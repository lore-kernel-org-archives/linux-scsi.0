Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A55A231A3B
	for <linux-scsi@vger.kernel.org>; Mon,  7 Apr 2025 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021033; cv=none; b=I9OjogiBuyghZnB45KcQUJPz7LadbgZkmqiB+QsXZiIEw3SyeLVH3NB62NSgZent2KGvgLcXaT1359uZ6aFaJnzypyaK8GOxTWx+XQsqGZiPNnyfZCrSrCFPVfruFfo465m27YGXOOKtwKm4A8mn8G2AZPpd/UBcZeCCS4Vjdbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021033; c=relaxed/simple;
	bh=GJ/3LoYhjreXCmlje4HGApIZSD0dopghOnCCoRTD310=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DJig4buamc4CgQ78xzR/p32QIyDZpZyzmbdud0bo4vq4NfrHSjP+Ga/ENB4YnX6izorKj4WP17l1IIElT5dTUHqyepqYZ+oMgyQSssvTXxxCsSjCW+i8U54E24vTxSQEs/hi4sviVackyBNFuTx97ZPYCfP4DAZ3LjCJnNtJtYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JexIb2gj; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JexIb2gj"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39c31e4c3e5so2531216f8f.0
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2025 03:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744021028; x=1744625828; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PxuAzzqTN8Esy+3wBd10qAHGJHFzExg1oERBNtTrUmM=;
        b=JexIb2gjNt3Gy/0s2IiYAJmZpxFMHlk8DtcWbR7rtyvXNqYfH8Hl+Byo5o47fypklG
         tQnm8mHpZ/MSG/9yObjvvSjQmv9tFsh+Y7VzULy7ZpOkc+w5PQzZFxkcSb7LUXDX2Git
         5ca/Sz0R4mmXboyU3kA+/PK0rCyH6nJs/5Kt4c90/gE/tOCaP7KZ+7aL0RMLt1QJdkpi
         3FW/qt0sJx2Sv41pXbYN49/eloQoDgA7j0EhAYixmItwtUKd/R61WLx8tEW61VoB5rZT
         70+RXV4cNuB/TimQGcMdu+7Eai4Amo7f2tqL1XAyXHO8uUfZ9eZ8ZjCU5VtXtgf++2fI
         ZXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744021028; x=1744625828;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PxuAzzqTN8Esy+3wBd10qAHGJHFzExg1oERBNtTrUmM=;
        b=o4zJ0hTSf5WE2yp70kbEYpLCZhewcZ99SeECT3KgXAB++28G/01/qZaypm5jWWnvCe
         rkGKHkCEZAdzX/hDih9tzg6qaQlFQKwayaeKGE1K/+oKtaenibZRNEmf1QQF9LAG69v3
         by00v6MiBXj40fKFlqZ1sD+gjnAdV7kt4paz4YOAGQdhfy+6eikjwCA3HxSvhjTKkagq
         P+H0JNpD5DjzXI4TdzxMSItWjNmBs2KpaSf9VYEMx2MMC1+rY3BnC/XjTFvggAXxktG4
         1nbog+WvVnjXoQsH5cwEjvOPI69deV7FhzSNWES8wXCXzKVa3d0Xie1Ej1monBtZ4bXA
         Aebg==
X-Forwarded-Encrypted: i=1; AJvYcCXWnskyBjAodOkLPEN92DFab4vxqF0uaioHgz/QiE/+Y9+tJcLQFOgoj1D3cu1JZ09uKFH+97fZZJJV@vger.kernel.org
X-Gm-Message-State: AOJu0YxEMRrKdMAamEBAk+WejVFTccei34QBpWN11ADAuB0i4/FtZXVe
	r+4LJJ1yoYJ6hPx8I545Px17OA+w8p760JXnQKpK7HOHH3UBm8eUsUSqGS1M1y0=
X-Gm-Gg: ASbGnct/q9y9o9RRMRZ9xbGgVVBd6gYmPq7IHzkrnZTO7cNGiFBoFwfF27B8Qq56nLx
	tQHr0ketflPg0s6pEMvt6cG8ipbK/rGWELOmfDxmaeF9CGy01NKnUbdPmW0CY0iGUrEU/1bzTRI
	Q8qUeXb6+YM7R/plTGLAc8JSjTK+ASAdvlNVslEMGGptp3huefcfL1CDRyLSeXYzfrfNX8E8WxZ
	AXtGFtCKelLoRr2sVxxtMPyPev73X0FK//mv2Wwi7ewu0W/Hwb4KQNj1lg70EcZzz/UVCoazaF8
	V+17HQ4HPIlukkVXIGRorQKk5CrMhWnfUi90enCdqSKODkozfTRNXVceEyMGKw4STQ==
X-Google-Smtp-Source: AGHT+IHh+6UGrJ/XHf2b1137nkPVPeuW5PoXq2uwhIcmz71829sHC5RKQ4MEcbte47SAnkiXo4gpRg==
X-Received: by 2002:a05:6000:188f:b0:391:3915:cfea with SMTP id ffacd0b85a97d-39cba93329amr9862933f8f.38.1744021028483;
        Mon, 07 Apr 2025 03:17:08 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:3d9:2080:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301a67a1sm11476831f8f.24.2025.04.07.03.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 03:17:08 -0700 (PDT)
