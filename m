From: Jens Axboe <axboe@kernel.dk>
Subject: Re: requeue failure with blk-mq-sched
Date: Thu, 19 Jan 2017 06:35:24 -0800
Message-ID: <c445d760-824a-9756-9b9d-09040fe84d92@kernel.dk>
References: <fb509d83-c895-ba78-e181-145c77542eac@suse.de>
 <8b7436c0-91c4-0b70-071c-364abe1f24f5@kernel.dk>
 <9b90e296-7e39-34a5-c18e-df27a5674417@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33067 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753038AbdASOf1 (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Thu, 19 Jan 2017 09:35:27 -0500
Received: by mail-pf0-f175.google.com with SMTP id y143so14074245pfb.0
        for <Linux-scsi@vger.kernel.org>; Thu, 19 Jan 2017 06:35:26 -0800 (PST)
In-Reply-To: <9b90e296-7e39-34a5-c18e-df27a5674417@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 01/19/2017 06:24 AM, Hannes Reinecke wrote:
> On 01/19/2017 03:09 PM, Jens Axboe wrote:
>> On 01/19/2017 04:27 AM, Hannes Reinecke wrote:
>>> Hi Jens,
>>>
>>> upon further testing with your blk-mq-sched branch I hit a queue stall
>>> during requeing:
>>>
>>> [  202.340959] sd 3:0:4:1: tag#473 Send: scmd 0xffff880422e7a440
>>> [  202.340962] sd 3:0:4:1: tag#473 CDB: Test Unit Ready 00 00 00 00 00 00
>>> [  202.341161] sd 3:0:4:1: tag#473 Done: ADD_TO_MLQUEUE Result:
>>> hostbyte=DID_OK driverbyte=DRIVER_OK
>>> [  202.341164] sd 3:0:4:1: tag#473 CDB: Test Unit Ready 00 00 00 00 00 00
>>> [  202.341167] sd 3:0:4:1: tag#473 Sense Key : Unit Attention [current]
>>> [  202.341171] sd 3:0:4:1: tag#473 Add. Sense: Power on, reset, or bus
>>> device reset occurred
>>> [  202.341173] sd 3:0:4:1: tag#473 scsi host busy 1 failed 0
>>> [  202.341176] sd 3:0:4:1: tag#473 Inserting command ffff880422e7a440
>>> into mlqueue
>>>
>>> ... and that is the last ever heard of that device.
>>> The 'device_busy' count remains at '1' and no further commands will be
>>> sent to the device.
>>
>> If device_busy is at 1, then it should have a command pending. Where did
>> you log this - it would be bandy if you attached whatever debug patch
>> you put in, so we can see where the printks are coming from. If we get a
>> BUSY with nothing pending, the driver should be ensuring that the queue
>> gets run again later through blk_mq_delay_queue(), for instance.
>>
>> When the device is stuck, does it restart if you send it IO?
>>
> Meanwhile I've found it.
> 
> Problem is that scsi_queue_rq() will not stop the queue when hitting a
> busy condition before sending commands down to the driver, but still
> calls blk_mq_delay_queue():
> 
> 	switch (ret) {
> 	case BLK_MQ_RQ_QUEUE_BUSY:
> 		if (atomic_read(&sdev->device_busy) == 0 &&
> 		    !scsi_device_blocked(sdev))
> 			blk_mq_delay_queue(hctx, SCSI_QUEUE_DELAY);
> 		break;
> 
> As the queue isn't stopped blk_mq_delay_queue() won't do anything,
> so queue_rq() will never be called.
> I've send a patch to linux-scsi.
> 
> BTW: Is it a hard requirement that the queue has to be stopped when
> returning BLK_MQ_RQ_QUEUE_BUSY?

No, but currently it is apparently a hard requirement that the queue be
stopped when you call delay. Which does make sense, since there's little
point in doing the delay if the queue is run anyway.

> The comments indicate as such, but none of the drivers do so...
> Also, blk_mq_delay_queue() is a bit odd, in that it'll only start
> stopped hardware queues. I would at least document that the queue has to
> be stopped when calling that.
> Better still, can't we have blk_mq_delay_queue start the queues
> unconditionally?

I think so, it doesn't make sense to have blk_mq_delay_queue() NOT stop
the queue, yet its own work handler requires it to be set to actually
run.


diff --git a/block/blk-mq.c b/block/blk-mq.c
index fa1f8619bfe7..739a29208a63 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1161,8 +1161,8 @@ static void blk_mq_delay_work_fn(struct work_struct *work)
 
 	hctx = container_of(work, struct blk_mq_hw_ctx, delay_work.work);
 
-	if (test_and_clear_bit(BLK_MQ_S_STOPPED, &hctx->state))
-		__blk_mq_run_hw_queue(hctx);
+	clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+	__blk_mq_run_hw_queue(hctx);
 }
 
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs)

-- 
Jens Axboe

