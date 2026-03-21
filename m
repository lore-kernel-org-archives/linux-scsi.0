Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADD13090CD;
	Sat, 21 Mar 2026 03:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774062705; cv=none; b=fNnq/3Ns+ADR462aFBNMqUzkMxV8RCmbOHcpaGIVkAHmRumyJ36Ptdzpdz8eNBtecK0Dc8vGiqerbhtbpLKG2zXVb8gSoKQv9BvSzqppujMuxLNeZzzauqO5tFbV1KT+7qDVTVwTPfscfmBUrz86ADxLqsCqWKjx6msOIH4uY1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774062705; c=relaxed/simple;
	bh=dVlMWJOmuZlFrRBiVtycGixckcPsHFhHry9YrqUOvn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H9rFGMsgJRxN4++9M12E0qbtCMmDvmMZk1YMHjJIN8YjDepUOzCVO3G3SHqrcxZcAnPbH88Am2LIP7X0fiDf4wkhHYJ2U1iALDaG3wsIC234e4u5hVWN7KQp/Mcs+NAiIdi8t1UzBkrZhFRj9Nn5n/8qXkf/3vaSaecO+T7j5gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=FwX/UeJc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="FwX/UeJc"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62L2vS3B3327857;
	Sat, 21 Mar 2026 03:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=whuzDqSEZV+
	VIi2+iSLttAVh7HlC9aCs1+312yxMcd8=; b=FwX/UeJcZqxUKRWn5mSdAqEBdy0
	NzE9c60ukRvSLCV6zA0PuE3Eby8EAOVG/73NTBYzhftvvcC5VDEm6tn3oIPL8GMX
	0q6F93ioleMnG1hX0ByMdF6UwqWN1LT5vGrov2MxYJ8CN82wL0oBpQyFC2YDdZpq
	AqC1kze7J1W3RQFhfDb2r/BQmJmspLBYmycPwU/yoFydthGWCkwWvB/GNYMf/j8m
	6CkKYwj90Z/a+9MpAZ7/b4NXs/J55kVotjTnB0uyrSHA47ffXOiGK0VcTy43m92J
	atopd/vEXpkGCbsaFs6p8INkRPxX1qtg4/R+hiBPFaHiI+WxKNI7qWb2cig==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d1gpk06nv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:11:28 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 62L3BRq0018324;
	Sat, 21 Mar 2026 03:11:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4d05k3awtf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:11:27 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62L3BRF7018314;
	Sat, 21 Mar 2026 03:11:27 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 62L3BRdO018313
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 21 Mar 2026 03:11:27 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 0C5975A8; Fri, 20 Mar 2026 20:11:27 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 07/12] scsi: ufs: core: Add support to retrain TX Equalization via debugfs
Date: Fri, 20 Mar 2026 20:10:16 -0700
Message-Id: <20260321031021.1722459-8-can.guo@oss.qualcomm.com>
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
X-Proofpoint-ORIG-GUID: 33G9iGFPCzbTRqK2bTCUKcea5wRoMzes
X-Proofpoint-GUID: 33G9iGFPCzbTRqK2bTCUKcea5wRoMzes
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIxMDAyNCBTYWx0ZWRfXzYmOoccveZ1g
 72ntJ92IOEhKi/eGZyKDHkco0CjmMxJUFnNJ8nD59bAMubYPUK8mBhA2V9T6W957Mlb10nenL+z
 1yTRgVUOG4T9pT09KiNZfcSNn0eCJfgMI23BV187jCOcV7c0PoEs0g4NV9uLwATytWuEnb1Lf/N
 yfHaq48a+0218l48wkkNjSS2TXPjaPMXYqaUpDirHzCNbPoycdW4LwqaerdrJNO9JOwFWH+W52e
 VvgMLPa5oGpIQcruU8GJ9fkYn0vKQmtB3BjNezTk2D1IXJshwTgYPgOF6Z9/uq9NLix8jGQS65H
 azUuM7PnhSuFtzS70Ws/3tlJ4CJ/NBIbQw1gwuvr/+DvqUrrhSoFBPQCARuI03r/0NN6paLDNeM
 ZrU/XtjbbvDV/JsoatdUPEMPmE/S72XV9jEhRiQ2LYrPIt5Uq/OraYz35vkISznxMKxFHqaZ9S5
 Huay0/ZKdgWt0FJuVDw==
