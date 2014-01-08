From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 12/14] target/rd: Add support for protection SGL setup + release
Date: Wed,  8 Jan 2014 20:15:55 +0000
Message-ID: <1389212157-14540-13-git-send-email-nab@daterainc.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49900 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525AbaAHUgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 15:36:31 -0500
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds rd_build_prot_space() + rd_release_prot_space() logic
to setup + release protection information scatterlists.

It also adds rd_init_prot() + rd_free_prot() se_subsystem_api
callbacks used by target core code for setup + release of
protection information.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_rd.c |   81 +++++++++++++++++++++++++++++++++++++++
 drivers/target/target_core_rd.h |    4 ++
 2 files changed, 85 insertions(+)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index fdc5022..dd99844 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -226,6 +226,64 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	return 0;
 }
 
+static void rd_release_prot_space(struct rd_dev *rd_dev)
+{
+	struct rd_dev_sg_table *sg_table;
+	u32 page_count;
+
+	if (!rd_dev->sg_prot_array || !rd_dev->sg_prot_count)
+		return;
+
+	sg_table = rd_dev->sg_prot_array;
+
+	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_prot_array,
+					  rd_dev->sg_prot_count);
+
+	pr_debug("CORE_RD[%u] - Released protection space for Ramdisk"
+		 " Device ID: %u, pages %u in %u tables total bytes %lu\n",
+		 rd_dev->rd_host->rd_host_id, rd_dev->rd_dev_id, page_count,
+		 rd_dev->sg_table_count, (unsigned long)page_count * PAGE_SIZE);
+
+	rd_dev->sg_prot_array = NULL;
+	rd_dev->sg_prot_count = 0;
+}
+
+static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length)
+{
+	struct rd_dev_sg_table *sg_table;
+	u32 total_sg_needed, sg_tables;
+	u32 max_sg_per_table = (RD_MAX_ALLOCATION_SIZE /
+				sizeof(struct scatterlist));
+	int rc;
+
+	if (rd_dev->rd_flags & RDF_NULLIO)
+		return 0;
+
+	total_sg_needed = rd_dev->rd_page_count / prot_length;
+
+	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
+
+	sg_table = kzalloc(sg_tables * sizeof(struct rd_dev_sg_table), GFP_KERNEL);
+	if (!sg_table) {
+		pr_err("Unable to allocate memory for Ramdisk protection"
+		       " scatterlist tables\n");
+		return -ENOMEM;
+	}
+
+	rd_dev->sg_prot_array = sg_table;
+	rd_dev->sg_prot_count = sg_tables;
+
+	rc = rd_allocate_sgl_table(rd_dev, sg_table, total_sg_needed, 0xff);
+	if (rc)
+		return rc;
+
+	pr_debug("CORE_RD[%u] - Built Ramdisk Device ID: %u prot space of"
+		 " %u pages in %u tables\n", rd_dev->rd_host->rd_host_id,
+		 rd_dev->rd_dev_id, total_sg_needed, rd_dev->sg_prot_count);
+
+	return 0;
+}
+
 static struct se_device *rd_alloc_device(struct se_hba *hba, const char *name)
 {
 	struct rd_dev *rd_dev;
@@ -280,6 +338,7 @@ static void rd_free_device(struct se_device *dev)
 {
 	struct rd_dev *rd_dev = RD_DEV(dev);
 
+	rd_release_prot_space(rd_dev);
 	rd_release_device_space(rd_dev);
 	kfree(rd_dev);
 }
@@ -482,6 +541,26 @@ static sector_t rd_get_blocks(struct se_device *dev)
 	return blocks_long;
 }
 
+static int rd_init_prot(struct se_device *dev)
+{
+	struct rd_dev *rd_dev = RD_DEV(dev);
+
+        if (!dev->dev_attrib.pi_prot_type)
+		return 0;
+
+	return rd_build_prot_space(rd_dev, dev->prot_length);
+}
+
+static void rd_free_prot(struct se_device *dev)
+{
+	struct rd_dev *rd_dev = RD_DEV(dev);
+
+	if (dev->dev_attrib.pi_prot_type)
+		return;
+
+	rd_release_prot_space(rd_dev);
+}
+
 static struct sbc_ops rd_sbc_ops = {
 	.execute_rw		= rd_execute_rw,
 };
@@ -507,6 +586,8 @@ static struct se_subsystem_api rd_mcp_template = {
 	.show_configfs_dev_params = rd_show_configfs_dev_params,
 	.get_device_type	= sbc_get_device_type,
 	.get_blocks		= rd_get_blocks,
+	.init_prot		= rd_init_prot,
+	.free_prot		= rd_free_prot,
 };
 
 int __init rd_module_init(void)
diff --git a/drivers/target/target_core_rd.h b/drivers/target/target_core_rd.h
index 1789d1e..cc46a6a 100644
--- a/drivers/target/target_core_rd.h
+++ b/drivers/target/target_core_rd.h
@@ -33,8 +33,12 @@ struct rd_dev {
 	u32		rd_page_count;
 	/* Number of SG tables in sg_table_array */
 	u32		sg_table_count;
+	/* Number of SG tables in sg_prot_array */
+	u32		sg_prot_count;
 	/* Array of rd_dev_sg_table_t containing scatterlists */
 	struct rd_dev_sg_table *sg_table_array;
+	/* Array of rd_dev_sg_table containing protection scatterlists */
+	struct rd_dev_sg_table *sg_prot_array;
 	/* Ramdisk HBA device is connected to */
 	struct rd_host *rd_host;
 } ____cacheline_aligned;
-- 
1.7.10.4

