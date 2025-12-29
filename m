Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD49239E9B
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766988457; cv=none; b=ldnQks+eW69jqxHQ9dLrsYK3ZX9RkDkc+6AhAl8AOTQOUs9XciRaxp4Vbd1lGTIoEQGCQs6Tg+iHlekKaXWs0VbRPrLW9USvB9F+A+C0NAMpeZGJZW21XyfZvJokKgXKVAY/+N6RuXfDixp4rtU1IXwHRSekafE+HOJDDyXfrto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766988457; c=relaxed/simple;
	bh=jJ6O5KkP658Kzoen1OLLHGHGjbrUHLY0oOPUXGr5BJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i3HazHw2CI6HP/mmSfAyzrKtw8UVcjwLoco8sYrh8POJP5e4KqzFYFFJ1l/zAZryvBdDipnKHbMygpWqJhk5S39+mgDRgGCNLFDM23sZXyuGAwZ9VgR+NA1mEIt94chiwQ/ruvtQHeZsjz+JJCzo4d1t0tpdtkai+rWOGGL6RSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Bv5EslXF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A613eNB8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Bv5EslXF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A613eNB8"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BSMgqsH211639
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=nzPReENl5jq
	P24RO4wk7cW8ZGHbcPiBK7hn8rIfW3pc=; b=Bv5EslXFCEeuAeS06DXCssX9aNc
	riVB7rXm0LP3DTP23mWH+PKJX9TCmMiSFfOEtnRHhuEsTUrbGydISujaG1/kYd3M
	yvSCNGTh9Rl+xH2N9gWq1KRFh8vyutEL+m6AV66Klgxz+KQs5kczI76EOsNLWNlW
	U9UimqgTh0JAa9HIdwfJSHlIE/2rnnDvphT8EgmSsJ8/MhDWsYBg+u1A6XyYoD9W
	VAlx5V5mnmkzqpdaPXN207s6mLxLR6DDLQh4w759YqNtnLCPI34dxrSfKYr8Rh69
	bJUcF3cKu9Z49q6FwT8YyT67BMoWxpB2FmIUjky9tg6VYLqqOOVLZjGxw3g==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bbc9v0ry9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 29 Dec 2025 06:07:33 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7ba92341f38so9781713b3a.0
        for <linux-scsi@vger.kernel.org>; Sun, 28 Dec 2025 22:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1766988453; x=1767593253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzPReENl5jqP24RO4wk7cW8ZGHbcPiBK7hn8rIfW3pc=;
        b=A613eNB8qmYlRA4FkJ+f0tcg9epPigD8M1axR6GXMfcGFS1UPDxJYWVeaHUilIAkdW
         9WMiULY7FMOdJl0/d13FALiEEqk0VUDxD4RhL+QtTwmtO5+mTopJrAhENRDTbrJ7XNEJ
         oP1vsHid0m2Hkykgnr54YyLkvSk3h/DYO4lq/FCySap1dlumouDgNEVMXYIiTxtAzt74
         VVQ1fdKW1JAA2uCyiyOZKaJuetOOrj5RlWtIlWAkhuvyJUBVSD5vEwVpa/tFc2Bl5P/e
         pVqD54hn0dRj2M58vNgELljOakf/uADZ84jVOFYsR2xIcgnX5gXvjvfrZNYVbXbPwFIZ
         lC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766988453; x=1767593253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nzPReENl5jqP24RO4wk7cW8ZGHbcPiBK7hn8rIfW3pc=;
        b=RYVDb/xWs8QienVCh/yaEDi9OZWrNzuINxd8bYDMRb0WcbI1Q1jJB/K6ZsOPCPtVmE
         V9qyamoJLpqv3B+yDQ8JNxz4+tH/a1g5E1F9lDAP7ZcOmAQkMR13s2MH8jCt+bgI31sM
         Y9NC+b0umPUYBzbKeV+zHG/cdFZrAza+aW5t4Ozb4qBjMGxQjbiXWuRVkzbZLZCgdS/d
         U8s9mwXCK1Kt3tt+kX+IzyBhAY+bFXG4DBmwmkW+JpFWUwNgdec8yH/BZxb1JncMdOn2
         M+VPkphtLqV7TAqTsLtKgX7qONvctELYtvROCg+4V+ijtd3/Q50Wp/wbzUaTjIz7bXAe
         67Jg==
