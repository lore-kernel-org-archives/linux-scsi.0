From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/22] libata: kill ATA_FLAG_DISABLED
Date: Tue, 21 Oct 2008 18:17:44 +0900
Message-ID: <1224580680-13698-7-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

ATA_FLAG_DISABLED is only used by drivers which don't use
->error_handler framework and is largely broken.  Its only meaningful
function is to make irq handlers skip processing if the flag is set,
which is largely useless and even harmful as it makes those ports more
likely to cause IRQ storms.

Kill ATA_FLAG_DISABLED and makes the callers disable attached devices
instead.  ata_port_probe() and ata_port_disable() which manipulate the
flag are also killed.

This simplifies condition check in IRQ handlers.  While updating IRQ
handlers, remove ap NULL check as libata guarantees consecutive port
allocation (unoccupied ports are initialized with dummies) and
long-obsolete ATA_QCFLAG_ACTIVE check (checked by ata_qc_from_tag()).

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c           |   66 +----------
 drivers/ata/libata-scsi.c           |    3 -
 drivers/ata/libata-sff.c            |   24 ++---
 drivers/ata/pata_bf54x.c            |   16 +--
 drivers/ata/pdc_adma.c              |   66 +++++------
 drivers/ata/sata_inic162x.c         |   17 +--
 drivers/ata/sata_mv.c               |    8 +-
 drivers/ata/sata_nv.c               |  234 +++++++++++++++++------------------
 drivers/ata/sata_promise.c          |    6 +-
 drivers/ata/sata_qstor.c            |   79 ++++++------
 drivers/ata/sata_sil.c              |    3 -
 drivers/ata/sata_sil24.c            |    9 +-
 drivers/ata/sata_sx4.c              |    4 +-
 drivers/ata/sata_vsc.c              |   10 +--
 drivers/scsi/ipr.c                  |    7 +-
 drivers/scsi/libsas/sas_scsi_host.c |    2 +-
 include/linux/libata.h              |    8 --
 17 files changed, 207 insertions(+), 355 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bbb3cae..231e967 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1821,22 +1821,6 @@ unsigned ata_exec_internal_sg(struct ata_device *dev,
 	ap->qc_active = preempted_qc_active;
 	ap->nr_active_links = preempted_nr_active_links;
 
-	/* XXX - Some LLDDs (sata_mv) disable port on command failure.
-	 * Until those drivers are fixed, we detect the condition
-	 * here, fail the command with AC_ERR_SYSTEM and reenable the
-	 * port.
-	 *
-	 * Note that this doesn't change any behavior as internal
-	 * command failure results in disabling the device in the
-	 * higher layer for LLDDs without new reset/EH callbacks.
-	 *
-	 * Kill the following code as soon as those drivers are fixed.
-	 */
-	if (ap->flags & ATA_FLAG_DISABLED) {
-		err_mask |= AC_ERR_SYSTEM;
-		ata_port_probe(ap);
-	}
-
 	spin_unlock_irqrestore(ap->lock, flags);
 
 	if ((err_mask & AC_ERR_TIMEOUT) && auto_timeout)
@@ -2582,8 +2566,6 @@ int ata_bus_probe(struct ata_port *ap)
 	int rc;
 	struct ata_device *dev;
 
-	ata_port_probe(ap);
-
 	ata_link_for_each_dev(dev, &ap->link)
 		tries[dev->devno] = ATA_PROBE_MAX_TRIES;
 
@@ -2611,8 +2593,7 @@ int ata_bus_probe(struct ata_port *ap)
 	ap->ops->phy_reset(ap);
 
 	ata_link_for_each_dev(dev, &ap->link) {
-		if (!(ap->flags & ATA_FLAG_DISABLED) &&
-		    dev->class != ATA_DEV_UNKNOWN)
+		if (dev->class != ATA_DEV_UNKNOWN)
 			classes[dev->devno] = dev->class;
 		else
 			classes[dev->devno] = ATA_DEV_NONE;
@@ -2620,8 +2601,6 @@ int ata_bus_probe(struct ata_port *ap)
 		dev->class = ATA_DEV_UNKNOWN;
 	}
 
-	ata_port_probe(ap);
-
 	/* read IDENTIFY page and configure devices. We have to do the identify
 	   specific sequence bass-ackwards so that PDIAG- is released by
 	   the slave device */
@@ -2677,8 +2656,6 @@ int ata_bus_probe(struct ata_port *ap)
 		if (ata_dev_enabled(dev))
 			return 0;
 
-	/* no device present, disable port */
-	ata_port_disable(ap);
 	return -ENODEV;
 
  fail:
@@ -2710,22 +2687,6 @@ int ata_bus_probe(struct ata_port *ap)
 }
 
 /**
- *	ata_port_probe - Mark port as enabled
- *	@ap: Port for which we indicate enablement
- *
- *	Modify @ap data structure such that the system
- *	thinks that the entire port is enabled.
- *
- *	LOCKING: host lock, or some other form of
- *	serialization.
- */
-
-void ata_port_probe(struct ata_port *ap)
-{
-	ap->flags &= ~ATA_FLAG_DISABLED;
-}
-
-/**
  *	sata_print_link_status - Print SATA link status
  *	@link: SATA link to printk link status about
  *
@@ -2772,26 +2733,6 @@ struct ata_device *ata_dev_pair(struct ata_device *adev)
 }
 
 /**
- *	ata_port_disable - Disable port.
- *	@ap: Port to be disabled.
- *
- *	Modify @ap data structure such that the system
- *	thinks that the entire port is disabled, and should
- *	never attempt to probe or communicate with devices
- *	on this port.
- *
- *	LOCKING: host lock, or some other form of
- *	serialization.
- */
-
-void ata_port_disable(struct ata_port *ap)
-{
-	ap->link.device[0].class = ATA_DEV_NONE;
-	ap->link.device[1].class = ATA_DEV_NONE;
-	ap->flags |= ATA_FLAG_DISABLED;
-}
-
-/**
  *	sata_down_spd_limit - adjust SATA spd limit downward
  *	@link: Link to adjust SATA spd limit for
  *
@@ -5355,7 +5296,6 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 
 	ap->pflags |= ATA_PFLAG_INITIALIZING;
 	ap->lock = &host->lock;
-	ap->flags = ATA_FLAG_DISABLED;
 	ap->print_id = -1;
 	ap->ctl = ATA_DEVCTL_OBS;
 	ap->host = host;
@@ -5848,8 +5788,6 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 			struct ata_eh_info *ehi = &ap->link.eh_info;
 			unsigned long flags;
 
-			ata_port_probe(ap);
-
 			/* kick EH for boot probing */
 			spin_lock_irqsave(ap->lock, flags);
 
