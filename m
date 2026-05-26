Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153353D3326
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779786639; cv=none; b=NdOUVnUpqwHZDk6xZ3FQ7ITEKjw2Ck/iVlI9+XnkHZfW66/S3C6Twt/ZEBN+QRddgKZLfa6OD8IkDM9u7iGUIFp/FSJLtx6G9yE+fYbRfBBWDQP6Zu5J8yFpQ5OPqwzY2XU4O6yEBsWXTkTfmfv5B4CTWxTG/ZvmcCfvw0WV/6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779786639; c=relaxed/simple;
	bh=2hrIrmAqSpXuicpv7cLYxJ838YKWPvx+p3taI1iQ3nU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cOb0tnI19Mmrre4eKKvZvToNgtcA+jy7S0ssGEPVllHW3mwAweiNYdKXaN0P1uPS+JfnMpAjxiTo/vqhMJCOv2dajC+EIASzPi2NM0DHhfS2bBmbaF3XCG9wFNyDxUUEbiFvaG1xw95xY1oHGfFGEhUkUx6AmSnmVfEwtBGAXww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LKZIn1gB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eehMcEjx; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LKZIn1gB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eehMcEjx"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64Q5Ub8Y2145983
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=ELC1WVXx49I
	opuMrgqrm+MdjBpXziP4zWs2sr55Q2Rs=; b=LKZIn1gBLIhcPFSXT/e1v06U+Kb
	BsSsjDBVMVlMRwkKrb31FdNSohmFgGLLD55uu+UGNdKbMIgoxzy2FkHZQFW/ZcLU
	L9TliFHvas7h7IwYjr/dj7KPfDjFSWsnJp5tkqCPdtgRJfGcZ/bmq531m2Jx/YnD
	XhBnFhsfzue1D5SC6ZhAzzrM6dTMaALKYwIv4ai6mLr3fgpMv1p+/OgpNIIr+OJR
	JdpGRtxyTgmqdOWFRQfmEYX7e/25dp/2FL4ea6Uf8kYlwUH+GiFPzSz91nSWQ5y4
	d/FnafWWInTVBCbgYAPXU/AKzaWYbBHUO01OUvswxzMJIqBHRAuPy5rSidA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecmbv3w3n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 09:10:36 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ba115ab6bbso113383815ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 02:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779786636; x=1780391436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELC1WVXx49IopuMrgqrm+MdjBpXziP4zWs2sr55Q2Rs=;
        b=eehMcEjxWwYt7dMYGeqm7v/r1yiWM/p6jikIG7y69i5Kl16iVQuNxwlDvcGqpUdOGa
         CvAFCWlUfKQiHk7Fed5Pjmnaq2o7vPW+g0PJSFkyl47thOmbsW5t+b8gDCxBiChQH2lo
         300UgpSbQxOs22mK8nXPEgER8JOB3qBW1p5vuinTtWQ7lK08GMjwwlNUt0yKVrCQQ9dM
         TjHDVAk9ybxwhEz+V9XgCZ9SksZ9gy8PR50G65WROAB3yO3ecMV07z6gHYgssawplohX
         SwK27JPvQxiFHkRYRW6MrnoITHsbE8Z22O0P59et48bMqsiSGLSSBZnrE0kvXeobszlg
         T9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779786636; x=1780391436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ELC1WVXx49IopuMrgqrm+MdjBpXziP4zWs2sr55Q2Rs=;
        b=KZFqnZtRPgMgFsdHOXLTT6SVfccVrqLcAO5SM8920A7W+rdBr8NtD5i/REccr8s5Un
         qfk4DuwASlrr7Kh7keFfKO1iSZRq9xXf1X0Vbqodt2Kk+4PMkBALpKepIFdsHr0CVGef
         7q7zgonPvYgQ3SNPhjux4v/FPFKykRlapR2rBxr4FCMQue0oNvL+XaoAY62H7zDWDlKC
         H+M1FQ2zZt9Dl2EIVXkvBUP+d+z8/NDj4iYldfCq/x5K7F8XBXWALOt0I96XI4RcpvkH
         GQvb1XGG9gxb1Jl/cFRCFBWtwk0pZLAXQCZ9sRW7VtvdF40rfgpFjM3HKRe6acXpCUpR
         WNag==
X-Forwarded-Encrypted: i=1; AFNElJ/HXMfHk3btVRRZmosre9JNkWZ76tNo6xz4OQT3ejukDTvWviaFmuPLsLTATWSYdtDGA5hfBopGq8xN@vger.kernel.org
X-Gm-Message-State: AOJu0YztBlnIGk6ACddXBI6rAR+lbu8fmw1veM1HEo7lR80bnDOczPun
	EzZhI1WJagsv7JmR8tZr0kC58hsxU+3ar+lDFjHwVFdMCc2dqjjk8X8oCiq+LpA7F8UmE4nAky/
	bgu737gnbqCOIn6mxwtH7S4DmwMmncGisyeqVvWfoWls0nZRD9t/K0XcFI8qcFbz5
