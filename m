Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4DB1F9EC1
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 20:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743108910; cv=none; b=F/h/LXatfkYCH+M87HUJL/tQtuYT9lm2gc3+zwe8eo1F4U71epxuWKUZ58+pJunhcxENT4hGY76TldyBon1y15Zd/54H0d9eMFVLtiC+rciM7ux0sTR+MHM5mwpOxrTmMzqbz4gnjF6oH3BAKynpZT0pEat2203Rfu5AOu9IHJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743108910; c=relaxed/simple;
	bh=JCGsJhs2SdD98uzBuqAjuVdnbspv67Sf05zG+7tanQA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XpWnqG1FZNfXwCJ0SIqnvxaindnHiEjHAnIEDiJkAjmVWYMvdwRmX/Ih8E99+PYt8HzOrbEqudrRGCvXH38vd2GOXjWgnvXgAD8o/Q7nEAQZsbgI2jFXHc3Fpe6gXslfqvea+7GC73O7lSPzg5WamZPRYUb7Z9PXT3r3qEK/iYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W+w2mFpp; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W+w2mFpp"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52REhUhF010916
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 20:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Fcdg1VAc7ndOycsxLya+Oon4ZP22hM8HpfAoB386QYY=; b=W+w2mFppuL8VrkT9
	HYG26zp0j2NxqlqlgUtCOF1jx9KDBWwgxtcNGigOHRx29u6lnl1KJpkbKPJOEdb4
	6HtHJ5IVee6QZliwgdP9rv364TZbkktJA6BEtvhVwgWL4x+2BvhGJIa1xkMV6JND
	ODNV95L1zcPECqrAz/1bQtPO2fHAYkNHT3Un6b+gC0XJLDzmB/t72bee/4PVu1+J
	0ZMr9cJQcWKVLV7XufdfRfTIjrspPmJ33+Aquk2lb/lMQ43wPOr61rImGH1laBps
	EKt+/qHCtgISO552F9p62pO8gKeGFSn06LiUmDo90G3IZ1Ta5VaJRBAQr7rTWkiA
	oq4dzw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45n0kqjepr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 20:55:06 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-22406ee0243so20639375ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2025 13:55:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743108905; x=1743713705;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fcdg1VAc7ndOycsxLya+Oon4ZP22hM8HpfAoB386QYY=;
        b=RSmhC2aDMxqh1YataNSc1cWqxGemQN7W9Os5TnB3JivVuYzoBaAbgIMay7JTYf5aWK
         SjUCreX2PQ5oxbqgwSkxy+1mlSfHeQDkbu3yifwtwHl18MsPou6OHGduKXgRzrI0Zpql
         Yh/tB+BNtQvd9kULX70b9gIg8lAyKp1hn/MnnK7l3d3wZMjXqSTUTuJUBctw0/jOsFuH
         cqgc5HPtLAt2HeeqPcN5OsQCWntvbzT4kNl/WimQa60fXGuooYvrw68MZ1ypPvM/Hvra
         ubsYnB80+hhOodBMxr5HlWEDH93vUTo+UgNFxDzlo0VRMsNxbaNTiDe6FTZpm8jiQUFO
         K4ng==
X-Forwarded-Encrypted: i=1; AJvYcCXbmtBWrk+KuCqDNuxp4qbkzLzsWmaqoyr8VbzMQJYvMRYqnUP+OF8Un+1bnJRrWfY+eArkIQI+x6/n@vger.kernel.org
X-Gm-Message-State: AOJu0YxyinHvi7z4KoPmfUC5by+xO6IUFvziYH7VakychzynWKTkJ7a+
	4epwTxI0dyuFV23NzxfdvVlYvoUk2uA4o4erN+jtFbbEx4aljok13clmkDO/HXQGlzo3LqRdgAD
	fgq2mftSoXFHUO879g/0IhbZsSd82v80L7+GCx+KrIrtudie69dbHbG60rgoB
X-Gm-Gg: ASbGnctTPwEoDzJDQ0Fn/gBuDcknu0KqP2yRE+XQr5WCpP9KuErB1cX0pPdr6gF+rS4
	Yl9dGMK6j/TkFQqUFxPqMO0xbv+EK0RINwDmbG2r6Byk2DnQ6vz3GE68EcboQs75mdfGoS9k3iF
	nwAeWTiYFOLJ3rGqgPzxj7cmkOJl2Y1der22B5oyS3yJ31pwx1V0SPseewL1kSyKCiqj4Vbv60R
	C56Afi/mXQyQJ3l8Wd+lU2VBvHIn6PcA1WJlIenlqbRgGVgL5/yF7vqYPWWIyli4f3iEKu4NnAS
	Fzms/IWV5H+ZoNqpBdmZ0yrxZ8JKvwRYQLOXqch0vlXivGR+A6/SNOM8uL8PZHWYOoV1yZM=
