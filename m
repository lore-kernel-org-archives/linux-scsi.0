Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFBE4266B1;
	Wed, 27 May 2026 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779892889; cv=none; b=S0Nc/m4dfW1E/dwmx29fZ1WB5RZgn5WOdiqn8FIMJvHSdgSssgM8BED6SopknEYgdFawJIl/bh9t5PgdwVU2CXxN0THXcO1/+mZo8mS7Con5OvmTMnqF+KwJtEatBISrk4M+TWyfaU98Zck3tQL1fJHChaf/ju+XZGwjtXNvTCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779892889; c=relaxed/simple;
	bh=t/fMk9p7EFJvNoBv2VTByiCZff1xvQjbRKhOFL0F+WE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SfO1fTk8JHa/B1Q32QUL8a8K0Wf+l9ky9zQ1MytxeJnEgmZtp0d6aYtH2M5LaRhnaxM3xaobhkgQ2hIfr5rxKpJKEgsFMbxOQnMTpj/Nwl/DMUwC43i3x6SHlwCp2bv7I9AV8Jv2h4KoWOgBfGa63LEsHGvdJ1SJiTuC/K9A6f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aPwkTFEs; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aPwkTFEs"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64RA6XoV1149361;
	Wed, 27 May 2026 14:41:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=P2dFneoPMwk
	6gsz4+5s4QxdpYbCmWtDZAcAaKQOok00=; b=aPwkTFEsis+R/QfjvSDWdDNdMrT
	DQ8+R+EDEeYeR/DArf6s1CRuZlNcVEv6CLncgJJhuX4w9ojBg0R3gSQh4zQIm9as
	9lWA/1QVzyqrZuK54VTsefDTMVYnsxfL9LmDbKqkEGiLrBJAJ8CtoyULXc8GobdE
	zoXfuQe1+mFf5F6bMABIzJq0k9yAI4zqHgNLdjZwaJbbCg+/pL8Gd1KCSnbv348v
	hmZyXlaJcbYlEdcBR4znBubC3wxQII5GQq9Ui/LHflrIr9NeoxPKDB9rydAxMYXA
	TEHr1Lj499f9y8KiQUruIH2rfcH7JKL8DHJmdBqCeNk0Tla3LJ/StuiB9VQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4edxjsgxc3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 14:41:15 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 64REfEOP013895;
	Wed, 27 May 2026 14:41:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4ed7b7f1uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 14:41:14 +0000 (GMT)
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64REfEui013888;
	Wed, 27 May 2026 14:41:14 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 64REfE8e013884
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 27 May 2026 14:41:14 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id F0F27631; Wed, 27 May 2026 07:41:13 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] scsi: ufs: core: Add support for static TX Equalization settings
Date: Wed, 27 May 2026 07:40:55 -0700
Message-Id: <20260527144055.2758170-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
References: <20260527144055.2758170-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Authority-Analysis: v=2.4 cv=C4PZDwP+ c=1 sm=1 tr=0 ts=6a17028b cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8 a=-xlrxDLzkpAifl49RugA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI3MDE0NSBTYWx0ZWRfX0G5apRdhZKgE
 VVFdu/XpdxXcBDyJOqY649mr8+CzCSKJpyuy71p7ErcSkkcMbtyk863l5NV/ey5IbVyheilj8Ze
 TWn1lgUHnBSG2Zrx9e+ahDHrN2AQaFy4REzeU2yiQZQgcUj+fIycpNwD7J7DnGETSlYPjcbQx+y
 fc6cSEPEQyXeiubKJFMg7ImZBGcJGb2GgwdGXAZy07ijtJeepmgj6P8xAmWEWZCtVT8ZuaKs27+
 WYxqVSFfeM2zFkQhLX4xVrfb3iyXp1PPxIxgTR6MlBddrEh3Sh+IMKZ+wYM5bnFk1fdrmCuFfIu
 EUqvcNCY5RE+JFMKVieMTZkMizFb5ujk1RUKw9Zs2JNKfv/LVlqcaH+j1H7TKpj9qZgtnu2AzR6
 qqVz9e/hctdn4DPuTlsBVFgkf3cowDqPF9vpi3Z8BZoMUj/OtUphcLnHBHrxEb1b98FrKV/DW90
 jiofCs3mQ/tghUeuszA==
X-Proofpoint-ORIG-GUID: fU5h-01FS58LcvxSn_KqBZRMnQnh-gXN
X-Proofpoint-GUID: fU5h-01FS58LcvxSn_KqBZRMnQnh-gXN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-05-27_02,2026-05-26_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605270145

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
 drivers/ufs/core/ufs-txeq.c      |   4 +-
 drivers/ufs/host/ufshcd-pltfrm.c | 128 +++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h             |   2 +
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 4b264adfdf49..634ec039e129 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -1297,7 +1297,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 	}
 
 	params = &hba->tx_eq_params[gear - 1];
