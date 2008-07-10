From: Cal Peake <cp@absolutedigital.net>
Subject: Re: [PATCH] SCSI: erase invalid data returned by device
Date: Thu, 10 Jul 2008 19:15:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807101908390.1756@lancer.cnet.absolutedigital.net>
References: <Pine.LNX.4.44L0.0806241402020.2166-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from livid.absolutedigital.net ([66.92.46.173]:53339 "EHLO
	mx2.absolutedigital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbYGJXcG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:32:06 -0400
In-Reply-To: <Pine.LNX.4.44L0.0806241402020.2166-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Peter Teoh <htmldeveloper@gmail.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

Hi,

It looks like we're getting down to the last -rc; can this patch please 
make it into main-line before 2.6.26 goes final?

Thanks!


On Tue, 24 Jun 2008, Alan Stern wrote:

> This patch (as1108) fixes a problem that can occur with certain USB
> mass-storage devices: They return invalid data together with a residue
> indicating that the data should be ignored.  Rather than leave the
> invalid data in a transfer buffer, where it can get misinterpreted,
> the patch clears the invalid portion of the buffer.
> 
> This solves a problem (wrong write-protect setting detected) reported
> by Maciej Rutecki and Peter Teoh.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Tested-by: Peter Teoh <htmldeveloper@gmail.com>
> 
> ---
> 
> Index: usb-2.6/drivers/scsi/scsi_lib.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_lib.c
> +++ usb-2.6/drivers/scsi/scsi_lib.c
> @@ -207,6 +207,15 @@ int scsi_execute(struct scsi_device *sde
>  	 */
>  	blk_execute_rq(req->q, NULL, req, 1);
>  
> +	/*
> +	 * Some devices (USB mass-storage in particular) may transfer
> +	 * garbage data together with a residue indicating that the data
> +	 * is invalid.  Prevent the garbage from being misinterpreted
> +	 * and prevent security leaks by zeroing out the excess data.
> +	 */
> +	if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
> +		memset(buffer + (bufflen - req->data_len), 0, req->data_len);
> +
>  	ret = req->errors;
>   out:
>  	blk_put_request(req);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Cal Peake

