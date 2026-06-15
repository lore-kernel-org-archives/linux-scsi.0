Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A64B2F39AB
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781514800; cv=none; b=LzNlafZQ+mh20VBVdrUcYVxCOZNLXu2yEamwP6cajbiO44u1V0ddky1yokM/RhF3k8eHXqU4HNgANcAhDtx6BI1tezhRODMNtIFpgJ+LfHW2MJOtWFt4pOtf9PibdjjNS6Ds9l4RAmFlT/lEq9FrAe5iXwLuckgxGbP93GpV7qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781514800; c=relaxed/simple;
	bh=4hpvzc+pg0bphjaQScym5O6zAEZDLrP0uaS6dmI7nF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EXHKL72avQvpy381Am/tdFpn8x6P/pr8GMIl5B6GDLRXls3txCw4gR+/INzDAzrL8h4CPUK8LHzUT8pBf7rQHfwKBR9q1bP+NFIw4RGR3NSu/CpDKjGtbkZfmg1sqhQ7Ai39oNNvJuBm97WLPCaEcxLekZOp4QMielZIG3iAd78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Vs2H1Ogl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IRdLQFkx; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Vs2H1Ogl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IRdLQFkx"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65F6L3O03888561
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=GhBkRebi7G5
	yKNU0yo6QqpUxkZX5awKWkx6MgJMhcSo=; b=Vs2H1OglxxbLXqz6s/dHvA7P1qM
	tWamriaOBjWfWgBeM5MGEOONt+wqXqsOdRUVlmLfobSUSoeZ23aWH3CErAnhcMeA
	ZezjApzGLnSnOjWAYmNQVKa8HjwEZ0IMmrjWAiOSwyHNImGxINfEmzsZv7cdRG3x
	KMc9Y/V5tzK7gnU88bHSS4WTtW8Ntr0rIt6Avn0ihYEWk35V629D6DEiSILjPd72
	5XkkKWEQaUYCG6R1hb/MuPdoi4lfgPtcaWhYgYtVgHCLi5tL68fQAzM2MonfXqdU
	M+QrwyPQ5dL/vK9OEvlqJpOCx+FHwJ13rpCTaLcajUWCKm5b0GkU3BqDMqg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ery8wxkyw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 09:13:11 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2c0a99db8dfso30210485ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2026 02:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781514790; x=1782119590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhBkRebi7G5yKNU0yo6QqpUxkZX5awKWkx6MgJMhcSo=;
        b=IRdLQFkxRPHX0L1puhZdBWIc/21JOB8z4kbpi5EFBlawxPAr8GY1qXjlLf9uCeFqbX
         0eSx4i6yisLHU5H/mHFZW7mTKra6fZATGBj++TZDYktQvFGu2Rj+9/CoXNlDqMlRiWJU
         gogOSSueTGvI3KunYKfJN+SFEntBlyDM553/pT2iPLNAOK7eMZLAG0BkFYoxF3Nl2oxC
         fgJ3MUfG5F1HJrBjlWZP4HRNqZF0hMoQrE541JTrSIhW9XwtdejCGHF4bS7pgFfRKgYW
         hW6jdrtGnqF31hUL4juHpdy0gbkoFrNoPQc8CxbEYjhdwdE8dj1pG6teXCROwnhPLKw6
         PJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781514790; x=1782119590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GhBkRebi7G5yKNU0yo6QqpUxkZX5awKWkx6MgJMhcSo=;
        b=Yg+bKy8pPsTuViM2gRjLGUa1HzaIKRy8/D8dOtWG+9+0NnUczO2ArOKEHpx6UVeQBw
         b3WFviFmUdAXx/twPj6ebG+rNSYPAUKM7NALDgtjCtoyXjNeYU6j8UC+KgLl5y1U4vw3
         q+ZYTW+QJZThdnOCrAq181083rbdsSp50I5y01sLg6nEMEiDemqvb7x9pTrqI2Oa5D4U
         9wPGbcNuB1EWXRevM8UnWIkc9J5QON+cr4pnI/cjwTKsO3hTpvihf2PqhdiMVrxhoIQS
         /ozC8EtsuO74ATwPQqnF1OFix0T7JI+AZL1nutCc+erO0lk7arRzSurG6kEP2TLRetOn
         2W2g==
