From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 2/5] target: Delete error messages for failed memory
 allocations
Date: Sun, 9 Apr 2017 21:47:55 +0200
Message-ID: <0ba7f3ea-612d-c3a6-16de-8237e41da041@users.sourceforge.net>
References: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:55198 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752320AbdDITsF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 9 Apr 2017 15:48:05 -0400
In-Reply-To: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Apr 2017 19:20:26 +0200

The script "checkpatch.pl" pointed information out like the following.

WARNING: Possible unnecessary 'out of memory' message

Thus remove such statements here.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/target_core_rd.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 026857861107..838dc128d494 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -48,10 +48,8 @@ static int rd_attach_hba(struct se_hba *hba, u32 host_id)
 	struct rd_host *rd_host;
 
 	rd_host = kzalloc(sizeof(struct rd_host), GFP_KERNEL);
-	if (!rd_host) {
-		pr_err("Unable to allocate memory for struct rd_host\n");
+	if (!rd_host)
 		return -ENOMEM;
-	}
 
 	rd_host->rd_host_id = host_id;
 
@@ -148,11 +146,8 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 
 		sg = kcalloc(sg_per_table + chain_entry, sizeof(*sg),
 				GFP_KERNEL);
-		if (!sg) {
-			pr_err("Unable to allocate scatterlist array"
-				" for struct rd_dev\n");
+		if (!sg)
 			return -ENOMEM;
-		}
 
 		sg_init_table(sg, sg_per_table + chain_entry);
 
@@ -211,11 +206,8 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
 	sg_table = kcalloc(sg_tables, sizeof(*sg_table), GFP_KERNEL);
-	if (!sg_table) {
-		pr_err("Unable to allocate memory for Ramdisk"
-		       " scatterlist tables\n");
+	if (!sg_table)
 		return -ENOMEM;
-	}
 
 	rd_dev->sg_table_array = sg_table;
 	rd_dev->sg_table_count = sg_tables;
@@ -271,11 +263,8 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
 	sg_table = kcalloc(sg_tables, sizeof(*sg_table), GFP_KERNEL);
-	if (!sg_table) {
-		pr_err("Unable to allocate memory for Ramdisk protection"
-		       " scatterlist tables\n");
+	if (!sg_table)
 		return -ENOMEM;
-	}
 
 	rd_dev->sg_prot_array = sg_table;
 	rd_dev->sg_prot_count = sg_tables;
@@ -297,10 +286,8 @@ static struct se_device *rd_alloc_device(struct se_hba *hba, const char *name)
 	struct rd_host *rd_host = hba->hba_ptr;
 
 	rd_dev = kzalloc(sizeof(struct rd_dev), GFP_KERNEL);
-	if (!rd_dev) {
-		pr_err("Unable to allocate memory for struct rd_dev\n");
+	if (!rd_dev)
 		return NULL;
-	}
 
 	rd_dev->rd_host = rd_host;
 
-- 
2.12.2
