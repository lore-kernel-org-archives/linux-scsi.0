From: akpm@osdl.org
Subject: [patch 30/30] SCSI/megaraid: fix MMIO casts
Date: Mon, 04 Dec 2006 15:18:45 -0800
Message-ID: <200612042319.kB4NJsx7008822@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56808 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967775AbWLDXUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:20:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jeff@garzik.org

From: Jeff Garzik <jeff@garzik.org>

megaraid's MMIO RD*/WR* macros directly call readl() and writel() with an
'unsigned long' argument.  This throws a warning, but is otherwise OK because
the 'unsigned long' is really the result of ioremap().  This setup is also OK
because the variable can hold an ioremap cookie /or/ a PCI I/O port (PIO).

However, to fix the warning thrown when readl() and writel() are passed an
unsigned long cookie, I introduce 'void __iomem *mmio_base', holding the same
value as 'base'.  This will silence the warnings, and also cause an oops
whenever these MMIO-only functions are ever accidentally passed an I/O
address.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |   13 ++++++++-----
 drivers/scsi/megaraid.h |    3 ++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/megaraid.c~scsi-megaraid-fix-mmio-casts drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~scsi-megaraid-fix-mmio-casts
+++ a/drivers/scsi/megaraid.c
@@ -73,10 +73,10 @@ static unsigned short int max_mbox_busy_
 module_param(max_mbox_busy_wait, ushort, 0);
 MODULE_PARM_DESC(max_mbox_busy_wait, "Maximum wait for mailbox in microseconds if busy (default=MBOX_BUSY_WAIT=10)");
 
-#define RDINDOOR(adapter)		readl((adapter)->base + 0x20)
-#define RDOUTDOOR(adapter)		readl((adapter)->base + 0x2C)
-#define WRINDOOR(adapter,value)		writel(value, (adapter)->base + 0x20)
-#define WROUTDOOR(adapter,value)	writel(value, (adapter)->base + 0x2C)
+#define RDINDOOR(adapter)	readl((adapter)->mmio_base + 0x20)
+#define RDOUTDOOR(adapter)	readl((adapter)->mmio_base + 0x2C)
+#define WRINDOOR(adapter,value)	 writel(value, (adapter)->mmio_base + 0x20)
+#define WROUTDOOR(adapter,value) writel(value, (adapter)->mmio_base + 0x2C)
 
 /*
  * Global variables
@@ -1386,7 +1386,8 @@ megaraid_isr_memmapped(int irq, void *de
 
 		handled = 1;
 
-		while( RDINDOOR(adapter) & 0x02 ) cpu_relax();
+		while( RDINDOOR(adapter) & 0x02 )
+			cpu_relax();
 
 		mega_cmd_done(adapter, completed, nstatus, status);
 
@@ -4672,6 +4673,8 @@ megaraid_probe_one(struct pci_dev *pdev,
 		host->host_no, mega_baseport, irq);
 
 	adapter->base = mega_baseport;
+	if (flag & BOARD_MEMMAP)
+		adapter->mmio_base = (void __iomem *) mega_baseport;
 
 	INIT_LIST_HEAD(&adapter->free_list);
 	INIT_LIST_HEAD(&adapter->pending_list);
diff -puN drivers/scsi/megaraid.h~scsi-megaraid-fix-mmio-casts drivers/scsi/megaraid.h
--- a/drivers/scsi/megaraid.h~scsi-megaraid-fix-mmio-casts
+++ a/drivers/scsi/megaraid.h
@@ -801,7 +801,8 @@ typedef struct {
 				   clustering is available */
 	u32	flag;
 
-	unsigned long	base;
+	unsigned long		base;
+	void __iomem		*mmio_base;
 
 	/* mbox64 with mbox not aligned on 16-byte boundry */
 	mbox64_t	*una_mbox64;
_
