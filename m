From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Wed, 1 Aug 2007 14:16:51 -0700
Message-ID: <20070801141651.a746763b.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	<46AE12B6.6090408@garzik.org>
	<46AED656.8070407@gmail.com>
	<1185891382.2750.8.camel@laptopd505.fenrus.org>
	<46AF4B05.4010700@gmail.com>
	<1185898532.2766.2.camel@laptopd505.fenrus.org>
	<46AF7F7E.6060300@gmail.com>
	<46B05109.4080007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46B05109.4080007@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

I was able to duplicate Tejun's problem on an ATAPI device I had here.
this updated patch fixed my problem.  These devices are just setting 
PhyReady (N) and CommWake (W) in Serror on power state changes, ignoring
them seems to be fine, and fixed the problem for me.


Enable Aggressive Link Power management for AHCI controllers.

This patch will set the correct bits to turn on Aggressive
Link Power Management (ALPM) for the ahci driver.  This
will cause the controller and disk to negotiate a lower
power state for the link when there is no activity (see
the AHCI 1.x spec for details).  This feature is mutually
exclusive with Hot Plug, so when ALPM is enabled, Hot Plug
is disabled.  ALPM will be enabled by default, but it is
settable via the scsi host syfs interface.  Possible 
settings for this feature are:

Setting		Effect
----------------------------------------------------------
min_power	ALPM is enabled, and link set to enter 
		lowest power state (SLUMBER) when idle
		Hot plug not allowed.

max_performance	ALPM is disabled, Hot Plug is allowed

medium_power	ALPM is enabled, and link set to enter
		second lowest power state (PARTIAL) when
		idle.  Hot plug not allowed.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/ata/ahci.c
===================================================================
--- 2.6-git.orig/drivers/ata/ahci.c
+++ 2.6-git/drivers/ata/ahci.c
@@ -48,6 +48,9 @@
 #define DRV_NAME	"ahci"
 #define DRV_VERSION	"2.3"
 
