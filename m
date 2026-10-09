Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C4743712D
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 10:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791542222; cv=none; b=TWENySSKedUPV3EiN9ew6kswK/P7vjxTjAo5z47z8e0XUeU5aJ82Z+Y2TXzIVH8aCfSaBd2jLaKUtgQ7Skce6cSaQCmi7uaTXP8z1MNTfBI3nu3/qpTNbfIz/QENXfQmgd7HFyDfkrBtqL1IGs0z/l+n3D0F8EqwSOKLadv6qZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791542222; c=relaxed/simple;
	bh=j+6E2DsyWVACZ4BJXAoVepwTbWHw7Rvhrv180mSV7PM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lc/6+YBZtJ6xS5vVNOjdc7CYGXeCOIBwYKiC0tCX3RLfx1dwCltAmoYVVAm/gI3R6fkV1EoQ5XgPu8SYEZTkwP2hoFvSIwr5OQBjqZgxakfyhbXLezePu+9eUYF5UNrHUbVueQhxdSxSCOupPtkuhjQZk1yWKKoQI5OeprmqfNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TLCDXaYK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cl2qKjq0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TLCDXaYK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cl2qKjq0"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6998KQA9642576
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2026 10:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xAjKpEiBJsa7RVtneAxPAiJWPxqBzUXw9AZO8LSFdjA=; b=TLCDXaYKeThkyfzl
	NneLDG/cgoEwwfQTE+F4RcvaI/04O7qYBXRw0/n7ypt3uab/o6dSCG3SCfT2B9FP
	yRxztaXhU3aVzMvQj08w+EGjaBUn2qDF4Ba91hilmGWb0VsA0S0AW2LAlObmaHG2
	Lbr4ke43rAe7vJADJxmnzVEPgqZVd+lKdpT6cFYjKusLxnZvQNX7UPosrRPb8RN3
	H1RK+WqROnvKLplM+VkqTgal00H2VGIERS+YW1wexR1FcvGby9XomNi1LSRSmOdw
	gEampWiQChKlNJcQPMQQq743O3GPgQmvyf8dpOyqrYeCltY7WAPb7GQWva1p8/7C
	wa5l8g==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6fxru5es-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 10:37:00 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e85f710dbeso102465ad.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 03:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791542219; x=1792147019; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xAjKpEiBJsa7RVtneAxPAiJWPxqBzUXw9AZO8LSFdjA=;
        b=cl2qKjq00qvr/UOvWDFnaC/8orrb/4Gl9tXef+TlhzNt6gz4LaRzRp8PTrCyN3LBoO
         3kmTHJBl1VWJIu/JecqwZ4RSZWW/isiyTZIdoXMhVdaZCT6e3sVuJUKA9Q5yzh8j5D0c
         wP0aylDtRTkjDZ+mZJK114RB+9MzbPFEvy4zNxZYPpHX8aM9N8foopvOvEk+FcwZ4xMu
         v/rjl2upQD7dnubQ5zq7Jg1u+PiBZtcCkiganzT2OV64/2YAJB0DV6aKYAIBYgnZGG6t
         yC/Rle0Jra/a95vOiSX+2Vo/DIRQtWJ8C4IhwbfH1dA444tW1phYNMYDjEhCz4ssghXJ
         H1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791542219; x=1792147019;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xAjKpEiBJsa7RVtneAxPAiJWPxqBzUXw9AZO8LSFdjA=;
        b=z/sysquiYj/JqRib+v7ktEAmwPZc8ifQ/d8svZ6qSzzPfsBB5Cue0Y+5T+DTx5XsdZ
         uZZgTKc7Q3UmYqLvHLm6N1F7t/X3FRlD7SH1F7WZuEwM8YK99Nc1ApI335iFWHtcdvtm
         Y6AeHARbR/6y9ImV8uvIihRqvUsI9gNaNewj3kkCH+DS2Ew7YBXKTfE2e8qDlmDRx5Yi
         iwXOHzODOJLgIew/HuL+mA5+vRT3OgbjIDm6jYYGSHJxV+z/jsH2LO+sp/QLt/kWH8nC
         NLZxDVEQSGAGh9WW8Af+EAeevoKphlVJC9ipLPx7mx78jed3G1W+tMLx8Ju29pqjYj2m
         iANg==
