From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH 3/3] faster workaround
Date: Thu, 11 Oct 2007 14:33:23 +0200
Message-ID: <200710111433.23833.bs@q-leap.de>
References: <200710081709.18253.bs@q-leap.de> <200710101112.20448.bs@q-leap.de> <200710111409.56210.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:49888 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbXJKMd1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 08:33:27 -0400
In-Reply-To: <200710111409.56210.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This is based on a patch from Jeff from 2004, but backported to 2.6.23 and 
furthermore, it will use the 7.5kiB/512B splitoff for blacklisted drives 
only.

Jeff, why did you replace ATA_SHT_USE_CLUSTERING and ATA_DMA_BOUNDARY?

 drivers/ata/libata-core.c |    9 ++++-
 drivers/ata/sata_sil.c    |   58 ++++++++++++++++++++++++++++++------
 include/linux/libata.h    |    6 +++
 3 files changed, 62 insertions(+), 11 deletions(-)

Signed-off-by: Bernd Schubert <bs@q-leap.de>


Index: linux-2.6.23-rc9/drivers/ata/libata-core.c
===================================================================
--- linux-2.6.23-rc9.orig/drivers/ata/libata-core.c	2007-10-02 
17:21:12.000000000 +0200
+++ linux-2.6.23-rc9/drivers/ata/libata-core.c	2007-10-11 10:46:18.000000000 
+0200
@@ -4073,7 +4073,7 @@ void ata_sg_clean(struct ata_queued_cmd 
  *	spin_lock_irqsave(host lock)
  *
  */
-static void ata_fill_sg(struct ata_queued_cmd *qc)
+void ata_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
@@ -4217,10 +4217,15 @@ int ata_check_atapi_dma(struct ata_queue
  */
 void ata_qc_prep(struct ata_queued_cmd *qc)
 {
+	struct ata_port *ap = qc->ap;
+
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
 		return;
 
-	ata_fill_sg(qc);
+	if (ap->ops->fill_sg)
+		ap->ops->fill_sg(qc);
+	else
+		ata_fill_sg(qc);
 }
 
 /**
Index: linux-2.6.23-rc9/drivers/ata/sata_sil.c
===================================================================
--- linux-2.6.23-rc9.orig/drivers/ata/sata_sil.c	2007-10-11 10:45:08.000000000 
+0200
+++ linux-2.6.23-rc9/drivers/ata/sata_sil.c	2007-10-11 10:57:51.000000000 
+0200
@@ -120,6 +120,7 @@ static int sil_scr_write(struct ata_port
 static int sil_set_mode (struct ata_port *ap, struct ata_device **r_failed);
 static void sil_freeze(struct ata_port *ap);
 static void sil_thaw(struct ata_port *ap);
+static void sil_fill_sg(struct ata_queued_cmd *qc);
 
 
 static const struct pci_device_id sil_pci_tbl[] = {
@@ -174,12 +175,12 @@ static struct scsi_host_template sil_sht
 	.queuecommand		= ata_scsi_queuecmd,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
-	.sg_tablesize		= LIBATA_MAX_PRD,
+	.sg_tablesize		= 120, /* max 15 kiB sectors ? */
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
 	.emulated		= ATA_SHT_EMULATED,
-	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.use_clustering		= 1,
 	.proc_name		= DRV_NAME,
-	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.dma_boundary		= 0x1fff,
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
@@ -187,6 +188,7 @@ static struct scsi_host_template sil_sht
 
 static const struct ata_port_operations sil_ops = {
 	.port_disable		= ata_port_disable,
+	.fill_sg		= sil_fill_sg,
 	.dev_config		= sil_dev_config,
 	.tf_load		= ata_tf_load,
 	.tf_read		= ata_tf_read,
@@ -278,9 +280,9 @@ MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, sil_pci_tbl);
 MODULE_VERSION(DRV_VERSION);
 
-static int slow_down = 0;
-module_param(slow_down, int, 0444);
-MODULE_PARM_DESC(slow_down, "Sledgehammer used to work around random 
problems, by limiting commands to 15 sectors (0=off, 1=on)");
+static int mod15_quirk = 0;
+module_param(mod15_quirk, int, 0444);
+MODULE_PARM_DESC(mod15_quirk, "Some disks from Seagate need a mod15 
workaround.");
 
 
 static unsigned char sil_get_device_cache_line(struct pci_dev *pdev)
@@ -534,6 +536,44 @@ static void sil_thaw(struct ata_port *ap
 	writel(tmp, mmio_base + SIL_SYSCFG);
 }
 
+static void sil_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	u32 addr, len;
+	unsigned int idx;
+
+	ata_fill_sg(qc);
+
+	/* check if we need the MOD15 workaround */
+	if (!(qc->dev->quirk & SIL_FLAG_MOD15WRITE))
+		return;
+
+	if (unlikely(qc->n_elem < 1))
+		return;
+
+	/* hardware S/G list may be longer (or shorter) than number of
+	 * PCI-mapped S/G entries (qc->n_elem), due to splitting
+	 * in ata_fill_sg(). Start at zero, and skip to end
+	 * of list, if we're not already there.
+	*/
+	idx = 0;
+	while ((le32_to_cpu(ap->prd[idx].flags_len) & ATA_PRD_EOT) == 0)
+		idx++;
+
+	/* Errata workaround: if last segment is exactly 8K, split
+	 * into 7.5K and 512b pieces.
+	 */
+	len = le32_to_cpu(ap->prd[idx].flags_len) & 0xffff;
+	if (len == 8192) {
+		addr = le32_to_cpu(ap->prd[idx].addr);
+		ap->prd[idx].flags_len = cpu_to_le32(15 * 512);
+
+		idx++;
+		ap->prd[idx].addr = cpu_to_le32(addr + (15 * 512));
+		ap->prd[idx].flags_len = cpu_to_le32(512 | ATA_PRD_EOT);
+	}
+}
+
 /**
  *	sil_dev_config - Apply device/host-specific errata fixups
  *	@dev: Device to be examined
@@ -577,14 +617,14 @@ static void sil_dev_config(struct ata_de
 			break;
 		}
 
-	/* limit requests to 15 sectors */
-	if (slow_down ||
+	/* mod15 bug */
+	if (mod15_quirk ||
 	    ((ap->flags & SIL_FLAG_MOD15WRITE) &&
 	     (quirks & SIL_QUIRK_MOD15WRITE))) {
 		if (print_info)
 			ata_dev_printk(dev, KERN_INFO, "applying Seagate "
 				       "errata fix (mod15write workaround)\n");
-		dev->max_sectors = 15;
+		dev->quirk |= SIL_FLAG_MOD15WRITE;
 		return;
 	}
 
Index: linux-2.6.23-rc9/include/linux/libata.h
===================================================================
--- linux-2.6.23-rc9.orig/include/linux/libata.h	2007-10-02 17:21:28.000000000 
+0200
+++ linux-2.6.23-rc9/include/linux/libata.h	2007-10-11 10:53:31.000000000 
+0200
@@ -471,6 +471,9 @@ struct ata_device {
 	/* error history */
 	struct ata_ering	ering;
 	int			spdn_cnt;
+
+	/* driver specific flags */
+	unsigned int            quirk;
 };
 
 /* Offset into struct ata_device.  Fields above it are maintained
@@ -641,6 +644,8 @@ struct ata_port_operations {
 
 	void (*bmdma_stop) (struct ata_queued_cmd *qc);
 	u8   (*bmdma_status) (struct ata_port *ap);
+
+	void (*fill_sg) (struct ata_queued_cmd *qc);
 };
 
 struct ata_port_info {
@@ -789,6 +794,7 @@ extern void ata_data_xfer_noirq(struct a
 				unsigned int buflen, int write_data);
 extern void ata_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
+extern void ata_fill_sg(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
 extern void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf,


-- 
Bernd Schubert
Q-Leap Networks GmbH
