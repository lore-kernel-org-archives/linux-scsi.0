Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795474367;
	b=m6fjsBm4EmM5VmWyGRy2t6166f2j2Gi6H55cCMZZxlWI+8h5rNbScBBCjQ0AJYT+XIX9
	 dODl9/5AWvA9agNT9yTz+BPh7C0V3NiMgGshDSlJIDQC7fAYPiHPDR2c/pxnxyMtGtjmj
	 eurhBFSG/JwUDq14tBxZoAnPnAAs6D+hUHR/sMx1KpGXzIkPwb7+/HOjRNUHcrEr4zOow
	 y4X5q6vkjOiA1y4N6wHsLlgYhC8xslQhdsFTqDw7W7Yvhd91EI//w2A/3Lz0CND1eeJPS
	 CTRquTv3Q7kESoRJbtzLLlnSssRwYujt/vIXSvE0AoGJWOayKuRwqYY6XJzdTyAI6kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795474367;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Z4Q32bNVA8uTT9x6m2vj2FS29PN31PcCTNBJgqrJqlY=;
	b=qP5ym71c/lmzWdY5BaHzn0R8igZvdLUJ355L6xEcWh3oFt3Cl9l9JNi1UDVdM67ELhn8
	 p+qGOpx/dz8NZ3W0qSbBzgg+MMJ+Ea74VF0wnjf0bx82vtGrdUZAlb+pIJzOAY52KFTlQ
	 qLF5Pt1nbKAIGsrzAYn0Wni7XJ+/PzCijNWUdiM1Z5k12NZXQEIIYTwzs98NC336V2HCp
	 2Ti8jvTRrsxMkSbmgTCxc9WHzoQYTdiRYWOq5bG7FXzzGaXv/AX/69DJt/tlAzRcmVHJr
	 UH9onyWyw0WYB1MKuD6SfpYBQrQpaotVewVhBND3yX4ZcQIfZFH3b1YxDhdWrZyMD0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--zhenwenliang.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Vb81xQ2V;
	arc=none smtp.remote-ip=209.85.160.71
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39083606A32E
	for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 22:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39083606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--zhenwenliang.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Vb81xQ2V
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-4ab90cdf747so6147541fac.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 14:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795474366; x=1796079166; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z4Q32bNVA8uTT9x6m2vj2FS29PN31PcCTNBJgqrJqlY=;
        b=Vb81xQ2VJKFS5rzpEMSwoVXOFkG/+gvfDYNmJ7zGBP0bCTT2NV9QcKfe+xxik3rbyH
         7wPqNiAgf+J3gAuGXkWKxKX+Wq6k2SrL0PN5QoUZRXQRvtpV4jDccFbf9JFHOweyjVEP
         lII9a5aQKk9WL60KT7QU4XRS9MOgT3HPXXMVONnZbQh7sZCdHmklW3C8BjTW5DzW4GdV
         k35umH3BwepB64VsBTkfzwqn4mIFNoio+7wzEyEwi2d2HMHOK6C/TKijhQsXCepiuQLX
         OAy7NbbXETyFgZH55XJ6ozPflEagnbu3YbR6kKG9VHgCOvNWARQvA2Wndnmo/CKql4qA
         PFFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795474366; x=1796079166;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z4Q32bNVA8uTT9x6m2vj2FS29PN31PcCTNBJgqrJqlY=;
        b=IC210ff4Ehe5s8ILepXCvcwImvazJu1bChel0xO+IhJvUU42Cswl5l+kTfrbxRpIld
         PmhgSAJ49qcMfI34w4DzTebg4yP3Bhsntat2yr6GupA+CbUthQIOD+A0U8NVRBe2j4sV
         h1cyivE7ddrjsBMOMt6W+bE3nO3LdgQgdOt+9EbGFC5U0ef+Aiq1mCuXbKvxP058wPAd
         X4s18Tsuo1wCg93DZymxYV6xyvAU1UNEJ2hKeTh+Y7Cv9cX+aYdL58XH72PLQ7k6704J
         1juqZzAoRXJshEJGVFgbQkn3DErS92d8M2U4jeNQFc2/zi83+QETWrQOGBAT/FrsKmsd
         mNNw==
X-Forwarded-Encrypted: i=1; AL+hErFGubVyLQWzJOJzW0aCR1O2D5pY5ZmyUkR3HqQx0V/UKyaF2RNztRM+VKWfi1ohn0bmvR4mJjZ91TdP@vger.kernel.org
X-Gm-Message-State: APuU4Z/Q25j61i3fnrUHlcqzyGXe48SDICMAouZ1+Uq+LId1He0sUjK4
	8TC1SlGmn06XGFOui+v+5X7nM01uTcf4Eao3HIOTGZsl/GqaWiniyxSbKsloWmUP+Fy1+icSNlN
	c9N++XkL5V6j8s1yObYodgZioH9nFBw==
