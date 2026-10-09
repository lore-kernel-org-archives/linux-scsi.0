Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC82434983
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 10:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542213; cv=none; b=KtNW8Iit+ZjeLb7Raoa/CyQeduCgFeWmrrWESAjnAPjJAv2vl+JmmMBZ+ZmAXx/cPhoZcF83k8IsOxlwcXtwHrPfodhPLvvSBW+qG8eNl3Pz1kmnOxDwOwwZnjnd9g0UxSex1tuBCUez2lPyKp+WX4a2W/OHqvuDLABuw79QcLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542213; c=relaxed/simple;
	bh=qZOq97SsVPti3oQZnFWkZh3c728gDdolT+V4/jasJQk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ugsCQBzLXRxyJKt4Gs0qlfMZwUcOVLXf4wqWFjH4lk4h7Iu46L0eXtK1M/4D1OdDrX0jswouGSBy9Gy+z9YdHd2ZG9hZlyfkqrYhniplC7+n7rMEOs/RVNcZdhgJpiwLF73iZK3VDQZf68WY6ZaX0UYyLIbsLDv93Lz3Nu+LN20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gpg65mZT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YphYYFNa; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gpg65mZT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YphYYFNa"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6998KBXL2256899
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2026 10:36:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=; b=gpg65mZTb1CfJeuu
	17tahFNDNqr7iiAQ3T0CYhsx7AiNyR7uTfnTD4/w9r2irb1s/Ml4cNz3tfvcy+at
	f7iU2OAiJVCA+noWpD+B1W7dk5f/DuloVjv9Dtzl/3ezczt2MLmDkEfe6AREXdTb
	2Y+sI/ya4tDMLrjukHNvxMAAWYbgxl8cZ66QUCewg+X+TnJZc8bwlP8Ew5177Q2p
	I48d4WNz/A+N3pDBOc0GgW4KeViND9S1VKmzEtIUAes5klL05W5mlEVXrx6X/TWT
	ci2aoliViIcBpL9Ha+0hrFM2egqZNiwo7N8sg06Y+2Qv7DwoBk9y10PGsyB6Ahpc
	cCjQNg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6nufsxfg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 10:36:51 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-39deda201bcso9594239a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 03:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791542211; x=1792147011; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=;
        b=YphYYFNahW8cFHYmFRmkMmLAwAOOlzTKnEP1Jphtbs/81Wlt87ivIDNNE6s0gIHFp/
         DSzpVEMtglbQj5QGEPijyS+wt1gAbfyIdOffD2dAa5ydoBN1ob0ioMBov1W3EjyF6ZSR
         3PCwXVuK+Or90EhyRwdq1qngvA2rfJukqxoZSPvV9srWx0DTJAYCpbfWkqlEw68Lmm9U
         YzsAvJ4niq5k4sJ1G2LcoZ8y/TtM+3xbih5pZ8WSKF5wCjVI0oHwZIc30j9V59m6HH+g
         W6sH89ORunCnPvq8/ClOu0hC2A8vogy8dTOoqHyOJlCp5cX19i9wUiHME1y7JwdoX/Ii
         1BlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791542211; x=1792147011;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IE7TTEPp+mYjYOJnw2S5JdN9e/VGEB2SwjVCAm8BKAQ=;
        b=zzOPBKMYJsYOdFTRHXbMG7wa7WGkR0Oq8gjWcAKRtEoQgCm6Txdc3pwfnHsB7xBWD1
         7CozJ6NN3bv1QX9JMqPNXK1QlwNMfAythapE8CXNO94CkLb0El5ZVdn6o+ypGCDYC03O
         otbLM5MnLq9DG4rMN3PR2L/fEOUD0a/uqP2YdXB6cPQBdGCze1Yp0DCIxH9ZV0EptmMJ
         N3xIuJAnDeR5KjkfsPtD7JxKB9vx5R1SQGo3cbEiD0dpPpYFm+mJEZXPAduhZssmDvvO
         eFaSx5hBmjlPvkrGOSvBO59IGv6gbahfFsVbSMdW6p3E1CZl94i6CTb1cRN1YgDLciWy
         fUbA==
X-Forwarded-Encrypted: i=1; AKwUvByHBG7A0JUKUsyhbvvyoHxSzVVfRtY3CqqsSHKt9Dc2Vyc5aAD1as3TfQqp3TC2xbL86zChHL2uKyLG@vger.kernel.org
X-Gm-Message-State: AFq9FYIyxC0QSOkLGZmsAzu1GvwmpclhrHL4H6BFQ1jx7tBQn3YsEqbt
	jO9ncuGHi1bX7v5iWY6wCFbF12wQ9X0p5efrSdFz97MXWR8A3oG7fiEhH/dB4LzhK1lU8ZxHiv2
	go78PVHAvnWkGYLu8KArDalTs8POI1QiEzsqfznOH6fb1EWnYpyUBp9QjfFWNMc1i
