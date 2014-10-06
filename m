From: Zach Brown <zab@zabbo.net>
Subject: [PATCH] target/file: fix inclusive vfs_fsync_range() end
Date: Mon,  6 Oct 2014 16:40:13 -0700
Message-ID: <1412638813-13285-1-git-send-email-zab@zabbo.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52811 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaJFXk0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2014 19:40:26 -0400
Received: by mail-wi0-f174.google.com with SMTP id cc10so6232424wib.1
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2014 16:40:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

Both of the file target's calls to vfs_fsync_range() got the end offset
off by one.  The range is inclusive, not exclusive.  It would sync a bit
more data than was required.

The sync path already tested the length of the range and fell back to
LLONG_MAX so I copied that pattern in the rw path.

This is untested. I found the errors by inspection while following other
code.

Signed-off-by: Zach Brown <zab@zabbo.net>
---
 drivers/target/target_core_file.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 7d6cdda..176588f 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -415,7 +415,7 @@ fd_execute_sync_cache(struct se_cmd *cmd)
 	} else {
 		start = cmd->t_task_lba * dev->dev_attrib.block_size;
 		if (cmd->data_length)
-			end = start + cmd->data_length;
+			end = start + cmd->data_length - 1;
 		else
 			end = LLONG_MAX;
 	}
@@ -680,7 +680,12 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			struct fd_dev *fd_dev = FD_DEV(dev);
 			loff_t start = cmd->t_task_lba *
 				dev->dev_attrib.block_size;
-			loff_t end = start + cmd->data_length;
+			loff_t end;
+
+			if (cmd->data_length)
+				end = start + cmd->data_length - 1;
+			else
+				end = LLONG_MAX;
 
 			vfs_fsync_range(fd_dev->fd_file, start, end, 1);
 		}
-- 
1.9.3

