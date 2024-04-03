Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964451514C5
	for <linux-scsi@vger.kernel.org>; Wed,  3 Apr 2024 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712150421; cv=none; b=bym/EyGCy0AS+E4cFaBwgzWveDInhs+wyH/2Ksq0Pe0s9+mZfqWbnO5YzM2N3w+5OPvV8K8p3XWW4tzN4NlYHw3zrPrj4Q3iUpW43VZ7/5BsZdkXKquqoq25wHvIct6EBggThgL5W9aKRvKZMhPA+vgiCI6SJvpf5MR6+/TZfZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712150421; c=relaxed/simple;
	bh=QMLyC7z7wrC4cQg2eqM+Dfe+kl12AbyhXTxgQxg+dJQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Isv3SwWIqJgB/WpmQPY70vBbXRCOlJPVvo8MBTUKhogaB7eM5fhICB8jl0sIHiz0gEj5Qe30ynPv4TxvPIo8tMizisB12s+6P2OX9XZ0sz1llm0IMPQE/tAN2c0l6G5FVsaE5sPhvmf8MPg1pkgtsHzpMsu0gyIYkSlZKTgtyQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iJ+YzJ1F; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iJ+YzJ1F"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6eaf1005fcaso3007801b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Apr 2024 06:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712150419; x=1712755219; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KwQhYX2Mz1rNOgNCjbLm4vj/pn57/J/0LzejU91ZMaQ=;
        b=iJ+YzJ1FnMTnDmmgSP+pBevtno1GL2cOETABb8IZDK3WtbxI2F5HAQNat8wZ0Z08Cj
         GlgfpFSI87gT5r9iV8b95Fn/8Jd83EfRVtuT49Ixsv8JhSQPz2WWWwWywoyUxBEET35n
         BHenb1XxJ/uD/tvhMScVHHbeHq3CNIZiuHHutjL8ro3pYV0EnBAf2g2EltTh7fPPqtZR
         abpg5hXaR0cJNVkD1ftYGKmu+qTKZa5PfackTYsD1FR0vpvCV/rgvCx2IMBbfQK6PlUK
         q+aJCV6jcocLsMaQxVLoE2pgd2roqIAj2XtyPARozxpFpeOorancxBXWXXUsHgxIZZ7t
         YXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712150419; x=1712755219;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KwQhYX2Mz1rNOgNCjbLm4vj/pn57/J/0LzejU91ZMaQ=;
        b=KS36B4xKHeje0Qu99bQlg7KRthtmHp94SXeQb8mlJU3CGPWe8TI2WptWuhsm/vhZnA
         VIirLUv76/gE3L+pzHKBFq4KOVUksYgSbmiYCYN8T/Sp6bGthVlujikaR4+ZDk7tzBl/
         DccbfYYLPuceOveao9BDp2Hrqj793QTC+Y7FJcv3NSu2EKgQrnGojyFXBicgDDVDmUHR
         +DcN3cAazEmDs/So9YA8RJYYr7fHF8GiXMKM+NFhGMLcCKBmKePXDKMYYRzjc63UNW9j
         Qwu61nwmxnuGXDaEHTM55J99ajZXMzoVZ2qLNCRv4ZJ0z7o73KwBstVV8HcP4VmpfF0r
         6g+g==
X-Forwarded-Encrypted: i=1; AJvYcCXQMQgev/fuPhLMoHKd3IaZgdF4tfdj2vyNAkqF1s0OW0o1e2WfzmFngwoqJuAyg6rQuRwhlRc3iitS23u+0hHisQ6FUfTtDT2xWg==
X-Gm-Message-State: AOJu0Yzer0kh+K5j+0erL533GOvNQLwj/oMM8LS8G5pIoANPTbiRGmiS
	uENqKkoAAlNU8Yyz/xe7L9uAUExEulUQG29TFGtemDMygLMNab6qspW+EdVAMU2HW8Ehz3PS8KY
	=
