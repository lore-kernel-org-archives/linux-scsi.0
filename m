From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] change scsi_cmd_ioctl to take a gendisk instead of a queue
Date: Sun, 1 Feb 2004 13:49:16 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201134916.A18509@beaverton.ibm.com>
References: <20040201124803.A18050@beaverton.ibm.com> <20040201213334.A17988@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:6791 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265477AbUBAVuN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2004 16:50:13 -0500
Content-Disposition: inline
In-Reply-To: <20040201213334.A17988@infradead.org>; from hch@infradead.org on Sun, Feb 01, 2004 at 09:33:34PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

On Sun, Feb 01, 2004 at 09:33:34PM +0000, Christoph Hellwig wrote:
> On Sun, Feb 01, 2004 at 12:48:03PM -0800, Patrick Mansfield wrote:
> > Jens or others, any comments?
> > 
> > This patch against a recent bk 2.6 changes scsi_cmd_ioctl to take a
> > gendisk as an argument instead of a request_queue_t. This allows scsi char
> > devices to use the scsi_cmd_ioctl interface.
> 
> Heh, I had pretty much the same patch in 2.5.  I don't rember why
> I dropped it but you're looks at least as nice.

> > If the scsi upper level scsi_cmd_ioctl usage were consolidated in
> > scsi_prep_fn, we could pass a request_queue_t instead of a gendisk to
> > scsi_cmd_ioctl.
> 
> I don't parse that.  You mean taking REQ_PC handling from upper drivers
> to the scsi core?

Yes. That would also clean up the upper level driver code (for example,
sd.c's sd_init_command), but I have not tried this.

Basically for the REQ_BLOCK_PC, setup our own scsi_block_pc_intr in
scsi_lib.c, set up the scsi_cmnd, and set the scsi_cmnd done to
scsi_block_pc_intr. And maybe make still call scsi_init_io.

Then we don't need the:

	drv = *(struct scsi_driver **)req->rq_disk->private_data

And so, in theory ;-), we don't need rq_disk to be set. My reading of
current code shows none of the other scsi_cmd_ioctl users need rq_disk,
so we could then pass a q to scsi_cmd_ioctl. 

Then in the future we could use sg_io instead of the scsi_do_req,
scsi_wait_req, etc., and get rid of REQ_CMD in favor of REQ_BLOCK_PC.

> > +int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
> > +		 unsigned int offset)
> > +{
> > +	return __bio_add_page(bdev_get_queue(bio->bi_bdev), bio, page,
> > +			      len, offset);
> > +}
> 
> Maybe worth inlining in a header? 

Maybe, and then export __bio_add_page.

-- Patrick Mansfield
