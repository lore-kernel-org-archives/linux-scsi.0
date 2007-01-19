From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH] Fusion: Call pci_set_mwi()
Date: Fri, 19 Jan 2007 14:03:05 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D705378FD@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:51648 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964865AbXASVDN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jan 2007 16:03:13 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Friday, October 13, 2006 10:25 AM,Matthew Wilcox wrote:   

> 
> Hi Eric,
> 
> Even though the 1030 is a PCI-X device, it can still be 
> plugged into a PCI
> bus, and end up operating in PCI mode.  According to the 
> documentation,
> it will benefit from using MWI and MRM commands, but in order to do so
> under Linux, we need to call pci_set_mwi(), which is what 
> this patch does.
> Please apply.
> 
> P.S. The if condition is just to avoid the warning from __must_check.
> Most device drivers do need to check and adjust their 
> internal flags if
> it fails, but according to the 1030 manual, the chip automatically
> decides when to use MWI.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>
> 
> diff --git a/drivers/message/fusion/mptbase.c 
> b/drivers/message/fusion/mptbase.c
> index 29d0635..d301a67 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1153,6 +1153,9 @@ #endif
>  	if (pci_enable_device(pdev))
>  		return r;
>  
> +	if (pci_set_mwi(pdev))
> +		/* We don't have to do anything if it fails */;
> +
>  	dinitprintk((KERN_WARNING MYNAM ": mpt_adapter_install\n"));
>  
>  	if (!pci_set_dma_mask(pdev, DMA_64BIT_MASK)) {
> 
> 


I just responded to the HP thread, and I remember this patch.

I hadn't had a chance to check this up.  Pls let me know importance of
this,
and I will ask around the office wrt to this patch..  You don't think
this shouldn't break anything else? , such
as pci-express cards, cuase we have 1030 pcie, as well as FC and SAS
that
are express.  

Eric
