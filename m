From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH 2/6] scsi: megaraid_sas - added bios_param in
	scsi_host_template
Date: Wed, 14 Feb 2007 12:41:55 -0800
Message-ID: <1171485715.4188.13.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48446 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbXBOBv3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Feb 2007 20:51:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com


Added bios_param in scsi_host_template to return disk geometry.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---
 drivers/scsi/megaraid/megaraid_sas.c |   45 +++++++++++++++++++++++++
 1 files changed, 45 insertions(+)

Resubmitting with following changes : ulong -> unsigned long, removed type-casting
in size comparison of > 1Gb

diff -uprN linux-feb13-new-p1/drivers/scsi/megaraid/megaraid_sas.c linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.c
--- linux-feb13-new-p1/drivers/scsi/megaraid/megaraid_sas.c	2007-02-13 07:18:39.000000000 -0800
+++ linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.c	2007-02-13 11:34:58.000000000 -0800
@@ -35,6 +35,7 @@
 #include <asm/uaccess.h>
 #include <linux/fs.h>
 #include <linux/compat.h>
+#include <linux/blkdev.h>
 #include <linux/mutex.h>
 
 #include <scsi/scsi.h>
@@ -1015,6 +1016,49 @@ static int megasas_reset_bus_host(struct
 }
 
 /**
+ * megasas_bios_param - Returns disk geometry for a disk
+ * @sdev: 		device handle
+ * @bdev:		block device
+ * @capacity:		drive capacity
+ * @geom:		geometry parameters
+ */
+static int
+megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
+		 sector_t capacity, int geom[])
+{
+	int heads;
+	int sectors;
+	sector_t cylinders;
+	unsigned long tmp;
+	/* Default heads (64) & sectors (32) */
+	heads = 64;
+	sectors = 32;
+
+	tmp = heads * sectors;
+	cylinders = capacity;
+
+	sector_div(cylinders, tmp);
+
+	/*
+	 * Handle extended translation size for logical drives > 1Gb
+	 */
+
+	if (capacity >= 0x200000) {
+		heads = 255;
+		sectors = 63;
+		tmp = heads*sectors;
+		cylinders = capacity;
+		sector_div(cylinders, tmp);
+	}
+
+	geom[0] = heads;
+	geom[1] = sectors;
+	geom[2] = cylinders;
+
+	return 0;
+}
+
+/**
  * megasas_service_aen -	Processes an event notification
  * @instance:			Adapter soft state
  * @cmd:			AEN command completed by the ISR
@@ -1054,6 +1098,7 @@ static struct scsi_host_template megasas
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
 	.eh_host_reset_handler = megasas_reset_bus_host,
+	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
 };
 


