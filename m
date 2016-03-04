From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 4/7] cxlflash: Simplify attach path error cleanup
Date: Fri,  4 Mar 2016 15:55:17 -0600
Message-ID: <1457128520-53056-4-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1457128424-53017-1-git-send-email-ukrishn@linux.vnet.ibm.com>
 <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:49547 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759087AbcCDV6D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2016 16:58:03 -0500
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Fri, 4 Mar 2016 16:58:02 -0500
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id CFC876E8041
	for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2016 16:44:50 -0500 (EST)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u24Lvxeq32964814
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 21:57:59 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u24Lrf6F029990
	for <linux-scsi@vger.kernel.org>; Fri, 4 Mar 2016 16:53:42 -0500
In-Reply-To: <1457128520-53056-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The cxlflash_disk_attach() routine currently uses a cascading error
gate strategy for its error cleanup path. While this strategy is
commonly used to handle cleanup scenarios, it is too restrictive when
function callouts need to be restructured. Problems range from
inserting error path bugs in previously 'good' code to the cleanup
path imposing design changes to how the normal path is structured.
A less restrictive approach is needed to support ordering changes
that come about when operating in different environments.

To overcome this restriction, the error cleanup path is modified to
have a single entrypoint and use conditional logic to cleanup where
necessary. Entities that require multiple cleanup steps must be
carefully vetted to ensure their APIs support state. In cases where
they do not (none as of this commit) additional local variables can
be used to maintain state on their behalf.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 55 ++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index b30b362..7ec0b7a 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1315,9 +1315,9 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	u32 perms;
 	int ctxid = -1;
 	u64 rctxid = 0UL;
-	struct file *file;
+	struct file *file = NULL;
 
-	struct cxl_context *ctx;
+	struct cxl_context *ctx = NULL;
 
 	int fd = -1;
 
@@ -1371,7 +1371,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	if (unlikely(!lun_access)) {
 		dev_err(dev, "%s: Unable to allocate lun_access!\n", __func__);
 		rc = -ENOMEM;
-		goto err0;
+		goto err;
 	}
 
 	lun_access->lli = lli;
@@ -1391,21 +1391,21 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 		dev_err(dev, "%s: Could not initialize context %p\n",
 			__func__, ctx);
 		rc = -ENODEV;
-		goto err1;
+		goto err;
 	}
 
 	ctxid = cxl_process_element(ctx);
 	if (unlikely((ctxid >= MAX_CONTEXT) || (ctxid < 0))) {
 		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
 		rc = -EPERM;
-		goto err2;
+		goto err;
 	}
 
 	file = cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
 	if (unlikely(fd < 0)) {
 		rc = -ENODEV;
 		dev_err(dev, "%s: Could not get file descriptor\n", __func__);
-		goto err2;
+		goto err;
 	}
 
 	/* Translate read/write O_* flags from fcntl.h to AFU permission bits */
@@ -1415,7 +1415,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	if (unlikely(!ctxi)) {
 		dev_err(dev, "%s: Failed to create context! (%d)\n",
 			__func__, ctxid);
-		goto err3;
+		goto err;
 	}
 
 	/* Context mutex is locked upon return */
@@ -1429,13 +1429,13 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	if (unlikely(rc)) {
 		dev_dbg(dev, "%s: Could not start context rc=%d\n",
 			__func__, rc);
-		goto err4;
+		goto err;
 	}
 
 	rc = afu_attach(cfg, ctxi);
 	if (unlikely(rc)) {
 		dev_err(dev, "%s: Could not attach AFU rc %d\n", __func__, rc);
-		goto err5;
+		goto err;
 	}
 
 	/*
@@ -1471,13 +1471,14 @@ out:
 		__func__, ctxid, fd, attach->block_size, rc, attach->last_lba);
 	return rc;
 
-err5:
-	cxl_stop_context(ctx);
-err4:
-	put_context(ctxi);
-	destroy_context(cfg, ctxi);
-	ctxi = NULL;
-err3:
+err:
+	/* Cleanup CXL context; okay to 'stop' even if it was not started */
+	if (!IS_ERR_OR_NULL(ctx)) {
+		cxl_stop_context(ctx);
+		cxl_release_context(ctx);
+		ctx = NULL;
+	}
+
 	/*
 	 * Here, we're overriding the fops with a dummy all-NULL fops because
 	 * fput() calls the release fop, which will cause us to mistakenly
@@ -1485,15 +1486,21 @@ err3:
 	 * to that routine (cxlflash_cxl_release) we should try to fix the
 	 * issue here.
 	 */
-	file->f_op = &null_fops;
-	fput(file);
-	put_unused_fd(fd);
-	fd = -1;
-err2:
-	cxl_release_context(ctx);
-err1:
+	if (fd > 0) {
+		file->f_op = &null_fops;
+		fput(file);
+		put_unused_fd(fd);
+		fd = -1;
+		file = NULL;
+	}
+
+	/* Cleanup our context; safe to call even with mutex locked */
+	if (ctxi) {
+		destroy_context(cfg, ctxi);
+		ctxi = NULL;
+	}
+
 	kfree(lun_access);
-err0:
 	scsi_device_put(sdev);
 	goto out;
 }
-- 
2.1.0

