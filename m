From: Anton Blanchard <anton@samba.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b2).
Date: Thu, 22 May 2003 08:26:35 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030521222635.GB21124@krispykreme>
References: <20030519225728.GA17279@praka.local.home> <20030521173215.GA25137@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:19592 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262270AbTEUWVt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 18:21:49 -0400
Content-Disposition: inline
In-Reply-To: <20030521173215.GA25137@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@san.rr.com>, linux-scsi@vger.kernel.org


Hi,

> +#if MEMORY_MAPPED_IO
> +	/* Get memory mapped I/O address */
> +	pci_read_config_dword(ha->pdev, PCI_BASE_ADDRESS_1, &mmapbase);

You really want to be using pci_resource_start(ha->pdev, 1) so it will
work on architectures like ppc64 and sparc64.

> +	mmapbase &= PCI_BASE_ADDRESS_MEM_MASK;
> +
> +	/* Find proper memory chunk for memory map I/O reg */
> +	base = mmapbase & PAGE_MASK;
> +	page_offset = mmapbase - base;

Is that correct?

> +	/* Get virtual address for I/O registers  */
> +	ha->mmpbase = ioremap(base, page_offset + 256);

Anton
