From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [SCSI] iscsi: return data transfer residual for data-out
 commands
Date: Wed, 07 Nov 2007 21:17:31 +0200
Message-ID: <47320F4B.2040503@panasas.com>
References: <4731FEA4.5040206@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa10.bezeqint.net ([192.115.104.24]:39215 "EHLO
	sa10.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794AbXKGTRg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 14:17:36 -0500
In-Reply-To: <4731FEA4.5040206@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, Mike Christie <michaelc@cs.wisc.edu>

On Wed, Nov 07 2007 at 20:06 +0200, Tony Battersby <tonyb@cybernetics.com> wrote:
> Currently, the iSCSI driver returns the data transfer residual for
> data-in commands (e.g. read) but not data-out commands (e.g. write).
> This patch makes it return the data transfer residual for both types of
> commands.
All types of commands, also good for BIDI ;)

> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> --- linux-2.6.24-rc2/drivers/scsi/libiscsi.c.orig	2007-11-07 12:52:20.000000000 -0500
> +++ linux-2.6.24-rc2/drivers/scsi/libiscsi.c	2007-11-07 12:52:27.000000000 -0500
> @@ -291,9 +291,6 @@ invalid_datalen:
>  			   min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
>  	}
>  
> -	if (sc->sc_data_direction == DMA_TO_DEVICE)
> -		goto out;
> -
>  	if (rhdr->flags & ISCSI_FLAG_CMD_UNDERFLOW) {
>  		int res_count = be32_to_cpu(rhdr->residual_count);
>  
> 
> 
Thanks, this looks right to me. (And good catch)
I have went through the code and it looks like the right thing to do.
"svn blame" annotates this code to the patch (r527) that libiscsi was 
cut out of iscsi_tcp so perhaps then it made sense, but does not anymore.
It is also needed for the bidi patches, as currently bidi commands
have a sc_data_direction == DMA_TO_DEVICE.

Pleas accept this patch
Boaz

