Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29BA2DF126
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767156995; cv=none; b=I50WWrJ8T9/L+5+UwnYefHOs33X1Wafzo+/m91MOkHVepZUJRhOK4P4NEKN93lHqCdqDWHgG/O32fEiUN6dVI3Dyxj5gfgdRZKXFFXaKMglCcm6N0saaZC9g80VlNhgk3C5hKxC/opMQ50+bU7qhlsqOPs4n6HCZDa73bYrQvnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767156995; c=relaxed/simple;
	bh=XWp7COkoR50DXLNvgSau8lqHHHIoHPVakl6H9Mli0uU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LYYXwtHKVpMpDMMgBeH5s+GimwH3yfg8e5R0ADDlnJ8HucKYwbZTAB2zwxwqp6wmtTlD2NwjQ9c9a6OxGCTXp0ZHcggcqXDbaaf07uOXde6qo+S2rRXA2gvT3QfEaYBiy7BxLzVwrJVlrvK08vtAYXh5O03iACJLXLg3NUwTD6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kLe6889n; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Fmmsngzl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kLe6889n";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Fmmsngzl"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BV2KrvR2670845
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=hik6Yv4/FlA
	PL1T4IYbHNIfPpAtv/lW1BzmwFMKCUek=; b=kLe6889nRDFpBx0NiBBSouL43yL
	U/CkLbQ+F8EaoECTBlWcedwmQxazL7CJ6hQAWjWRxgoyiVsGnQp09s/DCGWRYkJm
	N+2WWV9uUa/ZIxtBVpkOhgsIktd6qI+rmzTbCSaeXNez+LnrQfO6KUxVeuwHM9nD
	sveFkbHoQXyaBptMqvCb14GMdPyu33AxMTBUuH3mFKYzNxV+vUcLUVO8VHCqnag5
	6z/hm+Ev/vPo6NcK9ndUrgLM04n86kPljKTjz1/VUQFTBSEsY+PUrCq6T8VX3PE1
	N+7EbF8HCMAG2jtXzzMEurWo6cEMSV8AKgHDHClD23qdcqx0lvWZzHqI5Uw==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc4fcu5y2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 04:56:32 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-34c64cd48a8so23152586a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 20:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767156990; x=1767761790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hik6Yv4/FlAPL1T4IYbHNIfPpAtv/lW1BzmwFMKCUek=;
        b=FmmsngzlDv4oJcXkdRv7itLj8SrL+qIhxpc16dxOjGCRgEG6BVaiX6Ucu+8HfaQm/t
         mcv0/RxIXq6SrPeX1kiL+vo+xEe6naNf14m1x1MiUhEjZZureEvwN8+pp7vEelfyEVQN
         a+LqLvOoQfCoO3ryTNRto2v0n6zck6H4WmTiSIFetZU2D7EwDq6KgAJlzJug6U1cuy6u
         9bv6qEPgTXTewmOWs587rhbsAp0xnVkO/CRhCB8D7lw6Q4SZr/MFeZFXHBZnW5ROR3jk
         nn2fLRrFCScVo6OuTw/3L9BLdRgZtZYPY5EeZ2XrkueMj1zFzwl4S83Ypu42orsZFB9S
         LtXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767156990; x=1767761790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hik6Yv4/FlAPL1T4IYbHNIfPpAtv/lW1BzmwFMKCUek=;
        b=ZzS+hJiSbz9TDTyISsrO8NJQDrkMbk+PLQXuIwr8eNYNMlnBSnn1KOAF5J5bYS/k1m
         3YZI42luaRx3BQ5ClEdoMcppNpeH2rVBwNZn14XAgwKC7bZPqnloIrq0487aJA4sHUeP
         DS0vCwUGae0HsBFStSW52fc2SHke3rqdCMCK3Xg2fGmx3HC+tQL3A/Nxl7TlX0oSKiec
         7XzzXQMmezN4FQW5HyUCtu20rc1x6v/eJSX0RvauZ/mCTAghQZ476pEsK+agJuw4x5rK
         dINi1Cmp8oxZza7IsGHnFbizLufGr5unzth1Qz+TpbZJzc4M92Pu1oNmqardbUVBS6Mp
         uTnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxuZLuWoAOGbm+15d1HYK/Op3dsLpWLAv1iT+MmaCFtf6YETRwwbFh3k9k5x7pe20G3WESiWbIFpJj@vger.kernel.org