X-Forwarded-Encrypted: i=1; AFNElJ91nU/79XchrNAywQp0PgWt/018mEeQ9+63GLLgR8j/UK8XW2SZE4xDItWWlS8e947//Clw0Q75P7+n@vger.kernel.org
X-Gm-Message-State: AOJu0YxF7UYYNWKEQGIxPvMT3GIh1LlulcXatU5JihHmQn8hUjVtmAZ2
	/rOPFplQdRv9HA2rcRKqnSVxkeCnzOCRrK95nmRW3Ph5quqSKESYCThyzqEBGfjBuyZkSxAqgf/
	ZS4IrjeB5kFrrc0zukGIdPNB/e9c/liEDuJgXdbhic5XXiwGucDtJiHIiwz6OHuky
X-Gm-Gg: Acq92OGc5pqcnh5XN8Erzhf0Eenhhztts0rBXdlpzoFQkuxWT7It3n5CJpuVyNdilzT
	cU21ZiQetPxEpiI4wkiCqjlYf02L78cPdFAu6jEt16FQXwGgQm5N3ZHmVf9yj3ExY/ISEARNA98
	21HTZQdfCSZqe1U1XtaMM+N8JFeg3+p5WAiDYOInkcteiGLDw/wjhpxYrD44KDTc2qXYBptyBV2
	VHr+ZF4o+4Vmo67X8OpKDGcwcq26aQHdDfOiyd7jJpQvb3z7ZQX0UHM7iBcmn52oUzV41rYymRK
	x5B0lcuHPM5QISVsgfjvVmC7NnL8X9wmRh6r9csSAyh3j9lOsRLxAPFDhmcFzh7fVlDaQREvS+a
	aZE3LxZ1I2Fohv9ShVylutwJTnQpGmEJ73BG9uKuZBImCxomK4Dc/2A==
X-Received: by 2002:a17:903:247:b0:2c1:a19:8396 with SMTP id d9443c01a7336-2c413dbb942mr151474215ad.31.1781514789973;
        Mon, 15 Jun 2026 02:13:09 -0700 (PDT)
X-Received: by 2002:a17:903:247:b0:2c1:a19:8396 with SMTP id d9443c01a7336-2c413dbb942mr151473625ad.31.1781514789334;
        Mon, 15 Jun 2026 02:13:09 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c433079999sm91669065ad.66.2026.06.15.02.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 02:13:08 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        dmitry.baryshkov@oss.qualcomm.com, abel.vesa@oss.qualcomm.com,
        luca.weiss@fairphone.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v4 2/2] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
Date: Mon, 15 Jun 2026 14:42:42 +0530
Message-Id: <20260615091242.1617492-3-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260615091242.1617492-1-palash.kambar@oss.qualcomm.com>
References: <20260615091242.1617492-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 7PsuhLkEkXsH6AbeC_kAHuGglGGdxsQ5
X-Proofpoint-GUID: 7PsuhLkEkXsH6AbeC_kAHuGglGGdxsQ5
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDA5NiBTYWx0ZWRfXxoi3k/klcR3/
 PDT49eGxyIXEpCDmptpTKc3QTFnsLMsD3YSzPxYTFyD8tayk7K+lHXkOjcIO4OVsPIVIq9SH5vl
 Y1grKQJofmvTQlsbaghPeFrVN9i335Y=
