From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/5]  qla2xxx: Correct loop-in-transition issues when mulitple initiators
Date: 8 Nov 2005 14:37:20 -0800
Message-ID: <20051108223716.25189.66242.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
References: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:40524 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1030335AbVKHWhU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 17:37:20 -0500
In-Reply-To: <20051108223647.25189.23124.sendpatchset@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

From: Ravi Anand <ravi.anand@qlogic.com>
are coming up in an FCAL topology.

Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_init.c |   21 +++++++++++++--------
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 ++
 2 files changed, 15 insertions(+), 8 deletions(-)

applies-to: 860072d349513d59fc6de8b6c2741a6c567bcdf0
b549339608ae9c507d2a2a8641f5914517c5714b
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 72d9090..8fb084b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -147,8 +147,8 @@ check_fw_ready_again:
 					 * LIP to complete
 					 */
 
-					if (atomic_read(&ha->loop_state) ==
-					    LOOP_DOWN && retry--) {
+					if (atomic_read(&ha->loop_state) !=
+					    LOOP_READY && retry--) {
 						goto check_fw_ready_again;
 					}
 					wait_time--;
@@ -1258,9 +1258,15 @@ qla2x00_configure_hba(scsi_qla_host_t *h
 	rval = qla2x00_get_adapter_id(ha,
 	    &loop_id, &al_pa, &area, &domain, &topo);
 	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "ERROR -- Unable to get host loop ID.\n");
-		set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		if (LOOP_NOT_READY(ha) || atomic_read(&ha->loop_down_timer) ||
+		    (rval == QLA_COMMAND_ERROR && loop_id == 0x7)) {
+			DEBUG2(printk("%s(%ld) Loop is in a transition state\n",
+			    __func__, ha->host_no));
+		} else {
+			qla_printk(KERN_WARNING, ha,
+			    "ERROR -- Unable to get host loop ID.\n");
+			set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+		}
 		return (rval);
 	}
 
@@ -1789,7 +1795,7 @@ qla2x00_configure_loop(scsi_qla_host_t *
 	}
 
 	if (rval == QLA_SUCCESS && test_bit(RSCN_UPDATE, &flags)) {
-		if (test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags)) {
+		if (LOOP_NOT_READY(ha)) {
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			rval = qla2x00_configure_fabric(ha);
@@ -2362,8 +2368,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 		if (qla2x00_is_reserved_id(ha, loop_id))
 			continue;
 
-		if (atomic_read(&ha->loop_down_timer) ||
-		    test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
+		if (atomic_read(&ha->loop_down_timer) || LOOP_NOT_READY(ha))
 			break;
 
 		if (swl != NULL) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ad3cacb..0e963bf 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1008,6 +1008,8 @@ qla2x00_get_adapter_id(scsi_qla_host_t *
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
+	if (mcp->mb[0] == MBS_COMMAND_ERROR)
+		rval = QLA_COMMAND_ERROR;
 
 	/* Return data. */
 	*id = mcp->mb[1];
---
0.99.9.GIT

-- 
Andrew Vasquez
