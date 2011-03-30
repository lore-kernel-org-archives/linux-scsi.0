From: madhu.iyengar@qlogic.com
Subject: [PATCH 11/18] qla2xxx: Perform FCoE context reset before trying adapter reset for ISP82xx.
Date: Wed, 30 Mar 2011 11:46:26 -0700
Message-ID: <1301510793-2492-12-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45797 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755548Ab1C3SvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:16 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

For certain failures, try to recover first by doing FCoE context reset before
attempting big hammer approach(adpater reset).

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   32 ++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c  |   16 +++++++++++++---
 2 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 85dd791..3bd252f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -843,7 +843,10 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		qla_printk(KERN_WARNING, ha,
 		    "Invalid SCSI completion handle %d.\n", index);
 
-		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		if (IS_QLA82XX(ha))
+			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+		else
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		return;
 	}
 
@@ -861,7 +864,10 @@ qla2x00_process_completed_request(struct scsi_qla_host *vha,
 		qla_printk(KERN_WARNING, ha,
 		    "Invalid ISP SCSI completion handle\n");
 
-		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		if (IS_QLA82XX(ha))
+			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+		else
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	}
 }
 
@@ -878,7 +884,10 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 	if (index >= MAX_OUTSTANDING_COMMANDS) {
 		qla_printk(KERN_WARNING, ha,
 		    "%s: Invalid completion handle (%x).\n", func, index);
-		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		if (IS_QLA82XX(ha))
+			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+		else
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		goto done;
 	}
 	sp = req->outstanding_cmds[index];
@@ -1564,7 +1573,10 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		    "scsi(%ld): Invalid status handle (0x%x).\n", vha->host_no,
 		    sts->handle);
 
-		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		if (IS_QLA82XX(ha))
+			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+		else
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
 		return;
 	}
@@ -1909,13 +1921,17 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 		qla2x00_sp_compl(ha, sp);
 
 	} else if (pkt->entry_type == COMMAND_A64_TYPE || pkt->entry_type ==
-	    COMMAND_TYPE || pkt->entry_type == COMMAND_TYPE_7) {
+		COMMAND_TYPE || pkt->entry_type == COMMAND_TYPE_7
+		|| pkt->entry_type == COMMAND_TYPE_6) {
 		DEBUG2(printk("scsi(%ld): Error entry - invalid handle\n",
-		    vha->host_no));
+			vha->host_no));
 		qla_printk(KERN_WARNING, ha,
-		    "Error entry - invalid handle\n");
+			"Error entry - invalid handle\n");
 
-		set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+		if (IS_QLA82XX(ha))
+			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
+		else
+			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index aab3e20..2255033 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3612,7 +3612,8 @@ qla2x00_timer(scsi_qla_host_t *vha)
 
 	/* Loop down handler. */
 	if (atomic_read(&vha->loop_down_timer) > 0 &&
-	    !(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
+	    !(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags)) &&
+	    !(test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags))
 		&& vha->flags.online) {
 
 		if (atomic_read(&vha->loop_down_timer) ==
@@ -3648,7 +3649,11 @@ qla2x00_timer(scsi_qla_host_t *vha)
 					if (!(sfcp->flags & FCF_FCP2_DEVICE))
 						continue;
 
-					set_bit(ISP_ABORT_NEEDED,
+					if (IS_QLA82XX(ha))
+						set_bit(FCOE_CTX_RESET_NEEDED,
+							&vha->dpc_flags);
+					else
+						set_bit(ISP_ABORT_NEEDED,
 							&vha->dpc_flags);
 					break;
 				}
@@ -3667,7 +3672,12 @@ qla2x00_timer(scsi_qla_host_t *vha)
 				qla_printk(KERN_WARNING, ha,
 				    "Loop down - aborting ISP.\n");
 
-				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+				if (IS_QLA82XX(ha))
+					set_bit(FCOE_CTX_RESET_NEEDED,
+						&vha->dpc_flags);
+				else
+					set_bit(ISP_ABORT_NEEDED,
+						&vha->dpc_flags);
 			}
 		}
 		DEBUG3(printk("scsi(%ld): Loop Down - seconds remaining %d\n",
-- 
1.6.0.2

