From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/6] bsg: fix kernel panic resulting from missing
 allocation of a reply-buffer
Date: Fri, 11 Aug 2017 15:49:29 +0200
Message-ID: <20170811134929.GA1249@bblock-ThinkPad-W530>
References: <cover.1502120928.git.bblock@linux.vnet.ibm.com>
 <9e67ce3fc2f3cd42e9e05b2753b00d6676f46ee1.1502120928.git.bblock@linux.vnet.ibm.com>
 <20170810093217.GL24539@lst.de>
 <20170810221038.GA918@bblock-ThinkPad-W530>
 <20170811083808.GA5497@lst.de>
 <20170811091415.GA8099@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170811091415.GA8099@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Steffen Maier <maier@linux.vnet.ibm.com>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 11, 2017 at 11:14:15AM +0200, Christoph Hellwig wrote:
> But patch 1 still creates an additional copy of the sense data for
> all bsg users.
>

Huh? What additional copy? There is one reply-buffer and that is copied
into the user-buffer should it contain valid data. Just like in your
patch, neither you, nor me touches any of the copy-code. There is also
no changes to how the driver get their data into that buffer, it will
still be copied in both cases.

> 
> Can you test the patch below which implements my suggestion?  Your
> other patches should still apply fine on top modulo minor context
> changes.

Only your patch on top of 4.13-rc4. din_xferp (D) is also empty, which is
not taken from the sense-buffer.

=============================================================================
BUG kmalloc-1024 (Not tainted): Invalid object pointer 0x000000004ad9e0f0
-----------------------------------------------------------------------------

Disabling lock debugging due to kernel taint
INFO: Slab 0x000003d1012b6600 objects=24 used=11 fp=0x000000004ad9da58 flags=0x3fffc0000008101
CPU: 2 PID: 20 Comm: ksoftirqd/2 Tainted: G    B           4.13.0-rc4-bsg-regression+ #2
Hardware name: IBM 2964 N96 702 (z/VM 6.4.0)
Call Trace:
([<0000000000117532>] show_stack+0x8a/0xe0)
 [<0000000000bcbaee>] dump_stack+0x96/0xd8 
 [<00000000003cd5fc>] slab_err+0xac/0xc0 
 [<00000000003d68e4>] free_debug_processing+0x554/0x570 
 [<00000000003d69ae>] __slab_free+0xae/0x618 
 [<00000000003d7dce>] kfree+0x44e/0x4a0 
 [<0000000000859b4e>] blk_done_softirq+0x146/0x160 
 [<0000000000bf4ec0>] __do_softirq+0x3d0/0x840 
 [<00000000001662a6>] run_ksoftirqd+0x3e/0xb8 
 [<00000000001957fc>] smpboot_thread_fn+0x2f4/0x318 
 [<000000000018f6f6>] kthread+0x166/0x178 
 [<0000000000bf3cf2>] kernel_thread_starter+0x6/0xc 
 [<0000000000bf3cec>] kernel_thread_starter+0x0/0xc 
INFO: lockdep is turned off.
FIX kmalloc-1024: Object at 0x000000004ad9e0f0 not freed
=============================================================================
BUG kmalloc-1024 (Tainted: G    B          ): Invalid object pointer 0x000000004ad9f630
-----------------------------------------------------------------------------

INFO: Slab 0x000003d1012b6600 objects=24 used=11 fp=0x000000004ad98558 flags=0x3fffc0000008101
CPU: 2 PID: 20 Comm: ksoftirqd/2 Tainted: G    B           4.13.0-rc4-bsg-regression+ #2
Hardware name: IBM 2964 N96 702 (z/VM 6.4.0)
Call Trace:
([<0000000000117532>] show_stack+0x8a/0xe0)
 [<0000000000bcbaee>] dump_stack+0x96/0xd8 
 [<00000000003cd5fc>] slab_err+0xac/0xc0 
 [<00000000003d68e4>] free_debug_processing+0x554/0x570 
 [<00000000003d69ae>] __slab_free+0xae/0x618 
 [<00000000003d7dce>] kfree+0x44e/0x4a0 
 [<0000000000859b4e>] blk_done_softirq+0x146/0x160 
 [<0000000000bf4ec0>] __do_softirq+0x3d0/0x840 
 [<00000000001662a6>] run_ksoftirqd+0x3e/0xb8 
 [<00000000001957fc>] smpboot_thread_fn+0x2f4/0x318 
 [<000000000018f6f6>] kthread+0x166/0x178 
 [<0000000000bf3cf2>] kernel_thread_starter+0x6/0xc 
 [<0000000000bf3cec>] kernel_thread_starter+0x0/0xc 
