From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 8/9] target/file: Add checks for backend DIF emulation
Date: Sat, 28 Feb 2015 10:36:05 +0000
Message-ID: <1425119766-11878-9-git-send-email-nab@daterainc.com>
References: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:56340 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbbB1LKJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2015 06:10:09 -0500
Received: by mail-oi0-f49.google.com with SMTP id v63so19804455oia.8
        for <linux-scsi@vger.kernel.org>; Sat, 28 Feb 2015 03:10:09 -0800 (PST)
In-Reply-To: <1425119766-11878-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>

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
index aefd448..d96e699 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -647,7 +647,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	if (data_direction == DMA_FROM_DEVICE) {
 		memset(&fd_prot, 0, sizeof(struct fd_prot));
 
-		if (cmd->prot_type) {
+		if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			ret = fd_do_prot_rw(cmd, &fd_prot, false);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -655,7 +655,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 		ret = fd_do_rw(cmd, sgl, sgl_nents, 0);
 
-		if (ret > 0 && cmd->prot_type) {
+		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			u32 sectors = cmd->data_length / dev->dev_attrib.block_size;
 
 			rc = sbc_dif_verify_read(cmd, cmd->t_task_lba, sectors,
@@ -671,7 +671,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	} else {
 		memset(&fd_prot, 0, sizeof(struct fd_prot));
 
-		if (cmd->prot_type) {
+		if (cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			u32 sectors = cmd->data_length / dev->dev_attrib.block_size;
 
 			ret = fd_do_prot_rw(cmd, &fd_prot, false);
@@ -709,7 +709,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 		}
 
-		if (ret > 0 && cmd->prot_type) {
+		if (ret > 0 && cmd->prot_type && dev->dev_attrib.pi_prot_type) {
 			ret = fd_do_prot_rw(cmd, &fd_prot, true);
 			if (ret < 0)
 				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-- 
1.9.1

