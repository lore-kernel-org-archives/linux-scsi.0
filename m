From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] avoid obsolete APIs in ide-scsi
Date: Sun, 5 Sep 2004 19:21:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040905172126.GB6685@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:2018 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266878AbUIERV2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2004 13:21:28 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.43/drivers/scsi/ide-scsi.c	2004-08-13 02:03:53 +02:00
+++ edited/drivers/scsi/ide-scsi.c	2004-09-04 15:44:27 +02:00
@@ -50,8 +50,11 @@
 #include <asm/bitops.h>
 #include <asm/uaccess.h>
 
-#include "scsi.h"
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/sg.h>
 
 #define IDESCSI_DEBUG_LOG		0
@@ -66,8 +69,8 @@
 	u8 *current_position;			/* Pointer into the above buffer */
 	struct scatterlist *sg;			/* Scatter gather table */
 	int b_count;				/* Bytes transferred from current entry */
-	Scsi_Cmnd *scsi_cmd;			/* SCSI command */
-	void (*done)(Scsi_Cmnd *);		/* Scsi completion routine */
+	struct scsi_cmnd *scsi_cmd;		/* SCSI command */
+	void (*done)(struct scsi_cmnd *);	/* Scsi completion routine */
 	unsigned long flags;			/* Status/Action flags */
 	unsigned long timeout;			/* Command timeout */
 } idescsi_pc_t;
@@ -747,7 +750,7 @@
 
 static int idescsi_attach(ide_drive_t *drive);
 
-static int idescsi_slave_configure(Scsi_Device * sdp)
+static int idescsi_slave_configure(struct scsi_device * sdp)
 {
 	/* Configure detected device */
 	scsi_adjust_queue_depth(sdp, MSG_SIMPLE_TAG, sdp->host->cmd_per_lun);
@@ -759,7 +762,7 @@
 	return "SCSI host adapter emulation for IDE ATAPI devices";
 }
 
-static int idescsi_ioctl (Scsi_Device *dev, int cmd, void __user *arg)
+static int idescsi_ioctl (struct scsi_device *dev, int cmd, void __user *arg)
 {
 	idescsi_scsi_t *scsi = scsihost_to_idescsi(dev->host);
 
@@ -849,7 +852,7 @@
 	return first_bh;
 }
 
-static inline int should_transform(ide_drive_t *drive, Scsi_Cmnd *cmd)
+static inline int should_transform(ide_drive_t *drive, struct scsi_cmnd *cmd)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
 
@@ -867,7 +870,8 @@
 	return test_bit(IDESCSI_TRANSFORM, &scsi->transform);
 }
 
-static int idescsi_queue (Scsi_Cmnd *cmd, void (*done)(Scsi_Cmnd *))
+static int idescsi_queue (struct scsi_cmnd *cmd,
+		void (*done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *host = cmd->device->host;
 	idescsi_scsi_t *scsi = scsihost_to_idescsi(host);
@@ -933,7 +937,7 @@
 	return 1;
 }
 
-static int idescsi_eh_abort (Scsi_Cmnd *cmd)
+static int idescsi_eh_abort (struct scsi_cmnd *cmd)
 {
 	idescsi_scsi_t *scsi  = scsihost_to_idescsi(cmd->device->host);
 	ide_drive_t    *drive = scsi->drive;
@@ -992,7 +996,7 @@
 	return ret;
 }
 
-static int idescsi_eh_reset (Scsi_Cmnd *cmd)
+static int idescsi_eh_reset (struct scsi_cmnd *cmd)
 {
 	struct request *req;
 	idescsi_scsi_t *scsi  = scsihost_to_idescsi(cmd->device->host);
@@ -1075,7 +1079,7 @@
 	return 0;
 }
 
-static Scsi_Host_Template idescsi_template = {
+static struct scsi_host_template idescsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "idescsi",
 	.info			= idescsi_info,
===== drivers/scsi/scsi_devinfo.c 1.24 vs edited =====
