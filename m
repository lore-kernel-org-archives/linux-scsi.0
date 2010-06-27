From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Sun, 27 Jun 2010 10:29:36 -0500
Message-ID: <1277652576.4366.19.camel@mulgrave.site>
References: <20100622180029.GA15950@redhat.com>
	 <1277582211-10725-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277582211-10725-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

linux-scsi cc added, since it's a SCSI patch.

On Sat, 2010-06-26 at 15:56 -0400, Mike Snitzer wrote:
> Fix leaks introduced via "block: don't allocate a payload for discard
> request" commit a1d949f5f44.
> 
> sd_done() is not called for REQ_TYPE_BLOCK_PC commands so cleanup
> discard request's payload directly in scsi_finish_command().
> 
> Also cleanup page allocated for discard payload in
> scsi_setup_discard_cmnd's scsi_setup_blk_pc_cmnd error path.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-core.c       |   23 +++++++++++++++++++++++
>  drivers/scsi/scsi.c    |    8 ++++++++
>  drivers/scsi/sd.c      |   18 ++++++++----------
>  include/linux/blkdev.h |    1 +
>  4 files changed, 40 insertions(+), 10 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 98b4cee..07925aa 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1167,6 +1167,29 @@ void blk_add_request_payload(struct request *rq, struct page *page,
>  }
>  EXPORT_SYMBOL_GPL(blk_add_request_payload);
>  
> +/**
> + * blk_clear_request_payload - clear a request's payload
> + * @rq: request to update
> + *
> + * The driver needs to take care of freeing the payload itself.
> + */
> +void blk_clear_request_payload(struct request *rq)
> +{
> +	struct bio *bio = rq->bio;
> +
> +	rq->__data_len = rq->resid_len = 0;
> +	rq->nr_phys_segments = 0;
> +	rq->buffer = NULL;
> +
> +	bio->bi_size = 0;
> +	bio->bi_vcnt = 0;
> +	bio->bi_phys_segments = 0;
> +
> +	bio->bi_io_vec->bv_page = NULL;
> +	bio->bi_io_vec->bv_len = 0;
> +}
> +EXPORT_SYMBOL_GPL(blk_clear_request_payload);
> +
>  void init_request_from_bio(struct request *req, struct bio *bio)
>  {
>  	req->cpu = bio->bi_comp_cpu;
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ad0ed21..69c7ea4 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -851,6 +851,14 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
>  		 */
>  		if (good_bytes == old_good_bytes)
>  			good_bytes -= scsi_get_resid(cmd);
> +	} else if (cmd->request->cmd_flags & REQ_DISCARD) {
> +		/*
> +		 * If this is a discard request that originated from the kernel
> +		 * we need to free our payload here.  Note that we need to check
> +		 * the request flag as the normal payload rules apply for
> +		 * pass-through UNMAP / WRITE SAME requests.
> +		 */
> +		__free_page(bio_page(cmd->request->bio));

This is another layering violation:  the page is allocated in the Upper
layer and freed in the mid-layer.

I really hate these growing contortions for discard.  They're a clear
signal that we haven't implemented it right.

So let's first work out how it should be done.  I really like Tomo's
idea of doing discard through the normal REQ_TYPE_FS route, which means
we can control the setup in prep and the tear down in done, all confined
to the ULD.

Where I think I'm at is partially what Christoph says:  The command
transformation belongs in the ULD so that's where the allocation and
deallocation should be, and partly what Tomo says in that we should
eliminate the special case paths.

The payload vs actual request size should be a red herring if we've got
everything correct:  only the ULD cares about the request parameters.
Once we've got everything set up, the mid layer and LLD should only care
about the parameters in the command, so we can confine the size changing
part to the ULD doing the discard.

Could someone take a stab at this and see if it works without layering
violations or any other problematic signals?

Thanks,

James
