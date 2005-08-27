From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/16]  qla2xxx: Correct ISP24xx soft-reset handling.
Date: Fri, 26 Aug 2005 21:26:21 -0500
Message-ID: <1125109581.5079.160.camel@mulgrave>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
	 <20050827020820.27275.23899.sendpatchset@plap.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:28651 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030274AbVH0C0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:26:35 -0400
In-Reply-To: <20050827020820.27275.23899.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-08-26 at 19:08 -0700, Andrew Vasquez wrote:
>  		WRT_REG_DWORD(&reg->ctrl_status,
>  		    CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
> -		RD_REG_DWORD(&reg->ctrl_status);
> +		/*
> +		 * It is necessary to delay here since the card doesn't respond
> +		 * to PCI reads during a reset. On some architectures this will
> +		 * result in an MCA.
> +		*/
> +		udelay(100);

Removing the read introduces a potential write posting bug, doesn't?
And again:


> @@ -589,10 +589,14 @@ qla24xx_reset_risc(scsi_qla_host_t *ha)
>  
>         WRT_REG_DWORD(&reg->ctrl_status,
>             CSRX_ISP_SOFT_RESET|CSRX_DMA_SHUTDOWN|MWB_4096_BYTES);
> -       RD_REG_DWORD(&reg->ctrl_status);

James


