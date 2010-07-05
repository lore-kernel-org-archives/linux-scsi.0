From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/3] scsi: add sd_unprep_fn to free discard page
Date: Mon, 05 Jul 2010 13:07:26 +0300
Message-ID: <4C31AEDE.7050008@panasas.com>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277981359-10717-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, snitzer@redhat.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/01/2010 01:49 PM, FUJITA Tomonori wrote:
> This fixes discard page leak by using q->unprep_rq_fn facility.
> 
> q->unprep_rq_fn is called when all the data buffer (req->bio and
> scsi_data_buffer) in the request is freed.
> 
> sd_unprep() uses rq->buffer to free discard page allocated in
> sd_prepare_discard().
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Sorry for thinking about this just now. It was on the tip of my
mind, but I was too busy with other things to notice.

There is a simple more STD way to solve all this without the need
for any new API.

*Use the bio destructor to also deallocate it's pages*

Now that is not such a novel idea, it's used all over the place.
Well it's the proper way to submit a bio and be notified on done.
Since there are no bio leaks, we know all error paths are just
as covered.

For this to work all these patches could be removed and the
blk_add_request_payload need to change to recieve a bio destructor
pointer.

If you ask me I hate what was done with discard at the block layer
since it's only in Jens tree for-next I think it is good time to change
it. What is this alloc the bio in one place and add it's pages in another
place. Rrrrr

to quote from the author himself:
<block-core.c>
/**
 * blk_add_request_payload - add a payload to a request
 <snip>
 *
 * Note that this is a quite horrible hack and nothing but handling of
 * discard requests should ever use it.
 */
void blk_add_request_payload(struct request *rq, struct page *page,
		unsigned int len)
</block-core.c>

The block-layer users think of a discard as zero-load, so should the
block-layer. The block driver like sd that needs to add a payload can
set in a bio just like any other place. when allocating the bio, set
it's destructor and be done with it. All allocations and cleanups are
done at one place, at same level.

As it stands now blk_add_request_payload will have to either chain the
bio destructors and/or if it knows where it's allocated then chain to
the proper bio_free, after calling the block-driver supplied callback.

BTW where is that zero-pages discard bio allocated. Why is it not allocated
inside blk_add_request_payload? What is the meaning of zero length bio?
I though everywhere we check for "if (req->bio)" not "if (bio_size(req_bio))"
isn't all this asking for trouble?

my $0.017
Boaz

> ---
>  drivers/scsi/sd.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 86da819..2d4e3a8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -425,6 +425,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
>  	sector_t sector = bio->bi_sector;
>  	unsigned int nr_sectors = bio_sectors(bio);
>  	unsigned int len;
> +	int ret;
>  	struct page *page;
>  
>  	if (sdkp->device->sector_size == 4096) {
> @@ -465,7 +466,15 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
>  	}
>  
>  	blk_add_request_payload(rq, page, len);
> -	return scsi_setup_blk_pc_cmnd(sdp, rq);
> +	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
> +	rq->buffer = page_address(page);
> +	return ret;
> +}
> +
> +static void sd_unprep_fn(struct request_queue *q, struct request *rq)
> +{
> +	if (rq->cmd_flags & REQ_DISCARD)
> +		__free_page(virt_to_page(rq->buffer));
>  }
>  
>  /**
> @@ -2242,6 +2251,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>  	sd_revalidate_disk(gd);
>  
>  	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
> +	blk_queue_unprep_rq(sdp->request_queue, sd_unprep_fn);
>  
>  	gd->driverfs_dev = &sdp->sdev_gendev;
>  	gd->flags = GENHD_FL_EXT_DEVT;
