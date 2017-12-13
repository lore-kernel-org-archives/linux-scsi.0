From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] qedi: Fix a possible sleep-in-atomic bug in qedi_process_tmf_resp
Date: Wed, 13 Dec 2017 17:11:08 +0800
Message-ID: <1513156268-13328-1-git-send-email-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep under a spinlock.
The function call path is:
qedi_cpu_offline (acquire the spinlock)
  qedi_fp_process_cqes
    qedi_mtask_completion
      qedi_process_tmf_resp
        kzalloc(GFP_KERNEL) --> may sleep

To fix it, GFP_KERNEL is replaced with GFP_ATOMIC.

This bug is found by my static analysis tool(DSAC) and checked by my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/qedi/qedi_fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index bd302d3..20a9259 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -198,7 +198,7 @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
 	cqe_tmp_response = &cqe->cqe_common.iscsi_hdr.tmf_response;
 
 	qedi_cmd = task->dd_data;
-	qedi_cmd->tmf_resp_buf = kzalloc(sizeof(*resp_hdr_ptr), GFP_KERNEL);
+	qedi_cmd->tmf_resp_buf = kzalloc(sizeof(*resp_hdr_ptr), GFP_ATOMIC);
 	if (!qedi_cmd->tmf_resp_buf) {
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Failed to allocate resp buf, cid=0x%x\n",
-- 
1.7.9.5
