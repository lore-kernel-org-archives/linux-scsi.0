Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257724;
	b=j87Oe5upW5AbauO8kANGRGXQriASlq426HwltJPYwWwYL6EOVLzZ2abs6FrS18C50Y1N
	 MP4HDG7j/b7uGIb3ramifxfJ873W6zYiQkMSRWN7FcosP6b5fTEPgF54nEDuAJcDeyaBJ
	 rlsdROV185qqfc2XiGG+cHVUlNYLisrm80lTIITwBlN0VwZQHdnF7bpIptj8o8nE7GQ8M
	 ZXjF2iEH3nC1IOw7CnmtQOUhIuSgmI2u9cxD/e5Z/Xxzm2CQTveuC/caIlIHuSMCZo0xk
	 BfREtgFIIr7VG0fi3eSl6BmjDGGT26Ig/MyaB8Re9Ov+3ltUkatZtPkWcDnPxZo3nrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257724;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=od3rktvThpmHG27AUgKJOFT+duaXCWPVODMzLp55jMA=;
	b=twZPFGgzUKX595VUcuySJZfpQX2vYLf2wonPyuF1Ue6tiuZTBCUU/iU8Oup+dyCv9k9E
	 fYInU7w36HsL+iZPflshmPaZXoBqnM5SNhloquq1eK4ml72DnxWlRCmjdJ8tlUVozl9gP
	 WXadnTTZQpXDPT0veZGwVTOCY83NDd3wGwSthYt3kvmj4l0jJdD7Es7SYyve8QcxvNTgg
	 xP8ESxP5xj8NipIZrDfQUKqGwTp4pO3fP70f510ufi37aymvzcQ6HbWxDaFyMUu2Onl2S
	 b51VL2qZ9B4iX6TTFFoo8UIsI9EDTfXBzeRoHNZxxJJe5Lx+54stPt5RJmMQ66tTYJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HyVBIC70;
	arc=none smtp.remote-ip=209.85.210.198
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF511606A320
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 07:08:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF511606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HyVBIC70
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a0688a43d3so1443423b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793257723; x=1793862523; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=od3rktvThpmHG27AUgKJOFT+duaXCWPVODMzLp55jMA=;
        b=HyVBIC70hD8mnthnqdIJhsKQpoP0dlSBmgVrk4awRy1knIFUL0VFd3izX48WAOS0x8
         7S9cRNybzdUtrsXId7772cYkrdh16Ejrqf7ve9QmZ3veqxNPVSvGgBa0EHMIU2YPXOnJ
         J38SjYFQFjiBFzpC//DAlXUW88lAVFeLSPwMNlgbISiATQpX4N0lESipsxGqulmyKgzv
         WO7u5OgVacyoOdZ1ggMJf9cdA/vL6YBb/oPIZw++nIPg8MuoYzZmuztMucD0V4LBkCOk
         OFmZhiMDzSZ+YAp6BF+9WjxICPbWdCF9tj6aUO0DkfOBbWLinuLAb/XyFdhd9u++JhXM
         FU6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257723; x=1793862523;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=od3rktvThpmHG27AUgKJOFT+duaXCWPVODMzLp55jMA=;
        b=MvbHsDjD7Uyd+oiDdE2eaC3Iok4xnhwQW/R+xb+PEZ40VYiVIauLaZAan1pchBRrdn
         7cP973xloRSnyB6UgO8lDRTyFv+Fm7TmJ+A61hPXATLXrX/bI+usoVlz9Tl736+FAsMe
         169NUcuiJAX9uzjocb6bs307u42N0hkw1ZYhFBf1Rq2/eOT9POzjSYMz/lPzR7MsHNkm
         fQdZc3/d2PrbbhQLL8qXQGo5cvXXnE7XxY9XY+nhmxtx+Z/oUcEB2YTc/OXqyEwCZlqE
         ZU3E7vbh9jRLtC3GwPbNae2VAkD3KG9I0v/L1bXme/QzhxChBKo/lTnRk7fSPY/gQcwa
         TcUw==
X-Forwarded-Encrypted: i=1; AKwUvByhQLI/YDAZ86kgC3gx2/8dZGMHTGwhKVwLmY/rWKAJh6M5SFiN/rQkIbN4pnlSj2/rLDzvuaWsUfnK@vger.kernel.org
X-Gm-Message-State: AFq9FYLLTV8VCspiElmtIRfa1IAuivufQq18+RKFDLaNYHenuYJVvthr
	9bttxZ3xLT4PUS4vc/rRUrNR4kREUSGYCSQ+aTEvKJsvGpBf8E1mzYRUPKWeRs95gWVtaPYCUvD
	6yidUtyeiyBBbL4QfT/6I0w==