X-Gm-Gg: AYBFou0es8cKEpoLvc0JN3X5rsoN6JYDf2Y5DtR9rXGpEZv/PuDgayjUeCTdialOQL/
	4584qVzMjfsxMfnZn3IKrvY6zjgxhv+ipBNz2SE78VSImySFHOPdFy3fSo8NeZCViPbevNE0bfL
	YmaNWZhp/JhP/sgXGMcRV70po8TaRRjbx9jRHekheu/HRaJxLd55suuyy6DCQMwZ7IPFRSlnGL4
	FXGFv4DbyAQ6/ZoaX2KNCoudMUlBfyCbgrHJzElRmQt+msDhr0KAq736xPZ3LlIFDIcjJjBzCfg
	AuO9rU41D/2G2IEDRrKbC9vxaS5f8IDktGE0nt3WEwNa+enmT8VtCh/k1YJoGRwSuXydSNIQaQR
	mYUhc3QntY7NiGCB+vszkv8Zx
X-Received: by 2002:a17:90b:1d4f:b0:3aa:6b5d:a00a with SMTP id 98e67ed59e1d1-3ab3ac7912fmr1351569a91.53.1791542210903;
        Fri, 09 Oct 2026 03:36:50 -0700 (PDT)
X-Received: by 2002:a17:90b:1d4f:b0:3aa:6b5d:a00a with SMTP id 98e67ed59e1d1-3ab3ac7912fmr1351545a91.53.1791542210379;
        Fri, 09 Oct 2026 03:36:50 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm2827285a91.16.2026.10.09.03.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 03:36:49 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Fri, 09 Oct 2026 16:05:56 +0530
Subject: [PATCH v4 4/5] arm64: dts: qcom: glymur-qcb: Enable UFS
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-glymur_ufs_qcb_enablement-v4-4-9a6ce83195b7@oss.qualcomm.com>
References: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
In-Reply-To: <20261009-glymur_ufs_qcb_enablement-v4-0-9a6ce83195b7@oss.qualcomm.com>
To: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>,
        Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791542167; l=1034;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=qZOq97SsVPti3oQZnFWkZh3c728gDdolT+V4/jasJQk=;
 b=PXedG+C7Vz/FcxbMEUnWOm+ZponbU5XxVcmfG0e1f742kHIZOPwWSFQIMT8Hbr95BQs06AhWu
 DEZUG0C7Jl1AAqG3ruPsXNdZ0KITXgm/PqFFNUKj0mu6a194VEBX8yg
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Authority-Analysis: v=2.4 cv=afn0Dhot c=1 sm=1 tr=0 ts=6ac8c3c3 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=cMKPt8sKVRzp0kMMbBYA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA0MiBTYWx0ZWRfX9wMLCd+7zfTa
 UJhxLOab+PTGJGyfgaAj0Z5Lm1FDufaxYYszUcDM3PE3+bHauLOt5LFDx2uMmKuVPpU3hDfo9X9
 BJRWrqNYsdAZta/q1h7ttsSol2wV7tw=
X-Proofpoint-GUID: Eeo3DhvURDaM8Q_OO6_0SmZei2om4Spg
X-Proofpoint-ORIG-GUID: Eeo3DhvURDaM8Q_OO6_0SmZei2om4Spg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA0MiBTYWx0ZWRfX4uJ/PykCnZmn
 FaLffrF7pcsTx2Tdt/m5dLO/iU+CuXxsZH5IUqHdb/99OQPZxz+hYslbtPQ9ZV+s0JBEB1J1Zls
 ILHuifO/wnxUd8wWw1XjMEntJ6usxtPGHckVgYpNkfCkSHSuAqkrPNlEgSkLdrshr0mo9uizDtt
 NNaO9JCAYrSjjtnBVU7Bu9ISb3PrGiforamo7nCmQf7IdO5NurewJEmFHLd34qECWbeBpjhuLsB
 Z0suQCRtRuUbkQ5FXPMMTBd3ZPK7Syq3ne3ikfQXXujV45Stm4Tuvl4HjzXjhwc0j0YYVes27+L
 0fQepnxSzgojM4sFLEAKAlp3/VKZ9xuf2ptoa/M9gNByc+ezpS45dLrpGKjOw7BUKrEID9zaXTO
 Wp1T9lDk8TfdTDMDlpWqgyGRgIXm4MUxRPyd5OMT1TMZIs8cA+V9HAeGfwHJEcw8kw1iGSd3LAq
 3C/QfsaWX00ySmPQf9A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_03,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090042

Enable UFS for glymur-qcb board.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 arch/arm64/boot/dts/qcom/glymur-qcb.dts | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur-qcb.dts b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
index 17d8ff3aed23..f17181bfeadb 100644
--- a/arch/arm64/boot/dts/qcom/glymur-qcb.dts
+++ b/arch/arm64/boot/dts/qcom/glymur-qcb.dts
@@ -697,3 +697,21 @@ bluetooth {
 		vddrfa1p8-supply = <&vreg_pmu_rfa_1p8>;
 	};
 };
+
+&ufs_mem_hc {
+	reset-gpios = <&tlmm 250 GPIO_ACTIVE_LOW>;
+
+	vcc-supply = <&vreg_l17b_e0_2p4>;
+	vcc-max-microamp = <1200000>;
+	vccq-supply = <&vreg_l12b_e0_1p14>;
+	vccq-max-microamp = <1200000>;
+
+	status = "okay";
+};
+
+&ufs_mem_phy {
+	vdda-phy-supply = <&vreg_l1c_e1_0p82>;
+	vdda-pll-supply = <&vreg_l4f_e1_1p08>;
+
+	status = "okay";
+};

-- 
2.34.1

