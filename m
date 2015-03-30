From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 10/15] target/rd: Add checks for backend DIF emulation
Date: Mon, 30 Mar 2015 03:28:19 +0000
Message-ID: <1427686104-14231-11-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Make sure that RAMDISK only attempts to use backend DIF emulation
when it's actually enabled at device level.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_rd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 98e83ac..bedd4a1 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -419,7 +419,8 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			data_direction == DMA_FROM_DEVICE ? "Read" : "Write",
 			cmd->t_task_lba, rd_size, rd_page, rd_offset);
 
-	if (cmd->prot_type && data_direction == DMA_TO_DEVICE) {
+	if (cmd->prot_type && se_dev->dev_attrib.pi_prot_type &&
+	    data_direction == DMA_TO_DEVICE) {
 		struct rd_dev_sg_table *prot_table;
 		struct scatterlist *prot_sg;
 		u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
@@ -502,7 +503,8 @@ rd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 	sg_miter_stop(&m);
 
-	if (cmd->prot_type && data_direction == DMA_FROM_DEVICE) {
+	if (cmd->prot_type && se_dev->dev_attrib.pi_prot_type &&
+	    data_direction == DMA_FROM_DEVICE) {
 		struct rd_dev_sg_table *prot_table;
 		struct scatterlist *prot_sg;
 		u32 sectors = cmd->data_length / se_dev->dev_attrib.block_size;
-- 
1.9.1
