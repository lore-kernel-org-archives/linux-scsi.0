From: michaelc@cs.wisc.edu
Subject: [PATCH 5/7] cxgb3i -- merge cxgb3i_ddp into cxgb3i module
Date: Wed,  1 Apr 2009 13:11:27 -0500
Message-ID: <1238609492308-git-send-email-michaelc@cs.wisc.edu>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu>
 <12386094902138-git-send-email-michaelc@cs.wisc.edu>
 <12386094901595-git-send-email-michaelc@cs.wisc.edu>
 <123860949112-git-send-email-michaelc@cs.wisc.edu>
 <12386094913176-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41466 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933423AbZDASLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 14:11:43 -0400
In-Reply-To: <12386094913176-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Xie <kxie@chelsio.com>

[PATCH 2.6.30] cxgb3i -- merge cxgb3i_ddp into cxgb3i module

From: Karen Xie <kxie@chelsio.com>

- Merge cxgb3i_ddp.ko to cxgb3i.ko as there is no other users.
- Bump the driver version up to 1.0.2.

Signed-off-by: Karen Xie <kxie@chelsio.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/Kbuild           |    4 +-
 drivers/scsi/cxgb3i/cxgb3i_ddp.c     |   63 ++++++----------------------------
 drivers/scsi/cxgb3i/cxgb3i_ddp.h     |    3 ++
 drivers/scsi/cxgb3i/cxgb3i_init.c    |    6 ++-
 drivers/scsi/cxgb3i/cxgb3i_offload.h |    2 +-
 5 files changed, 21 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/cxgb3i/Kbuild b/drivers/scsi/cxgb3i/Kbuild
index ee7d6d2..25a2032 100644
--- a/drivers/scsi/cxgb3i/Kbuild
+++ b/drivers/scsi/cxgb3i/Kbuild
@@ -1,4 +1,4 @@
 EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3
 
-cxgb3i-y := cxgb3i_init.o cxgb3i_iscsi.o cxgb3i_pdu.o cxgb3i_offload.o
-obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i_ddp.o cxgb3i.o
+cxgb3i-y := cxgb3i_init.o cxgb3i_iscsi.o cxgb3i_pdu.o cxgb3i_offload.o cxgb3i_ddp.o
+obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index bb1eebf..275d2da 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -23,19 +23,6 @@
 
 #include "cxgb3i_ddp.h"
 
-#define DRV_MODULE_NAME         "cxgb3i_ddp"
-#define DRV_MODULE_VERSION      "1.0.0"
-#define DRV_MODULE_RELDATE      "Dec. 1, 2008"
-
-static char version[] =
-	"Chelsio S3xx iSCSI DDP " DRV_MODULE_NAME
-	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
-
-MODULE_AUTHOR("Karen Xie <kxie@chelsio.com>");
-MODULE_DESCRIPTION("cxgb3i ddp pagepod manager");
-MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_MODULE_VERSION);
-
 #define ddp_log_error(fmt...) printk(KERN_ERR "cxgb3i_ddp: ERR! " fmt)
 #define ddp_log_warn(fmt...)  printk(KERN_WARNING "cxgb3i_ddp: WARN! " fmt)
 #define ddp_log_info(fmt...)  printk(KERN_INFO "cxgb3i_ddp: " fmt)
@@ -212,7 +199,6 @@ int cxgb3i_ddp_find_page_index(unsigned long pgsz)
 	ddp_log_debug("ddp page size 0x%lx not supported.\n", pgsz);
 	return DDP_PGIDX_MAX;
 }
-EXPORT_SYMBOL_GPL(cxgb3i_ddp_find_page_index);
 
 static inline void ddp_gl_unmap(struct pci_dev *pdev,
 				struct cxgb3i_gather_list *gl)