@@ -6469,7 +6407,6 @@ EXPORT_SYMBOL_GPL(ata_port_start);
 EXPORT_SYMBOL_GPL(ata_do_set_mode);
 EXPORT_SYMBOL_GPL(ata_std_qc_defer);
 EXPORT_SYMBOL_GPL(ata_noop_qc_prep);
-EXPORT_SYMBOL_GPL(ata_port_probe);
 EXPORT_SYMBOL_GPL(ata_dev_disable);
 EXPORT_SYMBOL_GPL(sata_set_spd);
 EXPORT_SYMBOL_GPL(ata_wait_after_reset);
@@ -6481,7 +6418,6 @@ EXPORT_SYMBOL_GPL(sata_std_hardreset);
 EXPORT_SYMBOL_GPL(ata_std_postreset);
 EXPORT_SYMBOL_GPL(ata_dev_classify);
 EXPORT_SYMBOL_GPL(ata_dev_pair);
-EXPORT_SYMBOL_GPL(ata_port_disable);
 EXPORT_SYMBOL_GPL(ata_ratelimit);
 EXPORT_SYMBOL_GPL(ata_wait_register);
 EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5d312dc..fd77fcd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3224,9 +3224,6 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 	struct ata_link *link;
 	struct ata_device *dev;
 
-	if (ap->flags & ATA_FLAG_DISABLED)
-		return;
-
  repeat:
 	ata_port_for_each_link(link, ap) {
 		ata_link_for_each_dev(dev, link) {
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index edcd72c..dbb8695 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1640,18 +1640,12 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 	spin_lock_irqsave(&host->lock, flags);
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
-
-		ap = host->ports[i];
-		if (ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct ata_queued_cmd *qc;
+		struct ata_port *ap = host->ports[i];
+		struct ata_queued_cmd *qc;
 
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
-			    (qc->flags & ATA_QCFLAG_ACTIVE))
-				handled |= ata_sff_host_intr(ap, qc);
-		}
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc && !(qc->tf.flags & ATA_TFLAG_POLLING))
+			handled |= ata_sff_host_intr(ap, qc);
 	}
 
 	spin_unlock_irqrestore(&host->lock, flags);
@@ -2340,9 +2334,6 @@ u8 ata_bmdma_status(struct ata_port *ap)
  *	PCI/etc. bus probe sem.
  *	Obtains host lock.
  *
