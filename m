From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 22/26] qla2xxx: Explicitly set the execution-throttle with recent ISPs.
Date: Tue, 24 Mar 2009 09:08:16 -0700
Message-ID: <1237910900-30817-23-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762370AbZCXQIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:46 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Firmware semantics changed for 24xx and above ISPs in their
handling of the specified execution-throttle passed during
firmware initialization.  The original codes use of a theoretical
maximum (0xffff, as carried over from earlier ISPs) could in fact
act as a throttle in some circumstances.  Now set the value based
of the firmware's own 'resource' (exchange IOCBs) capabilities.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1a84dbf..e3d4d48 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2432,6 +2432,7 @@ struct qla_hw_data {
 #define RISC_START_ADDRESS_2100 0x1000
 #define RISC_START_ADDRESS_2300 0x800
 #define RISC_START_ADDRESS_2400 0x100000
+	uint16_t	fw_xcb_count;
 
 	uint16_t	fw_options[16];         /* slots: 1,2,3,10,11 */
 	uint8_t		fw_seriallink_options[4];
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f90fd37..bd7dd84 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -948,8 +948,9 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
 				}
-				qla2x00_get_resource_cnts(vha, NULL, NULL,
-				    NULL, NULL, &ha->max_npiv_vports);
+				qla2x00_get_resource_cnts(vha, NULL,
+				    &ha->fw_xcb_count, NULL, NULL,
+				    &ha->max_npiv_vports);
 
 				if (!fw_major_version && ql2xallocfwdump)
 					qla2x00_alloc_fw_dump(vha);
@@ -1275,8 +1276,11 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
 	}
 
-
-	mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
+	if (IS_FWI2_CAPABLE(ha)) {
+		mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
+		mid_init_cb->init_cb.execution_throttle =
+		    cpu_to_le16(ha->fw_xcb_count);
+	}
 
 	rval = qla2x00_init_firmware(vha, ha->init_cb_size);
 	if (rval) {
-- 
1.6.2.rc0.55.g30aa4f

