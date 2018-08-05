From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH] drivers/scsi/fnic/fnic_trace: Use kvcalloc to replace vmalloc+memset
Date: Sun, 5 Aug 2018 21:41:47 +0800
Message-ID: <1533476507-16642-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: kartilak@cisco.com, john.garry@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The open code vmalloc() + memset() should be replaced by kvcalloc.
It make the code concise.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/scsi/fnic/fnic_trace.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 57f67af..e775774 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -477,8 +477,8 @@ int fnic_trace_buf_init(void)
 	}
 
 	fnic_trace_entries.page_offset =
-		vmalloc(array_size(fnic_max_trace_entries,
-				   sizeof(unsigned long)));
+			kvcalloc(fnic_max_trace_entries,
+				   sizeof(unsigned long), GFP_KERNEL);
 	if (!fnic_trace_entries.page_offset) {
 		printk(KERN_ERR PFX "Failed to allocate memory for"
 				  " page_offset\n");
@@ -489,8 +489,6 @@ int fnic_trace_buf_init(void)
 		err = -ENOMEM;
 		goto err_fnic_trace_buf_init;
 	}
-	memset((void *)fnic_trace_entries.page_offset, 0,
-		  (fnic_max_trace_entries * sizeof(unsigned long)));
 	fnic_trace_entries.wr_idx = fnic_trace_entries.rd_idx = 0;
 	fnic_buf_head = fnic_trace_buf_p;
 
@@ -524,7 +522,7 @@ void fnic_trace_free(void)
 	fnic_tracing_enabled = 0;
 	fnic_trace_debugfs_terminate();
 	if (fnic_trace_entries.page_offset) {
-		vfree((void *)fnic_trace_entries.page_offset);
+		kvfree((void *)fnic_trace_entries.page_offset);
 		fnic_trace_entries.page_offset = NULL;
 	}
 	if (fnic_trace_buf_p) {
@@ -556,8 +554,8 @@ int fnic_fc_trace_init(void)
 	fc_trace_max_entries = (fnic_fc_trace_max_pages * PAGE_SIZE)/
 				FC_TRC_SIZE_BYTES;
 	fnic_fc_ctlr_trace_buf_p =
-		(unsigned long)vmalloc(array_size(PAGE_SIZE,
-						  fnic_fc_trace_max_pages));
+		(unsigned long)kvcalloc(fnic_fc_trace_max_pages,
+					PAGE_SIZE, GFP_KERNEL);
 	if (!fnic_fc_ctlr_trace_buf_p) {
 		pr_err("fnic: Failed to allocate memory for "
 		       "FC Control Trace Buf\n");
@@ -565,25 +563,20 @@ int fnic_fc_trace_init(void)
 		goto err_fnic_fc_ctlr_trace_buf_init;
 	}
 
-	memset((void *)fnic_fc_ctlr_trace_buf_p, 0,
-			fnic_fc_trace_max_pages * PAGE_SIZE);
-
 	/* Allocate memory for page offset */
 	fc_trace_entries.page_offset =
-		vmalloc(array_size(fc_trace_max_entries,
-				   sizeof(unsigned long)));
+				kvcalloc(fc_trace_max_entries,
+					sizeof(unsigned long), GFP_KERNEL);
 	if (!fc_trace_entries.page_offset) {
 		pr_err("fnic:Failed to allocate memory for page_offset\n");
 		if (fnic_fc_ctlr_trace_buf_p) {
 			pr_err("fnic: Freeing FC Control Trace Buf\n");
-			vfree((void *)fnic_fc_ctlr_trace_buf_p);
+			kvfree((void *)fnic_fc_ctlr_trace_buf_p);
 			fnic_fc_ctlr_trace_buf_p = 0;
 		}
 		err = -ENOMEM;
 		goto err_fnic_fc_ctlr_trace_buf_init;
 	}
-	memset((void *)fc_trace_entries.page_offset, 0,
-	       (fc_trace_max_entries * sizeof(unsigned long)));
 
 	fc_trace_entries.rd_idx = fc_trace_entries.wr_idx = 0;
 	fc_trace_buf_head = fnic_fc_ctlr_trace_buf_p;
@@ -618,11 +611,11 @@ void fnic_fc_trace_free(void)
 	fnic_fc_tracing_enabled = 0;
 	fnic_fc_trace_debugfs_terminate();
 	if (fc_trace_entries.page_offset) {
-		vfree((void *)fc_trace_entries.page_offset);
+		kvfree((void *)fc_trace_entries.page_offset);
 		fc_trace_entries.page_offset = NULL;
 	}
 	if (fnic_fc_ctlr_trace_buf_p) {
-		vfree((void *)fnic_fc_ctlr_trace_buf_p);
+		kvfree((void *)fnic_fc_ctlr_trace_buf_p);
 		fnic_fc_ctlr_trace_buf_p = 0;
 	}
 	pr_info("fnic:Successfully FC_CTLR Freed Trace Buffer\n");
-- 
1.7.12.4
