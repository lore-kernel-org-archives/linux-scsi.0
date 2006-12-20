From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 5/6] bsg: replace SG v3 with SG v4
Date: Wed, 20 Dec 2006 11:15:18 +0100
Message-ID: <20061220101518.GM5010@kernel.dk>
References: <20061220144311D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:5654 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbWLTKNc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Dec 2006 05:13:32 -0500
Content-Disposition: inline
In-Reply-To: <20061220144311D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Wed, Dec 20 2006, FUJITA Tomonori wrote:
> This patch replaces SG v3 in bsg with SG v4 (except for SG_IO).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  block/bsg.c |  198 ++++++++++++++++++++++++++++++++++++-----------------------
>  1 files changed, 121 insertions(+), 77 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 53a09a5..6d139d2 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -103,8 +103,8 @@ struct bsg_command {
>  	struct request *rq;
>  	struct bio *bio;
>  	int err;
> -	struct sg_io_hdr hdr;
> -	struct sg_io_hdr __user *uhdr;
> +	struct sg_io_v4 hdr;
> +	struct sg_io_v4 __user *uhdr;
>  	char sense[SCSI_SENSE_BUFFERSIZE];
>  };
>  
> @@ -235,57 +235,82 @@ static struct bsg_command *bsg_get_comma
>  	return bc;
>  }
>  
> +static int blk_fill_sgv4_hdr_rq(request_queue_t *q, struct request *rq,
> +				struct sg_io_v4 *hdr, int has_write_perm)
> +{
> +	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
> +
> +	if (copy_from_user(rq->cmd, (void *)(unsigned long)hdr->request,
> +			   hdr->request_len))
> +		return -EFAULT;

Strange casting, that should be cleaned up. Also reminds me that the
sg_io_v4 header needs proper __user annotation.

-- 
Jens Axboe