X-Authority-Analysis: v=2.4 cv=IqAutr/g c=1 sm=1 tr=0 ts=6a2fc227 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=d9MzugbnVWS3ESvbmRYA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDA5NiBTYWx0ZWRfXxOyR9w7AyRgO
 kUN5s/6zKzLw3Qxk2FBokC2+hNBS1ij2tgJR1nYWakrCnF+VvRm6p2IXq5UOkH0SiXMJhTKx1jG
 2qd8eQT1U/caFqwWKekWYMDsjaPSGkc8q32q+baE54zb9WptiI48k2Bg47zdNISLqOxUtWBrOr7
 JGjpjzzGDREm0zAmvIZq9FSHZadb+pE3rPvDrlu0oKRdsl85oDmnjIyaHgz8f7MW5gqswAUmPmc
 bfNl7Jac6UD+21pfuXZOwsWZcgHfpRv4oI2KieqrGMul+ZZ+U+7mAbETX78qc4UKiYFUhAi67fv
 eFUgqouY8dsmbWr8V/ZHqP81ZRD4hmVhe1I9COMJBBqv5PRJyP54/U546UPB+TyN+tTTTotO9L4
 hbfzTzPmEyVQ0tofMsvP5sAhX6Sf9t5rGcZbKpIQIx+AfqW+rqczbzpPCiNRhSHW06O8629ZA3V
 eVkufzSLNiA62R8QwDA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_02,2026-06-12_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150096

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Add the init sequence tables and config for the UFS QMP phy found in
the Hawi SoC.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
 .../qualcomm/phy-qcom-qmp-qserdes-com-v8.h    |  13 +-
 .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 139 ++++++++++++++++++
 4 files changed, 212 insertions(+), 1 deletion(-)
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
 create mode 100644 drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
new file mode 100644
index 000000000000..e80d3dd6a190
--- /dev/null
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef QCOM_PHY_QMP_PCS_UFS_V7_H_
+#define QCOM_PHY_QMP_PCS_UFS_V7_H_
+
+/* Only for QMP V7 PHY - UFS PCS registers */
+#define QPHY_V7_PCS_UFS_PHY_START			0x000
+#define QPHY_V7_PCS_UFS_POWER_DOWN_CONTROL		0x004
+#define QPHY_V7_PCS_UFS_SW_RESET			0x008
+#define QPHY_V7_PCS_UFS_PCS_CTRL1			0x01C
+#define QPHY_V7_PCS_UFS_PLL_CNTL			0x028
+#define QPHY_V7_PCS_UFS_TX_LARGE_AMP_DRV_LVL		0x02C
+#define QPHY_V7_PCS_UFS_TX_HSGEAR_CAPABILITY		0x060
+#define QPHY_V7_PCS_UFS_RX_HSGEAR_CAPABILITY		0x094
+#define QPHY_V7_PCS_UFS_LINECFG_DISABLE			0x140
+#define QPHY_V7_PCS_UFS_RX_SIGDET_CTRL2			0x150
+#define QPHY_V7_PCS_UFS_READY_STATUS			0x16c
+#define QPHY_V7_PCS_UFS_TX_MID_TERM_CTRL1		0x1b8
+#define QPHY_V7_PCS_UFS_MULTI_LANE_CTRL1		0x1c0
+
+#endif
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h
index d8ac4c4a2c31..d416113bcb3c 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v8.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2026, The Linux Foundation. All rights reserved.
  */
 
 #ifndef QCOM_PHY_QMP_QSERDES_COM_V8_H_
@@ -71,5 +71,16 @@
 #define QSERDES_V8_COM_ADDITIONAL_MISC			0x1b4
 #define QSERDES_V8_COM_CMN_STATUS			0x2c8
 #define QSERDES_V8_COM_C_READY_STATUS			0x2f0
