From: Dave Hansen <haveblue@us.ibm.com>
Subject: Re: aic7xxx broken in 2.6.18-rc3-mm2
Date: Mon, 14 Aug 2006 12:56:43 -0700
Message-ID: <1155585403.12700.10.camel@localhost.localdomain>
References: <1155334308.7574.50.camel@localhost.localdomain>
	 <200608141858.37465.daniel.ritz-ml@swissonline.ch>
	 <1155575804.7574.166.camel@localhost.localdomain>
	 <200608142021.18551.daniel.ritz-ml@swissonline.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34229 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751768AbWHNT5G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Aug 2006 15:57:06 -0400
In-Reply-To: <200608142021.18551.daniel.ritz-ml@swissonline.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: Greg KH <greg@kroah.com>, Marcus Better <marcus@better.se>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux scsi <linux-scsi@vger.kernel.org>, ak@suse.de

On Mon, 2006-08-14 at 20:21 +0200, Daniel Ritz wrote:
> errm...sorry, i didn't mean that patch but the alternative i sent later. attached.
> it should use direct access while not breaking legacy PCI probing. in theory..
> 
> thanks,
> -daniel
> 
> diff --git a/arch/i386/pci/init.c b/arch/i386/pci/init.c
> index c7650a7..51087a9 100644
> --- a/arch/i386/pci/init.c
> +++ b/arch/i386/pci/init.c
> @@ -14,8 +14,12 @@ #endif
>  #ifdef CONFIG_PCI_BIOS
>  	pci_pcbios_init();
>  #endif
> -	if (raw_pci_ops)
> -		return 0;
> +	/*
> +	 * don't check for raw_pci_ops here because we want pcbios as last
> +	 * fallback, yet it's needed to run first to set pcibios_last_bus
> +	 * in case legacy PCI probing is used. otherwise detecting peer busses
> +	 * fails.
> +	 */
>  #ifdef CONFIG_PCI_DIRECT
>  	pci_direct_init();
>  #endif

That one works on my box without any issues.  Thanks!

-- Dave