- *	SIDE EFFECTS:
- *	Sets ATA_FLAG_DISABLED if bus reset fails.
- *
  *	DEPRECATED:
  *	This function is only for drivers which still use old EH and
  *	will be removed soon.
@@ -2410,8 +2401,9 @@ void ata_bus_reset(struct ata_port *ap)
 	return;
 
 err_out:
-	ata_port_printk(ap, KERN_ERR, "disabling port\n");
-	ata_port_disable(ap);
+	device[0].class = ATA_DEV_NONE;
+	device[1].class = ATA_DEV_NONE;
+	ata_port_printk(ap, KERN_ERR, "giving up port\n");
 
 	DPRINTK("EXIT\n");
 }
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 1266924..b833328 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1439,18 +1439,12 @@ static irqreturn_t bfin_ata_interrupt(int irq, void *dev_instance)
 	spin_lock_irqsave(&host->lock, flags);
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
+		struct ata_port *ap = host->ports[i];
+		struct ata_queued_cmd *qc;
 
-		ap = host->ports[i];
-		if (ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct ata_queued_cmd *qc;
-
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
-			    (qc->flags & ATA_QCFLAG_ACTIVE))
-				handled |= bfin_ata_host_intr(ap, qc);
-		}
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)))
+			handled |= bfin_ata_host_intr(ap, qc);
 	}
 
 	spin_unlock_irqrestore(&host->lock, flags);
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index be53545..b8cc349 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -439,8 +439,6 @@ static inline unsigned int adma_intr_pkt(struct ata_host *host)
 			continue;
 		handled = 1;
 		adma_enter_reg_mode(ap);
-		if (ap->flags & ATA_FLAG_DISABLED)
-			continue;
 		pp = ap->private_data;
 		if (!pp || pp->state != adma_state_pkt)
 			continue;
@@ -481,42 +479,38 @@ static inline unsigned int adma_intr_mmio(struct ata_host *host)
 	unsigned int handled = 0, port_no;
 
 	for (port_no = 0; port_no < host->n_ports; ++port_no) {
-		struct ata_port *ap;
-		ap = host->ports[port_no];
-		if (ap && (!(ap->flags & ATA_FLAG_DISABLED))) {
-			struct ata_queued_cmd *qc;
-			struct adma_port_priv *pp = ap->private_data;
-			if (!pp || pp->state != adma_state_mmio)
+		struct ata_port *ap = host->ports[port_no];
+		struct adma_port_priv *pp = ap->private_data;
+		struct ata_queued_cmd *qc;
+
+		if (!pp || pp->state != adma_state_mmio)
+			continue;
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
+
+			/* check main status, clearing INTRQ */
+			u8 status = ata_sff_check_status(ap);
+			if ((status & ATA_BUSY))
 				continue;
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
-
-				/* check main status, clearing INTRQ */
-				u8 status = ata_sff_check_status(ap);
-				if ((status & ATA_BUSY))
-					continue;
-				DPRINTK("ata%u: protocol %d (dev_stat 0x%X)\n",
-					ap->print_id, qc->tf.protocol, status);
-
-				/* complete taskfile transaction */
-				pp->state = adma_state_idle;
-				qc->err_mask |= ac_err_mask(status);
-				if (!qc->err_mask)
-					ata_qc_complete(qc);
-				else {
-					struct ata_eh_info *ehi =
-						&ap->link.eh_info;
-					ata_ehi_clear_desc(ehi);
-					ata_ehi_push_desc(ehi,
-						"status 0x%02X", status);
-
-					if (qc->err_mask == AC_ERR_DEV)
-						ata_port_abort(ap);
-					else
-						ata_port_freeze(ap);
-				}
-				handled = 1;
+			DPRINTK("ata%u: protocol %d (dev_stat 0x%X)\n",
+				ap->print_id, qc->tf.protocol, status);
+
+			/* complete taskfile transaction */
+			pp->state = adma_state_idle;
+			qc->err_mask |= ac_err_mask(status);
+			if (!qc->err_mask)
+				ata_qc_complete(qc);
+			else {
+				struct ata_eh_info *ehi = &ap->link.eh_info;
+				ata_ehi_clear_desc(ehi);
+				ata_ehi_push_desc(ehi, "status 0x%02X", status);
+
+				if (qc->err_mask == AC_ERR_DEV)
+					ata_port_abort(ap);
+				else
+					ata_port_freeze(ap);
 			}
+			handled = 1;
 		}
 	}
 	return handled;
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index fbbd87c..9dd7559 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -414,22 +414,11 @@ static irqreturn_t inic_interrupt(int irq, void *dev_instance)
 
 	spin_lock(&host->lock);
 
