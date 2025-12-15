Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CE82459C5;
	Mon, 15 Dec 2025 08:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765788949; cv=none; b=O3J5sdaCU6r2gjENwCZD/fiahGHaK/H5zUJkR/uj2tTI3Vthp6Tp+dQ9M2Nj88Z7PjDPc+PX7wX9MHNUGIbiEBSLNV7EPQ74ZAsKo0trZj1lIkAW0xNy1KBlqhP8SAo8MY5ZduNs3kiEu2N9oOB3IgSC+YAyQhwl2qr8nBPem5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765788949; c=relaxed/simple;
	bh=MG4n6t13xQNsm1zkulXNv8wTE5r3PemWTTB0fpb1mIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UT8vgdo/XtCLFjYWYApw9EMSwOzbChPXPBLfs/I70j2zb1o6ksx4PxWK/Z2qLfAh/nFOK377aOiI49qNPS21nA592tKG8riJatAsAx+mz1ccSluu4WQ0npH+rQgI0KzbIo7TiUcnEJTkRrGt1foILLS1F95eyNRqvu3MVZY16nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEAt7tjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEAt7tjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F6DC116B1;
	Mon, 15 Dec 2025 08:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765788949;
	bh=MG4n6t13xQNsm1zkulXNv8wTE5r3PemWTTB0fpb1mIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TEAt7tjHgm8ZBwTOEG4uMoiykITLApgM2b07clMD8Z3wJWT2lcldy6+gHEXTM/DzZ
	 QDb0CjGBMF8UCEig78J8Um4LbGcw1/low53AcZ3csZshsG00RuVThdBxKw0KkOqGNu
	 jfBApOyi2yqm0qMZ69Mdsr8sd6CErXpNQ6Dk2am+HZ8Ko1hwONhVXDEdlNSgMPDQtC
	 f9ZOWxf2pMZp9A8YNl4Tkpfh7VlbkJRgqibIcXXgfVqqh+X3fyl0XBBceR1mRWnLhg
	 hto2K9qXk6ekKCWmDmtrErqzU1s5EDBaqpKc6a21OgLlJ782twEgM/uvraF+MabBEh
	 UP0gwMfD9wlSg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Kao <powenkao@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	peter.wang@mediatek.com,
	avri.altman@sandisk.com,
	beanhuo@micron.com,
	adrian.hunter@intel.com,
	quic_nguyenb@quicinc.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] scsi: ufs: core: Fix EH failure after W-LUN resume error
Date: Mon, 15 Dec 2025 03:55:26 -0500
Message-ID: <20251215085533.2931615-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215085533.2931615-1-sashal@kernel.org>
References: <20251215085533.2931615-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Kao <powenkao@google.com>

[ Upstream commit b4bb6daf4ac4d4560044ecdd81e93aa2f6acbb06 ]

When a W-LUN resume fails, its parent devices in the SCSI hierarchy,
including the scsi_target, may be runtime suspended. Subsequently, the
error handler in ufshcd_recover_pm_error() fails to set the W-LUN device
back to active because the parent target is not active.  This results in
the following errors:

  google-ufshcd 3c2d0000.ufs: ufshcd_err_handler started; HBA state eh_fatal; ...
  ufs_device_wlun 0:0:0:49488: START_STOP failed for power mode: 1, result 40000
  ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume failed: -5
  ...
  ufs_device_wlun 0:0:0:49488: runtime PM trying to activate child device 0:0:0:49488 but parent (target0:0:0) is not active

Address this by:

 1. Ensuring the W-LUN's parent scsi_target is runtime resumed before
    attempting to set the W-LUN to active within
    ufshcd_recover_pm_error().

 2. Explicitly checking for power.runtime_error on the HBA and W-LUN
    devices before calling pm_runtime_set_active() to clear the error
    state.

 3. Adding pm_runtime_get_sync(hba->dev) in
    ufshcd_err_handling_prepare() to ensure the HBA itself is active
    during error recovery, even if a child device resume failed.

These changes ensure the device power states are managed correctly
during error recovery.

Signed-off-by: Brian Kao <powenkao@google.com>
Tested-by: Brian Kao <powenkao@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251112063214.1195761-1-powenkao@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### Problem Description
This commit fixes a bug where UFS error recovery fails after a W-LUN
(Well Known Logical Unit Number) resume error. When a W-LUN resume
fails:

1. The parent devices in the SCSI hierarchy (including `scsi_target`)
   remain runtime suspended
2. The error handler's `ufshcd_recover_pm_error()` attempts to set the
   W-LUN device active
3. The PM core rejects this because the parent target is not active,
   producing the error:
  ```
  runtime PM trying to activate child device 0:0:0:49488 but parent
  (target0:0:0) is not active
  ```

### Technical Analysis of the Fix

**Original (buggy) code:**
```c
ret = pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
if (ret)
    ret = pm_runtime_set_active(hba->dev);
```

