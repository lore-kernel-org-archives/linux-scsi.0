Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A83F30FC0F
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767156998; cv=none; b=g14wl6LXmghCJScTMNyssf6sNURNeicDbicJkYgT34VSjOJK+lSVPiK3D8/3FpyTs4621tSqjx0PFllBR//h/AmhpCS+Ej1fe7YtG3Pdgt1YlAkOIT6h7r+Sliu15V2+VfJsDAWOYkuM0UtXE/HlzmJfcbvO7gDRozwdnkyn5ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767156998; c=relaxed/simple;
	bh=D1O+si2Yt1LHRX9ttPtLSW9kr0/xClDgoku245+GvJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dj5uWoqK/M71fzc1pCh0Oi8tl43F2rN+RhQwTIorVl6/gP9PisLqnW+kgOn5PRCN1yd8gWQPehbU43MP6BATxoX2OBjTQLBFJm1Q5VXrtuv/StsUR089GmStd7fjydpkSkuvij1wVKuanuxp16kEI3T6v1H9yFUalABuKi1O/nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ncwQE9x+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VhThdok2; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ncwQE9x+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VhThdok2"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV04hJP2379791
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=09GkqJKtIHi
	QNekPzoYMiNgzGedCPpCvBabWAf+0JyA=; b=ncwQE9x+LRdHyEhfxarpEX/n/FW
	ZzRNOOOaELV2g+BUKlqc5hhhQ8fjEcB+BiDWZkTMin3HWiSa7wFUHLDCxuMyNAPz
	RBJofHNUY9nmRxqOxJ/C3z+G49Igjy7w5mFvRul1r1zZBUcwrvIrXxnX2q5IG/3a
	jzfZd/T45y60yiVveI3SwJlIarlCuqPvce7j4P00Emudgr2neyihBeePbo56Yv8d
	mvD4St0syjGy//IhjJo7tUqyODDcqbnFSqEQyAWR95cuVd5NIKIOMzJrpGYbIDzO
	m1S4psHOh0ElDsT7xKJ72KvjT2q2Qk7KiNHfdeVPKsWUOHJPvpbKUlQLwvw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc06gunwu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:35 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c213419f5so9647173a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 20:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767156995; x=1767761795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=09GkqJKtIHiQNekPzoYMiNgzGedCPpCvBabWAf+0JyA=;
        b=VhThdok2jZkshmSDmNPAfmlBJ/2xP3YRAfqcOjksFncWS7N3O3zTPLZ6pevDy3Da53
         jvKWDDbqSHBcFAX/rPfXIzzEycFpeN08Thk01YLjILPdfeztN9zy2Oirxiu3AkDTt8JZ
         ak+2XUYEXmNnWVEyF08McoSCVfZMNrxDHiRFdViKyJQh51P+qGLI/qE40R51FNxN1Cab
         G7n2/8dMokQjMJjnr/AurEicMSn98OkSUqD0mXYn4d4GLrm6iyo4YYvLQ7/Z9rvgZLay
         8Dmin5I1VPjT/nsnihx1MqWSCHosIFSNFo0SNOay+MqSKcnmh7n+pD86bRcOLpTeD2H+
         BYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767156995; x=1767761795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=09GkqJKtIHiQNekPzoYMiNgzGedCPpCvBabWAf+0JyA=;
        b=YfCVlZ9V2xmQ295Y/a/2oNp4YXSoEtcZGzr95igOInDNvJtX0VfpnWeNSj02jCFu6Z
         o+ZUxpFvzJ4dp4QFwt6BNzpGuCbcOKPYwKIh2uRPj6NQsxL3wl1pa27+6fn8j5nnWDMj
         C/WBFFtgD5u06/CwuuU0aBn1uTmE/eo5BlhjRvHh5ITutLHm+UbMvZL7pOtW1/LBhT7z
         9sfCrl7ErzuUqqSoJgIBjaYpGqqwPnV51o4jfqVKJzxsDi3iCXl0oyJs4Q/K1ivnqsvk
         iR7aGZgGEQNoJ8dytE4v6WdeMkWGnCUHhPl4GxhGASXg+wwqYnopor6ONMuDXzjmlGRG
         DrZg==
