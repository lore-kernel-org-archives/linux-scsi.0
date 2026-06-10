Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B91389104;
	Wed, 10 Jun 2026 07:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781075751; cv=none; b=rXvr0GrbE0MOZoYOv5W2pKt/rgtWDAAG9sQxB/RognLyOzIsala47ytMncavIDO6BiKYSUhV6d/6vSnD+4mwowLxDxnhL2CeAsQ0b6Z3KMNNHgm2kvHARxgh+mjWnQw5sB4M+H5A+yu6N/gbt0RgRlX8Yk3DYR54yKmnnx2KkF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781075751; c=relaxed/simple;
	bh=PHcr0SQGOxR2ANEitoNgxbhhLmgyge2ePpPkE8vw5xc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XmMrz4jdbw5ovb3tKKZky9sJBld4jJVctwmxDh4qbT+Wq4gYR3vpdJdtcogRvlx+mVtxjALmXaNXrMeqhWWnLtvSR094o0CyhJTUrwmwl7IGkQG4VaBAoAcPc/KWd8hAok8lqF77I6CNusPzZkojdl1xfD1xSJCzP7n1wmeQFzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fUdEhk9u; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fUdEhk9u"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65A2ehAA2481622;
	Wed, 10 Jun 2026 07:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=bZeAo1jX2j2
	m/uBFoZJ08klhOzsIks5HW8h3fu30jJc=; b=fUdEhk9uO7bEABiIof5kY+cDHqP
	G1aB/9sr+Ts8GwJ02ckJHJc/ovRzVh4w76sAmW56kk5aYYxhdgl84hOkVc54fzwD
	93gLb/CI2tq9zV6EoDsPj0dTD1/NYpqEfeeL42GtxYIOXV3/tbL71bJXqzj6m23j
	3e7DnhJ4qEIpZ0Xop8w6pzbPM6R11gYLY/w3698LbMR2YWqn+NBDJaKuvSg3CvxS
	JyMeWkosaOaXgKQ59H80iz9fe2JD4FB0bLhewPaGeX44DnWBOZcpp1OPstaZRqhE
	HORvLF3walfhamR76ecnrDH0K4sXq2gn0fxIgr3TtguRnwHVUXrnfK56Pbg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epwnes7yx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:15:37 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65A7Euew004018;
	Wed, 10 Jun 2026 07:15:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4epx0kjxsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:15:36 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65A7EtM3004012;
	Wed, 10 Jun 2026 07:15:36 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 65A7FZTs005345
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jun 2026 07:15:36 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id DB60F619; Wed, 10 Jun 2026 00:15:35 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 2/2] scsi: ufs: core: Add support for static TX Equalization settings
Date: Wed, 10 Jun 2026 00:15:15 -0700
Message-Id: <20260610071516.3763916-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
References: <20260610071516.3763916-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-GUID: 2LwyB61l44uJDRoMSeYJBa4Vp0Mxw0xt
X-Authority-Analysis: v=2.4 cv=ebYNubEH c=1 sm=1 tr=0 ts=6a290f19 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8 a=dHVp21D2o_8EOPIO518A:9
X-Proofpoint-ORIG-GUID: 2LwyB61l44uJDRoMSeYJBa4Vp0Mxw0xt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEwMDA2NyBTYWx0ZWRfXwwlUTp/bWOuQ
 PTZPmT7crubX9INS50xA6NnCGjiOEcR7KPdcpT+tNqFP/y7fbYTvPFZGvjPSgdBE1j5QaqFptAi
 oJPpkAW8x3QJ1JMJNEP6gcu2ybw/jQiPeaKhdJkcU89GYjq3E2Nsh26V0EYcAY7gnJ+QzFAdrYG
 ixOxm+4lCRL4KeykSiyR4UW/bnF0r5L3iQjHNXtQUXAZoWkXAiRGHqLLrv8SldNnMSvdwNzSVOn
 fD3+3OtxLHC3BJ93Ur/kED2vDtqRwKX9htXhf0iQ1cfYRSImM8gtQgnWV7OeLtIm4ddTU5LGehm
 oHDt8O7+wS+TZppNSfpzEW0udY92+F8aa/gwQ6zkntKkYIS93eUnXn7ii+5rYqaKpGKCCsg/lt9
 NJuXxTXn7jtJ5c9EpU8XuLSBnA7m4H6KpJCXuyrUA9CkWIrz1ahIJtHfX0bRfwjyZ5qiXji6DGf
 80nJjqjj70G9KfgfV7g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-10_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 spamscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606100067

