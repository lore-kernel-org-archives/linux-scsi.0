From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 4/6] cxlflash: Transition to application close model
Date: Tue,  9 Aug 2016 18:39:52 -0500
Message-ID: <1470785992-9274-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30914 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932614AbcHIXkI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 19:40:08 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u79Ncv1B069441
	for <linux-scsi@vger.kernel.org>; Tue, 9 Aug 2016 19:40:08 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24qm9sa9b7-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2016 19:40:07 -0400
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 9 Aug 2016 17:40:06 -0600
In-Reply-To: <1470785888-9112-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

Caching the adapter file descriptor and performing a close on behalf
of an application is a poor design. This is due to the fact that once
a file descriptor in installed, it is free to be altered without the
knowledge of the cxlflash driver. This can lead to inconsistencies
between the application and kernel. Furthermore, the nature of the
former design is more exploitable and thus should be abandoned.

To support applications performing a close on the adapter file that
is associated with a context, a new flag is introduced to the user
API to indicate to applications that they are responsible for the
close following the cleanup (detach) of a context. The documentation
is also updated to reflect this change in behavior.

Inspired-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 Documentation/powerpc/cxlflash.txt | 42 +++++++++++++++++++---
 drivers/scsi/cxlflash/superpipe.c  | 71 ++++++++++----------------------------
 drivers/scsi/cxlflash/vlun.c       | 13 ++-----
 include/uapi/scsi/cxlflash_ioctl.h | 19 +++++++---
 4 files changed, 73 insertions(+), 72 deletions(-)

diff --git a/Documentation/powerpc/cxlflash.txt b/Documentation/powerpc/cxlflash.txt
index 4202d1b..f4c1190 100644
--- a/Documentation/powerpc/cxlflash.txt
+++ b/Documentation/powerpc/cxlflash.txt
@@ -171,11 +171,30 @@ DK_CXLFLASH_ATTACH
           destroyed, the tokens are to be considered stale and subsequent
           usage will result in errors.
 
+	- A valid adapter file descriptor (fd2 >= 0) is only returned on
+	  the initial attach for a context. Subsequent attaches to an
+	  existing context (DK_CXLFLASH_ATTACH_REUSE_CONTEXT flag present)
+	  do not provide the adapter file descriptor as it was previously
+	  made known to the application.
+
         - When a context is no longer needed, the user shall detach from
-          the context via the DK_CXLFLASH_DETACH ioctl.
+          the context via the DK_CXLFLASH_DETACH ioctl. When this ioctl
+	  returns with a valid adapter file descriptor and the return flag
+	  DK_CXLFLASH_APP_CLOSE_ADAP_FD is present, the application _must_
+	  close the adapter file descriptor following a successful detach.
+
+	- When this ioctl returns with a valid fd2 and the return flag
+	  DK_CXLFLASH_APP_CLOSE_ADAP_FD is present, the application _must_
+	  close fd2 in the following circumstances:
+
+		+ Following a successful detach of the last user of the context
+		+ Following a successful recovery on the context's original fd2
+		+ In the child process of a fork(), following a clone ioctl,
+		  on the fd2 associated with the source context
 
-        - A close on fd2 will invalidate the tokens. This operation is not
-          required by the user.
+        - At any time, a close on fd2 will invalidate the tokens. Applications
+	  should exercise caution to only close fd2 when appropriate (outlined
+	  in the previous bullet) to avoid premature loss of I/O.
 
 DK_CXLFLASH_USER_DIRECT
 -----------------------
@@ -254,6 +273,10 @@ DK_CXLFLASH_DETACH
     success, all "tokens" which had been provided to the user from the
     DK_CXLFLASH_ATTACH onward are no longer valid.
 
+    When the DK_CXLFLASH_APP_CLOSE_ADAP_FD flag was returned on a successful
+    attach, the application _must_ close the fd2 associated with the context
+    following the detach of the final user of the context.
+
 DK_CXLFLASH_VLUN_CLONE
 ----------------------
     This ioctl is responsible for cloning a previously created
