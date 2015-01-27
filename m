From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 10/10] qla2xxx: Comment out dead code
Date: Tue, 27 Jan 2015 10:35:23 +0100
Message-ID: <54C75BDB.30502@sandisk.com>
References: <54C75AF8.90102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0093.outbound.protection.outlook.com ([207.46.100.93]:21122
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751443AbbA0Jfa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 04:35:30 -0500
In-Reply-To: <54C75AF8.90102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Comment out the code that is never reached in qlt_set_data_offset()
to avoid that static source code analysis tools report warnings for
this code.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

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
2.1.2

