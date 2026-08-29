Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE087311C2A;
	Sat, 29 Aug 2026 07:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787989447; cv=none; b=lBmusy6FXb0AI0V+0Ge8LAU6mewAiHcDDy6i+/gEYRIpPhExXz3tpKZ/7QTkKuvPJqIOmgyF0q42K8ifl58okXCvo25s2XxweWODtJQLcMrHPTp5wqOciYeDxI6mSQQO11QaOJnum3lX+FqCV9JA2U3VL7RKr8jS5YGmZAZ8qDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787989447; c=relaxed/simple;
	bh=s3c8g78AqZ7CXpg2vNUbeY3SXl1ltLBNXS1efPH1FLY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lkaIAbMarX0ub+9epM8z9PZt/GVEkrN7KvdxOCCh1gL2fNqqZhd4nnZfMCZxKmjA8Mxsan0V60zlj6PNxmQVHuqsz/J4kQjS7ksuj+7c/QBz0wxyx4PW6fqP2YrHDhcDISi1fx4DYzeg/3PFRj310FigR9ujp5bYoBRsjuOwkzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CAFTxj+K; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CAFTxj+K"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67T57inq973637;
	Sat, 29 Aug 2026 07:44:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=/lqQpNAVNby
	gfEO5PiOZJX53KPHs7OpHbRAgj937lAU=; b=CAFTxj+KksDRL0tjina34NyEhu4
	T68joNmkm83xsOBlz0o2xnYYlIdsUPOnMp/eqi2JLqgBjwjyR8JIAYic/Z+5g4+w
	8hCUj27Y+fWlNBM6fymFA6F66pQpm2MorQslVkHsILKsecOihSQosySkll2zzvCu
	7Pe/80JdmopX6XRveaf2wdve+Mshw8IvuMNC4rrPkMkuu7ttoKy460TSfHD0B9om
	WVbvCCO1uJWq1gGHM1CODbkWyHZyjdkV7hc5zL9968Ae1zdqe9hUz7++KkHTzpqB
	Z4KUWnzNVJEDeZN1b+vp25O3Z6RAxr1yqhbOy077PbvHC/mwQivTdghsHrg==
Received: from apblrppmta01.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gbqn2gduh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Aug 2026 07:44:02 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 67T7hwsm002260;
	Sat, 29 Aug 2026 07:43:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 4gbrgh21u8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Aug 2026 07:43:59 +0000 (GMT)
Received: from APBLRPPMTA01.qualcomm.com (APBLRPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67T7hxVt002274;
	Sat, 29 Aug 2026 07:43:59 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com ([10.213.101.157])
	by APBLRPPMTA01.qualcomm.com (PPS) with ESMTPS id 67T7hxHg002273
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 29 Aug 2026 07:43:59 +0000 (GMT)
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 2342877)
	id BCD8063E; Sat, 29 Aug 2026 13:13:58 +0530 (+0530)
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
To: krzk+dt@kernel.org, robh@kernel.org, conor+dt@kernel.org,
        andersson@kernel.org, konradybcio@kernel.org, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, mkp@kernel.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        Ziqi Chen <ziqi.chen@oss.qualcomm.com>,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Subject: [PATCH V1 1/2] scsi: ufs: ufs-qcom: Add specified gear support for multi gear scaling
Date: Sat, 29 Aug 2026 13:13:54 +0530
Message-Id: <20260829074355.946543-2-nitin.rawat@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
References: <20260829074355.946543-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-ORIG-GUID: r98_8POw1vapFe4CViMheJpAbwK0RUTR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI5MDA2NSBTYWx0ZWRfX5jzswxV/zOos
 8ksNn/ayUEAl7hHJ/p0ktJn3l5nVY0p6YiXt0jP1XuUxEMcWGcF9TEBh5DIYELk/9tFZS+kJVpu
 mJg1us60VF1sNyM3Q0DYNRG4keXsTa9ZJYYkUskagiqPXC9+IXsOECWi8PTgIm7Xu8AXM39KYPU
 vyBcOmw0dQyBKMtCGJ1q8OOrYsyF39s+serXqHPj4O/7qBmhvM4hWvpgkPTZ2YvH6RAjIAZFD7E
 6kXWGBoTf5kO4vIDV9zYX1aepEYwG+LegSt7fX7vqRTQi1Nh9KzNQ7HRLPAPmcy6knGRfjKs0eU
 u8B3Cb5x0nQKi/Hg48jVU4qXhT2lQPhItds1EZLOF/byDQ12JbLmkFghtX58vWVepe8msR/V2s0
 hNtaWVYJNGXv+eZ3oXh3rf8vt/CchmXYqcgB/t8njutP1sfW7sWKdECRoMD1qtj3zs3ltOr1iZx
 da5ccQc7MQF2Mcixfxg==
