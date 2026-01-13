Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68669354AE2
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768291287; cv=none; b=N3jTofFv1gWniFjEAiJh2mZt9+AID68bsrDTiEMfEZ6zQh88kgVoCerG+vzTAWTE9vZ/xZ92HS5CRpEh7OltvncblUnvoNrxWchaFBo+U5PEbjWwcMSg6I1HB6dSjyejGdylk3uNMAcBOBh/SSe99EDV0i8jJMGkBc8z/AXLTe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768291287; c=relaxed/simple;
	bh=XK8gpOPgN9rwsWFcr91jX5z+ISqBvoVw62l63nwUkhI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sfyvLoHhDXcmZHu1qJpKKJKw6mRqELhb+SR9/PcrPfekzhvqmND5lt9Z3gu9zaW2WwOBGBPf2ejGaO0sTh3utPH781lhAO0RGUi8Y+lZkTQWjOwb3MpagOEV3JBurfREfnm7X9mc8KnwkSgEgfewnz2+bNbv+Zzw9H1Ub5icbe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a/Io43aU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UYVLgVdG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a/Io43aU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UYVLgVdG"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60D5nMM33734990
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:01:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=QAjCo0V1My5
	AY/MhuD/dD54xGY8gMH823+BlsIXPwOY=; b=a/Io43aUbWDAjLUSqa2jHZsqcMf
	Yvt40pKtbp8u1GosQzXugCwsrX5A26EVssjLwP2KGALx6GR/b5pOKZvE5KnUNnIc
	9imc4YUMpFluhGDvivbEC/dFr04fy/H89ls2PHSATaXDZIudYBneAsvPnwzZrP/3
	2nDtJdfWsz6bmlM+u1L9E5mXCXWXd4UkcTml7eWBPfwM6nUmfDa+aeWgPtHMgHJn
	KB7UQ/+8T18ejx+GMO4oTgJPQYrGErMIYU6fDeWCQRz4K1PXS/UtBYb2oNTMyvH9
	3bxTCJaI7ZaAEQGT5vLCgu2Gq5HLJ2oguqak8ZM7RxA0SyhsX23Dw+ZMh1Q==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bng878bed-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 08:01:18 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a31087af17so94147095ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2026 00:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1768291277; x=1768896077; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QAjCo0V1My5AY/MhuD/dD54xGY8gMH823+BlsIXPwOY=;
        b=UYVLgVdG5DhUvyr98Ni5/NV7YqBJFtuyusLjcady8NxtT+jEtwd4aqoSPk4abSZR9s
         ebJef1x+8F2VGMTdGGS7UW4txxwolG/Dm6XskfbYwW4D0qLWdy8GNByH2awDkO9Ui294
         9Rb1R599Ujz549A46H6sEcA29Dy/0zehoqk38CMqU+kQsdY8HY14ZKZoDXwZ1VX5bk/f
         bBiLzhYE2oVsb0VsHj8J71AkHf9hp6TSi/9jG+BMJu1YJVsGTEOjDeWZXa9rt9xyZdiW
         jC+o1jR8DmV8fQTN0sDK8e1YNUN5IWEggWCO9SRvbRX5aQUWi5ZqnnzQqSKxMAqhyCYf
         4W6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768291277; x=1768896077;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QAjCo0V1My5AY/MhuD/dD54xGY8gMH823+BlsIXPwOY=;
        b=lSvi3CYRML+qIJYrJjc0xt/u6lmQPTs+MyD7WjIGjFgqHJwmDhQ6vSkRE10LAmuzY2
         fS2oDZbmmTPz9mSoPJwD5RoJ6eFa9iq4aAVAUPzCrcIS/nE4YKmbXr1fweW/P0u1Vdca
         PsaEAyXEbV76yLVn0fH/V7bEVwJVA++LNFCvvLBY5/m8yf8VTrxcYi7RsFPiiCoQO+5m
         JoqeHKdjT9GfTBPEEY6Ol8IyJ18MHgrS23zPqf82mFT64ytFwaXiG9xEiTLm4NvWvN9p
         1KlxYKwLfGW+uFi4sGQzKR1Diq5+EMgjUsj3NAuPpQ76VN22P1Iby+M9wA4U+7a9sJ2D
         x+PA==
X-Forwarded-Encrypted: i=1; AJvYcCW6DjDF6O6Y8I82JYljTkhAtCskGbcXcHKyXpahgTOcGkRvWln6o/AJ+o4O9BE0KN/mdq5usw4MmCRy@vger.kernel.org
X-Gm-Message-State: AOJu0YxwAwzwuu8s0WuyCiSLVrjX5Xv2nGrgrG9uJT9V8R1Z7b3YawCO
	cBdnCHihFarFM+hmuPKbzLm1swP3gYu+12NhiTTO0iUdew0b9lAjmQiHFUYaSgIvm+RKVEMEH1J
	fXbho/OrBlKp8KtoXoPZEK2nBSJKXvqxBfQeNhu6NA+CBsXsF873QB3fYZnuwvDRb