+static int ahci_enable_alpm(struct ata_port *ap,
+		enum link_pm policy);
+static int ahci_disable_alpm(struct ata_port *ap);
 
 enum {
 	AHCI_PCI_BAR		= 5,
@@ -98,6 +101,7 @@ enum {
 	/* HOST_CAP bits */
 	HOST_CAP_SSC		= (1 << 14), /* Slumber capable */
 	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
+	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
 	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
 	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
 	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
@@ -153,6 +157,8 @@ enum {
 				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
 
 	/* PORT_CMD bits */
+	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
+	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
 	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
@@ -244,6 +250,11 @@ static int ahci_pci_device_suspend(struc
 static int ahci_pci_device_resume(struct pci_dev *pdev);
 #endif
 
+static struct class_device_attribute *ahci_shost_attrs[] = {
+	&class_device_attr_link_power_management_policy,
+	NULL
+};
+
 static struct scsi_host_template ahci_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -261,6 +272,7 @@ static struct scsi_host_template ahci_sh
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
+	.shost_attrs		= ahci_shost_attrs,
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -292,6 +304,8 @@ static const struct ata_port_operations 
 	.port_suspend		= ahci_port_suspend,
 	.port_resume		= ahci_port_resume,
 #endif
+	.enable_pm		= ahci_enable_alpm,
+	.disable_pm		= ahci_disable_alpm,
 
 	.port_start		= ahci_port_start,
 	.port_stop		= ahci_port_stop,
@@ -778,6 +792,156 @@ static void ahci_power_up(struct ata_por
 	writel(cmd | PORT_CMD_ICC_ACTIVE, port_mmio + PORT_CMD);
 }
 
+static int ahci_disable_alpm(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd, scontrol;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	/*
+ 	 * disable Interface Power Management State Transitions
+ 	 * This is accomplished by setting bits 8:11 of the
+ 	 * SATA Control register
+ 	 */
+	scontrol = readl(port_mmio + PORT_SCR_CTL);
+	scontrol |= (0x3 << 8);
+	writel(scontrol, port_mmio + PORT_SCR_CTL);
+
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* disable ALPM and ASP */
+	cmd &= ~PORT_CMD_ASP;
+	cmd &= ~PORT_CMD_ALPE;
+
+	/* force the interface back to active */
+	cmd |= PORT_CMD_ICC_ACTIVE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/* wait 10ms to be sure we've come out of any low power state */
+	msleep(10);
+
+	/* clear out any PhyRdy stuff from interrupt status */
+	writel(PORT_IRQ_PHYRDY, port_mmio + PORT_IRQ_STAT);
+
+	/* go ahead and clean out PhyRdy Change from Serror too */
+	ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+
+	/*
+ 	 * Clear flag to indicate that we should ignore all PhyRdy
+ 	 * state changes
+ 	 */
+	ap->flags &= ~AHCI_FLAG_NO_HOTPLUG;
+
+	/*
+ 	 * Enable interrupts on Phy Ready.
+ 	 */
+	pp->intr_mask |= PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * don't change the link pm policy - we can be called
+ 	 * just to turn of link pm temporarily
+ 	 */
+	return 0;
+}
+
+static int ahci_enable_alpm(struct ata_port *ap,
+	enum link_pm policy)
+{
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd, scontrol, sstatus;
+	struct ahci_port_priv *pp = ap->private_data;
+	u32 asp;
+
+	/* Make sure the host is capable of link power management */
+	if (!(hpriv->cap & HOST_CAP_ALPM)) {
+		ap->pm_policy = NOT_AVAILABLE;
+		return -EINVAL;
+	}
+
+	/* make sure we have a device attached */
+	sstatus = readl(port_mmio + PORT_SCR_STAT);
+	if (!(sstatus & 0xf00)) {
+		ap->pm_policy = NOT_AVAILABLE;
+		return -EINVAL;
+	}
+
+	switch (policy) {
+	case MAX_PERFORMANCE:
+	case NOT_AVAILABLE:
+		/*
+ 		 * if we came here with NOT_AVAILABLE,
+ 		 * it just means this is the first time we
+ 		 * have tried to enable - default to max performance,
+ 		 * and let the user go to lower power modes on request.
+ 		 */
+		ahci_disable_alpm(ap);
+		ap->pm_policy = MAX_PERFORMANCE;
+		return 0;
+	case MIN_POWER:
+		/* configure HBA to enter SLUMBER */
+		asp = PORT_CMD_ASP;
+		break;
+	case MEDIUM_POWER:
+		/* configure HBA to enter PARTIAL */
+		asp = 0;
+		break;
+	default:
+		return -EINVAL;
+	}
+	ap->pm_policy = policy;
+
+	/*
+ 	 * Disable interrupts on Phy Ready. This keeps us from
+ 	 * getting woken up due to spurious phy ready interrupts
+	 * TBD - Hot plug should be done via polling now, is
+	 * that even supported?
+ 	 */
+	pp->intr_mask &= ~PORT_IRQ_PHYRDY;
+	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
+
+	/*
+ 	 * Set a flag to indicate that we should ignore all PhyRdy
+ 	 * state changes since these can happen now whenever we
+ 	 * change link state
+ 	 */
+	ap->flags |= AHCI_FLAG_NO_HOTPLUG;
+
+	/* get the existing command bits */
+	cmd = readl(port_mmio + PORT_CMD);
+
+	/*
+ 	 * enable Interface Power Management State Transitions
+ 	 * This is accomplished by clearing bits 8:11 of the
+ 	 * SATA Control register
+ 	 */
+	scontrol = readl(port_mmio + PORT_SCR_CTL);
+	scontrol &= ~(0x3 << 8);
+	writel(scontrol, port_mmio + PORT_SCR_CTL);
+
+	/*
+ 	 * Set ASP based on Policy
+ 	 */
+	cmd |= asp;
+
+	/*
+ 	 * Setting this bit will instruct the HBA to aggressively
+ 	 * enter a lower power link state when it's appropriate and
+ 	 * based on the value set above for ASP
+ 	 */
+	cmd |= PORT_CMD_ALPE;
+
+	/* write out new cmd value */
+	writel(cmd, port_mmio + PORT_CMD);
+	cmd = readl(port_mmio + PORT_CMD);
+	return 0;
+}
+
 #ifdef CONFIG_PM
 static void ahci_power_down(struct ata_port *ap)
 {
@@ -1355,6 +1519,17 @@ static void ahci_port_intr(struct ata_po
 	status = readl(port_mmio + PORT_IRQ_STAT);
 	writel(status, port_mmio + PORT_IRQ_STAT);
 
+	/* If we are getting PhyRdy, this is
+ 	 * just a power state change, we should
+ 	 * clear out this, plus the PhyRdy/Comm
+ 	 * Wake bits from Serror
+ 	 */
+	if ((ap->flags & AHCI_FLAG_NO_HOTPLUG) &&
+		(status & PORT_IRQ_PHYRDY)) {
+		status &= ~PORT_IRQ_PHYRDY;
+		ahci_scr_write(ap, SCR_ERROR, ((1 << 16) | (1 << 18)));
+	}
+
 	if (unlikely(status & PORT_IRQ_ERROR)) {
 		ahci_error_intr(ap, status);
 		return;
@@ -1861,6 +2036,9 @@ static int ahci_init_one(struct pci_dev 
 		struct ata_port *ap = host->ports[i];
 		void __iomem *port_mmio = ahci_port_base(ap);
 
+		/* set initial link pm policy */
+		ap->pm_policy = NOT_AVAILABLE;
+
 		/* standard SATA port setup */
 		if (hpriv->port_map & (1 << i))
 			ap->ioaddr.cmd_addr = port_mmio;
