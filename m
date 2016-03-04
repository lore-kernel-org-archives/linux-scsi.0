From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 3/7] cxlflash: Split out context initialization
Date: Fri,  4 Mar 2016 15:55:16 -0600
Message-ID: <1457128520-53056-3-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:52384 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758796AbcCDV5u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 16:57:50 -0500
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Fri, 4 Mar 2016 16:57:49 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 68856C90027
	for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2016 16:57:43 -0500 (EST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u24Lvk0128246064
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 21:57:46 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u24LrQ7h029490
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 16:53:29 -0500
In-Reply-To: <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Presently, context information structures are allocated and
initialized in the same routine, create_context(). This imposes
an ordering restriction such that all pieces of information needed
to initialize a context must be known before the context is even
allocated.

This design point is not flexible when the order of context
creation needs to be modified. Specifically, this can lead to
problems when members of the context information structure are
a part of an ordering dependency (i.e. - the 'work' structure
embedded within the context).

To remedy, the allocation is left as-is, inside of the existing
create_context() routine and the initialization is transitioned
to a new void routine, init_context(). At the same time, in
anticipation of these routines not being called in sequence, a
state boolean is added to the context information structure to
track when the context has been initilized. The context teardown
routine, destroy_context(), is modified to support being called
with a non-initialized context.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 92 +++++++++++++++++++++++----------------
 drivers/scsi/cxlflash/superpipe.h |  1 +
 2 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index f4020db..b30b362 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -709,27 +709,32 @@ int cxlflash_disk_release(struct scsi_device *sdev,
  * @cfg:	Internal structure associated with the host.
  * @ctxi:	Context to release.
  *
- * Note that the rht_lun member of the context was cut from a single
- * allocation when the context was created and therefore does not need
- * to be explicitly freed. Also note that we conditionally check for the
- * existence of the context control map before clearing the RHT registers
- * and context capabilities because it is possible to destroy a context
- * while the context is in the error state (previous mapping was removed
- * [so we don't have to worry about clearing] and context is waiting for
- * a new mapping).
+ * This routine is safe to be called with a a non-initialized context
+ * and is tolerant of being called with the context's mutex held (it
+ * will be unlocked if necessary before freeing). Also note that the
+ * routine conditionally checks for the existence of the context control
+ * map before clearing the RHT registers and context capabilities because
+ * it is possible to destroy a context while the context is in the error
+ * state (previous mapping was removed [so there is no need to worry about
+ * clearing] and context is waiting for a new mapping).
  */
 static void destroy_context(struct cxlflash_cfg *cfg,
 			    struct ctx_info *ctxi)
 {
 	struct afu *afu = cfg->afu;
 
-	WARN_ON(!list_empty(&ctxi->luns));
+	if (ctxi->initialized) {
+		WARN_ON(!list_empty(&ctxi->luns));
 
-	/* Clear RHT registers and drop all capabilities for this context */
-	if (afu->afu_map && ctxi->ctrl_map) {
-		writeq_be(0, &ctxi->ctrl_map->rht_start);
-		writeq_be(0, &ctxi->ctrl_map->rht_cnt_id);
-		writeq_be(0, &ctxi->ctrl_map->ctx_cap);
+		/* Clear RHT registers and drop all capabilities for context */
+		if (afu->afu_map && ctxi->ctrl_map) {
+			writeq_be(0, &ctxi->ctrl_map->rht_start);
+			writeq_be(0, &ctxi->ctrl_map->rht_cnt_id);
+			writeq_be(0, &ctxi->ctrl_map->ctx_cap);
+		}
+
+		if (mutex_is_locked(&ctxi->mutex))
+			mutex_unlock(&ctxi->mutex);
 	}
 
 	/* Free memory associated with context */
@@ -742,23 +747,12 @@ static void destroy_context(struct cxlflash_cfg *cfg,
 /**
  * create_context() - allocates and initializes a context
  * @cfg:	Internal structure associated with the host.
- * @ctx:	Previously obtained CXL context reference.
- * @ctxid:	Previously obtained process element associated with CXL context.
- * @adap_fd:	Previously obtained adapter fd associated with CXL context.
- * @file:	Previously obtained file associated with CXL context.
- * @perms:	User-specified permissions.
- *
- * The context's mutex is locked when an allocated context is returned.
  *
  * Return: Allocated context on success, NULL on failure
  */
-static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
-				       struct cxl_context *ctx, int ctxid,
-				       int adap_fd, struct file *file,
-				       u32 perms)
+static struct ctx_info *create_context(struct cxlflash_cfg *cfg)
 {
 	struct device *dev = &cfg->dev->dev;
-	struct afu *afu = cfg->afu;
 	struct ctx_info *ctxi = NULL;
 	struct llun_info **lli = NULL;
 	u8 *ws = NULL;
@@ -781,28 +775,49 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
 	ctxi->rht_lun = lli;
 	ctxi->rht_needs_ws = ws;
 	ctxi->rht_start = rhte;
-	ctxi->rht_perms = perms;
+out:
+	return ctxi;
+
+err:
+	kfree(ws);
+	kfree(lli);
+	kfree(ctxi);
+	ctxi = NULL;
+	goto out;
+}
+
+/**
+ * init_context() - initializes a previously allocated context
+ * @ctxi:	Previously allocated context
+ * @cfg:	Internal structure associated with the host.
+ * @ctx:	Previously obtained CXL context reference.
+ * @ctxid:	Previously obtained process element associated with CXL context.
+ * @adap_fd:	Previously obtained adapter fd associated with CXL context.
+ * @file:	Previously obtained file associated with CXL context.
+ * @perms:	User-specified permissions.
+ *
+ * Upon return, the context is marked as initialized and the context's mutex
+ * is locked.
+ */
+static void init_context(struct ctx_info *ctxi, struct cxlflash_cfg *cfg,
+			 struct cxl_context *ctx, int ctxid, int adap_fd,
+			 struct file *file, u32 perms)
+{
+	struct afu *afu = cfg->afu;
 
+	ctxi->rht_perms = perms;
 	ctxi->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
 	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
 	ctxi->lfd = adap_fd;
 	ctxi->pid = current->tgid; /* tgid = pid */
 	ctxi->ctx = ctx;
 	ctxi->file = file;
+	ctxi->initialized = true;
 	mutex_init(&ctxi->mutex);
 	INIT_LIST_HEAD(&ctxi->luns);
 	INIT_LIST_HEAD(&ctxi->list); /* initialize for list_empty() */
 
 	mutex_lock(&ctxi->mutex);
-out:
-	return ctxi;
-
-err:
-	kfree(ws);
-	kfree(lli);
-	kfree(ctxi);
-	ctxi = NULL;
-	goto out;
 }
 
 /**
@@ -1396,13 +1411,16 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	/* Translate read/write O_* flags from fcntl.h to AFU permission bits */
 	perms = SISL_RHT_PERM(attach->hdr.flags + 1);
 
-	ctxi = create_context(cfg, ctx, ctxid, fd, file, perms);
+	ctxi = create_context(cfg);
 	if (unlikely(!ctxi)) {
 		dev_err(dev, "%s: Failed to create context! (%d)\n",
 			__func__, ctxid);
 		goto err3;
 	}
 
+	/* Context mutex is locked upon return */
+	init_context(ctxi, cfg, ctx, ctxid, fd, file, perms);
+
 	work = &ctxi->work;
 	work->num_interrupts = attach->num_interrupts;
 	work->flags = CXL_START_WORK_NUM_IRQS;
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index bede574..5f9a091 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -102,6 +102,7 @@ struct ctx_info {
 	u64 ctxid;
 	int lfd;
 	pid_t pid;
+	bool initialized;
 	bool unavail;
 	bool err_recovery_active;
 	struct mutex mutex; /* Context protection */
-- 
2.1.0

