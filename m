Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892090;
	b=cyUe+D43FN4+ReI2rfYofwPT0LqMGmrIsFjnGtDNo8uEH4sNbTGtXrgfF8kpf/4VvHVs
	 BhpPbhR9YooLZSjCBCU2ydK8y6FePzBG7eXjESn+EDCa7pCEkFV5uzR+wRe9n7+9OrRPl
	 HV0fU30ASY0XaqhGQyP7i+ReG5ofye/xaqsQpIsApmc+HBqYh2yipNZlWesfWuLbHjSlw
	 sbahxhHX90ttVwcdiufCWq9kxDyEz6/NmywhCh6bJtxMtuWaSH3OQO9Ub/rZGAgBMIx9J
	 GPFGNavYGsgu8o2maBZHzz4ujyQ0Iu/rOcnRkP63zKg9cyIyYARAAk9w12lDKGeMucQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892090;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=yZ8488O7WbjmBGECLVnBLX/CdJuUluAndgW1v3to5AE=;
	b=aqknuRKCbX30SNwBEzNoav1UsxctRBEonA0Hgl5DPZJvy2aoSg3M00RDJDZ09FG0tkPq
	 FE/ahuKrWK0/9FYuUL4wy4qX59jWvFGX7F3chDPJo4kPT6DuAZobq6zCvTrWkrEL6AIok
	 ZoMSNNSvTCbslDjevwW81gpX9edSWlofc6DG0zVXPWm/pMYmpip96DtoJYS07XT96CMpp
	 8kM0K4D6skT2U1RbSzN2ueNH9hOs6rKW+Bc81jEbCLws4faB59+yVO4lwU7EYyN5XJq4c
	 ktdz0NjMU+YW/p7Eu9CDEVBeCkD5EJkpRkCxI4IKCU3Py+qI0xGtVX0jN5nXvl7HwNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=MvUBciHg;
	arc=none smtp.remote-ip=209.85.210.200
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F396E606A31B
	for <linux-scsi@vger.kernel.org>; Sun, 25 Oct 2026 01:34:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F396E606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=MvUBciHg
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-86fa6b15ed3so3185393b3a.1
        for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 18:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792892088; x=1793496888; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yZ8488O7WbjmBGECLVnBLX/CdJuUluAndgW1v3to5AE=;
        b=MvUBciHgwA2XlzjvYEE31gtLAo1s2kzVQ2tEnquKiOmoBBcUMdjmUqg1Hl1sgGRSE/
         mtL853Ju3CgTxnICSZfcliz1WQ/6QQeBYsx6vBmEk6Cbsg2tVrQnquGIrNAZel1X9sV0
         AEykW7q2FUsjC07/v+flN3OZHnAnNAjXLdD/a+S3tpPQB5HmUoykipYq6KUIEMMFa8S+
         +gA0tXnna1ntPLOjYS6+YhOgRv03fXGOIuVdJ0omUROT9cIwNXiDRT9t0AL+gEbJQoBY
         fUUyfj0sVBZ/JZmJMqkwZHyMIzD5Oh76hheBu1y5hjGR1NDVmGJ+sxq3NmsfMAuUGlKc
         WwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892088; x=1793496888;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yZ8488O7WbjmBGECLVnBLX/CdJuUluAndgW1v3to5AE=;
        b=knQGaWU77+nffNZyPYR5hNVtk1nTOrJAHgjKvA8yRmSuFt65CyS97A36pllFzuO7yc
         gh6IRVwXaOeP0nbusrp6qpqFmmODYL30hWRFxHyAF09rkRqpTiq3mFgT3jceYNCDs3aL
         yVCXvFyccud+D8koKrc1i4I+zbJZMAd1vRjAK4fbDpfoUBdJXoUhOYpOyOiZXDf26ELl
         spb+39OEJOnMRuDutr9ne2ZdNEbXeo5kPBxQr+5QRatKIAKGQV5pp2DrVjaFA7wdzMC8
         91iI1SyW0pFcJ0qO3vZvC2WEBtXuD2Fo75OQKCiBzumZRtfFAE1ltO00l6jq5pGWQggz
         BtjA==
X-Forwarded-Encrypted: i=1; AKwUvBywuoJvm0CtySpT63j4T8ruhO7ziSY6QjLvLp6alMvNLC0qW2KL/bPimKY4Umv8BLh1sN/6aNs7QdUD@vger.kernel.org
X-Gm-Message-State: AFq9FYIh5KpIDS50yjaok17cba03WTF6ovT44aUE+VufOZLYAFee9iGv
	MU0dhi1bQeGWDojVHIHeMMetPaYDIpL7JoBH7yYqOtU/nyTXWSbL1XezcluejDmc/JW9ASxHjv0
	xB8klfdsvv9FzDg38XYuNCg==
X-Received: from pfbbd11.prod.google.com ([2002:a05:6a00:278b:b0:89e:27e9:e2b3])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:98d:b0:89d:7d72:3433 with SMTP id d2e1a72fcca58-8a366f660b6mr1890699b3a.21.1792892087946;
 Sat, 24 Oct 2026 18:34:47 -0700 (PDT)
Date: Sun, 25 Oct 2026 09:34:41 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261025013446.345974-1-stanleyjhu@google.com>
Subject: [PATCH 0/5] scsi: ufs: Fix device management timeouts and runtime PM errors
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
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
W-LUN and returns a negative errno in three situations:
- Runtime resume of the W-LUN or host controller fails, leaving the
  device or controller in RPM_SUSPENDED with runtime_error clear.
- A prior runtime suspend failure latched power.runtime_error, so
  pm_runtime_get_sync() fails immediately with -EINVAL.
- Runtime PM is disabled on a non-active W-LUN, such as after
  device_suspend_late(), so pm_runtime_get_sync() fails with -EACCES.

Continuing after those failures can access host registers or issue
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

Tested on QEMU ARM64 UFS (SDB and MCQ) with injected runtime resume,
runtime suspend, and late-suspend failures, and with a timed out query
request.

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

-- 
2.56.0.307.g5fe7bd680c-goog

