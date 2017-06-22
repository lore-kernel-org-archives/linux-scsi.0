From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 05/17] cxlflash: Handle AFU sync failures
Date: Wed, 21 Jun 2017 21:14:30 -0500
Message-ID: <1498097670-8862-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38794 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751140AbdFVCOm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Jun 2017 22:14:42 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5M2EfWY034598
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:14:42 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b7w13m0ww-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2017 22:14:41 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 21 Jun 2017 20:14:39 -0600
In-Reply-To: <1498097563-8680-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

AFU sync operations are not currently evaluated for failure. This is
acceptable for paths where there is not a dependency on the AFU being
consistent with the host. Examples include link reset events and LUN
cleanup operations. On paths where there is a dependency, such as a LUN
open, a sync failure should be acted upon.

In the event of AFU sync failures, either log or cleanup as appropriate for
operations that are dependent on a successful sync completion.

Update documentation to reflect behavior in the event of an AFU sync
failure.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 Documentation/powerpc/cxlflash.txt | 12 ++++++
 drivers/scsi/cxlflash/superpipe.c  | 34 +++++++++++++--
 drivers/scsi/cxlflash/vlun.c       | 88 +++++++++++++++++++++++++++-----------
 3 files changed, 107 insertions(+), 27 deletions(-)

diff --git a/Documentation/powerpc/cxlflash.txt b/Documentation/powerpc/cxlflash.txt
index 66b4496..f9036cb 100644
--- a/Documentation/powerpc/cxlflash.txt
+++ b/Documentation/powerpc/cxlflash.txt
@@ -257,6 +257,12 @@ DK_CXLFLASH_VLUN_RESIZE
     operating in the virtual mode and used to program a LUN translation
     table that the AFU references when provided with a resource handle.
 
+    This ioctl can return -EAGAIN if an AFU sync operation takes too long.
+    In addition to returning a failure to user, cxlflash will also schedule
+    an asynchronous AFU reset. Should the user choose to retry the operation,
+    it is expected to succeed. If this ioctl fails with -EAGAIN, the user
+    can either retry the operation or treat it as a failure.
+
 DK_CXLFLASH_RELEASE
 -------------------
     This ioctl is responsible for releasing a previously obtained
@@ -309,6 +315,12 @@ DK_CXLFLASH_VLUN_CLONE
     clone. This is to avoid a stale entry in the file descriptor table of the
     child process.
 
+    This ioctl can return -EAGAIN if an AFU sync operation takes too long.
+    In addition to returning a failure to user, cxlflash will also schedule
+    an asynchronous AFU reset. Should the user choose to retry the operation,
+    it is expected to succeed. If this ioctl fails with -EAGAIN, the user
+    can either retry the operation or treat it as a failure.
+
 DK_CXLFLASH_VERIFY
 ------------------
     This ioctl is used to detect various changes such as the capacity of
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index fe9f17a..ad0f996 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -57,6 +57,19 @@ static void marshal_det_to_rele(struct dk_cxlflash_detach *detach,
 }
 
 /**
+ * marshal_udir_to_rele() - translate udirect to release structure
+ * @udirect:	Source structure from which to translate/copy.
+ * @release:	Destination structure for the translate/copy.
+ */
+static void marshal_udir_to_rele(struct dk_cxlflash_udirect *udirect,
+				 struct dk_cxlflash_release *release)
+{
+	release->hdr = udirect->hdr;
+	release->context_id = udirect->context_id;
+	release->rsrc_handle = udirect->rsrc_handle;
+}
+
+/**
  * cxlflash_free_errpage() - frees resources associated with global error page
  */
 void cxlflash_free_errpage(void)
