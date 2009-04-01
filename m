From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 14/17] scsi: replace custom rq mapping with blk_rq_map_kern_sgl()
Date: Wed, 01 Apr 2009 20:00:44 +0300
Message-ID: <49D39DBC.3000206@panasas.com>
References: <1238593472-30360-1-git-send-email-tj@kernel.org> <1238593472-30360-15-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:22665 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755981AbZDARCs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2009 13:02:48 -0400
In-Reply-To: <1238593472-30360-15-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On 04/01/2009 04:44 PM, Tejun Heo wrote:
> Impact: hack removal
> 
> SCSI needs to map sgl into rq for kernel PC requests; however, block
> API didn't have such feature so it used its own rq mapping function
> which hooked into block/bio internals and is generally considered an
> ugly hack.  The private function may also produce requests which are
> bigger than queue per-rq limits.
> 
> Block blk_rq_map_kern_sgl().  Kill the private implementation and use
> it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

James, TOMO

what happened to Tomo's patches that removes all this after fixing up
all users (sg.c)?

I thought that was agreed and done? What is left to do for that to go
in.

Thanks Boaz

> ---
>  drivers/scsi/scsi_lib.c |  108 +----------------------------------------------
>  1 files changed, 1 insertions(+), 107 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 3196c83..3fa5589 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -296,112 +296,6 @@ static void scsi_end_async(struct request *req, int uptodate)
>  	__blk_put_request(req->q, req);
>  }
>  
> -static int scsi_merge_bio(struct request *rq, struct bio *bio)
> -{
> -	struct request_queue *q = rq->q;
> -
> -	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
> -	if (rq_data_dir(rq) == WRITE)
> -		bio->bi_rw |= (1 << BIO_RW);
> -	blk_queue_bounce(q, &bio);
> -
> -	return blk_rq_append_bio(q, rq, bio);
> -}
> -
> -static void scsi_bi_endio(struct bio *bio, int error)
> -{
> -	bio_put(bio);
> -}
> -
> -/**
> - * scsi_req_map_sg - map a scatterlist into a request
> - * @rq:		request to fill
> - * @sgl:	scatterlist
> - * @nsegs:	number of elements
> - * @bufflen:	len of buffer
> - * @gfp:	memory allocation flags
> - *
> - * scsi_req_map_sg maps a scatterlist into a request so that the
> - * request can be sent to the block layer. We do not trust the scatterlist
> - * sent to use, as some ULDs use that struct to only organize the pages.
> - */
> -static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
> -			   int nsegs, unsigned bufflen, gfp_t gfp)
> -{
> -	struct request_queue *q = rq->q;
> -	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
> -	unsigned int data_len = bufflen, len, bytes, off;
> -	struct scatterlist *sg;
> -	struct page *page;
> -	struct bio *bio = NULL;
> -	int i, err, nr_vecs = 0;
> -
> -	for_each_sg(sgl, sg, nsegs, i) {
> -		page = sg_page(sg);
> -		off = sg->offset;
> -		len = sg->length;
> -
> -		while (len > 0 && data_len > 0) {
> -			/*
> -			 * sg sends a scatterlist that is larger than
> -			 * the data_len it wants transferred for certain
> -			 * IO sizes
> -			 */
> -			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
> -			bytes = min(bytes, data_len);
> -
> -			if (!bio) {
> -				nr_vecs = min_t(int, BIO_GUARANTEED_PAGES,
> -						nr_pages);
> -				nr_pages -= nr_vecs;
> -
> -				bio = bio_alloc(gfp, nr_vecs);
> -				if (!bio) {
> -					err = -ENOMEM;
> -					goto free_bios;
> -				}
> -				bio->bi_end_io = scsi_bi_endio;
> -			}
> -
> -			if (bio_add_pc_page(q, bio, page, bytes, off) !=
> -			    bytes) {
> -				bio_put(bio);
> -				err = -EINVAL;
> -				goto free_bios;
> -			}
> -
> -			if (bio->bi_vcnt >= nr_vecs) {
> -				err = scsi_merge_bio(rq, bio);
> -				if (err) {
> -					bio_endio(bio, 0);
> -					goto free_bios;
> -				}
> -				bio = NULL;
> -			}
> -
> -			page++;
> -			len -= bytes;
> -			data_len -=bytes;
> -			off = 0;
> -		}
> -	}
> -
> -	rq->buffer = rq->data = NULL;
> -	rq->data_len = bufflen;
> -	return 0;
> -
> -free_bios:
> -	while ((bio = rq->bio) != NULL) {
> -		rq->bio = bio->bi_next;
> -		/*
> -		 * call endio instead of bio_put incase it was bounced
> -		 */
> -		bio_endio(bio, 0);
> -	}
> -
> -	return err;
> -}
> -
>  /**
>   * scsi_execute_async - insert request
>   * @sdev:	scsi device
> @@ -438,7 +332,7 @@ int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
>  	req->cmd_flags |= REQ_QUIET;
>  
>  	if (use_sg)
> -		err = scsi_req_map_sg(req, buffer, use_sg, bufflen, gfp);
> +		err = blk_rq_map_kern_sg(req->q, req, buffer, use_sg, gfp);
>  	else if (bufflen)
>  		err = blk_rq_map_kern(req->q, req, buffer, bufflen, gfp);
>  

