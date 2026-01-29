Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F71296BC1
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 16:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769705560; cv=none; b=AnUeMft9KsczSlrFf4Xnvsl0HS6soKDMdtP8CxJTLg+PviFYsHGdJGSH+zlEekx85CiLgV0lzf/Nn9rmsw6W4YJuxn1D13GuDEzjFzjVUH/6YrdyYNdLpr+vcqH1zq+F5uEPUKWRXbswKSKs+mqiBvLgZr8595CsE4bf+TVMBWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769705560; c=relaxed/simple;
	bh=B1MPTM/kJP5aRghCWlM0TtdejrUwSpsLDbd7d2LgvqE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=aY3E17P62wAl5okjqsOOphjLwLQFV85fVKBDN2NZagqrtfC62n7XLt4jurrHkgIJzfPq+oOiUjEl5VOkOBQ581B3dpX6No4WaIba9UPVrUz/DdI1zh6Q/EbGGp2S/INd5o4jgxdprIwgFfEKoQcjHybaBKjeYwBSRW9LVVf1o5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--thomasyen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bNwmq8wy; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--thomasyen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bNwmq8wy"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c549aaa796dso2101123a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 08:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769705558; x=1770310358; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xcI8KLWScQWADlApPVsSl8lWzsA1EUoFkehAyhaBPxM=;
        b=bNwmq8wyFYJMZ0neaxdFwkcnXta0wpe21vKFaIUtdA93jw2ttSVtfY8LBsSLnxaK8O
         miilxEuSKXfmSk+Stv2M6anfMbIpmhvHv7atm9N7TKXvsH6a5+kk46ZjT/XOjWTA3Xk1
         fcvTCB+pzXiTodOI+yNiig9bF0SdntWNGNCdA7hHWj+jYZkR2Cr+ELAMM6a/LjlGCTwE
         LZDRRkeAO3VuPtUEaX8sev9d00ZnQoUrkfR32dEbF03AHMLW/oVlCo53jhdBaKr57Jkg
         PE6KQcaJKOpoaENMPcu4u873Bjn+G9IAusQ+Pwr8kRTgE9FUx2Al9cJZkmN4XfvXQDA5
         KPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769705558; x=1770310358;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xcI8KLWScQWADlApPVsSl8lWzsA1EUoFkehAyhaBPxM=;
        b=aptebch3sE5lRCgfCSMnBTQViAzasZUiodwPK0Ppl5dQTfOwFxGG6g31km6wOu2v2b
         BlvNlalew6+zCJ/3GmM3bXAhhvaFVLZzQBtqiF2xxIUcaw+aN7aeEVfbTQkIT5xFz4KQ
         OSUYn3WfFWYY8kjmEjHoOe98cz4vHid1yrdsxaDCoeXybjw/exlp4gOARdpm/eqN2Tut
         9pGTHOqquSJCjEZ1Z8EnO7hjB0xTaeDflWR1oUXiux+5vbRiMKWA8TVsbuHW2XymNE60
         wWagp3hTExlR12G4DwF9lnOpQfrQLh7Sa6Kdu5QVjAbKWI3WHR0DT4VIL8XLyxB+hbw7
         zVaw==
X-Forwarded-Encrypted: i=1; AJvYcCWUnZWT4l2viMuZnWl5ACvtDCMgY9Qechg5lMw1ArayA/Nk0160y+0fkTEzT0ZHKEXzxG9gvXYrls67@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1I+fMlXRz8zDBGSLr0doE9ywkIBJRhJNlV6MtKYbfsNdqJyXy
	+OdhFEREvR8/CrhmqGTQ0ytExLLV3U4SGK7YnEhkRxSEsrzVB9ACOwt8kdk+uKqlPR5SOxceD1X
	9GyfE7HVUeRlIBeRQIQ==
X-Received: from pgg10.prod.google.com ([2002:a05:6a02:4d8a:b0:bc4:233b:be04])
 (user=thomasyen job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:b82:b0:364:13ab:4119 with SMTP id adf61e73a8af0-38ec628953cmr8347913637.15.1769705557995;
 Thu, 29 Jan 2026 08:52:37 -0800 (PST)
Date: Fri, 30 Jan 2026 00:51:51 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129165156.956601-1-thomasyen@google.com>
Subject: [PATCH v4 1/1] scsi: ufs: core: Flush exception handling work when
 RPM level is zero
From: Thomas Yen <thomasyen@google.com>
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: Thomas Yen <thomasyen@google.com>, Stable Tree <stable@vger.kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Subhash Jadavani <subhashj@codeaurora.org>, 
	Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Ensure that the exception event handling work is explicitly flushed
during suspend when the runtime power management level is set to
UFS_PM_LVL_0.

When the RPM level is zero, the device power mode and link state both
remain active. Previously, the UFS core driver bypassed flushing
exception event handling jobs in this configuration. This created a race
condition where the driver could attempt to access the host controller
to handle an exception after the system had already entered a deep
power-down state, resulting in a system crash.

Explicitly flush this work and disable auto BKOPs before the suspend
callback proceeds. This guarantees that pending exception tasks complete
and prevents illegal hardware access during the power-down sequence.

Fixes: 57d104c153d3 ("scsi: ufs: ufshcd: Fix link state during system suspend")
Signed-off-by: Thomas Yen <thomasyen@google.com>
Cc: Stable Tree <stable@vger.kernel.org>
---
v4:
 - Add Fixes tag.
v3:
 - Add logic to disable BKOPs.
v2:
 - Add Cc: stable tag.
 - Reformat commit message text for better line wrapping.
 
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0369043ca010..8c88dd5c2cca 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9997,6 +9997,8 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
+		ufshcd_disable_auto_bkops(hba);
+		flush_work(&hba->eeh_work);
 		goto vops_suspend;
 	}
 

base-commit: a48ca06cf343423faa01c573aeafba9fa5f92577
-- 
2.53.0.rc1.225.gd81095ad13-goog

