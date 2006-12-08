From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Add support for asynchronous scans to libata
Date: Fri, 8 Dec 2006 14:12:36 -0700
Message-ID: <20061208211236.GC29763@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

Some of the drivers (AHCI was mentioned to me as a culprit) take a long
time to discover all the devices attached to them.  Even for ones which
are relatively quick, if you put a lot of them in a machine, it will
take a long time in aggregate.  This can be fixed by adding support for
asynchronous scsi scans, which causes the time-consuming portions of
initialisation to take place in threads.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 234197e..3e39e24 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -237,6 +237,8 @@ static struct scsi_host_template ahci_sh
 	.dma_boundary		= AHCI_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 377425e..a516eb4 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -116,6 +116,8 @@ static struct scsi_host_template generic
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 720174d..101cf75 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -263,6 +263,8 @@ static struct scsi_host_template piix_sh
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.resume			= ata_scsi_device_resume,
 	.suspend		= ata_scsi_device_suspend,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 915a55a..9ece3b7 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5397,6 +5397,13 @@ static struct ata_port * ata_port_add(co
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
@@ -5432,6 +5439,51 @@ void ata_host_init(struct ata_host *host
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
@@ -5549,7 +5601,6 @@ int ata_device_add(const struct ata_prob
 		}
 	}
 
-	/* perform each probe synchronously */
 	DPRINTK("probe begin\n");
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
@@ -5573,48 +5624,7 @@ int ata_device_add(const struct ata_prob
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
@@ -6133,6 +6143,8 @@ EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_destroy);
+EXPORT_SYMBOL_GPL(ata_scsi_scan_start);
+EXPORT_SYMBOL_GPL(ata_scsi_scan_finished);
 EXPORT_SYMBOL_GPL(ata_scsi_change_queue_depth);
 EXPORT_SYMBOL_GPL(ata_scsi_release);
 EXPORT_SYMBOL_GPL(ata_host_intr);
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 1d695df..b10052c 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -346,6 +346,8 @@ static struct scsi_host_template ali_sht
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 5c47a9e..29886f3 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -333,6 +333,8 @@ static struct scsi_host_template amd_sht
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 96a0980..aea075f 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -314,6 +314,8 @@ static struct scsi_host_template artop_s
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 1ce28d2..77b84bd 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -216,6 +216,8 @@ static struct scsi_host_template atiixp_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index b9bbd1d..cb61b80 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -275,6 +275,8 @@ static struct scsi_host_template cmd64x_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 2cd3c0f..e4c21be 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -166,6 +166,8 @@ static struct scsi_host_template cs5520_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index a07cc81..7198fe4 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -180,6 +180,8 @@ static struct scsi_host_template cs5530_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index f8def3f..aada46f 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -184,6 +184,8 @@ static struct scsi_host_template cs5535_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 247b436..2c89f89 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -135,6 +135,8 @@ static struct scsi_host_template cy82c69
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index ef18c60..0b54288 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -233,6 +233,8 @@ static struct scsi_host_template efar_sh
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 6d3e4c0..69460c5 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -329,6 +329,8 @@ static struct scsi_host_template hpt36x_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index fce3fcd..2eefe43 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -775,6 +775,8 @@ static struct scsi_host_template hpt37x_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index 58cfb2b..85db0d1 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -341,6 +341,8 @@ static struct scsi_host_template hpt3x2n
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index 3334d72..4b4eb39 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -118,6 +118,8 @@ static struct scsi_host_template hpt3x3_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index 640b8b0..9243f1f 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -34,6 +34,8 @@ static struct scsi_host_template isapnp_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 18ff3e5..2d3b546 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -675,6 +675,8 @@ static struct scsi_host_template it821x_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 52a2bdf..d8ff9e4 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -136,6 +136,8 @@ static struct scsi_host_template jmicron
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
 };
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 10231ef..aaf9a4b 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -135,6 +135,8 @@ static struct scsi_host_template legacy_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 9dfe3e9..5cf4916 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -166,6 +166,8 @@ static struct scsi_host_template mpiix_s
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index f5672de..8f05a67 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -62,6 +62,8 @@ static struct scsi_host_template netcell
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
 };
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index 2a3dbee..f10b8b5 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -156,6 +156,8 @@ static struct scsi_host_template ns87410
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index fc947df..6b4af88 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -231,6 +231,8 @@ static struct scsi_host_template oldpiix
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index a7320ba..ab6a395 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -202,6 +202,8 @@ static struct scsi_host_template opti_sh
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index c6906b4..dcd0ea1 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -359,6 +359,8 @@ static struct scsi_host_template optidma
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index e93ea27..4bf3d86 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -69,6 +69,8 @@ static struct scsi_host_template pcmcia_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index d894d99..8138bd9 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -141,6 +141,8 @@ static struct scsi_host_template pdc2027
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 5ba9eb2..f9003ae 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -269,6 +269,8 @@ static struct scsi_host_template pdc_sht
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index 2c3cc0c..8f116e8 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -164,6 +164,8 @@ static struct scsi_host_template qdi_sht
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 1af83d7..19b8d5e 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -227,6 +227,8 @@ static struct scsi_host_template radisys
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 4533b63..758c6a7 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -90,6 +90,8 @@ static struct scsi_host_template rz1000_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 067d9d2..71d024d 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -193,6 +193,8 @@ static struct scsi_host_template sc1200_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 5bbf76e..6b67756 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -325,6 +325,8 @@ static struct scsi_host_template serverw
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index 4a2b72b..d277ed9 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -225,6 +225,8 @@ static struct scsi_host_template sil680_
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index b9ffafb..64d13db 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -545,6 +545,8 @@ static struct scsi_host_template sis_sht
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 08a6dc8..56b94e5 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -237,6 +237,8 @@ static struct scsi_host_template sl82c10
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 9640f80..acf464f 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -192,6 +192,8 @@ static struct scsi_host_template triflex
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 1e7be9e..6468fa4 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -295,6 +295,8 @@ static struct scsi_host_template via_sht
 	.proc_name		= DRV_NAME,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 9021e34..48950c3 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -152,6 +152,8 @@ static struct scsi_host_template adma_at
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
@@ -390,6 +390,8 @@ static struct scsi_host_template mv_sht
 	.dma_boundary		= MV_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index d65ebfd..7f8ebd5 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -157,6 +157,8 @@ static struct scsi_host_template nv_sht
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 72eda51..a9ea5ec 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -122,6 +122,8 @@ static struct scsi_host_template pdc_ata
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
@@ -143,6 +143,8 @@ static struct scsi_host_template qs_ata_
 	.dma_boundary		= QS_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index ca8d993..a56e727 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -180,6 +180,8 @@ static struct scsi_host_template sil_sht
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 169e200..7a40c87 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -380,6 +380,8 @@ static struct scsi_host_template sil24_s
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 	.suspend		= ata_scsi_device_suspend,
 	.resume			= ata_scsi_device_resume,
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 9d1235b..366616a 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -96,6 +96,8 @@ static struct scsi_host_template sis_sht
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
@@ -299,6 +299,8 @@ static struct scsi_host_template k2_sata
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
@@ -192,6 +192,8 @@ static struct scsi_host_template pdc_sat
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
@@ -90,6 +90,8 @@ static struct scsi_host_template uli_sht
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 1c7f19a..def7ced 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -106,6 +106,8 @@ static struct scsi_host_template svia_sh
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
@@ -279,6 +279,8 @@ static struct scsi_host_template vsc_sat
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
+	.scan_start		= ata_scsi_scan_start,
+	.scan_finished		= ata_scsi_scan_finished,
 	.bios_param		= ata_std_bios_param,
 };
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index abd2deb..6e2a0dc 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -812,6 +812,8 @@ extern int ata_std_bios_param(struct scs
 			      sector_t capacity, int geom[]);
 extern int ata_scsi_slave_config(struct scsi_device *sdev);
 extern void ata_scsi_slave_destroy(struct scsi_device *sdev);
+extern void ata_scsi_scan_start(struct Scsi_Host *shost);
+extern int ata_scsi_scan_finished(struct Scsi_Host *shost, unsigned long time);
 extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);

