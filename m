From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/5] gdth: update deprecated pci_find_device
Date: Thu, 14 Feb 2008 15:13:33 -0500
Message-ID: <47B4A0ED.5090401@garzik.org>
References: <47B48CAE.2020705@panasas.com> <47B48DB5.1040303@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51942 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758242AbYBNUOE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Feb 2008 15:14:04 -0500
In-Reply-To: <47B48DB5.1040303@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> From: Sergio Luis <sergio@larces.uece.br>
> 
> Fix compilation warning in gdth.c, which was using the deprecated
> pci_find_device.
> 
> drivers/scsi/gdth.c:645: warning: 'pci_find_device' is deprecated (declared at include/linux/pci.h:495)
> 
> Changing it to use pci_get_device, instead.
> 
> Signed-off-by: Sergio Luis <sergio@larces.uece.br>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/Kconfig |    2 +-
>  drivers/scsi/gdth.c  |    7 +++++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 184c7ae..46fcb82 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -725,7 +725,7 @@ config SCSI_FD_MCS
>  
>  config SCSI_GDTH
>  	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
> -	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API && PCI_LEGACY
> +	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
>  	---help---
>  	  Formerly called GDT SCSI Disk Array Controller Support.
>  
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index b253b8c..5f0e054 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -643,12 +643,15 @@ static void __init gdth_search_dev(gdth_pci_str *pcistr, ushort *cnt,
>            *cnt, vendor, device));
>  
>      pdev = NULL;
> -    while ((pdev = pci_find_device(vendor, device, pdev)) 
> +    while ((pdev = pci_get_device(vendor, device, pdev))
>             != NULL) {
>          if (pci_enable_device(pdev))
>              continue;
> -        if (*cnt >= MAXHA)
> +        if (*cnt >= MAXHA) {
> +            pci_dev_put(pdev);
>              return;
> +        }

This patch is already upstream...  (unfortunately)

	Jeff



