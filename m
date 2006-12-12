From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Add support for asynchronous scans to libata
Date: Mon, 11 Dec 2006 22:14:44 -0700
Message-ID: <20061212051444.GH21070@parisc-linux.org>
References: <20061208211236.GC29763@parisc-linux.org> <457D84C9.6020907@pobox.com> <20061212050239.GG21070@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42971 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbWLLFOp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2006 00:14:45 -0500
Content-Disposition: inline
In-Reply-To: <20061212050239.GG21070@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Mon, Dec 11, 2006 at 10:02:40PM -0700, Matthew Wilcox wrote:
> On Mon, Dec 11, 2006 at 11:18:17AM -0500, Jeff Garzik wrote:
> > ACK.  I tried to apply the patch, but git-applymbox choked on every 
> > single file modified.  Quite possibly, its due to a whitespace cleanup 
> > in Alan territory.
> > 
> > If you would either (a) wait several hours for libata-dev.git#upstream 
> > to mirror out, and resend, or (b) supply a git:// URL to pull from, I'll 
> > merge.
> 
> Here's a merge against your upstream head.  It's perhaps more of a
> conceptual merge as it adds entries to drivers that have been added
> since I wrote the patch.  I also added a couple of missing slave_destroy
> methods to the newly-added drivers.
> 
> Signed-off-by: Matthew Wilcox <matthew@wil.cx>

... this time with patch ...

Add support for asynchronous scans to libata
    
Some of the drivers (AHCI was mentioned to me as a culprit) take a long
time to discover all the devices attached to them.  Even for ones which
are relatively quick, if you put a lot of them in a machine, it will
take a long time in aggregate.  This can be fixed by adding support for
asynchronous scsi scans, which causes the time-consuming portions of
initialisation to take place in threads.
    
Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index f36da48..bbbec6d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -242,6 +242,8 @@ static struct scsi_host_template ahci_sht = {
 	.dma_boundary		= AHCI_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 908751d..82c182b 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -116,6 +116,8 @@ static struct scsi_host_template generic_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 7959e4c..0d5b132 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -274,6 +274,8 @@ static struct scsi_host_template piix_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5fffccd..0d80396 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5712,6 +5712,13 @@ static struct ata_port * ata_port_add(const struct ata_probe_ent *ent,
 		return NULL;
 	}
 
+	if (!ent->sht->scan_start) {
+		printk(KERN_WARNING "ata%u: Overriding NULL scan_start\n",
+			port_no);
+		ent->sht->scan_start = ata_scsi_scan_start;
+		ent->sht->scan_finished = ata_scsi_scan_finished;
+	}
+
 	shost = scsi_host_alloc(ent->sht, sizeof(struct ata_port));
 	if (!shost)
 		return NULL;
@@ -5747,6 +5754,51 @@ void ata_host_init(struct ata_host *host, struct device *dev,
 	host->ops = ops;
 }
 
+void ata_scsi_scan_start(struct Scsi_Host *shost)
+{
+	struct ata_port *ap = ata_shost_to_port(shost);
+	int rc;
+
+	if (ap->ops->error_handler) {
+		struct ata_eh_info *ehi = &ap->eh_info;
+		unsigned long flags;
+
+		ata_port_probe(ap);
+
+		/* kick EH for boot probing */
+		spin_lock_irqsave(ap->lock, flags);
+
+		ehi->probe_mask = (1 << ATA_MAX_DEVICES) - 1;
+		ehi->action |= ATA_EH_SOFTRESET;
+		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
+
+		ap->pflags |= ATA_PFLAG_LOADING;
+		ata_port_schedule_eh(ap);
+
+		spin_unlock_irqrestore(ap->lock, flags);
+
+		/* wait for EH to finish */
+		ata_port_wait_eh(ap);
+	} else {
+		DPRINTK("ata%u: bus probe begin\n", ap->id);
+		rc = ata_bus_probe(ap);
+		DPRINTK("ata%u: bus probe end\n", ap->id);
+
+		if (rc) {
+			/* FIXME: do something useful here?
+			 * Current libata behavior will tear down everything
+			 * when the module is removed or the h/w is unplugged.
+			 */
+		}
+	}
+}
+
+int ata_scsi_scan_finished(struct Scsi_Host *shost, unsigned long time)
+{
+	ata_scsi_scan_host(ata_shost_to_port(shost));
+	return 1;
+}
+
 /**
  *	ata_device_add - Register hardware device with ATA and SCSI layers
  *	@ent: Probe information describing hardware device to be registered
@@ -5863,7 +5915,6 @@ int ata_device_add(const struct ata_probe_ent *ent)
 		}
 	}
 
-	/* perform each probe synchronously */
 	DPRINTK("probe begin\n");
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
@@ -5887,48 +5938,7 @@ int ata_device_add(const struct ata_probe_ent *ent)
 			 */
 		}
 
