Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA5F3446A6
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 15:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767714164; cv=none; b=rm2Pt21Xraqh2vurVo7RvI9JHPJ2Y/45u2txlPyHP68QaYgwXoItYwx3oWUGXCro9TCquDuK1hREpOonpN3pmacy1tMwQCEK2c9IZarDDWufiFt0ZUYkyt90PasU4FF9chZTeRp/3Kbh1V4onP/2CmFGMOptMRF73peBt5JiAeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767714164; c=relaxed/simple;
	bh=3LB0cITSfH4Noq7m1s58c2osN7yIye+Lx3PTEFp67co=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JWejS6EI7a01Z27gsQs1yLCtpx1m3u78uwlqI2uB8f++Tidnp8maJ5M3ltvwG1yOmksMiH+Zo8thC+qZ+9WwCXkB2Y+CwO4M+B91g4myVlndinS1YcDj8O7sPDmfqbcZBMF99LyWBQRsJnFO2RlbgD1ZRb1LKtxhqBPOAOS+LoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ePgiS/tZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ObIFVDXE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ePgiS/tZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ObIFVDXE"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606ASdDF2429680
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 15:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Mty9CPP7Jsu
	pHUVUgRA6WjTGLkSoSb22qlCPdm1xAOg=; b=ePgiS/tZBFbikeLjSU9HogSMWFk
	XlDRXeV1rtYk3U+ALiJtQPVKfC0Zc9yeNzS5ImKK3/s3mSFA27O7MceSlbbFvJsS
	sk/CvnISTKzDfOREzOgN8CA3OoFSVkCcYCE1nGl1BIxkHgHFCtFXwVSDcaqchprt
	bM9xJAkp22LNu2Q3B669WD6SC/7dyPD2tDk/yyeSa5h9LapK613dT2anMFgaXB1B
	Wlu7XTF0gpJL6vcuhM6K1yhKqEM9QvjsFRi1QLMk4npZ+Hsv0rC2j97CFUbqKiIC
	Z/9xUgVc55VzVYMExb8aNLzX707+6uUJvBBnFJ0kI14Y6JqpagTSKpYN80Q==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgr73ac3t-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 15:42:40 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a31087af17so32368605ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 07:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767714160; x=1768318960; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mty9CPP7JsupHUVUgRA6WjTGLkSoSb22qlCPdm1xAOg=;
        b=ObIFVDXE5WotAMVJ9dTW+rtkjRZSpMwo6C8vknKWlHYV8Q24cKXlbFt+x5gndseMbo
         JXDl5esnhv6kJbg74kguaTaqVZJQXXR16yxZ0wEkbi2V4VA21VEMglgu7UWJPNHUT8Xs
         ZBEYRDUNFJP8CpaSuCG71LJKn+vKMech5njisp2Ub7gE6py63VGpUcCnyILE6SGOoEk2
         /cAIQHMV21iGlbeTi6yKtO5CzqEf2Hb117TTSErADHLvUWrKkBfdKD67KT1yMbPhAsYs
         2sP/T8JVMHl8ijYvcrtVHpKmIi6uWzdFwuGsgUf6rx76ZAyczYxGkRZQ600x/yJlKTrs
         B1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767714160; x=1768318960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mty9CPP7JsupHUVUgRA6WjTGLkSoSb22qlCPdm1xAOg=;
        b=pVa9dYhFM3k5KfEfNhhCpQyPvV6h68zos5z5cHIQMoBtLPcQm8bppqeibMOHTR/9FA
         pAZjUKjYutpU4PJs4ghBmWnZ2kCrbgF2FSyEYjdR3OvoI/u5QvqMdh6MsPh+Bn5k5pRh
         2/OdQ5UYyasUMTZ9WZxjjdsmFnqq7eguXN0yesHTCbeUIx/8m2WrMbUVcIIavirfX5gW
         o9mF/Ct93WUOAw+38UpP8SPQrUioZARasYmT+J5s9C90sXkaTlhg3HFkWLhndUAySaNS
         gWGt9aSwyTojquL0wUKhNefcrmZGBBdVhWNnsgbKy3wbC6kU+GUlWhYXOuwcZ5tIQfXn
         Ydyw==
X-Forwarded-Encrypted: i=1; AJvYcCWZpIEaWgmsOlMV/V41W4kb2Vhkqct1pe54gxCfGvAtWyTOf+nk6zF8WUTQpAA11y5YPd1o8bK/IXsu@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9D9zFg42Gx7qG3u/PUBpDmZftnKr2t8oPv8aDsjhSDSLBJjYN
	79gso2lGP9NC3jhE6WSFNy3a/HFNzCs6W/wiwCeA5KXGMNZzV0P16bt2wZLnThPCJtmdtooOn51
	wNhIQ8ESGXr2sfCbfJd/SaRWKCjmGkEl1kcZQWsjbiJKhbU5eB7YBe8U8Q0CdRSqu
