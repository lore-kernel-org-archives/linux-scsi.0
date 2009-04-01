From: michaelc@cs.wisc.edu
Subject: [PATCH 3/7] cxgb3i - re-read ddp settings information after chip reset
Date: Wed,  1 Apr 2009 13:11:25 -0500
Message-ID: <123860949112-git-send-email-michaelc@cs.wisc.edu>
References: <1238609489948-git-send-email-michaelc@cs.wisc.edu>
 <12386094902138-git-send-email-michaelc@cs.wisc.edu>
 <12386094901595-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:41465 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933351AbZDASLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Apr 2009 14:11:43 -0400
In-Reply-To: <12386094901595-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>

From: Mike Christie <michaelc@cs.wisc.edu>

Orignally from Karen Xie, but merge conflicts/errors fixed up by
Mike Christie.

Re-read the ddp tag information after reset.

Signed-off-by: Karen Xie <kxie@chelsio.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/cxgb3i/cxgb3i.h       |    2 +-
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c |  114 ++++++++++++++++++++++--------------
 2 files changed, 70 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgb3i/cxgb3i.h
index 0942227..d362860 100644
--- a/drivers/scsi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgb3i/cxgb3i.h
@@ -141,7 +141,7 @@ int cxgb3i_iscsi_init(void);
 void cxgb3i_iscsi_cleanup(void);
 
 struct cxgb3i_adapter *cxgb3i_adapter_find_by_tdev(struct t3cdev *);
-struct cxgb3i_adapter *cxgb3i_adapter_open(struct t3cdev *);
+void cxgb3i_adapter_open(struct t3cdev *);
 void cxgb3i_adapter_close(struct t3cdev *);
 
 struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *);
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index ff6bfd6..fff8e43 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -71,37 +71,34 @@ struct cxgb3i_adapter *cxgb3i_adapter_find_by_tdev(struct t3cdev *tdev)
 	return NULL;
 }
 
-/**
- * cxgb3i_adapter_open - init a s3 adapter structure and any h/w settings
- * @t3dev: t3cdev adapter
- * return the resulting cxgb3i_adapter struct
- */
-struct cxgb3i_adapter *cxgb3i_adapter_open(struct t3cdev *t3dev)
+static inline int adapter_update(struct cxgb3i_adapter *snic)
 {
-	struct cxgb3i_adapter *snic;
-	struct adapter *adapter = tdev2adap(t3dev);
-	int i;
+	cxgb3i_log_info("snic 0x%p, t3dev 0x%p, updating.\n",
+			snic, snic->tdev);
+	return cxgb3i_adapter_ddp_info(snic->tdev, &snic->tag_format,
+					&snic->tx_max_size,
+					&snic->rx_max_size);
+}
 
-	snic = kzalloc(sizeof(*snic), GFP_KERNEL);
-	if (!snic) {
-		cxgb3i_api_debug("cxgb3 %s, OOM.\n", t3dev->name);
-		return NULL;
-	}
-	spin_lock_init(&snic->lock);
+static int adapter_add(struct cxgb3i_adapter *snic)
+{
+	struct t3cdev *t3dev = snic->tdev;
+	struct adapter *adapter = tdev2adap(t3dev);
+	int i, err;
 
-	snic->tdev = t3dev;
 	snic->pdev = adapter->pdev;
 	snic->tag_format.sw_bits = sw_tag_idx_bits + sw_tag_age_bits;
 
-	if (cxgb3i_adapter_ddp_init(t3dev, &snic->tag_format,
+	err = cxgb3i_adapter_ddp_info(t3dev, &snic->tag_format,
 				    &snic->tx_max_size,
-				    &snic->rx_max_size) < 0)
-		goto free_snic;
+				    &snic->rx_max_size);
+	if (err < 0)
+		return err;
 
 	for_each_port(adapter, i) {
 		snic->hba[i] = cxgb3i_hba_host_add(snic, adapter->port[i]);
 		if (!snic->hba[i])
-			goto ulp_cleanup;
+			return -EINVAL;
 	}
 	snic->hba_cnt = adapter->params.nports;
 
@@ -110,13 +107,40 @@ struct cxgb3i_adapter *cxgb3i_adapter_open(struct t3cdev *t3dev)
 	list_add_tail(&snic->list_head, &cxgb3i_snic_list);
 	write_unlock(&cxgb3i_snic_rwlock);
 
-	return snic;
+	cxgb3i_log_info("t3dev 0x%p open, snic 0x%p, %u scsi hosts added.\n",
+			t3dev, snic, snic->hba_cnt);
+	return 0;
+}
 