-	for (i = 0; i < NR_PORTS; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		if (!(host_irq_stat & (HIRQ_PORT0 << i)))
-			continue;
-
-		if (likely(ap && !(ap->flags & ATA_FLAG_DISABLED))) {
-			inic_host_intr(ap);
+	for (i = 0; i < NR_PORTS; i++)
+		if (host_irq_stat & (HIRQ_PORT0 << i)) {
+			inic_host_intr(host->ports[i]);
 			handled++;
-		} else {
-			if (ata_ratelimit())
-				dev_printk(KERN_ERR, host->dev, "interrupt "
-					   "from disabled port %d (0x%x)\n",
-					   i, host_irq_stat);
 		}
-	}
 
 	spin_unlock(&host->lock);
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 92f3ad8..13368cb 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1818,9 +1818,7 @@ static void mv_unexpected_intr(struct ata_port *ap, int edma_was_enabled)
 	char *when = "idle";
 
 	ata_ehi_clear_desc(ehi);
-	if (!ap || (ap->flags & ATA_FLAG_DISABLED)) {
-		when = "disabled";
-	} else if (edma_was_enabled) {
+	if (edma_was_enabled) {
 		when = "EDMA enabled";
 	} else {
 		struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->link.active_tag);
@@ -2055,10 +2053,6 @@ static void mv_port_intr(struct ata_port *ap, u32 port_cause)
 	struct mv_port_priv *pp;
 	int edma_was_enabled;
 
-	if (!ap || (ap->flags & ATA_FLAG_DISABLED)) {
-		mv_unexpected_intr(ap, 0);
-		return;
-	}
 	/*
 	 * Grab a snapshot of the EDMA_EN flag setting,
 	 * so that we have a consistent view for this port,
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index fae3841..521dcd3 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -879,107 +879,107 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
+		struct nv_adma_port_priv *pp = ap->private_data;
+		void __iomem *mmio = pp->ctl_block;
+		u16 status;
+		u32 gen_ctl;
+		u32 notifier, notifier_error;
+
 		notifier_clears[i] = 0;
 
-		if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct nv_adma_port_priv *pp = ap->private_data;
-			void __iomem *mmio = pp->ctl_block;
-			u16 status;
-			u32 gen_ctl;
-			u32 notifier, notifier_error;
-
-			/* if ADMA is disabled, use standard ata interrupt handler */
-			if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
-				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
-					>> (NV_INT_PORT_SHIFT * i);
-				handled += nv_host_intr(ap, irq_stat);
-				continue;
-			}
+		/* if ADMA is disabled, use standard ata interrupt handler */
+		if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
+			u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
+				>> (NV_INT_PORT_SHIFT * i);
+			handled += nv_host_intr(ap, irq_stat);
+			continue;
+		}
 
