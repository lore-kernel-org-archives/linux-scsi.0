From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.12-rc6
Date: Thu, 22 Jun 2017 12:08:16 -0700
Message-ID: <1498158496.2750.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two fixes to remove spurious WARN_ONs from the new(ish) qedi driver. 
 The driver already prints a warning message, there's no need to panic
users by printing something that looks like an oops as well.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Manish Rangankar (2):
      scsi: qedi: Remove WARN_ON from clear task context.
      scsi: qedi: Remove WARN_ON for untracked cleanup.

And the diffstat:

 drivers/scsi/qedi/qedi_fw.c   | 1 -
 drivers/scsi/qedi/qedi_main.c | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)


With full diff below.

James

---

diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
index 8bc7ee1a8ca8..507512cc478b 100644
--- a/drivers/scsi/qedi/qedi_fw.c
+++ b/drivers/scsi/qedi/qedi_fw.c
@@ -870,7 +870,6 @@ static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x, task=%p\n",
 			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
-		WARN_ON(1);
 	}
 }
 
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 09a294634bc7..879d3b7462f9 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1499,11 +1499,9 @@ int qedi_get_task_idx(struct qedi_ctx *qedi)
 
 void qedi_clear_task_idx(struct qedi_ctx *qedi, int idx)
 {
-	if (!test_and_clear_bit(idx, qedi->task_idx_map)) {
+	if (!test_and_clear_bit(idx, qedi->task_idx_map))
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "FW task context, already cleared, tid=0x%x\n", idx);
-		WARN_ON(1);
-	}
 }
 
 void qedi_update_itt_map(struct qedi_ctx *qedi, u32 tid, u32 proto_itt,
