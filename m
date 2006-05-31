From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: [PATCH][repost] kdump: mpt fusion driver initialization failure fix
Date: Wed, 31 May 2006 14:45:47 -0400
Message-ID: <20060531184547.GC8475@in.ibm.com>
References: <664A4EBB07F29743873A87CF62C26D70141D48@NAMAIL4.ad.lsil.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:4250 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751236AbWEaSp4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 14:45:56 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4VIjrbs027406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 14:45:53 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k4VIjqqG140570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 12:45:52 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4VIjqWL007077
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 12:45:52 -0600
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70141D48@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, Bottomley James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

On Wed, May 31, 2006 at 09:19:20AM -0600, Moore, Eric wrote:
> On Thursday, May 25, 2006 12:50 PM, Vivek Goyal wrote:   
> > 
> > Hi James,
> > 
> > Are there any issues with this patch? Are you planning to push it to
> > Linus sometime?
> > 
> 
> This patch is fine with LSI Logic.
> 
> Pls rebase your patch against the James scsi-misc tree, and repost
> so it can get into the 2.6.18 window.

The patch I had posted still applies cleanly on top of current scsi-misc
tree. I am attaching the patch again.

James, can you please include the patch.

Thanks
Vivek



o Kdump capture kernel boot fails during initialization of MPT fusion driver.
  (LSI Logic / Symbios Logic SAS1064E PCI-Express Fusion-MPT SAS (rev 01))

o Problem is easily reproducible, if system crashed while some disk activity
  like cp operation was going on.

o After a system crash, devices are not shutdown and capture kenrel starts
  booting while skipping BIOS. Hence underlying device is left in operational
  state. In this case scsi contoller was left with interrupt line asserted
  reply FIFO was not empty. When driver starts initializing in the second 
  kernel, it receives the interrupt the moment request_irq() is called.
  Interrupt handler, reads the message from reply FIFO and tries to access
  the associated message frame and panics, as in the new kernel's context
  that message frame is not valid at all.

o In this scenario, probably we should delay the request_irq() call. First
  bring up the IOC, reset it if needed and then should register for irq.

o I have tested the patch with SAS1064E and 53c1030 controllers.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 drivers/message/fusion/mptbase.c |   88 ++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 38 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~kdump-mpt-fusion-driver-hardening-fix drivers/message/fusion/mptbase.c
--- linux-2.6.17-rc2-1M/drivers/message/fusion/mptbase.c~kdump-mpt-fusion-driver-hardening-fix	2006-04-25 13:45:09.000000000 -0400
+++ linux-2.6.17-rc2-1M-root/drivers/message/fusion/mptbase.c	2006-04-25 14:53:28.000000000 -0400
@@ -1387,39 +1387,6 @@ mpt_attach(struct pci_dev *pdev, const s
 	/* Set lookup ptr. */
 	list_add_tail(&ioc->list, &ioc_list);
 
-	ioc->pci_irq = -1;
-	if (pdev->irq) {
-		if (mpt_msi_enable && !pci_enable_msi(pdev))
-			printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n", ioc->name);
-
-		r = request_irq(pdev->irq, mpt_interrupt, SA_SHIRQ, ioc->name, ioc);
-
-		if (r < 0) {
-#ifndef __sparc__
-			printk(MYIOC_s_ERR_FMT "Unable to allocate interrupt %d!\n",
-					ioc->name, pdev->irq);
-#else
-			printk(MYIOC_s_ERR_FMT "Unable to allocate interrupt %s!\n",
-					ioc->name, __irq_itoa(pdev->irq));
-#endif
-			list_del(&ioc->list);
-			iounmap(mem);
-			kfree(ioc);
-			return -EBUSY;
-		}
-
-		ioc->pci_irq = pdev->irq;
-
-		pci_set_master(pdev);			/* ?? */
-		pci_set_drvdata(pdev, ioc);
-
-#ifndef __sparc__
-		dprintk((KERN_INFO MYNAM ": %s installed at interrupt %d\n", ioc->name, pdev->irq));
-#else
-		dprintk((KERN_INFO MYNAM ": %s installed at interrupt %s\n", ioc->name, __irq_itoa(pdev->irq)));
-#endif
-	}
-
 	/* Check for "bound ports" (929, 929X, 1030, 1035) to reduce redundant resets.
 	 */
 	mpt_detect_bound_ports(ioc, pdev);
@@ -1429,11 +1396,7 @@ mpt_attach(struct pci_dev *pdev, const s
 		printk(KERN_WARNING MYNAM
 		  ": WARNING - %s did not initialize properly! (%d)\n",
 		  ioc->name, r);
-
 		list_del(&ioc->list);
-		free_irq(ioc->pci_irq, ioc);
-		if (mpt_msi_enable)
-			pci_disable_msi(pdev);
 		if (ioc->alt_ioc)
 			ioc->alt_ioc->alt_ioc = NULL;
 		iounmap(mem);
@@ -1637,6 +1600,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 	int	 handlers;
 	int	 ret = 0;
 	int	 reset_alt_ioc_active = 0;
+	int	 irq_allocated = 0;
 
 	printk(KERN_INFO MYNAM ": Initiating %s %s\n",
 			ioc->name, reason==MPT_HOSTEVENT_IOC_BRINGUP ? "bringup" : "recovery");
@@ -1720,6 +1684,48 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		}
 	}
 