X-Forwarded-Encrypted: i=1; AJvYcCVlimvoLYjXmnVZlaZ6oZuLgyM0hdTFwxDQvOTWwXJxuNHtN9iy6Cjpxkd/EwQIaytKqEgXC9ZgLGpk@vger.kernel.org
X-Gm-Message-State: AOJu0YwDcBf56KbRrOzfseytEDP6QjqQsh3sQhWC3tIHg3BRGx4xOTGS
	2GE5xrPUoG2HvhDVxkNcp50toIbnRTVD93Nj+vitkD/oWZ327HGqt6VutJZ3CphPdJfdDiaHJwZ
	+4u5qptudN8tQVpTiOIpHgtFIK8bbpFX9KnXlci1RXheg93XSW7DGZGU8vM7WBbUC
X-Gm-Gg: AY/fxX5iQihNkmq1MhxqQeiR6rmMLz9LGwGyLtrIFBpAolrk4aRs86lZyT4th7mOlTM
	TqS3Ru0Ns1SomQUymboRHYkC9oLyo2mOhI9bzmA5sH2EaHmZ5OZXWcddM9BX/zHVM0o1wVuYNg2
	f505DuelwirkD1ALyAzA3ZJ0bs3G39r83FAZfl1Z8zVi8a21rlAvjDe+J4Nrh78t7WB3lqeHEhq
	jlCjuSMfVlNb1RntyxlZ40CDdTss8l1OkjbfDgUaVKGZ6wFEHeaVCQrtUU52tOrWEBnih5oKVDh
	mZqcat84y3FI/rmzJYVwjOV9+52PUy2UimYS58Oj56LPhkDnRi16uw0PYUduLsiu1f/JaMIMDcw
	qWXditXX74cOYxswHj1UqSmm211SAU1PDlrd0RALv
X-Received: by 2002:a17:90b:1f89:b0:340:6f07:fefa with SMTP id 98e67ed59e1d1-34e921af98amr31649624a91.20.1767156994900;
        Tue, 30 Dec 2025 20:56:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFPPklYGJKPHXvfbOG+LeQT6y471CntsLmLLEInh4Km4O3Wovsq7fcPsnxKQlHGWy69xSmyHQ==
X-Received: by 2002:a17:90b:1f89:b0:340:6f07:fefa with SMTP id 98e67ed59e1d1-34e921af98amr31649597a91.20.1767156994398;
        Tue, 30 Dec 2025 20:56:34 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70d4f7d3sm34547697a91.4.2025.12.30.20.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 20:56:33 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com,
        anjana.hari@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shazad Hussain <shazad.hussain@oss.qualcomm.com>
Subject: [PATCH V3 4/4] ufs: ufs-qcom: Add support for firmware-managed resource abstraction
Date: Wed, 31 Dec 2025 10:25:53 +0530
Message-Id: <20251231045553.622611-5-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251231045553.622611-1-ram.dwivedi@oss.qualcomm.com>
References: <20251231045553.622611-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: v51ezXUn62Jo6uxlvAbPQSdom7z-cXX8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDAzOSBTYWx0ZWRfX+WIpxFaLrLNy
 MbtaIXHvPMOHXbn+wYi4+HowwAAVX/BwYJ5Ii8hnfbVFY1rRkToPQQfJ5JBGS999BbENp13pskg
 jdFZhIzBkk27rCSr0P2f75JS+76bephWX8noe3CnnE7JoaUuYJgYb8NWndV3BmHcwXt0wBd2y01
 Z8Wp6yrjvJXeNMeyLx4KFxQXPFU6Xnp/pzzZ+s0Ll4VkzA8Gy+UsVhb82G8DsgSv02/uIxeJldq
 C7ZWqetBB7qCFZOPkMSQgVv3MITd2HXdf/RutSAwuh9bouuHRi4wAlTV2bVttfxQGMYklis5xwR
 FWybEdGqzO8cnq74whNz1CI+3/YLsu1A0Jk2vv+h0ZTJ0+ZNlQCudd2v4n7JNuU76l3f8YvJr0l
 hY17KDCbvD+YnWxPuQ6LW/Ha4XEkNgmiRAuVs5ddYxViBVZO7bhZCsCvCCp8D5plamSxDT8ZGqx
 MJwXHRoyc4We4l+DbQQ==
X-Authority-Analysis: v=2.4 cv=A45h/qWG c=1 sm=1 tr=0 ts=6954ad03 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=YNeBtJC1tzGph8_Y4V8A:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: v51ezXUn62Jo6uxlvAbPQSdom7z-cXX8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512310039