@@ -261,7 +284,7 @@ DK_CXLFLASH_VLUN_CLONE
     support maintaining user space access to storage after a process
     forks. Upon success, the child process (which invoked the ioctl)
     will have access to the same LUNs via the same resource handle(s)
-    and fd2 as the parent, but under a different context.
+    as the parent, but under a different context.
 
     Context sharing across processes is not supported with CXL and
     therefore each fork must be met with establishing a new context
@@ -275,6 +298,12 @@ DK_CXLFLASH_VLUN_CLONE
     translation tables are copied from the parent context to the child's
     and then synced with the AFU.
 
+    When the DK_CXLFLASH_APP_CLOSE_ADAP_FD flag was returned on a successful
+    attach, the application _must_ close the fd2 associated with the source
+    context (still resident/accessible in the parent process) following the
+    clone. This is to avoid a stale entry in the file descriptor table of the
+    child process.
+
 DK_CXLFLASH_VERIFY
 ------------------
     This ioctl is used to detect various changes such as the capacity of
@@ -309,6 +338,11 @@ DK_CXLFLASH_RECOVER_AFU
     at which time the context/resources they held will be freed as part of
     the release fop.
 
+    When the DK_CXLFLASH_APP_CLOSE_ADAP_FD flag was returned on a successful
+    attach, the application _must_ unmap and close the fd2 associated with the
+    original context following this ioctl returning success and indicating that
+    the context was recovered (DK_CXLFLASH_RECOVER_AFU_CONTEXT_RESET).
+
 DK_CXLFLASH_MANAGE_LUN
 ----------------------
     This ioctl is used to switch a LUN from a mode where it is available
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index be7522a..b3bb90d 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -825,7 +825,6 @@ static void remove_context(struct kref *kref)
 {
 	struct ctx_info *ctxi = container_of(kref, struct ctx_info, kref);
 	struct cxlflash_cfg *cfg = ctxi->cfg;
-	int lfd;
 	u64 ctxid = DECODE_CTXID(ctxi->ctxid);
 
 	/* Remove context from table/error list */
@@ -842,19 +841,7 @@ static void remove_context(struct kref *kref)
 	mutex_unlock(&ctxi->mutex);
 
 	/* Context now completely uncoupled/unreachable */
-	lfd = ctxi->lfd;
 	destroy_context(cfg, ctxi);
-
-	/*
-	 * As a last step, clean up external resources when not
-	 * already on an external cleanup thread, i.e.: close(adap_fd).
-	 *
-	 * NOTE: this will free up the context from the CXL services,
-	 * allowing it to dole out the same context_id on a future
-	 * (or even currently in-flight) disk_attach operation.
-	 */
-	if (lfd != -1)
-		sys_close(lfd);
 }
 
 /**
@@ -949,34 +936,18 @@ static int cxlflash_disk_detach(struct scsi_device *sdev,
  *
  * This routine is the release handler for the fops registered with
  * the CXL services on an initial attach for a context. It is called
- * when a close is performed on the adapter file descriptor returned
- * to the user. Programmatically, the user is not required to perform
- * the close, as it is handled internally via the detach ioctl when
- * a context is being removed. Note that nothing prevents the user
- * from performing a close, but the user should be aware that doing
- * so is considered catastrophic and subsequent usage of the superpipe
- * API with previously saved off tokens will fail.
+ * when a close (explicity by the user or as part of a process tear
+ * down) is performed on the adapter file descriptor returned to the
+ * user. The user should be aware that explicitly performing a close
+ * considered catastrophic and subsequent usage of the superpipe API
+ * with previously saved off tokens will fail.
  *
- * When initiated from an external close (either by the user or via
- * a process tear down), the routine derives the context reference
- * and calls detach for each LUN associated with the context. The
- * final detach operation will cause the context itself to be freed.
- * Note that the saved off lfd is reset prior to calling detach to
- * signify that the final detach should not perform a close.
- *
- * When initiated from a detach operation as part of the tear down
- * of a context, the context is first completely freed and then the
- * close is performed. This routine will fail to derive the context
- * reference (due to the context having already been freed) and then
- * call into the CXL release entry point.
- *
- * Thus, with exception to when the CXL process element (context id)
- * lookup fails (a case that should theoretically never occur), every
- * call into this routine results in a complete freeing of a context.
- *
- * As part of the detach, all per-context resources associated with the LUN
- * are cleaned up. When detaching the last LUN for a context, the context
- * itself is cleaned up and released.
+ * This routine derives the context reference and calls detach for
+ * each LUN associated with the context.The final detach operation
+ * causes the context itself to be freed. With exception to when the
+ * CXL process element (context id) lookup fails (a case that should
+ * theoretically never occur), every call into this routine results
+ * in a complete freeing of a context.
  *
  * Return: 0 on success
  */