X-Forwarded-Encrypted: i=1; AKwUvByV+RQZwpXI0d+0/cvpReA6W/g6lBLZRl1jv5hw2AoAu0AoZfLkWe1CbrR0XdTJPk9oE2CMbIERc5uz@vger.kernel.org
X-Gm-Message-State: AFq9FYKWLQOZqjvI12fAjeWzk+wBivsz5AjspfMTRM7/7yqjOx7C7fEM
	SYxgd6yZfNTov4NXrX377iWBvhOEGhPo1ize8vCoQAsSOtCP+L5dna3aup5K9zrtjbVIRolPMD+
	5sl77VyvsFLNS3E3ycYc8lEU6zoTA+TU/zYzOg/KK82nOdTntz1anoerRVNdCMs3T
X-Gm-Gg: AYBFou1aKLpBgSxd/JJvH26g0RvRIw99JtaaVgw/9PKxFf+f1Ly4DwZIZqos4WZYx/g
	9ec89iV4ijpu8vmRW4sJejLh8cV/6DDyTqhv/NtyD6WhrC8vbkSfdNoblYTPwIWbbVh8XJsKLwq
	pK5V3aQinP3eTxMP9WyDTTo36yTWplM/GT4/qSUXG1Jl+KqGdTsPCDW4BiJcC5Ujk8jmd8FMOzE
	q5WH1xSTSwX84HdREBbS51LMi/9Yd5Btv9/9ZT1FC9KOY66kiQC2QZdMZ8CA4N7zO18tp4OpR9P
	kqBJTyDmY39PTSD73JTOUBLFoG2uwD21L1GjvVdfTbKG+PeFkme7VAUlqOJlte4tk4H03PsEG5c
	4YmdkZ2/wqGkkfrR7HaPDRkhj
X-Received: by 2002:a17:90b:224c:b0:3a7:9adb:2a0d with SMTP id 98e67ed59e1d1-3ab3a0218bfmr1514330a91.0.1791542219152;
        Fri, 09 Oct 2026 03:36:59 -0700 (PDT)
X-Received: by 2002:a17:90b:224c:b0:3a7:9adb:2a0d with SMTP id 98e67ed59e1d1-3ab3a0218bfmr1514298a91.0.1791542218650;
        Fri, 09 Oct 2026 03:36:58 -0700 (PDT)
Received: from [10.213.101.15] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm2827285a91.16.2026.10.09.03.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 03:36:57 -0700 (PDT)
From: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Date: Fri, 09 Oct 2026 16:05:57 +0530
Subject: [PATCH v4 5/5] phy: qcom-qmp-ufs: Add Glymur support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261009-glymur_ufs_qcb_enablement-v4-5-9a6ce83195b7@oss.qualcomm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791542167; l=6448;
 i=pradeep.pragallapati@oss.qualcomm.com; s=20260911;
 h=from:subject:message-id; bh=j+6E2DsyWVACZ4BJXAoVepwTbWHw7Rvhrv180mSV7PM=;
 b=l4MArN+SNZYmB8sxb1HMmCFah1CZn0Rgx1GAo0pMRdNBZUmj7CADZ/QvEO2Rf7jpHIGVUeX9M
 pmpzEWX7IzMC2EA9b9vG4M5Wow+hcJsf5+C/ieylkYKWwhvrLpOVjad
X-Developer-Key: i=pradeep.pragallapati@oss.qualcomm.com; a=ed25519;
 pk=uyRUsge8nQMwf3iW/e/o0U8z9nWLCMm1MGKxEftztic=
