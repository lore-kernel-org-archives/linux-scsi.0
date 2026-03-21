Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3A2301485;
	Sat, 21 Mar 2026 03:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774062670; cv=none; b=EnuOQclpFftQ5j6D3LH5NWM+BevJZMsEWXAaabAnS9GjA/9FAn9vyVdBlDM72iggSx+PFPRwrYYhejWW/u+M8lNZ30JhzqJIaKeJ+KF9/ghSLDRIEgS4gTvwiRR+shxORWGTxzM6Uv8pIRWm/RTau6uUuD3qb56w1uEzcmoRsug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774062670; c=relaxed/simple;
	bh=lHZ0ClUvWP8Y+QZojj8QA5W4MyXn5kWTK1xigGTA37c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iPEvXhztas4y+U/Q+sl1iwMM1MvFa56nl/A9NUPuxyw67/j8jNG1j1XeCz901n8IWjTq2XOyYWa+p6+cSqBWnxb9o86RpHy3ej9ZIYZyNfr779+i8hnQRYxt0zAUV87wInyX1iX5Do8gGBQB1VprAV/Hocf9OGAng49rTKwn4M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YUELnQKh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YUELnQKh"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62KEXaI71691830;
	Sat, 21 Mar 2026 03:10:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=gSBFTtcGx1p
	q018lrY4oHaWzg3smqrSZqEBnWuRwmTM=; b=YUELnQKheUFyrDyXwZFLpF8Iklc
	W7FqYVLJqi0bOG2XuCenH6qZohq8QQ1SX/AE7dOYquCbxxDRgLqD+7LdcT0iWqCn
	fh8KqoC1XDY4n3PYFVGpOT3rOocKmsl4+moDAKHd/RzjZY96FgX5/kxN9tEKYPX0
	eBfyPiQo+JdaIjMEfnGJJTlDH4YFv22u5f3oWDFwN8fCM6dPNsBU1UeoWit9q5zh
	4b7xK3lEHmjlZaCoOlBqD8FAvaLR5wSsgkDk7XnK+8L4jy9twUbtzdo6NW3yE6Nh
	0e8qgS1QLXmeU1G9cFxZC3HDqq+mG5ld1ZOXoPZUCitHmKqR4KUXXgrofrw==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d0s5d3qc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:10:41 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 62L3Aew6030722;
	Sat, 21 Mar 2026 03:10:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4d0spy9cu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:10:40 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62L3Ae1T030716;
	Sat, 21 Mar 2026 03:10:40 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 62L3AegA030715
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:10:40 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 35A685A8; Fri, 20 Mar 2026 20:10:40 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Archana Patni <archana.patni@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 02/12] scsi: ufs: core: Pass force_pmc to ufshcd_config_pwr_mode() as a parameter
Date: Fri, 20 Mar 2026 20:10:11 -0700
Message-Id: <20260321031021.1722459-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
References: <20260321031021.1722459-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: j_VkJCjJ0KahIzd_OvAEUev6uS9vceq3
X-Proofpoint-GUID: j_VkJCjJ0KahIzd_OvAEUev6uS9vceq3
X-Authority-Analysis: v=2.4 cv=CqCys34D c=1 sm=1 tr=0 ts=69be0c31 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=N54-gffFAAAA:8 a=EUspDBNiAAAA:8 a=ufAJUjbdAAAA:8
 a=WUAhUjOuKNn0ZP5bh2sA:9 a=rB1ygNaI0PWiOa_UD5GD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIxMDAyNCBTYWx0ZWRfX41pukc1deuvT
 MPJzIMUOAiVJjaTSfYesaQcXs5zdQognBng2n2oZPiUA4GXS6LeIuoIoS4rnksg903f1Blk6kPG
 C3+W/OH+cxBpVq+DqQRYZ9gSj1aNtgPelf/mcP8DH1wv6HX8VcH//X2PZIOdvavMO6t9L/V1XTW
 p8593QelKUwYHQ+apfr0bOssU+Qxa4PoberYAn5k4Efhn3lYexw7NiCke47zF9B4YxRxVgU07a+
 y/V4IIkT1gOhboUFOYdGV4ZT05UHEYvGHMBhPSyXZVoIDrBWaHOe2x/Pnzxyaurd7y+2I0SbZiD
 04lW73YQ2mykUjTVGv6llf8ecp6kT0syX4DhJQvah5ESLKHSJyFVrdKXItrsfx1zkH09qTPBwqu
 iTO5VbBgX/zMXsq2wWr1OVHFtxbXuUn9uwBVBoo/WXgoRVatZfl2UZfuCVv5/TRnOLjpI8foem5
 kk+pfa90/SSGkqRFKUA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-21_01,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603210024