INFO: lockdep is turned off.
FIX kmalloc-1024: Object at 0x000000004ad9f630 not freed
=============================================================================
BUG kmalloc-1024 (Tainted: G    B          ): Invalid object pointer 0x000000004ad986a0
-----------------------------------------------------------------------------

INFO: Slab 0x000003d1012b6600 objects=24 used=13 fp=0x000000004ad9d508 flags=0x3fffc0000008101
CPU: 2 PID: 20 Comm: ksoftirqd/2 Tainted: G    B           4.13.0-rc4-bsg-regression+ #2
Hardware name: IBM 2964 N96 702 (z/VM 6.4.0)
Call Trace:
([<0000000000117532>] show_stack+0x8a/0xe0)
 [<0000000000bcbaee>] dump_stack+0x96/0xd8 
 [<00000000003cd5fc>] slab_err+0xac/0xc0 
 [<00000000003d68e4>] free_debug_processing+0x554/0x570 
 [<00000000003d69ae>] __slab_free+0xae/0x618 
 [<00000000003d7dce>] kfree+0x44e/0x4a0
 [<0000000000859b4e>] blk_done_softirq+0x146/0x160
 [<0000000000bf4ec0>] __do_softirq+0x3d0/0x840
 [<00000000001662a6>] run_ksoftirqd+0x3e/0xb8
 [<00000000001957fc>] smpboot_thread_fn+0x2f4/0x318
 [<000000000018f6f6>] kthread+0x166/0x178
 [<0000000000bf3cf2>] kernel_thread_starter+0x6/0xc
 [<0000000000bf3cec>] kernel_thread_starter+0x0/0xc
INFO: lockdep is turned off.
FIX kmalloc-1024: Object at 0x000000004ad986a0 not freed
=============================================================================
BUG kmalloc-1024 (Tainted: G    B          ): Invalid object pointer 0x000000004ad9d650
-----------------------------------------------------------------------------

INFO: Slab 0x000003d1012b6600 objects=24 used=15 fp=0x000000004ad9ea48 flags=0x3fffc0000008101
CPU: 2 PID: 20 Comm: ksoftirqd/2 Tainted: G    B           4.13.0-rc4-bsg-regression+ #2
Hardware name: IBM 2964 N96 702 (z/VM 6.4.0)
Call Trace:
([<0000000000117532>] show_stack+0x8a/0xe0)
 [<0000000000bcbaee>] dump_stack+0x96/0xd8
 [<00000000003cd5fc>] slab_err+0xac/0xc0
 [<00000000003d68e4>] free_debug_processing+0x554/0x570
 [<00000000003d69ae>] __slab_free+0xae/0x618
 [<00000000003d7dce>] kfree+0x44e/0x4a0
 [<0000000000859b4e>] blk_done_softirq+0x146/0x160
 [<0000000000bf4ec0>] __do_softirq+0x3d0/0x840
 [<00000000001662a6>] run_ksoftirqd+0x3e/0xb8
 [<00000000001957fc>] smpboot_thread_fn+0x2f4/0x318
 [<000000000018f6f6>] kthread+0x166/0x178
 [<0000000000bf3cf2>] kernel_thread_starter+0x6/0xc
 [<0000000000bf3cec>] kernel_thread_starter+0x0/0xc
INFO: lockdep is turned off.
FIX kmalloc-1024: Object at 0x000000004ad9d650 not freed
=============================================================================
BUG kmalloc-1024 (Tainted: G    B          ): Invalid object pointer 0x000000004ad9eb90
-----------------------------------------------------------------------------

