Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257714;
	b=3y3zm+YcHW5ThQX2VW2v7EnkZgzV3TKfMwnTRp5LO9O8tg+tYnk1ys4MldZ4Lhjmus1s
	 nuwp0qWgxMl7jzeF8W9ekuX/N5qzW8g0Haq52fYfdkPNbGeUEyt7Y8HtmVjBWjeymg2G/
	 QqYdGAt/I5Uk/lFxE/Y8vleKcST4NAgTQ6jBHXR9dNum+r+OLireEV3yLRAVui0u9jOH3
	 BnZ4Q48+Pz1q60TUmqqhak+PItRnpOwT7WhaVaJPxLq/YOyv8LDuzLeuokzQdjFE7Jq2o
	 ZKGyhXH1T6Xet64QZ2vyrYZNV7xHTJhNOIIOiKLn+j3MZGOaotx9QH/TylUlmI/MkWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257714;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=K3AM1SjPaLQrVo38ruBsuLHnWg43JcXaTUMKROby+Fo=;
	b=itjSkvrfDzwvu2dW37EN5xetwikP4kFjS/4n1StIcw/cb7bR1xZ3CEDfsk6LM0dQYNFU
	 bIQdeW1WwR2cbQR9HII63jLo4mD4Ua+e66MyQKU3zLppUgnERwa7/aXLXYfHuyU81/IgN
	 jhBZN2Nxg7qzqlHISq4sz+DIt9pVbkW+ZBBgFDMP6Wy0S5NfeQP6TNqHS0HC+9W8O7cev
	 rhqhNaLCzCDT8TgNF/CrN5aiHHwUgZwoS0ZZ7Oj2qovcltP02xignJ14DhgYZl2SIHgxz
	 5MZz1jEdZEvKI/0WAsJ5eLSlriukUy3RaAZCvEJS9wWg/YXyrbY57ld3A9cMf9iJhjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Ay/HXkdc";
	arc=none smtp.remote-ip=209.85.210.199
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBD6606A320
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 07:08:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BBD6606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ay/HXkdc
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a079256596so1736520b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 00:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793257712; x=1793862512; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K3AM1SjPaLQrVo38ruBsuLHnWg43JcXaTUMKROby+Fo=;
        b=Ay/HXkdc42VKrrrHQ1rh+tKnXsuLOIa1OfJrZUcujGB5FqhWKSmQQZVWMYVPZtXkaK
         MNE2Mtr+Lkie5BhgtYxJe5Y1KyeiU2WMOeL8O6gxNtpa6te3Vbzk65XTKLWWS6r2m9Gk
         EnCkC33NAkCC1ie1dxu7f/FtB9/9jL0OWhkLfG3oJUriVxrRXhh85nLgWLLMkLLMaOcH
         CBK2OG2GrMuJPMfPdZsIastGuZLqFJE10MqhBcfAC9fWTN4Rfn68X0J0g6dr90EJrp5a
         jLGZJmtb+uHL5+lW8JZdyGJ1TRMtZUv4ml/QofdCPJZKtJd7x00ZD3LpGFy1WB/iDWFB
         X5Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793257712; x=1793862512;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K3AM1SjPaLQrVo38ruBsuLHnWg43JcXaTUMKROby+Fo=;
        b=Nta7O02+xlrQ9l14NmQFIXAasEWrX1970gqtYMTSp/bg9zovAhvG4WQUnS70KPUMSl
         A0dKEy0UItXMvVtot47IrnVCHVCZ0LKOs4cSA0z2SCtUyVRca2jm6035RBa5YOVGnV8y
         hnQs14d5EtPXSAkQU7GoKyC5d2QKnf0vD8V6DkWcJHTddV57qCsJ/zArL9EB2h81dTwg
         TKKvUxCAs5RZLftkxEQubbcWOT1rNqcccXYdHgeuiyLJIDeNWDFQ4nSI+UsEatfz5BOb
         XbsOW7IuKoh9kAKqW7qZBQ2mhrMZpOZ6WdSQ1dUOMQMZe+jVoagYrramydAxfacW+s1I
         kJCg==
X-Forwarded-Encrypted: i=1; AKwUvBzHNBaaGNzAqOFDwpBoOEQKWwCKXMLlFo1bY+CCq1AgdgPUg7BXICRmkZWzx7aVc4v6OUWux4htA1LA@vger.kernel.org
X-Gm-Message-State: AFq9FYIKj7QngI1x4JiNyjdJvVLyb/l+Y2b/c/tN42pxp0osZyrPOm5p
	h9CXSmJny4eGic1IFNKFZie8eWXw3v2Dmp0RZD9BwwSNyX4FeGcSgyWZUswDlWVFFnwLrcugKuK
	NROj482tffC0Q3Vwt/NwbhA==
X-Received: from pfbbr15.prod.google.com ([2002:a05:6a00:440f:b0:8a0:7c0e:8263])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6372:a810:b0:3dd:a009:3182 with SMTP id adf61e73a8af0-3e9023432c4mr3356622637.42.1793257712327;
 Thu, 29 Oct 2026 00:08:32 -0700 (PDT)
Date: Thu, 29 Oct 2026 15:08:30 +0800
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
Message-ID: <20261029040002.2100002-1-stanleyjhu@google.com>
Subject: [PATCH] scsi: ufs: core: Keep clock-gating hold on failed W-LUN
 runtime resume
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>, Praveen Talari <praveen.talari@oss.qualcomm.com>, 
	Peter Wang <peter.wang@mediatek.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	John Garry <john.garry@linux.dev>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

1. __ufshcd_wl_suspend() takes one ufshcd_hold() reference and sets
   hba->clk_gating.is_suspended while the UFS device W-LUN enters
   RPM_SUSPENDED.
2. Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
   suspend callback failures"), a failed runtime resume (for example
   START STOP UNIT completing with an error) leaves the W-LUN in
   RPM_SUSPENDED with power.runtime_error == 0, while
   __ufshcd_wl_resume() already clears hba->clk_gating.is_suspended and
   calls ufshcd_release().
3. The next W-LUN runtime resume runs __ufshcd_wl_resume() again without
   an intervening suspend and calls ufshcd_release() a second time,
   dropping a reference it does not own and underflowing
   hba->clk_gating.active_reqs on UFSHCD_CAP_CLK_GATING hosts.

Keep hba->clk_gating.is_suspended and the suspend hold across a failed
W-LUN runtime resume, so the hold stays paired with the W-LUN
RPM_SUSPENDED state and the next successful resume releases it.

Fixes: eef1d74bf88f ("PM: runtime: Only set runtime_error on suspend callback failures")
Cc: stable@vger.kernel.org # v7.3+
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cc75384c6502..9be370cea52a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10626,8 +10626,14 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 out:
 	if (ret)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
-	hba->clk_gating.is_suspended = false;
-	ufshcd_release(hba);
+	/*
+	 * A failed runtime resume leaves the W-LUN RPM_SUSPENDED, so keep
+	 * is_suspended and the suspend hold for the next resume.
+	 */
+	if (!ret || pm_op != UFS_RUNTIME_PM) {
+		hba->clk_gating.is_suspended = false;
+		ufshcd_release(hba);
+	}
 	hba->pm_op_in_progress = false;
 	return ret;
 }
-- 
2.56.0.313.g2479322e68-goog

