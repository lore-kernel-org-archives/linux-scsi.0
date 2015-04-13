From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/3] target/file: Fix BUG() when CONFIG_DEBUG_SG=y and DIF protection enabled
Date: Mon, 13 Apr 2015 23:21:56 +0900
Message-ID: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35182 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbbDMOWM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2015 10:22:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

When CONFIG_DEBUG_SG=y and DIF protection support enabled, kernel
BUG()s are triggered due to the following two issues:

1) prot_sg is not initialized by sg_init_table().

When CONFIG_DEBUG_SG=y, scatterlist helpers check sg entry has a
correct magic value.

2) vmalloc'ed buffer is passed to sg_set_buf().

sg_set_buf() uses virt_to_page() to convert virtual address to struct
page, but it doesn't work with vmalloc address.  vmalloc_to_page()
should be used instead.  As prot_buf isn't usually too large, so
fix it by allocating prot_buf by kmalloc instead of vmalloc.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/target/target_core_file.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 44620fb..8ca1883 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -274,7 +274,7 @@ static int fd_do_prot_rw(struct se_cmd *cmd, struct fd_prot *fd_prot,
 		     se_dev->prot_length;
 
 	if (!is_write) {
-		fd_prot->prot_buf = vzalloc(prot_size);
+		fd_prot->prot_buf = kzalloc(prot_size, GFP_KERNEL);
 		if (!fd_prot->prot_buf) {
 			pr_err("Unable to allocate fd_prot->prot_buf\n");
 			return -ENOMEM;
@@ -286,9 +286,10 @@ static int fd_do_prot_rw(struct se_cmd *cmd, struct fd_prot *fd_prot,
 					   fd_prot->prot_sg_nents, GFP_KERNEL);
 		if (!fd_prot->prot_sg) {
 			pr_err("Unable to allocate fd_prot->prot_sg\n");
-			vfree(fd_prot->prot_buf);
+			kfree(fd_prot->prot_buf);
 			return -ENOMEM;
 		}
+		sg_init_table(fd_prot->prot_sg, fd_prot->prot_sg_nents);
 		size = prot_size;
 
 		for_each_sg(fd_prot->prot_sg, sg, fd_prot->prot_sg_nents, i) {
@@ -318,7 +319,7 @@ static int fd_do_prot_rw(struct se_cmd *cmd, struct fd_prot *fd_prot,
 
 	if (is_write || ret < 0) {
 		kfree(fd_prot->prot_sg);
-		vfree(fd_prot->prot_buf);
+		kfree(fd_prot->prot_buf);
 	}
 
 	return ret;
@@ -658,11 +659,11 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 						 0, fd_prot.prot_sg, 0);
 			if (rc) {
 				kfree(fd_prot.prot_sg);
-				vfree(fd_prot.prot_buf);
+				kfree(fd_prot.prot_buf);
 				return rc;
 			}
 			kfree(fd_prot.prot_sg);
-			vfree(fd_prot.prot_buf);
+			kfree(fd_prot.prot_buf);
 		}
 	} else {
 		memset(&fd_prot, 0, sizeof(struct fd_prot));
@@ -678,7 +679,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 						  0, fd_prot.prot_sg, 0);
 			if (rc) {
 				kfree(fd_prot.prot_sg);
-				vfree(fd_prot.prot_buf);
+				kfree(fd_prot.prot_buf);
 				return rc;
 			}
 		}
@@ -714,7 +715,7 @@ fd_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (ret < 0) {
 		kfree(fd_prot.prot_sg);
-		vfree(fd_prot.prot_buf);
+		kfree(fd_prot.prot_buf);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 
-- 
1.9.1

