From: madhu.iyengar@qlogic.com
Subject: [PATCH 04/13] qla2xxx: Display nport_id when any SNS command fails.
Date: Wed, 23 Feb 2011 15:27:09 -0800
Message-ID: <1298503638-22396-5-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52612 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755017Ab1BWXa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:29 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gs.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 4c08392..a3ea6f0 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -121,8 +121,11 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 
 	rval = QLA_FUNCTION_FAILED;
 	if (ms_pkt->entry_status != 0) {
-		DEBUG2_3(printk("scsi(%ld): %s failed, error status (%x).\n",
-		    vha->host_no, routine, ms_pkt->entry_status));
+		DEBUG2_3(printk(KERN_WARNING "scsi(%ld): %s failed, error status "
+		    "(%x) on port_id: %02x%02x%02x.\n",
+		    vha->host_no, routine, ms_pkt->entry_status,
+		    vha->d_id.b.domain, vha->d_id.b.area,
+		    vha->d_id.b.al_pa));
 	} else {
 		if (IS_FWI2_CAPABLE(ha))
 			comp_status = le16_to_cpu(
@@ -136,8 +139,10 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 			if (ct_rsp->header.response !=
 			    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
 				DEBUG2_3(printk("scsi(%ld): %s failed, "
-				    "rejected request:\n", vha->host_no,
-				    routine));
+				    "rejected request on port_id: %02x%02x%02x\n",
+				    vha->host_no, routine,
+				    vha->d_id.b.domain, vha->d_id.b.area,
+				    vha->d_id.b.al_pa));
 				DEBUG2_3(qla2x00_dump_buffer(
 				    (uint8_t *)&ct_rsp->header,
 				    sizeof(struct ct_rsp_hdr)));
@@ -147,8 +152,10 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 			break;
 		default:
 			DEBUG2_3(printk("scsi(%ld): %s failed, completion "
-			    "status (%x).\n", vha->host_no, routine,
-			    comp_status));
+			    "status (%x) on port_id: %02x%02x%02x.\n",
+			    vha->host_no, routine, comp_status,
+			    vha->d_id.b.domain, vha->d_id.b.area,
+			    vha->d_id.b.al_pa));
 			break;
 		}
 	}
-- 
1.6.0.2

