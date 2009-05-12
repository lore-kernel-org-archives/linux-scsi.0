From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH block#for-2.6.31] scsi: fix resid_len mis-conversion in
	scsi_end_request()
Date: Tue, 12 May 2009 08:49:46 +0200
Message-ID: <20090512064945.GC5904@kernel.dk>
References: <4A08DBBA.1000208@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:44832 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbZELGtp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 02:49:45 -0400
Content-Disposition: inline
In-Reply-To: <4A08DBBA.1000208@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Tue, May 12 2009, Tejun Heo wrote:
> Commit c3a4d78c580de4edc9ef0f7c59812fb02ceb037f introduced
> rq->data_len and converted residual count users to it.  While
> converting, it mistakenly converted scsi_end_request() to finish
> requests with residual count when it wants to do is fully complete the
> request.  Fix it by using blk_end_request_all() instead.
> 
> This bug was spotted by Boaz Harrosh.

Added, thanks.

> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Spotted-by: Boaz Harrosh <bharrosh@panasas.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/scsi_lib.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a54bec9..e410d66 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -546,14 +546,9 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
>  	 * to queue the remainder of them.
>  	 */
>  	if (blk_end_request(req, error, bytes)) {
> -		int leftover = blk_rq_bytes(req);
> -
> -		if (blk_pc_request(req))
> -			leftover = req->resid_len;
> -
>  		/* kill remainder if no retrys */
>  		if (error && scsi_noretry_cmd(cmd))
> -			blk_end_request(req, error, leftover);
> +			blk_end_request_all(req, error);
>  		else {
>  			if (requeue) {
>  				/*
> 

-- 
Jens Axboe

