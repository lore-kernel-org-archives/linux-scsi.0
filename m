From: Vasily Averin <vvs@sw.ru>
Subject: Re: [PATCH 1/3] scsi : megaraid_{mm,mbox}: 64-bit DMA capability
 checker
Date: Mon, 24 Jul 2006 12:08:48 +0400
Message-ID: <44C48010.40603@sw.ru>
References: <890BF3111FB9484E9526987D912B261902CDA9@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:18617 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S932093AbWGXIJU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 04:09:20 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261902CDA9@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsil.com>, yang.bo@lsil.com

Ju, Seokmann wrote:
> Hi,
> With patch, the driver access PCIconfiguration space with dedicated 
> offset to read a signature. If the signature read, it means that the 
> controller has capability to handle 64-bit DMA. 
> Without this patch, the driver blindly claimed 64-bit DMA capability
> without checking with controller.
> The issue has been reported by Vasily Averin. 

> +	if (((magic64 == HBA_SIGNATURE_64_BIT) &&
> +		(adapter->pdev->subsystem_device !=
> +		PCI_SUBSYS_ID_MEGARAID_SATA_150_6)) ||

I would note that I've reported about issue on SATA_150_4 device. I can also
accept that similar patch fixes this issue.

> +		(adapter->pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC && 
> +		adapter->pdev->device == PCI_DEVICE_ID_VERDE) || 
> +		(adapter->pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC && 
> +		adapter->pdev->device == PCI_DEVICE_ID_DOBSON) || 
> +		(adapter->pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC && 
> +		adapter->pdev->device == PCI_DEVICE_ID_LINDSAY) || 
> +		(adapter->pdev->vendor == PCI_VENDOR_ID_DELL && 
> +		adapter->pdev->device == PCI_DEVICE_ID_PERC4_DI_EVERGLADES) || 
> +		(adapter->pdev->vendor == PCI_VENDOR_ID_DELL && 
> +		adapter->pdev->device == PCI_DEVICE_ID_PERC4E_DI_KOBUK)) {

Thank you,
	Vasily Averin

SWsoft Virtuozzo/OpenVZ Linux kernel team
