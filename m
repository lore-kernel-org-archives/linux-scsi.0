Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697043B8958;
	Fri,  1 May 2026 13:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777643088; cv=none; b=QFjpnEPnPWnA56U+zbU2ihZEhXC7TLHmCZdQfOOlmogoNCj7Xg4vxl2KxtgRdwdqh6pnGBleT/Pgw7qpFhOI2W0eF9P/Z3qFig4jadrCRYM15LZgTIEr1aX2V6Lutzpr3kVGbEhK2wqCQds6k6qRvxfJgYVzMbnUlEXU4b39Xwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777643088; c=relaxed/simple;
	bh=3MN3QSWocShXS+EbJVvMfujZc+wMHy8YsHjD2CnV4+A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=snUD5cRV0ywJWJ/lRZcF7194DmOUF9WNHH3qZf4uyoQcCl9RLqPnQ7WyJa0eGZjSmXYtD2Pbdegkre1LezNkDQqgozbxDgtcLb+JzXm8dOqkS4pc9FA81Ejdat2gjb5VMqJdjwdh9CLzddizh5pLYboxLJ7yuWRE3wpviKn5v7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cG6gk5k7; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cG6gk5k7"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 641AXLOm3305557;
	Fri, 1 May 2026 13:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=7tNuPbonqkJ
	mVYW5SIVhxwaVBYcYj1E4oBHWZ8E2ers=; b=cG6gk5k7G2pHeGLz00cs53kn6IU
	1FN5J15NpHoBLaZO3Zo7/WgEZyaj8INeiLAXqGczRokPOOqwawXjRD9fpTjfEDNn
	TOXagHJ82zf2aUaTtn4ndenMOEnof/W5xEXqSNCAJYS26TbYN54QHYudUU0ZLco9
	ZBA1UJ/fM/30jp9myqcy9/sXiP03HUTWRX/bn0talDkyiuqVwhEuZYI53rPF+uYQ
	q/+YTPjJny/opaTBrUbENaG6WzEFXyBHur2MrB5ptwDXY+ZUf5AWGDjJKObwJy8F
	pJ2pXmocgrpfgOGP0fGkXvyvB+Tmc4RipkHBNw7wxvy8eYJ1PgiMbIkzn8w==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dv7wuv991-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:44:32 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.7/8.18.1.7) with ESMTP id 641DiVGU014843;
	Fri, 1 May 2026 13:44:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4du78nm97k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:44:31 +0000 (GMT)
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 641DiVuf014771;
	Fri, 1 May 2026 13:44:31 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 641DiVJO014690
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 May 2026 13:44:31 +0000 (GMT)
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 14A7BB1B; Fri,  1 May 2026 06:44:31 -0700 (PDT)
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
Date: Fri,  1 May 2026 06:44:18 -0700
Message-Id: <20260501134418.863432-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260501134418.863432-1-can.guo@oss.qualcomm.com>
References: <20260501134418.863432-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDEzMyBTYWx0ZWRfX0H20PTh64Fi7
 ysDO0IibuTYPJKK5tMvY4ksJ5CWFTc571zqSzeKak3mHoD9knFxaYi48M7HmDLVI7vDbzQggBs+
 xcJdwi4v1w9I/6n26YyrkGM8SXtZuvOcQrCZpkahfcL8nvJ64a4bALN/WpCVVeLCPIPOSwRowZh
 9pqqfOHD7RkVHmJU20ao+E7j8YHUgxyJY4L29EGy8yZssOJjTTwnk6CJ3hcT7BFBm2SMCsdhP3T
 YVwSoB0egUDpIARAe0HWr6BarAJR+nFQ6ce46maoQ4DXTHs+nTyoBGqu9PxfH1q/R5UOfQIGTGA
 X9Tt6hkcBeohh8hhd9pmiag4wo9U8geQas9rJUmOu6d33v2VOP+jZJm/3ad67HTWRuTFv9GMSqt
 9jgn1tAiiMfx3M0aw/IJEN5OYF8BO429974G4CmOYZAECB3KuufWXTjmugxknVKKEmEdrX/ZgzW
 Mckoxe2jw1CrWU8qjuw==
X-Proofpoint-ORIG-GUID: IYuq_21urVWLqh8CStPk0tYP1u-DtZ3-
X-Proofpoint-GUID: IYuq_21urVWLqh8CStPk0tYP1u-DtZ3-
X-Authority-Analysis: v=2.4 cv=GMk41ONK c=1 sm=1 tr=0 ts=69f4ae40 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8 a=YtdY4IFUspqAs7Iwb1oA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-01_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 bulkscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605010133

