From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 03/26] qla2xxx: Initialize FCE debugfs codes with the proper vha structure.
Date: Tue, 24 Mar 2009 09:07:57 -0700
Message-ID: <1237910900-30817-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762288AbZCXQIY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:24 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Earlier refactoring codes missed passing the proper vha structure
and instead passed the 'hardware-descriptor' ha.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index c66036d..3a9a6ca 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -71,7 +71,7 @@ qla2x00_dfs_fce_open(struct inode *inode, struct file *file)
 
 	mutex_unlock(&ha->fce_mutex);
 out:
-	return single_open(file, qla2x00_dfs_fce_show, ha);
+	return single_open(file, qla2x00_dfs_fce_show, vha);
 }
 
 static int
@@ -145,7 +145,7 @@ create_dir:
 	atomic_inc(&qla2x00_dfs_root_count);
 
 create_nodes:
-	ha->dfs_fce = debugfs_create_file("fce", S_IRUSR, ha->dfs_dir, ha,
+	ha->dfs_fce = debugfs_create_file("fce", S_IRUSR, ha->dfs_dir, vha,
 	    &dfs_fce_ops);
 	if (!ha->dfs_fce) {
 		qla_printk(KERN_NOTICE, ha,
-- 
1.6.2.rc0.55.g30aa4f