+	/*
+	 * Device is reset now. It must have de-asserted the interrupt line
+	 * (if it was asserted) and it should be safe to register for the
+	 * interrupt now.
+	 */
+	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
+		ioc->pci_irq = -1;
+		if (ioc->pcidev->irq) {
+			if (mpt_msi_enable && !pci_enable_msi(ioc->pcidev))
+				printk(MYIOC_s_INFO_FMT "PCI-MSI enabled\n",
+					ioc->name);
+			rc = request_irq(ioc->pcidev->irq, mpt_interrupt,
+					SA_SHIRQ, ioc->name, ioc);
+			if (rc < 0) {
+#ifndef __sparc__
+				printk(MYIOC_s_ERR_FMT "Unable to allocate "
+					"interrupt %d!\n", ioc->name,
+					ioc->pcidev->irq);
+#else
+				printk(MYIOC_s_ERR_FMT "Unable to allocate "
+					"interrupt %s!\n", ioc->name,
+					__irq_itoa(ioc->pcidev->irq));
+#endif
+				if (mpt_msi_enable)
+					pci_disable_msi(ioc->pcidev);
+				return -EBUSY;
+			}
+			irq_allocated = 1;
+			ioc->pci_irq = ioc->pcidev->irq;
+			pci_set_master(ioc->pcidev);		/* ?? */
+			pci_set_drvdata(ioc->pcidev, ioc);
+#ifndef __sparc__
+			dprintk((KERN_INFO MYNAM ": %s installed at interrupt "
+				"%d\n", ioc->name, ioc->pcidev->irq));
+#else
+			dprintk((KERN_INFO MYNAM ": %s installed at interrupt "
+				"%s\n", ioc->name,
+				__irq_itoa(ioc->pcidev->irq)));
+#endif
+		}
+	}
+
 	/* Prime reply & request queues!
 	 * (mucho alloc's) Must be done prior to
 	 * init as upper addresses are needed for init.
@@ -1819,7 +1825,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 				ret = mptbase_sas_persist_operation(ioc,
 				    MPI_SAS_OP_CLEAR_NOT_PRESENT);
 				if(ret != 0)
-					return -1;
+					goto out;
 			}
 
 			/* Find IM volumes
@@ -1900,6 +1906,12 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		/* FIXME?  Examine results here? */
 	}
 
+out:
+	if ((ret != 0) && irq_allocated) {
+		free_irq(ioc->pci_irq, ioc);
+		if (mpt_msi_enable)
+			pci_disable_msi(ioc->pcidev);
+	}
 	return ret;
 }
 
_
