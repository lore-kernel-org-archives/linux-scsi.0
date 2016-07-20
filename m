From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mq and end_clone_request()
Date: Wed, 20 Jul 2016 14:33:21 -0400
Message-ID: <20160720183321.GA20223@redhat.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
 <20160720140815.GA19045@redhat.com>
 <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbcGTSdX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2016 14:33:23 -0400
Content-Disposition: inline
In-Reply-To: <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Jul 20 2016 at  1:37pm -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> On 07/20/2016 07:27 AM, Mike Snitzer wrote:
> >On Wed, Jul 20 2016 at 10:08am -0400,
> >Mike Snitzer <snitzer@redhat.com> wrote:
> >[ ... ]
> >diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> >index 7a96618..347ff25 100644
> >--- a/drivers/md/dm-rq.c
> >+++ b/drivers/md/dm-rq.c
> >@@ -414,7 +414,7 @@ static void dm_complete_request(struct request *rq, int error)
> > 	if (!rq->q->mq_ops)
> > 		blk_complete_request(rq);
> > 	else
> >-		blk_mq_complete_request(rq, error);
> >+		blk_mq_complete_request(rq, 0);
> > }
> >
> > /*
> 
> Hello Mike,
> 
> Thanks for the patch. But unfortunately even with this patch applied
> I see fio reporting I/O errors when run on top of dm-mq after a
> (simulated) cable pull. I think these errors occur because
> dm_softirq_done() fails requests if clone == NULL and tio->error !=
> NULL. Adding WARN_ON_ONCE(error && !tio->clone) in
> dm_complete_request() produced the following call stack:
> 
> Workqueue: kblockd blk_mq_run_work_fn
> Call Trace:
>  [<ffffffff8132aa27>] dump_stack+0x68/0xa1
>  [<ffffffff81061ed6>] __warn+0xc6/0xe0
>  [<ffffffff81061fa8>] warn_slowpath_null+0x18/0x20
>  [<ffffffffa0253fda>] dm_complete_request+0x8a/0xb0 [dm_mod]
>  [<ffffffffa0255200>] map_request+0x70/0x2e0 [dm_mod]
>  [<ffffffffa025771d>] dm_mq_queue_rq+0x7d/0x120 [dm_mod]
>  [<ffffffff8131195a>] __blk_mq_run_hw_queue+0x1da/0x350
>  [<ffffffff813120a0>] blk_mq_run_work_fn+0x10/0x20
>  [<ffffffff8107f279>] process_one_work+0x1f9/0x6a0
>  [<ffffffff8107f769>] worker_thread+0x49/0x490
>  [<ffffffff81085f7a>] kthread+0xea/0x100
>  [<ffffffff8162faff>] ret_from_fork+0x1f/0x40
> 
> Please let me know if you need more information.

Cable pull testing isn't new.  I'd have thought it covered (albeit
simulated) via mptest.  Does mptest pass for you?
https://github.com/snitm/mptest

Last I knew your tests were all passing with dm-mq.  Would love to
understand how/when they have regressed.

If clone is NULL then the request wasn't actually issued to (or even
allocated from the tag space of) the underlying blk-mq request_queue
(via clone_and_map_rq's call to __multipath_map).

The original request could've been previously cloned, failed due to
cable pull, it began retry via requeue, but on retry
blk_mq_alloc_request() could've failed in __multipath_map() -- (maybe
now the request_queue was "dying"?).  Or __multipath_map() failed for
some other reason.

Would be interesting to know the error returned from map_request()'s
ti->type->clone_and_map_rq().  Really should just be DM_MAPIO_REQUEUE.
But the stack you've provided shows map_request calling
dm_complete_request(), which implies dm_kill_unmapped_request() is being
called due to ti->type->clone_and_map_rq() returning < 0.

Could be that __multipath_map() is returning an error even before it
would've otherwise called blk_mq_alloc_request().

You said you are using queue_if_no_path?  Would be interesting to see
where __multipth_map is returning with an error.

Could be that __multipath_map() should respond differently if
blk_mq_alloc_request() fails and the queue is dying -- at a minimum the
path should be failed.  But before we explore that we need to understand
why the clone_and_map_rq() is returning < 0.