X-Received: by 2002:a05:6a00:848:b0:736:ab48:3823 with SMTP id d2e1a72fcca58-73960e0fb47mr6484350b3a.1.1743108905432;
        Thu, 27 Mar 2025 13:55:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEnkJJIMtRyqYK/2XjsY392pqaxRnmSP47y/7BPqGi6PK3Q/ePcfNg+0eDau5s9cq3RkRCoA==
X-Received: by 2002:a05:6a00:848:b0:736:ab48:3823 with SMTP id d2e1a72fcca58-73960e0fb47mr6484305b3a.1.1743108904909;
        Thu, 27 Mar 2025 13:55:04 -0700 (PDT)
Received: from hu-molvera-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af93ba10da3sm330889a12.66.2025.03.27.13.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 13:55:04 -0700 (PDT)
From: Melody Olvera <melody.olvera@oss.qualcomm.com>
Date: Thu, 27 Mar 2025 13:54:31 -0700
Subject: [PATCH v3 4/4] arm64: dts: qcom: sm8750: Add UFS nodes for SM8750
 QRD board
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250327-sm8750_ufs_master-v3-4-bad1f5398d0a@oss.qualcomm.com>
References: <20250327-sm8750_ufs_master-v3-0-bad1f5398d0a@oss.qualcomm.com>
In-Reply-To: <20250327-sm8750_ufs_master-v3-0-bad1f5398d0a@oss.qualcomm.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Manish Pandey <quic_mapa@quicinc.com>,
        Melody Olvera <melody.olvera@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1743108898; l=1323;
 i=melody.olvera@oss.qualcomm.com; s=20241204; h=from:subject:message-id;
 bh=ihtCyJmMmitRot9saRcjMZSy+hpwYazvZIqBi+G/4wg=;
 b=IDJhIzbndFSOx87EYr1g2L25zIqku3UnkqGVLM/TErGUoJU79zC+CXmGHBN/uF8+henbwcJQy
 7eIMRcJVA5RA4quh1i3Zrlo60wWo60V6R0GJKNKoWIXc/GAWA41gUu4
X-Developer-Key: i=melody.olvera@oss.qualcomm.com; a=ed25519;
 pk=1DGLp3zVYsHAWipMaNZZTHR321e8xK52C9vuAoeca5c=
X-Proofpoint-ORIG-GUID: 4N86sgh1BMvVR91-Qk6MmLkDREDoVY3p
X-Authority-Analysis: v=2.4 cv=FrcF/3rq c=1 sm=1 tr=0 ts=67e5bb2a cx=c_pps a=cmESyDAEBpBGqyK7t0alAg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=COk6AnOGAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=nWr6sicSGW1Kan4-Y_kA:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22 a=TjNXssC_j7lpFel5tvFf:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 4N86sgh1BMvVR91-Qk6MmLkDREDoVY3p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-27_04,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=782
 clxscore=1015 suspectscore=0 malwarescore=0 adultscore=0 impostorscore=0
 mlxscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2503270141

From: Nitin Rawat <quic_nitirawa@quicinc.com>

Add UFS host controller and PHY nodes for SM8750 QRD board.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Signed-off-by: Melody Olvera <melody.olvera@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/sm8750-qrd.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8750-qrd.dts b/arch/arm64/boot/dts/qcom/sm8750-qrd.dts
index 7f1d5d4e5b2813c59ea9dba2c57bee824f967481..363703e3ee8fa2820c72c58a0f4b3a73e7aed59f 100644
--- a/arch/arm64/boot/dts/qcom/sm8750-qrd.dts
+++ b/arch/arm64/boot/dts/qcom/sm8750-qrd.dts
@@ -804,3 +804,21 @@ &tlmm {
 &uart7 {
 	status = "okay";
 };
+
+&ufs_mem_phy {
+	vdda-phy-supply = <&vreg_l1j_0p91>;
+	vdda-pll-supply = <&vreg_l3g_1p2>;
+
+	status = "okay";
+};
+
+&ufs_mem_hc {
+	reset-gpios = <&tlmm 215 GPIO_ACTIVE_LOW>;
+
+	vcc-supply = <&vreg_l17b_2p5>;
+	vcc-max-microamp = <1300000>;
+	vccq-supply = <&vreg_l1d_1p2>;
+	vccq-max-microamp = <1200000>;
+
+	status = "okay";
+};

-- 
2.48.1

