From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] mpt3sas: move dereference under check
Date: Thu, 14 Mar 2013 17:34:30 +0300
Message-ID: <20130314143430.GF9189@mwanda>
References: <20130311114014.GA8235@longonot.mountain>
 <DCD177647606E9419ED923E0C8C4AA7223E78BBBA3@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27177 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab3CNOen (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Mar 2013 10:34:43 -0400
Content-Disposition: inline
In-Reply-To: <DCD177647606E9419ED923E0C8C4AA7223E78BBBA3@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 14, 2013 at 06:52:35PM +0530, Reddy, Sreekanth wrote:
> Hi Dan Carpenter,
> 
> While analyzing this patch, I have added some debugging prints to
> print the address referenced by the IOC->sense_dma_pool before and
> after pci_pool_free() API and I have observed that the address
> referenced by this pointer is same before and after calling
> pci_pool_free() API.  Please let me know if you have any case
> where you have seen ioc->sense_dma_pool is dereferenced after
> calling pci_pool_free API.
> 
> And we are checking this ioc->sense_dma_pool pointer to NULL value
> for safe side even it is not assigned to NULL value anywhere in
> the driver code.

Thanks for looking at this.

I hope you don't mind, but I've added linux-scsi back to the CC.

This is a static checker which is complaining that the code is not
checking for NULL consistently.  If "ioc->sense_dma_pool" is NULL
then we will crash inside pci_pool_free().  The NULL dereference is
on the line where we do:

mm/dmapool.c
   391  void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
   392  {
   393          struct dma_page *page;
   394          unsigned long flags;
   395          unsigned int offset;
   396  
   397          spin_lock_irqsave(&pool->lock, flags);
                                  ^^^^^^^^^^^
This dereference will cause a crash because we call pci_pool_free()
without testing for NULL.

   398          page = pool_find_page(pool, dma);

In other words:

drivers/scsi/mpt3sas/mpt3sas_base.c
  2481          if (ioc->sense) {
  2482                  pci_pool_free(ioc->sense_dma_pool, ioc->sense, ioc->sense_dma);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We crash on this line before we reach the NULL test on the next
line.

  2483                  if (ioc->sense_dma_pool)
  2484                          pci_pool_destroy(ioc->sense_dma_pool);

I've looked at the code, and you're right that if (ioc->sense) {
is non-NULL that means ->sense_dma_pool is non-NULL.  ioc->sense is
allocated from the DMA pool.

I would like to just remove the test and silence the warning
message.

regards,
dan carpenter

