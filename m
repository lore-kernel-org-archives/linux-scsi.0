From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [BK PATCH] essential SCSI fixes for 2.6.5-rc2
Date: 20 Mar 2004 10:21:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079796067.1755.18.camel@mulgrave>
References: <1079793048.1778.6.camel@mulgrave>
	<m3u10jr93e.fsf@averell.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:51681 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263441AbUCTPVV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Mar 2004 10:21:21 -0500
In-Reply-To: <m3u10jr93e.fsf@averell.firstfloor.org>
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>, Eric Dean Moore <Emoore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-03-20 at 07:33, Andi Kleen wrote:
> Any chance you could include the fusion consistent mask patch with this? 
> 
> Without this fusion is completely unusable with >4GB on 64bit.

But if I include this patch, it will break Altix.

Eric, could you make fixing this your top priority?  Even if you can't
consolidate the allocations, what about using dma_pool instead?

James

> diff -burpN -X ../KDIFX -x '*-SLAB' linux-vanilla-2.6.5rc2/drivers/message/fusion/mptbase.c linux-2.6.5rc2-amd64/drivers/message/fusion/mptbase.c
> --- linux-vanilla-2.6.5rc2/drivers/message/fusion/mptbase.c	2004-03-20 03:55:31.000000000 +0100
> +++ linux-2.6.5rc2-amd64/drivers/message/fusion/mptbase.c	2004-03-20 04:11:24.000000000 +0100
> @@ -1280,12 +1280,17 @@ mptbase_probe(struct pci_dev *pdev, cons
>  		return r;
>  	}
>  
> +#if 0
> +	/* broken because some code assumes that multiple calls
> +	   to pci_alloc_consistent return data in the same 4GB segment. 
> +	   This cannot work on machines with enough memory. */
>  	if (!pci_set_consistent_dma_mask(pdev, mask))
>  		dprintk((KERN_INFO MYNAM
>  			": Using 64 bit consistent mask\n"));
>  	else
>  		dprintk((KERN_INFO MYNAM
>  			": Not using 64 bit consistent mask\n"));
> +#endif
>  
>  	ioc = kmalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
>  	if (ioc == NULL) {


