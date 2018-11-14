From: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Subject: [PATCH v2] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Wed, 14 Nov 2018 22:24:21 +0530
Message-ID: <5bec5342.1c69fb81.b02fa.ace9@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: jrdr.linux@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-scsi@vger.kernel.org

Replaced vmalloc + memset with vzalloc

Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
---
v2: Removed additional braces

 drivers/scsi/fnic/fnic_trace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 8271785..bf0fd2a 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -468,14 +468,13 @@ int fnic_trace_buf_init(void)
 	fnic_max_trace_entries = (trace_max_pages * PAGE_SIZE)/
 					  FNIC_ENTRY_SIZE_BYTES;
 
-	fnic_trace_buf_p = (unsigned long)vmalloc((trace_max_pages * PAGE_SIZE));
+	fnic_trace_buf_p = (unsigned long)vzalloc(trace_max_pages * PAGE_SIZE);
 	if (!fnic_trace_buf_p) {
 		printk(KERN_ERR PFX "Failed to allocate memory "
 				  "for fnic_trace_buf_p\n");
 		err = -ENOMEM;
 		goto err_fnic_trace_buf_init;
 	}
-	memset((void *)fnic_trace_buf_p, 0, (trace_max_pages * PAGE_SIZE));
 
 	fnic_trace_entries.page_offset =
 		vmalloc(array_size(fnic_max_trace_entries,
-- 
2.7.4