-		if (ap->ops->error_handler) {
-			struct ata_eh_info *ehi = &ap->eh_info;
-			unsigned long flags;
-
-			ata_port_probe(ap);
-
-			/* kick EH for boot probing */
-			spin_lock_irqsave(ap->lock, flags);
-
-			ehi->probe_mask = (1 << ATA_MAX_DEVICES) - 1;
-			ehi->action |= ATA_EH_SOFTRESET;
-			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
-
-			ap->pflags |= ATA_PFLAG_LOADING;
-			ata_port_schedule_eh(ap);
-
-			spin_unlock_irqrestore(ap->lock, flags);
-
-			/* wait for EH to finish */
-			ata_port_wait_eh(ap);
-		} else {
-			DPRINTK("ata%u: bus probe begin\n", ap->id);
-			rc = ata_bus_probe(ap);
-			DPRINTK("ata%u: bus probe end\n", ap->id);
-
-			if (rc) {
-				/* FIXME: do something useful here?
-				 * Current libata behavior will
-				 * tear down everything when
-				 * the module is removed
-				 * or the h/w is unplugged.
-				 */
-			}
-		}
-	}
-
-	/* probes are done, now scan each port's disk(s) */
-	DPRINTK("host probe begin\n");
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		ata_scsi_scan_host(ap);
+		scsi_scan_host(ap->scsi_host);
 	}
 
 	dev_set_drvdata(dev, host);
