From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: explain the hidden scsi_wait_scan Kconfig
 variable
Date: Thu, 18 Jun 2009 15:21:26 +0000
Message-ID: <1245338486.7586.13.camel@mulgrave.site>
References: <4A384FE4.9090703@gmail.com>
	 <20090617021254.GQ19977@parisc-linux.org>
	 <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45420 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907AbZFRPV1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 11:21:27 -0400
In-Reply-To: <tkrat.ad6f8fb712020451@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Changli Gao <xiaosuo@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, 2009-06-17 at 12:07 +0200, Stefan Richter wrote:
> People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
> item.  These patches aren't accepted upstream, so let's stop the ongoing
> irritation of people due to this obscure and strange installed module
> and its Kconfig option.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/scsi/Kconfig |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> Index: b/drivers/scsi/Kconfig
> ===================================================================
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -259,10 +259,25 @@ config SCSI_SCAN_ASYNC
>  	  or async on the kernel's command line.
>  
>  config SCSI_WAIT_SCAN
> -	tristate
> +	tristate  # No prompt here, this is a hidden option.

Adding comments explaining this is good, I think.

>  	default m
>  	depends on SCSI
>  	depends on MODULES
> +	help
> +	  Wait until all the async scans are complete.  The idea is to use
> +	  it in initrd/ initramfs scripts.  You modprobe it after all the
> +	  modprobes of the root SCSI drivers and it will wait until they
> +	  have all finished scanning their buses before allowing the boot
> +	  to proceed.
> +
> +	  Of course this does not work if targets boot independently of and
> +	  in parallel with the initiator, and/ or with transports with non-
> +	  deterministic target discovery schemes, and/ or if a transport
> +	  driver does not support scsi_wait_scan.
> +
> +	  Still, this option is not exposed as a prompt because little is
> +	  to be gained by disabling it, whereas people who accidentally
> +	  switch it off may wonder why their mkinitrd gets into trouble.

But not a help text that can never be shown.  Turn this into a comment
and I'll apply the patch.

The reason is the fact that this could be construed as a detectable bug
(option with help that can never be displayed) and someone with too much
time on their hands someday might make a static checker for it.

James


