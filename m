From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/15] block/bsg: move queue creation into
        bsg_setup_queue
Date: Thu, 12 Jan 2017 08:57:54 +0100
Message-ID: <20170112075754.GB7567@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de> <1484060780-15592-15-git-send-email-hch@lst.de> <20170111084218.GB6286@linux-x5ow.site> <20170111084512.GA6937@lst.de> <20170111220122.GA19051@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170111220122.GA19051@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2017 at 05:01:22PM -0500, Mike Snitzer wrote:
> But I've seen you reference the need to stop multipath from allocating
> its own requests.  Are you referring to old request_fn request-based
> multipath's clone_old_rq:alloc_old_clone_request?

Yes, that one is the issue.  It allocates a struct request "blind",
that is without known what queue it goes to.  With this queue (or blk-mq
for that matter) we need to know the queue, because the request structures
might have additional data behind it and require additional initialization
for drivers that require per-request data.  We make use of the per-request
data for SCSI passthrough in this patch.

> Or how blk-mq request-based multipath gets a request from the blk-mq tag
> space (via blk_mq_alloc_request)?

That's fine because it works on the queue of the device that I/O is
submitted to.
