From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] scsi: sr.c use unaligned access helpers
Date: Tue, 7 Oct 2008 14:10:26 +0200
Message-ID: <20081007121025.GY19428@kernel.dk>
References: <1223081173.6778.4.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:58925 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbYJGMKz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2008 08:10:55 -0400
Content-Disposition: inline
In-Reply-To: <1223081173.6778.4.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Oct 03 2008, Harvey Harrison wrote:
> Preserve the cd->capacity indentation near the #if 0'd if() statement.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  drivers/scsi/sr.c |   26 ++++++++------------------
>  1 files changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 27f5bfd..f1b650e 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -45,6 +45,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/mutex.h>
>  #include <asm/uaccess.h>
> +#include <asm/unaligned.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_dbg.h>
> @@ -280,10 +281,7 @@ static int sr_done(struct scsi_cmnd *SCpnt)
>  		case ILLEGAL_REQUEST:
>  			if (!(SCpnt->sense_buffer[0] & 0x90))
>  				break;
> -			error_sector = (SCpnt->sense_buffer[3] << 24) |
> -				(SCpnt->sense_buffer[4] << 16) |
> -				(SCpnt->sense_buffer[5] << 8) |
> -				SCpnt->sense_buffer[6];
> +			error_sector = get_unaligned_be32(SCpnt->sense_buffer + 3);
>  			if (SCpnt->request->bio != NULL)
>  				block_sectors =
>  					bio_sectors(SCpnt->request->bio);
> @@ -445,13 +443,9 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
>  		SCpnt->sdb.length = this_count * s_size;
>  	}
>  
> -	SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
> -	SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
> -	SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;
> -	SCpnt->cmnd[5] = (unsigned char) block & 0xff;
> +	put_unaligned_be32(block, SCpnt->cmnd + 2);
>  	SCpnt->cmnd[6] = SCpnt->cmnd[9] = 0;
> -	SCpnt->cmnd[7] = (unsigned char) (this_count >> 8) & 0xff;
> -	SCpnt->cmnd[8] = (unsigned char) this_count & 0xff;
> +	put_unaligned_be16(this_count, SCpnt->cmnd + 7);
>  
>  	/*
>  	 * We shouldn't disconnect in the middle of a sector, so with a dumb

Lets not please, it reduces readability a lot when you are used to SCSI
cdb filling.


-- 
Jens Axboe