HW design team usually provide static TX Equalization settings based on
PCB board characteristics. The static TX Equalization settings may not be
optimal for all PCBs, but it is better than having nothing when adaptive
TX EQTR is not used. Since the static TX Equalization settings are PCB
board specific, pass the static TX Equalization settings from device tree.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-txeq.c      |  4 +-
 drivers/ufs/host/ufshcd-pltfrm.c | 82 ++++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h             |  5 ++
 3 files changed, 90 insertions(+), 1 deletion(-)

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
index c2dafb583cf5..de6302e8c067 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -210,6 +210,86 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
 	}
 }
 
+static void ufshcd_parse_static_tx_eq_settings(struct ufs_hba *hba)
+{
+	size_t sz = hba->lanes_per_direction * 2 * TX_EQ_SETTINGS_TUPLE_SZ;
+	u32 settings[UFS_MAX_LANES * 2 * TX_EQ_SETTINGS_TUPLE_SZ];
+	u32 *host_settings, *device_settings;
+	u32 lpd = hba->lanes_per_direction;
+	struct ufshcd_tx_eq_params *params;
+	struct device *dev = hba->dev;
+	int i, err, count, gear, lane;
+	char prop_name[MAX_PROP_SIZE];
+
+	if (!lpd || lpd > UFS_MAX_LANES) {
+		dev_err(dev, "Invalid lanes-per-direction value (%u) provided\n", lpd);
+		return;
+	}
+
+	for (gear = UFS_HS_G1; gear <= UFS_HS_GEAR_MAX; gear++) {
+		snprintf(prop_name, MAX_PROP_SIZE, "txeq-settings-g%d", gear);
+		count = of_property_count_u32_elems(dev->of_node, prop_name);
+		if (count <= 0)
+			continue;
+
+		if (count != sz) {
+			dev_err(dev, "Property %s has invalid count (%d), expecting %zu \n",
+				prop_name, count, sz);
+			continue;
+		}
+
+		err = of_property_read_u32_array(dev->of_node, prop_name,
+						 settings, sz);
+		if (err) {
+			dev_err(dev, "Failed to read %s property, %d\n",
+				prop_name, err);
+			continue;
+		}
+
+		for (i = 0; i < count; i += TX_EQ_SETTINGS_TUPLE_SZ) {
+			if (settings[i] >= TX_HS_NUM_PRESHOOT) {
+				dev_err(dev, "An invalid TX EQ PreShoot (%d) provided in %s property\n",
+					settings[i], prop_name);
+				break;
+			}
+
+			if (settings[i + 1] >= TX_HS_NUM_DEEMPHASIS) {
+				dev_err(dev, "An invalid TX EQ DeEmphasis (%d) provided in %s property\n",
+					settings[i + 1], prop_name);
+				break;
+			}
+
+			if (settings[i + 2] > 1) {
+				dev_err(dev, "An invalid PrecodeEn (%d) provided in %s property\n",
+					settings[i + 2], prop_name);
+				break;
+			}
+		}
+
+		if (i != count)
+			continue;
+
+		params = &hba->tx_eq_params[gear - 1];
+		host_settings = settings;
+		device_settings = settings + lpd * TX_EQ_SETTINGS_TUPLE_SZ;
+
+		for (lane = 0; lane < lpd; lane++) {
+			params->host[lane].preshoot = host_settings[0];
+			params->host[lane].deemphasis =	host_settings[1];
+			params->host[lane].precode_en = host_settings[2];
+			host_settings += TX_EQ_SETTINGS_TUPLE_SZ;
+
+			params->device[lane].preshoot =	device_settings[0];
+			params->device[lane].deemphasis = device_settings[1];
+			params->device[lane].precode_en = device_settings[2];
+			device_settings += TX_EQ_SETTINGS_TUPLE_SZ;
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
@@ -528,6 +608,8 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 
 	ufshcd_init_lanes_per_dir(hba);
 
+	ufshcd_parse_static_tx_eq_settings(hba);
+
 	err = ufshcd_parse_operating_points(hba);
 	if (err) {
 		dev_err(dev, "%s: OPP parse failed %d\n", __func__, err);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f48d6416e299..2d385d42fcff 100644
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
@@ -367,8 +368,12 @@ struct ufshcd_tx_eq_params {
 	bool is_valid;
 	bool is_applied;
 	bool is_trained;
+	bool is_static;
 };
 
+/* TX EQ Settings Tuple has 3 elements - PreShoot, DeEmphasis and PrecodeEn. */
+#define TX_EQ_SETTINGS_TUPLE_SZ		3
+
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
-- 
2.34.1