INFO: Slab 0x000003d1012b6600 objects=24 used=17 fp=0x000000004ad99548 flags=0x3fffc0000008101
CPU: 2 PID: 20 Comm: ksoftirqd/2 Tainted: G    B           4.13.0-rc4-bsg-regression+ #2
Hardware name: IBM 2964 N96 702 (z/VM 6.4.0)
Call Trace:
([<0000000000117532>] show_stack+0x8a/0xe0)
 [<0000000000bcbaee>] dump_stack+0x96/0xd8
 [<00000000003cd5fc>] slab_err+0xac/0xc0
 [<00000000003d68e4>] free_debug_processing+0x554/0x570
 [<00000000003d69ae>] __slab_free+0xae/0x618
 [<00000000003d7dce>] kfree+0x44e/0x4a0
 [<0000000000859b4e>] blk_done_softirq+0x146/0x160
 [<0000000000bf4ec0>] __do_softirq+0x3d0/0x840
 [<00000000001662a6>] run_ksoftirqd+0x3e/0xb8
 [<00000000001957fc>] smpboot_thread_fn+0x2f4/0x318
 [<000000000018f6f6>] kthread+0x166/0x178
 [<0000000000bf3cf2>] kernel_thread_starter+0x6/0xc
 [<0000000000bf3cec>] kernel_thread_starter+0x0/0xc
INFO: lockdep is turned off.
FIX kmalloc-1024: Object at 0x000000004ad9eb90 not freed

