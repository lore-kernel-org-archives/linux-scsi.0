From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/16] qla2xxx: Add change_queue_depth/type() API support.
Date: Fri, 26 Aug 2005 19:09:30 -0700 (PDT)
Message-ID: <20050827020930.27275.49830.sendpatchset@plap.qlogic.com>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:10344 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751619AbVH0CJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 22:09:31 -0400
In-Reply-To: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add change_queue_depth/type() API support.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_os.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

c61d82773aa6675dd6e8553f5aee97a743948689
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -111,6 +111,9 @@ static int qla2xxx_eh_host_reset(struct 
 static int qla2x00_loop_reset(scsi_qla_host_t *ha);
 static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
 
+static int qla2x00_change_queue_depth(struct scsi_device *, int);
+static int qla2x00_change_queue_type(struct scsi_device *, int);
+
 static struct scsi_host_template qla2x00_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "qla2xxx",
@@ -125,6 +128,8 @@ static struct scsi_host_template qla2x00
 
 	.slave_alloc		= qla2xxx_slave_alloc,
 	.slave_destroy		= qla2xxx_slave_destroy,
+	.change_queue_depth	= qla2x00_change_queue_depth,
+	.change_queue_type	= qla2x00_change_queue_type,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -151,6 +156,8 @@ static struct scsi_host_template qla24xx
 
 	.slave_alloc		= qla2xxx_slave_alloc,
 	.slave_destroy		= qla2xxx_slave_destroy,
+	.change_queue_depth	= qla2x00_change_queue_depth,
+	.change_queue_type	= qla2x00_change_queue_type,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.use_clustering		= ENABLE_CLUSTERING,
@@ -1109,6 +1116,28 @@ qla2xxx_slave_destroy(struct scsi_device
 	sdev->hostdata = NULL;
 }
 
+static int
+qla2x00_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), qdepth);
+	return sdev->queue_depth;
+}
+
+static int
+qla2x00_change_queue_type(struct scsi_device *sdev, int tag_type)
+{
+	if (sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, tag_type);
+		if (tag_type)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		tag_type = 0;
+
+	return tag_type;
+}
+
 /**
  * qla2x00_config_dma_addressing() - Configure OS DMA addressing method.
  * @ha: HA context

-- 
Andrew Vasquez
