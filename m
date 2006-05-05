From: Vasily Averin <vvs@sw.ru>
Subject: Re: megaraid_mbox: garbage in file
Date: Sat, 06 May 2006 03:35:41 +0400
Message-ID: <445BE14D.8000706@sw.ru>
References: <890BF3111FB9484E9526987D912B261901BD42@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:36481 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S1750759AbWEEXci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 May 2006 19:32:38 -0400
In-Reply-To: <890BF3111FB9484E9526987D912B261901BD42@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@engenio.com>, "Mukker, Atul" <Atul.Mukker@engenio.com>, "Bagalkote, Sreenivas" <Sreenivas.Bagalkote@engenio.com>, devel@openvz.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Ju, Seokmann wrote:
> Can you do one quick change in the driver?
> Search for 'pci_set_dma_mask()' API calls in the driver and mask out one of them with DMA_64BIT_MASK as follow.
> ---
> 	// if (pci_set_dma_mask(adapter->pdev, DMA_64BIT_MASK) != 0) {
> 
> 	// 	conlog(CL_ANN, (KERN_WARNING
> 	// 		"megaraid: could not set DMA mask for 64-bit.\n"));
> 
> 	// 	goto out_free_sysfs_res;
> 	// }
> ---
> 
> I found that the driver is NOT checking 64-bit DMA capability of the controllers accordingly and this could be a reason.

This change help me:
megaraid mailbox: status:0x0 cmd:0xa7 id:0x1f sec:0x1a lba:0x33f624ac
addr:0xffffffff ld:128 sg:4
scsi cmnd: 0x28 0x00 0x33 0xf6 0x24 0xac 0x00 0x00 0x1a 0x00
mbox request_buffer ebeb9380 use_sg 4
mbox sg0: page 050c5d88 off 0 addr e90d2000 len 4096 virt eb0d2000
		 first 732e646c page->flags 20000000
mbox sg1: page 050c5710 off 0 addr e90a4000 len 4096 virt eb0a4000
		 first 00000003 page->flags 20000000
mbox sg2: page 050c4438 off 0 addr e901e000 len 4096 virt eb01e000
		 first 00000000 page->flags 20000000
mbox sg3: page 030d64dc off 1024 addr 5f3f400 len 1024 virt 07f3f400
		 first 19398a0e page->flags 20001004

Errors go away, file content is correct.

> I'm waiting for feedback from F/W team for MegaRAID 150-4 controller if it supports 64-bit DMA.
> 
> I'll update here as I get.

How do you this, can it be the cause of
http://bugzilla.kernel.org/show_bug.cgi?id=6052

If so, you have a good chance to resolve this bug too :)

Thank you,
	Vasily Averin

SWsoft Virtuozzo/OpenVZ Linux kernel team
