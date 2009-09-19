From: Eddie <stunnel@attglobal.net>
Subject: Re: LSI MegaRAID not recognised correctly in 64-bit.  2.6.29.6
Date: Sat, 19 Sep 2009 08:24:02 -0700
Message-ID: <4AB4F792.8020308@attglobal.net>
References: <20090918141106.GA29475@parisc-linux.org>	<20090918231745O.fujita.tomonori@lab.ntt.co.jp>	<4AB48254.4000404@attglobal.net> <20090919165404D.fujita.tomonori@lab.ntt.co.jp>
Reply-To: stunnel@attglobal.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kcout01.prserv.net ([12.154.55.31]:47139 "EHLO
	kcout01.prserv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423AbZISPYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Sep 2009 11:24:06 -0400
In-Reply-To: <20090919165404D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: matthew@wil.cx, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, bo.yang@lsi.com

FUJITA Tomonori wrote:
> Thanks, now the problem is clear; the driver uses 64bit dma_mask but
> the hardware is not capable of 64bit dma according to James. Seems
> that hardware lies about the dma capability.
>
> Can you try the following patch?
>
>
> diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
> index 234f0b7..9ead856 100644
> --- a/drivers/scsi/megaraid/megaraid_mbox.c
> +++ b/drivers/scsi/megaraid/megaraid_mbox.c
> @@ -888,6 +888,8 @@ megaraid_init_mbox(adapter_t *adapter)
>  	if (((magic64 == HBA_SIGNATURE_64_BIT) &&
>  		((adapter->pdev->subsystem_device !=
>  		PCI_SUBSYS_ID_MEGARAID_SATA_150_6) &&
> +		(adapter->pdev->device !=
> +		PCI_DEVICE_ID_AMI_MEGARAID3) &&
>  		(adapter->pdev->subsystem_device !=
>  		PCI_SUBSYS_ID_MEGARAID_SATA_150_4))) ||
>  		(adapter->pdev->vendor == PCI_VENDOR_ID_LSI_LOGIC &&
>
>   
OK, that appears to have done the trick.

Thanks to all of you.

Cheers,
Eddie

