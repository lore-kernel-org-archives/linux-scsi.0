Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C5D31F984
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 03:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788405228; cv=none; b=mozinpo5/LbGdWcs7/xAPwjEKqU+8nyvN48THc1xfoRfqLleluK9cnKqCRTMr7+6V33xFhEct8TS0FE5BetMNf+2XIlvK4VtGYCmj6qTS6dfzvHj4KkiPWByWW1YL3e5CT2O4iIJSPQw6YlflkTniuJbE7YIA+BwzmKmR/Fsj/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788405228; c=relaxed/simple;
	bh=CshTmL+8XoyHo3HWtopNI4aZFLUjYTuRU2/2Ijnc6f4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=n38cC/yvS5JjF/9N6Y3LnipLoL/zisxAnjrfGGUh5orK3iL2EnvApB7n3E83tCkEM2CDWpu0oJA9VLt7mre7TINm1MOb6jGbsGmYO7RwLqD6pr1xDQkZiROCJMD+CwtOiA/chXI+JLOmgo+tDw4Aca528kQ3027G8+HSXiuEmAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ft3RGVCY; arc=none smtp.client-ip=209.85.216.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ft3RGVCY"
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-398d292eac1so3784155a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2026 20:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788405227; x=1789010027; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Pb11Sv5Oqcejo9Niy+ADZ+x65tQwyCrGSX+ts1QvInA=;
        b=ft3RGVCYp/2kdfsi1CEeB73UFw1PQg/FHJIgy5xlqy/bG8+2uMRLm+/rQS6Ie/J7V/
         v7zajtrgle8bFkCFAF0kDsYUcyFDoLtP8oC3Pm5T9NO4xmJQ0cRZlQ0bzD/ro1keGEaW
         +6IuVfUqRh57Akkawe2k2KBR+uYQPth67hv3NybuIO42MEDyHE5n28NVjqM2Y03IzhmM
         Mh3Nv0BzYLDrebnRhYp/ph/v2LM+iO6XPuml4IBvDDw3u4FIm7kjUE9AepHdrfp9uVAi
         vt5jzvK6rlqHnmKHUxWT5A9fcCj/bUSzqD4Zf+4MWuC7wO1Gjaj1rAq7NdZDjRhlFFTV
         wufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788405227; x=1789010027;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pb11Sv5Oqcejo9Niy+ADZ+x65tQwyCrGSX+ts1QvInA=;
        b=rEbcP//+h3bIy4eWxkpB26KmJAUFpcngxraIib5AVcsYdiXrDnPfOJJibllxQ0Sig6
         M5XU4wO+nmL5n1+ISu5uAX+I2IHOQnvqK0/iOVe3DOd0+qjHODupJU75VMl/HkMQMoxR
         8Eo4P3ShSSTZwfosjjhKBKa+4BoakGhImOwbGFen4v09cykCgVK1mwU4JOjtPDWGriJM
         kzO9HduUw6ekPVVy8bv8h8WEyVXbciDJloyO/RcnejzRCntOcQkp4RvazbEe2wjGKGFn
         v/MMqpt1oIhsNIW7zbW2eFgbWyHknyhDt7dUjv3dp4j/tMk++yBVjIh3JJntY+UQzJvO
         zP+w==
X-Forwarded-Encrypted: i=1; AKwUvBxnSukWvhuAo418IzPrLjlXNie0Q1QWuKoHFA9QK1KwDvFC34HTLBqXCNDkSCFLF4G/YM0oVSaq881D@vger.kernel.org
X-Gm-Message-State: AFuF++le3BpES8QyrFnbh5aAYtnljjbE64tltT3Qg/m60yNyiT+R78G2
	ZIuGJlA26lqoJ6UZE9slT0Kkdbsgn/E9A17glenmB493hcL3FnDMUWdIgo1lj4BZ9Sc/Sd8dSqp
	RbfVjk1wWeIVIlDlDxw2Hug==
X-Received: from pjuy11.prod.google.com ([2002:a17:90a:d70b:b0:38e:813b:9944])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2750:b0:398:e73e:5a0c with SMTP id 98e67ed59e1d1-39aedf5d887mr14329828a91.1.1788405226424;
 Wed, 02 Sep 2026 20:13:46 -0700 (PDT)
