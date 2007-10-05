From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Fri, 5 Oct 2007 12:03:55 -0700
Message-ID: <20071005120355.8986ca0a.akpm@linux-foundation.org>
References: <11913765421743-git-send-email-matthew@wil.cx>
	<11913765432770-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48855 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbXJETEa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:04:30 -0400
In-Reply-To: <11913765432770-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx, willy@linux.intel.com

On Tue,  2 Oct 2007 21:55:42 -0400
Matthew Wilcox <matthew@wil.cx> wrote:

> @@ -13428,9 +13428,9 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
>  		boardp->ioremap_addr = ioremap(pci_resource_start(pdev, 1),
>  					       boardp->asc_n_io_port);
>  		if (!boardp->ioremap_addr) {
> -			shost_printk(KERN_ERR, shost, "ioremap(%x, %d) "
> +			shost_printk(KERN_ERR, shost, "ioremap(%lx, %d) "
>  					"returned NULL\n",
> -					pci_resource_start(pdev, 1),
> +					(long)pci_resource_start(pdev, 1),
>  					boardp->asc_n_io_port);

This isn't right.  resource_size_t can be 64-bit so should be cast to
unsigned long long and printed with %llx.

If it is known that this driver will never encounter a 64-bit address here
then this optimisation should be accompanied by a comment at every place
where it is employed so that people do not copy the wrong code into other
drivers.

