Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB03F439012;
	Fri, 27 Feb 2026 16:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772208521; cv=none; b=clilBQvj1HK0mPCUJbYyCFrUc2UJLLubk3g9XeAWtAo86JMiXABd04fKTqj5saS2iDXoGdxUIR/DKgn0vF/S1uRiddCdqG8kLSLGmt1VKJ2YZiCJViFnP6aT4MHB/r/nZNnKG75SxvffvebjaBwotKsHudFC6v9/N1PI1Z8v0xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772208521; c=relaxed/simple;
	bh=g66xn561Lqpxq8tRiDEh1DyVJ+GHQ5CwrjS+sxbciJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VxpZFpmxvKiMe++MzUuhYT416KK45nRPrAZ8p82BQS5tGnQXzZI7RndvM6SkS4vWkKU3e/6PlTHPGrYGBgoAMfcVm2m9KHm9PmNzzGlGLajewAKXXA3PjBUVfL+nKscHkvNckh5WrAMAiCfGE17NbFbo7wb/MkgPq3QDW586P1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=dtUw3fBD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="dtUw3fBD"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61REaEsk1850516;
	Fri, 27 Feb 2026 16:08:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=QoDNWqXUeyk
	x2TzBEOGxhIRJboP27BCfSvca8LckLzc=; b=dtUw3fBDeQqfD645kiunS7IQb5S
	XtyUFTbpqJflqGOUeunYwzzkmmwWA0O0JptRRLMBUj23Z/PViYHbxIxgpyHla2a0
	EF3RMExiBRyRXysQ5biemrNr85BqdENIQii8QnpRYB1ZSp/8yAnRTmsD+UdF2LQE
	0BwSQtPSoa6yAF7sOYbLAeIhkKEYdAvAkcHafjjNwDXyerIojyUpROCXQ+1e1BCR
	e17GngoaM7KxCMxhYiQ1x+MJAu+i/mVMXxCWQ9rqXfiwEoEieMmBAHOm8GX3/FS8
	eJ80ID+H69Oq9V+P4iJqBhK8FxifOm0P5tvBVcu4v1XhiBv4kB4ZxlBpwew==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cjx1xu8ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:29 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61RG8T2F011166;
	Fri, 27 Feb 2026 16:08:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 4cjx30h5v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:29 +0000
Received: from NALASPPMTA05.qualcomm.com (NALASPPMTA05.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61RG8SGr011157;
	Fri, 27 Feb 2026 16:08:28 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA05.qualcomm.com (PPS) with ESMTPS id 61RG8Sl1011152
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:08:28 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 7FD5F5A0; Fri, 27 Feb 2026 08:08:28 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Archana Patni <archana.patni@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 02/11] scsi: ufs: core: Pass force_pmc to ufshcd_config_pwr_mode() as a parameter
Date: Fri, 27 Feb 2026 08:07:59 -0800
Message-Id: <20260227160809.2620598-3-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: 68dMnEv_rpomyhKRLHilQ6fG6Pwk6WU2
X-Authority-Analysis: v=2.4 cv=Vtouwu2n c=1 sm=1 tr=0 ts=69a1c17d cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8 a=ufAJUjbdAAAA:8
 a=wu8SEVntNhBdoNS0y9EA:9 a=rB1ygNaI0PWiOa_UD5GD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0NCBTYWx0ZWRfXyp1Lp+dVJuGH
 Elbsf7SaNbxoDx5nTRE4DwtaX1t/XiMJPhlgpCmltA+2aCkD3p81fSSZ7pOV6JO6NsEKzlcSdTG
 GzZZQ2iVKzg4JqY1YPXJUIHVwS6Le3uIbc42o2otrQRjVZSbUh5Uw64uH4qSs/AzdDwj7LMzXWt
 FxtdPDEboJmp0Piie62Bx7Iqoc1q3nMdH1y3xyg/wq2t5hENP2KYnJb9DxyZubCGoocxk9VOlIx
 FgcsZ36uaxoVhpkhphp+882om+nPQx22Hc5PRGLNiA6BsLiUT0kaad9YHoo/jupD6Pdge5jglqF
 nD0TrZ/G2W4zIDx0qzZXReBGLCCQJudOIlcuXHGspxWhJVZ/fDIB3/TLny9mHAra7G448thQlCV
 VG/kxMPHe9w3oadcVyfEQ1A6L/SISfP1/LDYgJMQs1c1qIBpWL5lBQi74fWcNOwP0pSKxJo6AdE
 6ygBetRJYVNRJKHWXTg==
X-Proofpoint-GUID: 68dMnEv_rpomyhKRLHilQ6fG6Pwk6WU2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_03,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1011 phishscore=0 bulkscore=0 spamscore=0
 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270144

Currently, callers must manually toggle hba->force_pmc before and after
calling ufshcd_config_pwr_mode() to force a Power Mode change. Refactor
ufshcd_config_pwr_mode() to accept force_pmc as a parameter.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c     | 32 +++++++++++++++++++-------------
 drivers/ufs/host/ufshcd-pci.c |  2 +-
 include/ufs/ufshcd.h          |  8 ++++----
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fc2eba74f120..511bd576a261 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1407,7 +1407,7 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, u32 target_gear, bool scale_up
 
 config_pwr_mode:
 	/* check if the power mode needs to be changed or not? */
-	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
+	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info, /*force_pmc=*/false);
 	if (ret)
 		dev_err(hba->dev, "%s: failed err %d, old gear: (tx %d rx %d), new gear: (tx %d rx %d)",
 			__func__, ret,
@@ -4248,7 +4248,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			pwr_mode_change = true;
 		}
 		if (pwr_mode_change) {
-			ret = ufshcd_change_power_mode(hba, &temp_pwr_info);
+			ret = ufshcd_change_power_mode(hba, &temp_pwr_info,
+						       /*force_pmc=*/false);
 			if (ret)
 				goto out;
 		}
