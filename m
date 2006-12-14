From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/9] qla2xxx: Detect GPSC capabilities within a fabric.
Date: Wed, 13 Dec 2006 19:20:28 -0800
Message-ID: <11660664332331-git-send-email-andrew.vasquez@qlogic.com>
References: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:39867 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbWLNDdp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 22:33:45 -0500
In-Reply-To: <20061214031935.GB538@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Disable subsequent GPSC queries if Fabric Management services do
not support the operation.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 ++
 drivers/scsi/qla2xxx/qla_gs.c  |   18 ++++++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c |    2 ++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c4fc40f..2c10130 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1602,6 +1602,7 @@ typedef struct fc_port {
 
 #define CT_REJECT_RESPONSE	0x8001
 #define CT_ACCEPT_RESPONSE	0x8002
+#define CT_REASON_INVALID_COMMAND_CODE	0x01
 #define CT_REASON_CANNOT_PERFORM	0x09
 #define CT_EXPL_ALREADY_REGISTERED	0x10
 
@@ -2079,6 +2080,7 @@ typedef struct scsi_qla_host {
 		uint32_t	msi_enabled		:1;
 		uint32_t	msix_enabled		:1;
 		uint32_t	disable_serdes		:1;
+		uint32_t	gpsc_supported		:1;
 	} flags;
 
 	atomic_t	loop_state;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 220ec41..ec5b2dd 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -143,6 +143,7 @@ qla2x00_chk_ms_status(scsi_qla_host_t *ha, ms_iocb_entry_t *ms_pkt,
 				DEBUG2_3(qla2x00_dump_buffer(
 				    (uint8_t *)&ct_rsp->header,
 				    sizeof(struct ct_rsp_hdr)));
+				rval = QLA_INVALID_COMMAND;
 			} else
 				rval = QLA_SUCCESS;
 			break;
@@ -1784,6 +1785,8 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 
 	if (!IS_QLA24XX(ha) && !IS_QLA54XX(ha))
 		return QLA_FUNCTION_FAILED;
+	if (!ha->flags.gpsc_supported)
+		return QLA_FUNCTION_FAILED;
 
 	rval = qla2x00_mgmt_svr_login(ha);
 	if (rval)
@@ -1813,8 +1816,19 @@ qla2x00_gpsc(scsi_qla_host_t *ha, sw_info_t *list)
 			/*EMPTY*/
 			DEBUG2_3(printk("scsi(%ld): GPSC issue IOCB "
 			    "failed (%d).\n", ha->host_no, rval));
-		} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
-		    "GPSC") != QLA_SUCCESS) {
+		} else if ((rval = qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
+		    "GPSC")) != QLA_SUCCESS) {
+			/* FM command unsupported? */
+			if (rval == QLA_INVALID_COMMAND &&
+			    ct_rsp->header.reason_code ==
+			    CT_REASON_INVALID_COMMAND_CODE) {
+				DEBUG2(printk("scsi(%ld): GPSC command "
+				    "unsupported, disabling query...\n",
+				    ha->host_no));
+				ha->flags.gpsc_supported = 0;
+				rval = QLA_FUNCTION_FAILED;
+				break;
+			}
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Save portname */
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d3b6df4..79115c1 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -475,6 +475,8 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 			set_bit(RESET_MARKER_NEEDED, &ha->dpc_flags);
 		}
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
+
+		ha->flags.gpsc_supported = 1;
 		break;
 
 	case MBA_CHG_IN_CONNECTION:	/* Change in connection mode */
-- 
1.4.4.2.g4cfec