X-Gm-Gg: Acq92OGscmf7MRJE3PtmzWI83jn3hUv1WJ+/NzxWFXUKkmGcyE/cw7w+WJ5prNcqgKD
	PunIcB8R92M0dLV3KAW2bXzM3SOT3hr+oKXxbiTXmc6iPnPvezRMgVZBAly5N8RnFZAAmoYcZ4U
	1ybMzQ4bdK/6G+xb8f7Bn0IkcVO+oRL0SNzpDspmaFn3PxWw+q/bjXiSNWA7Qo+oR2F2ScRRSB1
	9K6++mCMvVOkcJagmdaOjhq9OiVLxxyMfEWJYWuRfGcFSxtBnuF4+CaQRb1qKyzm4EYZNz8lCzx
	RHNe5ebORo7kx/vCdCa7ogfkOimspxzraQ1WanhrY96AhKhaiX2+y8y4oE5D3++JDg0JRtZul20
	RtIWNpKn5hO11c/0geXlgWg/td7ejg5SCwVyYqxV1CeDjTACl8uO9iw==
X-Received: by 2002:a17:902:e74f:b0:2b2:58c7:2ce1 with SMTP id d9443c01a7336-2beb07da2dcmr180143265ad.36.1779786635427;
        Tue, 26 May 2026 02:10:35 -0700 (PDT)
X-Received: by 2002:a17:902:e74f:b0:2b2:58c7:2ce1 with SMTP id d9443c01a7336-2beb07da2dcmr180142845ad.36.1779786634918;
        Tue, 26 May 2026 02:10:34 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5695a40sm109237915ad.17.2026.05.26.02.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 02:10:34 -0700 (PDT)
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
Subject: [PATCH v3 3/3] phy: qcom-qmp-ufs: Add UFS PHY support on Hawi
Date: Tue, 26 May 2026 14:39:56 +0530
Message-Id: <20260526090956.2340262-4-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
References: <20260526090956.2340262-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDA3OSBTYWx0ZWRfX4sj0PZ3sddT9
 8SYaaLZJBOuA5PnygP92GPN6DB7/czPrD+pKJWeWi0BCxCWJa2F1d9GV+ywD5Bj+3f2ioBekfHe
 WdjsrIgdaqnioQI0xtuWpQ2MjxieCQRvfIA9CCH+Yk+Qw0up8fseAkLyQfJmivoEair6ylrquDK
 983774Ua6gamw/joYBXoIaNbPZQ2GtPhHxp+bvaW1s2v3S5JhtohbYYmcgQGn8y8+NaDgkgFtk1
 5w5bfHSjNOT3W56ibkw3UCKXT4cyNz2xxBaA5XhQeqIw/bGrtjZtfC4I8lPVDTZn8/Oxb8FBYEH
 Dqisi8DO3gNJ7rX0C4teDsVLxeCRdPCioprqDflJvOO/VKkIEl2XUmlgRMmA054DEil/SsHjSe0
 ckaSsEWeN09x5w7jLzcPgdwzY760Av+PVM4uV6niB4xwLogeVPxzNA8Pji9kTbgWaSUmZsw6eV+
 EslftsDqOb6twyY/dyg==
X-Proofpoint-GUID: ctfK6hV5CJosvys0TFVpXvOAQxNuROb5
X-Proofpoint-ORIG-GUID: ctfK6hV5CJosvys0TFVpXvOAQxNuROb5
X-Authority-Analysis: v=2.4 cv=XqTK/1F9 c=1 sm=1 tr=0 ts=6a15638c cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=h_in7VWVVixVgI9GMPYA:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-26_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605260079

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

Add the init sequence tables and config for the UFS QMP phy found in
the Hawi SoC.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 .../phy/qualcomm/phy-qcom-qmp-pcs-ufs-v7.h    |  24 +++
 .../phy-qcom-qmp-qserdes-txrx-ufs-v8.h        |  37 +++++
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c       | 139 ++++++++++++++++++
 3 files changed, 200 insertions(+)
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
index 771bc7c2ab50..2fac3a7eb820 100644
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
@@ -1306,6 +1315,11 @@ static const struct regulator_bulk_data sm8750_ufsphy_vreg_l[] = {
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
@@ -1324,6 +1338,15 @@ static const struct qmp_ufs_offsets qmp_ufs_offsets_v6 = {
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
 
@@ -1844,6 +1867,119 @@ static const struct qmp_phy_cfg sm8750_ufsphy_cfg = {
 
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
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x06),
+	QMP_PHY_INIT_CFG(QPHY_V7_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x06),
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
@@ -2258,6 +2394,9 @@ static int qmp_ufs_probe(struct platform_device *pdev)
 
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