X-Received: from pfbbr15.prod.google.com ([2002:a05:6a00:440f:b0:8a0:7c0e:8263])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1905:b0:82f:38df:681c with SMTP id d2e1a72fcca58-8a6e480a6dfmr3468902b3a.6.1793257722603;
 Thu, 29 Oct 2026 00:08:42 -0700 (PDT)
Date: Thu, 29 Oct 2026 15:08:35 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029040003.2100003-1-stanleyjhu@google.com>
Subject: [PATCH v2 0/5] scsi: ufs: Fix device management timeouts and runtime
 PM errors
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>
Cc: Can Guo <can.guo@oss.qualcomm.com>, Peter Wang <peter.wang@mediatek.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

This series fixes two problems in UFS core entry points that issue
device management commands or touch host registers.

Patch 1/5 restores the millisecond to jiffies conversion of device
management command timeouts. Since the timeout moved to rq->timeout,
a 1500 ms query timeout waits 6 s with CONFIG_HZ=250.

Patches 2/5 to 5/5 handle runtime PM resume errors. Several UFS core,
sysfs, BSG, hwmon, and debugfs entry points call ufshcd_rpm_get_sync()
before accessing host registers or issuing device management and UIC
commands, but ignore its return value.

ufshcd_rpm_get_sync() wraps pm_runtime_get_sync() on the UFS device
W-LUN and returns a negative errno when runtime resume of the W-LUN or
host controller fails, leaving the device or controller in
RPM_SUSPENDED.

Continuing after such a failure can access host registers or issue
commands while the device or controller is not known to be active,
while checking pm_runtime_get_sync() directly would leave
power.usage_count elevated unless balanced with
pm_runtime_put_noidle().

Add ufshcd_rpm_resume_and_get() around pm_runtime_resume_and_get() and
convert the 20 external and helper call sites to abort and propagate the
error when resuming the W-LUN fails. The three lifecycle call sites in
ufshcd_rpm_dev_flush_recheck_work(), ufshcd_wl_shutdown(), and
ufshcd_remove(), plus ufshcd_err_handling_prepare(), are intentionally
left unchanged.

Tested on QEMU ARM64 UFS (SDB and MCQ) with W-LUN runtime resume and
suspend failures via sysfs offline (no behavior change on suspend
failure) and GDB power.disable_depth=1 to make ufshcd_rpm_get_sync()
fail, and on SDB with a timed out query request.

Changes since v1:
- Drop the incorrect claim that a failed W-LUN runtime suspend
  latches power.runtime_error from the cover letter and commit
  messages. The PM core latches a runtime suspend error only if it
  is neither -EBUSY nor -EAGAIN, and in-tree UFS drivers fail W-LUN
  runtime suspend only with -EBUSY or -EAGAIN (Bart).
- Say in the cover letter how the series was tested.
- Describe each failing sequence in patches 2-5 step by step in
  time order, and drop the runtime PM disabled (-EACCES) scenario.

Link: https://lore.kernel.org/linux-scsi/20261025013446.345974-1-stanleyjhu@google.com/

Stanley Jhu (5):
  scsi: ufs: core: Restore jiffies conversion of device management
    timeouts
  scsi: ufs: core: Introduce ufshcd_rpm_resume_and_get() helper
  scsi: ufs: sysfs: Propagate runtime PM resume errors
  scsi: ufs: bsg: Abort ufs_bsg_request() when runtime resume fails
  scsi: ufs: hwmon, debugfs: Propagate runtime PM resume errors

 drivers/ufs/core/ufs-debugfs.c |  8 +++-
 drivers/ufs/core/ufs-hwmon.c   | 12 +++++-
 drivers/ufs/core/ufs-sysfs.c   | 67 +++++++++++++++++++++++++++-------
 drivers/ufs/core/ufs_bsg.c     |  4 +-
 drivers/ufs/core/ufshcd-priv.h |  5 +++
 drivers/ufs/core/ufshcd.c      |  9 +++--
 6 files changed, 84 insertions(+), 21 deletions(-)


base-commit: 503e6172fa74da6b4944ece458f5534681e51d21
-- 
2.56.0.307.g5fe7bd680c-goog