Currently, callers must manually toggle hba->force_pmc before and after
calling ufshcd_config_pwr_mode() to force a Power Mode change. Introduce
enum ufshcd_pmc_policy and refactor ufshcd_config_pwr_mode() to accept
pmc_policy as a parameter to force a Power Mode change.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c     | 35 ++++++++++++++++++++++-------------
 drivers/ufs/host/ufshcd-pci.c |  3 ++-
 include/ufs/ufshcd.h          | 19 +++++++++++++++----
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 91b5d5b02d22..64220e3aa86e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1407,7 +1407,8 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u32 target_gear, bool scale_up
 
 config_pwr_mode:
 	/* check if the power mode needs to be changed or not? */
-	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
+	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info,
+				     UFSHCD_PMC_POLICY_DONT_FORCE);
 	if (ret)
 		dev_err(hba->dev, "%s: failed err %d, old gear: (tx %d rx %d), new gear: (tx %d rx %d)",
 			__func__, ret,
@@ -4248,7 +4249,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			pwr_mode_change = true;
 		}
 		if (pwr_mode_change) {
-			ret = ufshcd_change_power_mode(hba, &temp_pwr_info);
+			ret = ufshcd_change_power_mode(hba, &temp_pwr_info,
+						       UFSHCD_PMC_POLICY_DONT_FORCE);
 			if (ret)
 				goto out;
 		}
@@ -4272,7 +4274,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 
 	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
 	    && pwr_mode_change)
-		ufshcd_change_power_mode(hba, &orig_pwr_info);
+		ufshcd_change_power_mode(hba, &orig_pwr_info,
+					 UFSHCD_PMC_POLICY_DONT_FORCE);
 out:
 	return ret;
 }
@@ -4664,6 +4667,7 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
  * ufshcd_dme_change_power_mode() - UniPro DME Power Mode change sequence
  * @hba: per-adapter instance
  * @pwr_mode: pointer to the target power mode (gear/lane) attributes
+ * @pmc_policy: Power Mode change policy
  *
  * This function handles the low-level DME (Device Management Entity)
  * configuration required to transition the UFS link to a new power mode. It
