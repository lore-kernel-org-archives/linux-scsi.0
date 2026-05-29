Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11BD3546C8;
	Fri, 29 May 2026 01:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780017296; cv=none; b=ZHNGe852ZeKGg8DniyAb6ct7OCIQXBAhZPGcGiMNocVh6r1FsOscJZVL9x3CVsLkK62XfMyNI2xutiLhyhD/SsKIYasQxwDGYHL8ksMm3bRonagiUtvolKG1SZgENFSZgwnlragKr4Cj7Fv6YXsHJedkdNsp3U2cCAy4Dw3Zp+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780017296; c=relaxed/simple;
	bh=at7C4rVXy617FTxDNWThFKAjL6kTcfoN3AK39xgvug4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EUrT2syAP21Ftwv913d/yF9bBbF8DBPPqL0Ce7vppyKW6C7R6ZvzcPVAjw5Lh43njTBPJYBu/slH0ilXImXkdHJt0QEiBBjzEYLRXGuv2SCIwiBfteDWR+Cx7002UF0qVZpGYoAuJrAZpTjeekefvtFT2hsQztOpca5AtIntD/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wz5/UK+6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wz5/UK+6"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64SKkwjG1369478;
	Fri, 29 May 2026 01:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=KPBKEwoH+/9
	0aUWWxaPhUbiQBK5SaNCi2uDzGMcGWSI=; b=Wz5/UK+6m4W6Jq/6O4qlT/IHHaf
	ojNqu2xgUA561pNbW9nFx9QLpjw2tuGMDhv+VBjlmAx9SViUyZiVkQQPYKs/5iFC
	2gr1VZaVLhxsbXIGiua/32MqouC7mChujxli9TOCcJpCqJmYkpIKEGD+AZym74z8
	fwguFX4Rn1q8Ui9ytmsCcPa7iEX0c8qO+37ZMfcB4gXFUXo3qFcrWSLSESk87T4X
	XP9saVEuphIN3uj1iUT0RtPejo5HjBM5uKMb3bfaTxrm91QE+svSKDbTPu5+NHRL
	gblgfXBNEwGkzo40I72uBxRftu5OSVr4OvcGEJLrFUhpDNWQW70KDOPh4Cg==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eety5sn50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 01:14:39 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64T1EcJk017653;
	Fri, 29 May 2026 01:14:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4eej1spfmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 01:14:38 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64T1Ecup017640;
	Fri, 29 May 2026 01:14:38 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 64T1EcYs017637
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 29 May 2026 01:14:38 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 207C062E; Thu, 28 May 2026 18:14:38 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 2/2] scsi: ufs: core: Add support for static TX Equalization settings
Date: Thu, 28 May 2026 18:14:20 -0700
Message-Id: <20260529011421.462046-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
References: <20260529011421.462046-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-ORIG-GUID: lKKQPGU-drF7voyWb41RcRM9ERFPXHFW
X-Authority-Analysis: v=2.4 cv=TeqmcxQh c=1 sm=1 tr=0 ts=6a18e87f cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8 a=-xlrxDLzkpAifl49RugA:9
X-Proofpoint-GUID: lKKQPGU-drF7voyWb41RcRM9ERFPXHFW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI5MDAwOSBTYWx0ZWRfX5IyjjqJJ4CWf
 CLNiVgMMtYMGyL4236PxbEaYMYZk6NBNYu4Orqf7aQ98qsrRZW3IKNVO1m6uBsE/zOVkcBj3yqe
 dv9PjzCPGkND+y4COHhFLXnc1Fnaeb/wYHhDazPwTq+oZWtQQMyhrFlKn83ZTQNotIceJ+fo14N
 W2tUZsbQQQhLwwN5OBjv01eWYuMb8OhFkI7gRHM1YbpA9SD3YVn1TRDYccaIayrMgnNWdrpFLk3
 edbss3FEUcfY9/Quod4B5Wv4LBqgBNT19i/qnr4+WIc3vRfZs436K27fifjk+lBk8lM31k//s7n
 puJLA5homx4MzAQSY4k76/ZdqRYcCLxEt5pdTUBkhorwRv8iDsp+Me5TDXPb045eo2u/4uYmu8t
 29l43Njwp/j1OWGHXL4EyW6Vs0lRDYJkIgpXdKCtpW4cWjF/i9KfPnPObUIrJ6aRrLUU9etVwFe
 nj3DA1xJOP53WZoPY2A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-28_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2605290009

Static TX Equalization settings and TX Precode enable indication from DT
properties txeq-preshoot-g[1-6], txeq-deemphasis-g[1-6], and
tx-precode-enable-g6 are board-specific baseline values. Values are
provided as per-lane tuples:

<Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>]

Parse DT u32 properties with explicit range checks by using
of_property_count_u32_elems()/of_property_read_u32_array().

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
 drivers/ufs/core/ufs-txeq.c      |  10 ++-
 drivers/ufs/host/ufshcd-pltfrm.c | 137 +++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h             |   2 +
 3 files changed, 148 insertions(+), 1 deletion(-)

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
index c2dafb583cf5..c498ea6a86a3 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -210,6 +210,141 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 	}
 }
 
