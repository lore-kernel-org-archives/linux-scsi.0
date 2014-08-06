From: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 10/15] scsi: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:43:29 -0700
Message-ID: <1407300209-32745-1-git-send-email-hans@hanshq.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
List-Id: linux-scsi@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/scsi/cxgbi/libcxgbi.c     | 2 +-
 drivers/scsi/nsp32.c              | 2 +-
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index d65df6d..4cc9787 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1807,7 +1807,7 @@ static void csk_return_rx_credits(struct cxgbi_sock *csk, int copied)
 	u32 credits;
 
 	log_debug(1 << CXGBI_DBG_PDU_RX,
-		"csk 0x%p,%u,0x%lu,%u, seq %u, wup %u, thre %u, %u.\n",
+		"csk 0x%p,%u,0x%lx,%u, seq %u, wup %u, thre %u, %u.\n",
 		csk, csk->state, csk->flags, csk->tid, csk->copied_seq,
 		csk->rcv_wup, cdev->rx_credit_thres,
 		cdev->rcv_win);
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 50b086a..198f754 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -915,7 +915,7 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct s
 	int ret;
 
 	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
-		  "enter. target: 0x%x LUN: 0x%llu cmnd: 0x%x cmndlen: 0x%x "
+		  "enter. target: 0x%x LUN: 0x%llx cmnd: 0x%x cmndlen: 0x%x "
 		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
 		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
 		  scsi_sg_count(SCpnt), scsi_sglist(SCpnt), scsi_bufflen(SCpnt));
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index e632e14..aebe62c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2503,7 +2503,7 @@ qlt_handle_dif_error(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd,
 	    "iocb(s) %p Returned STATUS.\n", sts);
 
 	ql_dbg(ql_dbg_tgt, vha, 0xf075,
-	    "dif check TGT cdb 0x%x lba 0x%llu: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x]\n",
+	    "dif check TGT cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x]\n",
 	    cmd->atio.u.isp24.fcp_cmnd.cdb[0], lba,
 	    a_ref_tag, e_ref_tag, a_app_tag, e_app_tag, a_guard, e_guard);
 
-- 
2.0.0.526.g5318336