X-Gm-Gg: AY/fxX7lZ5Eh6kSJoU/SlznNVK4ttwKMHW6f3ENcViHXei4hoayTD2lJJMckdITcWZ7
	ewH+VcS2Fd/Idp3Afn4FSPJyIHYtnwxPSSrQrzisMW/I7Amt7nSOupHR7E7nv9KZCRErNgJOKJx
	gQrcvb0UI/++E1oY9QvlQwhXx2D36K3Xmhkvw9ndLzUFlCLKK5akS/Ubt4B+nzsIMC/2A8B7cb1
	mYYvvz5LcPcWa4GMWvpb1FTWRKUZyvDr4YOFtxYt3zdaq21bgbcIb/V8QAs3R+ddqL1xRMYbv6d
	SqB9hV0szsam61RV4ivYj8wsSdButSrmJByLxzH2/ykGpHx6Tc8kcRCeJmOGmp9TZOXJeUm8Glg
	KdPG/IsjF+Suv1QRRoK7+x8060Iw7RT1voPMnXd8H+2gvII3wwsxX
X-Received: by 2002:a17:902:c40f:b0:2a0:c5b6:67de with SMTP id d9443c01a7336-2a3e2e1e671mr35426915ad.52.1767714159731;
        Tue, 06 Jan 2026 07:42:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG667pmkGDth+EgwS5JLYw269C1+n+LtMnapVQaOfdQaxrvpwZx4BYdJ10YbUoQ+a3wnQQjaA==
X-Received: by 2002:a17:902:c40f:b0:2a0:c5b6:67de with SMTP id d9443c01a7336-2a3e2e1e671mr35426545ad.52.1767714159218;
        Tue, 06 Jan 2026 07:42:39 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cd492esm26606395ad.98.2026.01.06.07.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 07:42:38 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH V4 4/4] arm64: dts: qcom: hamoa-iot-evk: Enable UFS
Date: Tue,  6 Jan 2026 21:12:07 +0530
Message-Id: <20260106154207.1871487-5-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20260106154207.1871487-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=QrxTHFyd c=1 sm=1 tr=0 ts=695d2d70 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=cMKPt8sKVRzp0kMMbBYA:9 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: dovGYOWSjWn2-U5kw_SD54KMt9P-xlb5
X-Proofpoint-GUID: dovGYOWSjWn2-U5kw_SD54KMt9P-xlb5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzNiBTYWx0ZWRfXxRSkSlSIL522
 AGcenWDKL5oGjbI0I/5oGwJ1Zo/wHc+GSX8X18Mwj6BMRkqOCzy+5iyh//QqgMnL0dTP7NgdigQ
 hfxq/nhZdc0k1C6loNvSzElto3lVUVfePSF0qh+owpCOFJIfjSHaKiprENWdmj6L6muMSBgUUd2
 1Yd3fxoHM1fAUNsd/7CH+xoVaulWnEYppvf0rDUpyxRd4Om8kerCA3Nwvwtbl8biHLKwHIAeR8y
 IIfuvrIdMDNgnDw+JDYKiOkIVosAd7z0UubBeD/3qSm093opH34kV+VxGwdLKomTcRw7vV8csRa
 hL/u4FpSavqWkG2LjGKwz/w9190ZAShX/mDBrtXbTOeSUiLW5IZTG17J9wLoYdkaXbMWXDWgUzK
 It5FVw5eFziIXElkDX5d6tBD5RTySQZguZZSqVwyvHHVtYsbQtmC11/kdEwV/G4jArsTXtzKfos
 EDwBVMCGT+gQ3Ku82og==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 adultscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060136

Enable UFS for HAMOA-IOT-EVK board.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index 88e3e7bed998..23cd913b05f5 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -1253,6 +1253,24 @@ &uart21 {
 	status = "okay";
 };
 
+&ufs_mem_phy {
+	vdda-phy-supply = <&vreg_l3i_0p8>;
+	vdda-pll-supply = <&vreg_l3e_1p2>;
+
+	status = "okay";
+};
+
+&ufs_mem_hc {
+	reset-gpios = <&tlmm 238 GPIO_ACTIVE_LOW>;
+
+	vcc-supply = <&vreg_l17b_2p5>;
+	vcc-max-microamp = <1300000>;
+	vccq-supply = <&vreg_l2i_1p2>;
+	vccq-max-microamp = <1200000>;
+
+	status = "okay";
+};
+
 &usb_1_ss0_dwc3_hs {
 	remote-endpoint = <&pmic_glink_ss0_hs_in>;
 };
-- 
2.34.1