X-Proofpoint-GUID: r98_8POw1vapFe4CViMheJpAbwK0RUTR
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI5MDA2NSBTYWx0ZWRfX1jrddVscGlw9
 jheyibMnc4Zsu0Ab57DmGMJShxjHU/LtSZ1qn3SyAn2zbBRx2MfDR/RjP3/0rroH2L/kq57qaC1
 d51cDanvBTYaSIDRTITvA2MMBQicZno=
X-Authority-Analysis: v=2.4 cv=a5kAM0SF c=1 sm=1 tr=0 ts=6a928dc3 cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8 a=YzorNPvUMMs_jl1oJJoA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-29_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1015
 adultscore=0 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608290065

From: Ziqi Chen <ziqi.chen@oss.qualcomm.com>

The UFS clock frequency and gear speed do not necessarily have a strict
one-to-one correspondence on all platforms. Introduce a device tree
based configuration interface that allows specifying the HS gear
speed for each supported operating frequency via the "opp-level"
property in the OPP table. When this property is not configured, the
driver falls back to the default frequency-to-gear mapping table.

Signed-off-by: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 0f2e083b04fd..aa2ac2cd2b69 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -2460,8 +2460,9 @@ static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
 	bool found = false;

 	opp = dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
-	if (IS_ERR(opp)) {
-		dev_err(hba->dev, "Failed to find OPP for exact frequency %lu\n", freq);
+	if (IS_ERR_OR_NULL(opp)) {
+		dev_err(hba->dev, "%s: Failed to find OPP for exact frequency %lu\n",
+			__func__, freq);
 		return 0;
 	}

@@ -2489,12 +2490,32 @@ static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,

 static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
 {
-	u32 gear = UFS_HS_DONT_CHANGE;
+	struct dev_pm_opp *opp;
 	unsigned long unipro_freq;
+	u32 gear = UFS_HS_DONT_CHANGE;

 	if (!hba->use_pm_opp)
 		return gear;

+	opp = dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
+	if (IS_ERR_OR_NULL(opp)) {
+		dev_err(hba->dev, "%s: Failed to find OPP for exact frequency %lu\n",
+			__func__, freq);
+		return gear;
+	}
+
+	/* Get HS gear speed from 'opp-level' */
+	gear = dev_pm_opp_get_level(opp);
+	dev_pm_opp_put(opp);
+
+	/*
+	 * Greater than max gear means that there is no specified gear configured in DT
+	 * or the specified gear is invalid.
+	 */
+	if (gear <= hba->max_pwr_info.info.gear_rx)
+		return gear;
+
+	gear = UFS_HS_DONT_CHANGE;
 	unipro_freq = ufs_qcom_opp_freq_to_clk_freq(hba, freq, "core_clk_unipro");
 	switch (unipro_freq) {
 	case 403000000:
@@ -2515,7 +2536,8 @@ static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
 		gear = UFS_HS_G1;
 		break;
 	default:
-		dev_err(hba->dev, "%s: Unsupported clock freq : %lu\n", __func__, freq);
+		dev_err(hba->dev, "%s: Unsupported clock freq [sys_clk: %lu, unipro_clk: %lu]\n",
+			__func__, freq, unipro_freq);
 		return UFS_HS_DONT_CHANGE;
 	}

--
2.34.1

