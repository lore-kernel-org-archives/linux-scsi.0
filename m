From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] fix fusion breakage with multiple PCI domains
Date: Fri, 25 Mar 2005 09:25:06 -0700
Message-ID: <1111767906.6448.5.camel@eeyore>
References: <1111089617.11380.40.camel@eeyore>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from atlrel7.hp.com ([156.153.255.213]:33410 "EHLO atlrel7.hp.com")
	by vger.kernel.org with ESMTP id S261684AbVCYQZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Mar 2005 11:25:08 -0500
In-Reply-To: <1111089617.11380.40.camel@eeyore>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com
Cc: mpt_linux_developer@lsil.com, linux-scsi@vger.kernel.org, sjralston1@netscape.net

Any comments on the patch below?  Eric, sorry I didn't sent this
to you before -- maybe you'd consider the MAINTAINERS patch below
as well?

I also suggested pci_get_slot() as a possibility for rewriting
the function below (mpt_detect_bound_ports()).  But that's a
bit more than I want to do at the moment.  We need a fix for
RHEL4 and SLES9, and as a non-expert in mpt fusion, I'm more
comfortable advocating the simple change below.

On Thu, 2005-03-17 at 13:00 -0700, Bjorn Helgaas wrote:
> mpt_detect_bound_ports(): Don't assume that two devices with the same
>     dev->bus->number are on the same bus.  With multiple PCI domains,
>     many buses may have the same number.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
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

===== MAINTAINERS 1.291 vs edited =====
--- 1.291/MAINTAINERS	2005-03-13 16:29:59 -07:00
+++ edited/MAINTAINERS	2005-03-25 09:05:50 -07:00
@@ -1449,6 +1449,12 @@
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 
+LSILOGIC FC9XX/53C1030/53C1035 FUSION MPT DRIVER
+P:	Eric Moore
+M:	Eric.Moore@lsil.com
+L:	linux-scsi@vger.kernel.org
+S:	Maintained
+
 M68K ARCHITECTURE
 P:	Geert Uytterhoeven
 M:	geert@linux-m68k.org


