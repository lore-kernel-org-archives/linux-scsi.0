From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 04/37] cxlflash: Fix potential oops following LUN removal
Date: Wed, 21 Oct 2015 15:11:18 -0500
Message-ID: <1445458278-28591-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:35276 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341AbbJUUMn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:12:43 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:12:42 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id C5D1EC9003C
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:00:50 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKCd2N47448094
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:12:39 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKCajK008106
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:12:38 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

When a LUN is removed, the sdev that is associated with the LUN
remains intact until its reference count drops to 0. In order
to prevent an sdev from being removed while a context is still
associated with it, obtain an additional reference per-context
for each LUN attached to the context.

This resolves a potential Oops in the release handler when a
dealing with a LUN that has already been removed.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/cxlflash/superpipe.c | 35 +++++++++++++++++++++++------------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 4e44a48..ffa68cc 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -880,6 +880,9 @@ static int _cxlflash_disk_detach(struct scsi_device *sdev,
 			sys_close(lfd);
 	}
 
+	/* Release the sdev reference that bound this LUN to the context */
+	scsi_device_put(sdev);
+
 out:
 	if (put_ctx)
 		put_context(ctxi);
@@ -1287,11 +1290,17 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 			}
 	}
 
+	rc = scsi_device_get(sdev);
+	if (unlikely(rc)) {
+		dev_err(dev, "%s: Unable to get sdev reference!\n", __func__);
+		goto out;
+	}
+
 	lun_access = kzalloc(sizeof(*lun_access), GFP_KERNEL);
 	if (unlikely(!lun_access)) {
 		dev_err(dev, "%s: Unable to allocate lun_access!\n", __func__);
 		rc = -ENOMEM;
-		goto out;
+		goto err0;
 	}
 
 	lun_access->lli = lli;
@@ -1311,21 +1320,21 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 		dev_err(dev, "%s: Could not initialize context %p\n",
 			__func__, ctx);
 		rc = -ENODEV;
-		goto err0;
+		goto err1;
 	}
 
 	ctxid = cxl_process_element(ctx);
 	if (unlikely((ctxid >= MAX_CONTEXT) || (ctxid < 0))) {
 		dev_err(dev, "%s: ctxid (%d) invalid!\n", __func__, ctxid);
 		rc = -EPERM;
-		goto err1;
+		goto err2;
 	}
 
 	file = cxl_get_fd(ctx, &cfg->cxl_fops, &fd);
 	if (unlikely(fd < 0)) {
 		rc = -ENODEV;
 		dev_err(dev, "%s: Could not get file descriptor\n", __func__);
-		goto err1;
+		goto err2;
 	}
 
 	/* Translate read/write O_* flags from fcntl.h to AFU permission bits */
@@ -1335,7 +1344,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	if (unlikely(!ctxi)) {
 		dev_err(dev, "%s: Failed to create context! (%d)\n",
 			__func__, ctxid);
-		goto err2;
+		goto err3;
 	}
 
 	work = &ctxi->work;
@@ -1346,13 +1355,13 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	if (unlikely(rc)) {
 		dev_dbg(dev, "%s: Could not start context rc=%d\n",
 			__func__, rc);
-		goto err3;
+		goto err4;
 	}
 
 	rc = afu_attach(cfg, ctxi);
 	if (unlikely(rc)) {
 		dev_err(dev, "%s: Could not attach AFU rc %d\n", __func__, rc);
-		goto err4;
+		goto err5;
 	}
 
 	/*
@@ -1388,13 +1397,13 @@ out:
 		__func__, ctxid, fd, attach->block_size, rc, attach->last_lba);
 	return rc;
 
-err4:
+err5:
 	cxl_stop_context(ctx);
-err3:
+err4:
 	put_context(ctxi);
 	destroy_context(cfg, ctxi);
 	ctxi = NULL;
-err2:
+err3:
 	/*
 	 * Here, we're overriding the fops with a dummy all-NULL fops because
 	 * fput() calls the release fop, which will cause us to mistakenly
@@ -1406,10 +1415,12 @@ err2:
 	fput(file);
 	put_unused_fd(fd);
 	fd = -1;
-err1:
+err2:
 	cxl_release_context(ctx);
-err0:
+err1:
 	kfree(lun_access);
+err0:
+	scsi_device_put(sdev);
 	goto out;
 }
 
-- 
2.1.0

