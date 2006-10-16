From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6.19-rc2] scsi: megaraid_{mm,mbox}: 64-bit DMA
	capability fix
Date: Mon, 16 Oct 2006 14:34:44 -0500
Message-ID: <1161027285.3433.25.camel@mulgrave.il.steeleye.com>
References: <45333E0B.7000905@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:53458 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422857AbWJPTey (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 15:34:54 -0400
In-Reply-To: <45333E0B.7000905@sw.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasily Averin <vvs@sw.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Ju, Seokmann" <Seokmann.Ju@lsil.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, devel@openvz.org, Andrey Mirkin <amirkin@sw.ru>

On Mon, 2006-10-16 at 12:08 +0400, Vasily Averin wrote:
> It is known that 2 LSI Logic MegaRAID SATA RAID Controllers (150-4 and 150-6)
> don't support 64-bit DMA. Unfortunately currently this check is wrong and driver
>  sets 64-bit DMA mode for these devices.
> 
> Signed-off-by:	Andrey Mirkin <amirkin@sw.ru>
> Ack-by:		Vasily Averin <vvs@sw.ru>
> 
> --- linux-2.6.19-rc2/drivers/scsi/megaraid/megaraid_mbox.c.mgst6	2006-10-16
> 10:26:50.000000000 +0400
> +++ linux-2.6.19-rc2/drivers/scsi/megaraid/megaraid_mbox.c	2006-10-16
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

Er ... this patch would apply in reverse, but what's in the tree
currently looks to be correct.

James