Date: Thu,  3 Sep 2026 11:13:44 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260903031344.3740524-1-stanleyjhu@google.com>
Subject: [PATCH] scsi: ufs: core: Prevent MMIO access and drain in-flight
 commands during shutdown
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Seunghwan Baek <sh8267.baek@samsung.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@sandisk.com>, 
	Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Bean Huo <beanhuo@micron.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

Commit 19a198b67767 ("scsi: ufs: core: Put the normal LU into
SDEV_OFFLINE when ufs device wl-lun suspend") transitioned normal
logical units into SDEV_OFFLINE during ufshcd_wl_shutdown() to prevent
requeue deadlocks. However, setting SDEV_OFFLINE does not wait for
in-flight or currently dispatching requests to drain.

If an I/O request races past scsi_queue_rq() right as or before
SDEV_OFFLINE is set, or if an asynchronous command execution suffers
scheduling delays, it can arrive in ufshcd_queuecommand() or issue MMIO
writes after ufshcd_wl_shutdown() has powered off the UFS controller
(is_powered = false, regulators disabled, clocks gated). Writing to MMIO
registers of a power-gated or clock-gated controller triggers fatal
hardware bus errors, system hangs, or kernel panics.

Fix this with a dual-layer defense:
1. In ufshcd_queuecommand(), check if hba->shutting_down is set. Reject
   any non-WLUN / non-PM requests immediately with DID_NO_CONNECT before
   any MMIO register access.
   Note that checking !hba->is_powered is unnecessary here because
   hba->shutting_down is asserted prior to disabling clocks and
   regulators in ufshcd_wl_shutdown(), and module removal drains and
   destroys all request queues via scsi_remove_host() before is_powered
   is cleared.
2. In ufshcd_wl_shutdown(), invoke ufshcd_wait_for_pending_cmds() after
   taking regular LUNs offline to drain all existing hardware transfer
   and task management requests before putting the device into powerdown
   mode and powering down the host controller. Warn if draining times
   out after 1 second.

Fixes: 19a198b67767 ("scsi: ufs: core: Put the normal LU into SDEV_OFFLINE when ufs device wl-lun suspend")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..6d78e34a19b2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3105,6 +3105,25 @@ static enum scsi_qc_status ufshcd_queuecommand(struct Scsi_Host *host,
 	int err = 0;
 	struct ufs_hw_queue *hwq = NULL;
 
+	/*
+	 * During host shutdown, fail any incoming regular I/O commands
+	 * immediately. This prevents stray requests that bypassed SCSI queue
+	 * offline checks from writing to MMIO doorbells after the controller
+	 * is power-gated (causing fatal bus errors / panics).
+	 *
+	 * Note: Checking !hba->is_powered is not needed here because:
+	 * 1. During shutdown, hba->shutting_down is set prior to cutting
+	 *    controller power, so shutting_down alone fully covers the
+	 *    unpowered window.
+	 * 2. During module removal, scsi_remove_host() freezes and destroys
+	 *    all request queues before hba->is_powered is set to false in
+	 *    ufshcd_hba_exit().
+	 */
+	if (unlikely(READ_ONCE(hba->shutting_down))) {
+		if (!is_device_wlun(cmd->device) ||
+		    !(scsi_cmd_to_rq(cmd)->rq_flags & RQF_PM)) {
+			set_host_byte(cmd, DID_NO_CONNECT);
+			scsi_done(cmd);
+			return 0;
+		}
+	}
+
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 		break;
@@ -10931,6 +10950,14 @@ static void ufshcd_wl_shutdown(struct scsi_device *sdev)
 		scsi_device_set_state(sdev, SDEV_OFFLINE);
 		mutex_unlock(&sdev->state_mutex);
 	}
+
+	/*
+	 * Drain all in-flight transfer and task management requests before
+	 * putting the device into low power and turning off controller power.
+	 */
+	if (ufshcd_wait_for_pending_cmds(hba, USEC_PER_SEC))
+		dev_warn(hba->dev,
+			 "timed out waiting for in-flight commands during shutdown\n");
+
 	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
 
 	/*
-- 
2.43.0
