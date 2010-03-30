From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] mpt2sas: use correct pci_resource_flag for comparison
 with device pci ,resource
Date: Tue, 30 Mar 2010 16:18:05 +0530
Message-ID: <1C9608B8A4CD534FB19C7C7543CBB249020E3946A6@inbmail02.lsi.com>
References: <4B9ACDCA.6080803@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:54128 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755238Ab0C3KsT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2010 06:48:19 -0400
In-Reply-To: <4B9ACDCA.6080803@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard A Lary <rlary@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

After reviewing your patch, your patch looks ok to me. Similar changes I will post it for mptfusion also.

Please consider this patch as an Acked.

-- Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Richard A Lary
> Sent: Saturday, March 13, 2010 4:57 AM
> To: linux-scsi@vger.kernel.org
> Subject: [PATCH] mpt2sas: use correct pci_resource_flag for comparison
> with device pci ,resource
> 
> From: Richard A Lary <rlary@linux.vnet.ibm.com>
> 
> This patch replaces incorrect  base address space flag with correct IO
> resource
> flag.  Also, performs check of memory resource to validate resource
> before
> using.
> 
> Signed-off-by: Richard A Lary <rlary@linux.vnet.ibm.com>
> 
> ---
> 
> Index: b/drivers/scsi/mpt2sas/mpt2sas_base.c
> ===================================================================
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1253,7 +1253,7 @@ mpt2sas_base_map_resources(struct MPT2SA
>   	}
> 
>   	for (i = 0, memap_sz = 0, pio_sz = 0 ; i < DEVICE_COUNT_RESOURCE;
> i++) {
> -		if (pci_resource_flags(pdev, i) &
> PCI_BASE_ADDRESS_SPACE_IO) {
> +		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
>   			if (pio_sz)
>   				continue;
>   			pio_chip = (u64)pci_resource_start(pdev, i);
> @@ -1261,15 +1261,18 @@ mpt2sas_base_map_resources(struct MPT2SA
>   		} else {
>   			if (memap_sz)
>   				continue;
> -			ioc->chip_phys = pci_resource_start(pdev, i);
> -			chip_phys = (u64)ioc->chip_phys;
> -			memap_sz = pci_resource_len(pdev, i);
> -			ioc->chip = ioremap(ioc->chip_phys, memap_sz);
> -			if (ioc->chip == NULL) {
> -				printk(MPT2SAS_ERR_FMT "unable to map adapter "
> -				    "memory!\n", ioc->name);
> -				r = -EINVAL;
> -				goto out_fail;
> +			/* verify memory resource is valid before using */
> +			if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
> +				ioc->chip_phys = pci_resource_start(pdev, i);
> +				chip_phys = (u64)ioc->chip_phys;
> +				memap_sz = pci_resource_len(pdev, i);
> +				ioc->chip = ioremap(ioc->chip_phys, memap_sz);
> +				if (ioc->chip == NULL) {
> +					printk(MPT2SAS_ERR_FMT "unable to map "
> +					    "adapter memory!\n", ioc->name);
> +					r = -EINVAL;
> +					goto out_fail;
> +				}
>   			}
>   		}
>   	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
