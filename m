From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 11/14] target/rd: Refactor rd_build_device_space + rd_release_device_space
Date: Wed,  8 Jan 2014 20:15:54 +0000
Message-ID: <1389212157-14540-12-git-send-email-nab@daterainc.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49894 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbaAHUga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 15:36:30 -0500
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch refactors rd_build_device_space() + rd_release_device_space()
into rd_allocate_sgl_table() + rd_release_device_space() so that they
may be used seperatly for setup + release of protection information
scatterlists.

Also add explicit memset of pages within rd_allocate_sgl_table() based
upon passed 'init_payload' value.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_rd.c |  116 ++++++++++++++++++++++++---------------
 1 file changed, 71 insertions(+), 45 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 4ffe5f2..fdc5022 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -78,23 +78,14 @@ static void rd_detach_hba(struct se_hba *hba)
 	hba->hba_ptr = NULL;
 }
 
-/*	rd_release_device_space():
- *
- *
- */
-static void rd_release_device_space(struct rd_dev *rd_dev)
+static u32 rd_release_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *sg_table,
+				 u32 sg_table_count)
 {
-	u32 i, j, page_count = 0, sg_per_table;
-	struct rd_dev_sg_table *sg_table;
 	struct page *pg;
 	struct scatterlist *sg;
+	u32 i, j, page_count = 0, sg_per_table;
 
-	if (!rd_dev->sg_table_array || !rd_dev->sg_table_count)
-		return;
-
-	sg_table = rd_dev->sg_table_array;
-
-	for (i = 0; i < rd_dev->sg_table_count; i++) {
+	for (i = 0; i < sg_table_count; i++) {
 		sg = sg_table[i].sg_table;
 		sg_per_table = sg_table[i].rd_sg_count;
 
@@ -105,16 +96,31 @@ static void rd_release_device_space(struct rd_dev *rd_dev)
 				page_count++;
 			}
 		}
-
 		kfree(sg);
 	}
 
+	kfree(sg_table);
+	return page_count;
+}
+
+static void rd_release_device_space(struct rd_dev *rd_dev)
+{
+	struct rd_dev_sg_table *sg_table;
+	u32 page_count;
+
+	if (!rd_dev->sg_table_array || !rd_dev->sg_table_count)
+		return;
+
+	sg_table = rd_dev->sg_table_array;
+
+	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_table_array,
+					  rd_dev->sg_table_count);
+
 	pr_debug("CORE_RD[%u] - Released device space for Ramdisk"
 		" Device ID: %u, pages %u in %u tables total bytes %lu\n",
 		rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
 		rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
 
-	kfree(sg_table);
 	rd_dev->sg_table_array = NULL;
 	rd_dev->sg_table_count = 0;
 }
@@ -124,38 +130,15 @@ static void rd_release_device_space(struct rd_dev *rd_dev)
  *
  *
  */
-static int rd_build_device_space(struct rd_dev *rd_dev)
+static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *sg_table,
+				 u32 total_sg_needed, unsigned char init_payload)
 {
-	u32 i = 0, j, page_offset = 0, sg_per_table, sg_tables, total_sg_needed;
+	u32 i = 0, j, page_offset = 0, sg_per_table;
 	u32 max_sg_per_table = (RD_MAX_ALLOCATION_SIZE /
 				sizeof(struct scatterlist));
-	struct rd_dev_sg_table *sg_table;
 	struct page *pg;
 	struct scatterlist *sg;
-
-	if (rd_dev->rd_page_count <= 0) {
-		pr_err("Illegal page count: %u for Ramdisk device\n",
-			rd_dev->rd_page_count);
-		return -EINVAL;
-	}
-
-	/* Don't need backing pages for NULLIO */
-	if (rd_dev->rd_flags & RDF_NULLIO)
-		return 0;
-
-	total_sg_needed = rd_dev->rd_page_count;
-
-	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
-
-	sg_table = kzalloc(sg_tables * sizeof(struct rd_dev_sg_table), GFP_KERNEL);
-	if (!sg_table) {
-		pr_err("Unable to allocate memory for Ramdisk"
-			" scatterlist tables\n");
-		return -ENOMEM;
-	}
-
-	rd_dev->sg_table_array = sg_table;
-	rd_dev->sg_table_count = sg_tables;
+	unsigned char *p;
 
 	while (total_sg_needed) {
 		sg_per_table = (total_sg_needed > max_sg_per_table) ?
@@ -186,16 +169,59 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 			}
 			sg_assign_page(&sg[j], pg);
 			sg[j].length = PAGE_SIZE;
+
+			p = kmap(pg);
+			memset(p, init_payload, PAGE_SIZE);
+			kunmap(pg);
 		}
 
 		page_offset += sg_per_table;
 		total_sg_needed -= sg_per_table;
 	}
 
+	return 0;
+}
+
+static int rd_build_device_space(struct rd_dev *rd_dev)
+{
+	struct rd_dev_sg_table *sg_table;
+	u32 sg_tables, total_sg_needed;
+	u32 max_sg_per_table = (RD_MAX_ALLOCATION_SIZE /
+				sizeof(struct scatterlist));
+	int rc;
+
+	if (rd_dev->rd_page_count <= 0) {
+		pr_err("Illegal page count: %u for Ramdisk device\n",
+		       rd_dev->rd_page_count);
+		return -EINVAL;
+	}
+
+	/* Don't need backing pages for NULLIO */
+	if (rd_dev->rd_flags & RDF_NULLIO)
+		return 0;
+
+	total_sg_needed = rd_dev->rd_page_count;
+
+	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
+
+	sg_table = kzalloc(sg_tables * sizeof(struct rd_dev_sg_table), GFP_KERNEL);
+	if (!sg_table) {
+		pr_err("Unable to allocate memory for Ramdisk"
+		       " scatterlist tables\n");
+		return -ENOMEM;
+	}
+
+	rd_dev->sg_table_array = sg_table;
+	rd_dev->sg_table_count = sg_tables;
+
+	rc = rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0x00);
+	if (rc)
+		return rc;
+
 	pr_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u space of"
-		" %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,
-		rd_dev->rd_dev_id, rd_dev->rd_page_count,
-		rd_dev->sg_table_count);
+		 " %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,
+		 rd_dev->rd_dev_id, rd_dev->rd_page_count,
+		 rd_dev->sg_table_count);
 
 	return 0;
 }
-- 
1.7.10.4

