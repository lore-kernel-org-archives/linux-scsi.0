From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] dm: Avoid use-after-free of a mapped device
Date: Mon, 25 Feb 2013 16:09:52 +0100
Message-ID: <512B7EC0.8090400@acm.org>
References: <51274C2F.6070500@acm.org> <51274CC3.9070204@acm.org> <512B339A.7010606@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:53242 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757958Ab3BYPJ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Feb 2013 10:09:56 -0500
In-Reply-To: <512B339A.7010606@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>

On 02/25/13 10:49, Jun'ichi Nomura wrote:
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 314a0e2..51fefb5 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1973,15 +1973,27 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
>  {
>  	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
>
> -	if (md->io_pool && (md->tio_pool || dm_table_get_type(t) == DM_TYPE_BIO_BASED) && md->bs) {
> -		/*
> -		 * The md already has necessary mempools. Reload just the
> -		 * bioset because front_pad may have changed because
> -		 * a different table was loaded.
> -		 */
> -		bioset_free(md->bs);
> -		md->bs = p->bs;
> -		p->bs = NULL;
> +	if (md->io_pool && md->bs) {
> +		/* The md already has necessary mempools. */
> +		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
> +			/*
> +			 * Reload bioset because front_pad may have changed
> +			 * because a different table was loaded.
> +			 */
> +			bioset_free(md->bs);
> +			md->bs = p->bs;
> +			p->bs = NULL;
> +		} else if (dm_table_get_type(t) == DM_TYPE_REQUEST_BASED) {
> +			BUG_ON(!md->tio_pool);
> +			/*
> +			 * No need to reload in case of request-based dm
> +			 * because of fixed size front_pad.
> +			 * Note for future: if you are to reload bioset,
> +			 * prep-ed requests in queue may have reference
> +			 * to bio from the old bioset.
> +			 * So you must walk through the queue to unprep.
> +			 */
> +		}
>  		goto out;
>  	}

Without your patch my test failed after two or three iterations. With 
your patch my test is still running after 53 iterations. So if you want 
you can add Tested-by: Bart Van Assche <bvanassche@acm.org>.

Your e-mail and the above patch are also interesting because these 
explain why reverting to the v3.7 of drivers/md made my test succeed.

Note: even if this patch gets accepted I think it's still useful to 
modify blk_run_queue() such that it converts recursion into iteration.

Bart.


