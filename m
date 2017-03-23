From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 06/23] dm-kcopyd: switch to use REQ_OP_WRITE_ZEROES
Date: Thu, 23 Mar 2017 10:55:22 -0400
Message-ID: <20170323145522.GB17127@redhat.com>
References: <20170323143341.31549-1-hch@lst.de>
 <20170323143341.31549-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170323143341.31549-7-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 23 2017 at 10:33am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> It seems like the code currently passes whatever it was using for writes
> to WRITE SAME.  Just switch it to WRITE ZEROES, although that doesn't
> need any payload.
> 
> Untested, and confused by the code, maybe someone who understands it
> better than me can help..
> 
> Not-yet-signed-off-by: Christoph Hellwig <hch@lst.de>

See commit 70d6c400a ("dm kcopyd: add WRITE SAME support to dm_kcopyd_zero")
drivers/md/dm-io.c:do_region() adjusts the WRITE SAME payload to be a
single page.

So you'd want to tweak dm-io.c accordingly for WRITE ZEROES (presummably
no payload?)

Mike

> ---
>  drivers/md/dm-kcopyd.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
> index 9e9d04cb7d51..f85846741d50 100644
> --- a/drivers/md/dm-kcopyd.c
> +++ b/drivers/md/dm-kcopyd.c
> @@ -733,11 +733,11 @@ int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
>  		job->pages = &zero_page_list;
>  
>  		/*
> -		 * Use WRITE SAME to optimize zeroing if all dests support it.
> +		 * Use WRITE ZEROES to optimize zeroing if all dests support it.
>  		 */
> -		job->rw = REQ_OP_WRITE_SAME;
> +		job->rw = REQ_OP_WRITE_ZEROES;
>  		for (i = 0; i < job->num_dests; i++)
> -			if (!bdev_write_same(job->dests[i].bdev)) {
> +			if (!bdev_write_zeroes_sectors(job->dests[i].bdev)) {
>  				job->rw = WRITE;
>  				break;
>  			}
> -- 
> 2.11.0
> 
