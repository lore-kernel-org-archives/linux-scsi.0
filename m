Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917C844CAC2;
	Fri, 27 Feb 2026 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772208562; cv=none; b=ujPuCpxR4w6hcW+gYbpsAL/mVWuHnDgaU6DoXLoY393kHJXIew8Xyg87AhneYLk/VwVpAxMxXXzI3J1/Amt6b7G1J5XN+XYI9zgItZ+pSYqynbU+DvnlTprl3rRbvyvyF5eXinA0z99d8cSjP00nZsozBDpF1bFdIiNybNYhHPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772208562; c=relaxed/simple;
	bh=q7+7V5f13NsTaMVYlxwTcIsmDrjAqpbh4AEvuNkw+uM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fHNvkJGcVqplqxW19nf3iBmtwoHUrITRDlehE4VPIZB/TxZSB5bmNorHr0gmWbMNQkjQt2GiigA/e9VSsK7ggJbtIlq06KyfEvTjFkfucw8+wBymMzVqJAReKvGwIogo0ulxpIdcYnS9xpU6iWjaqsGE+aKZcRPblJ66Hi1rzSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Qn1cWD1r; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Qn1cWD1r"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61REaGBJ3181974;
	Fri, 27 Feb 2026 16:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=bBvPRgeAwCK
	NSHgwctlqPIrrDc+24VnqnvGxjKPy0Js=; b=Qn1cWD1rr7zebHOxcXJauXvGPE4
	pttsWTm0rmwR9Xpoy67PsUYOvVhpzaeE15kCYO0Qs1qFZ2ptV2ThQaaHUpM+w6d/
	/SeNuwvk38duKm/N9vl6THw21tbvVp95BYwHQmqzfJFYqFkWUH6K0hQ2939jyEn+
	fEGPYwYWGqhc6wdKQ0kJkhI/TEG4xTNpoDVuxOHLjE+OoL+WGQcz1hqvUMGQ/DSw
	WIoHV8pdSpkFHkvpt6ic0UUFycvx4q0RbU77Xr6IfViQGPJz9Xx7XXIHLOlajCHl
	nywA5XFcQZFC/kqe1ZBKJyoq/5drLbLR2npXgDPW9Y617d75ImnlSYrwt2g==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cjt99va5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:09:10 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 61RG8ZPb024025;
	Fri, 27 Feb 2026 16:09:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4cjf89aact-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:09:10 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61RG99CT024495;
	Fri, 27 Feb 2026 16:09:09 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 61RG992e024494
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 16:09:09 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 8773A5A0; Fri, 27 Feb 2026 08:09:09 -0800 (PST)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 06/11] scsi: ufs: core: Add support to retrain TX Equalization via debugfs
Date: Fri, 27 Feb 2026 08:08:03 -0800
Message-Id: <20260227160809.2620598-7-can.guo@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=IZWKmGqa c=1 sm=1 tr=0 ts=69a1c1a6 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8 a=ufAJUjbdAAAA:8
 a=c6kORSdi7RHHljI5AK8A:9 a=rB1ygNaI0PWiOa_UD5GD:22
X-Proofpoint-GUID: 7nWyb2-gmr8-V5SDvt8slWlHXv9DPyVR
X-Proofpoint-ORIG-GUID: 7nWyb2-gmr8-V5SDvt8slWlHXv9DPyVR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0NCBTYWx0ZWRfX+L/EgxJUvIpB
 hhXDGOOOWy+NpjEf9Nw+DGfhKNEZm+hqIjaZ4SIxy8Ld6Lk53f6TJ0nxIQxltPv1RdSyKnXjyO7
 lLV14HvXO696YTKO7bIuTzcMij78iswDLsDRU7WnPM8gsX9H+o949Lvlei8ZC0J6vWfU+ueYKNB
 EYH6FkcbkZYe5/xi6Tqar4g3dDaYsMIJxzvrbA/CPiqsajXPktzkW5upMFJNQA9os3IHWwAYIW7
 o6cC9Rp8I4n8VzqAnf9/DSjalVIVohakjmCYtoRJk+AcQ4/7+l3WqT50JKrvG9ouWLLjez2Hpr8
 qZMcZwuWXHly4U5w7SRUgrHCDwlJJRCLitAzRzaBa1EFDyKknrPdscJTTOgmsA6VcV/qoLICLuV
 F3DNblVD9FVUk6b2eDCsy+VRdDv4eaGTVEG8WqM5kkWCkTNob1xjaSL1nZjpvyKAeb9UV1O+M6X
 fazkfLbrB9bpmGM3nOw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_03,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602270144

