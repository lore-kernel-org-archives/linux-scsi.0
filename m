From: Grant Grundler <grundler@parisc-linux.org>
Subject: [PATCH] cleanup up mpt_attach error handling
Date: Thu, 13 Oct 2005 12:14:50 -0600
Message-ID: <20051013181450.GA24196@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:55715 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S932146AbVJMSH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 14:07:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsil.com
Cc: linux-scsi@vger.kernel.org, grundler@parisc-linux.org

Eric,
Minor cleanup to the error handling in mpt_attach.
Intent is to make this code a bit more maintainable.

This is NOT tested. But it *looks* right. :^)
We are still working on bringing up mpt driver on parisc-linux.

I'm also wondering if pci_disable_device() should be added to
the error handling code.

thanks,
grant


diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1244,8 +1244,8 @@ mpt_attach(struct pci_dev *pdev, const s
 	mem = ioremap(mem_phys, 0x100);
 	if (mem == NULL) {
 		printk(KERN_ERR MYNAM ": ERROR - Unable to map adapter memory!\n");
-		kfree(ioc);
-		return -EINVAL;
+		r = -EINVAL;
+		goto mpterr_freeioc;
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
+			goto mpterr_unlist;
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
+		goto mpterr_freeirq;
 	}
 
 	/* call per device driver probe entry point */
@@ -1451,6 +1443,16 @@ mpt_attach(struct pci_dev *pdev, const s
 #endif
 
 	return 0;
+
+mpterr_freeirq:
+	free_irq(ioc->pci_irq, ioc);
+mpterr_listdel:
+	list_del(&ioc->list);
+	iounmap(mem);
+mpterr_freeioc:
+	kfree(ioc);
+	pci_set_drvdata(pdev, NULL);
+	return r;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
