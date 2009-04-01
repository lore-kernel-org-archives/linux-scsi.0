From: michaelc@cs.wisc.edu
Subject: [PATCH 1/7] cxgb3i - subscribe to error notification from cxgb3 driver
Date: Wed,  1 Apr 2009 13:11:23 -0500
Message-ID: <12386094902138-git-send-email-michaelc@cs.wisc.edu>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41463 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbZDASLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 14:11:43 -0400
In-Reply-To: <1238609489948-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Xie <kxie@chelsio.com>

[PATCH 2/5 2.6.30] cxgb3i - subscribe to error notification from cxgb3 driver

From: Karen Xie <kxie@chelsio.com>

Add error notification handling function which is called during chip reset.

Signed-off-by: Karen Xie <kxie@chelsio.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i.h       |   10 ++++++----
 drivers/scsi/cxgb3i/cxgb3i_init.c  |   25 +++++++++++++++++++++++--
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c |   27 +++++++++++++++++++++++----
 3 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index a7cf550..0942227 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -66,10 +66,12 @@ struct cxgb3i_hba {
  * @pdev:	pointer to pci dev
  * @hba_cnt:	# of hbas (the same as # of ports)
  * @hba:	all the hbas on this adapter
+ * @flags:	bit flag for adapter event/status
  * @tx_max_size: max. tx packet size supported
  * @rx_max_size: max. rx packet size supported
  * @tag_format: ddp tag format settings
  */
+#define CXGB3I_ADAPTER_FLAG_RESET	0x1
 struct cxgb3i_adapter {
 	struct list_head list_head;
 	spinlock_t lock;
@@ -78,6 +80,7 @@ struct cxgb3i_adapter {
 	unsigned char hba_cnt;
 	struct cxgb3i_hba *hba[MAX_NPORTS];
 
+	unsigned int flags;
 	unsigned int tx_max_size;
 	unsigned int rx_max_size;
 
@@ -137,10 +140,9 @@ struct cxgb3i_task_data {
 int cxgb3i_iscsi_init(void);
 void cxgb3i_iscsi_cleanup(void);
 
-struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *);
-void cxgb3i_adapter_remove(struct t3cdev *);
-int cxgb3i_adapter_ulp_init(struct cxgb3i_adapter *);
-void cxgb3i_adapter_ulp_cleanup(struct cxgb3i_adapter *);
+struct cxgb3i_adapter *cxgb3i_adapter_find_by_tdev(struct t3cdev *);
+struct cxgb3i_adapter *cxgb3i_adapter_open(struct t3cdev *);
+void cxgb3i_adapter_close(struct t3cdev *);
 
 struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *);
 struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *,
diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
index 1ce9f24..833dbfa 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_init.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
@@ -26,6 +26,7 @@ MODULE_VERSION(DRV_MODULE_VERSION);
 
 static void open_s3_dev(struct t3cdev *);
 static void close_s3_dev(struct t3cdev *);
+static void s3_err_handler(struct t3cdev *tdev, u32 status, u32 error);
 
 static cxgb3_cpl_handler_func cxgb3i_cpl_handlers[NUM_CPL_CMDS];
 static struct cxgb3_client t3c_client = {
@@ -33,6 +34,7 @@ static struct cxgb3_client t3c_client = {
 	.handlers = cxgb3i_cpl_handlers,
 	.add = open_s3_dev,
 	.remove = close_s3_dev,
+	.err_handler = s3_err_handler,
 };
 
 /**
@@ -49,7 +51,7 @@ static void open_s3_dev(struct t3cdev *t3dev)
 	}
 
 	cxgb3i_sdev_add(t3dev, &t3c_client);
-	cxgb3i_adapter_add(t3dev);
+	cxgb3i_adapter_open(t3dev);
 }
 
 /**
@@ -58,10 +60,29 @@ static void open_s3_dev(struct t3cdev *t3dev)
  */
 static void close_s3_dev(struct t3cdev *t3dev)
 {
-	cxgb3i_adapter_remove(t3dev);
+	cxgb3i_adapter_close(t3dev);
 	cxgb3i_sdev_remove(t3dev);
 }
 
+static void s3_err_handler(struct t3cdev *tdev, u32 status, u32 error)
+{
+	struct cxgb3i_adapter *snic = cxgb3i_adapter_find_by_tdev(tdev);
+
+	cxgb3i_log_info("snic 0x%p, tdev 0x%p, status 0x%x, err 0x%x.\n",
+			snic, tdev, status, error);
+	if (!snic)
+		return;
+
+	switch (status) {
+	case OFFLOAD_STATUS_DOWN:
+		snic->flags |= CXGB3I_ADAPTER_FLAG_RESET;
+		break;
+	case OFFLOAD_STATUS_UP:
+		snic->flags &= ~CXGB3I_ADAPTER_FLAG_RESET;
+		break;
+	}
+}
+
 /**
  * cxgb3i_init_module - module init entry point
  *
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index e185ded..ff6bfd6 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -53,11 +53,30 @@ static LIST_HEAD(cxgb3i_snic_list);
 static DEFINE_RWLOCK(cxgb3i_snic_rwlock);
 
 /**
- * cxgb3i_adapter_add - init a s3 adapter structure and any h/w settings
+ * cxgb3i_adpater_find_by_tdev - find the cxgb3i_adapter structure via t3cdev
+ * @tdev: t3cdev pointer
+ */
+struct cxgb3i_adapter *cxgb3i_adapter_find_by_tdev(struct t3cdev *tdev)
+{
+	struct cxgb3i_adapter *snic;
+
+	read_lock(&cxgb3i_snic_rwlock);
+	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
+		if (snic->tdev == tdev) {
+			read_unlock(&cxgb3i_snic_rwlock);
+			return snic;
+		}
+	}
+	read_unlock(&cxgb3i_snic_rwlock);
+	return NULL;
+}
+
+/**
+ * cxgb3i_adapter_open - init a s3 adapter structure and any h/w settings
  * @t3dev: t3cdev adapter
  * return the resulting cxgb3i_adapter struct
  */
-struct cxgb3i_adapter *cxgb3i_adapter_add(struct t3cdev *t3dev)
+struct cxgb3i_adapter *cxgb3i_adapter_open(struct t3cdev *t3dev)
 {
 	struct cxgb3i_adapter *snic;
 	struct adapter *adapter = tdev2adap(t3dev);
@@ -101,10 +120,10 @@ free_snic:
 }
 
 /**
- * cxgb3i_adapter_remove - release the resources held and cleanup h/w settings
+ * cxgb3i_adapter_close - release the resources held and cleanup h/w settings
  * @t3dev: t3cdev adapter
  */
-void cxgb3i_adapter_remove(struct t3cdev *t3dev)
+void cxgb3i_adapter_close(struct t3cdev *t3dev)
 {
 	int i;
 	struct cxgb3i_adapter *snic;
-- 
1.6.0.6

