Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3716D3469F8
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2026 14:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767624436; cv=none; b=Qj4BZ4TDTwPzyaIRgp6qd3A4tNflNiUsRCUII/9Q3OdXReXqF04k5YT9WLU8fIKIJdzWzkibhJ6YQolSUGQ/O1+vXaX7QVyep7BOtTmIOmXK3PB7qbTcC21X+ncvVIkMvdcNuYwOlcoQIBBjQOeIWRJ91RPot+85esGaKiLRbfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767624436; c=relaxed/simple;
	bh=0/49bV7xcWqrx+PER+pNr4EOl5y9jYDTYIF1B5vedJI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sxzn50C+LVue5QeV0lvMpp5UkTqiAa0M7gEUWxQ4fsGv6Z8Wngh62Wp0VvEpiq6EWIql/6buDK7uIorYjebkAg8UN/jKp8IVZX8woPFF7gz5XupzWmZnGGd3QZcjzHkjIzZBGoeAOFaLwXd5Avx7cmjs9nzcpfq6hnw7hBFL3AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Qf+inBUR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YAc8h7lz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Qf+inBUR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YAc8h7lz"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 605Bxxr33520992
	for <linux-scsi@vger.kernel.org>; Mon, 5 Jan 2026 14:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=JL9j8lRAbIP
	3UrbUnDDXBBLQaw+rdcjrIyfR5u1zqHA=; b=Qf+inBUR0kFomEu0Bkh0Ab4lDyB
	y1LMAEysQYWehe1ZdZbPSULtPU6EUp1JkyO43JHYjePhF2ozRKtUwezxCosRy/EO
	I6G0/1RflZeuIzImTgwKNUoeAwAHVOW0KinhoZR9U1fCyVWh8uDj0ZrrmRJ4iD7R
	kFLE0ZsqWrSf9uM/kh1jofH7y2M470MpKzSKjyQmtjU0jVvCqoSlfldHNeftsGRZ
	ESvTzor8v9F46pXwfCknhK0IEpET4DwS/0g1QujUfS7PgawFuVQJlmwRQqnnZ9ly
	rf89T/9Lm//ZJ9C7/1pxoW7ks3aDtuHQqRVOHciXIWInZuGfsx9OUHklgBg==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bg6uu9jm8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 14:47:11 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso59701a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Jan 2026 06:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767624430; x=1768229230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JL9j8lRAbIP3UrbUnDDXBBLQaw+rdcjrIyfR5u1zqHA=;
        b=YAc8h7lzp20BaAgAHkRG9wicnhnfBuoc+6Y5dYTQLc/DJigU+RajWLRoCejpI8wm0v
         V3wBk8lRTGenK2L7rBhmrsn1zPmmYixrkaznWhi2bHdg44x7kvMGjd9Q+not30NSqGhn
         69t2N3d3j9zVWBRnmgRkgXoHOEvL4fPHQUbOgBjGZWUcifVd99naGVvRJDRaWassMkQ7
         N9LdIFiW8NeqAWK3Bu2pAQB6ucG7uns/MLwxFxsOigCrNCBJ/QqQmvGJH6d9hqTOKUQ7
         1dt8syMPIBJYY1qxPJsyFZiIhhqLQGpQE4gfbui/IQ+bBmMk5slqWNuouy0+0BZt2JE0
         dTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767624430; x=1768229230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JL9j8lRAbIP3UrbUnDDXBBLQaw+rdcjrIyfR5u1zqHA=;
        b=T46BM1IX7p4k0dHDidem2kn9hBdgG+yhqoIQq4OgNMN60/kBuaUddPP1BogMto76+G
         xiOl3Pwj3K+3kyoPjzfcDFb3m6h8/RoTL9WLem2ENkk1+Ik4jeP5Q5GaBWujHKIgvO7S
         PUI9s+KhqheEMufLT4jZ02KZXWRkfxNY/1dxS5MsdSlYLjF83hAXueb/2FuJsqQfwozX
         wdQe7HpYNbNgiH+GKfEPrtUHutUK6K4e+zWq7t0vPiOQ9iJsoYq/sjbS+thM5oFoue10
         OrfELr1R+6IK/44njSDn/U3cMvTY9OpnX+FFWH7A4tniMb0QLwfwPRX6Xy2CbwgGVYqL
         pHiA==
X-Forwarded-Encrypted: i=1; AJvYcCXXxWdFhgiTGngRkFdLdsQY5IbRhSUNf019b1gG2Y57Wr57cPROyizLEZ0LxXh6/QbLYtHa8ok7rW6Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyjG1tP9YruDZ3SsK8Xt25s012t9w6J4v3LzZUbCzJJSIHF3LSM
	bQY+1c/iJQGykXI+3ww0yQ4YEuozjrCsVbmgm/K9qW6nUWvkek/Ty3SrMs/Jgz/yN8QrmJ7xKT7
	OBJ5kxO1kO2SWYLDHfyVJYU5P5Wo9rpBeRNEgmKv8BTdBfAgmpphO3mNU4YVcTqMx