@@ -1014,11 +985,8 @@ static int cxlflash_cxl_release(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	dev_dbg(dev, "%s: close(%d) for context %d\n",
-		__func__, ctxi->lfd, ctxid);
+	dev_dbg(dev, "%s: close for context %d\n", __func__, ctxid);
 
-	/* Reset the file descriptor to indicate we're on a close() thread */
-	ctxi->lfd = -1;
 	detach.context_id = ctxi->ctxid;
 	list_for_each_entry_safe(lun_access, t, &ctxi->luns, list)
 		_cxlflash_disk_detach(lun_access->sdev, ctxi, &detach);
@@ -1391,7 +1359,6 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 			__func__, rctxid);
 		kref_get(&ctxi->kref);
 		list_add(&lun_access->list, &ctxi->luns);
-		fd = ctxi->lfd;
 		goto out_attach;
 	}
 
@@ -1461,7 +1428,11 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	fd_install(fd, file);
 
 out_attach:
-	attach->hdr.return_flags = 0;
+	if (fd != -1)
+		attach->hdr.return_flags = DK_CXLFLASH_APP_CLOSE_ADAP_FD;
+	else
+		attach->hdr.return_flags = 0;
+
 	attach->context_id = ctxi->ctxid;
 	attach->block_size = gli->blk_len;
 	attach->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
