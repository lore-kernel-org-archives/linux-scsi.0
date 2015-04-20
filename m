From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 4/4] target/file: enable WRITE SAME when protection info is enabled
Date: Tue, 21 Apr 2015 08:36:22 +0900
Message-ID: <1429572982-6809-5-git-send-email-akinobu.mita@gmail.com>
References: <1429572982-6809-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1429572982-6809-1-git-send-email-akinobu.mita@gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now we can generate correct PI for WRITE SAME command, so it is
unnecessary to disallow WRITE SAME when protection info is enabled.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/target/target_core_file.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 829817a..200d9ec 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -381,11 +381,6 @@ fd_execute_write_same(struct se_cmd *cmd)
 		target_complete_cmd(cmd, SAM_STAT_GOOD);
 		return 0;
 	}
-	if (cmd->prot_op) {
-		pr_err("WRITE_SAME: Protection information with FILEIO"
-		       " backends not supported\n");
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-	}
 
 	if (cmd->t_data_nents > 1 ||
 	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
@@ -401,6 +396,14 @@ fd_execute_write_same(struct se_cmd *cmd)
 	if (!bvec)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
+	if (cmd->prot_op) {
+		ret = fd_do_rw(cmd, fd_dev->fd_prot_file, se_dev->prot_length,
+				cmd->t_prot_sg, cmd->t_prot_nents,
+				cmd->prot_length, 0);
+		if (ret < 0)
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
 	for (i = 0; i < nolb; i++) {
 		bvec[i].bv_page = sg_page(&cmd->t_data_sg[0]);
 		bvec[i].bv_len = cmd->t_data_sg[0].length;
-- 
1.9.1
