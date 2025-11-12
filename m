Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CD2299AA3
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762929186; cv=none; b=XBWXqYtIyoeEvDKT1zjQx33Qc2fqyu9UDWcUn6tqQA+myh3C/ZRK4HwN8ml12ry5RfF1EHYPGFDVGO23Hkc8suIhkOHaGsGB4Ju3q/YyYp09Lf+nqJAOOZQORMkE38Iw45IETekYTjmeNtUeMKvD80tSGwnz+eiJaLKDrYl3Pj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762929186; c=relaxed/simple;
	bh=Cw/W9CyuYpuZLvXAU9J3ai0lpSgJef+6FDu5Ex6zTrg=;
	h=Date:Mime-Version:Message-ID:Subject:From:Cc:Content-Type; b=ePLzFnmeyUJ2HHzynQUgP97cuClXyoRn5wtO6hTconhPYf/XQHrTWhrdcUptP3YZpiXFEbZwr063kdBaCEsueppIWgz51z9PKLl4vNI9CEqL2MKPPICL3+7KIj3CAmv585Lz/aRPJBaDKuek5xm5vqatwsHlqqnn313uwyWLD5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P0K9mlZ5; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P0K9mlZ5"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297d50cd8c4so12142765ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2025 22:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762929184; x=1763533984; darn=vger.kernel.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cNIqEapCp4oN2w7WnRx0ObGqxT09Vga2okdYEcb4q94=;
        b=P0K9mlZ5VDcapn2JKn6uv6gNLGbFzIsZUYHM1uwsXypj6zQpMb2KnbjkNkG3JboF2Q
         L445f4FCSq6K/iJPgLsmy0gDb3E5isGaFGm6EOp9xHzKTkrlxEt3CUfa7laMqjDa/Uhv
         5H2HNnvnu+HLlnV+ABZmlm5XoekfMdKoeM9nHkb7RR0Mp9mot/Z9v6E2P0li4Tso5tcN
         AleUKMO73DeNPBwlcnJgIUiyV92WO3qavIa7w9NSR/0DOG/h/C3AbljV4aa9RObmXVg8
         MpZPBjznEIyQjEyayU3BYYUXeh/5k2CHScnshxVUESe5h98Lh1rsFF3oKhu5cb+3rvNo
         i/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762929184; x=1763533984;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cNIqEapCp4oN2w7WnRx0ObGqxT09Vga2okdYEcb4q94=;
        b=d2oFaO5SPfRkdWeykLUjc6rQ/ttME/LPKX5DJamH7bk1I6tnhxc6d7pGtxoN83KTBt
         eE+T3ggT9/O+VICI5Sycm4KHh9Ci/1PljAujrZtMi/N6H6/xGI1VYwodQcdxF4J6va1U
         yCPUqOJsTD2JkmdDwku7YjtnONG017c9OIB+PPRXQXthaCb4VH52aJTHjtjFyn+4dKdC
         dduuxGmqeGG8IGZRi76tPT7dDhXL/yicNQRDUXLxiaVap1PKkeQn2KzWkWbWpefnskzN
         cRyNPydf8CRveYhHXpWHnzy2/TTHm2IbUbxmHbcnVU2N57ECcTaGorhCTltNkzuSiBAL
         owkw==
X-Forwarded-Encrypted: i=1; AJvYcCWxoOhtRcI3Ol3aNAeifV42JWzVW8EWZU+/vqo3h0jmm0uPck5k+fky7aaGP4pQsIU/xLd95abfJbDe@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7F1+fEQRUK8AtbS5imSZTQhavOCaC1U0sG6LgS8OX2ZIFIZ1A
	bAX+laWhc3omx6+5tIDuJst/syEmO74fuPZKMEqG+VTlotdAx6cA8Z8iAYiv/Ml66r/moqQe5/y
	wUOxqGi9TxhvGVA==
X-Google-Smtp-Source: AGHT+IE+1PQbQCK5w3kPAD89sgfjYeOI3cDhEHBRfHdP1rOJCTJurTa9E4fGRbFCWFXAzzb3hcUMl+2A8+O2wQ==
X-Received: from plxe3.prod.google.com ([2002:a17:902:ef43:b0:298:33c9:abd5])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1a30:b0:290:b53b:7456 with SMTP id d9443c01a7336-2984ed34347mr24804745ad.5.1762929184258;
 Tue, 11 Nov 2025 22:33:04 -0800 (PST)
Date: Wed, 12 Nov 2025 06:32:02 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112063214.1195761-1-powenkao@google.com>
Subject: [PATCH 1/1] scsi: ufs: core: Fix EH failure after wlun resume error
From: Po-Wen Kao <powenkao@google.com>
Cc: Brian Kao <powenkao@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Manivannan Sadhasivam <mani@kernel.org>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

When a W-LUN resume fails, its parent devices in the SCSI hierarchy,
including the scsi_target, may be runtime suspended. Subsequently, the
error handler in ufshcd_recover_pm_error() fails to set the W-LUN
device back to active because the parent target is not active.
This results in the following errors:

  google-ufshcd 3c2d0000.ufs: ufshcd_err_handler started; HBA state eh_fatal; ...
  ufs_device_wlun 0:0:0:49488: START_STOP failed for power mode: 1, result 40000
  ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume failed: -5
  ...
  ufs_device_wlun 0:0:0:49488: runtime PM trying to activate child device 0:0:0:49488 but parent (target0:0:0) is not active

This patch addresses this by:

1.  Ensuring the W-LUN's parent scsi_target is runtime resumed before
attempting to set the W-LUN to active within ufshcd_recover_pm_error().
2.  Explicitly checking for power.runtime_error on the HBA and W-LUN
devices before calling pm_runtime_set_active() to clear the error state.
3.  Adding pm_runtime_get_sync(hba->dev) in
ufshcd_err_handling_prepare() to ensure the HBA itself
is active during error recovery, even if a child device resume failed.

These changes ensure the device power states are managed correctly
during error recovery.

Signed-off-by: Brian Kao <powenkao@google.com>
Tested-by: Brian Kao <powenkao@google.com>
---
 drivers/ufs/core/ufshcd.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fc4d1b6576dc..9176d7ce25b4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6504,6 +6504,11 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 
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
@@ -6543,6 +6548,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
 	ufshcd_rpm_put(hba);
+	pm_runtime_put(hba->dev);
 }
 
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
@@ -6557,28 +6563,42 @@ static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
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

base-commit: c53a741a7fd4b8e9d07acf1861b5e4a188c6585a
-- 
2.51.2.1041.gc1ab5b90ca-goog

