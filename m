Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8D3242D76
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 01:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769477236; cv=none; b=GP+jmN4LziMaLybQKyCC5Y3hiqFMP8auGwuvoWY2n6hdnNoF2ylJ2jlQdCIe4UKR6AB9OG77XRt83/TJjUq+w13KA8816dzGlzRFoLhIIeg+MYOCBQXsl15K8lb6Xu+L9j0/GYdRj1zPv1kOkTvDwz8MKOvt/62TneKUCex0V4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769477236; c=relaxed/simple;
	bh=2PkusNBvCXPAaSE7WSYZ8b1NjsEsw/WwT2shsz++lr4=;
	h=Date:Mime-Version:Message-ID:Subject:From:Cc:Content-Type; b=OOzXPEQJiLyPZZaCFi2RwDODrhpqxNgbhfg6lwJ4ZvoDs/zcTYZ6gcLXy7mT6IHR8RWKT2wfBELfCaES5qxs7d+5BykiJcmX0l84EYvUnTcOSdxVp1895rbMHq/uOk81oQHb4Dlx+YvW1ZaHoaus2EaytC4Qhd8zCiBVL8xYxXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--thomasyen.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=07SKOVP/; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--thomasyen.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="07SKOVP/"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-81d9b88caf2so3690241b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2026 17:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769477235; x=1770082035; darn=vger.kernel.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=164t62qeBCYmLeLaFusukV4c4GOaOGQY6hBpjpPEgbk=;
        b=07SKOVP/wWQwOeO1sw12rFVja1wXjqw7V8WdnIy31DuA2ET/jcLs8eDKzYgmlDu/Ne
         HKP6nsRxu9ZAVx1rI9K1Jng1A7p8qu7JAtQR115DnGdNJ8Kr6K9EmNSZauxqEcIp/UeP
         BnNcRHA1OvhO8yFWpSB7AOg1xHSyJfVflDYea0ihwR1TalkdR5HqX4+ZVK4cckLi5tEg
         5giF/J2tkRJMLsrjMh79HcLcP+t8iv0+XckgPYkxIOvY4eWMmJidhE3itQTozqUHoqP+
         5Mt9HS+FevcoQCWjZh11i0rBeoS5+4Mn+j0119saio93ib4ZU+tKrqZKDmNWLgtERtXC
         JYXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769477235; x=1770082035;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=164t62qeBCYmLeLaFusukV4c4GOaOGQY6hBpjpPEgbk=;
        b=t+5MlyHjSxZjBRUVLriOiLIjI4qjVofBcYCUKU/jwPNWWPKMnqyJbqLk1TtXugvY0i
         oYt7hy2K1Hu59Zu91SGPLoy2wxHVhmXdj0EryB9jJAr2uos6RSIPHFD2HkYg1/wwUwDi
         0BYXsbt8b5gzMIX+S05YAJnBTuz94Atfez9YuutvhLgR6Pz/1Vw9/BuNtZ0BrDyY+VS0
         UDH3FMLpILz7cmcrhRtGTfsBq533zXxyCfqBzuonAJo4/ZT6sNyRvsiyNWYVImtR1pVX
         35CZ88QO1dkleiF2VYZlH99J5hTf/8kpezsxr2aJsALO9xd/Eukbt2SuKxlgJRyS8PXm
         czYw==
X-Forwarded-Encrypted: i=1; AJvYcCU69OO+rL8Q/drytKMHrWrJxvAd+C8WXrumZTNdsYuYCijbxqCvJNgLx5BR6qq6YQiyL87lgZrx+lDW@vger.kernel.org
X-Gm-Message-State: AOJu0YzvaJlpeW6J1qrx+kdzFePGS6MfZ+SHk01D7snv1gVq9o2Mk9lV
	lQjj/EbymOtAtuDqL5CzdbYpA/trsBrAAuOHSrHd7KDg9HmUcmkmW9S0ZOWz5xvXUShuK8LpZw3
	+7dbqFa/omoKnjI1Cvw==
X-Received: from pfbhw19.prod.google.com ([2002:a05:6a00:8913:b0:7e2:fa44:4fac])
 (user=thomasyen job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e1b:b0:821:81aa:add with SMTP id d2e1a72fcca58-823691c12e3mr180205b3a.31.1769477234543;
 Mon, 26 Jan 2026 17:27:14 -0800 (PST)
Date: Tue, 27 Jan 2026 09:26:45 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260127012700.3311649-1-thomasyen@google.com>
Subject: [PATCH v2 1/1] scsi: ufs: core: Flush exception handling work when
 RPM level is zero
From: Thomas Yen <thomasyen@google.com>
Cc: Thomas Yen <thomasyen@google.com>, Stable Tree <stable@vger.kernel.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Peter Wang <peter.wang@mediatek.com>, 
	Bean Huo <beanhuo@micron.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	"open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Ensure that the exception event handling work (&hba->eeh_work) is
explicitly flushed during suspend when the runtime power management
level (rpm_lvl) is set to UFS_PM_LVL_0.

When the RPM level is zero, the device power mode remains active and the
link remains in an active state. In this specific configuration, the UFS
core driver previously bypassed the flushing of exception event handling
jobs. This created a race condition where the driver could attempt to
access the host controller to handle an exception after the system had
already entered a deep power-down state, leading to a system crash.

By explicitly flushing this work before the suspend callback proceeds,
pending exception handling tasks are guaranteed to complete, preventing
illegal hardware access during the power-down sequence.

Signed-off-by: Thomas Yen <thomasyen@google.com>
Cc: Stable Tree <stable@vger.kernel.org>
---
v2:
 - Add Cc: stable tag.
 - Reformat commit message text for better line wrapping.

 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0369043ca010..3a0e6c9ba86a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9997,6 +9997,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
+		flush_work(&hba->eeh_work);
 		goto vops_suspend;
 	}
 

base-commit: a48ca06cf343423faa01c573aeafba9fa5f92577
-- 
2.52.0.457.g6b5491de43-goog

