From: kxie@chelsio.com
Subject: [PATCH 1/2 2.6.30-rc v2] cxgb3i -- use kref to track ddp usage
Date: Mon, 15 Jun 2009 11:15:16 -0700
Message-ID: <200906151815.n5FIFGXM008959@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:22972 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbZFOSIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 14:08:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: kxie@chelsio.com, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

[PATCH 1/2 2.6.30-rc v2] cxgb3i -- use kref to track ddp usage

From: Karen Xie <kxie@chelsio.com>

The iscsi ddp functionality could be used by multiple iscsi entities,
add a refcnt to keep track of it, so we would not release it pre-maturely.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_ddp.c |   54 +++++++++++++++++++++++---------------
 drivers/scsi/cxgb3i/cxgb3i_ddp.h |    2 +
 2 files changed, 35 insertions(+), 21 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index 99c9125..8eb2848 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -598,30 +598,40 @@ int cxgb3i_adapter_ddp_info(struct t3cdev *tdev,
  * release all the resource held by the ddp pagepod manager for a given
  * adapter if needed
  */
-void cxgb3i_ddp_cleanup(struct t3cdev *tdev)
+
+static void ddp_cleanup(struct kref *kref)
 {
+	struct cxgb3i_ddp_info *ddp = container_of(kref,
+						struct cxgb3i_ddp_info,
+						refcnt);
 	int i = 0;
+
+	ddp_log_info("kref release ddp 0x%p, t3dev 0x%p.\n", ddp, ddp->tdev);
+
+	ddp->tdev->ulp_iscsi = NULL;
+	while (i < ddp->nppods) {
+		struct cxgb3i_gather_list *gl = ddp->gl_map[i];
+		if (gl) {
+			int npods = (gl->nelem + PPOD_PAGES_MAX - 1)
+					>> PPOD_PAGES_SHIFT;
+			ddp_log_info("t3dev 0x%p, ddp %d + %d.\n",
+					ddp->tdev, i, npods);
+			kfree(gl);
+			ddp_free_gl_skb(ddp, i, npods);
+			i += npods;
+		} else
+			i++;
+	}
+	cxgb3i_free_big_mem(ddp);
+}
+
+void cxgb3i_ddp_cleanup(struct t3cdev *tdev)
+{
 	struct cxgb3i_ddp_info *ddp = (struct cxgb3i_ddp_info *)tdev->ulp_iscsi;
 
 	ddp_log_info("t3dev 0x%p, release ddp 0x%p.\n", tdev, ddp);
-
-	if (ddp) {
-		tdev->ulp_iscsi = NULL;
-		while (i < ddp->nppods) {
-			struct cxgb3i_gather_list *gl = ddp->gl_map[i];
-			if (gl) {
-				int npods = (gl->nelem + PPOD_PAGES_MAX - 1)
-						>> PPOD_PAGES_SHIFT;
-				ddp_log_info("t3dev 0x%p, ddp %d + %d.\n",
-						tdev, i, npods);
-				kfree(gl);
-				ddp_free_gl_skb(ddp, i, npods);
-				i += npods;
-			} else
-				i++;
-		}
-		cxgb3i_free_big_mem(ddp);
-	}
+	if (ddp)
+		kref_put(&ddp->refcnt, ddp_cleanup);
 }
 
 /**
@@ -631,12 +641,13 @@ void cxgb3i_ddp_cleanup(struct t3cdev *tdev)
  */
 static void ddp_init(struct t3cdev *tdev)
 {
-	struct cxgb3i_ddp_info *ddp;
+	struct cxgb3i_ddp_info *ddp = tdev->ulp_iscsi;
 	struct ulp_iscsi_info uinfo;
 	unsigned int ppmax, bits;
 	int i, err;
 
-	if (tdev->ulp_iscsi) {
+	if (ddp) {
+		kref_get(&ddp->refcnt);
 		ddp_log_warn("t3dev 0x%p, ddp 0x%p already set up.\n",
 				tdev, tdev->ulp_iscsi);
 		return;
@@ -670,6 +681,7 @@ static void ddp_init(struct t3cdev *tdev)
 					  ppmax *
 					  sizeof(struct cxgb3i_gather_list *));
 	spin_lock_init(&ddp->map_lock);
+	kref_init(&ddp->refcnt);
 
 	ddp->tdev = tdev;
 	ddp->pdev = uinfo.pdev;
diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index 0d296de..87dd56b 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -54,6 +54,7 @@ struct cxgb3i_gather_list {
  * struct cxgb3i_ddp_info - cxgb3i direct data placement for pdu payload
  *
  * @list:	list head to link elements
+ * @refcnt:	ref. count
  * @tdev:	pointer to t3cdev used by cxgb3 driver
  * @max_txsz:	max tx packet size for ddp
  * @max_rxsz:	max rx packet size for ddp
@@ -70,6 +71,7 @@ struct cxgb3i_gather_list {
  */
 struct cxgb3i_ddp_info {
 	struct list_head list;
+	struct kref refcnt;
 	struct t3cdev *tdev;
 	struct pci_dev *pdev;
 	unsigned int max_txsz;
