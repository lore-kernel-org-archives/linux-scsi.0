From: Colin King <colin.king@canonical.com>
Subject: [PATCH] target: need_to_release is always false, remove redundant check and kfree
Date: Fri,  6 May 2016 00:16:17 +0100
Message-ID: <1462490177-23028-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A . Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The removal the #ifdef'd code on CONFIG_ARCH_HAS_SG_CHAIN in
commit 02c4de53add1b79 ("target/rd: always chain S/G list")
removed the setting of need_to_release to true, so we are now left
with need_to_release always being false and hence the conditional
kfree is never reached.  Clean up the dead code by removing need_to_release
and the conditional kfree.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/target_core_rd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 47a833f..24b36fd 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -403,7 +403,6 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 	struct se_device *se_dev = cmd->se_dev;
 	struct rd_dev *dev = RD_DEV(se_dev);
 	struct rd_dev_sg_table *prot_table;
-	bool need_to_release = false;
 	struct scatterlist *prot_sg;
 	u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
 	u32 prot_offset, prot_page;
@@ -432,9 +431,6 @@ static sense_reason_t rd_do_prot_rw(struct se_cmd *cmd, bool is_read)
 	if (!rc)
 		sbc_dif_copy_prot(cmd, sectors, is_read, prot_sg, prot_offset);
 
-	if (need_to_release)
-		kfree(prot_sg);
-
 	return rc;
 }
 
-- 
2.8.1