-			/* if in ATA register mode, check for standard interrupts */
-			if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
-				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
-					>> (NV_INT_PORT_SHIFT * i);
-				if (ata_tag_valid(ap->link.active_tag))
-					/** NV_INT_DEV indication seems unreliable at times
-					    at least in ADMA mode. Force it on always when a
-					    command is active, to prevent losing interrupts. */
-					irq_stat |= NV_INT_DEV;
-				handled += nv_host_intr(ap, irq_stat);
-			}
+		/* if in ATA register mode, check for standard interrupts */
+		if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
+			u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
+				>> (NV_INT_PORT_SHIFT * i);
+			if (ata_tag_valid(ap->link.active_tag))
+				/** NV_INT_DEV indication seems unreliable
+				    at times at least in ADMA mode. Force it
+				    on always when a command is active, to
+				    prevent losing interrupts. */
+				irq_stat |= NV_INT_DEV;
+			handled += nv_host_intr(ap, irq_stat);
+		}
+
+		notifier = readl(mmio + NV_ADMA_NOTIFIER);
+		notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
+		notifier_clears[i] = notifier | notifier_error;
+
+		gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
+
+		if (!NV_ADMA_CHECK_INTR(gen_ctl, ap->port_no) && !notifier &&
+		    !notifier_error)
+			/* Nothing to do */
+			continue;
+
+		status = readw(mmio + NV_ADMA_STAT);
+
+		/* Clear status. Ensure the controller sees the clearing
+		   before we start looking at any of the CPB statuses, so
+		   that any CPB completions after this point in the handler
+		   will raise another interrupt. */
+		writew(status, mmio + NV_ADMA_STAT);
+		readw(mmio + NV_ADMA_STAT); /* flush posted write */
+		rmb();
+
+		handled++; /* irq handled if we got here */
+
+		/* freeze if hotplugged or controller error */
+		if (unlikely(status & (NV_ADMA_STAT_HOTPLUG |
+				       NV_ADMA_STAT_HOTUNPLUG |
+				       NV_ADMA_STAT_TIMEOUT |
+				       NV_ADMA_STAT_SERROR))) {
+			struct ata_eh_info *ehi = &ap->link.eh_info;
 
-			notifier = readl(mmio + NV_ADMA_NOTIFIER);
-			notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
-			notifier_clears[i] = notifier | notifier_error;
-
-			gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
-
-			if (!NV_ADMA_CHECK_INTR(gen_ctl, ap->port_no) && !notifier &&
-			    !notifier_error)
-				/* Nothing to do */
-				continue;
-
-			status = readw(mmio + NV_ADMA_STAT);
-
-			/* Clear status. Ensure the controller sees the clearing before we start
-			   looking at any of the CPB statuses, so that any CPB completions after
-			   this point in the handler will raise another interrupt. */
-			writew(status, mmio + NV_ADMA_STAT);
-			readw(mmio + NV_ADMA_STAT); /* flush posted write */
-			rmb();
-
-			handled++; /* irq handled if we got here */
-
-			/* freeze if hotplugged or controller error */
-			if (unlikely(status & (NV_ADMA_STAT_HOTPLUG |
-					       NV_ADMA_STAT_HOTUNPLUG |
-					       NV_ADMA_STAT_TIMEOUT |
-					       NV_ADMA_STAT_SERROR))) {
-				struct ata_eh_info *ehi = &ap->link.eh_info;
-
-				ata_ehi_clear_desc(ehi);
-				__ata_ehi_push_desc(ehi, "ADMA status 0x%08x: ", status);
-				if (status & NV_ADMA_STAT_TIMEOUT) {
-					ehi->err_mask |= AC_ERR_SYSTEM;
-					ata_ehi_push_desc(ehi, "timeout");
-				} else if (status & NV_ADMA_STAT_HOTPLUG) {
-					ata_ehi_hotplugged(ehi);
-					ata_ehi_push_desc(ehi, "hotplug");
-				} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
-					ata_ehi_hotplugged(ehi);
-					ata_ehi_push_desc(ehi, "hot unplug");
-				} else if (status & NV_ADMA_STAT_SERROR) {
-					/* let libata analyze SError and figure out the cause */
-					ata_ehi_push_desc(ehi, "SError");
-				} else
-					ata_ehi_push_desc(ehi, "unknown");
-				ata_port_freeze(ap);
-				continue;
+			ata_ehi_clear_desc(ehi);
+			__ata_ehi_push_desc(ehi, "ADMA status 0x%08x: ", status);
+			if (status & NV_ADMA_STAT_TIMEOUT) {
+				ehi->err_mask |= AC_ERR_SYSTEM;
+				ata_ehi_push_desc(ehi, "timeout");
+			} else if (status & NV_ADMA_STAT_HOTPLUG) {
+				ata_ehi_hotplugged(ehi);
+				ata_ehi_push_desc(ehi, "hotplug");
+			} else if (status & NV_ADMA_STAT_HOTUNPLUG) {
+				ata_ehi_hotplugged(ehi);
+				ata_ehi_push_desc(ehi, "hot unplug");
+			} else if (status & NV_ADMA_STAT_SERROR) {
+				/* let libata analyze SError and figure out
+				   the cause */
+				ata_ehi_push_desc(ehi, "SError");
+			} else
+				ata_ehi_push_desc(ehi, "unknown");
+			ata_port_freeze(ap);
+			continue;
+		}
+
+		if (status & (NV_ADMA_STAT_DONE |
+			      NV_ADMA_STAT_CPBERR |
+			      NV_ADMA_STAT_CMD_COMPLETE)) {
+			u32 check_commands = notifier_clears[i];
+			int pos, error = 0;
+
+			if (status & NV_ADMA_STAT_CPBERR) {
+				/* Check all active commands */
+				if (ata_tag_valid(ap->link.active_tag))
+					check_commands = 1 <<
+						ap->link.active_tag;
+				else
+					check_commands = ap->link.sactive;
 			}
 
-			if (status & (NV_ADMA_STAT_DONE |
-				      NV_ADMA_STAT_CPBERR |
-				      NV_ADMA_STAT_CMD_COMPLETE)) {
-				u32 check_commands = notifier_clears[i];
-				int pos, error = 0;
-
-				if (status & NV_ADMA_STAT_CPBERR) {
-					/* Check all active commands */
-					if (ata_tag_valid(ap->link.active_tag))
-						check_commands = 1 <<
-							ap->link.active_tag;
-					else
-						check_commands = ap->
-							link.sactive;
-				}
-
-				/** Check CPBs for completed commands */
-				while ((pos = ffs(check_commands)) && !error) {
-					pos--;
-					error = nv_adma_check_cpb(ap, pos,
+			/** Check CPBs for completed commands */
+			while ((pos = ffs(check_commands)) && !error) {
+				pos--;
+				error = nv_adma_check_cpb(ap, pos,
 						notifier_error & (1 << pos));
-					check_commands &= ~(1 << pos);
-				}
+				check_commands &= ~(1 << pos);
 			}
 		}
 	}
@@ -1444,22 +1444,16 @@ static irqreturn_t nv_generic_interrupt(int irq, void *dev_instance)
 	spin_lock_irqsave(&host->lock, flags);
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
-
-		ap = host->ports[i];
-		if (ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct ata_queued_cmd *qc;
-
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)))
-				handled += ata_sff_host_intr(ap, qc);
-			else
-				// No request pending?  Clear interrupt status
-				// anyway, in case there's one pending.
-				ap->ops->sff_check_status(ap);
-		}
+		struct ata_port *ap = host->ports[i];
+		struct ata_queued_cmd *qc;
 
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)))
+			handled += ata_sff_host_intr(ap, qc);
+		else
+			// No request pending?  Clear interrupt status
+			// anyway, in case there's one pending.
+			ap->ops->sff_check_status(ap);
 	}
 
 	spin_unlock_irqrestore(&host->lock, flags);