This incorrectly tries to activate a child device while its parent is
suspended - violating the PM hierarchy requirement.

**The fix does three things:**
1. **Adds `pm_runtime_get_sync(hba->dev)` in
   `ufshcd_err_handling_prepare()`** - Ensures HBA is active during
   error recovery even if a child device resume failed
2. **Fixes PM hierarchy in `ufshcd_recover_pm_error()`** - Explicitly
   resumes the parent `scsi_target` before trying to activate the child
   W-LUN
3. **Checks `power.runtime_error`** - Only clears error state on devices
   that actually have an error, rather than relying on return values

### Stable Tree Criteria Assessment

| Criterion | Assessment |
|-----------|------------|
| Fixes real bug | ✅ YES - Error handling completely fails without this
|
| Obviously correct | ✅ YES - Follows standard PM parent-before-child
rules |
| Small and contained | ✅ YES - ~35 lines in one file, error handling
path only |
| No new features | ✅ YES - Pure bugfix |
| Tested | ✅ YES - Has Tested-by and Reviewed-by: Bart Van Assche |
| Exists in stable | ✅ YES - `ufshcd_recover_pm_error()` introduced in
v5.10 |
| Dependencies | ✅ NONE - Uses standard, long-existing PM APIs |

### User Impact
- **Affected systems**: Android devices, embedded systems with UFS
  storage
- **Severity**: Error handler failure can lead to I/O failures and
  potential data loss
- **Frequency**: Occurs when W-LUN resume fails and error handler tries
  to recover

### Risk Assessment
- **Low regression risk**: Changes are in error handling code path only
- **Well-understood fix**: Standard PM hierarchy handling pattern
- **Good review**: Bart Van Assche (experienced SCSI/block maintainer)
  reviewed it

### Conclusion

This is a clear-cut bug fix for UFS error handling. The bug causes the
error handler to fail completely when a W-LUN resume error occurs, which
can leave the storage subsystem in an unrecoverable state. The fix
correctly implements PM hierarchy requirements (parent must be active
before child), is well-tested, has expert review, and uses standard APIs
that exist in all stable trees since v5.10. The changes are contained to
the error handling path with minimal regression risk.

**YES**

 drivers/ufs/core/ufshcd.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d6a060a724618..ce52c3bafbe8f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6498,6 +6498,11 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 
 static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
+	/*
+	 * A WLUN resume failure could potentially lead to the HBA being
+	 * runtime suspended, so take an extra reference on hba->dev.
+	 */
+	pm_runtime_get_sync(hba->dev);
 	ufshcd_rpm_get_sync(hba);
 	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
 	    hba->is_sys_suspended) {
@@ -6537,6 +6542,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
 	ufshcd_rpm_put(hba);
+	pm_runtime_put(hba->dev);
 }
 
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
@@ -6551,28 +6557,42 @@ static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 #ifdef CONFIG_PM
 static void ufshcd_recover_pm_error(struct ufs_hba *hba)
 {
+	struct scsi_target *starget = hba->ufs_device_wlun->sdev_target;
 	struct Scsi_Host *shost = hba->host;
 	struct scsi_device *sdev;
 	struct request_queue *q;
-	int ret;
+	bool resume_sdev_queues = false;
 
 	hba->is_sys_suspended = false;
+
 	/*
-	 * Set RPM status of wlun device to RPM_ACTIVE,
-	 * this also clears its runtime error.
+	 * Ensure the parent's error status is cleared before proceeding
+	 * to the child, as the parent must be active to activate the child.
 	 */
-	ret = pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
+	if (hba->dev->power.runtime_error) {
+		/* hba->dev has no functional parent thus simplily set RPM_ACTIVE */
+		pm_runtime_set_active(hba->dev);
+		resume_sdev_queues = true;
+	}
+
+	if (hba->ufs_device_wlun->sdev_gendev.power.runtime_error) {
+		/*
+		 * starget, parent of wlun, might be suspended if wlun resume failed.
+		 * Make sure parent is resumed before set child (wlun) active.
+		 */
+		pm_runtime_get_sync(&starget->dev);
+		pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
+		pm_runtime_put_sync(&starget->dev);
+		resume_sdev_queues = true;
+	}
 
-	/* hba device might have a runtime error otherwise */
-	if (ret)
-		ret = pm_runtime_set_active(hba->dev);
 	/*
 	 * If wlun device had runtime error, we also need to resume those
 	 * consumer scsi devices in case any of them has failed to be
 	 * resumed due to supplier runtime resume failure. This is to unblock
 	 * blk_queue_enter in case there are bios waiting inside it.
 	 */
-	if (!ret) {
+	if (resume_sdev_queues) {
 		shost_for_each_device(sdev, shost) {
 			q = sdev->request_queue;
 			if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
-- 
2.51.0

