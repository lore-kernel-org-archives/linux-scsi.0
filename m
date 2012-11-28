From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Make spc_get_write_same_sectors return sector_t
Date: Wed, 28 Nov 2012 03:55:25 +0000
Message-ID: <1354074925-12647-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

We already expect TFO->get_blocks() to return sector_t for zero value case
when doing WRITE_SAME to the end of the backend device, so go ahead and return
sector_t from spc_get_write_same_sectors() to handle this case properly.

Also, update the single iblock_execute_write_same() caller of this code.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_iblock.c  |    2 +-
 drivers/target/target_core_sbc.c     |    2 +-
 include/target/target_core_backend.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 42cc3fb..cfdb949 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -483,7 +483,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 	struct bio *bio;
 	struct bio_list list;
 	sector_t block_lba = cmd->t_task_lba;
-	unsigned int sectors = spc_get_write_same_sectors(cmd);
+	sector_t sectors = spc_get_write_same_sectors(cmd);
 
 	sg = &cmd->t_data_sg[0];
 
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 4fd22cd..8be5bd7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -109,7 +109,7 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 	return 0;
 }
 
-int spc_get_write_same_sectors(struct se_cmd *cmd)
+sector_t spc_get_write_same_sectors(struct se_cmd *cmd)
 {
 	u32 num_blocks;
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 3393ab1..5079109 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -52,7 +52,7 @@ void	target_complete_cmd(struct se_cmd *, u8);
 
 sense_reason_t	spc_parse_cdb(struct se_cmd *cmd, unsigned int *size);
 sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
-int	spc_get_write_same_sectors(struct se_cmd *cmd);
+sector_t	spc_get_write_same_sectors(struct se_cmd *cmd);
 
 sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops);
 u32	sbc_get_device_rev(struct se_device *dev);
-- 
1.7.2.5
