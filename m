From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 21/24] target: Convert rd_build_device_space() to use errno
Date: Sat, 29 Jan 2011 10:36:21 -0800
Message-ID: <1296326184-16664-22-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm5.bullet.mail.ac4.yahoo.com ([98.139.52.202]:28405 "HELO
	nm5.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754830Ab1A2ShN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:37:13 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Dan Carpenter <error27@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Dan Carpenter <error27@gmail.com>

This patch converts rd_build_device_space() to return errno usage
for failures in rd_create_virtdevice().

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit f7446ee6eaa2d1d20692881adc705bebff0d5a1f)
---
 drivers/target/target_core_rd.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 0d0a583..663177e 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -151,7 +151,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	if (rd_dev->rd_page_count <= 0) {
 		printk(KERN_ERR "Illegal page count: %u for Ramdisk device\n",
 			rd_dev->rd_page_count);
-		return -1;
+		return -EINVAL;
 	}
 	total_sg_needed = rd_dev->rd_page_count;
 
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
@@ -254,15 +254,14 @@ static struct se_device *rd_create_virtdevice(
 	struct se_dev_limits dev_limits;
 	struct rd_dev *rd_dev = p;
 	struct rd_host *rd_host = hba->hba_ptr;
-	int dev_flags = 0, ret = -EINVAL;
+	int dev_flags = 0, ret;
 	char prod[16], rev[4];
 
 	memset(&dev_limits, 0, sizeof(struct se_dev_limits));
 
-	if (rd_build_device_space(rd_dev) < 0) {
-		ret = -ENOMEM;
+	ret = rd_build_device_space(rd_dev);
+	if (ret < 0)
 		goto fail;
-	}
 
 	snprintf(prod, 16, "RAMDISK-%s", (rd_dev->rd_direct) ? "DR" : "MCP");
 	snprintf(rev, 4, "%s", (rd_dev->rd_direct) ? RD_DR_VERSION :
-- 
1.7.3.5