+#define QSERDES_V8_COM_PLL_IVCO_MODE1				0xf8
+#define QSERDES_V8_COM_CMN_IETRIM				0xfc
+#define QSERDES_V8_COM_CMN_IPTRIM				0x100
+#define QSERDES_V8_COM_VCO_TUNE_CTRL				0x13c
+#define QSERDES_V8_COM_ADAPTIVE_ANALOG_CONFIG			0x268
+#define QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE0			0x26c
+#define QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE0		0x270
+#define QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE0			0x274
+#define QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE1			0x278
+#define QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE1		0x27c
+#define QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE1			0x280
 
 #endif
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
new file mode 100644
index 000000000000..5f923c3e64ec
--- /dev/null
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v8.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2026, The Linux Foundation. All rights reserved.
+ */
+
+#ifndef QCOM_PHY_QMP_QSERDES_TXRX_UFS_V8_H_
+#define QCOM_PHY_QMP_QSERDES_TXRX_UFS_V8_H_
+
+#define QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_TX		(0x34)
+#define QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_RX		(0x38)
+#define QSERDES_UFS_V8_TX_LANE_MODE_1				(0x80)
+#define QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE2			(0x1BC)
+#define QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE4			(0x1C4)
+#define QSERDES_UFS_V8_RX_UCDR_SO_GAIN_RATE4			(0x1DC)
+#define QSERDES_UFS_V8_RX_EQ_OFFSET_ADAPTOR_CNTRL1		(0x2C8)
+#define QSERDES_UFS_V8_RX_UCDR_PI_CONTROLS			(0x1E4)
+#define QSERDES_UFS_V8_RX_OFFSET_ADAPTOR_CNTRL3			(0x2D0)
+#define QSERDES_UFS_V8_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4	(0x120)
+#define QSERDES_UFS_V8_RX_UCDR_FASTLOCK_FO_GAIN_RATE4		(0xD4)
+#define QSERDES_UFS_V8_RX_UCDR_FASTLOCK_SO_GAIN_RATE4		(0xEC)
+#define QSERDES_UFS_V8_RX_VGA_CAL_MAN_VAL			(0x288)
+#define QSERDES_UFS_V8_RX_EQU_ADAPTOR_CNTRL4			(0x2B0)
+#define QSERDES_UFS_V8_RX_MODE_RATE_0_1_B4			(0x324)
+#define QSERDES_UFS_V8_RX_MODE_RATE4_SA_B7			(0x3B4)
+#define QSERDES_UFS_V8_RX_MODE_RATE4_SA_B9			(0x3BC)
+#define QSERDES_UFS_V8_RX_MODE_RATE4_SB_B7			(0x3E0)
+#define QSERDES_UFS_V8_RX_MODE_RATE4_SB_B9			(0x3E8)
+#define QSERDES_UFS_V8_RX_MODE_RATE5_SA_B7			(0x40C)
+#define QSERDES_UFS_V8_RX_MODE_RATE5_SA_B9			(0x414)
+#define QSERDES_UFS_V8_RX_MODE_RATE5_SB_B7			(0x438)
+#define QSERDES_UFS_V8_RX_MODE_RATE5_SB_B9			(0x440)
+#define QSERDES_UFS_V8_RX_UCDR_SO_SATURATION			(0xF4)
+#define QSERDES_UFS_V8_RX_TERM_BW_CTRL0				(0x1AC)
+#define QSERDES_UFS_V8_RX_DLL0_FTUNE_CTRL			(0x498)
+#define QSERDES_UFS_V8_RX_SIGDET_CAL_TRIM			(0x4d0)
+
+#endif
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index 0f4ad24aa405..d4aca22c181e 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -29,9 +29,11 @@
 #include "phy-qcom-qmp-pcs-ufs-v4.h"
 #include "phy-qcom-qmp-pcs-ufs-v5.h"
 #include "phy-qcom-qmp-pcs-ufs-v6.h"
+#include "phy-qcom-qmp-pcs-ufs-v7.h"
 
 #include "phy-qcom-qmp-qserdes-txrx-ufs-v6.h"
 #include "phy-qcom-qmp-qserdes-txrx-ufs-v7.h"
+#include "phy-qcom-qmp-qserdes-txrx-ufs-v8.h"
 
 /* QPHY_PCS_READY_STATUS bit */
 #define PCS_READY				BIT(0)
@@ -84,6 +86,13 @@ static const unsigned int ufsphy_v6_regs_layout[QPHY_LAYOUT_SIZE] = {
 	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V6_PCS_UFS_POWER_DOWN_CONTROL,
 };
 
