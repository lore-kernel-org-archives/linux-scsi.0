Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760A73A6EE5;
	Wed,  4 Mar 2026 13:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772632474; cv=none; b=o0Lx4wTaSWTQoS+fPJGbhyVbotTXJsb4g16vd1sHY8Nf6bioZ8uzrx4dK1GAgUmv2VT1F7IueQt/GsAIDwhdRubzGb+MZTuZbyU4fOScY34hF8cNeNwHl+TFwEj6tDeCi21FSzkC9YJM7JDy6O/+L7t/IaLVo7gVxRvqVY4bt1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772632474; c=relaxed/simple;
	bh=ruO4JwluJGS6GoW6Nztpui9LlYIR74FgfE1H2f9bX+c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s5xYLVk2BBUfah1v6fzxc89WWz+eaHlfpRREqkarOKsyQ5Kyb6DVlqMfg0wH3SjKPZ9JoygP3UJHRydtNJNPpt8c0x8ebxBv0HfFrBwLaXBgsf6ThuW8WR8Iac+d7es66Bevz4WS/f9gRDxf5ZywftTjjjWZm2cnE3BXAJHq7rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TufO3s8w; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TufO3s8w"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624Camfp1421862;
	Wed, 4 Mar 2026 13:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=bec7Xz99/nn
	km/OCW48qxFKUnfOyPbe3w20wqvfsQ54=; b=TufO3s8wbCbPAyxeAvlkoVqquqO
	S3V7MqVBAf9+9lbFqWrvlKXr+PaGqDHwimqJ7BTHefGB183pwUw/C4rsa6KqSqua
	jbPELv+3ldggfcr/beasV4VLY8ZCB2yNRUZI5OJLW5EqO7/ilSLNXKGz3wYNeOGS
	WPxsk6VNFWf+082SdkgLpIzKX5tMrZr9cNOCbYXEQ20eUDm0qfbNTRz3fnT0tPb6
	tyfPle7vao1cUxVssSjXIqewm96l6rvH+SYBqr3xUismdu4CbgHXwkKd4Veps7hD
	bAFBTt70P8365YHPp/KFmwdIvCqdfxOZzd5mhinoUgELYQBw3UCcAKPnryA==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cpe8u1kf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:54:19 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 624DsI2v005924;
	Wed, 4 Mar 2026 13:54:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 4cp8uh03ur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:54:18 +0000
Received: from NALASPPMTA02.qualcomm.com (NALASPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 624DsIjC005917;
	Wed, 4 Mar 2026 13:54:18 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA02.qualcomm.com (PPS) with ESMTPS id 624DsI9x005916
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 04 Mar 2026 13:54:18 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 636705A7; Wed,  4 Mar 2026 05:54:18 -0800 (PST)
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
Subject: [PATCH v2 06/11] scsi: ufs: core: Add support to retrain TX Equalization via debugfs
Date: Wed,  4 Mar 2026 05:53:08 -0800
Message-Id: <20260304135313.413688-7-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: b5Ya14wLZjl3ib42Yel4XVJXaqNa-irj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDExMSBTYWx0ZWRfX1mnN582n28Vz
 Y9cAhkA2AqtRye22+G71Y4kAiPC5jtXHoIT6PH1by78ifXBYftUNqzKJtenJsJldc2H5SvCXVsg
 RUv84oieFkNzZavAcqPdQTsOFehUTatWACCfGllEQRNN2/jhCX0My4J0vJQ2j2LAKKOtyT0I+2k
 o9FbGS9DbyYQiKHyZZA631Nwa/IVQ/12cS6JXUZ2ZwUK6uL4rrq50D8b1jWMDAQK/Y82YjvutE4
 nDAmwTi1pJCKZO9i+OE/zXCCOkhfNHzO/LUwYU18Rg6VTbzPdyRnYA21CA7xlMqR5pH0QXjBU0/
 Ha5vb4q0XjJrspAo4mZgwnTmfZTBMPynOLI3Q64nkRmzxlil9akxiwzqyOkxFQOjMPgUk4zuW/m
 gMCFm5ZBuy0x5oGLkm9a8un6iQx3SFUX6gjRA7YtPEHpkQArkP8Eb4VvExMgVT8YCBwYNHjjQXv
 vnGfloIkavBAkKez1aA==
X-Authority-Analysis: v=2.4 cv=FpAIPmrq c=1 sm=1 tr=0 ts=69a8398b cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8 a=ufAJUjbdAAAA:8
 a=MA_fwug8SUCjBrf4WSEA:9 a=rB1ygNaI0PWiOa_UD5GD:22
X-Proofpoint-GUID: b5Ya14wLZjl3ib42Yel4XVJXaqNa-irj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_06,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603040111

Drastic environmental changes, such as significant temperature shifts, can
impact UFS link signal integrity. In such cases, retraining the Transmit
(TX) Equalization is necessary to find optimal settings that compensate
for these thermal effects.

Add a debugfs entry, 'retrain_tx_eq', to allow userspace to manually
trigger the TX Equalization training (EQTR) process. These entries are
created on a per-gear basis for High Speed Gear 4 (HS-G4) and above, as
EQTR is not supported for lower gears.

The 'retrain_tx_eq' entry is a write-only trigger that initiates the
retraining sequence when the value '1' is written to it.

The ufshcd's debugfs folder structure will look like below:

/sys/kernel/debug/ufshcd/*ufs*/
|--tx_eq_hs_gear1/
|  |--device_tx_eq_params
|  |--host_tx_eq_params
|--tx_eq_hs_gear2/
|--tx_eq_hs_gear3/
|--tx_eq_hs_gear4/
|--tx_eq_hs_gear5/
|--tx_eq_hs_gear6/
   |--device_tx_eq_params
   |--device_tx_eqtr_record
   |--host_tx_eq_params
   |--host_tx_eqtr_record
   |--retrain_tx_eq

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-debugfs.c | 44 +++++++++++++++++++++++
 drivers/ufs/core/ufs-txeq.c    | 64 ++++++++++++++++++++++++++++++++--
 drivers/ufs/core/ufshcd-priv.h |  7 +++-
 drivers/ufs/core/ufshcd.c      | 32 ++++++++++++++---
 4 files changed, 139 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index b618d9b11dc9..45397a6e9ea0 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -383,9 +383,53 @@ static const struct file_operations ufs_tx_eqtr_record_fops = {
 	.release	= single_release,
 };
 
+static ssize_t ufs_retrain_tx_eq_write(struct file *file,
+				       const char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ufs_hba *hba = hba_from_file(file);
+	struct ufs_pa_layer_attr *pwr_info = &hba->max_pwr_info.info;
+	u32 gear = (u32)(uintptr_t)file->f_inode->i_private;
+	int val, ret;
+
+	ret = kstrtoint_from_user(buf, count, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val != 1)
+		return -EINVAL;
+
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL)
+		return -EBUSY;
+
+	if (!hba->ufs_device_wlun)
+		return -ENODEV;
+
+	if (!hba->max_pwr_info.is_valid || gear > pwr_info->gear_tx)
+		return -EINVAL;
+
+	ret = ufs_debugfs_get_user_access(hba);
+	if (ret)
+		return ret;
+	ufshcd_hold(hba);
+	ret = ufshcd_retrain_tx_eq(hba, gear);
+	ufshcd_release(hba);
+	ufs_debugfs_put_user_access(hba);
+
+	return ret ? ret : count;
+}
+
+static const struct file_operations ufs_retrain_tx_eq_fops = {
+	.owner		= THIS_MODULE,
+	.open		= simple_open,
+	.write		= ufs_retrain_tx_eq_write,
+	.llseek		= noop_llseek,
+};
+
 static const struct ufs_debugfs_attr ufs_tx_eqtr_attrs[] = {
 	{ "host_tx_eqtr_record", 0400, &ufs_tx_eqtr_record_fops },
 	{ "device_tx_eqtr_record", 0400, &ufs_tx_eqtr_record_fops },
+	{ "retrain_tx_eq", 0400, &ufs_retrain_tx_eq_fops },
 	{ }
 };
 
diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 2f637077548c..2cd2d5156607 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -1102,6 +1102,7 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
  * ufshcd_config_tx_eq_settings - Configure TX Equalization settings
  * @hba: per adapter instance
  * @pwr_mode: target power mode containing gear and rate information
+ * @force_tx_eqtr: do a TX EQTR regardless
  *
  * This function finds and sets the TX Equalization settings for the given
  * target power mode.
@@ -1109,7 +1110,8 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
  * Returns 0 on success, error code otherwise
  */
 int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
-				 struct ufs_pa_layer_attr *pwr_mode)
+				 struct ufs_pa_layer_attr *pwr_mode,
+				 bool force_tx_eqtr)
 {
 	struct ufshcd_tx_eq_params *params;
 	u32 gear, rate;
@@ -1144,7 +1146,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 	if (gear < UFS_HS_G4)
 		goto apply_tx_eq_settings;
 
-	if (!params->is_valid) {
+	if (!params->is_valid || force_tx_eqtr) {
 		int ret;
 
 		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
@@ -1208,3 +1210,61 @@ void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba)
 		}
 	}
 }
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
+	ret = ufshcd_pause_command_processing(hba, 1 * USEC_PER_SEC);
+	if (ret)
+		return ret;
+
+	ufshcd_hold(hba);
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
+	ret = ufshcd_change_power_mode(hba, &final_params,
+				       UFSHCD_PMC_POLICY_FORCE);
+	if (ret)
+		dev_err(hba->dev, "%s: Failed to change Power Mode to HS-G%u, Rate-%s: %d\n",
+			__func__, final_params.gear_tx,
+			UFS_HS_RATE_STRING(final_params.hs_rate), ret);
+
+out:
+	ufshcd_resume_command_processing(hba);
+	ufshcd_release(hba);
+
+	return ret;
+}
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 20ec8d8ac0a4..c63c53f61d2c 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -78,6 +78,9 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag);
 int ufshcd_mcq_abort(struct scsi_cmnd *cmd);
 int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd);
+int ufshcd_scale_clks(struct ufs_hba *hba, unsigned long freq, bool scale_up);
+int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us);
+void ufshcd_resume_command_processing(struct ufs_hba *hba);
 
 /**
  * enum ufs_descr_fmt - UFS string descriptor format
@@ -106,8 +109,10 @@ int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id);
 int ufshcd_uic_tx_eqtr(struct ufs_hba *hba, int gear);
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
index f30ff912ce1a..71c737bef205 100644
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
@@ -1362,6 +1359,31 @@ static int ufshcd_wait_for_pending_cmds(struct ufs_hba *hba,
 	return ret;
 }
 
+int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
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
+	}
+
+	return ret;
+}
+
+void ufshcd_resume_command_processing(struct ufs_hba *hba)
+{
+	up_write(&hba->clk_scaling_lock);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
+}
+
 /**
  * ufshcd_scale_gear - scale up/down UFS gear
  * @hba: per adapter instance
@@ -4815,7 +4837,7 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 	if (ret)
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 
-	ret = ufshcd_config_tx_eq_settings(hba, &final_params);
+	ret = ufshcd_config_tx_eq_settings(hba, &final_params, false);
 	if (ret) {
 		dev_err(hba->dev, "Failed to configure TX Equalization settings for HS-G%u, Rate-%s: %d\n",
 			final_params.gear_tx,
-- 
2.34.1

