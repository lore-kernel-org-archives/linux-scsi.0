Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3124935C183;
	Mon, 15 Jun 2026 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530147; cv=none; b=M/MGXX8QthfJ4NQPC21i6mIImVMmJoXJzf1CzxpqeWl28oFLBJQ3FRZtQEN5FWgwumqVvIOdFBcK47cGrDc39pt2fxVy7AZDlgYmeCi9lOrjv76/U4o8XH0Y9mrk6pr952wYM/VQmf8rXdb52exjSDDKfPvWL7M4NRjOTjjii2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530147; c=relaxed/simple;
	bh=814Xbez1Ko0lWUeJqwx5q5pgzSf02EfOjm634q/0h68=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MyAO5P25OMiNPOO7Kqyspg1l0oTzzcmGpYY75MSWbiNHu7GHqsjQ2NbTPhK2HnqjgmJpFcMEJBzm35QQBkVCNFw3BLCM1M5nbaAbWlceVJDlU4OkDtuslJ0zC9vX+8GplRaf67SSYYPWxGilXPd3t3sYLrGMo5bKceY7qaDolNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mpHQ8UYI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mpHQ8UYI"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FCbm0N568219;
	Mon, 15 Jun 2026 13:28:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=C07zEFxMjel
	DBx86ZqHxUyrqmvGLkOJGO5+egHNVAaI=; b=mpHQ8UYI8Oy9zPZk1qOgitL2N5m
	03SAxs33gJ7sHpG3dwp8W8mkQAr4L3ZmLzDBWavh1OCgcHPh3ZiM0u2njmuJqFd7
	tjQvPkiEoDPkubIyDuKDEeUDbbRTaMGcA/X3uDoFyoRCEQvd8ZXeRwnLnjn50swE
	/q35WurL8Le3EPxSQqP6ZCL1CDy2Ads8WifTAnG4uVlJq/GzyiMuSHwREwkD0ssz
	UAonV9HryvAhuouH64+F4QmE4veGzwbNZMvpl/A/PKSUX4wK/tDXMqTJg6UdB+bS
	FOc5ltC12LI/dBmVr3fTwyb/1361BlhALK64did1ESnKMB9bk9J1JziR6GQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4etgvhgbgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 13:28:52 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 65FDRaDG003083;
	Mon, 15 Jun 2026 13:28:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4et5v8eh72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 13:28:51 +0000 (GMT)
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65FDSpoA004339;
	Mon, 15 Jun 2026 13:28:51 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 65FDSosc004338
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Jun 2026 13:28:51 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 0C5EA657; Mon, 15 Jun 2026 06:28:51 -0700 (PDT)
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
Subject: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX Equalization settings
Date: Mon, 15 Jun 2026 06:28:34 -0700
Message-Id: <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE1MDE0MiBTYWx0ZWRfX+C0MRhDcpXlH
 50wjW5jhRt6VSt3vQpddwAPcsCcQVklAh629u6myq/bkPCE6w1lNFB7ivggP2J3dWgedMaFsNta
 kygfX7XNbFqKlf38iHTCy16PgefafyY=
X-Authority-Analysis: v=2.4 cv=Zqnd7d7G c=1 sm=1 tr=0 ts=6a2ffe14 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8 a=mPEsZNRqivZz7kMXn-sA:9
X-Proofpoint-GUID: 363LlCN6vWrSWN4G097Aedj0wn8-KijB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE1MDE0MiBTYWx0ZWRfX9jhuimLXuQx1
 o0kcx0o8RK/CKuaVUyOgB54tYJHJArjk6cbBzlTJ5Bt9CVkA2ai7mBK+IwEh2yN0yrs/x38bMNR
 Legn2kEYnUdtz0z46wN05k4t9BzD0VJVAocEUw35/n7j5ylQ9aVgsgUoI6CmcbO9biIE9VAL0TC
 +K7IZdowjKbWj47vwrgHkOnfVYYFqRtTAOPcv1TCjA8ksC3amnue5RzNjQ9OcKU4tkHFOg2nt69
 71u0f0hvQ6q/EtyNZW6vKEm+xO6aRE2T7ScqNZSC7A/s2++VjlS4KR9RtrtZ5L8ow4pKshEhX/a
 YxYAF/TTD7vrxCWva0jsEXeppnQRt5zwskmUE0ZlkUl7RuR8lDa24yjF6nF2y28vkieKmq0jLyd
 Z+Q9Zfw96Wb7YyPiFf8DlGdvzJy+W4KPBVgWRuwwOI+1X8/7IULd8WGlmHRxFblcBEXFPwYFw3L
 SS24atkdEN4pEpKLvtQ==
X-Proofpoint-ORIG-GUID: 363LlCN6vWrSWN4G097Aedj0wn8-KijB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-15_03,2026-06-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 clxscore=1015 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606150142

Parse board-specific static TX Equalization settings from Device Tree for
each HS gear and store them in hba->tx_eq_params.

Parse txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6] as per-lane tuples:
<Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].

