From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/10] qla2xxx: Comment out unreachable code
Date: Thu, 4 Jun 2015 15:57:20 -0700
Message-ID: <5570D7D0.80500@sandisk.com>
References: <5570D656.9050704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0096.outbound.protection.outlook.com ([65.55.169.96]:45952
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752616AbbFDW5Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Jun 2015 18:57:25 -0400
In-Reply-To: <5570D656.9050704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Comment out the code that is never reached in qla83xx_idc_unlock()
and also in qlt_set_data_offset() to avoid that static source code
analysis tools report warnings for this code.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c     |  7 ++++++-
 drivers/scsi/qla2xxx/qla_target.c | 16 +++++++++-------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0ababd5..5a5166b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4417,7 +4417,10 @@ retry_lock2:
 void
 qla83xx_idc_unlock(scsi_qla_host_t *base_vha, uint16_t requester_id)
 {
-	uint16_t options = (requester_id << 15) | BIT_7, retry;
+#if 0
+	uint16_t options = (requester_id << 15) | BIT_7;
+#endif
+	uint16_t retry;
 	uint32_t data;
 	struct qla_hw_data *ha = base_vha->hw;
 
@@ -4453,6 +4456,7 @@ retry_unlock:
 
 	return;
 
+#if 0
 	/* XXX: IDC-unlock implementation using access-control mbx */
 	retry = 0;
 retry_unlock2:
@@ -4468,6 +4472,7 @@ retry_unlock2:
 	}
 
 	return;
+#endif
 }
 
 int
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 59a0897..22a91a3 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3699,6 +3699,14 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 
 static int qlt_set_data_offset(struct qla_tgt_cmd *cmd, uint32_t offset)
 {
+#if 1
+	/*
+	 * FIXME: Reject non zero SRR relative offset until we can test
+	 * this code properly.
+	 */
+	pr_debug("Rejecting non zero SRR rel_offs: %u\n", offset);
+	return -1;
+#else
 	struct scatterlist *sg, *sgp, *sg_srr, *sg_srr_start = NULL;
 	size_t first_offset = 0, rem_offset = offset, tmp = 0;
 	int i, sg_srr_cnt, bufflen = 0;
@@ -3708,13 +3716,6 @@ static int qlt_set_data_offset(struct qla_tgt_cmd *cmd, uint32_t offset)
 	    "cmd->sg_cnt: %u, direction: %d\n",
 	    cmd, cmd->sg, cmd->sg_cnt, cmd->dma_data_direction);
 
-	/*
-	 * FIXME: Reject non zero SRR relative offset until we can test
-	 * this code properly.
-	 */
-	pr_debug("Rejecting non zero SRR rel_offs: %u\n", offset);
-	return -1;
-
 	if (!cmd->sg || !cmd->sg_cnt) {
 		ql_dbg(ql_dbg_tgt, cmd->vha, 0xe055,
 		    "Missing cmd->sg or zero cmd->sg_cnt in"
@@ -3797,6 +3798,7 @@ static int qlt_set_data_offset(struct qla_tgt_cmd *cmd, uint32_t offset)
 		BUG();
 
 	return 0;
+#endif
 }
 
 static inline int qlt_srr_adjust_data(struct qla_tgt_cmd *cmd,
-- 
2.1.4

