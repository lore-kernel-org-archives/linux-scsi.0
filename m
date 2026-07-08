Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D0D2165EA
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783514989; cv=none; b=kQSU81zU9M0JP1hqf7VtWxGrM3JIreRFbZQad0fnMAT7dJC1HpqlBLkSKpa4Z5Wd1MQw9hUIWnJcXzSiLSJpKOFP+wc0JP2moDVMAYtJZyh7UI6IomwhBdfnF2RAOyesE/vpBF1gkuouWqV9ME0XIhYiDMfu01uxyaSBf6j3Ma8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783514989; c=relaxed/simple;
	bh=n2nH6kTAhyC1n8/BGxNBjbsF7U+UVsUzSr8/n9ex8KI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RC0X4wjYzfRvv3AFJAT4SSvEPYfEwwY+2Nq1HVKlig1qKWgLBQ5ltJZrT7MehJoVn8uXuonyNyPWRlKilyaDJAZi0XDEkOKWRwuXc7b51abP1kgqvemzSTBsCfqlxhN2C07lf5euFKXuYOLatsPjRzku96haGluVOPY/SrDEiNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PZxaJgLL; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZxaJgLL"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c9b373d5af0so456109a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 05:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783514988; x=1784119788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t/eJ2nE9MwhWwXoqGShfoG+vedkOAHqJyjfJT0ks1QY=;
        b=PZxaJgLLDdRWkCFbwebu86X3EtlLf0jXLhYv8qWyY0WdyXQYN31r0G820O6z8MH3kW
         sUKMlw21Czy+99nDdkSNlIEnsO2fdbYg2BGcL2CF7rStY6JYus/KXTOO/s1bwcFsN7zo
         gwDvle9k5vDN3qHNnxpXmmLO/yweFHGNIL6ANpGRgY7hvR5P2d1gw1Ksv03DxEFXj6zP
         dQSqSCn10ZZ+KDBThR4b+M22p3wsO3hoKlqtmlxNbxj2NRAdQ4PGgoMwS/uZygOTBo5o
         mpSx2JOnG6NS1oLzWpDiowcCgu4KDDB0dNwWBFiJQ8qW0jxL+OH9vtjZqt/oS57C/zX/
         vzQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783514988; x=1784119788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t/eJ2nE9MwhWwXoqGShfoG+vedkOAHqJyjfJT0ks1QY=;
        b=tYEa2cuHrSIRhb5EnXJDTqZOnumUcAN4U9R/GMQ7zlVBqOl5YUDyiqkI2UTKdhyJpb
         Ch+0u+CWnb01HYw5Ivz6zFwg9zzFnOoZBK0djg/OUHylNUGv+DhEKJKcPv/A9NoiGHbV
         dM4VGsaXxR87W93wxxSpGXuaJQcpekynoukHbSBEbKB0dlag4+hI/vFLJ+5u1jyg4kGF
         UdPnpaXKvtb/RxHxkdHZfu0jlIW1Jf2AUhsDAnQKh6nx86uECFucJqAfWYvoza32tkCq
         mYwdMLURKzD19mlrxlyekf/MtcrX8rb74UqKfVC11a4145q0lycoc6jtok/0NOkj+aOn
         Vj4Q==
X-Forwarded-Encrypted: i=1; AHgh+Rq/vqW63yac50Iq1iLqcOl3k53G+4wo0eTFAK/wSQB7YOfU5TyfWKcsYSqUBvi79L5JxzIux+PcSHo4@vger.kernel.org
X-Gm-Message-State: AOJu0YyaNGDeN2SzFHEbIR0QmF96k0oN5Csy8zIJdaXWyItoaE8ec/ZZ
	GvKuPiBLbZ+yOr/lgoAplFmXkM3A0QeZPPrXcWnkecYm8ghmeI/pJy+V
X-Gm-Gg: AfdE7cnpUPdYp34FCu1bvh+cp9uBKMtpgl0cElcwWc7jl3CUzrs5TMLbzWr5HaIGTne
	mvoiJttw5pejZGCmY2bItJybC7m+OmMnVriaDPzoG99W4PFulCvDVrZiNM3+csfZNbxleJwgjVc
	KJ49g+BWeo11bGfbEM2hCsh9o9rCIOdKwY+W2Wu3XfV6u6oA6XrlgA/ztBYz+nTy7NSFnPCPm81
	4dbHEUFlwNAxU5nob7xfoNCdnsscyYe+CvjyaxaHmIYdAV1kYA5XHZwkinRluZB8BG89mT5gMK/
	Wla7YBk4qRRFi5cNBdZRjYkMXI/qScg+1vg2nB8IS8PcnGnuhgOHDt7fZ6BWO0rngWCuuxBuUVN
	rDWPRiNFf+3jlQXsOWP97EwqV83MImVEVnbc520oxPY2Ho9kNnRZlZnEn1VAmbxnSBsKv3xnb8y
	LZUg==
X-Received: by 2002:a05:6a21:6817:b0:3b4:888f:b3f7 with SMTP id adf61e73a8af0-3c0bcbc1d5fmr2752621637.42.1783514987879;
        Wed, 08 Jul 2026 05:49:47 -0700 (PDT)
Received: from lgs.. ([152.32.188.52])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5acedb5b3sm2424157a12.0.2026.07.08.05.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 05:49:47 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Luca Porzio <lporzio@micron.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Mike Bi <mikebi@micron.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] scsi: ufs: core: cancel RTC work in active-active suspend
Date: Wed,  8 Jul 2026 20:49:34 +0800
Message-ID: <20260708124934.764281-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

UFS RTC support schedules ufs_rtc_update_work to periodically update the
device RTC. The work can issue query commands and access the UFS host
controller.

__ufshcd_wl_suspend() cancels ufs_rtc_update_work in the common suspend
path before calling the vendor suspend callback. However, the
active-active path, where both the device power mode and link state stay
active, jumps directly to vops_suspend after flushing exception handling
work. That jump bypasses the RTC work cancellation.

If the RTC work runs while the vendor suspend callback is gating or
otherwise changing hardware state, it can access the controller during
suspend and trigger an SError.

Cancel the RTC work in the active-active path before jumping to
vops_suspend, matching the common suspend path.

Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d3044a3089b5..9d5571a7aec2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10269,6 +10269,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			req_link_state == UIC_LINK_ACTIVE_STATE) {
 		ufshcd_disable_auto_bkops(hba);
 		flush_work(&hba->eeh_work);
+		cancel_delayed_work_sync(&hba->ufs_rtc_update_work);
 		goto vops_suspend;
 	}
 
-- 
2.43.0