X-Authority-Analysis: v=2.4 cv=QKhlhwLL c=1 sm=1 tr=0 ts=69be0c60 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8 a=Vsb1Ig1MPm7qU1zCfT0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-21_01,2026-03-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603210024

Drastic environmental changes, such as significant temperature shifts, can
impact link signal integrity. In such cases, retraining TX Equalization is
necessary to compensate for these environmental changes.

Add a debugfs entry, 'tx_eq_ctrl', to allow userspace to manually trigger
the TX Equalization training (EQTR) procedure and apply the identified
optimal settings on the fly. These entries are created on a per-gear basis
for High Speed Gear 4 (HS-G4) and above, as TX EQTR is not supported for
lower gears.

The 'tx_eq_ctrl' entry currently accepts the 'retrain' command to initiate
the procedure. The interface is designed to be scalable to support
additional commands in the future.

Reading the 'tx_eq_ctrl' entry provides a usage hint to the user,
ensuring the interface is self-documenting.

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
   |--tx_eq_ctrl

Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-debugfs.c |  61 ++++++++++++++++++
 drivers/ufs/core/ufs-txeq.c    | 109 +++++++++++++++++++++++++++++++--
 drivers/ufs/core/ufshcd-priv.h |   5 +-
 drivers/ufs/core/ufshcd.c      |   7 +--
 include/ufs/ufshcd.h           |   2 +
 5 files changed, 174 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index 831758b45163..e3dd81d6fe82 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -401,9 +401,70 @@ static const struct file_operations ufs_tx_eqtr_record_fops = {
 	.release	= single_release,
 };
 
+static ssize_t ufs_tx_eq_ctrl_write(struct file *file, const char __user *buf,
+				    size_t count, loff_t *ppos)
+{
+	u32 gear = (u32)(uintptr_t)file->f_inode->i_private;
+	struct ufs_hba *hba = hba_from_file(file);
+	char kbuf[32];
+	int ret;
+
+	if (count >= sizeof(kbuf))
+		return -EINVAL;
+
+	if (copy_from_user(kbuf, buf, count))
+		return -EFAULT;
+
+	if (!ufshcd_is_tx_eq_supported(hba))
+		return -EOPNOTSUPP;
+
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
+	    !hba->max_pwr_info.is_valid)
+		return -EBUSY;
+
+	if (!hba->ufs_device_wlun)
+		return -ENODEV;
+
+	kbuf[count] = '\0';
+
+	if (sysfs_streq(kbuf, "retrain")) {
+		ret = ufs_debugfs_get_user_access(hba);
+		if (ret)
+			return ret;
+		ret = ufshcd_retrain_tx_eq(hba, gear);
+		ufs_debugfs_put_user_access(hba);
+	} else {
+		/* Unknown operation */
+		return -EINVAL;
+	}
+
+	return ret ? ret : count;
+}
+
+static int ufs_tx_eq_ctrl_show(struct seq_file *s, void *data)
+{
+	seq_puts(s, "write 'retrain' to retrain TX Equalization settings\n");
+	return 0;
+}
+
+static int ufs_tx_eq_ctrl_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ufs_tx_eq_ctrl_show, inode->i_private);
+}
+
+static const struct file_operations ufs_tx_eq_ctrl_fops = {
+	.owner		= THIS_MODULE,
+	.open		= ufs_tx_eq_ctrl_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.write		= ufs_tx_eq_ctrl_write,
+	.release	= single_release,
+};
+
 static const struct ufs_debugfs_attr ufs_tx_eqtr_attrs[] = {
 	{ "host_tx_eqtr_record", 0400, &ufs_tx_eqtr_record_fops },
 	{ "device_tx_eqtr_record", 0400, &ufs_tx_eqtr_record_fops },
+	{ "tx_eq_ctrl", 0600, &ufs_tx_eq_ctrl_fops },
 	{ }
 };
 
diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
index 89ed932fe24e..dc4aa5c06a83 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -628,9 +628,15 @@ static int ufshcd_setup_tx_eqtr_adapt_length(struct ufs_hba *hba,
 					     struct ufshcd_tx_eq_params *params,
 					     u32 gear)
 {
+	struct ufshcd_tx_eqtr_record *rec = params->eqtr_record;
 	u32 adapt_eqtr;
 	int ret;
 
+	if (rec && rec->saved_adapt_eqtr) {
+		adapt_eqtr = rec->saved_adapt_eqtr;
+		goto set_adapt_eqtr;
+	}
+
 	if (gear == UFS_HS_G4 || gear == UFS_HS_G5) {
 		u64 t_adapt, t_adapt_local, t_adapt_peer;
 		u32 adapt_cap_local, adapt_cap_peer, adapt_length;
@@ -782,6 +788,10 @@ static int ufshcd_setup_tx_eqtr_adapt_length(struct ufs_hba *hba,
 		return -EINVAL;
 	}
 
+	if (rec)
+		rec->saved_adapt_eqtr = (u16)adapt_eqtr;
+
+set_adapt_eqtr:
 	ret = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXADAPTLENGTH_EQTR), adapt_eqtr);
 	if (ret)
 		dev_err(hba->dev, "Failed to set adapt length for TX EQTR: %d\n", ret);
@@ -847,16 +857,33 @@ static int ufshcd_apply_tx_eqtr_settings(struct ufs_hba *hba,
 /**
  * ufshcd_update_tx_eq_params - Update TX Equalization params
  * @params: TX EQ parameters data structure
+ * @pwr_mode: target power mode containing gear and rate
  * @eqtr_data: TX EQTR data structure
  *
- * Update TX Equalization params using results from TX EQTR data.
+ * Update TX Equalization params using results from TX EQTR data. Check also
+ * the TX EQTR FOM value for each TX lane in the TX EQTR data. If a TX lane got
+ * a FOM value of 0, restore the TX Equalization settings from the last known
+ * valid TX Equalization params for that specific TX lane.
  */
 static inline void
 ufshcd_update_tx_eq_params(struct ufshcd_tx_eq_params *params,
+			   struct ufs_pa_layer_attr *pwr_mode,
 			   struct ufshcd_tx_eqtr_data *eqtr_data)
 {
 	struct ufshcd_tx_eqtr_record *rec = params->eqtr_record;
 
+	if (params->is_valid) {
+		int lane;
+
+		for (lane = 0; lane < pwr_mode->lane_tx; lane++)
+			if (eqtr_data->host[lane].fom_val == 0)
+				eqtr_data->host[lane] = params->host[lane];
+
+		for (lane = 0; lane < pwr_mode->lane_rx; lane++)
+			if (eqtr_data->device[lane].fom_val == 0)
+				eqtr_data->device[lane] = params->device[lane];
+	}
+
 	memcpy(params->host, eqtr_data->host, sizeof(params->host));
 	memcpy(params->device, eqtr_data->device, sizeof(params->device));
 
@@ -955,7 +982,7 @@ static int __ufshcd_tx_eqtr(struct ufs_hba *hba,
 	dev_info(hba->dev, "TX EQTR procedure completed! Time elapsed: %llu ms\n",
 		 ktime_to_ms(ktime_sub(ktime_get(), start)));
 
-	ufshcd_update_tx_eq_params(params, eqtr_data);
+	ufshcd_update_tx_eq_params(params, pwr_mode, eqtr_data);
 
 	return ret;
 }
@@ -1086,6 +1113,7 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
  * ufshcd_config_tx_eq_settings - Configure TX Equalization settings
  * @hba: per adapter instance
  * @pwr_mode: target power mode containing gear and rate information
+ * @force_tx_eqtr: execute the TX EQTR procedure
  *
  * This function finds and sets the TX Equalization settings for the given
  * target power mode.
@@ -1093,7 +1121,8 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
  * Returns 0 on success, error code otherwise
  */
 int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
-				 struct ufs_pa_layer_attr *pwr_mode)
+				 struct ufs_pa_layer_attr *pwr_mode,
+				 bool force_tx_eqtr)
 {
 	struct ufshcd_tx_eq_params *params;
 	u32 gear, rate;
@@ -1133,7 +1162,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 	if (gear < UFS_HS_G4)
 		goto apply_tx_eq_settings;
 
-	if (!params->is_valid) {
+	if (!params->is_valid || force_tx_eqtr) {
 		int ret;
 
 		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
@@ -1200,3 +1229,75 @@ void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba)
 		}
 	}
 }