@@ -622,6 +635,7 @@ int _cxlflash_disk_release(struct scsi_device *sdev,
 	res_hndl_t rhndl = release->rsrc_handle;
 
 	int rc = 0;
+	int rcr = 0;
 	u64 ctxid = DECODE_CTXID(release->context_id),
 	    rctxid = release->context_id;
 
@@ -686,8 +700,12 @@ int _cxlflash_disk_release(struct scsi_device *sdev,
 		rhte_f1->dw = 0;
 		dma_wmb(); /* Make RHT entry bottom-half clearing visible */
 
-		if (!ctxi->err_recovery_active)
-			cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
+		if (!ctxi->err_recovery_active) {
+			rcr = cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
+			if (unlikely(rcr))
+				dev_dbg(dev, "%s: AFU sync failed rc=%d\n",
+					__func__, rcr);
+		}
 		break;
 	default:
 		WARN(1, "Unsupported LUN mode!");
@@ -1929,6 +1947,7 @@ static int cxlflash_disk_direct_open(struct scsi_device *sdev, void *arg)
 	struct afu *afu = cfg->afu;
 	struct llun_info *lli = sdev->hostdata;
 	struct glun_info *gli = lli->parent;
+	struct dk_cxlflash_release rel = { { 0 }, 0 };
 
 	struct dk_cxlflash_udirect *pphys = (struct dk_cxlflash_udirect *)arg;
 
@@ -1970,13 +1989,18 @@ static int cxlflash_disk_direct_open(struct scsi_device *sdev, void *arg)
 	rsrc_handle = (rhte - ctxi->rht_start);
 
 	rht_format1(rhte, lli->lun_id[sdev->channel], ctxi->rht_perms, port);
-	cxlflash_afu_sync(afu, ctxid, rsrc_handle, AFU_LW_SYNC);
 
 	last_lba = gli->max_lba;
 	pphys->hdr.return_flags = 0;
 	pphys->last_lba = last_lba;
 	pphys->rsrc_handle = rsrc_handle;
 
+	rc = cxlflash_afu_sync(afu, ctxid, rsrc_handle, AFU_LW_SYNC);
+	if (unlikely(rc)) {
+		dev_dbg(dev, "%s: AFU sync failed rc=%d\n", __func__, rc);
+		goto err2;
+	}
+
 out:
 	if (likely(ctxi))
 		put_context(ctxi);
@@ -1984,6 +2008,10 @@ static int cxlflash_disk_direct_open(struct scsi_device *sdev, void *arg)
 		__func__, rsrc_handle, rc, last_lba);
 	return rc;
 
+err2:
+	marshal_udir_to_rele(pphys, &rel);
+	_cxlflash_disk_release(sdev, ctxi, &rel);
+	goto out;
 err1:
 	cxlflash_lun_detach(gli);
 	goto out;
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 90b5c19..0800bcb 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -594,7 +594,9 @@ static int grow_lxt(struct afu *afu,
 	rhte->lxt_cnt = my_new_size;
 	dma_wmb(); /* Make RHT entry's LXT table size update visible */
 
-	cxlflash_afu_sync(afu, ctxid, rhndl, AFU_LW_SYNC);
+	rc = cxlflash_afu_sync(afu, ctxid, rhndl, AFU_LW_SYNC);
+	if (unlikely(rc))
+		rc = -EAGAIN;
 
 	/* free old lxt if reallocated */
 	if (lxt != lxt_old)
@@ -673,8 +675,11 @@ static int shrink_lxt(struct afu *afu,
 	rhte->lxt_start = lxt;
 	dma_wmb(); /* Make RHT entry's LXT table update visible */
 
-	if (needs_sync)
-		cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
+	if (needs_sync) {
+		rc = cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
+		if (unlikely(rc))
+			rc = -EAGAIN;
+	}
 
 	if (needs_ws) {
 		/*
@@ -792,6 +797,21 @@ int _cxlflash_vlun_resize(struct scsi_device *sdev,
 		rc = grow_lxt(afu, sdev, ctxid, rhndl, rhte, &new_size);
 	else if (new_size < rhte->lxt_cnt)
 		rc = shrink_lxt(afu, sdev, rhndl, rhte, ctxi, &new_size);
+	else {
+		/*
+		 * Rare case where there is already sufficient space, just
+		 * need to perform a translation sync with the AFU. This
+		 * scenario likely follows a previous sync failure during
+		 * a resize operation. Accordingly, perform the heavyweight
+		 * form of translation sync as it is unknown which type of
+		 * resize failed previously.
+		 */
+		rc = cxlflash_afu_sync(afu, ctxid, rhndl, AFU_HW_SYNC);
+		if (unlikely(rc)) {
+			rc = -EAGAIN;
+			goto out;
+		}
+	}
 
 	resize->hdr.return_flags = 0;
 	resize->last_lba = (new_size * MC_CHUNK_SIZE * gli->blk_len);
@@ -1084,10 +1104,13 @@ static int clone_lxt(struct afu *afu,
 {
 	struct cxlflash_cfg *cfg = afu->parent;
 	struct device *dev = &cfg->dev->dev;
-	struct sisl_lxt_entry *lxt;
+	struct sisl_lxt_entry *lxt = NULL;
+	bool locked = false;
 	u32 ngrps;
 	u64 aun;		/* chunk# allocated by block allocator */
-	int i, j;
+	int j;
+	int i = 0;
+	int rc = 0;
 
 	ngrps = LXT_NUM_GROUPS(rhte_src->lxt_cnt);
 
@@ -1095,33 +1118,29 @@ static int clone_lxt(struct afu *afu,
 		/* allocate new LXTs for clone */
 		lxt = kzalloc((sizeof(*lxt) * LXT_GROUP_SIZE * ngrps),
 				GFP_KERNEL);
-		if (unlikely(!lxt))
-			return -ENOMEM;
+		if (unlikely(!lxt)) {
+			rc = -ENOMEM;
+			goto out;
+		}
 
 		/* copy over */
 		memcpy(lxt, rhte_src->lxt_start,
 		       (sizeof(*lxt) * rhte_src->lxt_cnt));
 
-		/* clone the LBAs in block allocator via ref_cnt */
+		/* clone the LBAs in block allocator via ref_cnt, note that the
+		 * block allocator mutex must be held until it is established
+		 * that this routine will complete without the need for a
+		 * cleanup.
+		 */
 		mutex_lock(&blka->mutex);
+		locked = true;
 		for (i = 0; i < rhte_src->lxt_cnt; i++) {
 			aun = (lxt[i].rlba_base >> MC_CHUNK_SHIFT);
 			if (ba_clone(&blka->ba_lun, aun) == -1ULL) {
-				/* free the clones already made */
-				for (j = 0; j < i; j++) {
-					aun = (lxt[j].rlba_base >>
-					       MC_CHUNK_SHIFT);
-					ba_free(&blka->ba_lun, aun);
-				}
-
-				mutex_unlock(&blka->mutex);
-				kfree(lxt);
-				return -EIO;
+				rc = -EIO;
+				goto err;
 			}
 		}
-		mutex_unlock(&blka->mutex);
-	} else {
-		lxt = NULL;
 	}
 
 	/*
@@ -1136,10 +1155,31 @@ static int clone_lxt(struct afu *afu,
 	rhte->lxt_cnt = rhte_src->lxt_cnt;
 	dma_wmb(); /* Make RHT entry's LXT table size update visible */
 
-	cxlflash_afu_sync(afu, ctxid, rhndl, AFU_LW_SYNC);
+	rc = cxlflash_afu_sync(afu, ctxid, rhndl, AFU_LW_SYNC);
+	if (unlikely(rc)) {
+		rc = -EAGAIN;
+		goto err2;
+	}
 
-	dev_dbg(dev, "%s: returning\n", __func__);
-	return 0;
+out:
+	if (locked)
+		mutex_unlock(&blka->mutex);
+	dev_dbg(dev, "%s: returning rc=%d\n", __func__, rc);
+	return rc;
+err2:
+	/* Reset the RHTE */
+	rhte->lxt_cnt = 0;
+	dma_wmb();
+	rhte->lxt_start = NULL;
+	dma_wmb();
+err:
+	/* free the clones already made */
+	for (j = 0; j < i; j++) {
+		aun = (lxt[j].rlba_base >> MC_CHUNK_SHIFT);
+		ba_free(&blka->ba_lun, aun);
+	}
+	kfree(lxt);
+	goto out;
 }
 
 /**
-- 
2.1.0
