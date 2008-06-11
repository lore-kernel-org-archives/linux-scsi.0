From: Tejun Heo <htejun@gmail.com>
Subject: Re: Prevent busy looping
Date: Wed, 11 Jun 2008 16:11:09 +0900
Message-ID: <484F7A8D.1040809@gmail.com>
References: <20080416151305.8788.63912.stgit@denkblock.local>	<20080416163152.GK12774@kernel.dk> <87r6d5l9pb.fsf@denkblock.local>	<20080417071335.GR12774@kernel.dk> <87ve2gc1bn.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090700090705040508060704"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:52586 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbYFKHLQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2008 03:11:16 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2970910wfd.4
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2008 00:11:16 -0700 (PDT)
In-Reply-To: <87ve2gc1bn.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.orglinux

This is a multi-part message in MIME format.
--------------090700090705040508060704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Picking up a dropped ball.

Elias Oltmanns wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
>> On Thu, Apr 17 2008, Elias Oltmanns wrote:
>>> Jens Axboe <jens.axboe@oracle.com> wrote:
>>>> On Wed, Apr 16 2008, Elias Oltmanns wrote:
>>>>> blk_run_queue() as well as blk_start_queue() plug the device on reentry
>>>>> and schedule blk_unplug_work() right afterwards. However,
>>>>> blk_plug_device() takes care of that already and makes sure that there is
>>>>> a short delay before blk_unplug_work() is scheduled. This is important
>>>>> to prevent busy looping and possibly system lockups as observed here:
>>>>> <http://permalink.gmane.org/gmane.linux.ide/28351>.
>>>> If you call blk_start_queue() and blk_run_queue(), you better mean it.
>>>> There should be no delay. The only reason it does blk_plug_device() is
>>>> so that the work queue function will actually do some work.
>>> Well, I'm mainly concerned with blk_run_queue(). In a comment it says
>>> that it should recurse only once so as not to overrun the stack. On my
>>> machine, however, immediate rescheduling may have exactly as disastrous
>>> consequences as an overrunning stack would have since the system locks
>>> up completely.
>>>
>>> Just to get this straight: Are low level drivers allowed to rely on
>>> blk_run_queue() that there will be no loops or do they have to make sure
>>> that this function is not called from the request_fn() of the same
>>> queue?
>> It's not really designed for being called recursively. Which isn't the
>> problem imo, the problem is SCSI apparently being dumb and calling
>> blk_run_queue() all the time. blk_run_queue() must run the queue NOW. If
>> SCSI wants something like 'run the queue in a bit', it should use
>> blk_plug_device() instead.
> 
> James would probably argue that this is alright as long as
> max_device_blocked and max_host_blocked are bigger than one.
> 
>>>> In the newer kernels we just do:
>>>>
>>>>         set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
>>>>         kblockd_schedule_work(q, &q->unplug_work);
>>>>
>>>> instead, which is much better.
>>> Only as long as it doesn't get called from the request_fn() of the same
>>> queue. Otherwise, there may be no chance for other threads to clear the
>>> condition that caused blk_run_queue() to be called in the first place.
>> Broken usage.
> 
> Right. Tejun, would it be possible to apply the patch below (2.6.25) or
> do you see any alternative?

Okay, I (finally) looked into this.  The meaning of blocked counts is
that to wait (count - 1) * plug delay if the target (be it device or
host) is idle before retrying.  libata uses deferring to implement
command scheduling and as such, there shouldn't be any delay if the
target is not busy.

Elias's synthetic test case triggered infinite loop because it wasn't
a proper ->qc_defer().  ->qc_defer() should never defer commands when
the target is idle.

Attached is debug patch to monitor libata command deferring.  It will
whine if certain command is retried 10 times or more, or ->qc_defer()
is called in rapid succession.  I couldn't find anything wrong with
it.  When IDENTIFY is queued while NCQ commands are in flight, it
waited for several hundreds millisecs for NCQ commands to drain with
each ->qc_defer() calling spaced by several milliseconds as determined
by in-flight NCQ command completion.

So, blocked counts of 1 are just fine as long as ->qc_defer() doesn't
try to defer a command when the target is idle.  That said, there's no
harm in increasing the blocked count to two or even leaving it at the
default because those blocked counters are reset to 0 whenever a
command completes and by the same logic which makes blocked counts of
1 okay, it's guaranteed that every deferred command will have matching
command completions to clear its blocked counts.

As the current code has been working well for quite some time now, I'm
more inclined to leave it as it is.

Thanks.

-- 
tejun

--------------090700090705040508060704
Content-Type: text/x-patch;
 name="defer-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="defer-debug.patch"

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3ce4392..8eb050e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1612,6 +1612,11 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			goto defer;
 	}
 
+	if (cmd->ata_deferred_cnt >= 10)
+		ata_dev_printk(dev, KERN_INFO, "XXX: cmd %02x deferred %d times taking %u msecs\n",
+			       qc->tf.command, cmd->ata_deferred_cnt,
+			       jiffies_to_msecs(jiffies - cmd->ata_first_deferred));
+
 	/* select device, send command to hardware */
 	ata_qc_issue(qc);
 
@@ -1633,6 +1638,18 @@ err_mem:
 	return 0;
 
 defer:
+	if (!cmd->ata_deferred_cnt++) {
+		cmd->ata_first_deferred = cmd->ata_last_deferred = jiffies;
+	} else {
+		unsigned long now = jiffies;
+
+		if (jiffies_to_msecs(now - cmd->ata_last_deferred) < 3)
+			ata_dev_printk(dev, KERN_INFO, "XXX: cmd %02x deferred in %d msecs, cnt=%d\n",
+				       qc->tf.command,
+				       jiffies_to_msecs(now - cmd->ata_last_deferred),
+				       cmd->ata_deferred_cnt);
+		cmd->ata_last_deferred = now;
+	}
 	ata_qc_free(qc);
 	DPRINTK("EXIT - defer\n");
 	if (rc == ATA_DEFER_LINK)
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 110e776..aadee36 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -265,6 +265,7 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 		list_add_tail(&cmd->list, &dev->cmd_list);
 		spin_unlock_irqrestore(&dev->list_lock, flags);
 		cmd->jiffies_at_alloc = jiffies;
+		cmd->ata_deferred_cnt = 0;
 	} else
 		put_device(&dev->sdev_gendev);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3e46dfa..0000971 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -127,6 +127,10 @@ struct scsi_cmnd {
 	int result;		/* Status code from lower level driver */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
+
+	int ata_deferred_cnt;
+	unsigned long ata_first_deferred;
+	unsigned long ata_last_deferred;
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);

--------------090700090705040508060704--