@@ -335,7 +321,6 @@ error_out:
 	kfree(gl);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(cxgb3i_ddp_make_gl);
 
 /**
  * cxgb3i_ddp_release_gl - release a page buffer list
@@ -349,7 +334,6 @@ void cxgb3i_ddp_release_gl(struct cxgb3i_gather_list *gl,
 	ddp_gl_unmap(pdev, gl);
 	kfree(gl);
 }
-EXPORT_SYMBOL_GPL(cxgb3i_ddp_release_gl);
 
 /**
  * cxgb3i_ddp_tag_reserve - set up ddp for a data transfer
@@ -431,7 +415,6 @@ unmark_entries:
 	ddp_unmark_entries(ddp, idx, npods);
 	return err;
 }
-EXPORT_SYMBOL_GPL(cxgb3i_ddp_tag_reserve);
 
 /**
  * cxgb3i_ddp_tag_release - release a ddp tag
@@ -469,7 +452,6 @@ void cxgb3i_ddp_tag_release(struct t3cdev *tdev, u32 tag)
 		ddp_log_error("ddp tag 0x%x, idx 0x%x > max 0x%x.\n",
 			      tag, idx, ddp->nppods);
 }
-EXPORT_SYMBOL_GPL(cxgb3i_ddp_tag_release);
 
 static int setup_conn_pgidx(struct t3cdev *tdev, unsigned int tid, int pg_idx,
 			    int reply)
@@ -510,7 +492,6 @@ int cxgb3i_setup_conn_host_pagesize(struct t3cdev *tdev, unsigned int tid,
 {
 	return setup_conn_pgidx(tdev, tid, page_idx, reply);
 }
-EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_host_pagesize);
 
 /**
  * cxgb3i_setup_conn_pagesize - setup the conn.'s ddp page size
@@ -527,7 +508,6 @@ int cxgb3i_setup_conn_pagesize(struct t3cdev *tdev, unsigned int tid,
 
 	return setup_conn_pgidx(tdev, tid, pgidx, reply);
 }
-EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_pagesize);
 
 /**
  * cxgb3i_setup_conn_digest - setup conn. digest setting
@@ -563,7 +543,6 @@ int cxgb3i_setup_conn_digest(struct t3cdev *tdev, unsigned int tid,
 	cxgb3_ofld_send(tdev, skb);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cxgb3i_setup_conn_digest);
 
 
 /**
@@ -606,7 +585,6 @@ int cxgb3i_adapter_ddp_info(struct t3cdev *tdev,
 		     *txsz, ddp->max_txsz, *rxsz, ddp->max_rxsz);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cxgb3i_adapter_ddp_info);
 
 /**
  * ddp_release - release the cxgb3 adapter's ddp resource
@@ -651,7 +629,6 @@ static void ddp_init(struct t3cdev *tdev)
 	struct ulp_iscsi_info uinfo;
 	unsigned int ppmax, bits;
 	int i, err;
-	static int vers_printed;
 
 	if (tdev->ulp_iscsi) {
 		ddp_log_warn("t3dev 0x%p, ddp 0x%p already set up.\n",
@@ -659,11 +636,6 @@ static void ddp_init(struct t3cdev *tdev)
 		return;
 	}
 
-	if (!vers_printed) {
-		printk(KERN_INFO "%s", version);
-		vers_printed = 1;
-	}
-
 	err = tdev->ctl(tdev, ULP_ISCSI_GET_PARAMS, &uinfo);
 	if (err < 0) {
 		ddp_log_error("%s, failed to get iscsi param err=%d.\n",
@@ -730,36 +702,23 @@ free_ddp_map:
 	cxgb3i_free_big_mem(ddp);
 }
 
-static struct cxgb3_client t3c_ddp_client = {
-	.name = "iscsiddp_cxgb3",
-	.add = ddp_init,
-	.remove = ddp_release,
-};
-
 /**
- * cxgb3i_ddp_init_module - module init entry point
- * initialize any driver wide global data structures and register with the
- * cxgb3 module
+ * cxgb3i_ddp_init - initialize ddp functions
  */
-static int __init cxgb3i_ddp_init_module(void)
+void cxgb3i_ddp_init(struct t3cdev *tdev)
 {
-	page_idx = cxgb3i_ddp_find_page_index(PAGE_SIZE);
-	ddp_log_info("system PAGE_SIZE %lu, ddp idx %u.\n",
-		     PAGE_SIZE, page_idx);
-
-	cxgb3_register_client(&t3c_ddp_client);
-	return 0;
+	if (page_idx == DDP_PGIDX_MAX) {
+		page_idx = cxgb3i_ddp_find_page_index(PAGE_SIZE);
+		ddp_log_info("system PAGE_SIZE %lu, ddp idx %u.\n",
+				PAGE_SIZE, page_idx);
+	}
+	ddp_init(tdev);
 }
 
 /**
- * cxgb3i_ddp_exit_module - module cleanup/exit entry point
- * go through the ddp list, unregister with the cxgb3 module and release
- * any resource held.
+ * cxgb3i_ddp_cleaup - clean up ddp function
  */
-static void __exit cxgb3i_ddp_exit_module(void)
+void cxgb3i_ddp_cleanup(struct t3cdev *tdev)
 {
-	cxgb3_unregister_client(&t3c_ddp_client);
+	ddp_release(tdev);
 }
-
-module_init(cxgb3i_ddp_init_module);
-module_exit(cxgb3i_ddp_exit_module);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index 87f032b..0d296de 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -303,4 +303,7 @@ int cxgb3i_setup_conn_digest(struct t3cdev *, unsigned int tid,
 int cxgb3i_ddp_find_page_index(unsigned long pgsz);
 int cxgb3i_adapter_ddp_info(struct t3cdev *, struct cxgb3i_tag_format *,
 			    unsigned int *txsz, unsigned int *rxsz);
+
+void cxgb3i_ddp_init(struct t3cdev *);
+void cxgb3i_ddp_cleanup(struct t3cdev *);
 #endif
diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
index 833dbfa..042d9bc 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_init.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
@@ -12,8 +12,8 @@
 #include "cxgb3i.h"
 
 #define DRV_MODULE_NAME         "cxgb3i"
-#define DRV_MODULE_VERSION	"1.0.1"
-#define DRV_MODULE_RELDATE	"Jan. 2009"
+#define DRV_MODULE_VERSION	"1.0.2"
+#define DRV_MODULE_RELDATE	"Mar. 2009"
 
 static char version[] =
 	"Chelsio S3xx iSCSI Driver " DRV_MODULE_NAME
@@ -50,6 +50,7 @@ static void open_s3_dev(struct t3cdev *t3dev)
 		vers_printed = 1;
 	}
 
+	cxgb3i_ddp_init(t3dev);
 	cxgb3i_sdev_add(t3dev, &t3c_client);
 	cxgb3i_adapter_open(t3dev);
 }
@@ -62,6 +63,7 @@ static void close_s3_dev(struct t3cdev *t3dev)
 {
 	cxgb3i_adapter_close(t3dev);
 	cxgb3i_sdev_remove(t3dev);
+	cxgb3i_ddp_cleanup(t3dev);
 }
 
 static void s3_err_handler(struct t3cdev *tdev, u32 status, u32 error)
diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.h b/drivers/scsi/cxgb3i/cxgb3i_offload.h
index dab759d..ebfca96 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.h
@@ -16,7 +16,7 @@
 #define _CXGB3I_OFFLOAD_H
 
 #include <linux/skbuff.h>
-#include <net/tcp.h>
+#include <linux/in.h>
 
 #include "common.h"
 #include "adapter.h"
-- 
1.6.0.6

