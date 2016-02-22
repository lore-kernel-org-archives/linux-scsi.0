From: Mike Snitzer <snitzer@redhat.com>
Subject: why is blk-mq requeue foricbly kicking stopped queues? [was: Re:
 dm-multipath test scripts]
Date: Mon, 22 Feb 2016 10:09:01 -0500
Message-ID: <20160222150901.GA5043@redhat.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com>
 <56C662F1.8070407@ce.jp.nec.com>
 <56C6D45A.6060407@ce.jp.nec.com>
 <20160219194216.GB21133@redhat.com>
 <20160220061247.GA23333@redhat.com>
 <56CADA20.7050209@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbcBVPJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 10:09:03 -0500
Content-Disposition: inline
In-Reply-To: <56CADA20.7050209@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, axboe@kernel.dk
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org

On Mon, Feb 22 2016 at  4:51am -0500,
Junichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> On 02/20/16 15:12, Mike Snitzer wrote:
> > On Fri, Feb 19 2016 at  2:42pm -0500, Mike Snitzer <snitzer@redhat.com> wrote:
> >> Have you been running with blk-mq?
> >> Either by setting CONFIG_DM_MQ_DEFAULT or:
> >> echo Y > /sys/module/dm_mod/parameters/use_blk_mq
> >>
> >> I'm seeing test_02_sdev_delete fail with blk-mq enabled.
> > 
> > I only see failure if I stack dm-mq ontop of old non-mq scsi devices with:
> > 
> > echo N > /sys/module/scsi_mod/parameters/use_blk_mq
> > echo Y > /sys/module/dm_mod/parameters/use_blk_mq
> 
> Ah, I didn't test that combination. I can see the failure, too.
> 
> > But this makes me think the novelty of having dm-mq support stacking on
> > non-blk-mq devices was misplaced.  It is a senseless config.  I'll
> > probably remove support for such stacking soon (next week). 
> 
> Looking at the failure, I suspect it could be a common issue of dm-mq
> regardless of underlying device type.

In practice I'm not seeing any issues with dm-mq on scsi-mq.

> When requeueing, following calls happen in dm-mq:
>   dm_requeue_original_request() {
>     ..
>     blk_mq_requeue_request(rq);
>     blk_mq_kick_requeue_list(rq->q);
> 
> then from block workqueue:
>   blk_mq_requeue_work() {
>     ..
>     blk_mq_start_hw_queue(q);
> 
> and blk_mq_start_hw_queue() re-starts the queue even if DM has
> stopped it for suspending. As a result, dm-mq ends up repeating
> submit-error-requeue forever and suspend never completes. Or,
> suspend somehow proceeds to clear DMF_NOFLUSH_SUSPENDING and
> I/O error may directly be returned to submitter.

I should note that I applied this patch for 4.6:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.6&id=7db905b3d4294e5db4c2938fb7d0e5ba4bd798d6

(but it was purely a fallout of code-review, and looking at the nvme's
use of blk_mq_requeue_request, I did't consider it to be a critical fix
or anything)

> Attached patch fixes the problem for DM. But given the code comment,
> there should be call sites which depend on 'start-if-stopped' behavior
> of blk_mq_requeue_work and we may need other solution.

Nice catch, it certainly does seem like the blk-mq requeue code is
undo-ing steps DM took to protect dm-mpath during suspend.  It likely
doesn't bite dm-mq on scsi-mq because in general blk-mq takes the
rq->q->queue_lock much less frequently.  But when stacking blk-mq on
.request_fn queues it causes live-lock you detailed above.

I'm not sure what the right fix is, but it would seem we need
something.  I cannot speak to why blk_mq_start_hw_queues() was used to
begin with (or why it is important for blk-mq to forcibly kicked stopped
queues on requeue).  Jens?

I see commit 8b95741569ea ("blk-mq: use blk_mq_start_hw_queues() when
running requeue work") but I'm still missing why the upper-layer driver
of the blk-mq queue (dm-mq in this case) isn't free to keep the queue
stopped.  This is pretty important for DM's suspend functionality.

> -- 
> Jun'ichi Nomura, NEC Corporation
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 56c0a72..bbfe936 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -481,11 +481,7 @@ static void blk_mq_requeue_work(struct work_struct *work)
>  		blk_mq_insert_request(rq, false, false, false);
>  	}
>  
> -	/*
> -	 * Use the start variant of queue running here, so that running
> -	 * the requeue work will kick stopped queues.
> -	 */
> -	blk_mq_start_hw_queues(q);
> +	blk_mq_run_hw_queues(q, false);
>  }
>  
>  void blk_mq_add_to_requeue_list(struct request *rq, bool at_head)
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