Parse board-specific static TX Equalization settings from DT for each HS
gear and store them in hba->tx_eq_params.

Parse txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6] as per-lane tuples:
<Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]

For HS-G6, parse optional lane lists:
- tx-precode-g6-host-lanes
- tx-precode-g6-device-lanes

Introduce is_static in struct ufshcd_tx_eq_params to track whether TX EQ
values came from static DT data.

When adaptive TX Equalization is used, these static settings are not final:

- If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
  those retrieved settings override static DT settings.
- If retrieval is not available/valid, TX EQTR runs and trained settings
  override static DT settings.

So static DT settings are a fallback and are intended for cases where
adaptive TX Equalization is not enabled/used. Adaptive TX Equalization
remains the primary path when enabled.

No behavior changes for platforms that do not provide these properties.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-txeq.c      |  10 +-
 drivers/ufs/host/ufshcd-pltfrm.c | 159 +++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h             |   2 +
 3 files changed, 170 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 4b264adfdf49..b645fe5f6d95 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -1297,7 +1297,13 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 	}
 
 	params = &hba->tx_eq_params[gear - 1];
-	if (!params->is_valid || force_tx_eqtr) {
+	/*
+	 * TX EQTR must run for the following cases:
+	 * 1. TX EQ settings are invalid.
+	 * 2. TX EQ settings are valid but static, i.e., populated from DT.
+	 * 3. TX EQTR procedure is forced.
+	 */
+	if (!params->is_valid || params->is_static || force_tx_eqtr) {
 		int ret;
 
 		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
@@ -1310,6 +1316,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 		/* Mark TX Equalization settings as valid */
 		params->is_valid = true;
 		params->is_trained = true;
+		params->is_static = false;
 		params->is_applied = false;
 	}
 
@@ -1495,6 +1502,7 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
 	}
 
 	params->is_valid = true;
+	params->is_static = false;
 }
 
 void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba)
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index c2dafb583cf5..e8b352f5b68f 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -210,6 +210,163 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 	}
 }
 