-ulp_cleanup:
-	cxgb3i_adapter_ddp_cleanup(t3dev);
-free_snic:
-	kfree(snic);
-	return NULL;
+/**
+ * cxgb3i_adapter_open - init a s3 adapter structure and any h/w settings
+ * @t3dev: t3cdev adapter
+ */
+void cxgb3i_adapter_open(struct t3cdev *t3dev)
+{
+	struct cxgb3i_adapter *snic = cxgb3i_adapter_find_by_tdev(t3dev);
+	int err;
+
+	if (snic)
+		err = adapter_update(snic);
+	else {
+		snic = kzalloc(sizeof(*snic), GFP_KERNEL);
+		if (snic) {
+			spin_lock_init(&snic->lock);
+			snic->tdev = t3dev;
+			err = adapter_add(snic);
+		} else
+			err = -ENOMEM;
+	}
+
+	if (err < 0) {
+		cxgb3i_log_info("snic 0x%p, f 0x%x, t3dev 0x%p open, err %d.\n",
+				snic, snic ? snic->flags : 0, t3dev, err);
+		if (snic) {
+			snic->flags &= ~CXGB3I_ADAPTER_FLAG_RESET;
+			cxgb3i_adapter_close(t3dev);
+		}
+	}
 }
 
 /**
@@ -125,31 +149,29 @@ free_snic:
  */
 void cxgb3i_adapter_close(struct t3cdev *t3dev)
 {
+	struct cxgb3i_adapter *snic = cxgb3i_adapter_find_by_tdev(t3dev);
 	int i;
-	struct cxgb3i_adapter *snic;
+
+	if (!snic || snic->flags & CXGB3I_ADAPTER_FLAG_RESET) {
+		cxgb3i_log_info("t3dev 0x%p close, snic 0x%p, f 0x%x.\n",
+				t3dev, snic, snic ? snic->flags : 0);
+		return;
+	}
 
 	/* remove from the list */
 	write_lock(&cxgb3i_snic_rwlock);
-	list_for_each_entry(snic, &cxgb3i_snic_list, list_head) {
-		if (snic->tdev == t3dev) {
-			list_del(&snic->list_head);
-			break;
-		}
-	}
+	list_del(&snic->list_head);
 	write_unlock(&cxgb3i_snic_rwlock);
 
-	if (snic) {
-		for (i = 0; i < snic->hba_cnt; i++) {
-			if (snic->hba[i]) {
-				cxgb3i_hba_host_remove(snic->hba[i]);
-				snic->hba[i] = NULL;
-			}
+	for (i = 0; i < snic->hba_cnt; i++) {
+		if (snic->hba[i]) {
+			cxgb3i_hba_host_remove(snic->hba[i]);
+			snic->hba[i] = NULL;
 		}
-
-		/* release ddp resources */
-		cxgb3i_adapter_ddp_cleanup(snic->tdev);
-		kfree(snic);
 	}
+	cxgb3i_log_info("t3dev 0x%p close, snic 0x%p, %u scsi hosts removed.\n",
+			t3dev, snic, snic->hba_cnt);
+	kfree(snic);
 }
 
 /**
@@ -189,7 +211,8 @@ struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *snic,
 	shost = iscsi_host_alloc(&cxgb3i_host_template,
 				 sizeof(struct cxgb3i_hba), 1);
 	if (!shost) {
-		cxgb3i_log_info("iscsi_host_alloc failed.\n");
+		cxgb3i_log_info("snic 0x%p, ndev 0x%p, host_alloc failed.\n",
+				snic, ndev);
 		return NULL;
 	}
 
@@ -207,7 +230,8 @@ struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *snic,
 	pci_dev_get(snic->pdev);
 	err = iscsi_host_add(shost, &snic->pdev->dev);
 	if (err) {
-		cxgb3i_log_info("iscsi_host_add failed.\n");
+		cxgb3i_log_info("snic 0x%p, ndev 0x%p, host_add failed.\n",
+				snic, ndev);
 		goto pci_dev_put;
 	}
 
-- 
1.6.0.6