X-Gm-Message-State: AOJu0YyPqhFptqPS8bXtvpkc0qNtgGIZEQoSxe3PYLzs3oWzbqN4Tv9P
	v5j+ccNWTaHPgLIkXtDNrD2t0vjOUzZr8Yqnp9LeZ1VDAtt5iazT01JYRMGfl3SXNocXO1LTe1O
	BoBSmM7KtUN72/EYylgk6xyjyoxbfTpRDGPxlhvGi6IMkLLoc2KAIPLAZ3CMxX8X9
X-Gm-Gg: AY/fxX7Bz66AmiY0thXgyVJXwIfRSUaxanKfH/5t1xZXTZreK76xvRS5Fo8CnIi/ViJ
	hqa8BwxrqE9F5eUjsCU8ILDRfCCLCp9WixUhfR0Bvtti4o4nrD8yhHpkKpOWsusCVq7AUnbx4jg
	OQjIEkzPSiYcHGci176dylaSZD6KOH3vzJ/NQpjozCBW8m/bXhNBRWN4LNbuM1z3XRytpO/x6mW
	Egau2gS9Q5pCWK9SSGMxW/pyVo8dPC905Y3j5WA/Q+SElrm+GkbIvOpwj70ikKTrZ9ZkTGD6IQ6
	5efqG09DJMSRUvi+5lgYrgjS5YtOcs0dE8hM6akyD6OPHGecwi3iJC+O6cL5U61tOnW8zpRxi+S
	RSFLnZoRdxR7BgI2XEyb3c48KatlkGSrQXeFgPCRD
X-Received: by 2002:a17:90b:4d90:b0:34a:e9b:26b1 with SMTP id 98e67ed59e1d1-34e921d0a61mr30320780a91.26.1767156990343;
        Tue, 30 Dec 2025 20:56:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAmbtw/5/ayDFahPPH4jioa1oTKC6l4u/GuyMepxqzmSJeoizBhSiIQJ9Q9qSSuJuq9LX3zA==
X-Received: by 2002:a17:90b:4d90:b0:34a:e9b:26b1 with SMTP id 98e67ed59e1d1-34e921d0a61mr30320764a91.26.1767156989895;
        Tue, 30 Dec 2025 20:56:29 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70d4f7d3sm34547697a91.4.2025.12.30.20.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 20:56:29 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com,
        anjana.hari@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 3/4] scsi: ufs: core Enforce minimum pm level for sysfs configuration
Date: Wed, 31 Dec 2025 10:25:52 +0530
Message-Id: <20251231045553.622611-4-ram.dwivedi@oss.qualcomm.com>
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
X-Proofpoint-GUID: 3odG-ppKX-gijcBz5jp5FvB9QpHD3vxU
X-Proofpoint-ORIG-GUID: 3odG-ppKX-gijcBz5jp5FvB9QpHD3vxU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDAzOSBTYWx0ZWRfX4c4Kzc2Y+tlk
 llKyVHJiTt78Uq67F6uM8mANxgq5FXNIQwn5dZ/9suOhFBp7bFinKREfG60br7IWfFSLnQct1Uh
 KGEIeBL2CG8rR/J7TbBSAHdXq0kVjf9IV+FrQHM8L2ng5xZWn9PlmvvFikQBRATMO0Ug81GP9MQ
 Hy7DIOjsMFWE8OQ4B+o9BaGlEXU5fk+OZMZmWx+g/cVGz2quBp2EkYHWtopqMp9Woahs7hDUaZT
 7Dn9Z4iO7E9pv7wxeIuypPfdO7/iu+Xoo9/55JAPdGLYI1lvtJfCxy33oMq+FYg5+kdNmKOz/Ir
 WFQ3ajZy+Q90QEjwV9b09K+Y40R1hy1VjEhXcfiY4bDAb8COpu588D6XZAmDUgZqbUk98FjlU3a
 ipvtxg8BSFaQbXJr0mtCpB4RiRGLSdJf3vmtUYnYxtCKMBH+cIi4nk4Bk+WFGFzkFsAmVKmxabn
 RBHHTRAZKFvllgENmKw==
X-Authority-Analysis: v=2.4 cv=foHRpV4f c=1 sm=1 tr=0 ts=6954ad00 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=_fLkURk_aflrY1IPiHIA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512310039

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
 include/ufs/ufshcd.h         | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

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
index 19154228780b..ac8697a7355b 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -972,6 +972,7 @@ struct ufs_hba {
 	enum ufs_pm_level rpm_lvl;
 	/* Desired UFS power management level during system PM */
 	enum ufs_pm_level spm_lvl;
+	enum ufs_pm_level pm_lvl_min;
 	int pm_op_in_progress;
 
 	/* Auto-Hibernate Idle Timer register value */
-- 
2.34.1