For HS-G6, parse optional tx-precode-enable-g6 using the same per-lane
Host/Device tuple format. If provided, it must contain values for all
active lanes, and each value must be 0 or 1.

Introduce from_dt in struct ufshcd_tx_eq_params to track whether TX EQ
values came from static Device Tree data.

When TX Equalization Training is used, static settings are not final:
- If valid settings are retrieved from qTxEQGnSettings/wTxEQGnSettingsExt,
  those retrieved settings override static Device Tree settings.
- If retrieval is not available/valid, TX EQTR runs and trained settings
  override static Device Tree settings.

No behavior changes for platforms that do not provide these properties.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-txeq.c      |  15 ++-
 drivers/ufs/host/ufshcd-pltfrm.c | 156 +++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h             |   2 +
 3 files changed, 172 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 4b264adfdf49..63616f8c2f74 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -1297,7 +1297,13 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 	}
 
 	params = &hba->tx_eq_params[gear - 1];
-	if (!params->is_valid || force_tx_eqtr) {
+	/*
+	 * TX EQTR must run for the following cases:
+	 * 1. TX EQ settings are invalid.
+	 * 2. TX EQ settings are from Device Tree.
+	 * 3. TX EQTR procedure is forced.
+	 */
+	if (!params->is_valid || params->from_dt || force_tx_eqtr) {
 		int ret;
 
 		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
@@ -1310,6 +1316,8 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 		/* Mark TX Equalization settings as valid */
 		params->is_valid = true;
 		params->is_trained = true;
+		/* TX EQTR succeeds, clear from_dt flag */
+		params->from_dt = false;
 		params->is_applied = false;
 	}
 
@@ -1495,6 +1503,11 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
 	}
 
 	params->is_valid = true;
+	/*
+	 * Optimal TX EQ settings are retrieved from UFS device attributes,
+	 * clear from_dt flag to avoid TX EQTR procedure.
+	 */
+	params->from_dt = false;
 }
 
 void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba)
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index c2dafb583cf5..5cf934bf10d0 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -210,6 +210,160 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 	}
 }
 
+static int ufshcd_parse_tx_precode_enable(struct ufs_hba *hba,
+					  bool host_precode_en[UFS_MAX_LANES],
+					  bool device_precode_en[UFS_MAX_LANES])
+{
+	const char *prop_name = "tx-precode-enable-g6";
+	u32 num_elems = 2 * hba->lanes_per_direction;
+	const u32 lpd = hba->lanes_per_direction;
+	u32 precode[UFS_MAX_LANES * 2];
+	struct device *dev = hba->dev;
+	struct property *prop;
+	int count, err, i;
+
+	prop = of_find_property(dev->of_node, prop_name, NULL);
+	if (!prop)
+		return 0;
+
+	count = of_property_count_u32_elems(dev->of_node, prop_name);
+	if (count < 0)
+		return count;
+
+	if (count != num_elems) {
+		dev_err(dev, "Property %s has invalid count (%d), expecting %u\n",
+			prop_name, count, num_elems);
+		return -EINVAL;
+	}
+
+	err = of_property_read_u32_array(dev->of_node, prop_name, precode, num_elems);
+	if (err) {
+		dev_err(dev, "Failed to read %s property, %d\n", prop_name, err);
+		return err;
+	}
+
+	for (i = 0; i < num_elems; i++) {
+		if (precode[i] > 1) {
+			dev_err(dev, "Invalid TX precode value (%u) in %s property\n",
+				precode[i], prop_name);
+			return -EINVAL;
+		}
+	}
+
+	for (i = 0; i < lpd; i++) {
+		host_precode_en[i] = precode[i * 2];
+		device_precode_en[i] = precode[i * 2 + 1];
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
+	if (count < 0)
+		return count;
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
+ * tx-precode-enable-g6 device-tree properties.
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
+		err = ufshcd_parse_tx_precode_enable(hba, host_precode_en, device_precode_en);
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
+	params->from_dt = true;
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
@@ -528,6 +682,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	ufshcd_init_lanes_per_dir(hba);
 
+	ufshcd_parse_static_tx_eq_settings(hba);
+
 	err = ufshcd_parse_operating_points(hba);
 	if (err) {
 		dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f48d6416e299..0f87b081b2ff 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -359,6 +359,7 @@ struct ufshcd_tx_eqtr_record {
  * @is_valid: True if parameter contains valid TX Equalization settings
  * @is_applied: True if settings have been applied to UniPro of both sides
  * @is_trained: True if parameters obtained from TX EQTR procedure
+ * @from_dt: True if settings are from Device Tree
  */
 struct ufshcd_tx_eq_params {
 	struct ufshcd_tx_eq_settings host[UFS_MAX_LANES];
@@ -367,6 +368,7 @@ struct ufshcd_tx_eq_params {
 	bool is_valid;
 	bool is_applied;
 	bool is_trained;
+	bool from_dt;
 };
 
 /**
-- 
2.34.1

