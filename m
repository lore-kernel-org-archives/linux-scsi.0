From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 15/24] advansys: ioremap no longer needs page-aligned
 addresses
Date: Fri, 27 Jul 2007 10:45:54 -0400
Message-ID: <46AA0522.2080609@garzik.org>
References: <20070727134038.GC21219@parisc-linux.org> <1185543753687-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:58355 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067AbXG0Op4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jul 2007 10:45:56 -0400
In-Reply-To: <1185543753687-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> -#ifdef CONFIG_PCI
> -		pci_memory_address = pci_resource_start(pdev, 1);
> -		ASC_DBG1(1,
> -			 "advansys_board_found: pci_memory_address: 0x%lx\n",
> -			 (ulong)pci_memory_address);
> -		if ((boardp->ioremap_addr =
> -		     ioremap(pci_memory_address & PAGE_MASK, PAGE_SIZE)) == 0) {
> +		boardp->asc_n_io_port = pci_resource_len(pdev, 1);
> +		boardp->ioremap_addr = ioremap(pci_resource_start(pdev, 1),
> +					       boardp->asc_n_io_port);
> +		if (!boardp->ioremap_addr) {
>  			ASC_PRINT3


As mentioned before you should check pci_resource_{start,len} do not 
return zero in pci_driver::probe().

For PCI BAR length, the end result is just a more friendly error 
message, since ioremap will return NULL for !size.

But ioremap will do the wrong thing, if passed zero for PCI BAR bus address.

	Jeff


