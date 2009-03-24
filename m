From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/26] qla2xxx: Always (re)read firmware version/capabilities information.
Date: Tue, 24 Mar 2009 09:08:00 -0700
Message-ID: <1237910900-30817-7-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbZCXQI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:28 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

With recent ISPs loading firmware from flash, a flash-update to
the firmware-image region with a follow-on reset will reload the
new image.

Original caching of data only made sense when firmware was bound
with the driver.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1d28b53..a8a0f13 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -963,6 +963,7 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	unsigned long flags;
+	uint16_t fw_major_version;
 
 	if (!IS_FWI2_CAPABLE(ha) && !IS_QLA2100(ha) && !IS_QLA2200(ha)) {
 		/* Disable SRAM, Instruction RAM and GP RAM parity.  */
@@ -986,7 +987,8 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 
 			rval = qla2x00_execute_fw(vha, srisc_address);
 			/* Retrieve firmware information. */
-			if (rval == QLA_SUCCESS && ha->fw_major_version == 0) {
+			if (rval == QLA_SUCCESS) {
+				fw_major_version = ha->fw_major_version;
 				qla2x00_get_fw_version(vha,
 				    &ha->fw_major_version,
 				    &ha->fw_minor_version,
@@ -1003,10 +1005,11 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 						ha->max_npiv_vports =
 						    MIN_MULTI_ID_FABRIC - 1;
 				}
-				qla2x00_resize_request_q(vha);
-
-				if (ql2xallocfwdump)
-					qla2x00_alloc_fw_dump(vha);
+				if (!fw_major_version) {
+					qla2x00_resize_request_q(vha);
+					if (ql2xallocfwdump)
+						qla2x00_alloc_fw_dump(vha);
+				}
 			}
 		} else {
 			DEBUG2(printk(KERN_INFO
-- 
1.6.2.rc0.55.g30aa4f

