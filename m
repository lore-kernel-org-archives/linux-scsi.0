From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 21/21] advansys: Changes to work on parisc
Date: Tue,  2 Oct 2007 21:55:42 -0400
Message-ID: <11913765432770-git-send-email-matthew@wil.cx>
References: <11913765421743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:45206 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbXJCBzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 21:55:49 -0400
In-Reply-To: <11913765421743-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

Change PortAddr to be an unsigned int instead of an unsigned short (IO
Port address are 24 bit on parisc).  Fix a couple of printk argument
warnings.  Remove the Kconfig marking as 'BROKEN'.

I haven't removed the #warning yet because virt_to_bus/bus_to_virt are
only eliminated for narrow boards.  Wide boards need more work.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/Kconfig    |    1 -
 drivers/scsi/advansys.c |   10 +++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 69b2fac..de6a641 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -521,7 +521,6 @@ config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI
 	depends on ISA || EISA || PCI
-	depends on BROKEN || X86_32
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 8e39df5..bc0f2e5 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -120,7 +120,7 @@ typedef unsigned char uchar;
 #define CC_VERY_LONG_SG_LIST 0
 #define ASC_SRB2SCSIQ(srb_ptr)  (srb_ptr)
 
-#define PortAddr                 unsigned short	/* port address size  */
+#define PortAddr                 unsigned int	/* port address size  */
 #define inp(port)                inb(port)
 #define outp(port, byte)         outb((byte), (port))
 
@@ -13333,8 +13333,8 @@ static int __devinit advansys_wide_init_chip(struct Scsi_Host *shost)
 
 	}
 
-	ASC_DBG(1, "sg_cnt %d * %u = %u bytes\n", sg_cnt, sizeof(adv_sgblk_t),
-		 (unsigned)(sizeof(adv_sgblk_t) * sg_cnt));
+	ASC_DBG(1, "sg_cnt %d * %lu = %lu bytes\n", sg_cnt, sizeof(adv_sgblk_t),
+		 sizeof(adv_sgblk_t) * sg_cnt);
 
 	if (!board->adv_sgblkp)
 		goto kmalloc_failed;
@@ -13428,9 +13428,9 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		boardp->ioremap_addr = ioremap(pci_resource_start(pdev, 1),
 					       boardp->asc_n_io_port);
 		if (!boardp->ioremap_addr) {
-			shost_printk(KERN_ERR, shost, "ioremap(%x, %d) "
+			shost_printk(KERN_ERR, shost, "ioremap(%lx, %d) "
 					"returned NULL\n",
-					pci_resource_start(pdev, 1),
+					(long)pci_resource_start(pdev, 1),
 					boardp->asc_n_io_port);
 			ret = -ENODEV;
 			goto err_shost;
-- 
1.5.3.1