When environmental changes happen too much and too fast during runtime,
e.g., temperature, it might be required to retrain TX Equalization to find
the new optimal TX EQ settings to compensate. Add support to retrain TX
Equalization via debugfs, so that userspace can decide when to trigger it.

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-debugfs.c | 32 ++++++++++++
 drivers/ufs/core/ufs-txeq.c    | 89 +++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  6 ++-
 drivers/ufs/core/ufshcd.c      | 10 ++--
 4 files changed, 127 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index 53deb8b2d1ea..5a52c2ad44f5 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -230,6 +230,36 @@ static int tx_eq_gear_set(void *data, u64 val)
 
 DEFINE_DEBUGFS_ATTRIBUTE(tx_eq_gear_fops, tx_eq_gear_get, tx_eq_gear_set, "%#llx\n");
 
+static int retrain_tx_eq_set(void *data, u64 val)
+{
+	struct ufs_hba *hba = data;
+	struct ufs_pa_layer_attr *pwr_info = &hba->max_pwr_info.info;
+	u32 gear = (u32)val;
+	int err;
+
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+		return -EBUSY;
+
+	if (!hba->ufs_device_wlun)
+		return -ENODEV;
+
+	if (gear < UFS_HS_G1 || gear >= UFS_HS_GEAR_MAX ||
+	    !hba->max_pwr_info.is_valid || gear > pwr_info->gear_tx)
+		return -EINVAL;
+
+	err = ufs_debugfs_get_user_access(hba);
+	if (err)
+		return err;
+	ufshcd_hold(hba);
+	err = ufshcd_retrain_tx_eq(hba, gear);
+	ufshcd_release(hba);
+	ufs_debugfs_put_user_access(hba);
+
+	return err;
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(retrain_tx_eq_fops, NULL, retrain_tx_eq_set, "%#llx\n");
+
 static int ufs_tx_eq_params_show(struct seq_file *s, void *data)
 {
 	struct ufs_debugfs_attr *attr = s->private;
@@ -433,6 +463,8 @@ void ufs_debugfs_hba_init(struct ufs_hba *hba)
 	hba->debugfs_tx_eq_gear = UFS_HS_GEAR_MAX - 1;
 	debugfs_create_file("tx_eq_gear_sel", 0600, hba->debugfs_root, hba,
 			    &tx_eq_gear_fops);
+	debugfs_create_file("retrain_tx_eq", 0200, hba->debugfs_root, hba,
+			    &retrain_tx_eq_fops);
 	for (attr = ufs_tx_eq_attrs; attr->name; attr++)
 		debugfs_create_file(attr->name, attr->mode, root, (void *)attr,
 				    attr->fops);
diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 1eaaca7c34a4..55d8d4f49146 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -1075,6 +1075,7 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
  * ufshcd_config_tx_eq_settings - Configure TX Equalization settings
  * @hba: per adapter instance
  * @pwr_mode: target power mode containing gear and rate information
+ * @force_tx_eqtr: do a TX EQTR regardless
  *
  * This function finds and sets the TX Equalization settings for the given
  * target power mode.
@@ -1082,7 +1083,8 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
  * Returns 0 on success, error code otherwise
  */
 int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
-				 struct ufs_pa_layer_attr *pwr_mode)
+				 struct ufs_pa_layer_attr *pwr_mode,
+				 bool force_tx_eqtr)
 {
 	struct ufshcd_tx_eq_params *params;
 	u32 gear, rate;
@@ -1118,7 +1120,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 	if (gear < UFS_HS_G4)
 		goto apply_tx_eq_settings;
 
-	if (!params->is_valid) {
+	if (!params->is_valid || force_tx_eqtr) {
 		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
 		if (ret) {
 			dev_err(hba->dev, "Failed to train TX Equalization for HS-G%u, Rate-%s: %d\n",
@@ -1178,3 +1180,86 @@ void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba)
 		}
 	}
 }
+
+static int ufshcd_retrain_tx_eq_prepare(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	mutex_lock(&hba->host->scan_mutex);
+	blk_mq_quiesce_tagset(&hba->host->tag_set);
+	down_write(&hba->clk_scaling_lock);
+
+	if (ufshcd_wait_for_pending_cmds(hba, 1 * USEC_PER_SEC)) {
+		ret = -EBUSY;
+		up_write(&hba->clk_scaling_lock);
+		blk_mq_unquiesce_tagset(&hba->host->tag_set);
+		mutex_unlock(&hba->host->scan_mutex);
+		goto out;
+	}
+
+	ufshcd_hold(hba);
+
+out:
+	return ret;
+}
+
+static void ufshcd_retrain_tx_eq_unprepare(struct ufs_hba *hba)
+{
+	up_write(&hba->clk_scaling_lock);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
+	ufshcd_release(hba);
+}
+
+int ufshcd_retrain_tx_eq(struct ufs_hba *hba, u32 gear)
+{
+	struct ufs_pa_layer_attr new_pwr_info, final_params = { 0 };
+	int ret;
+
+	if (!ufshcd_is_tx_eq_supported(hba) || !use_adaptive_txeq)
+		return -EOPNOTSUPP;
+
+	if (gear < adaptive_txeq_gear)
+		return -ETOOSMALL;
+
+	ret = ufshcd_retrain_tx_eq_prepare(hba);
+	if (ret)
+		return ret;
+
+	/* scale up clocks to max frequency before TX EQTR */
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_scale_clks(hba, ULONG_MAX, true);
+
+	new_pwr_info = hba->pwr_info;
+	new_pwr_info.gear_tx = gear;
+	new_pwr_info.gear_rx = gear;
+
+	ret = ufshcd_vops_negotiate_pwr_mode(hba, &new_pwr_info, &final_params);
+	if (ret)
+		memcpy(&final_params, &new_pwr_info, sizeof(final_params));
+
+	if (final_params.gear_tx != gear) {
+		dev_err(hba->dev, "%s: Negotiated Gear (%u) does not match target Gear (%u)\n",
+			__func__, final_params.gear_tx, gear);
+		goto out;
+	}
+
+	ret = ufshcd_config_tx_eq_settings(hba, &final_params, true);
+	if (ret) {
+		dev_err(hba->dev, "%s: Failed to configure TX Equalization settings for HS-G%u, Rate-%s: %d\n",
+			__func__, final_params.gear_tx,
+			UFS_HS_RATE_STRING(final_params.hs_rate), ret);
+		goto out;
+	}
+
+	/* Change Power Mode to apply the new TX EQ settings */
+	ret = ufshcd_change_power_mode(hba, &final_params, /*force_pmc=*/true);
+	if (ret)
+		dev_err(hba->dev, "%s: Failed to change Power Mode to HS-G%u, Rate-%s: %d\n",
+			__func__, final_params.gear_tx,
+			UFS_HS_RATE_STRING(final_params.hs_rate), ret);
+
+out:
+	ufshcd_retrain_tx_eq_unprepare(hba);
+	return ret;
+}
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 87777d3f4326..95503fb3235d 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -102,12 +102,16 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id);
+int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba, u64 wait_timeout_us);
+int ufshcd_scale_clks(struct ufs_hba *hba, unsigned long freq, bool scale_up);
 
 int ufshcd_trigger_tx_eqtr(struct ufs_hba *hba, int gear);
 void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba);
 int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