@@ -6448,6 +6458,8 @@ EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_destroy);
+EXPORT_SYMBOL_GPL(ata_scsi_scan_start);
+EXPORT_SYMBOL_GPL(ata_scsi_scan_finished);
 EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
 EXPORT_SYMBOL_GPL(ata_scsi_release);
 EXPORT_SYMBOL_GPL(ata_host_intr);
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 2035417..3d9d69b 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -344,6 +344,8 @@ static struct scsi_host_template ali_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index a6b3300..764d231 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -333,6 +333,8 @@ static struct scsi_host_template amd_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 37bc132..6e16901 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -314,6 +314,8 @@ static struct scsi_host_template artop_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 6f6672c..cb0a2e0 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -216,6 +216,8 @@ static struct scsi_host_template atiixp_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 15841a5..ac014c9 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -275,6 +275,8 @@ static struct scsi_host_template cmd64x_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 476b879..71c04e5 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -166,6 +166,8 @@ static struct scsi_host_template cs5520_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 9b9d911..f1ccfe0 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -180,6 +180,8 @@ static struct scsi_host_template cs5530_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index e3efec4..97fefb2 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -184,6 +184,8 @@ static struct scsi_host_template cs5535_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index e2a9569..dde9ef9 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -135,6 +135,8 @@ static struct scsi_host_template cy82c693_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index edf8a63..6d5eb82 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -233,6 +233,8 @@ static struct scsi_host_template efar_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 8cf167e..db49053 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -337,6 +337,8 @@ static struct scsi_host_template hpt36x_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index e51651b..6347b52 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -775,6 +775,8 @@ static struct scsi_host_template hpt37x_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index f6817b4..4739f3b 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -341,6 +341,8 @@ static struct scsi_host_template hpt3x2n_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index 5caf167..19c0eba 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -118,6 +118,8 @@ static struct scsi_host_template hpt3x3_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index a97d55a..f2bc867 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -34,6 +34,8 @@ static struct scsi_host_template isapnp_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 7e9a416..4853d7b 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -245,6 +245,9 @@ static struct scsi_host_template it8213_sht = {
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 0b56ff3..235c230 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -673,6 +673,8 @@ static struct scsi_host_template it821x_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index cb89241..1889158 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -117,6 +117,8 @@ static struct scsi_host_template ixp4xx_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index efb1b6d..7d19bc9 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -135,6 +135,8 @@ static struct scsi_host_template jmicron_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
 };
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index c7d1738..4462b58 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -135,6 +135,8 @@ static struct scsi_host_template legacy_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index af93533..601618d 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -101,6 +101,8 @@ static struct scsi_host_template marvell_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 8b7019a..bc5b802 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -280,6 +280,9 @@ static struct scsi_host_template mpc52xx_ata_sht = {
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 4ccca93..fc6d072 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -166,6 +166,8 @@ static struct scsi_host_template mpiix_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index cf7fe03..08fc7a5 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -61,6 +61,8 @@ static struct scsi_host_template netcell_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index c3032eb..6ffa2e2 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -156,6 +156,8 @@ static struct scsi_host_template ns87410_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 10ac3cc..b2d943e 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -231,6 +231,8 @@ static struct scsi_host_template oldpiix_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index c2988b0..575c4b4 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -178,6 +178,8 @@ static struct scsi_host_template opti_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 80d111c..28a041a 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -359,6 +359,8 @@ static struct scsi_host_template optidma_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 9ed7f58..67236a3 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -69,6 +69,8 @@ static struct scsi_host_template pcmcia_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 76dd1c9..3152b90 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -141,6 +141,8 @@ static struct scsi_host_template pdc2027x_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index ad691b9..3174346 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -269,6 +269,8 @@ static struct scsi_host_template pdc202xx_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 443b1d8..9849893 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -78,6 +78,8 @@ static struct scsi_host_template pata_platform_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 36f621a..7857ef1 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -164,6 +164,8 @@ static struct scsi_host_template qdi_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 065541d..29842cc 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -227,6 +227,8 @@ static struct scsi_host_template radisys_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 3677c64..9167c39 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -90,6 +90,8 @@ static struct scsi_host_template rz1000_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index a3b35bc..3c59b46 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -193,6 +193,8 @@ static struct scsi_host_template sc1200_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 8019197..2406ed7 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -325,6 +325,8 @@ static struct scsi_host_template serverworks_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index ae07f63..c6855e0 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -225,6 +225,8 @@ static struct scsi_host_template sil680_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index c434c4e..45409ad 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -545,6 +545,8 @@ static struct scsi_host_template sis_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index e94f515..4607150 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -237,6 +237,8 @@ static struct scsi_host_template sl82c105_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index a142971..fcc3964 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -192,6 +192,8 @@ static struct scsi_host_template triflex_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 9905fa8..571e66c 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -297,6 +297,8 @@ static struct scsi_host_template via_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index cd5560f..24092b9 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -133,6 +133,8 @@ static struct scsi_host_template winbond_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 9021e34..48950c3 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -152,6 +152,8 @@ static struct scsi_host_template adma_ata_sht = {
 	.dma_boundary		= ADMA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 1b8e0eb..4c101a6 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -390,6 +390,8 @@ static struct scsi_host_template mv_sht = {
 	.dma_boundary		= MV_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 49f8ff2..2dbb89a 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -310,6 +310,8 @@ static struct scsi_host_template nv_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index f055874..f25dba5 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -129,6 +129,8 @@ static struct scsi_host_template pdc_ata_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 710909d..81756e8 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -143,6 +143,8 @@ static struct scsi_host_template qs_ata_sht = {
 	.dma_boundary		= QS_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 7808d03..29b283b 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -180,6 +180,8 @@ static struct scsi_host_template sil_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 5aa288d..8372ce7 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -385,6 +385,8 @@ static struct scsi_host_template sil24_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index c90fb13..feed5ab 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -99,6 +99,8 @@ static struct scsi_host_template sis_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index db32d15..d460417 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -299,6 +299,8 @@ static struct scsi_host_template k2_sata_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 #ifdef CONFIG_PPC_OF
 	.proc_info		= k2_sata_proc_info,
 #endif
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index ae7992d..c964b98 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -192,6 +192,8 @@ static struct scsi_host_template pdc_sata_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 5c603ca..fef5b0a 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -90,6 +90,8 @@ static struct scsi_host_template uli_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 8c2335c..e045ba1 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -106,6 +106,8 @@ static struct scsi_host_template svia_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index e654b99..f28152d 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -279,6 +279,8 @@ static struct scsi_host_template vsc_sata_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 9356322..bdf69a4 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -822,6 +822,8 @@ extern int ata_std_bios_param(struct scsi_device *sdev,
 			      sector_t capacity, int geom[]);
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
+extern void ata_scsi_scan_start(struct Scsi_Host *shost);
+extern int ata_scsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
