From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH] cleanup up mpt_attach error handling
Date: Fri, 14 Oct 2005 00:15:26 -0600
Message-ID: <20051014061526.GE3348@colo.lackof.org>
References: <91888D455306F94EBD4D168954A9457C047475A4@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:1234 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S932212AbVJNGIa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 02:08:30 -0400
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C047475A4@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-scsi@vger.kernel.org

On Thu, Oct 13, 2005 at 04:14:03PM -0600, Moore, Eric Dean wrote:
> I guess that sounds good adding pci_disable_device().
> Can you resend with patch that handles 
> this(failure of pci_set_dma_mask, and the kmalloc 
> right below it);

Version 2 (appended) includes the above.
While it looks right, it's late here. Please review carefully.

> as well as calling pci_disable_device() from mpt_detach() ?

As noted earlier, I think this needs more review of the related
PCI code paths and some substantial testing (e.g. load/unload
and maybe hotplug).

> Howabout using out_free_irq, and out_free_ioc, instead
> of mpterr_freeirq, and mpterr_freeioc, respectively.

Also done.

thanks,
grant


diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1164,7 +1164,7 @@ mpt_attach(struct pci_dev *pdev, const s
 			": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n"));
 	} else if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
 		printk(KERN_WARNING MYNAM ": 32 BIT PCI BUS DMA ADDRESSING NOT SUPPORTED\n");
-		return r;
+		goto out_pcidisable;
 	}
 
 	if (!pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
@@ -1177,7 +1177,7 @@ mpt_attach(struct pci_dev *pdev, const s
 	ioc = kmalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
 	if (ioc == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Insufficient memory to add adapter!\n");
-		return -ENOMEM;
+		goto out_pcidisable;
 	}
 	memset(ioc, 0, sizeof(MPT_ADAPTER));
 	ioc->alloc_total = sizeof(MPT_ADAPTER);
@@ -1231,8 +1231,8 @@ mpt_attach(struct pci_dev *pdev, const s
 
 	if (ii == DEVICE_COUNT_RESOURCE) {
 		printk(KERN_ERR MYNAM ": ERROR - MPT adapter has no memory regions defined!\n");
-		kfree(ioc);
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_freeioc;
 	}
 
 	dinitprintk((KERN_INFO MYNAM ": MPT adapter @ %lx, msize=%dd bytes\n", mem_phys, msize));
@@ -1244,8 +1244,8 @@ mpt_attach(struct pci_dev *pdev, const s
 	mem = ioremap(mem_phys, 0x100);
 	if (mem == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Unable to map adapter memory!\n");
-		kfree(ioc);
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_freeioc;
 	}
 	ioc->memmap = mem;
 	dinitprintk((KERN_INFO MYNAM ": mem = %p, mem_phys = %lx\n", mem, mem_phys));
@@ -1387,10 +1387,8 @@ mpt_attach(struct pci_dev *pdev, const s
 			printk(MYIOC_s_ERR_FMT "Unable to allocate interrupt %s!\n",
 					ioc->name, __irq_itoa(pdev->irq));
 #endif
-			list_del(&ioc->list);
-			iounmap(mem);
-			kfree(ioc);
-			return -EBUSY;
+			r = -EBUSY;
+			goto out_unlist;
 		}
 
 		ioc->pci_irq = pdev->irq;
@@ -1414,13 +1412,7 @@ mpt_attach(struct pci_dev *pdev, const s
 		printk(KERN_WARNING MYNAM
 		  ": WARNING - %s did not initialize properly! (%d)\n",
 		  ioc->name, r);
-
-		list_del(&ioc->list);
-		free_irq(ioc->pci_irq, ioc);
-		iounmap(mem);
-		kfree(ioc);
-		pci_set_drvdata(pdev, NULL);
-		return r;
+		goto out_freeirq;
 	}
 
 	/* call per device driver probe entry point */
@@ -1451,6 +1443,18 @@ mpt_attach(struct pci_dev *pdev, const s
 #endif
 
 	return 0;
+
+out_freeirq:
+	free_irq(ioc->pci_irq, ioc);
+out_listdel:
+	list_del(&ioc->list);
+	iounmap(mem);
+	pci_set_drvdata(pdev, NULL);
+out_freeioc:
+	kfree(ioc);
+out_pcidisable:
+	pci_disable_device(pdev);
+	return r;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
