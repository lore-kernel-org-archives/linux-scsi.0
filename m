From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/2]  qla2xxx: Correct mis-handling of AENs.
Date: Tue, 6 Dec 2005 10:57:06 -0800
Message-ID: <20051206185705.GE997@andrew-vasquezs-powerbook-g4-15.local>
References: <20051206185521.GD997@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:28227 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S965014AbVLFS5H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2005 13:57:07 -0500
Content-Disposition: inline
In-Reply-To: <20051206185521.GD997@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

A regression in a recent change
33135aa2a568ec1a30e734f18e5315e10516e4f3 caused the driver
to mistakenly drop handling of AENs.  Due to the incorrect
handling, ports would not reappear after RSCNs and LIPs.

Drops unused/incorrect compound #define from qla_def.h.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

---

 drivers/scsi/qla2xxx/qla_def.h  |   10 +---------
 drivers/scsi/qla2xxx/qla_init.c |    6 +++---
 2 files changed, 4 insertions(+), 12 deletions(-)

eb897bf0f1298b29f039010b73c3db6e4e621380
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7096945..7b3efd5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2476,17 +2476,9 @@ typedef struct scsi_qla_host {
  */
 #define LOOP_TRANSITION(ha) \
 	(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) || \
-	 test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
-
-#define LOOP_NOT_READY(ha) \
-	((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) || \
-	  test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) || \
-	  test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) || \
-	  test_bit(LOOP_RESYNC_ACTIVE, &ha->dpc_flags)) || \
+	 test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags) || \
 	 atomic_read(&ha->loop_state) == LOOP_DOWN)
 
-#define LOOP_RDY(ha)	(!LOOP_NOT_READY(ha))
-
 #define TGT_Q(ha, t) (ha->otgt[t])
 
 #define to_qla_host(x)		((scsi_qla_host_t *) (x)->hostdata)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2d72012..c46d246 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1259,7 +1259,7 @@ qla2x00_configure_hba(scsi_qla_host_t *h
 	rval = qla2x00_get_adapter_id(ha,
 	    &loop_id, &al_pa, &area, &domain, &topo);
 	if (rval != QLA_SUCCESS) {
-		if (LOOP_NOT_READY(ha) || atomic_read(&ha->loop_down_timer) ||
+		if (LOOP_TRANSITION(ha) || atomic_read(&ha->loop_down_timer) ||
 		    (rval == QLA_COMMAND_ERROR && loop_id == 0x7)) {
 			DEBUG2(printk("%s(%ld) Loop is in a transition state\n",
 			    __func__, ha->host_no));
@@ -1796,7 +1796,7 @@ qla2x00_configure_loop(scsi_qla_host_t *
 	}
 
 	if (rval == QLA_SUCCESS && test_bit(RSCN_UPDATE, &flags)) {
-		if (LOOP_NOT_READY(ha)) {
+		if (LOOP_TRANSITION(ha)) {
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			rval = qla2x00_configure_fabric(ha);
@@ -2369,7 +2369,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 		if (qla2x00_is_reserved_id(ha, loop_id))
 			continue;
 
-		if (atomic_read(&ha->loop_down_timer) || LOOP_NOT_READY(ha))
+		if (atomic_read(&ha->loop_down_timer) || LOOP_TRANSITION(ha))
 			break;
 
 		if (swl != NULL) {
-- 
0.99.9.GIT