@@ -1526,7 +1497,7 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 {
 	struct device *dev = &cfg->dev->dev;
 	int rc = 0;
-	int old_fd, fd = -1;
+	int fd = -1;
 	int ctxid = -1;
 	struct file *file;
 	struct cxl_context *ctx;
@@ -1574,7 +1545,6 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 	 * No error paths after this point. Once the fd is installed it's
 	 * visible to user space and can't be undone safely on this thread.
 	 */
-	old_fd = ctxi->lfd;
 	ctxi->ctxid = ENCODE_CTXID(ctxi, ctxid);
 	ctxi->lfd = fd;
 	ctxi->ctx = ctx;
@@ -1593,9 +1563,6 @@ static int recover_context(struct cxlflash_cfg *cfg, struct ctx_info *ctxi)
 	cfg->ctx_tbl[ctxid] = ctxi;
 	mutex_unlock(&cfg->ctx_tbl_list_mutex);
 	fd_install(fd, file);
-
-	/* Release the original adapter fd and associated CXL resources */
-	sys_close(old_fd);
 out:
 	dev_dbg(dev, "%s: returning ctxid=%d fd=%d rc=%d\n",
 		__func__, ctxid, fd, rc);
@@ -1707,7 +1674,7 @@ retry_recover:
 		recover->context_id = ctxi->ctxid;
 		recover->adap_fd = ctxi->lfd;
 		recover->mmio_size = sizeof(afu->afu_map->hosts[0].harea);
-		recover->hdr.return_flags |=
+		recover->hdr.return_flags = DK_CXLFLASH_APP_CLOSE_ADAP_FD |
 			DK_CXLFLASH_RECOVER_AFU_CONTEXT_RESET;
 		goto out;
 	}
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 50f8e93..90c5d7f 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -1135,14 +1135,13 @@ int cxlflash_disk_clone(struct scsi_device *sdev,
 	    ctxid_dst = DECODE_CTXID(clone->context_id_dst),
 	    rctxid_src = clone->context_id_src,
 	    rctxid_dst = clone->context_id_dst;
-	int adap_fd_src = clone->adap_fd_src;
 	int i, j;
 	int rc = 0;
 	bool found;
 	LIST_HEAD(sidecar);
 
-	pr_debug("%s: ctxid_src=%llu ctxid_dst=%llu adap_fd_src=%d\n",
-		 __func__, ctxid_src, ctxid_dst, adap_fd_src);
+	pr_debug("%s: ctxid_src=%llu ctxid_dst=%llu\n",
+		 __func__, ctxid_src, ctxid_dst);
 
 	/* Do not clone yourself */
 	if (unlikely(rctxid_src == rctxid_dst)) {
@@ -1166,13 +1165,6 @@ int cxlflash_disk_clone(struct scsi_device *sdev,
 		goto out;
 	}
 
-	if (unlikely(adap_fd_src != ctxi_src->lfd)) {
-		pr_debug("%s: Invalid source adapter fd! (%d)\n",
-			 __func__, adap_fd_src);
-		rc = -EINVAL;
-		goto out;
-	}
-
 	/* Verify there is no open resource handle in the destination context */
 	for (i = 0; i < MAX_RHT_PER_CONTEXT; i++)
 		if (ctxi_dst->rht_start[i].nmask != 0) {
@@ -1257,7 +1249,6 @@ int cxlflash_disk_clone(struct scsi_device *sdev,
 
 out_success:
 	list_splice(&sidecar, &ctxi_dst->luns);
-	sys_close(adap_fd_src);
 
 	/* fall through */
 out:
diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlflash_ioctl.h
index 2302f3c..6bf1f8a 100644
--- a/include/uapi/scsi/cxlflash_ioctl.h
+++ b/include/uapi/scsi/cxlflash_ioctl.h
@@ -39,19 +39,28 @@ struct dk_cxlflash_hdr {
  * at this time, this provides future flexibility.
  */
 #define DK_CXLFLASH_ALL_PORTS_ACTIVE	0x0000000000000001ULL
+#define DK_CXLFLASH_APP_CLOSE_ADAP_FD	0x0000000000000002ULL
 
 /*
- * Notes:
- * -----
+ * General Notes:
+ * -------------
  * The 'context_id' field of all ioctl structures contains the context
  * identifier for a context in the lower 32-bits (upper 32-bits are not
  * to be used when identifying a context to the AFU). That said, the value
  * in its entirety (all 64-bits) is to be treated as an opaque cookie and
  * should be presented as such when issuing ioctls.
+ */
+
+/*
+ * DK_CXLFLASH_ATTACH Notes:
+ * ------------------------
+ * Read/write access permissions are specified via the O_RDONLY, O_WRONLY,
+ * and O_RDWR flags defined in the fcntl.h header file.
  *
- * For DK_CXLFLASH_ATTACH ioctl, user specifies read/write access
- * permissions via the O_RDONLY, O_WRONLY, and O_RDWR flags defined in
- * the fcntl.h header file.
+ * A valid adapter file descriptor (fd >= 0) is only returned on the initial
+ * attach (successful) of a context. When a context is shared(reused), the user
+ * is expected to already 'know' the adapter file descriptor associated with the
+ * context.
  */
 #define DK_CXLFLASH_ATTACH_REUSE_CONTEXT	0x8000000000000000ULL
 
-- 
2.1.0