X-Gm-Gg: AY/fxX7qrhj72ncZeWNvDxzh8px3wNfO2/FGBGFoZRyui1RQd9ABXeS6bX4lAKix5qu
	l/ObHWZIAbot622EDgqtLH40cemH83HwKDDDdS/zOJE9Vw+VJeWXNOs6tnnKiIqq8zh3GmMp/IC
	XATGgiFkvhPo/mGvZ41biYaDf+UWGon6FV6eiEXueiWQZUhcZlTAAKHWT3dwBR/Y3Gh1UWlwnHw
	v1l627zmpktLvGL4KuGSmW3Y5x7HruByBLWSp6eNCq5ZLqTIdlfFJP+mCAo/zSzk/YilGVdHxBK
	prZZm8E51RQTLWz7b0pXCz0F3kVQ6cP431d/i9R4FGJt+gCQoXNvyiYtfB3b9o2OJvxiVUxS6TH
	d/nC12kwT0WKOanSfBMD4ZjsUkQ7ouCW8RL3G34q7
X-Received: by 2002:a17:902:c406:b0:2a0:9923:6954 with SMTP id d9443c01a7336-2a3ee48fbf3mr175858895ad.27.1768291276916;
        Tue, 13 Jan 2026 00:01:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHDpZkrucyrRCmXeXMPckJQy7yAmhXICk1uU3T0FskJTRg50++uCHNweWpQjhc6hAOTflTUaA==
X-Received: by 2002:a17:902:c406:b0:2a0:9923:6954 with SMTP id d9443c01a7336-2a3ee48fbf3mr175858595ad.27.1768291276426;
        Tue, 13 Jan 2026 00:01:16 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c48c15sm191132725ad.27.2026.01.13.00.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 00:01:16 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V5 3/4] scsi: ufs: core Enforce minimum pm level for sysfs configuration
Date: Tue, 13 Jan 2026 13:30:45 +0530
Message-Id: <20260113080046.284089-4-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260113080046.284089-1-ram.dwivedi@oss.qualcomm.com>
References: <20260113080046.284089-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEzMDA2NiBTYWx0ZWRfXyovYBKWVB239
 G3UKlHxHk9CZn4Jd9uue/5gplDEnpqxaG0P9T3PMo1VLq9dZEqlUtqZrhllJUlD100GNBVgB+q8
 L0PBSVwK4QftcrfNDwztV1xO21dS9AdZ9oJMAZr2XRawSqvRvs/B6hwsQmIpMAMxl/1pxcadLj4
 d2moMKgwE78/D+GaXMj7Ab5wdSdADVWrdIFIC6igExT0rZ8xQvWdN2Chgi35rVScq/QyNU/ldHg
 +ny8T6c1m5bV3y6yRWLqkqcqAPTGIqoF9gZXbY7grKQMsXe4v5zxJBDHBl/xUwK295CHdeLHCAz
 NB70dLJpGvUv1txwlyVyCVAvjMjLjfxFiX29vHASVUXd8gsw33WLpttLAf7sLqTrEJPrGaFPnQc
 7nE11VqjjfsqyeVMlUXiymFu5XmEw9hug7HasEJqQ/ZfYDdRvBnHDdbXR89aMEn74IsSTmxpBNH
 Nm4Zlqr+p0s3a8okmjQ==
X-Proofpoint-ORIG-GUID: 7RdajPPXxZrMWL3ZZAeERSa-9OoM8xWV
X-Authority-Analysis: v=2.4 cv=IOEPywvG c=1 sm=1 tr=0 ts=6965fbce cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=chdQYeBgf-UdQiD2u_cA:9 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: 7RdajPPXxZrMWL3ZZAeERSa-9OoM8xWV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-13_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601130066

Some UFS platforms only support a limited subset of power levels.
Currently, the sysfs interface allows users to set any pm level
without validating the minimum supported value. If an unsupported
level is selected, suspend may fail.

Introduce an pm_lvl_min field in the ufs_hba structure and use it
to clamp the pm level requested via sysfs so that only supported
levels are accepted. Platforms that require a minimum pm level
can set this field during probe.

Signed-off-by: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-sysfs.c | 2 +-
 include/ufs/ufshcd.h         | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index b33f8656edb5..02e5468ad49d 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -141,7 +141,7 @@ static inline ssize_t ufs_sysfs_pm_lvl_store(struct device *dev,
 	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
-	if (value >= UFS_PM_LVL_MAX)
+	if (value >= UFS_PM_LVL_MAX || value < hba->pm_lvl_min)
 		return -EINVAL;
 
 	if (ufs_pm_lvl_states[value].dev_state == UFS_DEEPSLEEP_PWR_MODE &&
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 19154228780b..a64c19563b03 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -834,6 +834,7 @@ enum ufshcd_mcq_opr {
  * @uic_link_state: active state of the link to the UFS device.
  * @rpm_lvl: desired UFS power management level during runtime PM.
  * @spm_lvl: desired UFS power management level during system PM.
+ * @pm_lvl_min: minimum supported power management level.
  * @pm_op_in_progress: whether or not a PM operation is in progress.
  * @ahit: value of Auto-Hibernate Idle Timer register.
  * @outstanding_tasks: Bits representing outstanding task requests
@@ -972,6 +973,7 @@ struct ufs_hba {
 	enum ufs_pm_level rpm_lvl;
 	/* Desired UFS power management level during system PM */
 	enum ufs_pm_level spm_lvl;
+	enum ufs_pm_level pm_lvl_min;
 	int pm_op_in_progress;
 
 	/* Auto-Hibernate Idle Timer register value */
-- 
2.34.1

