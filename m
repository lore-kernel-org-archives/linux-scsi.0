From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2 04/30] cxlflash: Fix potential oops following LUN removal
Date: Wed, 16 Sep 2015 16:27:40 -0500
Message-ID: <1442438860-49316-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:44475 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbbIPV2M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 17:28:12 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 16 Sep 2015 15:28:11 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 2E39E3E40041
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 15:28:08 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8GLP6HZ10092938
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 14:25:07 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8GLS6YN025114
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 15:28:07 -0600
In-Reply-To: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

When a LUN is removed, the sdev that is associated with the LUN
remains intact until its reference count drops to 0. In order
to prevent an sdev from being removed while a context is still
associated with it, obtain an additional reference per-context
for each LUN attached to the context.

This resolves a potential Oops in the release handler when a
dealing with a LUN that has already been removed.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Suggested-by: Brian King <brking@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index fa513ba..1fa4af6 100644
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
@@ -1287,11 +1290,18 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
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
+		scsi_device_put(sdev);
 		rc = -ENOMEM;
-		goto out;
+		goto err0;
 	}
 
 	lun_access->lli = lli;
@@ -1311,21 +1321,21 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 		dev_err(dev, "%s: Could not initialize context %p\n",
 			__func__, ctx);
 		rc = -ENODEV;
-		goto err0;
+		goto err1;
 	}
 
 	ctxid = cxl_process_element(ctx);
 	if (unlikely((ctxid > MAX_CONTEXT) || (ctxid < 0))) {
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
@@ -1335,7 +1345,7 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 	if (unlikely(!ctxi)) {
 		dev_err(dev, "%s: Failed to create context! (%d)\n",
 			__func__, ctxid);
-		goto err2;
+		goto err3;
 	}
 
 	work = &ctxi->work;
@@ -1346,13 +1356,13 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
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
@@ -1388,13 +1398,13 @@ out:
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
@@ -1406,10 +1416,12 @@ err2:
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

