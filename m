Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEF923185D
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 22:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762467353; cv=none; b=inouuve0lCwk1jev88lf6Kw50oMOfCm0lcWWFFZCmAi9xwVOMD/yYc384SF+KjsK1gmSGgnEmFsQFf3y2FXtuASEkfnAH1fEphFsYUGmP+cBbXHVhfJ/0BirlQp8QXWTeQ5e2Ed6SPRvZ+iwcMRiT3HrSn19jZ5I0f2FN5EfmMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762467353; c=relaxed/simple;
	bh=J21PxH6s6ZEijOdrD4BDJiRoVH1TP6PzubN1rb/RiHI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hwsYp67621CtIWMTobMiuK8/k6SUSY/v1+gbU6S8iKOMYFliCrQhGXcsvU+ssQWjBK6iN4ovOpM6UvH08Ewq/lqXJhzXB7yz0Hi70dw1E46d6cA/9paWk4aCkUCyidx9N60Txx8T85V3D6+OF0wNgR+wTJUFHWymxm21A9Hx70g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bj8zhMMr; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bj8zhMMr"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso143372b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 14:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762467351; x=1763072151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IHa1X2TU+BSGB7/ATLdTMXTc2axV7rYHmYrgV4H8Ooc=;
        b=bj8zhMMrN+oEwo31ehjzFlHpZ6k7EmIOo0LElm10gHrkOlIDNi0VsFmBjXD0zAHnbA
         t7gh0LIRN25tzLlO3Yg1F9ZMh5PnVH9GVEBAJg3LWZX4NC0NbVWa/3Sv4Yrx1Ql7wyD9
         Vbd/cGoY435RKn5Yv/pODVMy64TIXXQkmpCvlixXJfJK1z+7yoN7BAnDR6LBPVJsX6cL
         6XhewdtV8spWlp28YhZVakVexzTRFrtOfuyA8bjgfLbv/f2B0m5YxieFYGEOh4rB8sLh
         hubezwHBmfG01IUuk7Bi1GIcw8rpxgtxNxrdnYsKKaaSG3JhsCS+63Zp/58/rVb6YLBG
         Wn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762467351; x=1763072151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IHa1X2TU+BSGB7/ATLdTMXTc2axV7rYHmYrgV4H8Ooc=;
        b=lt0opvlbRkzOT346kVnTOtJjPlc0cmD0wEdahd5Gpa3R1+cPbS7TCgrALI0M89wPHC
         uYsuFvKRHsQDpQ6HbZ7xEBLUOpAYVW5caiPf3q760kQjopWKfvyh9fzTSGPHOF0W24li
         g6QL3XL6ND84swT+ktyBpjIZRtgp9CrEJQpSnhnAuBFJoovq5VKzPeY1m8akO+bT5fMu
         IZSQfi0O0WdFZs2XxwDSTEwyAVrwp/8H6t0FRGlYVDYPkc7XX5seUpYgYIxwmrC1TE37
         XkG9qxc4OPhJXJjRI23Z09tuFK1GZfVahXYlupEW0skLlcWfArok0de0GrjvgHbIGIZi
         UNyw==
X-Gm-Message-State: AOJu0Yw9gIQAWZeXltno2m8oD+X2+nKkPZltITwXvNdJBTs4EaMtqe94
	5mBJH09y4IULAKBScR4PEVxoXaGn1EKQ5GSL5qr+2XGA3OVk6uwLf/BnrUf19s2S
X-Gm-Gg: ASbGncvboHA3CLAUvafDrXclPQwmu5S/NSI0ysP/Xmta4onnjrafIFfZZyVjO/HoLRC
	ZIvBGcB9habP+3gJXLVXplYV8tk+p2bn1bPI8sx2e8qXUrPVFsEg+2XjPqzTdY6wNmB1BT7ZvVM
	LhMJDnkABMJ/POGcXuQWuQYWdo0WD/VOw0odc3V2cdnW4NioSKoUIRH4SgIChGwAtQoFCCiQ5cd
	WieiuAgEz0dQtjMXw7dXiepw9xGxb3xRuzyqvtmmN9MLwXbew3Id+Bl40WdM5h0qpbXbfB1Vvgl
	5ka0k2aikUNPOxThgd1IhpIzH9vcXWAhCijtucW6DzWpsbjv4nKw7NF+fB4nRVQlBYpmeu9PAcC
	uwXnIwY5yXDIWjeUPteEuiH1Gscv5lbdMFItzkMKAn8U0f50CSMxm8OJ4z7/jzqpqxgE7BdUNiP
	AJC8qUcyV1bHKx/Szf3i9jlXEIS3pfzFts6ldUFd/agp55xHltF8DPMI3sQWM6T46t4Rm4uQI=
X-Google-Smtp-Source: AGHT+IH61mbm4+9pdfSt9Uc8sK1I8uRItLqIQLwIJLLOZr2rhn13GpRdMuaCIC68Me+4Sz5wn5cggA==
X-Received: by 2002:a05:6a00:1706:b0:77f:4b9b:8c34 with SMTP id d2e1a72fcca58-7b0bdd71fadmr1417638b3a.31.1762467351117;
        Thu, 06 Nov 2025 14:15:51 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccc59de7sm568901b3a.65.2025.11.06.14.15.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Nov 2025 14:15:50 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 08/10] lpfc: Allow support for BB credit recovery in point-to-point topology
Date: Thu,  6 Nov 2025 14:46:37 -0800
Message-Id: <20251106224639.139176-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20251106224639.139176-1-justintee8345@gmail.com>
References: <20251106224639.139176-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, BB credit recovery is excluded to fabric topology mode.  This
patch allows setting of BB_SC_N in PLOGIs and PLOGI_ACCs when in
point-to-point mode so that BB credit recovery can operate in
point-to-point topology as well.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0045c1e29619..b066ba83ce87 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2279,7 +2279,8 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 
 	sp->cmn.valid_vendor_ver_level = 0;
 	memset(sp->un.vendorVersion, 0, sizeof(sp->un.vendorVersion));
-	sp->cmn.bbRcvSizeMsb &= 0xF;
+	if (!test_bit(FC_PT2PT, &vport->fc_flag))
+		sp->cmn.bbRcvSizeMsb &= 0xF;
 
 	/* Check if the destination port supports VMID */
 	ndlp->vmid_support = 0;
@@ -5670,7 +5671,8 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			sp->cmn.valid_vendor_ver_level = 0;
 			memset(sp->un.vendorVersion, 0,
 			       sizeof(sp->un.vendorVersion));
-			sp->cmn.bbRcvSizeMsb &= 0xF;
+			if (!test_bit(FC_PT2PT, &vport->fc_flag))
+				sp->cmn.bbRcvSizeMsb &= 0xF;
 
 			/* If our firmware supports this feature, convey that
 			 * info to the target using the vendor specific field.
-- 
2.38.0

