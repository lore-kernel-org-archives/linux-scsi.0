From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 3/6] cxlflash: Add kref to context
Date: Tue,  9 Aug 2016 18:39:42 -0500
Message-ID: <1470785982-9233-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5075 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932614AbcHIXkG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 19:40:06 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u79Nd0x9063821
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2016 19:40:06 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by mx0b-001b2d01.pphosted.com with ESMTP id 24qm9r236r-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2016 19:40:05 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 9 Aug 2016 17:40:05 -0600
In-Reply-To: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Currently, context user references are tracked via the list of LUNs
that have attached to the context. While convenient, this is not
intuitive without a deep study of the code and is inconsistent with
the existing reference tracking patterns within the kernel. This design
choice can lead to future bug injection.

To improve code comprehension and better protect against future bugs, add
explicit reference counting to contexts and migrate the context removal
code to the kref release handler.

Inspired-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 87 +++++++++++++++++++++++----------------
 drivers/scsi/cxlflash/superpipe.h |  1 +
 2 files changed, 53 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 640c3a2..be7522a 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -808,11 +808,56 @@ static void init_context(struct ctx_info *ctxi, struct cxlflash_cfg *cfg,
 	ctxi->file = file;
 	ctxi->initialized = true;
 	mutex_init(&ctxi->mutex);
+	kref_init(&ctxi->kref);
 	INIT_LIST_HEAD(&ctxi->luns);
 	INIT_LIST_HEAD(&ctxi->list); /* initialize for list_empty() */
 }
 
 /**
+ * remove_context() - context kref release handler
+ * @kref:	Kernel reference associated with context to be removed.
+ *
+ * When a context no longer has any references it can safely be removed
+ * from global access and destroyed. Note that it is assumed the thread
+ * relinquishing access to the context holds its mutex.
+ */
+static void remove_context(struct kref *kref)
+{
+	struct ctx_info *ctxi = container_of(kref, struct ctx_info, kref);
+	struct cxlflash_cfg *cfg = ctxi->cfg;
+	int lfd;
+	u64 ctxid = DECODE_CTXID(ctxi->ctxid);
+
+	/* Remove context from table/error list */
+	WARN_ON(!mutex_is_locked(&ctxi->mutex));
+	ctxi->unavail = true;
+	mutex_unlock(&ctxi->mutex);
+	mutex_lock(&cfg->ctx_tbl_list_mutex);
+	mutex_lock(&ctxi->mutex);
+
+	if (!list_empty(&ctxi->list))
+		list_del(&ctxi->list);
+	cfg->ctx_tbl[ctxid] = NULL;
+	mutex_unlock(&cfg->ctx_tbl_list_mutex);
+	mutex_unlock(&ctxi->mutex);
+
+	/* Context now completely uncoupled/unreachable */
+	lfd = ctxi->lfd;
+	destroy_context(cfg, ctxi);
+
+	/*
+	 * As a last step, clean up external resources when not
+	 * already on an external cleanup thread, i.e.: close(adap_fd).
+	 *
+	 * NOTE: this will free up the context from the CXL services,
+	 * allowing it to dole out the same context_id on a future
+	 * (or even currently in-flight) disk_attach operation.
+	 */
+	if (lfd != -1)
+		sys_close(lfd);
+}
+
+/**
  * _cxlflash_disk_detach() - detaches a LUN from a context
  * @sdev:	SCSI device associated with LUN.
  * @ctxi:	Context owning resources.
@@ -837,7 +882,6 @@ static int _cxlflash_disk_detach(struct scsi_device *sdev,
 
 	int i;
 	int rc = 0;
-	int lfd;
 	u64 ctxid = DECODE_CTXID(detach->context_id),
 	    rctxid = detach->context_id;
 
@@ -879,40 +923,12 @@ static int _cxlflash_disk_detach(struct scsi_device *sdev,
 			break;
 		}
 
-	/* Tear down context following last LUN cleanup */
-	if (list_empty(&ctxi->luns)) {
-		ctxi->unavail = true;
-		mutex_unlock(&ctxi->mutex);
-		mutex_lock(&cfg->ctx_tbl_list_mutex);
-		mutex_lock(&ctxi->mutex);
-
-		/* Might not have been in error list so conditionally remove */
-		if (!list_empty(&ctxi->list))
-			list_del(&ctxi->list);
-		cfg->ctx_tbl[ctxid] = NULL;
-		mutex_unlock(&cfg->ctx_tbl_list_mutex);
-		mutex_unlock(&ctxi->mutex);
-
-		lfd = ctxi->lfd;
-		destroy_context(cfg, ctxi);
-		ctxi = NULL;
-		put_ctx = false;
-
-		/*
-		 * As a last step, clean up external resources when not
-		 * already on an external cleanup thread, i.e.: close(adap_fd).
-		 *
-		 * NOTE: this will free up the context from the CXL services,
-		 * allowing it to dole out the same context_id on a future
-		 * (or even currently in-flight) disk_attach operation.
-		 */
-		if (lfd != -1)
-			sys_close(lfd);
-	}
-
-	/* Release the sdev reference that bound this LUN to the context */
+	/*
+	 * Release the context reference and the sdev reference that
+	 * bound this LUN to the context.
+	 */
+	put_ctx = !kref_put(&ctxi->kref, remove_context);
 	scsi_device_put(sdev);
-
 out:
 	if (put_ctx)
 		put_context(ctxi);
@@ -1369,10 +1385,11 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	lun_access->lli = lli;
 	lun_access->sdev = sdev;
 
-	/* Non-NULL context indicates reuse */
+	/* Non-NULL context indicates reuse (another context reference) */
 	if (ctxi) {
 		dev_dbg(dev, "%s: Reusing context for LUN! (%016llX)\n",
 			__func__, rctxid);
+		kref_get(&ctxi->kref);
 		list_add(&lun_access->list, &ctxi->luns);
 		fd = ctxi->lfd;
 		goto out_attach;
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 61404f2..5bda8b5 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -106,6 +106,7 @@ struct ctx_info {
 	bool unavail;
 	bool err_recovery_active;
 	struct mutex mutex; /* Context protection */
+	struct kref kref;
 	struct cxl_context *ctx;
 	struct cxlflash_cfg *cfg;
 	struct list_head luns;	/* LUNs attached to this context */
-- 
2.1.0

