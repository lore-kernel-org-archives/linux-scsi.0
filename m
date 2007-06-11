From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 1/3] Store interrupt value
Date: Mon, 11 Jun 2007 11:48:10 -0700
Message-ID: <20070611114810.f918bc1d.kristen.c.accardi@intel.com>
References: <20070611184146.448266229@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070611184146.448266229@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, james.bottomley@steeleye.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, arjan@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

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
@@ -1384,6 +1385,7 @@ static void ahci_thaw(struct ata_port *a
 	void __iomem *mmio = ap->host->iomap[AHCI_PCI_BAR];
 	void __iomem *port_mmio = ahci_port_base(ap);
 	u32 tmp;
+	struct ahci_port_priv *pp = ap->private_data;
 
 	/* clear IRQ */
 	tmp = readl(port_mmio + PORT_IRQ_STAT);
@@ -1391,7 +1393,7 @@ static void ahci_thaw(struct ata_port *a
 	writel(1 << ap->port_no, mmio + HOST_IRQ_STAT);
 
 	/* turn IRQ back on */
-	writel(DEF_PORT_IRQ, port_mmio + PORT_IRQ_MASK);
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
 
 static void ahci_error_handler(struct ata_port *ap)
@@ -1547,6 +1549,12 @@ static int ahci_port_start(struct ata_po
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