X-Google-Smtp-Source: AGHT+IGpQCGkn5PhcSonCc4+J0cwxJctvKaSt5maet/T2RTVHwqbp8l0HU6o47fJUh/H4LTbscQw3g==
X-Received: by 2002:a05:6a00:8e06:b0:6e6:8c49:f2f6 with SMTP id io6-20020a056a008e0600b006e68c49f2f6mr16252144pfb.24.1712150418636;
        Wed, 03 Apr 2024 06:20:18 -0700 (PDT)
Received: from [127.0.1.1] ([103.28.246.48])
        by smtp.gmail.com with ESMTPSA id r1-20020aa78441000000b006e69a142458sm11640518pfn.213.2024.04.03.06.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 06:20:18 -0700 (PDT)
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Date: Wed, 03 Apr 2024 18:50:04 +0530
Subject: [PATCH v2 2/2] scsi: ufs: qcom: Add sanity checks for gear/lane
 values during ICC scaling
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240403-ufs-icc-fix-v2-2-958412a5eb45@linaro.org>
References: <20240403-ufs-icc-fix-v2-0-958412a5eb45@linaro.org>
In-Reply-To: <20240403-ufs-icc-fix-v2-0-958412a5eb45@linaro.org>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konrad.dybcio@linaro.org>, 
 "James E.J. Bottomley" <jejb@linux.ibm.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=1242;
 i=manivannan.sadhasivam@linaro.org; h=from:subject:message-id;
 bh=QMLyC7z7wrC4cQg2eqM+Dfe+kl12AbyhXTxgQxg+dJQ=;
 b=owEBbQGS/pANAwAKAVWfEeb+kc71AcsmYgBmDVeJkgfnxTwqt6pwLJcFG/ywaqATm2PYnOmoZ
 8RiTomJs4KJATMEAAEKAB0WIQRnpUMqgUjL2KRYJ5dVnxHm/pHO9QUCZg1XiQAKCRBVnxHm/pHO
 9WqlCACHiwIXIUVyW6PYemRimdhM9VGxKicBAzA1Xm4P8Jt7Xrv2D/sBmrrRoQ2ogK400Qpg9/G
 zyg6R9fpCortdbyi1rWC8JVtgeZGaM1GB1XeDq6Mdrtjt2nO41OaktIhw+oqtfSotEyBJCw13jb
 ItvI64Qq6igYPNiMd5WdO9Imo0yJuVQJ9tPcknCAHmzzWqCDDg7HaO03OJEjQf+O4KoU2WS2AOs
 6pttNv6l5wDwvSzq19R1TG/eypF21m0hvxKRibAiKXO2TzqFtFndSI46tAIJd9zwxt3Kqx8pz/F
 bzI75lQksPSBnACjD+eg0zC78/FKcKIJFv622CeEIvRXX8nf
X-Developer-Key: i=manivannan.sadhasivam@linaro.org; a=openpgp;
 fpr=C668AEC3C3188E4C611465E7488550E901166008

Let's add the checks to warn the user if the ICC scaling is not supported
for the gear/lane values and also fallback to the max value if that's the
case.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 696540ca835e..79b4ce05f7c5 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -696,6 +696,16 @@ static struct __ufs_qcom_bw_table ufs_qcom_get_bw_table(struct ufs_qcom_host *ho
 	int gear = max_t(u32, p->gear_rx, p->gear_tx);
 	int lane = max_t(u32, p->lane_rx, p->lane_tx);
 
+	if (WARN_ONCE(gear > QCOM_UFS_MAX_GEAR,
+		      "ICC scaling for UFS Gear (%d) not supported. Using Gear (%d) bandwidth\n",
+		      gear, QCOM_UFS_MAX_GEAR))
+		gear = QCOM_UFS_MAX_GEAR;
+
+	if (WARN_ONCE(lane > QCOM_UFS_MAX_LANE,
+		      "ICC scaling for UFS Lane (%d) not supported. Using Lane (%d) bandwidth\n",
+		      lane, QCOM_UFS_MAX_LANE))
+		lane = QCOM_UFS_MAX_LANE;
+
 	if (ufshcd_is_hs_mode(p)) {
 		if (p->hs_rate == PA_HS_MODE_B)
 			return ufs_qcom_bw_table[MODE_HS_RB][gear][lane];

-- 
2.25.1

