From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 1/4] Store interrupt value
Date: Thu, 5 Jul 2007 13:05:00 -0700
Message-ID: <20070705130500.ad5f7739.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52782 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758021AbXGEUIR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2007 16:08:17 -0400
In-Reply-To: <20070705194909.337398431@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, James.Bottomley@steeleye.com, edwintorok@gmail.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Use a stored value for which interrupts to enable.  Changing this allows
us to selectively turn off certain interrupts later and have them 
stay off.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/ata/ahci.c
===================================================================
--- 2.6-git.orig/drivers/ata/ahci.c
+++ 2.6-git/drivers/ata/ahci.c
@@ -211,6 +211,7 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_d2h:1;
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
+	u32 			intr_mask;	/* interrupts to enable */
 };
 
 static u32 ahci_scr_read (struct ata_port *ap, unsigned int sc_reg);
@@ -1408,6 +1409,7 @@ static void ahci_thaw(struct ata_port *a
 	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
+	struct ahci_port_priv *pp = ap->private_data;
 
 	/* clear IRQ */
 	tmp = readl(port_mmio + PORT_IRQ_STAT);
@@ -1415,7 +1417,7 @@ static void ahci_thaw(struct ata_port *a
 	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
 
 	/* turn IRQ back on */
-	writel(DEF_PORT_IRQ, port_mmio + PORT_IRQ_MASK);
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
 static void ahci_error_handler(struct ata_port *ap)
@@ -1571,6 +1573,12 @@ static int ahci_port_start(struct ata_po
 	pp->cmd_tbl = mem;
 	pp->cmd_tbl_dma = mem_dma;
 
+	/*
+ 	 * Save off initial list of interrupts to be enabled.
+ 	 * This could be changed later
+ 	 */
+	pp->intr_mask = DEF_PORT_IRQ;
+
 	ap->private_data = pp;
 
 	/* power up port */

-- 
