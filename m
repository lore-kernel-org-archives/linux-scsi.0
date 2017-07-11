From: lixiubo@cmss.chinamobile.com
Subject: [PATCH] tcmu: Fix possbile memory leak when recalculating the cmd base size
Date: Tue, 11 Jul 2017 16:05:57 +0800
Message-ID: <1499760357-15120-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

For all the entries allocated from the ring cmd area, the memory
is something like the stack, which will reserve the old data, so
the entry->req.iov_bidi_cnt maybe none zero.

To fix this, just memset all the entry memory before using it, and
also to be more readable we adjust the bidi code.

Fixed: fe25cc34795(tcmu: Recalculate the tcmu_cmd size to save cmd area
		memories)
Reported-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 2f1fa92..be62c86 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -840,6 +840,7 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 	}
 
 	entry = (void *) mb + CMDR_OFF + cmd_head;
+	memset(entry, 0, command_size);
 	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
 	entry->hdr.kflags = 0;
@@ -865,8 +866,8 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 	entry->req.iov_dif_cnt = 0;
 
 	/* Handle BIDI commands */
+	iov_cnt = 0;
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
-		iov_cnt = 0;
 		iov++;
 		ret = scatter_data_area(udev, tcmu_cmd,
 					se_cmd->t_bidi_data_sg,
@@ -879,8 +880,8 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 			pr_err("tcmu: alloc and scatter bidi data failed\n");
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		}
-		entry->req.iov_bidi_cnt = iov_cnt;
 	}
+	entry->req.iov_bidi_cnt = iov_cnt;
 
 	/*
 	 * Recalaulate the command's base size and size according
-- 
1.8.3.1
