Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED76E27F00A;
	Sun,  8 Mar 2026 15:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772982923; cv=none; b=d5aP1p4yT8aLBp31gZZMc/Hh8dFfR6/33hb6FXrswlbz/QNpuilAYmwSYBke0QnCVOTZpj3fRf2feYi8zs7Zz9Q+wL6cxbFKNNfxHL7kIJ9V5jvgVynbLgttyrSHm2yilYfFwYfe0IlYs/83OP1vZewYPl8NNyEo8O7rpolBems=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772982923; c=relaxed/simple;
	bh=dTNDo8dbjiHZE4ZBOcBGmYUa4Wv6j7z0Wjd9YlxX3Sg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fIKsX2lsOTg45rRON1q9Z7mMJjvQBsuZY2ejPcEnqGje8CBK0PEHqcEIg14tQZxGSI2bi+ov7ho+AslDJeO+8PyRcN+N50cr2UK2wEG3m/xAFJQLZaFG3YhdQr6JCMN0Y2PfuilvtHB6smxzRmfuUYpl52bPM8wHHiT0Pz9d2ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SGm0LjuF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SGm0LjuF"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628CT6dX1756853;
	Sun, 8 Mar 2026 15:15:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=XiQlo4Zej0x
	ooEE/mrRzIQ9CRxVeOMDTZJG35Q9y2I4=; b=SGm0LjuFVobeid+1mHEQZmMqKpL
	njjkRQDlcIQipKZCEp7yZTFSgRXu+oOpTcZ9ijPb4UMovUEvKnUcUTszaPLB4KAQ
	If36vrhWIBJ1smkk6mn1I1P7cYgE7AwH+l1lsfhKfY288LgFRMsCNzxTKvQXV6tU
	hVse8tQIT2MxmEJMvBWGFis+I3FEUdi1VCxlQRWgisi5EfaioAIfosXeU+tT+dgD
	Rh+wS0xrnvmyfzehhjtiPfR3b41BrJWXouohlnuYs6Ck0HYqfQ/7GOUPScS//WEE
	0mtEaOuFwHcoWayO2oF6zA77KOlZiBxd+VmTqIMMKPeVMNjGYXmkz2I8ZtQ==
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4crbkxtrm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:15:06 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 628FF5QF029820;
	Sun, 8 Mar 2026 15:15:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 4crd3mjvfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:15:05 +0000
Received: from NALASPPMTA04.qualcomm.com (NALASPPMTA04.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 628FF4Tq029810;
	Sun, 8 Mar 2026 15:15:04 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-cang-lv.qualcomm.com [10.81.25.255])
	by NALASPPMTA04.qualcomm.com (PPS) with ESMTPS id 628FF4AZ029807
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 08 Mar 2026 15:15:04 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 359480)
	id 9DCC65A4; Sun,  8 Mar 2026 08:15:04 -0700 (PDT)
From: Can Guo <can.guo@oss.qualcomm.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Can Guo <can.guo@oss.qualcomm.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 07/12] scsi: ufs: core: Add support to refresh TX Equalization via debugfs
Date: Sun,  8 Mar 2026 08:14:04 -0700
Message-Id: <20260308151409.3779137-8-can.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA4MDE0MCBTYWx0ZWRfX8GNgeuObT3V4
 BcAXCLs2XjaAWJAmKTDVyhx4kDZ5tvVWrEfnMP3vt4t9vdd8l7i4qpz8SlIDOlzjWrD98NC935p
 cCSuL5RlcK8FTPnrsD5tPm82aA/RUVQwGqwbW1nProweX+4Z9ve8jLD6Gvq4zhruooNlmPBBTiu
 CL7OASoIDkATtgpr5muq9SvAIu6GFIoszloFAAovLXl/sSTa+w0mzdKYsbl4q0jSOqHUlKit98j
 b/fIhqFkIOeyrOa5B8GkdA3TBwhCvUdkRaluV8hpb5cFqXHXWALgF1JdEc+xhAOocGUVOoxg+SP
 WI1MQ9BASdkKQq17E0xvP23tNI57HlXe+ifMlpcLa0VknYHwK/WaRd5eOW4+ClZKS0eHhx/ddIN
 34MRCwBX+simk/xONQl4Awa2nZFfPi+Ogy37A/9ojARDyrg+tbdSDyPJtErWLNXLRh6eZRgyuTt
 cvloH+rIzxZvzPOANOg==
X-Proofpoint-ORIG-GUID: vEdT5QHK4IaqBniwc9uo3S5hIBNC-aiw
X-Proofpoint-GUID: vEdT5QHK4IaqBniwc9uo3S5hIBNC-aiw
X-Authority-Analysis: v=2.4 cv=LOprgZW9 c=1 sm=1 tr=0 ts=69ad927a cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8 a=r2bqU_pdSQlm8wuFfEYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-08_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0 adultscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603080140

Drastic environmental changes, such as significant temperature shifts, can
impact link signal integrity. In such cases, refreshing TX Equalization is
necessary to compensate for these environmental changes.

