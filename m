From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 5/6] cxlflash: Remove adapter file descriptor cache
Date: Tue,  9 Aug 2016 18:40:02 -0500
Message-ID: <1470786002-9342-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56969 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932614AbcHIXkQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 19:40:16 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u79Ncxfb087816
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2016 19:40:15 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24qm9rtcra-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2016 19:40:15 -0400
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 9 Aug 2016 17:40:14 -0600
In-Reply-To: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The adapter file descriptor was previously cached within the kernel
for a given context in order to support performing a close on behalf
of an application. This is no longer needed as applications are now
required to perform a close on the adapter file descriptor.

Inspired-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 26 +++++++++++++-------------
 drivers/scsi/cxlflash/superpipe.h |  1 -
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index b3bb90d..c91fe6f 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -788,20 +788,18 @@ err:
  * @cfg:	Internal structure associated with the host.
  * @ctx:	Previously obtained CXL context reference.
  * @ctxid:	Previously obtained process element associated with CXL context.
- * @adap_fd:	Previously obtained adapter fd associated with CXL context.
  * @file:	Previously obtained file associated with CXL context.
  * @perms:	User-specified permissions.
  */
 static void init_context(struct ctx_info *ctxi, struct cxlflash_cfg *cfg,
-			 struct cxl_context *ctx, int ctxid, int adap_fd,
-			 struct file *file, u32 perms)
+			 struct cxl_context *ctx, int ctxid, struct file *file,
+			 u32 perms)
 {
 	struct afu *afu = cfg->afu;
 
 	ctxi->rht_perms = perms;
 	ctxi->ctrl_map = &afu->afu_map->ctrls[ctxid].ctrl;
 	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
-	ctxi->lfd = adap_fd;
 	ctxi->pid = current->tgid; /* tgid = pid */
 	ctxi->ctx = ctx;
 	ctxi->cfg = cfg;
@@ -1086,8 +1084,7 @@ static int cxlflash_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto err;
 	}
 
-	dev_dbg(dev, "%s: fault(%d) for context %d\n",
-		__func__, ctxi->lfd, ctxid);
+	dev_dbg(dev, "%s: fault for context %d\n", __func__, ctxid);
 
 	if (likely(!ctxi->err_recovery_active)) {
 		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
@@ -1162,8 +1159,7 @@ static int cxlflash_cxl_mmap(struct file *file, struct vm_area_struct *vma)
 		goto out;
 	}
 
-	dev_dbg(dev, "%s: mmap(%d) for context %d\n",
-		__func__, ctxi->lfd, ctxid);
+	dev_dbg(dev, "%s: mmap for context %d\n", __func__, ctxid);
 
 	rc = cxl_fd_mmap(file, vma);
 	if (likely(!rc)) {
@@ -1406,7 +1402,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	perms = SISL_RHT_PERM(attach->hdr.flags + 1);
 
 	/* Context mutex is locked upon return */
-	init_context(ctxi, cfg, ctx, ctxid, fd, file, perms);
+	init_context(ctxi, cfg, ctx, ctxid, file, perms);
 
 	rc = afu_attach(cfg, ctxi);
 	if (unlikely(rc)) {
@@ -1488,12 +1484,15 @@ err:
  * recover_context() - recovers a context in error
  * @cfg:	Internal structure associated with the host.
  * @ctxi:	Context to release.
+ * @adap_fd:	Adapter file descriptor associated with new/recovered context.
  *
  * Restablishes the state for a context-in-error.
  *
  * Return: 0 on success, -errno on failure
  */
-static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
+static int recover_context(struct cxlflash_cfg *cfg,
+			   struct ctx_info *ctxi,
+			   int *adap_fd)
 {
 	struct device *dev = &cfg->dev->dev;
 	int rc = 0;
@@ -1546,7 +1545,6 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 	 * visible to user space and can't be undone safely on this thread.
 	 */
 	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
-	ctxi->lfd = fd;
 	ctxi->ctx = ctx;
 	ctxi->file = file;
 
@@ -1563,6 +1561,7 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 	cfg->ctx_tbl[ctxid] = ctxi;
 	mutex_unlock(&cfg->ctx_tbl_list_mutex);
 	fd_install(fd, file);
+	*adap_fd = fd;
 out:
 	dev_dbg(dev, "%s: returning ctxid=%d fd=%d rc=%d\n",
 		__func__, ctxid, fd, rc);
@@ -1621,6 +1620,7 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 	    rctxid = recover->context_id;
 	long reg;
 	int lretry = 20; /* up to 2 seconds */
+	int new_adap_fd = -1;
 	int rc = 0;
 
 	atomic_inc(&cfg->recovery_threads);
@@ -1650,7 +1650,7 @@ retry:
 
 	if (ctxi->err_recovery_active) {
 retry_recover:
-		rc = recover_context(cfg, ctxi);
+		rc = recover_context(cfg, ctxi, &new_adap_fd);
 		if (unlikely(rc)) {
 			dev_err(dev, "%s: Recovery failed for context %llu (rc=%d)\n",
 				__func__, ctxid, rc);
@@ -1672,7 +1672,7 @@ retry_recover:
 
 		ctxi->err_recovery_active = false;
 		recover->context_id = ctxi->ctxid;
-		recover->adap_fd = ctxi->lfd;
+		recover->adap_fd = new_adap_fd;
 		recover->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
 		recover->hdr.return_flags = DK_CXLFLASH_APP_CLOSE_ADAP_FD |
 			DK_CXLFLASH_RECOVER_AFU_CONTEXT_RESET;
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 5bda8b5..9e62ff3 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -100,7 +100,6 @@ struct ctx_info {
 
 	struct cxl_ioctl_start_work work;
 	u64 ctxid;
-	int lfd;
 	pid_t pid;
 	bool initialized;
 	bool unavail;
-- 
2.1.0

