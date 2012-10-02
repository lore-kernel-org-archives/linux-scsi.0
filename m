From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 3/3] Make blk_cleanup_queue() wait until request_fn finished
Date: Tue, 02 Oct 2012 08:37:43 +0200
Message-ID: <506A8BB7.6040007@acm.org>
References: <50648014.7080308@acm.org> <50648130.4060902@acm.org> <CAA9_cmcJC+xFZigKWBjXPvKY39diN0iTMTWXMSep7++YRt1Dfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:36649 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab2JBGhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 02:37:48 -0400
In-Reply-To: <CAA9_cmcJC+xFZigKWBjXPvKY39diN0iTMTWXMSep7++YRt1Dfw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

On 10/01/12 19:41, Dan Williams wrote:
> On Thu, Sep 27, 2012 at 9:39 AM, Bart Van Assche <bvanassche@acm.org> wrote:
 >> [ ... ]
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 593fc71..03571a3 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1517,10 +1517,6 @@ static void scsi_request_fn(struct request_queue *q)
>>          struct scsi_cmnd *cmd;
>>          struct request *req;
>>
>> -       if(!get_device(&sdev->sdev_gendev))
>> -               /* We must be tearing the block queue down already */
>> -               return;
>> -
>>          /*
>>           * To start with, we keep looping until the queue is empty, or until
>>           * the host is no longer able to accept any more requests.
>> @@ -1629,11 +1625,7 @@ out_delay:
>>          if (sdev->device_busy == 0)
>>                  blk_delay_queue(q, SCSI_QUEUE_DELAY);
>>   out:
>> -       /* must be careful here...if we trigger the ->remove() function
>> -        * we cannot be holding the q lock */
>> -       spin_unlock_irq(q->queue_lock);
>> -       put_device(&sdev->sdev_gendev);
>> -       spin_lock_irq(q->queue_lock);
>> +       ;
>
> Any reason to keep this "out:" label now that it has no effect?

Some people prefer a single-exit style for kernel code since that style 
makes it easy to add cleanup code for resources allocated inside the 
function itself. I don't have a strong opinion about this though.

Note: after I posted this patch series I noticed that patch 2/3 leaves a 
(small) race window. I'm currently testing this follow-up patch:

diff --git a/block/blk-core.c b/block/blk-core.c
index f0efe32..3991f8e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -425,6 +425,9 @@ void blk_drain_queue(struct request_queue *q, bool 
drain_all)
                         }
                 }

+               if (!drain && blk_queue_dying(q))
+                       queue_flag_set(QUEUE_FLAG_DEAD, q);
+
                 spin_unlock_irq(q->queue_lock);

                 if (!drain)
@@ -525,10 +528,6 @@ void blk_cleanup_queue(struct request_queue *q)
         /* drain all requests queued before DEAD marking */
         blk_drain_queue(q, true);

-       spin_lock_irq(lock);
-       queue_flag_set(QUEUE_FLAG_DEAD, q);
-       spin_unlock_irq(lock);
-
         /* @q won't process any more request, flush async actions */
         del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
         blk_sync_queue(q);