> 
> ---
> From 4cd32ee48e334b62b55bff0d380833b978454040 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Fri, 11 Aug 2017 11:03:29 +0200
> Subject: bsg-lib: allocate sense data for each request
> 
> Since we split the scsi_request out of the request the driver is supposed
> to provide storage for the sense buffer.  The bsg-lib code failed to do so,
> though and will crash anytime it is used.
> 
> This patch moves bsg-lib to allocate and setup the bsg_job ahead of time,
> and allocate the sense data, which is used as reply buffer in bsg.
> 
> Reported-by: Steffen Maier <maier@linux.vnet.ibm.com>
> Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
> Fixes: 82ed4db499b8 ("block: split scsi_request out of struct request")
> Cc: <stable@vger.kernel.org> #4.11+
> ---
>  block/bsg-lib.c         | 53 +++++++++++++++++++++++++++----------------------
>  include/linux/blkdev.h  |  1 -
>  include/linux/bsg-lib.h |  2 ++
>  3 files changed, 31 insertions(+), 25 deletions(-)
> 
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index c4513b23f57a..215893dbd038 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -100,7 +100,7 @@ EXPORT_SYMBOL_GPL(bsg_job_done);
>   */
>  static void bsg_softirq_done(struct request *rq)
>  {
> -	struct bsg_job *job = rq->special;
> +	struct bsg_job *job = blk_mq_rq_to_pdu(rq);
> 
>  	bsg_job_put(job);
>  }
> @@ -129,26 +129,9 @@ static int bsg_map_buffer(struct bsg_buffer *buf, struct request *req)
>  static int bsg_create_job(struct device *dev, struct request *req)
>  {
>  	struct request *rsp = req->next_rq;
> -	struct request_queue *q = req->q;
> -	struct scsi_request *rq = scsi_req(req);
> -	struct bsg_job *job;
> +	struct bsg_job *job = blk_mq_rq_to_pdu(req);
>  	int ret;
> 
> -	BUG_ON(req->special);
> -
> -	job = kzalloc(sizeof(struct bsg_job) + q->bsg_job_size, GFP_KERNEL);
> -	if (!job)
> -		return -ENOMEM;
> -
> -	req->special = job;
> -	job->req = req;
> -	if (q->bsg_job_size)
> -		job->dd_data = (void *)&job[1];
> -	job->request = rq->cmd;
> -	job->request_len = rq->cmd_len;
> -	job->reply = rq->sense;
> -	job->reply_len = SCSI_SENSE_BUFFERSIZE;	/* Size of sense buffer
> -						 * allocated */
>  	if (req->bio) {
>  		ret = bsg_map_buffer(&job->request_payload, req);
>  		if (ret)
> @@ -187,7 +170,6 @@ static void bsg_request_fn(struct request_queue *q)
>  {
>  	struct device *dev = q->queuedata;
>  	struct request *req;
> -	struct bsg_job *job;
>  	int ret;
> 
>  	if (!get_device(dev))
> @@ -207,8 +189,7 @@ static void bsg_request_fn(struct request_queue *q)
>  			continue;
>  		}
> 
> -		job = req->special;
> -		ret = q->bsg_job_fn(job);
> +		ret = q->bsg_job_fn(blk_mq_rq_to_pdu(req));
>  		spin_lock_irq(q->queue_lock);
>  		if (ret)
>  			break;
> @@ -219,6 +200,29 @@ static void bsg_request_fn(struct request_queue *q)
>  	spin_lock_irq(q->queue_lock);
>  }
> 
> +static int bsg_init_rq(struct request_queue *q, struct request *req, gfp_t gfp)
> +{
> +	struct bsg_job *job = blk_mq_rq_to_pdu(req);
> +
> +	memset(job, 0, sizeof(*job));
> +	job->req = req;
> +	job->dd_data = job + 1;
> +	job->request = job->sreq.cmd;
> +	job->request_len = job->sreq.cmd_len;
> +	job->reply_len = SCSI_SENSE_BUFFERSIZE;
> +	job->reply = job->sreq.sense = kzalloc(job->reply_len, gfp);
> +	if (!job->reply)
> +		return -ENOMEM;
> +	return 0;
> +}

This will now create an additional and never used (sizeof(struct
bsg_job) + dd_job_size + SCSI_SENSE_BUFFERSIZE - sizeof(struct
scsi_request)) size buffer for each bidirectional BSG request (each FC
request for zFCP for example). I mentioned that in my reply.

I really don't see the point in this exercise. We know the old way
worked well for BSG, no driver has been changed in expectations to now
do DMA to the reply-buffer.. its a custom non-standardised kernel
struct.. there is no HW that would do this (and like I said, the reply
protocol Data is already DMA'ed directly into the user-provided
buffers, if the HW can). And more-over, like you said, later patches
make all allocations on-heap anyway.

If you really want, I can change the first patch to do more of what
Patch 4 does right now, so that there is no on-stack usage, even just
intermediate in a patch-series.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block

> +
> +static void bsg_exit_rq(struct request_queue *q, struct request *req)
> +{
> +	struct bsg_job *job = blk_mq_rq_to_pdu(req);
> +
> +	kfree(job->reply);
> +}
> +
>  /**
>   * bsg_setup_queue - Create and add the bsg hooks so we can receive requests
>   * @dev: device to attach bsg device to
> @@ -235,7 +239,9 @@ struct request_queue *bsg_setup_queue(struct device *dev, char *name,
>  	q = blk_alloc_queue(GFP_KERNEL);
>  	if (!q)
>  		return ERR_PTR(-ENOMEM);
> -	q->cmd_size = sizeof(struct scsi_request);
> +	q->cmd_size = sizeof(struct bsg_job) + dd_job_size;
> +	q->init_rq_fn = bsg_init_rq;
> +	q->exit_rq_fn = bsg_exit_rq;
>  	q->request_fn = bsg_request_fn;
> 
>  	ret = blk_init_allocated_queue(q);
> @@ -243,7 +249,6 @@ struct request_queue *bsg_setup_queue(struct device *dev, char *name,
>  		goto out_cleanup_queue;
> 
>  	q->queuedata = dev;
> -	q->bsg_job_size = dd_job_size;
>  	q->bsg_job_fn = job_fn;
>  	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
>  	queue_flag_set_unlocked(QUEUE_FLAG_SCSI_PASSTHROUGH, q);
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f45f157b2910..6ae9aa6f93f0 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -568,7 +568,6 @@ struct request_queue {
> 
>  #if defined(CONFIG_BLK_DEV_BSG)
>  	bsg_job_fn		*bsg_job_fn;
> -	int			bsg_job_size;
>  	struct bsg_class_device bsg_dev;
>  #endif
> 
> diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
> index e34dde2da0ef..637a20cfb237 100644
> --- a/include/linux/bsg-lib.h
> +++ b/include/linux/bsg-lib.h
> @@ -24,6 +24,7 @@
>  #define _BLK_BSG_
> 
>  #include <linux/blkdev.h>
> +#include <scsi/scsi_request.h>
> 
>  struct request;
>  struct device;
> @@ -37,6 +38,7 @@ struct bsg_buffer {
>  };
> 
>  struct bsg_job {
> +	struct scsi_request sreq;
>  	struct device *dev;
>  	struct request *req;
> 
> -- 
> 2.11.0
> 

-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