@@ -4679,12 +4683,13 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
  * Return: 0 on success, non-zero error code on failure.
  */
 static int ufshcd_dme_change_power_mode(struct ufs_hba *hba,
-					struct ufs_pa_layer_attr *pwr_mode)
+					struct ufs_pa_layer_attr *pwr_mode,
+					enum ufshcd_pmc_policy pmc_policy)
 {
 	int ret;
 
 	/* if already configured to the requested pwr_mode */
-	if (!hba->force_pmc &&
+	if (pmc_policy == UFSHCD_PMC_POLICY_DONT_FORCE &&
 	    pwr_mode->gear_rx == hba->pwr_info.gear_rx &&
 	    pwr_mode->gear_tx == hba->pwr_info.gear_tx &&
 	    pwr_mode->lane_rx == hba->pwr_info.lane_rx &&
@@ -4767,6 +4772,7 @@ static int ufshcd_dme_change_power_mode(struct ufs_hba *hba,
  * ufshcd_change_power_mode() - Change UFS Link Power Mode
  * @hba: per-adapter instance
  * @pwr_mode: pointer to the target power mode (gear/lane) attributes
+ * @pmc_policy: Power Mode change policy
  *
  * This function handles the high-level sequence for changing the UFS link
  * power mode. It triggers vendor-specific pre-change notification,
@@ -4776,13 +4782,14 @@ static int ufshcd_dme_change_power_mode(struct ufs_hba *hba,
  * Return: 0 on success, non-zero error code on failure.
  */
 int ufshcd_change_power_mode(struct ufs_hba *hba,
-			     struct ufs_pa_layer_attr *pwr_mode)
+			     struct ufs_pa_layer_attr *pwr_mode,
+			     enum ufshcd_pmc_policy pmc_policy)
 {
 	int ret;
 
 	ufshcd_vops_pwr_change_notify(hba, PRE_CHANGE, pwr_mode);
 
-	ret = ufshcd_dme_change_power_mode(hba, pwr_mode);
+	ret = ufshcd_dme_change_power_mode(hba, pwr_mode, pmc_policy);
 
 	if (!ret)
 		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
@@ -4795,11 +4802,13 @@ EXPORT_SYMBOL_GPL(ufshcd_change_power_mode);
  * ufshcd_config_pwr_mode - configure a new power mode
  * @hba: per-adapter instance
  * @desired_pwr_mode: desired power configuration
+ * @pmc_policy: Power Mode change policy
  *
  * Return: 0 upon success; < 0 upon failure.
  */
 int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-		struct ufs_pa_layer_attr *desired_pwr_mode)
+			   struct ufs_pa_layer_attr *desired_pwr_mode,
+			   enum ufshcd_pmc_policy pmc_policy)
 {
 	struct ufs_pa_layer_attr final_params = { 0 };
 	int ret;
@@ -4814,7 +4823,7 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 	}
 
-	return ufshcd_change_power_mode(hba, &final_params);
+	return ufshcd_change_power_mode(hba, &final_params, pmc_policy);
 }
 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
 
@@ -6871,14 +6880,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 * are sent via bsg and/or sysfs.
 		 */
 		down_write(&hba->clk_scaling_lock);
-		hba->force_pmc = true;
-		pmc_err = ufshcd_config_pwr_mode(hba, &(hba->pwr_info));
+		pmc_err = ufshcd_config_pwr_mode(hba, &hba->pwr_info,
+						 UFSHCD_PMC_POLICY_FORCE);
 		if (pmc_err) {
 			needs_reset = true;
 			dev_err(hba->dev, "%s: Failed to restore power mode, err = %d\n",
 					__func__, pmc_err);
 		}
-		hba->force_pmc = false;
 		ufshcd_print_pwr_info(hba);
 		up_write(&hba->clk_scaling_lock);
 		spin_lock_irqsave(hba->host->host_lock, flags);
@@ -9153,7 +9161,8 @@ static int ufshcd_post_device_init(struct ufs_hba *hba)
 	if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
 		ufshcd_set_dev_ref_clk(hba);
 	/* Gear up to HS gear. */
-	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
+	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info,
+				     UFSHCD_PMC_POLICY_DONT_FORCE);
 	if (ret) {
 		dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
 			__func__, ret);
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 8a4f2381a32e..38d458711c99 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -145,7 +145,8 @@ static int ufs_intel_set_lanes(struct ufs_hba *hba, u32 lanes)
 
 	pwr_info.lane_rx = lanes;
 	pwr_info.lane_tx = lanes;
-	ret = ufshcd_change_power_mode(hba, &pwr_info);
+	ret = ufshcd_change_power_mode(hba, &pwr_info,
+				       UFSHCD_PMC_POLICY_DONT_FORCE);
 	if (ret)
 		dev_err(hba->dev, "%s: Setting %u lanes, err = %d\n",
 			__func__, lanes, ret);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 51c2555bea73..16facaee3e77 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -529,6 +529,17 @@ enum ufshcd_state {
 	UFSHCD_STATE_ERROR,
 };
 
+/**
+ * enum ufshcd_pmc_policy - Power Mode change policy
+ * @UFSHCD_PMC_POLICY_DONT_FORCE: Do not force a Power Mode change.
+ * @UFSHCD_PMC_POLICY_FORCE: Force a Power Mode change even if current Power
+ *	Mode is same as target Power Mode.
+ */
+enum ufshcd_pmc_policy {
+	UFSHCD_PMC_POLICY_DONT_FORCE,
+	UFSHCD_PMC_POLICY_FORCE,
+};
+
 enum ufshcd_quirks {
 	/* Interrupt aggregation support is broken */
 	UFSHCD_QUIRK_BROKEN_INTR_AGGR			= 1 << 0,
@@ -882,7 +893,6 @@ enum ufshcd_mcq_opr {
  * @saved_uic_err: sticky UIC error mask
  * @ufs_stats: various error counters
  * @force_reset: flag to force eh_work perform a full reset
- * @force_pmc: flag to force a power mode change
  * @silence_err_logs: flag to silence error logs
  * @dev_cmd: ufs device management command information
  * @last_dme_cmd_tstamp: time stamp of the last completed DME command
@@ -1036,7 +1046,6 @@ struct ufs_hba {
 	u32 saved_uic_err;
 	struct ufs_stats ufs_stats;
 	bool force_reset;
-	bool force_pmc;
 	bool silence_err_logs;
 
 	/* Device management request data */
@@ -1363,9 +1372,11 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
 extern int ufshcd_change_power_mode(struct ufs_hba *hba,
-				    struct ufs_pa_layer_attr *pwr_mode);
+				    struct ufs_pa_layer_attr *pwr_mode,
+				    enum ufshcd_pmc_policy pmc_policy);
 extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-			struct ufs_pa_layer_attr *desired_pwr_mode);
+				  struct ufs_pa_layer_attr *desired_pwr_mode,
+				  enum ufshcd_pmc_policy pmc_policy);
 extern int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode);
 
 /* UIC command interfaces for DME primitives */
-- 
2.34.1

