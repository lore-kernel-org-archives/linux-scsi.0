From: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/4] libata: Flag most SATA ports as hotpluggable
Date: Thu, 16 Jul 2009 00:43:56 +0100
Message-ID: <1247701438-18266-2-git-send-email-mjg@redhat.com>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:46553 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbZGOXoN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2009 19:44:13 -0400
In-Reply-To: <1247701438-18266-1-git-send-email-mjg@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Matthew Garrett <mjg@redhat.com>

SATA is generally hotpluggable, though some controllers don't expose
enough information to make it possible. Flag most SATA controllers as
supporting hotplug, leaving the remaining ones (ich in PIIX mode, Promise
SX4, Pacific Digital Talon) marked as not supporting it.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/ata/ahci.c          |    1 +
 drivers/ata/sata_fsl.c      |    1 +
 drivers/ata/sata_inic162x.c |    1 +
 drivers/ata/sata_mv.c       |    2 ++
 drivers/ata/sata_nv.c       |    3 +++
 drivers/ata/sata_promise.c  |    1 +
 drivers/ata/sata_qstor.c    |    1 +
 drivers/ata/sata_sil.c      |    3 ++-
 drivers/ata/sata_sil24.c    |    1 +
 drivers/ata/sata_sis.c      |    1 +
 drivers/ata/sata_svw.c      |    1 +
 drivers/ata/sata_uli.c      |    1 +
 drivers/ata/sata_via.c      |    1 +
 drivers/ata/sata_vsc.c      |    1 +
 14 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 15a2303..de84054 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -347,6 +347,7 @@ static struct scsi_host_template ahci_sht = {
 	.dma_boundary		= AHCI_DMA_BOUNDARY,
 	.shost_attrs		= ahci_shost_attrs,
 	.sdev_attrs		= ahci_sdev_attrs,
+	.hotpluggable		= 1,
 };
 
 static struct ata_port_operations ahci_ops = {
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 94eaa43..e7738c7 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1252,6 +1252,7 @@ static struct scsi_host_template sata_fsl_sht = {
 	.can_queue = SATA_FSL_QUEUE_DEPTH,
 	.sg_tablesize = SATA_FSL_MAX_PRD_USABLE,
 	.dma_boundary = ATA_DMA_BOUNDARY,
+	.hotpluggable = 1,
 };
 
 static struct ata_port_operations sata_fsl_ops = {
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 8d890cc..f51e71d 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -234,6 +234,7 @@ static struct scsi_host_template inic_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize	= LIBATA_MAX_PRD,	/* maybe it can be larger? */
 	.dma_boundary	= INIC_DMA_BOUNDARY,
+	.hotpluggable	= 1,
 };
 
 static const int scr_map[] = {
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 23714ae..8d61998 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -647,6 +647,7 @@ static struct scsi_host_template mv5_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.dma_boundary		= MV_DMA_BOUNDARY,
+	.hotpluggable		= 1,
 };
 
 static struct scsi_host_template mv6_sht = {
@@ -654,6 +655,7 @@ static struct scsi_host_template mv6_sht = {
 	.can_queue		= MV_MAX_Q_DEPTH - 1,
 	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.dma_boundary		= MV_DMA_BOUNDARY,
+	.hotpluggable		= 1,
 };
 
 static struct ata_port_operations mv5_ops = {
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index b2d11f3..9e93c56 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -388,6 +388,7 @@ static struct pci_driver nv_pci_driver = {
 
 static struct scsi_host_template nv_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
+	.hotpluggable		= 1,
 };
 
 static struct scsi_host_template nv_adma_sht = {
@@ -396,6 +397,7 @@ static struct scsi_host_template nv_adma_sht = {
 	.sg_tablesize		= NV_ADMA_SGTBL_TOTAL_LEN,
 	.dma_boundary		= NV_ADMA_DMA_BOUNDARY,
 	.slave_configure	= nv_adma_slave_config,
+	.hotpluggable		= 1,
 };
 
 static struct scsi_host_template nv_swncq_sht = {
@@ -404,6 +406,7 @@ static struct scsi_host_template nv_swncq_sht = {
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= nv_swncq_slave_config,
+	.hotpluggable		= 1,
 };
 
 /*
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index b1fd7d6..abddf93 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -166,6 +166,7 @@ static struct scsi_host_template pdc_ata_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= PDC_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.hotpluggable		= 1,
 };
 
 static const struct ata_port_operations pdc_common_ops = {
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index 326c0cf..f9db8fe 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -130,6 +130,7 @@ static struct scsi_host_template qs_ata_sht = {
 	ATA_BASE_SHT(DRV_NAME),
 	.sg_tablesize		= QS_MAX_PRD,
 	.dma_boundary		= QS_DMA_BOUNDARY,
+	.hotpluggable		= 1,
 };
 
 static struct ata_port_operations qs_ata_ops = {
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 030ec07..7237abb 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -179,7 +179,8 @@ static struct scsi_host_template sil_sht = {
 	    transfer chunks up to 2GB and which cross 64KB boundaries,
 	    therefore the DMA limits are more relaxed than standard ATA SFF. */
 	.dma_boundary		= SIL_DMA_BOUNDARY,
-	.sg_tablesize		= ATA_MAX_PRD
+	.sg_tablesize		= ATA_MAX_PRD,
+	.hotpluggable		= 1,
 };
 
 static struct ata_port_operations sil_ops = {
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 77aa8d7..166be9e 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -386,6 +386,7 @@ static struct scsi_host_template sil24_sht = {
 	.can_queue		= SIL24_MAX_CMDS,
 	.sg_tablesize		= SIL24_MAX_SGE,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.hotpluggable		= 1,
 };
 
 static struct ata_port_operations sil24_ops = {
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 8f98332..4cc5469 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -87,6 +87,7 @@ static struct pci_driver sis_pci_driver = {
 
 static struct scsi_host_template sis_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
+	.hotpluggable		= 1,
 };
 
 static struct ata_port_operations sis_ops = {
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 7257f2d..2f90770 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -341,6 +341,7 @@ static struct scsi_host_template k2_sata_sht = {
 #ifdef CONFIG_PPC_OF
 	.proc_info		= k2_sata_proc_info,
 #endif
+	.hotpluggable		= 1,
 };
 
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index e5bff47..9f2ae95 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -77,6 +77,7 @@ static struct pci_driver uli_pci_driver = {
 
 static struct scsi_host_template uli_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
+	.hotpluggable		= 1,
 };
 
 static struct ata_port_operations uli_ops = {
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index bdd43c7..c554b2e 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -111,6 +111,7 @@ static struct pci_driver svia_pci_driver = {
 
 static struct scsi_host_template svia_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
+	.hotpluggable		= 1,
 };
 
 static struct ata_port_operations svia_base_ops = {
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 8b2a278..dc58b2b 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -303,6 +303,7 @@ out:
 
 static struct scsi_host_template vsc_sata_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
+	.hotpluggable		= 1,
 };
 
 
-- 
1.6.2.5

