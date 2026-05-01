Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BCE271443;
	Fri,  1 May 2026 13:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777641458; cv=none; b=sCLQCAy1vtDzVsDQNcT5SBspjeDl5Xg4esFKnE1uiqQ50FfOLTQIwizE+woUaL3ldLnxGEPYs5nRhvxgzkCyaBN0DCim1yubv4qrRkFt9yFP5HNlGM2o8ZgXo4m2X4WD59Kh7wfQpLeLVKQcOvZfpgTI/IKrE79uyJfy/vj/XdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777641458; c=relaxed/simple;
	bh=F21DW7zhgeYXDZdQO28lUx/4n6zk4IdiRywRVjUIcp0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gGnzKutY4hWILg+8fY0eb6Cofmpg8A/DtR6qkLlVUGUPN0hhkeMUriov8WzbL8+Bz/jWjjF5DqfKsBy8tgy33lrK8L+GJ19yQhpEqkwh9NFD73NsLlSWXfCxmiLRjzi1dIhkOGywyDGeQtaOsiaL2vCpCR5ZD0Itjk7tjSpWu7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kcq0uB6U; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kcq0uB6U"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 641AXKdU3951051;
	Fri, 1 May 2026 13:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=CkzKMvBiSpe
	l+nC8YAqqhb3MZNkFaEVO15jGJXSu1xU=; b=kcq0uB6UedV+LGiisM5E88EtVcE
	+NKaTdAjE64829r+GXwBUUf6dmGH627jsJ+W+dhxItVeEWioF7pQhjGPk758yrj/
	3c4oxDMH/4o3tH7DLyn+ATWITKopWFayoFwUivkOxA/qBL2XwvHrUMhTeQ4avZlN
	Kr37bV8sRrpDb8cQLyzZDHoHUayYWVKpbUTbAke2wz6nVS4vAaWnBoL8Fu4vUyWv
	lmswhcJJWkxcRmDPdmwQjtOyKjMWjU1jaBBN1g3IHD96W06SBQai17UgORcF7mH5
	cgFGFQBijvRjxfdhmkpuQbBhdNoXYWcfgoUzEjkd6Gc4/krVOH1TzPR9qsQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dvchkak2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:16:54 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 641DGrah013390;
	Fri, 1 May 2026 13:16:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4du6edmfvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:16:53 +0000 (GMT)
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 641DGqV7013379;
	Fri, 1 May 2026 13:16:53 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 641DGqhd013378
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:16:52 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id B57F05FC; Fri,  1 May 2026 06:16:52 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] scsi: ufs: core: Add a quirk for extended TX EQTR Adapt L0L1L2L3 length
Date: Fri,  1 May 2026 06:16:40 -0700
Message-Id: <20260501131641.826258-2-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDEyOSBTYWx0ZWRfX0MghlTpMR3R1
 zzfVUabQA6BogoPHhdRLj9lwQcU/0suUJUhGuo9bxaKqaAlZDoPKyc8kNT/PB2dr5fmfmaVltTB
 TzhLgQH2ihJ/HkbznaB6WeVeWgiA9k6G1VOlPaVDCFGLlYs9m6IR6yDoOX7f3O7HFs6U19jcnCc
 dgK8UnMnbtVb7pdfdl8om1JI6OkLz/MEh9sFSy1TkkYCWu6RpYxT+BAjksk7zGbW5Zx0QPJNVJW
 H6yCEmjllmk0tqlCNSSV9Zdo6hFaKWomCyIW16aLm0n8CYgBU4+9/2Qkey7eVth/UQEV1syj9mH
 CRLltx9bkfnUKXw3I452taSn1QTC07OmB4sUxr/wDtDxZQ4SB2CkNrnXKBCl0FVW7R3mTkiVWxg
 c4ZovwjaxhfAV+vuXUFtxr2NgMqEFULcMUN0TqQewDuQm0l+fjIj2Gx5SqHOCHh7T9SJTCAfcmW
 ca0H4a3woe0n4SOly1Q==
X-Authority-Analysis: v=2.4 cv=Zdkt8MVA c=1 sm=1 tr=0 ts=69f4a7c6 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8 a=K_dlAwRSWhGW3_DjcLgA:9
X-Proofpoint-ORIG-GUID: riw__3Anw45-2KJWE4-45-oS1XBaeJ4L
X-Proofpoint-GUID: riw__3Anw45-2KJWE4-45-oS1XBaeJ4L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-01_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605010129

Add a quirk to support TX Equalization Training (EQTR) using Adapt L0L1L2L3
length which is larger than what is allowed by M-PHY spec ver 6.0.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-txeq.c | 8 ++++++--
 include/ufs/ufshcd.h        | 7 +++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index b2dc89124353..fe647450a7a1 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -740,7 +740,9 @@ static int ufshcd_setup_tx_eqtr_adapt_length(struct ufs_hba *hba,
 		if (adapt_l0l1l2l3_cap_local > ADAPT_L0L1L2L3_LENGTH_MAX) {
 			dev_err(hba->dev, "local RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP (0x%x) exceeds MAX\n",
 				gear, adapt_l0l1l2l3_cap_local);
-			return -EINVAL;
+
+			if (!(hba->quirks & UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3))
+				return -EINVAL;
 		}
 
 		ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PEERRXHSG6ADAPTINITIALL0L1L2L3),
@@ -751,7 +753,9 @@ static int ufshcd_setup_tx_eqtr_adapt_length(struct ufs_hba *hba,
 		if (adapt_l0l1l2l3_cap_peer > ADAPT_L0L1L2L3_LENGTH_MAX) {
 			dev_err(hba->dev, "peer RX_HS_G%u_ADAPT_INITIAL_L0L1L2L3_CAP (0x%x) exceeds MAX\n",
 				gear, adapt_l0l1l2l3_cap_peer);
-			return -EINVAL;
+
+			if (!(hba->quirks & UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3))
+				return -EINVAL;
 		}
 
 		t_adapt_l0l1l2l3_local = adapt_cap_to_t_adapt_l0l1l2l3(adapt_l0l1l2l3_cap_local);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cfbc75d8df83..7a7c07636cf7 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -804,6 +804,13 @@ enum ufshcd_quirks {
 	 * delay after enabling VCC to ensure it's stable.
 	 */
 	UFSHCD_QUIRK_VCC_ON_DELAY			= 1 << 27,
+
+	/*
+	 * This quirk indicates that Host supports TX Equalization Training
+	 * (EQTR) using Adapt L0L1L2L3 length which is larger than what is
+	 * allowed by M-PHY spec ver 6.0.
+	 */
+	UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3	= 1 << 28,
 };
 
 enum ufshcd_caps {
-- 
2.34.1