+static const unsigned int ufsphy_v7_regs_layout[QPHY_LAYOUT_SIZE] = {
+	[QPHY_START_CTRL]		= QPHY_V7_PCS_UFS_PHY_START,
+	[QPHY_PCS_READY_STATUS]		= QPHY_V7_PCS_UFS_READY_STATUS,
+	[QPHY_SW_RESET]			= QPHY_V7_PCS_UFS_SW_RESET,
+	[QPHY_PCS_POWER_DOWN_CONTROL]	= QPHY_V7_PCS_UFS_POWER_DOWN_CONTROL,
+};
+
 static const struct qmp_phy_init_tbl milos_ufsphy_serdes[] = {
 	QMP_PHY_INIT_CFG(QSERDES_V6_COM_SYSCLK_EN_SEL, 0xd9),
 	QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_CONFIG_1, 0x16),
@@ -1307,6 +1316,11 @@ static const struct regulator_bulk_data sm8750_ufsphy_vreg_l[] = {
 	{ .supply = "vdda-pll", .init_load_uA = 18300 },
 };
 
+static const struct regulator_bulk_data hawi_ufsphy_vreg_l[] = {
+	{ .supply = "vdda-phy", .init_load_uA = 324000 },
+	{ .supply = "vdda-pll", .init_load_uA = 27000 },
+};
+
 static const struct qmp_ufs_offsets qmp_ufs_offsets = {
 	.serdes		= 0,
 	.pcs		= 0xc00,
@@ -1325,6 +1339,15 @@ static const struct qmp_ufs_offsets qmp_ufs_offsets_v6 = {
 	.rx2		= 0x1a00,
 };
 
+static const struct qmp_ufs_offsets qmp_ufs_offsets_v7 = {
+	.serdes		= 0,
+	.pcs		= 0x0400,
+	.tx		= 0x2000,
+	.rx		= 0x2000,
+	.tx2		= 0x3000,
+	.rx2		= 0x3000,
+};
+
 static const struct qmp_phy_cfg milos_ufsphy_cfg = {
 	.lanes			= 2,
 
@@ -1845,6 +1868,119 @@ static const struct qmp_phy_cfg sm8750_ufsphy_cfg = {
 
 };
 
+static const struct qmp_phy_init_tbl hawi_ufsphy_serdes[] = {
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_SYSCLK_EN_SEL, 0xd9),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_CONFIG_1, 0x16),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_HSCLK_SEL_1, 0x11),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_HSCLK_HS_SWITCH_SEL_1, 0x00),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP_EN, 0x01),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP_CFG, 0x60),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_IVCO, 0x1f),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_IVCO_MODE1, 0x1f),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_IETRIM, 0x07),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CMN_IPTRIM, 0x20),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_VCO_TUNE_MAP, 0x04),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_VCO_TUNE_CTRL, 0x40),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_ADAPTIVE_ANALOG_CONFIG, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_DEC_START_MODE0, 0x41),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_MODE0, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCTRL_MODE0, 0x18),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_MODE0, 0x14),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE0, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE0, 0x18),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE0, 0x14),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP1_MODE0, 0x7f),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP2_MODE0, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE1_MODE0, 0x92),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE2_MODE0, 0x1e),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_DEC_START_MODE1, 0x4c),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_MODE1, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCTRL_MODE1, 0x18),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_MODE1, 0x14),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_CP_CTRL_ADAPTIVE_MODE1, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_RCCTRL_ADAPTIVE_MODE1, 0x18),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_PLL_CCTRL_ADAPTIVE_MODE1, 0x14),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP1_MODE1, 0x99),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_LOCK_CMP2_MODE1, 0x07),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE1_MODE1, 0xbe),
+	QMP_PHY_INIT_CFG(QSERDES_V8_COM_BIN_VCOCAL_CMP_CODE2_MODE1, 0x23),
+};
+
+static const struct qmp_phy_init_tbl hawi_ufsphy_tx[] = {
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_LANE_MODE_1, 0x0c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_TX, 0x07),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_TX_RES_CODE_LANE_OFFSET_RX, 0x17),
+};
+
+static const struct qmp_phy_init_tbl hawi_ufsphy_rx[] = {
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE2, 0x0c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FO_GAIN_RATE4, 0x0c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_SO_GAIN_RATE4, 0x04),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_EQ_OFFSET_ADAPTOR_CNTRL1, 0x14),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_PI_CONTROLS, 0x07),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_OFFSET_ADAPTOR_CNTRL3, 0x0e),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4, 0x02),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FASTLOCK_FO_GAIN_RATE4, 0x1c),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_FASTLOCK_SO_GAIN_RATE4, 0x06),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_VGA_CAL_MAN_VAL, 0x8e),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_EQU_ADAPTOR_CNTRL4, 0x0f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE_0_1_B4, 0xb8),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SA_B7, 0x66),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SA_B9, 0x1f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SB_B7, 0x66),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE4_SB_B9, 0x1f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SA_B7, 0x66),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SA_B9, 0x1f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SB_B7, 0x66),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_MODE_RATE5_SB_B9, 0x1f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_UCDR_SO_SATURATION, 0x1f),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_TERM_BW_CTRL0, 0xfa),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_DLL0_FTUNE_CTRL, 0x30),
+	QMP_PHY_INIT_CFG(QSERDES_UFS_V8_RX_SIGDET_CAL_TRIM, 0x77),
+};
+
+static const struct qmp_phy_init_tbl hawi_ufsphy_pcs[] = {
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_PCS_CTRL1, 0x42),
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_LARGE_AMP_DRV_LVL, 0x0f),
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_RX_SIGDET_CTRL2, 0x68),
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
+};
+
+static const struct qmp_phy_init_tbl hawi_ufsphy_g5_pcs[] = {
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_PLL_CNTL, 0x3b),
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x05),
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x05),
+};
+
+static const struct qmp_phy_cfg hawi_ufsphy_cfg = {
+	.lanes			= 2,
+
+	.offsets		= &qmp_ufs_offsets_v7,
+	.max_supported_gear	= UFS_HS_G5,
+
+	.tbls = {
+		.serdes		= hawi_ufsphy_serdes,
+		.serdes_num	= ARRAY_SIZE(hawi_ufsphy_serdes),
+		.tx		= hawi_ufsphy_tx,
+		.tx_num		= ARRAY_SIZE(hawi_ufsphy_tx),
+		.rx		= hawi_ufsphy_rx,
+		.rx_num		= ARRAY_SIZE(hawi_ufsphy_rx),
+		.pcs		= hawi_ufsphy_pcs,
+		.pcs_num	= ARRAY_SIZE(hawi_ufsphy_pcs),
+	},
+
+	.tbls_hs_overlay[0] = {
+		.pcs		= hawi_ufsphy_g5_pcs,
+		.pcs_num	= ARRAY_SIZE(hawi_ufsphy_g5_pcs),
+		.max_gear	= UFS_HS_G5,
+	},
+
+	.vreg_list		= hawi_ufsphy_vreg_l,
+	.num_vregs		= ARRAY_SIZE(hawi_ufsphy_vreg_l),
+	.regs			= ufsphy_v7_regs_layout,
+};
+
 static void qmp_ufs_serdes_init(struct qmp_ufs *qmp, const struct qmp_phy_cfg_tbls *tbls)
 {
 	void __iomem *serdes = qmp->serdes;
@@ -2259,6 +2395,9 @@ static int qmp_ufs_probe(struct platform_device *pdev)
 
 static const struct of_device_id qmp_ufs_of_match_table[] = {
 	{
+		.compatible = "qcom,hawi-qmp-ufs-phy",
+		.data = &hawi_ufsphy_cfg,
+	}, {
 		.compatible = "qcom,milos-qmp-ufs-phy",
 		.data = &milos_ufsphy_cfg,
 	}, {
-- 
2.34.1

