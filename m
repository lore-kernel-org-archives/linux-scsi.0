Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7542B4FC8D1
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 13:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789739106; cv=none; b=j+/qqo6iqt+7aBy9rAecwD2KCTchNb5R70w6NaO+UQJPtix+Uin8LnCqW257s+KbpZQRxxDg0VHAPUK1IBQZENTWwUNp08cQWv5lsy/11s9WxFyvkGQXwzHTii3vC2TdEpfuA1KadoYIdHEO9UIj4E5QvZ7Xjj8WBlDdL5sUcJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789739106; c=relaxed/simple;
	bh=RpJXRlGpRaN8FjcMr2y5WfKyuPAPxYuToIb7LiFIlQk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NldbLrtvIAr31Xq1vQ2Rrd63XCbA2zIPHDXG3GTT26q8yNgbadUUBX1Ck/N2L40iPU1k7MNhbcCo1k+930MLeSnbbT0WGVWnN1xG3GFFm3XpxCJkfwtkEk79WOZpiXGCOLLRsVGfLJvmsrqckn31JFUquhsm/Fb42ptVFRH13V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q6ieOk4J; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q6ieOk4J"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-86917d18880so1371420b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 06:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789739105; x=1790343905; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eSHtfc76F2JZKCB9I4hSn94KsItsv68pYgoXJRLd5Bs=;
        b=Q6ieOk4JdvBcyx1xlr6JjfVHGYiQ7CtuPgnOJwLZNPkl1R4uy6QFL7If4o57B/wnjj
         9Nd8PbwIi2DWF5ohYMmV1yM2m5y6v7Gqq4i69GBJHPJPOEMej94K/gewR5vvf8gSP4eY
         BPXEi7keZMXVmsSlb8WD6eG6rYk/5XwE6fEp1J17OFiqyikKfMWpLwQan2wpG+4WSk7+
         I+IhOQuBg94seMufOEde2zgjZVqbg+Z7iTebUMuQsoW3NY2eyfadJ0F0PdMxovB4utur
         Ic2gpWyRqTkg1ejnBdalNhSA0+mFz2EMh4VH7qyXzQ264Ka+5K53mTjwCt3lmjolbcug
         S90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789739105; x=1790343905;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eSHtfc76F2JZKCB9I4hSn94KsItsv68pYgoXJRLd5Bs=;
        b=RdpyTv7Xnz3TyvVcIzNsyGie02EMRhjkOd8v0g/wVeymoDlJnWQITpYm1ZV5mIscp3
         EgIfY1wLUNztGC7nSPTC0BM1n6o3vysUgHY6VhI0QaNBqacP3OuzAh045/69o3j0LZHd
         cLkuO92j2XyXYlRqzbZKtKOjP6aV8M0VQibuYxibkqPxBJSg1q/7ZBuJK+Tm42IROXic
         G8lOru0a34w5N0aDrnlhNNGYoyrRR72jNTYoEwZ0KTojFwO9Fc7nfhn+eGI3qgUcZi06
         YyrmGxpmRnATOVhXOmS0rMDbRP/IX0dc4NS2btaadoXw/bInx+KRwzNpV2qHsf27JNeu
         0M+Q==
X-Forwarded-Encrypted: i=1; AKwUvByU3fIGZ01D6wbtVU8Ng+GQkUjoIYJaDJDh60bDSffrcHUQBQRb921rh+OdKYz2tNYTuBmGAeY17HkE@vger.kernel.org
X-Gm-Message-State: AFuF++kIX/dWVt+gnu12MQbIL5NOf2x+/CC2Yv6tL6HL5xRmQAxLKMEE
	ywpipOzmzZ+TpBkYRrWCXlDpqVm/HOIhy7sNz/4LhGPZNx1N7x95QKLt7nZ0w/tJbzK0/h9PORx
	G8XPjx38HH84C3dnVpQnsmA==
X-Received: from pfw3.prod.google.com ([2002:a05:6a00:a263:b0:873:37e4:3d09])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:400a:b0:85c:2d83:bbf1 with SMTP id d2e1a72fcca58-874dd5f0f21mr6085259b3a.20.1789739104629;
 Fri, 18 Sep 2026 06:45:04 -0700 (PDT)
Date: Fri, 18 Sep 2026 21:45:02 +0800
In-Reply-To: <20260903031344.3740524-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260903031344.3740524-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918134502.2876440-1-stanleyjhu@google.com>
Subject: [PATCH v2] scsi: ufs: core: Prevent MMIO access and drain in-flight
 commands during shutdown
From: Stanley Jhu <stanleyjhu@google.com>
To: mkp@kernel.org, James.Bottomley@HansenPartnership.com, 
	linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, sh8267.baek@samsung.com, alim.akhtar@samsung.com, 
	avri.altman@sandisk.com, peter.wang@mediatek.com, can.guo@oss.qualcomm.com, 
	beanhuo@micron.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Commit 19a198b67767 ("scsi: ufs: core: Set SDEV_OFFLINE when UFS is
shut down") replaced scsi_device_quiesce() with
scsi_device_set_state(sdev, SDEV_OFFLINE) in ufshcd_wl_shutdown() to
avoid unbounded blk_mq_freeze_queue() deadlocks when a reboot occurs
early during boot. However, unlike scsi_device_quiesce(), setting
SDEV_OFFLINE is a state write only and does not wait for in-flight or
currently dispatching requests to drain.

As a result, ufshcd_wl_shutdown() immediately sends START STOP UNIT
(PowerDown) and powers off the UFS controller (is_powered = false,
regulators disabled, clocks gated) while regular LUNs may still have
commands outstanding or threads preempted between scsi_queue_rq() and
ufshcd_queuecommand(). Writing to MMIO registers of a power-gated or
clock-gated controller triggers hardware bus errors, system hangs, or
kernel panics.

Close this window without reintroducing the unbounded freeze deadlock:
1. In ufshcd_wl_shutdown(), invoke ufshcd_wait_for_pending_cmds() with a
   bounded 1-second timeout after marking regular LUNs SDEV_OFFLINE so
   in-flight transfer and task management requests drain before the
   device enters powerdown mode and controller clocks/regulators are
   disabled.
2. In ufshcd_queuecommand(), check hba->shutting_down and reject any
   stray non-WLUN / non-PM requests with DID_NO_CONNECT before touching
   MMIO registers, covering threads preempted across the bounded drain
   window.

Fixes: 19a198b67767 ("scsi: ufs: core: Set SDEV_OFFLINE when UFS is shut down")
Cc: stable@vger.kernel.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
Changes since v1:
- Correct the commit subject in the Fixes: tag and clarify why a bounded
  drain is used instead of restoring scsi_device_quiesce().
- Collect Reviewed-by from Peter Wang (sent off-list due to mail gateway
  headers). No code changes.

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
2.55.0.1082.g2b9226bbc0-goog
