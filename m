From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/1] SCSI: lpfc, restore MSI-X/MSI support
Date: Sun, 17 Jan 2010 12:47:32 -0600
Message-ID: <1263754052.2802.2.camel@mulgrave.site>
References: <87r5pta66n.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481Ab0AQSrm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Jan 2010 13:47:42 -0500
In-Reply-To: <87r5pta66n.fsf@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: George Kadianakis <desnacked@gmail.com>
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com

On Thu, 2010-01-14 at 02:20 +0200, George Kadianakis wrote:
> From: George Kadianakis <desnacked {bomb} gmail {point} com>
> 
> A Gentoo bug report [1] showed that as of 2.6.31 lpfc only uses INTx interrupts.
> This patch restores lpfc's ability to support MSI-X/MSI interrupts that the 
> "Addition of SLI4 Interface - Base Support" patch [2] broke.
> It reestablishes MSI-X as the default interrupt method and in case MSI-X is not 
> supported lpfc_sli{4,}_enable_intr fallbacks to MSI and then to INTx.
> 
> [1]: http://bugs.gentoo.org/show_bug.cgi?id=296319
> [2]: commit da0436e915a5c17ee79e72c1bf978a4ebb1cbf4d

So now I have an ack for this, I need an applyable patch.

> Signed-off-by:  George Kadianakis <desnacked {cat} gmail {dog} com>

This needs to be a proper email

>  drivers/scsi/lpfc/lpfc_attr.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index e1a30a1..936ecaf 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -2890,12 +2890,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
>  /*
>  # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
>  # 				 support this feature
> -#       0  = MSI disabled (default)
> +#       0  = MSI disabled
>  #       1  = MSI enabled
> -#       2  = MSI-X enabled
> +#       2  = MSI-X enabled (default)
>  # Value range is [0,2]. Default value is 0.
>  */
> -LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
> +LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
>  					      "MSI-X (2), if possible");
>  
>  /*

And for some reason there are extra tabs in the above lines which cause
patch to reject.

James