@@ -1472,11 +1466,7 @@ static irqreturn_t nv_do_interrupt(struct ata_host *host, u8 irq_stat)
 	int i, handled = 0;
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		if (ap && !(ap->flags & ATA_FLAG_DISABLED))
-			handled += nv_host_intr(ap, irq_stat);
-
+		handled += nv_host_intr(host->ports[i], irq_stat);
 		irq_stat >>= NV_INT_PORT_SHIFT;
 	}
 
@@ -2309,16 +2299,14 @@ static irqreturn_t nv_swncq_interrupt(int irq, void *dev_instance)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-			if (ap->link.sactive) {
-				nv_swncq_host_interrupt(ap, (u16)irq_stat);
-				handled = 1;
-			} else {
-				if (irq_stat)	/* reserve Hotplug */
-					nv_swncq_irq_clear(ap, 0xfff0);
+		if (ap->link.sactive) {
+			nv_swncq_host_interrupt(ap, (u16)irq_stat);
+			handled = 1;
+		} else {
+			if (irq_stat)	/* reserve Hotplug */
+				nv_swncq_irq_clear(ap, 0xfff0);
 
-				handled += nv_host_intr(ap, (u8)irq_stat);
-			}
+			handled += nv_host_intr(ap, (u8)irq_stat);
 		}
 		irq_stat >>= NV_INT_PORT_SHIFT_MCP55;
 	}
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 750d8cd..3c440e5 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -844,8 +844,7 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 		/* check for a plug or unplug event */
 		ata_no = pdc_port_no_to_ata_no(i, is_sataii_tx4);
 		tmp = hotplug_status & (0x11 << ata_no);
