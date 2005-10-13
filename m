From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] cleanup up mpt_attach error handling
Date: Thu, 13 Oct 2005 16:14:03 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C047475A4@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5372 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751116AbVJMWOP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 18:14:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: linux-scsi@vger.kernel.org

On Thursday, October 13, 2005 12:15 PM, Grant Grundler wrote: 
> 
> Eric,
> Minor cleanup to the error handling in mpt_attach.
> Intent is to make this code a bit more maintainable.

Thanks, nice cleanup.

> I'm also wondering if pci_disable_device() should be added to
> the error handling code.
> 

I guess that sounds good adding pci_disable_device().
Can you resend with patch that handles 
this(failure of pci_set_dma_mask, and the kmalloc 
right below it); as well as calling 
pci_disable_device() from mpt_detach() ?


> +mpterr_freeirq:
> +	free_irq(ioc->pci_irq, ioc);
> +mpterr_listdel:
> +	list_del(&ioc->list);
> +	iounmap(mem);
> +mpterr_freeioc:
> +	kfree(ioc);
> +	pci_set_drvdata(pdev, NULL);
> +	return r;
>  }
>  

Howabout using out_free_irq, and out_free_ioc, instead
of mpterr_freeirq, and mpterr_freeioc, respectively.

Thankyou,
Eric Moore
