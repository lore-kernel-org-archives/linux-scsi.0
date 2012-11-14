From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] Try #2: Use SCSI read/write(16) with >2TB drives
Date: Wed, 14 Nov 2012 20:02:14 +0100
Message-ID: <20121114190214.GD6439@breakpoint.cc>
References: <1352872513-2424-1-git-send-email-hernejj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36743 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754842Ab2KNTCR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2012 14:02:17 -0500
Content-Disposition: inline
In-Reply-To: <1352872513-2424-1-git-send-email-hernejj@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jason J. Herne" <hernejj@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, pbonzini@redhat.com, JBottomley@parallels.com, stern@rowland.harvard.edu

On Wed, Nov 14, 2012 at 12:55:13AM -0500, Jason J. Herne wrote:
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -887,7 +887,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>  		SCpnt->cmnd[29] = (unsigned char) (this_count >> 16) & 0xff;
>  		SCpnt->cmnd[30] = (unsigned char) (this_count >> 8) & 0xff;
>  		SCpnt->cmnd[31] = (unsigned char) this_count & 0xff;
> -	} else if (block > 0xffffffff) {
> +	} else if (sdp->use_16_for_rw) {
>  		SCpnt->cmnd[0] += READ_16 - READ_6;
>  		SCpnt->cmnd[1] = protect | ((rq->cmd_flags & REQ_FUA) ? 0x8 : 0);
>  		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
> @@ -2054,6 +2054,9 @@ got_data:
>  		}
>  	}
>  
> +	/* Use read/write(16) for > 2TB disks */
> +	sdp->use_16_for_rw = (sdkp->capacity > 0xffffffff);

The comment is pointless if you assume the reading is able to read C. What
would help is a link either here or in patch's description to the mail thread
where it has been descovered that some >2TB devices don't recognize the small
command.

> +
>  	/* Rescale capacity to 512-byte units */
>  	if (sector_size == 4096)
>  		sdkp->capacity <<= 3;

Sebastian
