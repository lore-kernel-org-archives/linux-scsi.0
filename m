From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH v2 1/4] driver/scsi/fnic/fnic_trace: Use kvcalloc instead of vmalloc+memset
Date: Thu, 2 Aug 2018 19:28:31 +0800
Message-ID: <1533209314-1074-2-git-send-email-zhongjiang@huawei.com>
References: <1533209314-1074-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533209314-1074-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com
Cc: andy.shevchenko@gmail.com, joe@perches.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The kvcalloc is better than vmalloc() + memset(), So replace them to make
the code concise.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/scsi/fnic/fnic_trace.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 8271785..57f67af 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -468,14 +468,13 @@ int fnic_trace_buf_init(void)
 	fnic_max_trace_entries = (trace_max_pages * PAGE_SIZE)/
 					  FNIC_ENTRY_SIZE_BYTES;
 
-	fnic_trace_buf_p = (unsigned long)vmalloc((trace_max_pages * PAGE_SIZE));
+	fnic_trace_buf_p = (unsigned long)kvcalloc(trace_max_pages, PAGE_SIZE, GFP_KERNEL);
 	if (!fnic_trace_buf_p) {
 		printk(KERN_ERR PFX "Failed to allocate memory "
 				  "for fnic_trace_buf_p\n");
 		err = -ENOMEM;
 		goto err_fnic_trace_buf_init;
 	}
-	memset((void *)fnic_trace_buf_p, 0, (trace_max_pages * PAGE_SIZE));
 
 	fnic_trace_entries.page_offset =
 		vmalloc(array_size(fnic_max_trace_entries,
@@ -484,7 +483,7 @@ int fnic_trace_buf_init(void)
 		printk(KERN_ERR PFX "Failed to allocate memory for"
 				  " page_offset\n");
 		if (fnic_trace_buf_p) {
-			vfree((void *)fnic_trace_buf_p);
+			kvfree((void *)fnic_trace_buf_p);
 			fnic_trace_buf_p = 0;
 		}
 		err = -ENOMEM;
@@ -529,7 +528,7 @@ void fnic_trace_free(void)
 		fnic_trace_entries.page_offset = NULL;
 	}
 	if (fnic_trace_buf_p) {
-		vfree((void *)fnic_trace_buf_p);
+		kvfree((void *)fnic_trace_buf_p);
 		fnic_trace_buf_p = 0;
 	}
 	printk(KERN_INFO PFX "Successfully Freed Trace Buffer\n");
-- 
1.7.12.4