X-Authority-Analysis: v=2.4 cv=E+1YNqdl c=1 sm=1 tr=0 ts=6ac8c3cc cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=EEZK_nQxm5Uv2-YDnh4A:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: ye8zFkSQCAQ5WhV9igArDnJqpP22JjD6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA0MiBTYWx0ZWRfXxc77Rcyrrnak
 g0mYlipo3WFN42ySHa0ScP/B8IiQOvdgz1VHDxoyvj7GFUZKaBz7ZTS1GS5s+XmCM31g/NlPjYt
 OmG0daGrbRQ/l++M18q4ViDioWAbZpc7KZJeE5Z3PYuYn3KeJCtRIhrFzx7mK1YbfcHzYGIwxc3
 51fCv0e4dU2RnfSsZiKamtQlFjczFDr970bMVUvrBRfCtWt9ExPxvwusJR6t3ONNL+sdpqNsiB5
 dqfoKVui1mcwyqee6DuDzm8Y5JjhL/2WBORWauj8zaMzgrGbmHVhebB88WPmrEfEF8DvWGtEhEr
 gDrJvEWTn6r8X9kWbNPLf6FhdV/8V2Mp0yqNZkRvezoaCP+HutwcepUaWXdj9/NhHMxZ+WJ9wOh
 /adCMP5jqUXLH8SIfJhvUWPlxZoYGEUWH5SqHWZSsTXbWsMhhDiOQ08ZpfWFWDA2rijKmc+JTqk
 d1ES82tOH3l0jir/35A==
X-Proofpoint-ORIG-GUID: ye8zFkSQCAQ5WhV9igArDnJqpP22JjD6
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA0MiBTYWx0ZWRfXwQxaQNANB2Qi
 KSr7U+pw/8UGrQQmccNaZS369Gm7ksxIy/Su328KWjIFl3QZCJwfBCODA1klHVwk/EKF5dFk9QY
 nFEOiVB1AzqDmpAu8iZmSJ/M2Itz3rU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_03,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090042

Add the init sequence tables and config for the UFS QMP phy found in
the Glymur SoC.

Similar to SM8750, the QSERDES RX and TX register offsets for
glymur SoC follow the v7 register layout, while the remaining
(PCS, MPHY base) register offsets follow v6 layout. Update the
register layouts accordingly.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 99 +++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index d15db9ab9a90..f441b26bb8a6 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -93,6 +93,59 @@ static const unsigned int ufsphy_v7_regs_layout[QPHY_LAYOUT_SIZE] = {
 	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V7_PCS_UFS_POWER_DOWN_CONTROL,
 };
 
+static const struct qmp_phy_init_tbl glymur_ufsphy_rx[] = {
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FO_GAIN_RATE2, 0x0c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FO_GAIN_RATE4, 0x0c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_SO_GAIN_RATE4, 0x04),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_EQ_OFFSET_ADAPTOR_CNTRL1, 0x14),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_PI_CONTROLS, 0x07),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_OFFSET_ADAPTOR_CNTRL3, 0x0e),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4, 0x02),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FASTLOCK_FO_GAIN_RATE4, 0x1c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FASTLOCK_SO_GAIN_RATE4, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_VGA_CAL_MAN_VAL, 0xce),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_EQU_ADAPTOR_CNTRL4, 0x0f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B0, 0xce),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B1, 0xce),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B2, 0x18),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B3, 0x1a),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B4, 0x0f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B6, 0x60),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B7, 0x62),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE2_B3, 0x9a),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE2_B6, 0xe2),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE2_B7, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B0, 0x1b),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B1, 0x1b),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B2, 0x98),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B3, 0x9b),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B4, 0x2a),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B5, 0x12),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B7, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B8, 0x01),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B0, 0x93),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B1, 0x93),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B2, 0x60),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B3, 0x99),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B4, 0x5f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B5, 0x92),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B6, 0xe3),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B7, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B0, 0x24),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B1, 0x24),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B2, 0xe0),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B3, 0x99),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B4, 0x5f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B5, 0x92),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B6, 0xfb),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B7, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_SO_SATURATION, 0x1f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_PI_CTRL1, 0x94),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_TERM_BW_CTRL0, 0xfa),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_DLL0_FTUNE_CTRL, 0x30),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_SIGDET_CAL_TRIM, 0x77),
+};
+
 static const struct qmp_phy_init_tbl milos_ufsphy_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_V6_COM_SYSCLK_EN_SEL, 0xd9),
 	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_CONFIG_1, 0x16),
