From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/12] advansys: Update to version 3.5 and remove compilation warning
Date: Wed,  3 Dec 2014 12:45:05 +0100
Message-ID: <1417607105-85455-13-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbaLCLpO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:14 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The driver has now been converted to use the DMA-API, so
update the version number and remove the compilation warning.
And check for DMA mapping errors, while we're at it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 MAINTAINERS             |  1 +
 drivers/scsi/advansys.c | 41 +++++++++++++++++++++++++++--------------
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9210908..4c111aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -445,6 +445,7 @@ F:	drivers/input/misc/adxl34x.c
 
 ADVANSYS SCSI DRIVER
 M:	Matthew Wilcox <matthew@wil.cx>
+M:	Hannes Reinecke <hare@suse.de>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 F:	Documentation/scsi/advansys.txt
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index bd44d1b..4f3f948 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1,5 +1,5 @@
 #define DRV_NAME "advansys"
-#define ASC_VERSION "3.4"	/* AdvanSys Driver Version */
+#define ASC_VERSION "3.5"	/* AdvanSys Driver Version */
 
 /*
  * advansys.c - Linux Host Driver for AdvanSys SCSI Adapters
@@ -7,6 +7,7 @@
  * Copyright (c) 1995-2000 Advanced System Products, Inc.
  * Copyright (c) 2000-2001 ConnectCom Solutions, Inc.
  * Copyright (c) 2007 Matthew Wilcox <matthew@wil.cx>
+ * Copyright (c) 2014 Hannes Reinecke <hare@suse.de>
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -51,24 +52,19 @@
 
 /* FIXME:
  *
- *  1. Although all of the necessary command mapping places have the
- *     appropriate dma_map.. APIs, the driver still processes its internal
- *     queue using bus_to_virt() and virt_to_bus() which are illegal under
- *     the API.  The entire queue processing structure will need to be
- *     altered to fix this.
+ *  1. (done)
  *  2. Need to add memory mapping workaround. Test the memory mapping.
  *     If it doesn't work revert to I/O port access. Can a test be done
  *     safely?
  *  3. Handle an interrupt not working. Keep an interrupt counter in
  *     the interrupt handler. In the timeout function if the interrupt
  *     has not occurred then print a message and run in polled mode.
- *  4. Need to add support for target mode commands, cf. CAM XPT.
- *  5. check DMA mapping functions for failure
+ *  4. (obsolete)
+ *  5. (done)
  *  6. Use scsi_transport_spi
  *  7. advansys_info is not safe against multiple simultaneous callers
  *  8. Add module_param to override ISA/VLB ioport array
  */
-#warning this driver is still not properly converted to the DMA API
 
 /* Enable driver /proc statistics. */
 #define ADVANSYS_STATS
@@ -7765,6 +7761,10 @@ static __le32 advansys_get_sense_buffer_dma(struct scsi_cmnd *scp)
 	struct asc_board *board = shost_priv(scp->device->host);
 	scp->SCp.dma_handle = dma_map_single(board->dev, scp->sense_buffer,
 					     SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(board->dev, scp->SCp.dma_handle)) {
+		ASC_DBG(1, "failed to map sense buffer\n");
+		return 0;
+	}
 	dma_cache_sync(board->dev, scp->sense_buffer,
 		       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 	return cpu_to_le32(scp->SCp.dma_handle);
@@ -7794,6 +7794,8 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
 	asc_scsi_q->q1.sense_addr = advansys_get_sense_buffer_dma(scp);
 	asc_scsi_q->q1.sense_len = SCSI_SENSE_BUFFERSIZE;
+	if (!asc_scsi_q->q1.sense_addr)
+		return ASC_ERROR;
 
 	/*
 	 * If there are any outstanding requests for the current target,
@@ -7815,7 +7817,10 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 
 	/* Build ASC_SCSI_Q */
 	use_sg = scsi_dma_map(scp);
-	if (use_sg != 0) {
+	if (use_sg < 0) {
+		ASC_DBG(1, "failed to map sglist\n");
+		return ASC_BUSY;
+	} else if (use_sg > 0) {
 		int sgcnt;
 		struct scatterlist *slp;
 		struct asc_sg_head *asc_sg_head;
@@ -8049,6 +8054,11 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 
 	sense_addr = dma_map_single(boardp->dev, scp->sense_buffer,
 				    SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(boardp->dev, sense_addr)) {
+		ASC_DBG(1, "failed to map sense buffer\n");
+		ASC_STATS(scp->device->host, adv_build_noreq);
+		return ASC_BUSY;
+	}
 	scsiqp->sense_addr = cpu_to_le32(sense_addr);
 	scsiqp->sense_len = cpu_to_le32(SCSI_SENSE_BUFFERSIZE);
 	dma_cache_sync(boardp->dev, scp->sense_buffer,
@@ -8057,7 +8067,11 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	/* Build ADV_SCSI_REQ_Q */
 
 	use_sg = scsi_dma_map(scp);
-	if (use_sg == 0) {
+	if (use_sg < 0) {
+		ASC_DBG(1, "failed to map SG list\n");
+		ASC_STATS(scp->device->host, adv_build_noreq);
+		return ASC_BUSY;
+	} else if (use_sg == 0) {
 		/* Zero-length transfer */
 		reqp->sgblkp = NULL;
 		scsiqp->data_cnt = 0;
@@ -8783,11 +8797,10 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
 		struct asc_scsi_q asc_scsi_q;
 
-		/* asc_build_req() can not return ASC_BUSY. */
 		ret = asc_build_req(boardp, scp, &asc_scsi_q);
-		if (ret == ASC_ERROR) {
+		if (ret == ASC_ERROR || ret == ASC_BUSY) {
 			ASC_STATS(scp->device->host, build_error);
-			return ASC_ERROR;
+			return ret;
 		}
 
 		ret = AscExeScsiQueue(asc_dvc, &asc_scsi_q);
-- 
1.8.5.2

