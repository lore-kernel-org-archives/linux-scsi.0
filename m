From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: [PATCH] aic7xxx_old iomem annotations
Date: Fri, 22 Oct 2004 03:13:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022021320.GS24336@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:30670 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271171AbUJVCNY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 22:13:24 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC9-bk4-dpt/drivers/scsi/qlogicisp.c RC9-bk4-qlogicisp/drivers/scsi/qlogicisp.c
--- RC9-bk4-dpt/drivers/scsi/qlogicisp.c	Sat Aug 14 03:46:25 2004
+++ RC9-bk4-qlogicisp/drivers/scsi/qlogicisp.c	Wed Oct 20 19:24:36 2004
@@ -564,7 +564,7 @@
 };
 
 struct isp1020_hostdata {
-	u_long	memaddr;
+	void __iomem *memaddr;
 	u_char	revision;
 	struct	host_param host_param;
 	struct	dev_param dev_param[MAX_TARGETS];
@@ -714,7 +714,7 @@
 		continue;
 
 	fail_uninit:
-		iounmap((void *)hostdata->memaddr);
+		iounmap(hostdata->memaddr);
 		release_region(host->io_port, 0xff);
 	fail_and_unregister:
 		if (hostdata->res_cpu)
@@ -747,7 +747,7 @@
 	isp_outw(0x0, host, PCI_INTF_CTL);
 	free_irq(host->irq, host);
 
-	iounmap((void *)hostdata->memaddr);
+	iounmap(hostdata->memaddr);
 
 	release_region(host->io_port, 0xff);
 
@@ -769,7 +769,7 @@
 		"QLogic ISP1020 SCSI on PCI bus %02x device %02x irq %d %s base 0x%lx",
 		hostdata->pci_dev->bus->number, hostdata->pci_dev->devfn, host->irq,
 		(hostdata->memaddr ? "MEM" : "I/O"),
-		(hostdata->memaddr ? hostdata->memaddr : host->io_port));
+		(hostdata->memaddr ? (unsigned long)hostdata->memaddr : host->io_port));
 
 	LEAVE("isp1020_info");
 
@@ -1410,18 +1410,17 @@
 
  	if ((command & PCI_COMMAND_MEMORY) &&
  	    ((mem_flags & 1) == 0)) {
- 		mem_base = (u_long) ioremap(mem_base, PAGE_SIZE);
-		if (!mem_base) {
+ 		hostdata->memaddr = ioremap(mem_base, PAGE_SIZE);
+		if (!hostdata->memaddr) {
  			printk("qlogicisp : i/o remapping failed.\n");
 			goto out_release;
 		}
- 		hostdata->memaddr = mem_base;
  	} else {
 		if (command & PCI_COMMAND_IO && (io_flags & 3) != 1) {
 			printk("qlogicisp : i/o mapping is disabled\n");
 			goto out_release;
  		}
- 		hostdata->memaddr = 0; /* zero to signify no i/o mapping */
+ 		hostdata->memaddr = NULL; /* zero to signify no i/o mapping */
  		mem_base = 0;
 	}
 
@@ -1470,7 +1469,7 @@
 	return 0;
 
 out_unmap:
-	iounmap((void *)hostdata->memaddr);
+	iounmap(hostdata->memaddr);
 out_release:
 	release_region(sh->io_port, 0xff);
 	return 1;
