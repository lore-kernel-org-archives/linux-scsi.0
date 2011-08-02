From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/3] [SCSI] sd: remove dead code
Date: Tue, 02 Aug 2011 11:29:31 -0500
Message-ID: <1312302571.11352.10.camel@mulgrave>
References: <1312257053-2522-1-git-send-email-namhyung@gmail.com>
	 <1312257053-2522-2-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34329 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754557Ab1HBQ3q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2011 12:29:46 -0400
In-Reply-To: <1312257053-2522-2-git-send-email-namhyung@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2011-08-02 at 12:50 +0900, Namhyung Kim wrote:
> As rq_data_dir() only checks a single bit (REQ_WRITE), the result
> can not be anything but READ or WRITE. Thus last ELSE clause is
> not needed at all.

This isn't really dead code, it's future proofing.  Block can handle
bidirectional commands.  It's true that currently the rq_data_dir()
macro is wrong for them.  However, if anyone decided to fix it, we'd
need the check.

James


> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/scsi/sd.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 463a324835f4..fbb522add124 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -760,12 +760,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>  		    sd_dif_prepare(rq, block, sdp->sector_size) == -EIO)
>  			goto out;
>  
> -	} else if (rq_data_dir(rq) == READ) {
> +	} else { /* READ */
>  		SCpnt->cmnd[0] = READ_6;
>  		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
> -	} else {
> -		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
> -		goto out;
>  	}
>  
>  	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,