Add a debugfs entry, 'tx_eq_ctrl', to allow userspace to manually trigger
the TX Equalization training (EQTR) procedure and apply the identified
optimal settings on the fly. These entries are created on a per-gear basis
for High Speed Gear 4 (HS-G4) and above, as TX EQTR is not supported for
lower gears.

The 'tx_eq_ctrl' entry currently accepts the 'refresh' command to initiate
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
 drivers/ufs/core/ufs-debugfs.c | 61 ++++++++++++++++++++++++++
 drivers/ufs/core/ufs-txeq.c    | 78 +++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd-priv.h |  5 ++-
 drivers/ufs/core/ufshcd.c      |  7 +--
 4 files changed, 143 insertions(+), 8 deletions(-)

diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
index 6f7562846f5b..b3bb2c850ad2 100644
--- a/drivers/ufs/core/ufs-debugfs.c
+++ b/drivers/ufs/core/ufs-debugfs.c
@@ -383,9 +383,70 @@ static const struct file_operations ufs_tx_eqtr_record_fops = {
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
+	kbuf[count] = '\0';
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
+	if (sysfs_streq(kbuf, "refresh")) {
+		ret = ufs_debugfs_get_user_access(hba);
+		if (ret)
+			return ret;
+		ret = ufshcd_refresh_tx_eq(hba, gear);
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
+	seq_puts(s, "write 'refresh' to refresh TX Equalization settings\n");
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
index d77fa3f5e16d..c68b232b1598 100644
--- a/drivers/ufs/core/ufs-txeq.c
+++ b/drivers/ufs/core/ufs-txeq.c
@@ -1099,6 +1099,7 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
  * ufshcd_config_tx_eq_settings - Configure TX Equalization settings
  * @hba: per adapter instance
  * @pwr_mode: target power mode containing gear and rate information
+ * @force_tx_eqtr: execute the TX EQTR procedure
  *
  * This function finds and sets the TX Equalization settings for the given
  * target power mode.
@@ -1106,7 +1107,8 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
  * Returns 0 on success, error code otherwise
  */
 int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
-				 struct ufs_pa_layer_attr *pwr_mode)
+				 struct ufs_pa_layer_attr *pwr_mode,
+				 bool force_tx_eqtr)
 {
 	struct ufshcd_tx_eq_params *params;
 	u32 gear, rate;
@@ -1141,7 +1143,7 @@ int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
 	if (gear < UFS_HS_G4)
 		goto apply_tx_eq_settings;
 
-	if (!params->is_valid) {
+	if (!params->is_valid || force_tx_eqtr) {
 		int ret;
 
 		ret = ufshcd_tx_eqtr(hba, params, pwr_mode);
@@ -1212,3 +1214,75 @@ void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba)
 		}
 	}
 }
+
+/**
+ * ufshcd_refresh_tx_eq - Retrain TX Equalization and apply new settings
+ * @hba: per-adapter instance
+ * @gear: target High-Speed (HS) gear for retraining
+ *
+ * This function initiates a refresh of the TX Equalization settings for a
+ * specific HS gear. It scales the clocks to maximum frequency, negotiates the
+ * power mode with the device, retrains TX EQ and applies new TX EQ settings
+ * through a Power Mode change.
+ *
+ * Returns 0 on success, non-zero error code otherwise
+ */
+int ufshcd_refresh_tx_eq(struct ufs_hba *hba, u32 gear)
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
index 2303d57bf874..fa5419e33d54 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -80,6 +80,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
 void ufshcd_release_scsi_cmd(struct ufs_hba *hba, struct scsi_cmnd *cmd);
 int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us);
 void ufshcd_resume_command_processing(struct ufs_hba *hba);
+int ufshcd_scale_clks(struct ufs_hba *hba, unsigned long freq, bool scale_up);
 
 /**
  * enum ufs_descr_fmt - UFS string descriptor format
@@ -108,8 +109,10 @@ int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exception_id);
 int ufshcd_uic_tx_eqtr(struct ufs_hba *hba, int gear);
 void ufshcd_apply_valid_tx_eq_settings(struct ufs_hba *hba);
 int ufshcd_config_tx_eq_settings(struct ufs_hba *hba,
-				 struct ufs_pa_layer_attr *pwr_mode);
+				 struct ufs_pa_layer_attr *pwr_mode,
+				 bool force_tx_eqtr);
 void ufshcd_print_tx_eq_params(struct ufs_hba *hba);
+int ufshcd_refresh_tx_eq(struct ufs_hba *hba, u32 target_gear);
 
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6fef24612be1..f2846ac49775 100644
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
@@ -4887,7 +4884,7 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 	if (ret)
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 
-	ret = ufshcd_config_tx_eq_settings(hba, &final_params);
+	ret = ufshcd_config_tx_eq_settings(hba, &final_params, false);
 	if (ret)
 		dev_warn(hba->dev, "Failed to configure TX Equalization for HS-G%u, Rate-%s: %d\n",
 			 final_params.gear_tx,
-- 
2.34.1