@@ -1212,6 +1265,11 @@ struct qmp_ufs {
 };
 
 /* Regulator bulk data with load values for specific configurations */
+static const struct regulator_bulk_data glymur_ufsphy_vreg_l[] = {
+	{ .supply = "vdda-phy", .init_load_uA = 217130 },
+	{ .supply = "vdda-pll", .init_load_uA = 18340 },
+};
+
 static const struct regulator_bulk_data milos_ufsphy_vreg_l[] = {
 	{ .supply = "vdda-phy", .init_load_uA = 140120 },
 	{ .supply = "vdda-pll", .init_load_uA = 18340 },
@@ -1324,6 +1382,44 @@ static const struct qmp_ufs_offsets qmp_ufs_offsets_v7 = {
 	.rx2		= 0x3000,
 };
 
+static const struct qmp_phy_cfg glymur_ufsphy_cfg = {
+	.lanes			= 2,
+
+	.offsets		= &qmp_ufs_offsets_v6,
+	.max_supported_gear	= UFS_HS_G5,
+
+	.tbls = {
+		.serdes		= sm8750_ufsphy_serdes,
+		.serdes_num	= ARRAY_SIZE(sm8750_ufsphy_serdes),
+		.tx		= sm8750_ufsphy_tx,
+		.tx_num		= ARRAY_SIZE(sm8750_ufsphy_tx),
+		.rx		= glymur_ufsphy_rx,
+		.rx_num		= ARRAY_SIZE(glymur_ufsphy_rx),
+		.pcs		= sm8750_ufsphy_pcs,
+		.pcs_num	= ARRAY_SIZE(sm8750_ufsphy_pcs),
+	},
+
+	.tbls_hs_b = {
+		.pcs		= sm8750_ufsphy_hs_b_pcs,
+		.pcs_num	= ARRAY_SIZE(sm8750_ufsphy_hs_b_pcs),
+	},
+
+	.tbls_hs_overlay[0] = {
+		.pcs		= sm8750_ufsphy_g4_pcs,
+		.pcs_num	= ARRAY_SIZE(sm8750_ufsphy_g4_pcs),
+		.max_gear	= UFS_HS_G4,
+	},
+	.tbls_hs_overlay[1] = {
+		.pcs		= sm8650_ufsphy_g5_pcs,
+		.pcs_num	= ARRAY_SIZE(sm8650_ufsphy_g5_pcs),
+		.max_gear	= UFS_HS_G5,
+	},
+
+	.vreg_list		= glymur_ufsphy_vreg_l,
+	.num_vregs		= ARRAY_SIZE(glymur_ufsphy_vreg_l),
+	.regs			= ufsphy_v6_regs_layout,
+};
+
 static const struct qmp_phy_cfg milos_ufsphy_cfg = {
 	.lanes			= 2,
 
@@ -2371,6 +2467,9 @@ static int qmp_ufs_probe(struct platform_device *pdev)
 
 static const struct of_device_id qmp_ufs_of_match_table[] = {
 	{
+		.compatible = "qcom,glymur-qmp-ufs-phy",
+		.data = &glymur_ufsphy_cfg,
+	}, {
 		.compatible = "qcom,hawi-qmp-ufs-phy",
 		.data = &hawi_ufsphy_cfg,
 	}, {

-- 
2.34.1