@@ -4272,7 +4273,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 
 	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
 	    && pwr_mode_change)
-		ufshcd_change_power_mode(hba, &orig_pwr_info);
+		ufshcd_change_power_mode(hba, &orig_pwr_info,
+					 /*force_pmc=*/false);
 out:
 	return ret;
 }
@@ -4661,12 +4663,13 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 }
 
 static int __ufshcd_change_power_mode(struct ufs_hba *hba,
-				      struct ufs_pa_layer_attr *pwr_mode)
+				      struct ufs_pa_layer_attr *pwr_mode,
+				      bool force_pmc)
 {
 	int ret;
 
 	/* if already configured to the requested pwr_mode */
-	if (!hba->force_pmc &&
+	if (!force_pmc &&
 	    pwr_mode->gear_rx == hba->pwr_info.gear_rx &&
 	    pwr_mode->gear_tx == hba->pwr_info.gear_tx &&
 	    pwr_mode->lane_rx == hba->pwr_info.lane_rx &&
@@ -4746,13 +4749,14 @@ static int __ufshcd_change_power_mode(struct ufs_hba *hba,
 }
 
 int ufshcd_change_power_mode(struct ufs_hba *hba,
-			     struct ufs_pa_layer_attr *pwr_mode)
+			     struct ufs_pa_layer_attr *pwr_mode,
+			     bool force_pmc)
 {
 	int ret;
 
 	ufshcd_vops_pwr_change_notify(hba, PRE_CHANGE, pwr_mode);
 
-	ret = __ufshcd_change_power_mode(hba, pwr_mode);
+	ret = __ufshcd_change_power_mode(hba, pwr_mode, force_pmc);
 
 	if (!ret)
 		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
@@ -4765,11 +4769,13 @@ EXPORT_SYMBOL_GPL(ufshcd_change_power_mode);
  * ufshcd_config_pwr_mode - configure a new power mode
  * @hba: per-adapter instance
  * @desired_pwr_mode: desired power configuration
+ * @force_pmc: force a Power Mode change
  *
  * Return: 0 upon success; < 0 upon failure.
  */
 int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-		struct ufs_pa_layer_attr *desired_pwr_mode)
+			   struct ufs_pa_layer_attr *desired_pwr_mode,
+			   bool force_pmc)
 {
 	struct ufs_pa_layer_attr final_params = { 0 };
 	int ret;
@@ -4779,7 +4785,7 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 	if (ret)
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 
-	return ufshcd_change_power_mode(hba, &final_params);
+	return ufshcd_change_power_mode(hba, &final_params, force_pmc);
 }
 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
 
@@ -6836,14 +6842,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 		 * are sent via bsg and/or sysfs.
 		 */
 		down_write(&hba->clk_scaling_lock);
-		hba->force_pmc = true;
-		pmc_err = ufshcd_config_pwr_mode(hba, &(hba->pwr_info));
+		pmc_err = ufshcd_config_pwr_mode(hba, &hba->pwr_info,
+						 /*force_pmc=*/true);
 		if (pmc_err) {
 			needs_reset = true;
 			dev_err(hba->dev, "%s: Failed to restore power mode, err = %d\n",
 					__func__, pmc_err);
 		}
-		hba->force_pmc = false;
 		ufshcd_print_pwr_info(hba);
 		up_write(&hba->clk_scaling_lock);
 		spin_lock_irqsave(hba->host->host_lock, flags);
@@ -9118,7 +9123,8 @@ static int ufshcd_post_device_init(struct ufs_hba *hba)
 	if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
 		ufshcd_set_dev_ref_clk(hba);
 	/* Gear up to HS gear. */
-	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
+	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info,
+				     /*force_pmc=*/false);
 	if (ret) {
 		dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
 			__func__, ret);
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 894b7589b14e..b080a735dbd3 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -154,7 +154,7 @@ static int ufs_intel_set_lanes(struct ufs_hba *hba, u32 lanes)
 
 	pwr_info.lane_rx = lanes;
 	pwr_info.lane_tx = lanes;
-	ret = ufshcd_change_power_mode(hba, &pwr_info);
+	ret = ufshcd_change_power_mode(hba, &pwr_info, /*force_pmc=*/false);
 	if (ret)
 		dev_err(hba->dev, "%s: Setting %u lanes, err = %d\n",
 			__func__, lanes, ret);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 51c2555bea73..45caa162d3d8 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -882,7 +882,6 @@ enum ufshcd_mcq_opr {
  * @saved_uic_err: sticky UIC error mask
  * @ufs_stats: various error counters
  * @force_reset: flag to force eh_work perform a full reset
- * @force_pmc: flag to force a power mode change
  * @silence_err_logs: flag to silence error logs
  * @dev_cmd: ufs device management command information
  * @last_dme_cmd_tstamp: time stamp of the last completed DME command
@@ -1036,7 +1035,6 @@ struct ufs_hba {
 	u32 saved_uic_err;
 	struct ufs_stats ufs_stats;
 	bool force_reset;
-	bool force_pmc;
 	bool silence_err_logs;
 
 	/* Device management request data */
@@ -1363,9 +1361,11 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
 extern int ufshcd_change_power_mode(struct ufs_hba *hba,
-				    struct ufs_pa_layer_attr *pwr_mode);
+				    struct ufs_pa_layer_attr *pwr_mode,
+				    bool force_pmc);
 extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-			struct ufs_pa_layer_attr *desired_pwr_mode);
+				  struct ufs_pa_layer_attr *desired_pwr_mode,
+				  bool force_pmc);
 extern int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode);
 
 /* UIC command interfaces for DME primitives */
-- 
2.34.1

