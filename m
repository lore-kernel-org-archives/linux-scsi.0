From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] fix fusion breakage with multiple PCI domains
Date: Fri, 18 Mar 2005 10:25:18 -0700
Message-ID: <1111166718.13286.23.camel@eeyore>
References: <1111089617.11380.40.camel@eeyore>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from atlrel7.hp.com ([156.153.255.213]:41385 "EHLO atlrel7.hp.com")
	by vger.kernel.org with ESMTP id S261997AbVCRRZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2005 12:25:26 -0500
In-Reply-To: <1111089617.11380.40.camel@eeyore>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sjralston1@netscape.net
Cc: mpt_linux_developer@lsil.com, linux-scsi@vger.kernel.org

On Thu, 2005-03-17 at 13:00 -0700, Bjorn Helgaas wrote:
> mpt_detect_bound_ports(): Don't assume that two devices with the same
>     dev->bus->number are on the same bus.  With multiple PCI domains,
>     many buses may have the same number.

Maybe mpt_detect_bound_ports() could be rewritten to use pci_get_slot()
instead?  tg3_find_5704_peer() looks like it's doing basically the
same thing; maybe you could copy it.

> ===== drivers/message/fusion/mptbase.c 1.40 vs edited =====
> --- 1.40/drivers/message/fusion/mptbase.c	2005-03-13 16:30:09 -07:00
> +++ edited/drivers/message/fusion/mptbase.c	2005-03-17 12:46:57 -07:00
> @@ -1834,14 +1834,14 @@
>  
>  	match_lo = pdev->devfn-1;
>  	match_hi = pdev->devfn+1;
> -	dprintk((MYIOC_s_INFO_FMT "PCI bus/devfn=%x/%x, searching for devfn match on %x or %x\n",
> -			ioc->name, pdev->bus->number, pdev->devfn, match_lo, match_hi));
> +	dprintk((MYIOC_s_INFO_FMT "PCI device %s devfn=%x/%x, searching for devfn match on %x or %x\n",
> +			ioc->name, pci_name(pdev), pdev->devfn, match_lo, match_hi));
>  
>  	list_for_each_entry(ioc_srch, &ioc_list, list) {
>  		struct pci_dev *_pcidev = ioc_srch->pcidev;
>  
>  		if ((_pcidev->device == pdev->device) &&
> -		    (_pcidev->bus->number == pdev->bus->number) &&
> +		    (_pcidev->bus == pdev->bus) &&
>  		    (_pcidev->devfn == match_lo || _pcidev->devfn == match_hi) ) {
>  			/* Paranoia checks */
>  			if (ioc->alt_ioc != NULL) {
> 

