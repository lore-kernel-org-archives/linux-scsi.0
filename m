From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] osdblk: a Linux block device for OSD objects
Date: Fri, 3 Apr 2009 11:49:09 +0200
Message-ID: <20090403094909.GQ5178@kernel.dk>
References: <20090402015455.GA14087@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761831AbZDCJtd@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090402015455.GA14087@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 01 2009, Jeff Garzik wrote:
> 
> As I promised in older exofs threads, here is a client for libosd
> _other_ than exofs.  This block driver exports a single OSD object
> as a Linux block device.
> 
> See the comment block at the top of the driver for usage instructions.
> 
> 
> 
> +static void osdblk_end_request(struct osdblk_device *osdev,
> +			       struct osdblk_request *orq,
> +			       int error)
> +{
> +	struct request *rq = orq->rq;
> +	int rc;
> +
> +	/* complete request, at block layer */
> +	rc = __blk_end_request(rq, error, blk_rq_bytes(rq));
> +
> +	/* clear request slot for use */
> +	osdev->req[orq->tag].rq = NULL;
> +
> +	/* restart queue, if necessary */
> +	blk_start_queue(osdev->q);
> +}
> +
> +static void osdblk_osd_complete(struct osd_request *or, void *private)
> +{
> +	struct osdblk_request *orq = private;
> +	struct osd_sense_info osi;
> +	int ret = osd_req_decode_sense(or, &osi);
> +
> +	if (ret)
> +		ret = -EIO;
> +
> +	osd_end_request(or);
> +	osdblk_end_request(orq->osdev, orq, ret);
> +}
> +
> +static void osdblk_rq_fn(struct request_queue *q)
> +{
> +	struct osdblk_device *osdev = q->queuedata;
> +	struct request *rq;
> +	struct osdblk_request *orq;
> +	struct osd_request *or;
> +	struct bio *bio;
> +	int rq_idx, do_write;
> +
> +	while (1) {
> +		rq = elv_next_request(q);
> +		if (!rq)
> +			break;
> +
> +		do_write = (rq_data_dir(rq) == WRITE);
> +
> +		bio = bio_clone(rq->bio, GFP_NOIO);
> +		if (!bio)
> +			break;

This wont work, GFP_NOIO inside the queue lock. You are also only
cloning the front bio, what happens if you have > 1 bio on the request?
You seem to dequeue the request and complete all of it, regardless of
whether bio->bi_size == blk_rq_bytes(rq). I'm assuming you have to clone
because of how the osd_req_{read,write} works, so I'd suggest storing
the byte size in your osdblk_request and only completing that in
osdblk_end_request(). Then do a rq_for_each_bio() look in there, and
only dequeue if you manage to start an osd request for each of them,
THEN moving on to the next request.

-- 
Jens Axboe