X-Received: from iok9-n1.prod.google.com ([2002:a05:6602:c609:10b0:9c7:b2b5:20af])
 (user=zhenwenliang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1506:b0:4f0:2d60:f0f4 with SMTP id 5614622812f47-5797bb9eb7emr10216396b6e.17.1795474365917;
 Mon, 23 Nov 2026 14:52:45 -0800 (PST)
Date: Mon, 23 Nov 2026 22:52:43 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123225243.1653417-1-zhenwenliang@google.com>
Subject: [PATCH] scsi: ufs: core: update clkscale is_enabled under clk_scaling.lock
From: Zhenwen Liang <zhenwenliang@google.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

ufshcd_clk_scaling_start_busy() reads clk_scaling.is_enabled and queues
clk_scaling.resume_work under clk_scaling.lock. The clkscale_enable
store writes is_enabled without that lock and, when it disables
scaling, then calls ufshcd_suspend_clkscaling(), which cancels
resume_work and marks clock scaling suspended.

A request that starts while clock scaling is being disabled can read
the old value and queue resume_work after it was cancelled:

  clkscale_enable_store(0)          ufshcd_clk_scaling_start_busy()
  ------------------------          -------------------------------
                                    lock clk_scaling.lock
                                    is_enabled is still true
  is_enabled = false
  ufshcd_suspend_clkscaling()
    cancel_work_sync(resume_work)
                                    queue_work(resume_work)
                                    unlock clk_scaling.lock
    is_suspended = true
    devfreq_suspend_device()
                                    ufshcd_clk_scaling_resume_work()
                                      is_suspended = false
                                      devfreq_resume_device()

devfreq is then active again although clkscale_enable reads 0, and
ufshcd_devfreq_target() only checks is_suspended, so devfreq can change
the clock frequency again (for example scale it down when the load
drops). The window is a few instructions inside the locked section of
start_busy().

Write is_enabled under clk_scaling.lock. ufshcd_clk_scaling_start_busy()
then either sees the new value, or it queued resume_work before the
store and ufshcd_suspend_clkscaling() cancels or waits for that work.

Reproduced on v7.4-rc4 in QEMU with two debug-only changes, not part of
this patch: clock scaling enabled on the emulated UFS controller with a
fake clock entry (no clock or gear is actually changed), and a delay in
ufshcd_clk_scaling_start_busy() after the is_enabled check. Writing 0 to
clkscale_enable during the first request after idle left devfreq
resumed although scaling was disabled in 5 of 5 runs; with this patch,
in none of 5 runs. Without the delay (2 control runs) we did not see
it. We have no UFS hardware with clock scaling.

The problem was found with a Lean-based formal model of the code and
AI-assisted analysis. The patch and this description were written with
AI assistance; a human checked them against the source.

Fixes: 401f1e4490ee ("scsi: ufs: don't suspend clock scaling during clock gating")
Signed-off-by: Zhenwen Liang <zhenwenliang@google.com>
---
ufshcd_clkscale_enable_store() writes clk_scaling.is_enabled without
clk_scaling.lock (drivers/ufs/core/ufshcd.c:1872 in v7.4-rc4), while
ufshcd_clk_scaling_start_busy() reads it and queues resume_work under
that lock (2303-2312). When scaling is disabled as the first request
after idle starts, start_busy() can queue resume_work after
ufshcd_suspend_clkscaling() cancelled it (1806); resume_work then
clears is_suspended and resumes devfreq although clkscale_enable reads
0. The window is a few instructions with interrupts off; on non-RT
kernels the CPU must stall exactly there (NMI, preempted vCPU).

Affected: v7.4-rc4, next-20261123, 7.3.y, 6.18.y (clk_scaling.lock
exists since be769e5cf53b, v6.14). 6.12.y, 6.6.y, 6.1.y and 5.15.y use
host_lock in start_busy() and need a backport using it; 5.10.y differs
(is_allowed, cancel before the write).

Who can trigger it: root (the attribute is 0644). Functional bug.

Reproduced on v7.4-rc4 in QEMU (x86_64 TCG, 4 vCPUs). QEMU's UFS
device has no clock scaling, so a debug-only test helper enables
UFSHCD_CAP_CLK_SCALING with a fake clock entry (clk == NULL: no clock
or gear change, only the scaling bookkeeping and devfreq run). A
debug-only one-shot mdelay() sits in start_busy() after the is_enabled
check. Writing 0 to clkscale_enable during the first read after idle:

  v7.4-rc4 + delay:          scaling left resumed after the write,
                             5 of 5 runs
  + this patch:              suspended correctly, 5 of 5 runs
  no delay (2 control runs): suspended correctly

Not tested on UFS hardware; how long devfreq stays active was not
measured. Helper and debug patches on request.

Found by a formal code verification tool under development (Lean-based),
with AI-assisted analysis; verified by the reproduction above and human
review. The patch and this text were written with AI assistance and
reviewed by a human. Point of contact: Zhenwen Liang
<zhenwenliang@google.com>.

A search of public list archives, git history and syzbot found no
earlier report; we could not check the review thread of be769e5cf53b.

 drivers/ufs/core/ufshcd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c9b2eefbd7b0..76190f472f9f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1869,7 +1869,13 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 		goto out;
 	ufshcd_hold(hba);
 
-	hba->clk_scaling.is_enabled = value;
+	/*
+	 * ufshcd_clk_scaling_start_busy() reads is_enabled and queues
+	 * resume_work under clk_scaling.lock; update it under the same lock
+	 * so that no resume_work is queued after it is cancelled below.
+	 */
+	scoped_guard(spinlock_irqsave, &hba->clk_scaling.lock)
+		hba->clk_scaling.is_enabled = value;
 
 	if (value) {
 		ufshcd_resume_clkscaling(hba);
-- 
2.56.1.809.ga0b61035b5-goog

