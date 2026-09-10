Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E4F3644C5
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 01:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789005309; cv=none; b=IH/n1Lakl2lyllczU0dRVzy4Q75TSaOwORsuX6gjX8gkydINNzxX9O49Qf4RI78g0Jqs+bzqxPO0OwQx4sCChKYRajI0sSHKwUeZC5PcShXn6DaS3tHeJrBtWZN7jOEJA8n52Fx2iT3cSpYu2gfYXhC7vrd66gcXRqVP0WKkXR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789005309; c=relaxed/simple;
	bh=M6g75GxKPZwfj0M4wb39/wMW2fm2x6bFOZ9iXsZaaCA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=tXHtN+4QCKafUmAn0CebaltwDwDp2GT7Q7kpeCVpNeC5PIO28BGjKiDycbZY0dhD2RA73Aexy0M+uf6xoLXa1yev3PKTxGfQI4aZfLT0VpdiemjnJTcMpkMx4BOPQKEFZ3EhtOuIPxVoqzz1vf1JYRIINsQuWRHQByOM0KW0vgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UJD//NZ4; arc=none smtp.client-ip=209.85.210.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UJD//NZ4"
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-86a2639398cso45537b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2026 18:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789005305; x=1789610105; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NePljxZM68cBmWkIS+a2JA3eYMxsrjX7Iv9xSSnRDn8=;
        b=UJD//NZ4w6moNQYpZzdMtf6AQ8kZKoSN0yk12n48AJBFfP/4d1qgtU1H1ihZA4kv6/
         kBATjSP7xC+v1J3BXDoVxISVDJHNa31szJrRS29bdMr3xmyIWyb9TcCmOHkUCxlztZZO
         vGCxgd1g2BrU+/NMxAKqEnppfQ7l2ewTmFKGhh5qr8SahgzP/H/ri/quvxfdez7+aDsz
         63sZFVzbcfBkxXXvuheBKOQkTxst1fQQwkuWEp/j/hX4ds/YslmCMjx17dVpeaT+BYRD
         1iyKcfbYYxexg00DzKcDa3jVGyfIFRm8kht9Jp+UWgpeOXC/ocdKS485vElm7f+DPpy0
         gLCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789005305; x=1789610105;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NePljxZM68cBmWkIS+a2JA3eYMxsrjX7Iv9xSSnRDn8=;
        b=XxnJiGcwkfhR8VFOQY3K0WCPPg8KSakGCfqD9zpxPI2onkWRcLcR9E5jw9x/JSP7e2
         7Tx5ghKN0LYZiMhno8joy127Dce+iZY3T1zxXHFl/AtrQarRAD4H2H49OdVD53EzmPel
         kzio69ehEAZ1wzppOwr5hbtaInEiGBRd/JhG/oN8eU+bzUOfru71df0KudXxoHXUIKwK
         LPqgq8wTDyiXmxWOg2Q6B07huqgygVuTfcsP1tyEKOdgIgRke7f8yZD9myI45Yk7niEk
         DUGx6XKzVXTF9Csz6EymXjY6rm6WjYRfwJ0xLk+hXD5/NJZ36sYleeVCdX1rRk42u72U
         iPKg==
X-Forwarded-Encrypted: i=1; AKwUvBzQ/QOjdqUbBWUVzIi6iUICjPnBEJhsmGr5ssJXVZ/V5EgH33oMkn2PbtF7nVtMmMQatjBY2OsEcyc0@vger.kernel.org
X-Gm-Message-State: AFuF++kQksqHWaVSsuvol59qW4ouw/wm6XGBJKJ2W4TYbLcolHJZsc0O
	l1ODVzq1P4PcrAb3uEEsvQEoxqkOAo7V9leT8c12gyqRorHTJq2CMSMZcvIERMRa3ou5X0sfTin
	7MK+UBkAYqxeYrujVfF/zbA==
X-Received: from pfbgq17.prod.google.com ([2002:a05:6a00:3bd1:b0:862:b45b:e636])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:7583:b0:869:2e7:977 with SMTP id d2e1a72fcca58-86902e70c55mr4810484b3a.4.1789005305453;
 Wed, 09 Sep 2026 18:55:05 -0700 (PDT)
Date: Thu, 10 Sep 2026 09:55:01 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910015503.1991119-1-stanleyjhu@google.com>
Subject: [PATCH v3 0/2] scsi: ufs: rpmb: Fix bus registration and device lifecycle
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Brian Kao <powenkao@google.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@sandisk.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, Li Qiang <liqiang01@kylinos.cn>, 
	Ao Sun <ao.sun@transsion.com>, linux-kernel@vger.kernel.org, 
	Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

This series fixes bus registration and device lifecycle defects in the
UFS OP-TEE RPMB driver.

Why:
1. ufs_rpmb_bus_type was never registered with bus_register(), causing
   device_register() in ufs_rpmb_probe() to unconditionally fail with
   -EINVAL.
2. struct ufs_rpmb_dev embeds struct device but was allocated via
   devm_kzalloc() tied to hba->dev. On host unbind, devres frees the
   structure prematurely while external references remain active,
   causing a Use-After-Free (UAF) Oops.

What:
- Patch 1: Register ufs_rpmb_bus_type during ufshcd_core_init() and
  unregister it in ufshcd_core_exit(), with stubs for !CONFIG_RPMB.
- Patch 2: Allocate ufs_rpmb with kzalloc_obj() and free it via kfree()
  in ufs_rpmb_device_release(). Pin the underlying SCSI WLUN via
  scsi_device_get/put() and unregister in ufs_rpmb_remove().

Differences from v2:
- Drop generic RPMB core changes (sent as a separate patch).
- Reorder patches so bus registration comes first for bisectability.
- Call rpmb_dev_unregister() in ufs_rpmb_remove() to break cyclic refcount.
- Pin underlying SCSI WLUN via scsi_device_get/put().

Tested:
- Verified clean probe, RPMB I/O, and unbind on QEMU ARM64 without UAF.

Stanley Jhu (2):
  scsi: ufs: rpmb: Register and unregister ufs_rpmb_bus_type
  scsi: ufs: rpmb: Decouple device lifecycle from devres to avoid UAF

 drivers/ufs/core/ufs-rpmb.c    | 107 ++++++++++++++++++++-------------
 drivers/ufs/core/ufshcd-priv.h |  13 +++-
 drivers/ufs/core/ufshcd.c      |  16 ++++-
 3 files changed, 91 insertions(+), 45 deletions(-)

-- 
2.55.0.1007.g17ff1f9808-goog

