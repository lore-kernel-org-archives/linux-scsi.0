From: "Anil K. Ravindranath" <anil_ravindranath@adaptec.com>
Subject: Re: [PATCH] aic7xxx driver. Restrict DMA to 32bit for 29320LPE
	Adaptec SCSI controller
Date: Thu, 20 Sep 2007 08:08:09 -0700
Message-ID: <1190300889.31372.4.camel@linux.site>
References: <1183207551.14436.15.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:49852 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751975AbXIUAbE (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2007 20:31:04 -0400
In-Reply-To: <1183207551.14436.15.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-scsi@vger.kernel.org, James.Bottemley@SteelEye.com

Hi,

We have not heard any comments or inputs on this patch. 

With regards,
  Anil

On Sat, 2007-06-30 at 05:45 -0700, Anil K. Ravindranath wrote:
> Subject: [PATCH] aic7xxx driver. Restrict DMA to 32bit for 29320LPE
> Adaptec SCSI controller
> 
> Contribution:
> 
> Anil Ravindranath <anil_ravindranath@adaptec.com>
> 
> Issue:
> 
> Data Bursts that cross from 32- to 64-Bit address space have incorrect
> address for 29320LPE. This leads to potential data corruption.
> 
> Fix:
> 
> Restrict DMA to 32bit so that it does not cross 4GB boundary.
> 
> Change Log:
> 
> Restrict DMA to 32bit for 29320LPE so that it does not cross 4GB
> boundary
> 
> Patch: apply to scsi-misc-2.6.git development tree
> 
> Signed off By:  Anil Ravindranath <anil_ravindranath@adaptec.com>
> 
> diff -urN a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> --- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c    2007-06-30
> 05:24:08.000000000 -0700
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c    2007-06-30
> 05:25:40.000000000 -0700
> @@ -161,7 +161,10 @@
>         }
>         pci_set_master(pdev);
> 
> -       if (sizeof(dma_addr_t) > 4) {
> +       /*
> +        * Restrict DMA to 32bit for 29320LPE
> +        */
> +       if ((sizeof(dma_addr_t) > 4) && (entry->full_id !=
> ID_AHA_29320LPE)) {
>                 const u64 required_mask = dma_get_required_mask(dev);
> 
>                 if (required_mask > DMA_39BIT_MASK &&
> 
> 
> 
> diffstat output:
> 
> aic79xx_osm_pci.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletion(-)
> 
> With regards,
>   Anil