+static int ufshcd_parse_tx_precode_lane_list(struct ufs_hba *hba,
+					     const char *prop_name,
+					     bool precode_en[UFS_MAX_LANES])
+{
+	const u32 lpd = hba->lanes_per_direction;
+	struct device *dev = hba->dev;
+	u32 lane_ids[UFS_MAX_LANES];
+	int len, count, err, i;
+	struct property *prop;
+
+	prop = of_find_property(dev->of_node, prop_name, &len);
+	if (!prop || !len)
+		return 0;
+
+	count = of_property_count_u32_elems(dev->of_node, prop_name);
+	if (count < 0) {
+		dev_err(dev, "Property %s is malformed, %d\n", prop_name, count);
+		return count;
+	}
+
+	if (count > lpd) {
+		dev_err(dev, "Property %s has invalid count (%d), max %u\n",
+			prop_name, count, lpd);
+		return -EINVAL;
+	}
+
+	err = of_property_read_u32_array(dev->of_node, prop_name, lane_ids, count);
+	if (err) {
+		dev_err(dev, "Failed to read %s property, %d\n", prop_name, err);
+		return err;
+	}
+
+	for (i = 0; i < count; i++) {
+		if (lane_ids[i] >= lpd) {
+			dev_err(dev, "Invalid lane index %u provided in %s property\n",
+				lane_ids[i], prop_name);
+			return -EINVAL;
+		}
+
+		precode_en[lane_ids[i]] = true;
+	}
+
+	return 0;
+}
+
+static int ufshcd_parse_tx_eq_value_array(struct ufs_hba *hba,
+					  const char *prop_name,
+					  const u32 max_value,
+					  u32 values[UFS_MAX_LANES * 2])
+{
+	u32 num_elems = 2 * hba->lanes_per_direction;
+	struct device *dev = hba->dev;
+	int count, err, i;
+
+	count = of_property_count_u32_elems(dev->of_node, prop_name);
+	if (count <= 0)
+		return count ? count : -ENOENT;
+
+	if (count != num_elems) {
+		dev_err(dev, "Property %s has invalid count (%d), expecting %u\n",
+			prop_name, count, num_elems);
+		return -EINVAL;
+	}
+
+	err = of_property_read_u32_array(dev->of_node, prop_name, values, num_elems);
+	if (err) {
+		dev_err(dev, "Failed to read %s property, %d\n", prop_name, err);
+		return err;
+	}
+
+	for (i = 0; i < num_elems; i++) {
+		if (values[i] >= max_value) {
+			dev_err(dev, "Invalid TX EQ value (%u) in %s property\n",
+				values[i], prop_name);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ufshcd_parse_tx_eq_settings_for_gear - Parse static TX EQ DT settings for one gear
+ * @hba: per adapter instance
+ * @gear: target HS gear
+ *
+ * Reads the txeq-preshoot-gN, txeq-deemphasis-gN, and (for G6)
+ * tx-precode-g6-host-lanes/tx-precode-g6-device-lanes device-tree properties.
+ * If all present values are valid, stores them as static TX Equalization
+ * settings for the given gear.
+ */
+static void ufshcd_parse_tx_eq_settings_for_gear(struct ufs_hba *hba, int gear)
+{
+	bool device_precode_en[UFS_MAX_LANES] = { false };
+	bool host_precode_en[UFS_MAX_LANES] = { false };
+	const u32 lpd = hba->lanes_per_direction;
+	struct ufshcd_tx_eq_params *params;
+	u32 deemphasis[UFS_MAX_LANES * 2];
+	u32 preshoot[UFS_MAX_LANES * 2];
+	char prop_name[MAX_PROP_SIZE];
+	int err, lane;
+
+	snprintf(prop_name, MAX_PROP_SIZE, "txeq-preshoot-g%d", gear);
+	err = ufshcd_parse_tx_eq_value_array(hba, prop_name, TX_HS_NUM_PRESHOOT, preshoot);
+	if (err)
+		return;
+
+	snprintf(prop_name, MAX_PROP_SIZE, "txeq-deemphasis-g%d", gear);
+	err = ufshcd_parse_tx_eq_value_array(hba, prop_name, TX_HS_NUM_DEEMPHASIS, deemphasis);
+	if (err)
+		return;
+
+	if (gear == UFS_HS_G6) {
+		err = ufshcd_parse_tx_precode_lane_list(hba, "tx-precode-g6-host-lanes",
+							host_precode_en);
+		if (err)
+			return;
+
+		err = ufshcd_parse_tx_precode_lane_list(hba, "tx-precode-g6-device-lanes",
+							device_precode_en);
+		if (err)
+			return;
+	}
+
+	params = &hba->tx_eq_params[gear - 1];
+	for (lane = 0; lane < lpd; lane++) {
+		params->host[lane].preshoot = preshoot[lane * 2];
+		params->host[lane].deemphasis = deemphasis[lane * 2];
+		params->host[lane].precode_en = host_precode_en[lane];
+
+		params->device[lane].preshoot = preshoot[lane * 2 + 1];
+		params->device[lane].deemphasis = deemphasis[lane * 2 + 1];
+		params->device[lane].precode_en = device_precode_en[lane];
+	}
+
+	params->is_valid = true;
+	params->is_static = true;
+}
+
+static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
+{
+	const u32 lpd = hba->lanes_per_direction;
+	int gear;
+
+	if (!lpd)
+		return;
+
+	if (lpd > UFS_MAX_LANES) {
+		dev_warn(hba->dev, "lanes_per_direction (%u) exceeds UFS_MAX_LANES (%u)\n",
+			 lpd, UFS_MAX_LANES);
+		return;
+	}
+
+	for (gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++)
+		ufshcd_parse_tx_eq_settings_for_gear(hba, gear);
+}
+
 /**
  * ufshcd_parse_clock_min_max_freq  - Parse MIN and MAX clocks freq
  * @hba: per adapter instance
@@ -528,6 +685,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	ufshcd_init_lanes_per_dir(hba);
 
+	ufshcd_parse_static_tx_eq_settings(hba);
+
 	err = ufshcd_parse_operating_points(hba);
 	if (err) {
 		dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f48d6416e299..c01824576472 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -359,6 +359,7 @@ struct ufshcd_tx_eqtr_record {
  * @is_valid: True if parameter contains valid TX Equalization settings
  * @is_applied: True if settings have been applied to UniPro of both sides
  * @is_trained: True if parameters obtained from TX EQTR procedure
+ * @is_static: True if settings are static
  */
 struct ufshcd_tx_eq_params {
 	struct ufshcd_tx_eq_settings host[UFS_MAX_LANES];
@@ -367,6 +368,7 @@ struct ufshcd_tx_eq_params {
 	bool is_valid;
 	bool is_applied;
 	bool is_trained;
+	bool is_static;
 };
 
 /**
-- 
2.34.1

