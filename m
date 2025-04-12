Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E77B1C862E;
	Sat, 12 Apr 2025 19:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744487955; cv=none; b=XvORZUjDIahvtnzn6S3XhDDoKgctIke+ksEV9VqnweLkkp/YR1rkW81ZlV69dKf1nDfEAOrP0brJl5OnGziB4vJ/oi2eq5W73KPMpDNRpQ9S9Q9S3Xp8CMpP7PDrA/u5K5+wRkqFzPHJUZVHhxOUSnpmMgGxvm/w+FXbsKEaGJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744487955; c=relaxed/simple;
	bh=2OjB1QhTLKklmbQVSbsphQt72iZ7X8Hyz8dWd8pfqvg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=E53C3QVygerT+Gt0pV3/Et/EMrlW/CNNZsUrFVr7QsByLScTio9BtQBAcnTS6pSb8gqVutgNQdtrhS3rtiEY2xRT2eghMxsWhGKL7bahCZUTPHJ6DW4iOaDIII0d3dCKhQvieoysFV0pWwR6rtl7+6MhMpkNyIYhjI8mWmG3PQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MLiguAgB; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MLiguAgB"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6e8ff1b051dso5262436d6.1;
        Sat, 12 Apr 2025 12:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744487952; x=1745092752; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zVbi2TXkSg4KXX8medQfMaOeKCJREtWfx9H5qztrBxM=;
        b=MLiguAgBWZVuX1hVxStUTTl23qh5khNMSEjt+b3qU9fCnFdsV4/xQ/uAV2bYOqLW/d
         P5TjIVyi4oFXpqTKTMaNBjSJEA278U4akBd4Dx0GB5aakhsZNpM9q8kcBVfY1TPN/Utj
         dnMIB8yl3B47sLiQnwE9gxz8s2gF6C0JtNpcuFViLIwLsK5/lto5umu84WqRAMG+UHaM
         JogPi1GCfhMMqgC2qtrjmoL2wE8qHR1Lh54NRYqKeSY9QwQmnbJ4veECd4ThHeUd72YC
         eppfNrZITi8zrldNwrhEUD/56WuB5fpaa8PXOsEw6Lk580CG36UyMbVn/HtoEiXcIP3K
         hdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744487952; x=1745092752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zVbi2TXkSg4KXX8medQfMaOeKCJREtWfx9H5qztrBxM=;
        b=hTYfNaJOQmAUbhwVIFghdUG9MNiM8L6KoErRPv5wVXAP4/557tEJon+LetUTxCvBw6
         yx7nDX3ZUFMRoZEiwnDnaiTt3V7359NRBhoIEyB8Y9lZX0WwB/EnxgkilQyWVDvKtr/Z
         WhqqHCrUnt5tzm7V/f4CUA5R6hVdxaDZ8bIpl0NZBK8c5NLS91eijOeV5ZWpAyhix3RZ
         Cpdgu7yEKAMHiqJg7jeuHFtQJ/ePLheg7VzksAERhuKAiQ0Y30jZjxuCj0maiyhJWvPJ
         HwRpaGh+Rm6c0JrGwlTWEZxpWnaw3i8/MVlFGgsxC+YIgpH7E73xfnZh+AQCiy5BYL4K
         eyMA==
X-Forwarded-Encrypted: i=1; AJvYcCWpUWWES/4AeeBDaKRQ+v+5nS9YFt8NvJ09kxHPI27wnHrhmFVCz2AiiBmb4iVh34IcrGUmAncjd9NPhcg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXCBK91zaYhzwCYTIMABcohLBilnu9LjkIBbNMFyIBvZ32sMe9
	+fUA1TYJ96Zr8RyfGGcXLI/wl2+GkmTz7IbqYpg9U3zPqinVGAZpZXMP0C8=
X-Gm-Gg: ASbGnctJ6qZAn3YTe1nHU2n2adKe0hZw92dghXSoxceBe/2gp52GUTUhoRAFFWC3xO3
	AIbqGeXcevB03nW/EAoLUf9YDcZ7OHoD11JhAnNwd8C0eOoW1clrE778I6oaQxTq6izbJ9vnCG0
	xfFXQdoNbvobEI+fNuaMFsskBIjSf7tePdGdgXEV/wq64pD8Ng07Fql9iUGjiBxGQSq4t/OoMqH
	8SyFq+A4YHpjjb96YfCYnyARJHllQL5x9g1tOrXpDDwgyC4g9QAjfu6jVr/zzjE6WZyeGDADVSe
	cfaioq3zFwWXgmkxt2+TPSTqqsFWZIrD9jNNkA==
X-Google-Smtp-Source: AGHT+IHOb1sEOftq5ghYu8md170FhVPT25M7x4K+yhMg+C67EgyS5u0Mu32YcIcVtklarGAqfD82qQ==
X-Received: by 2002:a05:620a:4306:b0:7c3:d798:e8ae with SMTP id af79cd13be357-7c7b189ed07mr334969285a.2.1744487952199;
        Sat, 12 Apr 2025 12:59:12 -0700 (PDT)
Received: from ise-alpha.. ([2620:0:e00:550a:642:1aff:fee8:511b])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c7a8969428sm447768285a.61.2025.04.12.12.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Apr 2025 12:59:11 -0700 (PDT)
From: Chenyuan Yang <chenyuan0y@gmail.com>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	manivannan.sadhasivam@linaro.org,
	stanley.chu@mediatek.com,
	quic_cang@quicinc.com,
	quic_nguyenb@quicinc.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chenyuan Yang <chenyuan0y@gmail.com>
Subject: [PATCH] scsi: ufs: core: Add NULL check in ufshcd_mcq_compl_pending_transfer()
Date: Sat, 12 Apr 2025 14:59:09 -0500
Message-Id: <20250412195909.315418-1-chenyuan0y@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a NULL check for the returned hwq pointer by ufshcd_mcq_req_to_hwq().

This is similar to the fix in commit 74736103fb41
("scsi: ufs: core: Fix ufshcd_abort_one racing issue").

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0534390c2a35..fd39e10c2043 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5692,6 +5692,8 @@ static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 			continue;
 
 		hwq = ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+		if (!hwq)
+			continue;
 
 		if (force_compl) {
 			ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-- 
2.34.1