From: Neil Armstrong <neil.armstrong@linaro.org>
Date: Mon, 07 Apr 2025 12:17:05 +0200
Subject: [PATCH RFT v3 3/3] ufs: core: delegate the interrupt service
 routine to a threaded irq handler
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250407-topic-ufs-use-threaded-irq-v3-3-08bee980f71e@linaro.org>
References: <20250407-topic-ufs-use-threaded-irq-v3-0-08bee980f71e@linaro.org>
In-Reply-To: <20250407-topic-ufs-use-threaded-irq-v3-0-08bee980f71e@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3901;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=GJ/3LoYhjreXCmlje4HGApIZSD0dopghOnCCoRTD310=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBn86Yh9gJ5axoT/EQbGWoqm1NFW5vkB2viScmVj9lv
 3zyu8NeJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZ/OmIQAKCRB33NvayMhJ0faSEA
 Cda9fOHkeTmvfwyg0O+9OkwVmMxfblxX9lpBagC/2+wG542TmQ/IznGMbYXZn/h3UmpJQgAcpKt1Dk
 DXIzZRFBxs17dffzTsGbFmp+EKhVmBoQPCDqH0YPHBcMM8R8I/yQT33v3ygS6PkvQQO9/nFyXmnokE
 Llrr+gCJW6jG5FXPjEVLJ6aKTcOtOj3mMp5p1FsxbOTI+TtOhM5pOomdZrVuUzyHLqrQ+R8xMr6BGo
 3+6zc5klY7QEsJv4LIFzklaGh1pDbEqeYgT2WS+rJtJkGkxXEqD8At5DrbjU2fDLrJgJWxc2ZvN74I
 2rz2//vS7H6zmXsbo73NOPVuMvL1Zu+eWseoUs1qkGaLI1BSyLeGjUSNGF7PUPV011hAC0KHAPTQ7v
 cJJLItL/eDavPoRw1Hpf9C5ORd4EuY48CibS9VveKTMd4HLDqhwDszEPCz/2L07pfVgrM/nmHAGxGv
 qSWiw2NzS1HE2kKuH3chhPNgiQDCsxZM1LGI7W9hniNBXFuV8/67myXyc1osPrwsuNgMEVcxFn1hxh
 GmdKebccIDYdWwiJGM72YAhh1UXfwcKtAepsOFO4yoAS7gVPKlzeOzvQm/qTN9OYPJAlK2Koj25Ug1
 fPqAWLx6u4daaV/0A3bWBo1es/VvlfKMopdmwBilSYgBRA56C4eqYGkpl9FA==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE

On systems with a large number request slots and unavailable MCQ ESI,
the current design of the interrupt handler can delay handling of
other subsystems interrupts causing display artifacts, GPU stalls
or system firmware requests timeouts.

Since the interrupt routine can take quite some time, it's
preferable to move it to a threaded handler and leave the
hard interrupt handler wake up the threaded interrupt routine,
the interrupt line would be masked until the processing is
finished in the thread thanks to the IRQS_ONESHOT flag.

When MCQ & ESI interrupts are enabled the I/O completions are now
directly handled in the "hard" interrupt routine to keep IOPs high
since queues handling is done in separate per-queue interrupt routines.

This fixes all encountered issued when running FIO tests
on the Qualcomm SM8650 platform.

Example of errors reported on a loaded system:
 [drm:dpu_encoder_frame_done_timeout:2706] [dpu error]enc32 frame done timeout
 msm_dpu ae01000.display-controller: [drm:hangcheck_handler [msm]] *ERROR* 67.5.20.1: hangcheck detected gpu lockup rb 2!
 msm_dpu ae01000.display-controller: [drm:hangcheck_handler [msm]] *ERROR* 67.5.20.1:     completed fence: 74285
 msm_dpu ae01000.display-controller: [drm:hangcheck_handler [msm]] *ERROR* 67.5.20.1:     submitted fence: 74286
 Error sending AMC RPMH requests (-110)

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/ufs/core/ufshcd.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7f256f77b8ba9853569157db7785d177b6cd6dee..b40660ca2fa6b3488645bd26121752554a8d6a08 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6971,7 +6971,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 }
 
 /**
- * ufshcd_intr - Main interrupt service routine
+ * ufshcd_threaded_intr - Threaded interrupt service routine
  * @irq: irq number
  * @__hba: pointer to adapter instance
  *
@@ -6979,7 +6979,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_intr(int irq, void *__hba)
+static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
 {
 	u32 last_intr_status, intr_status, enabled_intr_status = 0;
 	irqreturn_t retval = IRQ_NONE;
@@ -7018,6 +7018,29 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	return retval;
 }
 
+/**
+ * ufshcd_intr - Main interrupt service routine
+ * @irq: irq number
+ * @__hba: pointer to adapter instance
+ *
+ * Return:
+ *  IRQ_HANDLED     - If interrupt is valid
+ *  IRQ_WAKE_THREAD - If handling is moved to threaded handled
+ *  IRQ_NONE        - If invalid interrupt
+ */
+static irqreturn_t ufshcd_intr(int irq, void *__hba)
+{
+	struct ufs_hba *hba = __hba;
+
+	/* Move interrupt handling to thread when MCQ & ESI are not enabled */
+	if (!hba->mcq_enabled || !hba->mcq_esi_enabled)
+		return IRQ_WAKE_THREAD;
+
+	/* Directly handle interrupts since MCQ ESI handlers does the hard job */
+	return ufshcd_sl_intr(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
+				   ufshcd_readl(hba, REG_INTERRUPT_ENABLE));
+}
+
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 {
 	int err = 0;
@@ -10577,7 +10600,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 
 	/* IRQ registration */
-	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
+	err = devm_request_threaded_irq(dev, irq, ufshcd_intr, ufshcd_threaded_intr,
+					IRQF_ONESHOT | IRQF_SHARED, UFSHCD, hba);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
 		goto out_disable;

-- 
2.34.1

