From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 5/5] target/file: enable WRITE SAME when protection info is enabled
Date: Sat, 25 Apr 2015 23:33:30 +0900
Message-ID: <1429972410-7146-6-git-send-email-akinobu.mita@gmail.com>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35730 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988AbbDYOeN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Apr 2015 10:34:13 -0400
In-Reply-To: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

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
* No change from v2

 drivers/target/target_core_file.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 829817a..fe98f58 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -376,16 +376,12 @@ fd_execute_write_same(struct se_cmd *cmd)
 	struct bio_vec *bvec;
 	unsigned int len = 0, i;
 	ssize_t ret;
+	sense_reason_t rc;
 
 	if (!nolb) {
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
@@ -397,6 +393,10 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+	rc = sbc_dif_verify(cmd, cmd->t_task_lba, nolb, 0, cmd->t_prot_sg, 0);
+	if (rc)
+		return rc;
+
 	bvec = kcalloc(nolb, sizeof(struct bio_vec), GFP_KERNEL);
 	if (!bvec)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -418,6 +418,14 @@ fd_execute_write_same(struct se_cmd *cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
+	if (cmd->prot_op) {
+		ret = fd_do_rw(cmd, fd_dev->fd_prot_file, se_dev->prot_length,
+				cmd->t_prot_sg, cmd->t_prot_nents,
+				cmd->prot_length, 1);
+		if (ret < 0)
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
 	target_complete_cmd(cmd, SAM_STAT_GOOD);
 	return 0;
 }
-- 
1.9.1

