From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH 2.6.11-rc4 rename IOMAPPED config option
Date: Sun, 20 Feb 2005 20:11:58 -0500
Message-ID: <4219355E.1000807@pobox.com>
References: <20050221010758.GC30800@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14000 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261176AbVBUBMN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Feb 2005 20:12:13 -0500
In-Reply-To: <20050221010758.GC30800@colo.lackof.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: willy@parisc-linux.org, linux-scsi@vger.kernel.org

Grant Grundler wrote:
> --- drivers/scsi/Kconfig	3 Feb 2005 11:44:46 -0000	1.32
> +++ drivers/scsi/Kconfig	21 Feb 2005 00:46:18 -0000

Patch doesn't apply with -p1.



> --- drivers/scsi/sym53c8xx_2/sym_glue.c	20 Feb 2005 23:49:27 -0000	1.84
> +++ drivers/scsi/sym53c8xx_2/sym_glue.c	21 Feb 2005 00:46:18 -0000
> @@ -1915,7 +1915,7 @@ sym_init_device(struct pci_dev *pdev, st
>  	i = pci_get_base_address(pdev, 1, &device->s.base);
>  	pci_get_base_address(pdev, i, &device->s.base_2);
>  
> -#ifdef CONFIG_SCSI_SYM53C8XX_IOMAPPED
> +#ifndef CONFIG_SCSI_SYM53C8XX_USE_MMIO
>  	device->s.ioaddr = pci_iomap(pdev, 0, pci_resource_len(pdev, 0));
>  #else
>  	device->s.ioaddr = pci_iomap(pdev, 1, pci_resource_len(pdev, 1));

This file does not include <linux/config.h>.


> Index: drivers/scsi/sym53c8xx_2/sym_hipd.c
> ===================================================================
> RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
> retrieving revision 1.48
> diff -u -p -r1.48 sym_hipd.c
> --- drivers/scsi/sym53c8xx_2/sym_hipd.c	16 Feb 2005 20:54:02 -0000	1.48
> +++ drivers/scsi/sym53c8xx_2/sym_hipd.c	21 Feb 2005 00:46:18 -0000
> @@ -1044,7 +1044,7 @@ static int sym_prepare_setting(struct sy
>   *
>   *  Has to be called with interrupts disabled.
>   */
> -#ifndef SYM_CONF_IOMAPPED
> +#ifdef CONFIG_SCSI_SYM53C8XX_USE_MMIO

ditto

