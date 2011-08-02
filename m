From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [SCSI] sd: consolidate sector size alignment check
 in sd_pref_fn
Date: Tue, 02 Aug 2011 11:29:10 -0500
Message-ID: <1312302550.11352.9.camel@mulgrave>
References: <1312257053-2522-1-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34320 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab1HBQ3N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2011 12:29:13 -0400
In-Reply-To: <1312257053-2522-1-git-send-email-namhyung@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2011-08-02 at 12:50 +0900, Namhyung Kim wrote:
> Generalize common code to reduce code duplication.

This code isn't equivalent because it won't fail sector sizes > 4096
which we can't support.

Plus I really don't see much point doing this: ilog2 is a far less
efficient operation on several platforms and this is the hot path.

James

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/scsi/sd.c |   32 ++++++++------------------------
>  1 files changed, 8 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 953773cb26d9..463a324835f4 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -735,36 +735,20 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>  	 * and not force the scsi disk driver to use bounce buffers
>  	 * for this.
>  	 */
> -	if (sdp->sector_size == 1024) {
> -		if ((block & 1) || (blk_rq_sectors(rq) & 1)) {
> -			scmd_printk(KERN_ERR, SCpnt,
> -				    "Bad block number requested\n");
> -			goto out;
> -		} else {
> -			block = block >> 1;
> -			this_count = this_count >> 1;
> -		}
> -	}
> -	if (sdp->sector_size == 2048) {
> -		if ((block & 3) || (blk_rq_sectors(rq) & 3)) {
> -			scmd_printk(KERN_ERR, SCpnt,
> -				    "Bad block number requested\n");
> -			goto out;
> -		} else {
> -			block = block >> 2;
> -			this_count = this_count >> 2;
> -		}
> -	}
> -	if (sdp->sector_size == 4096) {
> -		if ((block & 7) || (blk_rq_sectors(rq) & 7)) {
> +	if (sdp->sector_size > 512) {
> +		int shift = ilog2(sdp->sector_size) - 9;
> +
> +		if (!IS_ALIGNED(block, 1 << shift) ||
> +		    !IS_ALIGNED(blk_rq_sectors(rq), 1 << shift)) {
>  			scmd_printk(KERN_ERR, SCpnt,
>  				    "Bad block number requested\n");
>  			goto out;
>  		} else {
> -			block = block >> 3;
> -			this_count = this_count >> 3;
> +			block = block >> shift;
> +			this_count = this_count >> shift;
>  		}
>  	}
> +
>  	if (rq_data_dir(rq) == WRITE) {
>  		if (!sdp->writeable) {
>  			goto out;


