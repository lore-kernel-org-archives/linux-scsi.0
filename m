From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/9] qla2xxx: Correct setting of 'current' and 'supported' speeds during FDMI registration.
Date: Thu, 19 Jul 2007 15:05:58 -0700
Message-ID: <11848827643716-git-send-email-andrew.vasquez@qlogic.com>
References: <20070719220456.GK4015@plap.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:27113 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763255AbXGSWHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 18:07:04 -0400
In-Reply-To: <20070719220456.GK4015@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    8 ++++++++
 drivers/scsi/qla2xxx/qla_gs.c  |   29 ++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d505c04..f98eb63 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1711,6 +1711,14 @@ struct ct_fdmi_hba_attributes {
 #define FDMI_PORT_OS_DEVICE_NAME	5
 #define FDMI_PORT_HOST_NAME		6
 
+#define FDMI_PORT_SPEED_1GB		0x1
+#define FDMI_PORT_SPEED_2GB		0x2
+#define FDMI_PORT_SPEED_10GB		0x4
+#define FDMI_PORT_SPEED_4GB		0x8
+#define FDMI_PORT_SPEED_8GB		0x10
+#define FDMI_PORT_SPEED_16GB		0x20
+#define FDMI_PORT_SPEED_UNKNOWN		0x8000
+
 struct ct_fdmi_port_attr {
 	uint16_t type;
 	uint16_t len;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 9be3123..301279a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1528,11 +1528,15 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
 	if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
-		eiter->a.sup_speed = __constant_cpu_to_be32(4);
+		eiter->a.sup_speed = __constant_cpu_to_be32(
+		    FDMI_PORT_SPEED_1GB|FDMI_PORT_SPEED_2GB|
+		    FDMI_PORT_SPEED_4GB);
 	else if (IS_QLA23XX(ha))
-		eiter->a.sup_speed = __constant_cpu_to_be32(2);
+		eiter->a.sup_speed =__constant_cpu_to_be32(
+		    FDMI_PORT_SPEED_1GB|FDMI_PORT_SPEED_2GB);
 	else
-		eiter->a.sup_speed = __constant_cpu_to_be32(1);
+		eiter->a.sup_speed = __constant_cpu_to_be32(
+		    FDMI_PORT_SPEED_1GB);
 	size += 4 + 4;
 
 	DEBUG13(printk("%s(%ld): SUPPORTED_SPEED=%x.\n", __func__, ha->host_no,
@@ -1543,14 +1547,21 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_CURRENT_SPEED);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
 	switch (ha->link_data_rate) {
-	case 0:
-		eiter->a.cur_speed = __constant_cpu_to_be32(1);
+	case PORT_SPEED_1GB:
+		eiter->a.cur_speed =
+		    __constant_cpu_to_be32(FDMI_PORT_SPEED_1GB);
 		break;
-	case 1:
-		eiter->a.cur_speed = __constant_cpu_to_be32(2);
+	case PORT_SPEED_2GB:
+		eiter->a.cur_speed =
+		    __constant_cpu_to_be32(FDMI_PORT_SPEED_2GB);
 		break;
-	case 3:
-		eiter->a.cur_speed = __constant_cpu_to_be32(4);
+	case PORT_SPEED_4GB:
+		eiter->a.cur_speed =
+		    __constant_cpu_to_be32(FDMI_PORT_SPEED_4GB);
+		break;
+	default:
+		eiter->a.cur_speed =
+		    __constant_cpu_to_be32(FDMI_PORT_SPEED_UNKNOWN);
 		break;
 	}
 	size += 4 + 4;
-- 
1.5.3.rc2.4.g726f9

