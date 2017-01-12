From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH 15/15] block: split scsi_request out of struct request
Date: Wed, 11 Jan 2017 20:59:11 -0700
Message-ID: <20170112035911.GB27546@kernel.dk>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
 <1484060780-15592-16-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35614 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750779AbdALD7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 22:59:17 -0500
Content-Disposition: inline
In-Reply-To: <1484060780-15592-16-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Tue, Jan 10 2017, Christoph Hellwig wrote:
> And require all drivers that want to support BLOCK_PC to allocate it
> as the first thing of their private data.  To support this the legacy
> IDE and BSG code is switched to set cmd_size on their queues to let
> the block layer allocate the additional space.

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index be23859..499728d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -225,17 +225,7 @@ struct request {
>  	int tag;
>  	int errors;
>  
> -	/*
> -	 * when request is used as a packet command carrier
> -	 */
> -	unsigned char __cmd[BLK_MAX_CDB];
> -	unsigned char *cmd;
> -	unsigned short cmd_len;
> -
>  	unsigned int extra_len;	/* length of alignment and padding */
> -	unsigned int sense_len;
> -	unsigned int resid_len;	/* residual count */
> -	void *sense;

Oh yes, my mouth is watering. I've wanted to kill off ->cmd and friends
with fire for years.

On the block front, I think the solution is fine with mimicking the mq
solution of carrying an rq payload, and the implementation for the
legacy path looks fine.

-- 
Jens Axboe

