From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 5/9] scsi: fnic: Use zeroing allocator rather than allocator/memset
Date: Sat, 30 Dec 2017 20:58:28 +0530
Message-ID: <1514647712-6332-6-git-send-email-himanshujha199640@gmail.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@adaptec.com
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use vzalloc instead of vmalloc followed by memset 0.

Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/fnic/fnic_debugfs.c | 10 ++--------
 drivers/scsi/fnic/fnic_trace.c   |  9 ++-------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 9858484..ec249bd 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -233,24 +233,18 @@ static int fnic_trace_debugfs_open(struct inode *inode,
 		return -ENOMEM;
 
 	if (*rdata_ptr == fc_trc_flag->fnic_trace) {
-		fnic_dbg_prt->buffer = vmalloc(3 *
-					(trace_max_pages * PAGE_SIZE));
+		fnic_dbg_prt->buffer = vzalloc(3 *
+					(trace_max_pages * PAGE_SIZE));
 		if (!fnic_dbg_prt->buffer) {
 			kfree(fnic_dbg_prt);
 			return -ENOMEM;
 		}
-		memset((void *)fnic_dbg_prt->buffer, 0,
-		3 * (trace_max_pages * PAGE_SIZE));
 		fnic_dbg_prt->buffer_len = fnic_get_trace_data(fnic_dbg_prt);
 	} else {
-		fnic_dbg_prt->buffer =
-			vmalloc(3 * (fnic_fc_trace_max_pages * PAGE_SIZE));
+		fnic_dbg_prt->buffer =
+			vzalloc(3 * (fnic_fc_trace_max_pages * PAGE_SIZE));
 		if (!fnic_dbg_prt->buffer) {
 			kfree(fnic_dbg_prt);
 			return -ENOMEM;
 		}
-		memset((void *)fnic_dbg_prt->buffer, 0,
-			3 * (fnic_fc_trace_max_pages * PAGE_SIZE));
 		fnic_dbg_prt->buffer_len =
 			fnic_fc_trace_get_data(fnic_dbg_prt, *rdata_ptr);
 	}
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 4826f59..e63285e 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -468,14 +468,13 @@ int fnic_trace_buf_init(void)
 	fnic_max_trace_entries = (trace_max_pages * PAGE_SIZE)/
 					  FNIC_ENTRY_SIZE_BYTES;
 
-	fnic_trace_buf_p = (unsigned long)vmalloc((trace_max_pages * PAGE_SIZE));
+	fnic_trace_buf_p = (unsigned long)vzalloc((trace_max_pages
+							* PAGE_SIZE));
 	if (!fnic_trace_buf_p) {
 		printk(KERN_ERR PFX "Failed to allocate memory "
 				  "for fnic_trace_buf_p\n");
 		err = -ENOMEM;
 		goto err_fnic_trace_buf_init;
 	}
-	memset((void *)fnic_trace_buf_p, 0, (trace_max_pages * PAGE_SIZE));
 
 	fnic_trace_entries.page_offset = vmalloc(fnic_max_trace_entries *
 						  sizeof(unsigned long));
@@ -555,8 +554,7 @@ int fnic_fc_trace_init(void)
 
 	fc_trace_max_entries = (fnic_fc_trace_max_pages * PAGE_SIZE)/
 				FC_TRC_SIZE_BYTES;
-	fnic_fc_ctlr_trace_buf_p = (unsigned long)vmalloc(
-					fnic_fc_trace_max_pages * PAGE_SIZE);
+	fnic_fc_ctlr_trace_buf_p = (unsigned long)vzalloc(
+					fnic_fc_trace_max_pages * PAGE_SIZE);
 	if (!fnic_fc_ctlr_trace_buf_p) {
 		pr_err("fnic: Failed to allocate memory for "
 		       "FC Control Trace Buf\n");
@@ -564,9 +562,6 @@ int fnic_fc_trace_init(void)
 		goto err_fnic_fc_ctlr_trace_buf_init;
 	}
 
-	memset((void *)fnic_fc_ctlr_trace_buf_p, 0,
-			fnic_fc_trace_max_pages * PAGE_SIZE);
-
 	/* Allocate memory for page offset */
 	fc_trace_entries.page_offset = vmalloc(fc_trace_max_entries *
 						sizeof(unsigned long));
-- 
2.7.4
