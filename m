From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sg: add SG_FLAG_Q_AT_TAIL flag
Date: Wed, 4 Jun 2014 01:58:58 -0700
Message-ID: <20140604085858.GA8461@infradead.org>
References: <538E7838.5000809@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaFDI66 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2014 04:58:58 -0400
Content-Disposition: inline
In-Reply-To: <538E7838.5000809@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@parallels.com>, openosd@gmail.com

On Tue, Jun 03, 2014 at 09:36:56PM -0400, Douglas Gilbert wrote:
> When the SG_IO ioctl was copied into the block layer and
> later into the bsg driver, subtle differences emerged.
> 
> One difference is the way injected commands are queued through
> the block layer (i.e. this is not SCSI device queueing nor SATA
> NCQ). Summarizing:
>   - SG_IO in the block layer: blk_exec*(at_head=false)
>   - sg SG_IO: at_head=true
>   - bsg SG_IO: at_head=true
> 
> Some time ago Boaz Harrosh introduced a sg v4 flag called
> BSG_FLAG_Q_AT_TAIL to override the bsg driver default.
> This patch does the equivalent for the sg driver.
> 
> ChangeLog:
> 	Introduce SG_FLAG_Q_AT_TAIL flag to cause commands
> 	to be injected into the block layer with
> 	at_head=false.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 177f755..1b7d4f6 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -740,7 +740,7 @@ static int
>  sg_common_write(Sg_fd * sfp, Sg_request * srp,
>  		unsigned char *cmnd, int timeout, int blocking)
>  {
> -	int k, data_dir;
> +	int k, data_dir, at_head;
>  	Sg_device *sdp = sfp->parentdp;
>  	sg_io_hdr_t *hp = &srp->header;
>  
> @@ -784,11 +784,12 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
>  		break;
>  	}
>  	hp->duration = jiffies_to_msecs(jiffies);
> +	at_head = !(hp->interface_id && (SG_FLAG_Q_AT_TAIL & hp->flags));

It seems like all other occurances of ->interface_id compare to either
'\0' or 'S', so this looks odd.  Also I think this would really benefit
from beeing untangled into and if/else as it took me literally two
minutes to parse..