X-Gm-Gg: AY/fxX6PRB6KkXkPx0Cj1WbZbBNk42WJGpgQ2fnxs86tdy0qYMQDqip/MQsq2cQgQwD
	Sa3XFoH2ip1egby0QiO1N6PX2fatP1t852Ji20znOpAvfknXRttKi117OrmXxajzdwBeXJe0Fl+
	UvqdpMMFkm+o3YEtLI18uJ+60rWNXIWzSu/Hn+7a09Hauisj1EfYZKkJawK1IEMEpKzriIc9f2y
	c/fWIpo87x1Y6KcXeL7HGTyWeJCKzx1VND48vSAxFcFgUZP6U/2ksARIdTx1m8F3YAYtnpyMjhX
	XLpuPQRH5d/NXdo/PgV4+mqmEfXWAC3yaC6dSzf1CbQSlT9kd7Eq+mRkJf4DjHtYAH6ofbl8p/a
	th0wUyDvrJbWqgIWSj8/VylDM9SdJ+ssJcageMn41GjgNzaiox26Y
X-Received: by 2002:a17:90b:1346:b0:34a:8c77:d386 with SMTP id 98e67ed59e1d1-34e92139a88mr40066110a91.9.1767624430164;
        Mon, 05 Jan 2026 06:47:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHYO4fyY/NKZqP522dc4OZGpMKPzWFprBwP1/RIUeyvYF9tNegohUl3Ei5e98Hahvi876HNPw==
X-Received: by 2002:a17:90b:1346:b0:34a:8c77:d386 with SMTP id 98e67ed59e1d1-34e92139a88mr40066079a91.9.1767624429411;
        Mon, 05 Jan 2026 06:47:09 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f476ec311sm6634868a91.4.2026.01.05.06.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 06:47:08 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH V3 2/4] dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC compatible for x1e80100
Date: Mon,  5 Jan 2026 20:16:41 +0530
Message-Id: <20260105144643.669344-3-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEyOSBTYWx0ZWRfX6lHHir/BHCuv
 Lc7LIXxIhYiCJvHDmXMDrPHZ5XadYAeWX2QmW2Z3ea26sodPQgIrBRMBPKjPw5EJhsUPODt5tQo
 0AMdtA18geQryqYgg8ZqU57tiGx0tZeeCKQ2N48iG5xAWkgggQ5FK3w+wiIsYnJ67qZ9bORxVSY
 E4dRgVqSyNvkgHcIfWqdw/V0N7EOx0fp+WqjGWH1KcTOhLAlYV8kbsqolUHWPW02zarrefp9jyI
 Lwrqesihvl3oLqz38AwUrkYrXvG/WcvKAn8/dE0+FmXJqxe67Q+9dB2w7x2+znLvWeNJFk+r3gS
 4GRkR2lFXA8lV8Z6R8bJVc9t/Rvfg3zzNb9GF2Mzjz43Xlx4f2vyaY7eH85L37/b6W66gohKUw1
 6WjYvZI7A+eK3mfxIYLMwy+GV6h8wKYEDNVTJ/Rz+ZzlV9xFb6o7ZilXtRgs8T44bCXIcNQkE16
 0Rj1wEJK4asEdDSo98w==
X-Authority-Analysis: v=2.4 cv=eZ8wvrEH c=1 sm=1 tr=0 ts=695bceef cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=YpgvqVHoR88ruzM84CIA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: yf7YCvRBjVAe1PbJ5dsOmC7yqav33Dw2
X-Proofpoint-ORIG-GUID: yf7YCvRBjVAe1PbJ5dsOmC7yqav33Dw2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 phishscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601050129

Add UFS Host Controller (UFSHC) compatible for x1e80100 SoC. Use
SM8550 as a fallback since x1e80100 is fully compatible with it.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 .../bindings/ufs/qcom,sc7180-ufshc.yaml       | 37 +++++++++++--------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
index d94ef4e6b85a..c1085d178421 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
@@ -31,21 +31,28 @@ select:
 
 properties:
   compatible:
-    items:
-      - enum:
-          - qcom,msm8998-ufshc
-          - qcom,qcs8300-ufshc
-          - qcom,sa8775p-ufshc
-          - qcom,sc7180-ufshc
-          - qcom,sc7280-ufshc
-          - qcom,sc8180x-ufshc
-          - qcom,sc8280xp-ufshc
-          - qcom,sm8250-ufshc
-          - qcom,sm8350-ufshc
-          - qcom,sm8450-ufshc
-          - qcom,sm8550-ufshc
-      - const: qcom,ufshc
-      - const: jedec,ufs-2.0
+    oneOf:
+      - items:
+          - enum:
+              - qcom,x1e80100-ufshc
+          - const: qcom,sm8550-ufshc
+          - const: qcom,ufshc
+          - const: jedec,ufs-2.0
+      - items:
+          - enum:
+              - qcom,msm8998-ufshc
+              - qcom,qcs8300-ufshc
+              - qcom,sa8775p-ufshc
+              - qcom,sc7180-ufshc
+              - qcom,sc7280-ufshc
+              - qcom,sc8180x-ufshc
+              - qcom,sc8280xp-ufshc
+              - qcom,sm8250-ufshc
+              - qcom,sm8350-ufshc
+              - qcom,sm8450-ufshc
+              - qcom,sm8550-ufshc
+          - const: qcom,ufshc
+          - const: jedec,ufs-2.0
 
   reg:
     maxItems: 1
-- 
2.34.1

