From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] libsas, aic94xx: fix dma mapping cockups with ATA
Date: Mon, 16 Jul 2007 13:41:04 -0500
Message-ID: <1184611264.3447.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39405 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751187AbXGPSlG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 14:41:06 -0400
Received: from [172.17.6.40] (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (Postfix) with ESMTP id 21D80AAA81CF
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2007 14:41:05 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This one was noticed by Gilbert Wu of Adaptec:

The libata core actually does the DMA mapping for you, so there has to
be an exception in the device drivers that *don't* do dma mapping for
ATA commands.  However, since we've already done this, libsas must now
dma map any ATA commands that it wishes to issue ... and yes, this is a
horrible mess.

Additionally, the test in aic94xx for ATA protocols isn't quite right.

---

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_discover.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_discover.c	2007-07-16 13:01:19.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_discover.c	2007-07-16 13:39:57.000000000 -0500
@@ -110,6 +110,13 @@ static int sas_execute_task(struct sas_t
 	task->total_xfer_len = size;
 	task->data_dir = pci_dma_dir;
 	task->task_done = sas_disc_task_done;
+	if (pci_dma_dir != PCI_DMA_NONE &&
+	    sas_protocol_ata(task->task_proto)) {
+		task->num_scatter = pci_map_sg(task->dev->port->ha->pcidev,
+					       task->scatter,
+					       task->num_scatter,
+					       task->data_dir);
+	}
 
 	for (retries = 0; retries < 5; retries++) {
 		task->task_state_flags = SAS_TASK_STATE_PENDING;
@@ -192,8 +199,13 @@ static int sas_execute_task(struct sas_t
 		}
 	}
 ex_err:
-	if (pci_dma_dir != PCI_DMA_NONE)
+	if (pci_dma_dir != PCI_DMA_NONE) {
+		if (sas_protocol_ata(task->task_proto))
+			pci_unmap_sg(task->dev->port->ha->pcidev,
+				     task->scatter, task->num_scatter,
+				     task->data_dir);
 		kfree(scatter);
+	}
 out:
 	return res;
 }
Index: BUILD-2.6/drivers/scsi/aic94xx/aic94xx_task.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/aic94xx/aic94xx_task.c	2007-07-16 13:37:59.000000000 -0500
+++ BUILD-2.6/drivers/scsi/aic94xx/aic94xx_task.c	2007-07-16 13:38:46.000000000 -0500
@@ -76,7 +76,7 @@ static inline int asd_map_scatterlist(st
 
 	/* STP tasks come from libata which has already mapped
 	 * the SG list */
-	if (task->task_proto == SAS_PROTOCOL_STP)
+	if (sas_protocol_ata(task->task_proto))
 		num_sg = task->num_scatter;
 	else
 		num_sg = pci_map_sg(asd_ha->pcidev, task->scatter,
@@ -125,7 +125,7 @@ static inline int asd_map_scatterlist(st
 
 	return 0;
 err_unmap:
-	if (task->task_proto != SAS_PROTOCOL_STP)
+	if (sas_protocol_ata(task->task_proto))
 		pci_unmap_sg(asd_ha->pcidev, task->scatter, task->num_scatter,
 			     task->data_dir);
 	return res;
Index: BUILD-2.6/include/scsi/scsi_transport_sas.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_transport_sas.h	2007-07-16 13:34:05.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_transport_sas.h	2007-07-16 13:35:58.000000000 -0500
@@ -23,6 +23,12 @@ enum sas_protocol {
 	SAS_PROTOCOL_SSP		= 0x08,
 };
 
+static inline int sas_protocol_ata(enum sas_protocol proto)
+{
+	return ((proto & SAS_PROTOCOL_SATA) ||
+		(proto & SAS_PROTOCOL_STP))? 1 : 0;
+}
+
 enum sas_linkrate {
 	/* These Values are defined in the SAS standard */
 	SAS_LINK_RATE_UNKNOWN = 0,



