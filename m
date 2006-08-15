From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [patch 18/24] megaraid: Dell CERC ATA100/4ch support
Date: Tue, 15 Aug 2006 08:19:19 -0600
Message-ID: <890BF3111FB9484E9526987D912B261932E347@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:15538 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S965377AbWHOOTn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 10:19:43 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, jkrzyszt@tis.icnet.pl

Hi,
On Tuesday, August 15, 2006 2:10 AM, Janusz Krzysztofik wrote:
> Add CERC subsystem ids to the old megaraid driver.  Tested, works.
NACK - This addition will create PCI ID overlapping with megaraid_{mbox,mm} module under driver/scsi/megaraid.
Since 2.6.16, we have removed some IDs in the megaraid module under driver/scsi to address ID overlappijng issue.
Please switch to megaraid_{mbox,mm} module for the controller support. megaraid module under driver/scsi is dedicated to very old products.

Seokmann

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of akpm@osdl.org
> Sent: Tuesday, August 15, 2006 2:10 AM
> To: James.Bottomley@steeleye.com
> Cc: linux-scsi@vger.kernel.org; akpm@osdl.org; jkrzyszt@tis.icnet.pl
> Subject: [patch 18/24] megaraid: Dell CERC ATA100/4ch support
> 
> From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> 
> Add CERC subsystem ids to the old megaraid driver.  Tested, works.
> 
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> Signed-off-by: Andrew Morton <akpm@osdl.org>
> ---
> 
>  drivers/scsi/megaraid.c |    2 ++
>  drivers/scsi/megaraid.h |    2 ++
>  2 files changed, 4 insertions(+)
> 
> diff -puN 
> drivers/scsi/megaraid.c~megaraid-dell-cerc-ata100-4ch-support 
> drivers/scsi/megaraid.c
> --- a/drivers/scsi/megaraid.c~megaraid-dell-cerc-ata100-4ch-support
> +++ a/drivers/scsi/megaraid.c
> @@ -5046,6 +5046,8 @@ static struct pci_device_id megaraid_pci
>  		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
>  	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
>  		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> +	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
> +		PCI_VENDOR_ID_DELL, PCI_SUBSYS_ID_CERC_ATA100, 0, 0, 0},
>  	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
>  		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
>  	{0,}
> diff -puN 
> drivers/scsi/megaraid.h~megaraid-dell-cerc-ata100-4ch-support 
> drivers/scsi/megaraid.h
> --- a/drivers/scsi/megaraid.h~megaraid-dell-cerc-ata100-4ch-support
> +++ a/drivers/scsi/megaraid.h
> @@ -84,6 +84,8 @@
>  #define LSI_SUBSYS_VID			0x1000
>  #define INTEL_SUBSYS_VID		0x8086
>  
> +#define PCI_SUBSYS_ID_CERC_ATA100	0x0511
> +
>  #define HBA_SIGNATURE	      		0x3344
>  #define HBA_SIGNATURE_471	  	0xCCCC
>  #define HBA_SIGNATURE_64BIT		0x0299
> _
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
