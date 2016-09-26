From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/9] Introduce blk_quiesce_queue() and blk_resume_queue()
Date: Mon, 26 Sep 2016 11:46:44 -0700
Message-ID: <9cffd6ee-2940-b2b7-cbfc-47dd6307593a@sandisk.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
 <20160926183308.GA13309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160926183308.GA13309-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 09/26/2016 11:33 AM, Mike Snitzer wrote:
> On Mon, Sep 26 2016 at  2:25pm -0400,
> Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>
>> Hello Jens,
>>
>> Multiple block drivers need the functionality to stop a request
>> queue and to wait until all ongoing request_fn() / queue_rq() calls
>> have finished without waiting until all outstanding requests have
>> finished. Hence this patch series that introduces the
>> blk_quiesce_queue() and blk_resume_queue() functions. The dm-mq, SRP
>> and nvme patches in this patch series are three examples of where
>> these functions are useful. These patches apply on top of the
>> September 21 version of your for-4.9/block branch. The individual
>> patches in this series are:
>>
>> 0001-blk-mq-Introduce-blk_mq_queue_stopped.patch
>> 0002-dm-Fix-a-race-condition-related-to-stopping-and-star.patch
>> 0003-RFC-nvme-Use-BLK_MQ_S_STOPPED-instead-of-QUEUE_FLAG_.patch
>> 0004-block-Move-blk_freeze_queue-and-blk_unfreeze_queue-c.patch
>> 0005-block-Extend-blk_freeze_queue_start-to-the-non-blk-m.patch
>> 0006-block-Rename-mq_freeze_wq-and-mq_freeze_depth.patch
>> 0007-blk-mq-Introduce-blk_quiesce_queue-and-blk_resume_qu.patch
>> 0008-SRP-transport-Port-srp_wait_for_queuecommand-to-scsi.patch
>> 0009-RFC-nvme-Fix-a-race-condition.patch
>
> Hi Bart,
>
> How much testing has this series seen?  Did you run it against the
> mptest testsuite? https://github.com/snitm/mptest
>
> I did notice patch 2 should come after patch 7 (not sure if other
> patches are out of order).

Hello Mike,

Regarding testing: I have primarily used my srp-test regression test 
suite to test this patch series because that test suite uncovered a 
dm-mq race that was not discovered by mptest. I'm currently running 
xfstests (to verify an ib_srp change that is not in this patch series) 
and will run mptest next.

You are right that patch 2 should come after patch 7. The order of the 
other patches in this series should be fine.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
