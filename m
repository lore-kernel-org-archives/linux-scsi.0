From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 08/15] target/file: Add checks for backend DIF emulation
Date: Mon, 30 Mar 2015 03:28:17 +0000
Message-ID: <1427686104-14231-9-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Make sure that FILEIO only attempts to use backend DIF emulation
when it's actually enabled at device level.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index cd93935..fa54835 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -584,7 +584,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	if (data_direction == DMA_FROM_DEVICE) {
 		memset(&fd_prot, 0, sizeof(struct fd_prot));
 
-		if (cmd->prot_type) {
+		if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			ret = fd_do_prot_rw(cmd, &fd_prot, false);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -592,7 +592,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 		ret = fd_do_rw(cmd, sgl, sgl_nents, 0);
 
-		if (ret > 0 && cmd->prot_type) {
+		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			u32 sectors = cmd->data_length / dev->dev_attrib.block_size;
 
 			rc = sbc_dif_verify_read(cmd, cmd->t_task_lba, sectors,
@@ -608,7 +608,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	} else {
 		memset(&fd_prot, 0, sizeof(struct fd_prot));
 
-		if (cmd->prot_type) {
+		if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			u32 sectors = cmd->data_length / dev->dev_attrib.block_size;
 
 			ret = fd_do_prot_rw(cmd, &fd_prot, false);
@@ -646,7 +646,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 		}
 
-		if (ret > 0 && cmd->prot_type) {
+		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			ret = fd_do_prot_rw(cmd, &fd_prot, true);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-- 
1.9.1
