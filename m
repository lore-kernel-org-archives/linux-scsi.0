From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 0/9] New EH command timeout handler
Date: Fri, 12 Jul 2013 12:27:30 +0200
Message-ID: <51DFDA12.4080905@suse.de>
References: <1372688671-85639-1-git-send-email-hare@suse.de> <51DF82B9.8030406@cn.fujitsu.com> <51DF9DB0.7080502@suse.de> <51DFD3D9.4080306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080907060104010301040607"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244Ab3GLK1c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 06:27:32 -0400
In-Reply-To: <51DFD3D9.4080306@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>

This is a multi-part message in MIME format.
--------------080907060104010301040607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

On 07/12/2013 12:00 PM, Ren Mingxin wrote:
> Hi, Hannes:
> 
> On 07/12/2013 02:09 PM, Hannes Reinecke wrote:
>> On 07/12/2013 06:14 AM, Ren Mingxin wrote:
>>> On 07/01/2013 10:24 PM, Hannes Reinecke wrote:
>>>> With the original SCSI EH I got:
>>>> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
>>>> 4096+0 records in
>>>> 4096+0 records out
>>>> 16777216 bytes (17 MB) copied, 142.652 s, 118 kB/s
>>>>
>>>> real    2m22.657s
>>>> user    0m0.013s
>>>> sys    0m0.145s
>>>>
>>>> With this patchset I got:
>>>> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
>>>> 4096+0 records in
>>>> 4096+0 records out
>>>> 16777216 bytes (17 MB) copied, 52.1579 s, 322 kB/s
>>>>
>>>> real    0m52.163s
>>>> user    0m0.012s
>>>> sys    0m0.145s
>>>>
>>>> Test was to disable RSCN on the target port, disable the
>>>> target port, and then start the 'dd' command as indicated.
>>>
>>> Do you mean disabling RSCN/port is enough? I'm afraid I couldn't
>>> reproduce the problem by your steps. Both with and without your
>>> patchset are the same 'dd' result: 27s. Please let me know where I
>>> neglected or mistook:
>>>
>>> 1) I made a dm-multipath target 'dm-0' whose grouping policy was
>>>     failover;
>>> 2) Disable RSCN/port via brocade fc switch:
>>>     SW300:root>  portcfg rscnsupr 15 --enable; portDisable 15
>>> 3) Start the 'dd' command:
>>>     # time dd if=/dev/zero of=/dev/dm-0 bs=4k count=4k oflag=direct
>>>     dd: writing `/dev/sde': Input/output error
>>>     1+0 records in
>>>     0+0 records out
>>>     0 bytes (0 B) copied, 27.8588 s, 0.0 kB/s
>>>
>>>     real    0m27.860s
>>>     user    0m0.001s
>>>     sys     0m0.000s
>>
>> You are aware that you have to disable RSCNs on the _target_ port,
>> right?
>> Disabling RSCNs on the _initiator_ ports is a well-tested case, and
>> the one which actually makes sense (and is even implemented in
>> QLogic switches).
>> Disabling RSCNs for the _target_ port, OTOH, has a very questionable
>> nature (hence QLogic switches don't even allow you to do this).
> 
> You're right. By disabling RSCNs on target port, I've reproduced this
> problem. Thank you so much. But I've encountered the bug I said
> before. I'll test again with your new patchset once you send.
> 

Could you check with the attached patch? That should convert it to
delayed_work and avoid this issue.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------080907060104010301040607
Content-Type: text/x-patch;
 name="scsi-use-delayed_work-for-cancel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scsi-use-delayed_work-for-cancel.patch"

>From 2d0851bea02e3d15bf403e6800cc7164f2e211f2 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Fri, 12 Jul 2013 12:06:19 +0200
Subject: [PATCH] scsi: use delayed_work to trigger aborts

Command aborts are invoked from an interrupt, so we cannot use
cancel_work_sync() when an outstanding abort needs to be cancelled.
So convert the mechanism to delayed_work, which can be cancelled
even from an interrupt context.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a62ae84..13a3418 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -297,7 +297,7 @@ struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, gfp_t gfp_mask)
 
 		cmd->device = dev;
 		INIT_LIST_HEAD(&cmd->list);
-		INIT_WORK(&cmd->abort_work, scmd_eh_abort_handler);
+		INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 		spin_lock_irqsave(&dev->list_lock, flags);
 		list_add_tail(&cmd->list, &dev->cmd_list);
 		spin_unlock_irqrestore(&dev->list_lock, flags);
@@ -354,6 +354,8 @@ void scsi_put_command(struct scsi_cmnd *cmd)
 	list_del_init(&cmd->list);
 	spin_unlock_irqrestore(&cmd->device->list_lock, flags);
 
+	cancel_delayed_work_sync(&cmd->abort_work);
+
 	__scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_put_command);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 28c272f..cd443b2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -187,7 +187,7 @@ void
 scmd_eh_abort_handler(struct work_struct *work)
 {
 	struct scsi_cmnd *scmd =
-		container_of(work, struct scsi_cmnd, abort_work);
+		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
 	unsigned long flags;
 	int rtn;
@@ -254,7 +254,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "scmd %p abort timeout\n", scmd));
-		cancel_work_sync(&scmd->abort_work);
+		cancel_delayed_work(&scmd->abort_work);
 		return BLK_EH_NOT_HANDLED;
 	}
 
@@ -279,7 +279,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
 	SCSI_LOG_ERROR_RECOVERY(3,
 		scmd_printk(KERN_INFO, scmd,
 			    "scmd %p abort scheduled\n", scmd));
-	schedule_work(&scmd->abort_work);
+	schedule_delayed_work(&scmd->abort_work, HZ / 100);
 	return BLK_EH_SCHEDULED;
 }
 EXPORT_SYMBOL_GPL(scsi_abort_command);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2f062e..e3137e3 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -55,7 +55,7 @@ struct scsi_cmnd {
 	struct scsi_device *device;
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 	struct list_head eh_entry; /* entry for the host eh_cmd_q */
-	struct work_struct abort_work;
+	struct delayed_work abort_work;
 	int eh_eflags;		/* Used by error handlr */
 
 	/*

--------------080907060104010301040607--