-	if (!params->is_valid || force_tx_eqtr) {
+	if (!params->is_valid || params->is_static || force_tx_eqtr) {
 		int ret;
 
 		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
@@ -1310,6 +1310,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 		/* Mark TX Equalization settings as valid */
 		params->is_valid = true;
 		params->is_trained = true;
+		params->is_static = false;
 		params->is_applied = false;
 	}
 
@@ -1495,6 +1496,7 @@ static void ufshcd_extract_tx_eq_settings_attrs(struct ufs_hba *hba, u8 gear)
 	}
 
 	params->is_valid = true;
+	params->is_static = false;
 }
 
 void ufshcd_retrieve_tx_eq_settings(struct ufs_hba *hba)
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index c2dafb583cf5..2db2103a6ac0 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -210,6 +210,132 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 	}
 }
 
+static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
+{
+	size_t sz = hba->lanes_per_direction * 2;
+	u32 lpd = hba->lanes_per_direction;
+	struct ufshcd_tx_eq_params *params;
+	u32 deemphasis[UFS_MAX_LANES * 2];
+	u32 precode_en[UFS_MAX_LANES * 2];
+	u32 preshoot[UFS_MAX_LANES * 2];
+	struct device *dev = hba->dev;
+	char prop_name[MAX_PROP_SIZE];
+	int i, err, count, gear, lane;
+
+	if (!lpd || lpd > UFS_MAX_LANES) {
+		dev_err(dev, "Invalid lanes-per-direction value (%u) provided\n", lpd);
+		return;
+	}
+
+	for (gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++) {
+		snprintf(prop_name, MAX_PROP_SIZE, "txeq-preshoot-g%d", gear);
+		count = of_property_count_u32_elems(dev->of_node, prop_name);
+		if (count <= 0)
+			continue;
+
+		if (count != sz) {
+			dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
+				prop_name, count, sz);
+			continue;
+		}
+
+		err = of_property_read_u32_array(dev->of_node, prop_name, preshoot, sz);
+		if (err) {
+			dev_err(dev, "Failed to read %s property, %d\n",
+				prop_name, err);
+			continue;
+		}
+
+		for (i = 0; i < count; i++) {
+			if (preshoot[i] >= TX_HS_NUM_PRESHOOT) {
+				dev_err(dev, "An invalid TX EQ PreShoot (%d) provided in %s property\n",
+					preshoot[i], prop_name);
+				break;
+			}
+		}
+
+		if (i != count)
+			continue;
+
+		snprintf(prop_name, MAX_PROP_SIZE, "txeq-deemphasis-g%d", gear);
+		count = of_property_count_u32_elems(dev->of_node, prop_name);
+		if (count <= 0) {
+			dev_err(dev, "Missing required %s property\n", prop_name);
+			continue;
+		}
+
+		if (count != sz) {
+			dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
+				prop_name, count, sz);
+			continue;
+		}
+
+		err = of_property_read_u32_array(dev->of_node, prop_name, deemphasis, sz);
+		if (err) {
+			dev_err(dev, "Failed to read %s property, %d\n",
+				prop_name, err);
+			continue;
+		}
+
+		for (i = 0; i < count; i++) {
+			if (deemphasis[i] >= TX_HS_NUM_DEEMPHASIS) {
+				dev_err(dev, "An invalid TX EQ DeEmphasis (%d) provided in %s property\n",
+					deemphasis[i], prop_name);
+				break;
+			}
+		}
+
+		if (i != count)
+			continue;
+
+		memset(precode_en, 0, sizeof(precode_en));
+		if (gear == UFS_HS_G6) {
+			snprintf(prop_name, MAX_PROP_SIZE, "tx-precode-enable-g%d", gear);
+			count = of_property_count_u32_elems(dev->of_node, prop_name);
+			if (count > 0) {
+				if (count != sz) {
+					dev_err(dev, "Property %s has invalid count (%d), expecting %zu\n",
+						prop_name, count, sz);
+					continue;
+				}
+
+				err = of_property_read_u32_array(dev->of_node, prop_name,
+								 precode_en, sz);
+				if (err) {
+					dev_err(dev, "Failed to read %s property, %d\n",
+						prop_name, err);
+					continue;
+				}
+
+				for (i = 0; i < count; i++) {
+					if (precode_en[i] > 1) {
+						dev_err(dev, "An invalid PrecodeEn (%d) provided in %s property\n",
+							precode_en[i], prop_name);
+						break;
+					}
+				}
+
+				if (i != count)
+					continue;
+			}
+		}
+
+		params = &hba->tx_eq_params[gear - 1];
+		for (lane = 0; lane < lpd; lane++) {
+			params->host[lane].preshoot = preshoot[lane * 2];
+			params->host[lane].deemphasis = deemphasis[lane * 2];
+			params->host[lane].precode_en = precode_en[lane * 2];
+
+			params->device[lane].preshoot = preshoot[lane * 2 + 1];
+			params->device[lane].deemphasis = deemphasis[lane * 2 + 1];
+			params->device[lane].precode_en = precode_en[lane * 2 + 1];
+		}
+
+		params->is_valid = true;
+		params->is_static = true;
+	}
+}
+
 /**
  * ufshcd_parse_clock_min_max_freq  - Parse MIN and MAX clocks freq
  * @hba: per adapter instance
@@ -528,6 +654,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
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
