From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/15] qla2xxx: Use FW calculated residual count for underrun handling.
Date: Wed, 17 May 2006 15:08:55 -0700
Message-ID: <1147903730985-git-send-email-andrew.vasquez@qlogic.com>
References: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:59319 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751214AbWEQWI4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 May 2006 18:08:56 -0400
In-Reply-To: <20060517220642.GF4126@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>

With ISP24XX and ISP54XX parts.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

9946602efb5484538c4fe8a32cfa1e75df55f748
 drivers/scsi/qla2xxx/qla_fw.h  |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c |   16 ++++++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

9946602efb5484538c4fe8a32cfa1e75df55f748
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 1ee58ad..d2f5870 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -463,7 +463,7 @@ struct sts_entry_24xx {
 	uint16_t comp_status;		/* Completion status. */
 	uint16_t ox_id;			/* OX_ID used by the firmware. */
 
-	uint32_t residual_len;		/* Residual transfer length. */
+	uint32_t residual_len;		/* FW calc residual transfer length. */
 
 	uint16_t reserved_1;
 	uint16_t state_flags;		/* State flags. */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 2003dbb..40325ec 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -805,7 +805,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	uint16_t	scsi_status;
 	uint8_t		lscsi_status;
 	int32_t		resid;
-	uint32_t	sense_len, rsp_info_len, resid_len;
+	uint32_t	sense_len, rsp_info_len, resid_len, fw_resid_len;
 	uint8_t		*rsp_info, *sense_data;
 
 	sts = (sts_entry_t *) pkt;
@@ -859,11 +859,12 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 
 	fcport = sp->fcport;
 
-	sense_len = rsp_info_len = resid_len = 0;
+	sense_len = rsp_info_len = resid_len = fw_resid_len = 0;
 	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
 		sense_len = le32_to_cpu(sts24->sense_len);
 		rsp_info_len = le32_to_cpu(sts24->rsp_data_len);
 		resid_len = le32_to_cpu(sts24->rsp_residual_count);
+		fw_resid_len = le32_to_cpu(sts24->residual_len);
 		rsp_info = sts24->data;
 		sense_data = sts24->data;
 		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
@@ -963,14 +964,21 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 
 	case CS_DATA_UNDERRUN:
 		resid = resid_len;
+		/* Use F/W calculated residual length. */
+		if (IS_QLA24XX(ha) || IS_QLA54XX(ha))
+			resid = fw_resid_len;
+
 		if (scsi_status & SS_RESIDUAL_UNDER) {
 			cp->resid = resid;
 			CMD_RESID_LEN(cp) = resid;
 		} else {
 			DEBUG2(printk(KERN_INFO
 			    "scsi(%ld:%d:%d) UNDERRUN status detected "
-			    "0x%x-0x%x.\n", ha->host_no, cp->device->id,
-			    cp->device->lun, comp_status, scsi_status));
+			    "0x%x-0x%x. resid=0x%x fw_resid=0x%x cdb=0x%x "
+			    "os_underflow=0x%x\n", ha->host_no,
+			    cp->device->id, cp->device->lun, comp_status,
+			    scsi_status, resid_len, resid, cp->cmnd[0],
+			    cp->underflow));
 
 		}
 
-- 
1.3.3.g63df


