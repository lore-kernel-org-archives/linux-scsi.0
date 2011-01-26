From: Dan Carpenter <error27@gmail.com>
Subject: [patch] [SCSI] target: return -ENOMEM instead of -1 in
 target_core_rd.c
Date: Wed, 26 Jan 2011 11:51:23 +0300
Message-ID: <20110126085122.GL2721@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62527 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1AZIvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jan 2011 03:51:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

-1 is -EPERM but -ENOMEM is more appropriate for allocation errors.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 979aebf..e7fc512 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -161,7 +161,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	if (!(sg_table)) {
 		printk(KERN_ERR "Unable to allocate memory for Ramdisk"
 			" scatterlist tables\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	rd_dev->sg_table_array = sg_table;
@@ -176,7 +176,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 		if (!(sg)) {
 			printk(KERN_ERR "Unable to allocate scatterlist array"
 				" for struct rd_dev\n");
-			return -1;
+			return -ENOMEM;
 		}
 
 		sg_init_table((struct scatterlist *)&sg[0], sg_per_table);
@@ -192,7 +192,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 			if (!(pg)) {
 				printk(KERN_ERR "Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
-				return -1;
+				return -ENOMEM;
 			}
 			sg_assign_page(&sg[j], pg);
 			sg[j].length = PAGE_SIZE;
@@ -780,7 +780,7 @@ static int rd_DIRECT_without_offset(
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
 		if (!(se_mem)) {
 			printk(KERN_ERR "Unable to allocate struct se_mem\n");
-			return -1;
+			return -ENOMEM;
 		}
 		INIT_LIST_HEAD(&se_mem->se_list);
 