+
+/**
+ * ufshcd_retrain_tx_eq - Retrain TX Equalization and apply new settings
+ * @hba: per-adapter instance
+ * @gear: target High-Speed (HS) gear for retraining
+ *
+ * This function initiates a refresh of the TX Equalization settings for a
+ * specific HS gear. It scales the clocks to maximum frequency, negotiates the
+ * power mode with the device, retrains TX EQ and applies new TX EQ settings
+ * by conducting a Power Mode change.
+ *
+ * Returns 0 on success, non-zero error code otherwise
+ */
+int ufshcd_retrain_tx_eq(struct ufs_hba *hba, u32 gear)
+{
+	struct ufs_pa_layer_attr new_pwr_info, final_params = {};
+	int ret;
+
+	if (!ufshcd_is_tx_eq_supported(hba) || !use_adaptive_txeq)
+		return -EOPNOTSUPP;
+
+	if (gear < adaptive_txeq_gear)
+		return -ERANGE;
+
+	ufshcd_hold(hba);
+
+	ret = ufshcd_pause_command_processing(hba, 1 * USEC_PER_SEC);
+	if (ret) {
+		ufshcd_release(hba);
+		return ret;
+	}
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
+		dev_err(hba->dev, "Negotiated Gear (%u) does not match target Gear (%u)\n",
+			final_params.gear_tx, gear);
+		goto out;
+	}
+
+	ret = ufshcd_config_tx_eq_settings(hba, &final_params, true);
+	if (ret) {
+		dev_err(hba->dev, "Failed to config TX Equalization for HS-G%u, Rate-%s: %d\n",
+			final_params.gear_tx,
+			ufs_hs_rate_to_str(final_params.hs_rate), ret);
+		goto out;
+	}
+
+	/* Change Power Mode to apply the new TX EQ settings */
+	ret = ufshcd_change_power_mode(hba, &final_params,
+				       UFSHCD_PMC_POLICY_FORCE);
+	if (ret)
+		dev_err(hba->dev, "%s: Failed to change Power Mode to HS-G%u, Rate-%s: %d\n",
+			__func__, final_params.gear_tx,
+			ufs_hs_rate_to_str(final_params.hs_rate), ret);
+
+out:
+	ufshcd_resume_command_processing(hba);
+	ufshcd_release(hba);
+
+	return ret;
+}
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 7f18dbcd9343..8af60ee28d4a 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -80,6 +80,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd);
 int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us);
 void ufshcd_resume_command_processing(struct ufs_hba *hba);
+int ufshcd_scale_clks(struct ufs_hba *hba, unsigned long freq, bool scale_up);
 
 /**
  * enum ufs_descr_fmt - UFS string descriptor format
@@ -108,10 +109,12 @@ int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id);
 int ufshcd_uic_tx_eqtr(struct ufs_hba *hba, int gear);
 void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba);
 int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
-				 struct ufs_pa_layer_attr *pwr_mode);
+				 struct ufs_pa_layer_attr *pwr_mode,
+				 bool force_tx_eqtr);
 void ufshcd_print_tx_eq_params(struct ufs_hba *hba);
 bool ufshcd_is_txeq_presets_used(struct ufs_hba *hba);
 bool ufshcd_is_txeq_preset_selected(u8 preshoot, u8 deemphasis);
+int ufshcd_retrain_tx_eq(struct ufs_hba *hba, u32 gear);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0ee8bc156af1..f2cd587529fb 100644
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
@@ -4892,7 +4889,7 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 	}
 
-	ret = ufshcd_config_tx_eq_settings(hba, &final_params);
+	ret = ufshcd_config_tx_eq_settings(hba, &final_params, false);
 	if (ret)
 		dev_warn(hba->dev, "Failed to configure TX Equalization for HS-G%u, Rate-%s: %d\n",
 			 final_params.gear_tx,
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 35b1288327d0..bc9e48e89db4 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -341,12 +341,14 @@ struct ufshcd_tx_eqtr_data {
  * @device_fom: Device TX EQTR FOM record
  * @last_record_ts: Timestamp of the most recent TX EQTR record
  * @last_record_index: Index of the most recent TX EQTR record
+ * @saved_adapt_eqtr: Saved Adaptation length setting for TX EQTR
  */
 struct ufshcd_tx_eqtr_record {
 	u8 host_fom[UFS_MAX_LANES][TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMPHASIS];
 	u8 device_fom[UFS_MAX_LANES][TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMPHASIS];
 	ktime_t last_record_ts;
 	u16 last_record_index;
+	u16 saved_adapt_eqtr;
 };
 
 /**
-- 
2.34.1