-		if (tmp && ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
+		if (tmp) {
 			struct ata_eh_info *ehi = &ap->link.eh_info;
 			ata_ehi_clear_desc(ehi);
 			ata_ehi_hotplugged(ehi);
@@ -857,8 +856,7 @@ static irqreturn_t pdc_interrupt(int irq, void *dev_instance)
 
 		/* check for a packet interrupt */
 		tmp = mask & (1 << (i + 1));
-		if (tmp && ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
+		if (tmp) {
 			struct ata_queued_cmd *qc;
 
 			qc = ata_qc_from_tag(ap, ap->link.active_tag);
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index a000c86..48a3756 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -402,26 +402,24 @@ static inline unsigned int qs_intr_pkt(struct ata_host *host)
 			u8 sHST = sff1 & 0x3f;	/* host status */
 			unsigned int port_no = (sff1 >> 8) & 0x03;
 			struct ata_port *ap = host->ports[port_no];
+			struct qs_port_priv *pp = ap->private_data;
+			struct ata_queued_cmd *qc;
 
 			DPRINTK("SFF=%08x%08x: sCHAN=%u sHST=%d sDST=%02x\n",
 					sff1, sff0, port_no, sHST, sDST);
 			handled = 1;
-			if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-				struct ata_queued_cmd *qc;
-				struct qs_port_priv *pp = ap->private_data;
-				if (!pp || pp->state != qs_state_pkt)
-					continue;
-				qc = ata_qc_from_tag(ap, ap->link.active_tag);
-				if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
-					switch (sHST) {
-					case 0: /* successful CPB */
-					case 3: /* device error */
-						qs_enter_reg_mode(qc->ap);
-						qs_do_or_die(qc, sDST);
-						break;
-					default:
-						break;
-					}
+			if (!pp || pp->state != qs_state_pkt)
+				continue;
+			qc = ata_qc_from_tag(ap, ap->link.active_tag);
+			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING))) {
+				switch (sHST) {
+				case 0: /* successful CPB */
+				case 3: /* device error */
+					qs_enter_reg_mode(qc->ap);
+					qs_do_or_die(qc, sDST);
+					break;
+				default:
+					break;
 				}
 			}
 		}
@@ -434,33 +432,30 @@ static inline unsigned int qs_intr_mmio(struct ata_host *host)
 	unsigned int handled = 0, port_no;
 
 	for (port_no = 0; port_no < host->n_ports; ++port_no) {
-		struct ata_port *ap;
-		ap = host->ports[port_no];
-		if (ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct ata_queued_cmd *qc;
-			struct qs_port_priv *pp;
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (!qc || !(qc->flags & ATA_QCFLAG_ACTIVE)) {
-				/*
-				 * The qstor hardware generates spurious
-				 * interrupts from time to time when switching
-				 * in and out of packet mode.
-				 * There's no obvious way to know if we're
-				 * here now due to that, so just ack the irq
-				 * and pretend we knew it was ours.. (ugh).
-				 * This does not affect packet mode.
-				 */
-				ata_sff_check_status(ap);
-				handled = 1;
-				continue;
-			}
-			pp = ap->private_data;
-			if (!pp || pp->state != qs_state_mmio)
-				continue;
-			if (!(qc->tf.flags & ATA_TFLAG_POLLING))
-				handled |= ata_sff_host_intr(ap, qc);
+		struct ata_port *ap = host->ports[port_no];
+		struct qs_port_priv *pp = ap->private_data;
+		struct ata_queued_cmd *qc;
+
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (!qc) {
+			/*
+			 * The qstor hardware generates spurious
+			 * interrupts from time to time when switching
+			 * in and out of packet mode.  There's no
+			 * obvious way to know if we're here now due
+			 * to that, so just ack the irq and pretend we
+			 * knew it was ours.. (ugh).  This does not
+			 * affect packet mode.
+			 */
+			ata_sff_check_status(ap);
+			handled = 1;
+			continue;
 		}
+
+		if (!pp || pp->state != qs_state_mmio)
+			continue;
+		if (!(qc->tf.flags & ATA_TFLAG_POLLING))
+			handled |= ata_sff_host_intr(ap, qc);
 	}
 	return handled;
 }
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 031d7b7..dce3b91 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -439,9 +439,6 @@ static irqreturn_t sil_interrupt(int irq, void *dev_instance)
 		struct ata_port *ap = host->ports[i];
 		u32 bmdma2 = readl(mmio_base + sil_port[ap->port_no].bmdma2);
 
-		if (unlikely(!ap || ap->flags & ATA_FLAG_DISABLED))
-			continue;
-
 		/* turn off SATA_IRQ if not supported */
 		if (ap->flags & SIL_FLAG_NO_SATA_IRQ)
 			bmdma2 &= ~SIL_DMA_SATA_IRQ;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 4621807..e9e66e2 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -1151,13 +1151,8 @@ static irqreturn_t sil24_interrupt(int irq, void *dev_instance)
 
 	for (i = 0; i < host->n_ports; i++)
 		if (status & (1 << i)) {
-			struct ata_port *ap = host->ports[i];
-			if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-				sil24_host_intr(ap);
-				handled++;
-			} else
-				printk(KERN_ERR DRV_NAME
-				       ": interrupt from disabled port %d\n", i);
+			sil24_host_intr(host->ports[i]);
+			handled++;
 		}
 
 	spin_unlock(&host->lock);
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index ec04b8d..8027f64 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -314,7 +314,6 @@ static void pdc_20621_phy_reset(struct ata_port *ap)
 {
 	VPRINTK("ENTER\n");
 	ap->cbl = ATA_CBL_SATA;
-	ata_port_probe(ap);
 	ata_bus_reset(ap);
 }
 