-				 struct ufs_pa_layer_attr *pwr_mode);
+				 struct ufs_pa_layer_attr *pwr_mode,
+				 bool force_tx_eqtr);
 void ufshcd_print_tx_eq_params(struct ufs_hba *hba);
+int ufshcd_retrain_tx_eq(struct ufs_hba *hba, u32 target_gear);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ed6793b1b7a1..0cdd61a980c3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -332,8 +332,6 @@ static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static void ufshcd_resume_clkscaling(struct ufs_hba *hba);
 static void ufshcd_suspend_clkscaling(struct ufs_hba *hba);
-static int ufshcd_scale_clks(struct ufs_hba *hba, unsigned long freq,
-			     bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
 static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
@@ -1208,8 +1206,7 @@ static int ufshcd_opp_set_rate(struct ufs_hba *hba, unsigned long freq)
  *
  * Return: 0 if successful; < 0 upon failure.
  */
-static int ufshcd_scale_clks(struct ufs_hba *hba, unsigned long freq,
-			     bool scale_up)
+int ufshcd_scale_clks(struct ufs_hba *hba, unsigned long freq, bool scale_up)
 {
 	int ret = 0;
 	ktime_t start = ktime_get();
@@ -1308,8 +1305,7 @@ static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
  *
  * Return: 0 upon success; -EBUSY upon timeout.
  */
-static int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba,
-					u64 wait_timeout_us)
+int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba, u64 wait_timeout_us)
 {
 	int ret = 0;
 	u32 tm_doorbell;
@@ -4812,7 +4808,7 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 	if (ret)
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 
-	ret = ufshcd_config_tx_eq_settings(hba, &final_params);
+	ret = ufshcd_config_tx_eq_settings(hba, &final_params, false);
 	if (ret) {
 		dev_err(hba->dev, "Failed to configure TX Equalization settings for HS-G%u, Rate-%s: %d\n",
 			final_params.gear_tx,
-- 
2.34.1

