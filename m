From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: Prevent busy looping
Date: Thu, 17 Apr 2008 10:50:20 +0200
Message-ID: <87ve2gc1bn.fsf@denkblock.local>
References: <20080416151305.8788.63912.stgit@denkblock.local>
	<20080416163152.GK12774@kernel.dk> <87r6d5l9pb.fsf@denkblock.local>
	<20080417071335.GR12774@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:60188 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYDQIvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Apr 2008 04:51:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--=-=-=

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Apr 17 2008, Elias Oltmanns wrote:
>> Jens Axboe <jens.axboe@oracle.com> wrote:
>> > On Wed, Apr 16 2008, Elias Oltmanns wrote:
>> >> blk_run_queue() as well as blk_start_queue() plug the device on reentry
>> >> and schedule blk_unplug_work() right afterwards. However,
>> >> blk_plug_device() takes care of that already and makes sure that there is
>> >> a short delay before blk_unplug_work() is scheduled. This is important
>> >> to prevent busy looping and possibly system lockups as observed here:
>> >> <http://permalink.gmane.org/gmane.linux.ide/28351>.
>> >
>> > If you call blk_start_queue() and blk_run_queue(), you better mean it.
>> > There should be no delay. The only reason it does blk_plug_device() is
>> > so that the work queue function will actually do some work.
>> 
>> Well, I'm mainly concerned with blk_run_queue(). In a comment it says
>> that it should recurse only once so as not to overrun the stack. On my
>> machine, however, immediate rescheduling may have exactly as disastrous
>> consequences as an overrunning stack would have since the system locks
>> up completely.
>> 
>> Just to get this straight: Are low level drivers allowed to rely on
>> blk_run_queue() that there will be no loops or do they have to make sure
>> that this function is not called from the request_fn() of the same
>> queue?
>
> It's not really designed for being called recursively. Which isn't the
> problem imo, the problem is SCSI apparently being dumb and calling
> blk_run_queue() all the time. blk_run_queue() must run the queue NOW. If
> SCSI wants something like 'run the queue in a bit', it should use
> blk_plug_device() instead.

James would probably argue that this is alright as long as
max_device_blocked and max_host_blocked are bigger than one.

>
>> > In the newer kernels we just do:
>> >
>> >         set_bit(QUEUE_FLAG_PLUGGED, &q->queue_flags);
>> >         kblockd_schedule_work(q, &q->unplug_work);
>> >
>> > instead, which is much better.
>> 
>> Only as long as it doesn't get called from the request_fn() of the same
>> queue. Otherwise, there may be no chance for other threads to clear the
>> condition that caused blk_run_queue() to be called in the first place.
>
> Broken usage.

Right. Tejun, would it be possible to apply the patch below (2.6.25) or
do you see any alternative?

Regards,

Elias


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=adjust-blocked-counters.patch

---

 drivers/ata/libata-scsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1579539..ce865e9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -831,7 +831,7 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 	 * prevent SCSI midlayer from automatically deferring
 	 * requests.
 	 */
-	sdev->max_device_blocked = 1;
+	sdev->max_device_blocked = 2;
 }
 
 /**
@@ -3206,7 +3206,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		 * Set host_blocked to 1 to prevent SCSI midlayer from
 		 * automatically deferring requests.
 		 */
-		shost->max_host_blocked = 1;
+		shost->max_host_blocked = 2;
 
 		rc = scsi_add_host(ap->scsi_host, ap->host->dev);
 		if (rc)

--=-=-=--
