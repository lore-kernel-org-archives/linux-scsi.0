From: brking@us.ibm.com
Subject: [patch 03/15] libata: Remove dependence on host_set->dev for SAS
Date: Mon, 06 Feb 2006 09:42:22 -0600
Message-ID: <200602061542.k16FgSYn009049@d01av02.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Remove some of the dependence on the host_set struct
in preparation for supporting SAS HBAs. Adds a struct device
pointer to the ata_port struct.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/libata-core.c |   13 +++++++------
 include/linux/libata.h     |    1 +
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/libata.h~libata_host_set_dev include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_host_set_dev	2006-02-03 12:37:07.000000000 -0600
+++ libata-dev-bjking1/include/linux/libata.h	2006-02-03 12:37:07.000000000 -0600
@@ -393,6 +393,7 @@ struct ata_port {
 
 	struct ata_host_stats	stats;
 	struct ata_host_set	*host_set;
+	struct device 		*dev;
 
 	struct work_struct	packet_task;
 
diff -puN drivers/scsi/libata-core.c~libata_host_set_dev drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_host_set_dev	2006-02-03 12:37:07.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-02-03 12:37:07.000000000 -0600
@@ -2855,7 +2855,7 @@ static void ata_sg_clean(struct ata_queu
 
 	if (qc->flags & ATA_QCFLAG_SG) {
 		if (qc->n_elem)
-			dma_unmap_sg(ap->host_set->dev, sg, qc->n_elem, dir);
+			dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
 		/* restore last sg */
 		sg[qc->orig_n_elem - 1].length += qc->pad_len;
 		if (pad_buf) {
@@ -2866,7 +2866,7 @@ static void ata_sg_clean(struct ata_queu
 		}
 	} else {
 		if (sg_dma_len(&sg[0]) > 0)
-			dma_unmap_single(ap->host_set->dev,
+			dma_unmap_single(ap->dev,
 				sg_dma_address(&sg[0]), sg_dma_len(&sg[0]),
 				dir);
 		/* restore sg */
@@ -3073,7 +3073,7 @@ static int ata_sg_setup_one(struct ata_q
 		goto skip_map;
 	}
 
-	dma_address = dma_map_single(ap->host_set->dev, qc->buf_virt,
+	dma_address = dma_map_single(ap->dev, qc->buf_virt,
 				     sg->length, dir);
 	if (dma_mapping_error(dma_address)) {
 		/* restore sg */
@@ -3161,7 +3161,7 @@ static int ata_sg_setup(struct ata_queue
 	}
 
 	dir = qc->dma_dir;
-	n_elem = dma_map_sg(ap->host_set->dev, sg, pre_n_elem, dir);
+	n_elem = dma_map_sg(ap->dev, sg, pre_n_elem, dir);
 	if (n_elem < 1) {
 		/* restore last sg */
 		lsg->length += qc->pad_len;
@@ -4625,7 +4625,7 @@ int ata_device_suspend(struct ata_port *
 
 int ata_port_start (struct ata_port *ap)
 {
-	struct device *dev = ap->host_set->dev;
+	struct device *dev = ap->dev;
 	int rc;
 
 	ap->prd = dma_alloc_coherent(dev, ATA_PRD_TBL_SZ, &ap->prd_dma, GFP_KERNEL);
@@ -4658,7 +4658,7 @@ int ata_port_start (struct ata_port *ap)
 
 void ata_port_stop (struct ata_port *ap)
 {
-	struct device *dev = ap->host_set->dev;
+	struct device *dev = ap->dev;
 
 	dma_free_coherent(dev, ATA_PRD_TBL_SZ, ap->prd, ap->prd_dma);
 	ata_pad_free(ap, dev);
@@ -4725,6 +4725,7 @@ static void ata_host_init(struct ata_por
 	ap->host = host;
 	ap->ctl = ATA_DEVCTL_OBS;
 	ap->host_set = host_set;
+	ap->dev = ent->dev;
 	ap->port_no = port_no;
 	ap->hard_port_no =
 		ent->legacy_mode ? ent->hard_port_no : port_no;
_