@@ -839,8 +838,7 @@ static irqreturn_t pdc20621_interrupt(int irq, void *dev_instance)
 			ap = host->ports[port_no];
 		tmp = mask & (1 << i);
 		VPRINTK("seq %u, port_no %u, ap %p, tmp %x\n", i, port_no, ap, tmp);
-		if (tmp && ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
+		if (tmp && ap) {
 			struct ata_queued_cmd *qc;
 
 			qc = ata_qc_from_tag(ap, ap->link.active_tag);
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index c57cdff..45bd21c 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -284,14 +284,8 @@ static irqreturn_t vsc_sata_interrupt(int irq, void *dev_instance)
 	for (i = 0; i < host->n_ports; i++) {
 		u8 port_status = (status >> (8 * i)) & 0xff;
 		if (port_status) {
-			struct ata_port *ap = host->ports[i];
-
-			if (ap && !(ap->flags & ATA_FLAG_DISABLED)) {
-				vsc_port_intr(port_status, ap);
-				handled++;
-			} else
-				dev_printk(KERN_ERR, host->dev,
-					"interrupt from disabled port %d\n", i);
+			vsc_port_intr(port_status, host->ports[i]);
+			handled++;
 		}
 	}
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 098739d..8ca7bd4 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3637,7 +3637,7 @@ static void ipr_slave_destroy(struct scsi_device *sdev)
 	res = (struct ipr_resource_entry *) sdev->hostdata;
 	if (res) {
 		if (res->sata_port)
-			ata_port_disable(res->sata_port->ap);
+			res->sata_port->ap->link.device[0].class = ATA_DEV_NONE;
 		sdev->hostdata = NULL;
 		res->sdev = NULL;
 		res->sata_port = NULL;
@@ -5001,7 +5001,7 @@ static void ipr_ata_phy_reset(struct ata_port *ap)
 	rc = ipr_device_reset(ioa_cfg, res);
 
 	if (rc) {
-		ata_port_disable(ap);
+		ap->link.device[0].class = ATA_DEV_NONE;
 		goto out_unlock;
 	}
 
@@ -5015,8 +5015,7 @@ static void ipr_ata_phy_reset(struct ata_port *ap)
 		ap->link.device[0].class = ATA_DEV_ATAPI;
 		break;
 	default:
-		ap->link.device[0].class = ATA_DEV_UNKNOWN;
-		ata_port_disable(ap);
+		ap->link.device[0].class = ATA_DEV_NONE;
 		break;
 	};
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 7448387..cca1f1e 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -817,7 +817,7 @@ void sas_slave_destroy(struct scsi_device *scsi_dev)
 	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
 
 	if (dev_is_sata(dev))
-		ata_port_disable(dev->sata_dev.ap);
+		dev->sata_dev.ap->link.device[0].class = ATA_DEV_NONE;
 }
 
 int sas_change_queue_depth(struct scsi_device *scsi_dev, int new_depth)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c261aa0..e0b8c24 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -199,12 +199,6 @@ enum {
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
 					      * led */
 
-	/* The following flag belongs to ap->pflags but is kept in
-	 * ap->flags because it's referenced in many LLDs and will be
-	 * removed in not-too-distant future.
-	 */
-	ATA_FLAG_DISABLED	= (1 << 23), /* port is disabled, ignore it */
-
 	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
 
 	/* struct ata_port pflags */
@@ -888,7 +882,6 @@ static inline int ata_port_is_dummy(struct ata_port *ap)
 	return ap->ops == &ata_dummy_port_ops;
 }
 
-extern void ata_port_probe(struct ata_port *);
 extern int sata_set_spd(struct ata_link *link);
 extern int ata_std_prereset(struct ata_link *link, unsigned long deadline);
 extern int ata_wait_after_reset(struct ata_link *link, unsigned long deadline,
@@ -903,7 +896,6 @@ extern int sata_link_hardreset(struct ata_link *link,
 extern int sata_std_hardreset(struct ata_link *link, unsigned int *class,
 			      unsigned long deadline);
 extern void ata_std_postreset(struct ata_link *link, unsigned int *classes);
-extern void ata_port_disable(struct ata_port *);
 
 extern struct ata_host *ata_host_alloc(struct device *dev, int max_ports);
 extern struct ata_host *ata_host_alloc_pinfo(struct device *dev,
-- 
1.5.4.5