Add a compatible string for SA8255p platforms where resources such as
PHY, clocks, regulators, and resets are managed by firmware through an
SCMI server. Use the SCMI power protocol to abstract these resources and
invoke power operations via runtime PM APIs (pm_runtime_get/put_sync).

Introduce vendor operations (vops) for SA8255p targets to enable SCMI-
based resource control. In this model, capabilities like clock scaling
and gating are not yet supported; these will be added incrementally.

Co-developed-by: Anjana Hari <anjana.hari@oss.qualcomm.com>
Signed-off-by: Anjana Hari <anjana.hari@oss.qualcomm.com>
Co-developed-by: Shazad Hussain <shazad.hussain@oss.qualcomm.com>
Signed-off-by: Shazad Hussain <shazad.hussain@oss.qualcomm.com>
Signed-off-by: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 164 +++++++++++++++++++++++++++++++++++-
 drivers/ufs/host/ufs-qcom.h |   1 +
 2 files changed, 164 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8ebee0cc5313..ddca7b344642 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -14,6 +14,7 @@
 #include <linux/of.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/pm_domain.h>
 #include <linux/reset-controller.h>
 #include <linux/time.h>
 #include <linux/unaligned.h>
@@ -619,6 +620,27 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_qcom_fw_managed_hce_enable_notify(struct ufs_hba *hba,
+						 enum ufs_notify_change_status status)
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	switch (status) {
+	case PRE_CHANGE:
+		ufs_qcom_select_unipro_mode(host);
+		break;
+	case POST_CHANGE:
+		ufs_qcom_enable_hw_clk_gating(hba);
+		ufs_qcom_ice_enable(host);
+		break;
+	default:
+		dev_err(hba->dev, "Invalid status %d\n", status);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /**
  * ufs_qcom_cfg_timers - Configure ufs qcom cfg timers
  *
@@ -789,6 +811,38 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	return ufs_qcom_ice_resume(host);
 }
 
+static int ufs_qcom_fw_managed_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
+				       enum ufs_notify_change_status status)
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+
+	if (status == PRE_CHANGE)
+		return 0;
+
+	if (hba->spm_lvl != UFS_PM_LVL_5) {
+		dev_err(hba->dev, "Unsupported spm level %d\n", hba->spm_lvl);
+		return -EINVAL;
+	}
+
+	pm_runtime_put_sync(hba->dev);
+
+	return ufs_qcom_ice_suspend(host);
+}
+
+static int ufs_qcom_fw_managed_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+	int err;
+
+	err = pm_runtime_resume_and_get(hba->dev);
+	if (err) {
+		dev_err(hba->dev, "PM runtime resume failed: %d\n", err);
+		return err;
+	}
+
+	return ufs_qcom_ice_resume(host);
+}
+
 static void ufs_qcom_dev_ref_clk_ctrl(struct ufs_qcom_host *host, bool enable)
 {
 	if (host->dev_ref_clk_ctrl_mmio &&
@@ -1421,6 +1475,55 @@ static void ufs_qcom_exit(struct ufs_hba *hba)
 	phy_exit(host->generic_phy);
 }
 
+static int ufs_qcom_fw_managed_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct ufs_qcom_host *host;
+	int err;
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	host->hba = hba;
+	ufshcd_set_variant(hba, host);
+
+	ufs_qcom_get_controller_revision(hba, &host->hw_ver.major,
+					 &host->hw_ver.minor, &host->hw_ver.step);
+
+	err = ufs_qcom_ice_init(host);
+	if (err)
+		goto out_variant_clear;
+
+	ufs_qcom_get_default_testbus_cfg(host);
+	err = ufs_qcom_testbus_config(host);
+	if (err)
+		/* Failure is non-fatal */
+		dev_warn(dev, "Failed to configure the testbus %d\n", err);
+
+	hba->caps |= UFSHCD_CAP_WB_EN;
+
+	ufs_qcom_advertise_quirks(hba);
+	host->hba->quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
+
+	hba->pm_lvl_min = UFS_PM_LVL_5;
+	hba->spm_lvl = hba->rpm_lvl = hba->pm_lvl_min;
+
+	ufs_qcom_set_host_params(hba);
+	ufs_qcom_parse_gear_limits(hba);
+
+	return 0;
+
+out_variant_clear:
+	ufshcd_set_variant(hba, NULL);
+	return err;
+}
+
+static void ufs_qcom_fw_managed_exit(struct ufs_hba *hba)
+{
+	pm_runtime_put_sync(hba->dev);
+}
+
 /**
  * ufs_qcom_set_clk_40ns_cycles - Configure 40ns clk cycles
  *
@@ -1950,6 +2053,39 @@ static int ufs_qcom_device_reset(struct ufs_hba *hba)
 	return 0;
 }
 
+/**
+ * ufs_qcom_fw_managed_device_reset - Reset UFS device under FW-managed design
+ * @hba: pointer to UFS host bus adapter
+ *
+ * In the firmware-managed reset model, cold boot power-on is handled
+ * automatically by the PM domain framework during SCMI protocol init,
+ * before ufshcd_device_reset() is reached. For subsequent resets
+ * (such as suspend/resume or recovery), the UFS driver must explicitly
+ * invoke PM runtime operations to reset the subsystem.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+static int ufs_qcom_fw_managed_device_reset(struct ufs_hba *hba)
+{
+	static bool is_boot = true;
+	int err;
+
+	/* Skip reset on cold boot; perform it on subsequent calls */
+	if (is_boot) {
+		is_boot = false;
+		return 0;
+	}
+
+	pm_runtime_put_sync(hba->dev);
+	err = pm_runtime_resume_and_get(hba->dev);
+	if (err < 0) {
+		dev_err(hba->dev, "PM runtime resume failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
 					struct devfreq_dev_profile *p,
 					struct devfreq_simple_ondemand_data *d)
@@ -2229,6 +2365,20 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.freq_to_gear_speed	= ufs_qcom_freq_to_gear_speed,
 };
 