X-Forwarded-Encrypted: i=1; AJvYcCXTJOKcZeS/Acbmsc8Cc9sC5rW5N/G6USQPLhKWu/nphU9Db20609VyyCS2Uth9PwD+pSUDVwK+olZC@vger.kernel.org
X-Gm-Message-State: AOJu0YyQhRIQBT277Q8sSSbVMJDUZYLx1Wv0IyMeCO7PuRK9LNcfXyoo
	HkjxJmWvp7fNTDiyIJg8/DQHZI2r9tsc1D8+7ix56vyqXCwS+tK3CgdY4pPofw3/MRmnuEkfD24
	Zsf0eu/sGx110NuxhqFelUFr53QO5zTWN/Gm6u0frsMxz48J4Z1TA5JB4H5XMzFd1
X-Gm-Gg: AY/fxX4HO+FtE601WO6gEwsbOJu8aBAgjmH8L2PeGT+Js5Pd1xveUwdp+2uwl+My3ty
	OByD8zBUIzsYJqNAESuNbQckN6Sl66kypJp1RhioP+TTRf7q0CnQVNaIvVTTO5C227RyDyUabzS
	Mf+FVHTWDoLRuH/GoQnxGrvJHy9fRmPYJcUeTNQ6ZLbf9NVRCqx8UqtwdjeGTUyAtD5Kho0hSwo
	q5vvXQzzFJHtFOXN5mQRHdn4D8bvcVQSv2EktBkSlG/C8Uvk4n9dF0FcitEjuDgrdFOg4DVWGKy
	rMvw7hPkaYybEdDOhn3yZasK//1Ib8SuA4K3O1hkXVJc5i7NzWdR0csfB4WQbXoryFVrRU6TZXF
	gU1sE2ETdsexteQiG44FI4A2rSVSzZ9shZyCopzfS1AnnigUuagNb
X-Received: by 2002:a05:6a00:1d14:b0:7e8:43f5:bd44 with SMTP id d2e1a72fcca58-7ff6725797emr27629166b3a.48.1766988452951;
        Sun, 28 Dec 2025 22:07:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFJ4QM4VdGN93Y3u+R4lE5nFnhu3cRd1IzjpC/9WxyY5qv/m4PWqlReb+ZwjHBPOzexW/VaCg==
X-Received: by 2002:a05:6a00:1d14:b0:7e8:43f5:bd44 with SMTP id d2e1a72fcca58-7ff6725797emr27629148b3a.48.1766988452500;
        Sun, 28 Dec 2025 22:07:32 -0800 (PST)
Received: from hu-pragalla-hyd.qualcomm.com ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e8947a1sm27917763b3a.67.2025.12.28.22.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 22:07:32 -0800 (PST)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Subject: [PATCH V1 4/4] arm64: dts: qcom: hamoa-iot-evk: Enable UFS
Date: Mon, 29 Dec 2025 11:36:42 +0530
Message-Id: <20251229060642.2807165-5-pradeep.pragallapati@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: _SIh4vT4OFZpYYYlaFHkwEYdJ66rMADY
X-Authority-Analysis: v=2.4 cv=R/sO2NRX c=1 sm=1 tr=0 ts=69521aa5 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=FwCcbryfLnLJMkbT1zkA:9 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDA1NCBTYWx0ZWRfX//tpdMwo6RPA
 YCRh7cPguwdjgHTiNuEXvZzclzRb95wfeXu+2h5LM/7VoETqgDg7E5fxvmT26VELbGuxAgQhlsa
 /sb9rq53pcs4hPWhrL41swoOXjrqgj3/V1q0XR+kSOG6kZJCNl8WJGInf5DF89g4yMbCUTHrFbb
 G6EuSqAn5WeimOB9UXEEli3XvdDbBTgozvxhYff7BHMtvTIQw2uxpqCSXQ/5b5d2pJ0tR1HhqDX
 aUJxEyvt5GZBKny6lBxzKC/fGdu7JwtbBjUA737El9mhxdGm9TOqmiDOd0T8Mb2IzMTBd1YILRm
 KpBJHjMeHnv35i3kSVDGuSm/uUk5hUawhQn2Gi5OxYAYYTpDb6820QsjRBUCMZIXzWGp2KAsaze
 vUiEhAJyjw0VCLQfUkpXP1F+VvhpRcQ6MykZPhpjHjdgD50Es1NHPBtSQZxaKdfDiKhAPG/iU/3
 +SBXTziqW2RdI23vtOQ==
X-Proofpoint-ORIG-GUID: _SIh4vT4OFZpYYYlaFHkwEYdJ66rMADY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_01,2025-12-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 adultscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512290054

Enable UFS for HAMOA-IOT-EVK board.

Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
index 36dd6599402b..2b1e643975d9 100644
--- a/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
+++ b/arch/arm64/boot/dts/qcom/hamoa-iot-evk.dts
@@ -1190,6 +1190,24 @@ &uart21 {
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

