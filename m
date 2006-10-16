From: "Ju, Seokmann" <Seokmann.Ju@lsi.com>
Subject: RE: [PATCH 2.6.19-rc2] scsi: megaraid_{mm,mbox}: 64-bit DMA capability fix
Date: Mon, 16 Oct 2006 06:32:14 -0600
Message-ID: <890BF3111FB9484E9526987D912B261932E3E4@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7635 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1422675AbWJPMc3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 08:32:29 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@sw.ru>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, devel@openvz.org
Cc: Andrey Mirkin <amirkin@sw.ru>

Hi,
Monday, October 16, 2006 4:09 AM, Vasily Averin wrote:
> It is known that 2 LSI Logic MegaRAID SATA RAID Controllers 
> (150-4 and 150-6)
> don't support 64-bit DMA. Unfortunately currently this check 
> is wrong and driver
>  sets 64-bit DMA mode for these devices.
ACK - this patch will fix the problem.
Thank you for the finding, Vasily.

Seokmann

> -----Original Message-----
> From: Vasily Averin [mailto:vvs@sw.ru] 
> Sent: Monday, October 16, 2006 4:09 AM
> To: Linux Kernel Mailing List; linux-scsi@vger.kernel.org; 
> Ju, Seokmann; James Bottomley; Andrew Morton; Linus Torvalds; 
> devel@openvz.org
> Cc: Andrey Mirkin
> Subject: [PATCH 2.6.19-rc2] scsi: megaraid_{mm,mbox}: 64-bit 
> DMA capability fix
> 
> From: Andrey Mirkin (amirkin@sw.ru)
> 
> It is known that 2 LSI Logic MegaRAID SATA RAID Controllers 
> (150-4 and 150-6)
> don't support 64-bit DMA. Unfortunately currently this check 
> is wrong and driver
>  sets 64-bit DMA mode for these devices.
> 
> Signed-off-by:	Andrey Mirkin <amirkin@sw.ru>
> Ack-by:		Vasily Averin <vvs@sw.ru>
> 
> --- 
> linux-2.6.19-rc2/drivers/scsi/megaraid/megaraid_mbox.c.mgst6	
> 2006-10-16
> 10:26:50.000000000 +0400
> +++ linux-2.6.19-rc2/drivers/scsi/megaraid/megaraid_mbox.c	
> 2006-10-16
> 11:30:55.000000000 +0400
> @@ -884,7 +884,7 @@ megaraid_init_mbox(adapter_t *adapter)
> 
>  	if (((magic64 == HBA_SIGNATURE_64_BIT) &&
>  		((adapter->pdev->subsystem_device !=
> -		PCI_SUBSYS_ID_MEGARAID_SATA_150_6) ||
> +		PCI_SUBSYS_ID_MEGARAID_SATA_150_6) &&
>  		(adapter->pdev->subsystem_device !=
>  		PCI_SUBSYS_ID_MEGARAID_SATA_150_4))) ||
>  		(adapter->pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC &&
> 
> 