+static const struct ufs_hba_variant_ops ufs_hba_qcom_sa8255p_vops = {
+	.name                   = "qcom-sa8255p",
+	.init                   = ufs_qcom_fw_managed_init,
+	.exit                   = ufs_qcom_fw_managed_exit,
+	.hce_enable_notify      = ufs_qcom_fw_managed_hce_enable_notify,
+	.pwr_change_notify      = ufs_qcom_pwr_change_notify,
+	.apply_dev_quirks       = ufs_qcom_apply_dev_quirks,
+	.fixup_dev_quirks       = ufs_qcom_fixup_dev_quirks,
+	.suspend                = ufs_qcom_fw_managed_suspend,
+	.resume                 = ufs_qcom_fw_managed_resume,
+	.dbg_register_dump      = ufs_qcom_dump_dbg_regs,
+	.device_reset           = ufs_qcom_fw_managed_device_reset,
+};
+
 /**
  * ufs_qcom_probe - probe routine of the driver
  * @pdev: pointer to Platform device handle
@@ -2239,9 +2389,16 @@ static int ufs_qcom_probe(struct platform_device *pdev)
 {
 	int err;
 	struct device *dev = &pdev->dev;
+	const struct ufs_hba_variant_ops *vops;
+	const struct ufs_qcom_drvdata *drvdata = device_get_match_data(dev);
+
+	if (drvdata && drvdata->vops)
+		vops = drvdata->vops;
+	else
+		vops = &ufs_hba_qcom_vops;
 
 	/* Perform generic probe */
-	err = ufshcd_pltfrm_init(pdev, &ufs_hba_qcom_vops);
+	err = ufshcd_pltfrm_init(pdev, vops);
 	if (err)
 		return dev_err_probe(dev, err, "ufshcd_pltfrm_init() failed\n");
 
@@ -2269,10 +2426,15 @@ static const struct ufs_qcom_drvdata ufs_qcom_sm8550_drvdata = {
 	.no_phy_retention = true,
 };
 
+static const struct ufs_qcom_drvdata ufs_qcom_sa8255p_drvdata = {
+	.vops = &ufs_hba_qcom_sa8255p_vops
+};
+
 static const struct of_device_id ufs_qcom_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,ufshc" },
 	{ .compatible = "qcom,sm8550-ufshc", .data = &ufs_qcom_sm8550_drvdata },
 	{ .compatible = "qcom,sm8650-ufshc", .data = &ufs_qcom_sm8550_drvdata },
+	{ .compatible = "qcom,sa8255p-ufshc", .data = &ufs_qcom_sa8255p_drvdata },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ufs_qcom_of_match);
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 380d02333d38..1111ab34da01 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -313,6 +313,7 @@ struct ufs_qcom_host {
 struct ufs_qcom_drvdata {
 	enum ufshcd_quirks quirks;
 	bool no_phy_retention;
+	const struct ufs_hba_variant_ops *vops;
 };
 
 static inline u32
-- 
2.34.1

