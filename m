From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/5] target: Use kcalloc() in two functions
Date: Sun, 9 Apr 2017 21:46:24 +0200
Message-ID: <3754914e-5269-e034-0e61-aaa19aa21107@users.sourceforge.net>
References: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <337dfdee-8a9f-9bb3-639a-ea47758966f1@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 9 Apr 2017 19:02:38 +0200

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus use the corresponding function "kcalloc".

  This issue was detected by using the Coccinelle software.

* Replace the specification of data structures by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/target_core_rd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 5f23f341f8d3..026857861107 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -210,8 +210,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 	total_sg_needed = rd_dev->rd_page_count;
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
-
-	sg_table = kzalloc(sg_tables * sizeof(struct rd_dev_sg_table), GFP_KERNEL);
+	sg_table = kcalloc(sg_tables, sizeof(*sg_table), GFP_KERNEL);
 	if (!sg_table) {
 		pr_err("Unable to allocate memory for Ramdisk"
 		       " scatterlist tables\n");
@@ -271,8 +270,7 @@ static int rd_build_prot_space(struct rd_dev *rd_dev, int prot_length, int block
 	total_sg_needed = (rd_dev->rd_page_count * prot_length / block_size) + 1;
 
 	sg_tables = (total_sg_needed / max_sg_per_table) + 1;
-
-	sg_table = kzalloc(sg_tables * sizeof(struct rd_dev_sg_table), GFP_KERNEL);
+	sg_table = kcalloc(sg_tables, sizeof(*sg_table), GFP_KERNEL);
 	if (!sg_table) {
 		pr_err("Unable to allocate memory for Ramdisk protection"
 		       " scatterlist tables\n");
-- 
2.12.2
