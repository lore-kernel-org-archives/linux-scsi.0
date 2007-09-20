From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 10/19] qla2xxx: Set correct attribute count during FDMI RPA.
Date: Thu, 20 Sep 2007 14:07:41 -0700
Message-ID: <1190322470-15543-10-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbXITVHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:52 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Also remove legacy '/proc' name during OS_DEVICE_NAME
registration.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c  |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 75ab898..511e3cd 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1705,7 +1705,7 @@ struct ct_fdmi_hba_attributes {
 /*
  * Port attribute types.
  */
-#define FDMI_PORT_ATTR_COUNT		5
+#define FDMI_PORT_ATTR_COUNT		6
 #define FDMI_PORT_FC4_TYPES		1
 #define FDMI_PORT_SUPPORT_SPEED		2
 #define FDMI_PORT_CURRENT_SPEED		3
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index a7e2358..eb0784c 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1517,7 +1517,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 
 	/* Attributes */
 	ct_req->req.rpa.attrs.count =
-	    __constant_cpu_to_be32(FDMI_PORT_ATTR_COUNT);
+	    __constant_cpu_to_be32(FDMI_PORT_ATTR_COUNT - 1);
 	entries = ct_req->req.rpa.port_name;
 
 	/* FC4 types. */
@@ -1600,7 +1600,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	/* OS device name. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_OS_DEVICE_NAME);
-	sprintf(eiter->a.os_dev_name, "/proc/scsi/qla2xxx/%ld", ha->host_no);
+	strcpy(eiter->a.os_dev_name, QLA2XXX_DRIVER_NAME);
 	alen = strlen(eiter->a.os_dev_name);
 	alen += (alen & 3) ? (4 - (alen & 3)) : 4;
 	eiter->len = cpu_to_be16(4 + alen);
@@ -1611,6 +1611,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 
 	/* Hostname. */
 	if (strlen(fc_host_system_hostname(ha->host))) {
+		ct_req->req.rpa.attrs.count =
+		    __constant_cpu_to_be32(FDMI_PORT_ATTR_COUNT);
 		eiter = (struct ct_fdmi_port_attr *) (entries + size);
 		eiter->type = __constant_cpu_to_be16(FDMI_PORT_HOST_NAME);
 		snprintf(eiter->a.host_name, sizeof(eiter->a.host_name),
-- 
1.5.3.2.80.g077d6f