+/**
+ * ufshcd_parse_tx_eq_settings_for_gear - Parse static TX EQ DT settings for one gear
+ * @hba: per adapter instance
+ * @gear: target HS gear
+ * @num_elems: expected number of elements per property
+ *
+ * Reads the txeq-preshoot-gN, txeq-deemphasis-gN, and (for G6)
+ * tx-precode-enable-gN device-tree properties and, if all are valid, stores
+ * them as static TX Equalization settings for the given gear.
+ */
+static void ufshcd_parse_tx_eq_settings_for_gear(struct ufs_hba *hba,
+						 int gear, const u32 num_elems)
+{
+	u32 precode_en[UFS_MAX_LANES * 2] = { 0 };
+	const u32 lpd = hba->lanes_per_direction;
+	struct ufshcd_tx_eq_params *params;
+	u32 deemphasis[UFS_MAX_LANES * 2];
+	u32 preshoot[UFS_MAX_LANES * 2];
+	struct device *dev = hba->dev;
+	char prop_name[MAX_PROP_SIZE];
+	int i, err, lane, count;
+
+	snprintf(prop_name, MAX_PROP_SIZE, "txeq-preshoot-g%d", gear);
+	count = of_property_count_u32_elems(dev->of_node, prop_name);
+	if (count <= 0)
+		return;
+
+	if (count != num_elems) {
+		dev_err(dev, "Property %s has invalid count (%d), expecting %u\n",
+			prop_name, count, num_elems);
+		return;
+	}
+
+	err = of_property_read_u32_array(dev->of_node, prop_name, preshoot, num_elems);
+	if (err) {
+		dev_err(dev, "Failed to read %s property, %d\n", prop_name, err);
+		return;
+	}
+
+	for (i = 0; i < count; i++) {
+		if (preshoot[i] >= TX_HS_NUM_PRESHOOT) {
+			dev_err(dev, "An invalid TX EQ PreShoot (%d) provided in %s property\n",
+				preshoot[i], prop_name);
+			return;
+		}
+	}
+
+	snprintf(prop_name, MAX_PROP_SIZE, "txeq-deemphasis-g%d", gear);
+	count = of_property_count_u32_elems(dev->of_node, prop_name);
+	if (count <= 0) {
+		dev_err(dev, "Missing required %s property\n", prop_name);
+		return;
+	}
+
+	if (count != num_elems) {
+		dev_err(dev, "Property %s has invalid count (%d), expecting %u\n",
+			prop_name, count, num_elems);
+		return;
+	}
+
+	err = of_property_read_u32_array(dev->of_node, prop_name, deemphasis, num_elems);
+	if (err) {
+		dev_err(dev, "Failed to read %s property, %d\n", prop_name, err);
+		return;
+	}
+
+	for (i = 0; i < count; i++) {
+		if (deemphasis[i] >= TX_HS_NUM_DEEMPHASIS) {
+			dev_err(dev, "An invalid TX EQ DeEmphasis (%d) provided in %s property\n",
+				deemphasis[i], prop_name);
+			return;
+		}
+	}
+
+	if (gear == UFS_HS_G6) {
+		snprintf(prop_name, MAX_PROP_SIZE, "tx-precode-enable-g%d", gear);
+		count = of_property_count_u32_elems(dev->of_node, prop_name);
+		if (count > 0) {
+			if (count != num_elems) {
+				dev_err(dev, "Property %s has invalid count (%d), expecting %u\n",
+					prop_name, count, num_elems);
+				return;
+			}
+
+			err = of_property_read_u32_array(dev->of_node, prop_name,
+							 precode_en, num_elems);
+			if (err) {
+				dev_err(dev, "Failed to read %s property, %d\n",
+					prop_name, err);
+				return;
+			}
+
+			for (i = 0; i < count; i++) {
+				if (precode_en[i] > 1) {
+					dev_err(dev, "An invalid PrecodeEn (%d) provided in %s property\n",
+						precode_en[i], prop_name);
+					return;
+				}
+			}
+		}
+	}
+
+	params = &hba->tx_eq_params[gear - 1];
+	for (lane = 0; lane < lpd; lane++) {
+		params->host[lane].preshoot = preshoot[lane * 2];
+		params->host[lane].deemphasis = deemphasis[lane * 2];
+		params->host[lane].precode_en = precode_en[lane * 2];
+
+		params->device[lane].preshoot = preshoot[lane * 2 + 1];
+		params->device[lane].deemphasis = deemphasis[lane * 2 + 1];
+		params->device[lane].precode_en = precode_en[lane * 2 + 1];
+	}
+
+	params->is_valid = true;
+	params->is_static = true;
+}
+
+static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
+{
+	const u32 lpd = hba->lanes_per_direction;
+	const u32 num_elems = lpd * 2;
+	int gear;
+
+	if (!lpd) {
+		return;
+	} else if (lpd > UFS_MAX_LANES) {
+		dev_warn(hba->dev, "lanes_per_direction (%u) exceeds UFS_MAX_LANES (%u)\n",
+			 lpd, UFS_MAX_LANES);
+		return;
+	}
+
+	for (gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++)
+		ufshcd_parse_tx_eq_settings_for_gear(hba, gear, num_elems);
+}
+
 /**
  * ufshcd_parse_clock_min_max_freq  - Parse MIN and MAX clocks freq
  * @hba: per adapter instance
@@ -528,6 +663,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
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

