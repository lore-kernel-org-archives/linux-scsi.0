Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27E033890E
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767706840; cv=none; b=L+Z+Lpc/lAf5NwfjPE1RWr0VI+Z8yHXs7RVijvHxbg220gjqAuA8JOhBgueNQOAlf8Ezzx4aGt8lwZwluCrk1R69kVUJ8KaqHUX8HkSkgK3baG2GeH97H7bRqqXWlj3dQ6mLAVPHRUpTw30J0HK3qpV+bwBta7U13OfCOAiahrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767706840; c=relaxed/simple;
	bh=XWp7COkoR50DXLNvgSau8lqHHHIoHPVakl6H9Mli0uU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sk09EB1DJE61giZzM1ymYtf+NmawtBYMu6fQrL0vWEAuiKCmVJtKox5g6eckokM2jfOFru4/TxHQfX0mPrKlUFGXBumYvmBIY4g2u2YFtXjsSE8qE+U1Gbw6ULiYFCC3xJ5740E1WMIOE2sFKkTtHmEEY0vOzx0nsYjRolcpJd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TYFsNJUz; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e2n3R8KH; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TYFsNJUz";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e2n3R8KH"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606BfOD8308003
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 13:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=hik6Yv4/FlA
	PL1T4IYbHNIfPpAtv/lW1BzmwFMKCUek=; b=TYFsNJUzgt7+Gp1KgJ2K60BG/a+
	g+4g5J5qMs7P88EoYzi1uR47oKPKSG78b5TROGjv/MGNYXwuJHq7yd2xY2dLDqSF
	xD6oFoWu0AqjUMmnEKNZLPySyqM1jcIzbPLDAQQT4swWSnYPzoFuXhGzNTBCWyQ3
	hKFP4FgvO0Ds3YyhH+Ipcyqbw3savvHrsDxJaSI2d48hipa8OlNZNo1O9/2QzF6v
	B+oy9lhxiAmngUgFWTeW59RoGeAr7s/DcxJyVx9aQPYSlEp55zndAN64kah7a5jG
	YOvInn+qLKw7wsQCG24jceFolrESqWzQ7Sn1ptv4zHjBIZ5Lo/Gsm+lOTCA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bh1r6gahj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 13:40:35 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a0e9e0fd49so30462705ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 05:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767706834; x=1768311634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hik6Yv4/FlAPL1T4IYbHNIfPpAtv/lW1BzmwFMKCUek=;
        b=e2n3R8KHT4kFQP4UPjFDu6EtY4+vEqpEV/jkwtL+ocU9NgIwdCGZuHjIaAy89AK6uM
         GYyJ58unPkSNnG8CJIwd7HFqIOs05+OthM3bCGp+Or4t3nA57zUFWzu+5OtaLvNTf15y
         lv2daZerYkEBqBxI2UChcvQ5hUXVQrKdnNlkaon1hFTJTPKwEdSM8Z3ad+y2/zAO8Vai
         WLg63t/ZasqH5Eez7J+xsV0t9u5bn6ZJUlLb55Id0yPLY/gnVH0vgTrOSJQJiYn0v73E
         N7jTSxUGwjHvHgu0oWF90dgzwrHW30lzn8sTSBvLKiUWdDDqkyeEdtKEXW0MjCJ3RnxX
         4eDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767706834; x=1768311634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hik6Yv4/FlAPL1T4IYbHNIfPpAtv/lW1BzmwFMKCUek=;
        b=vWB49wE6cEXeW5g9lenWM9iZ+W3B1dqF8GbIV5EkjUeQ0zVTl5BUNrScvmdrzMzOxz
         RPGp0IISSKIpTBoBU4qi54N1wF9PDrOx67cZ4IRFsS9J4Ka4+CgAq0/Z8Ep4q5HVNJpU
         /cGD9vEW6UxNBk/E41Myh9PqhhKegkuNBsXifL6EFqYtXD8QDOfauvS4mfoiF4rJY+6b
         HmNxtoZTYzdJxPcNXX6PLKlty/X+Y7CvTEclZcnoZCllFJXR6N/RxvNYosfwnAkuMDnX
         aIsM9S4f9WoX6lBVbgZnVP4pg6tmmE4M5nDft6g0h+zQVrKvNsxwHWZtMyGEvXkxcgvA
         dLVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrQtEomHdMGTr3jysenm3SESSAmnTULJf2S+adOH7BIbaB1x0bOGYL4GAnWuIwMRjANxVXHtE+kKmN@vger.kernel.org
X-Gm-Message-State: AOJu0Yydgn9IWE2dNybFOpHtnxjrVoy3yAuLKF8QQagWghZ+q8vAvffR
	hQRDCuQtv4NnR1XJ11lmwz2K63Su2xDTlW504QJiSFSxagBbn5y/K3QMNMQWC9qel8pSSWZX5j8
	+L9qO3kI4RrmT1hBsIy0prdIafWCnmD5ufYCSh0CBwOyGqlksc6wMt8YtsPZQU4c1
X-Gm-Gg: AY/fxX5bQGoweeUa/u+qGjkn7NFcokdDxA8WXHBF4sw7wv/GeHl0WK4CsgjHKXSlqdD
	5MsGWW0iq6800smxnDfQnKf131KIIXZ6YVM2hOu0habaHz+wZTnHBWkQs8zVIhichfBAmh9UEm8
	HF1YmX1S857rl7ylt+iI5QC+8XPun8FbBqx0D0GfL1QYrwre04RBRIAS0xFgtDBUSSpmU0q4vxQ
	9O0D0nbooGpeYNzHkpaCl3ecmHQuiEW4YIDofFuzO+aec3Ps8qPa6/wPVWoDYiKqgjlXqSLxPtY
	SDlxX7v/Tilz+HKf3QL7Q4z4jtVllYq93Le0SjGhtVoLmbDTIMxwlJ8TaDJfPJhRNHht7tMVjP2
	Bys+ppGwfEifDYEXyHveNYX0iuxiSp9Ta/Y6A6Wl8
X-Received: by 2002:a17:902:c94c:b0:2a2:b620:12d9 with SMTP id d9443c01a7336-2a3e398e82emr28538565ad.5.1767706834206;
        Tue, 06 Jan 2026 05:40:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHPXXNLeunS2BjceJQzS81yF1SGalnzfMf0xuwsb9X9HO5mpbz/Mj589G/FmMugANxNfE+/9w==
X-Received: by 2002:a17:902:c94c:b0:2a2:b620:12d9 with SMTP id d9443c01a7336-2a3e398e82emr28538275ad.5.1767706833732;
        Tue, 06 Jan 2026 05:40:33 -0800 (PST)
Received: from hu-rdwivedi-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc7856sm24112515ad.68.2026.01.06.05.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 05:40:33 -0800 (PST)
From: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
To: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, ram.dwivedi@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V4 3/4] scsi: ufs: core Enforce minimum pm level for sysfs configuration
Date: Tue,  6 Jan 2026 19:10:07 +0530
Message-Id: <20260106134008.1969090-4-ram.dwivedi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260106134008.1969090-1-ram.dwivedi@oss.qualcomm.com>
References: <20260106134008.1969090-1-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: L37_-GV9UbTPcP45FnpsQxMwgLVx6bRA
X-Proofpoint-ORIG-GUID: L37_-GV9UbTPcP45FnpsQxMwgLVx6bRA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDExOCBTYWx0ZWRfX3+q/os85ZJVf
 +7DQUF+R4qIYuEUWbNR563cEHu3AYsMCGtQ9C5AJTw0JmRbxQGUNzaL9ICUUQX7hiJV+N7VqmhL
 o/ODFY6SeZqQCmaHZTnZDL0FJa4kUQBk0afO5C9KSDebfO5d5f5+kbFC6j8E1yiSqCyn6cRAorq
 AtTyzOKKg5xGv8mexATcdninhyZw3ALsQ2dcmfeD9DRqGXgrw4WVCF5+Q61u4Lq+w0iGHh73nGM
 NkGEWtzCGkbjZ4efakHpBhzqQaR2wDvK7QKvHWxMXbyIhSPthqqhgbMxjBQRvW+uEbFkaJqj8je
 rN6HGUdyDhNvThthKeaY+QgeSnML5SoVkSid91yxRZpKS31aN4Y1huDIkced5MnKVrDrNfAHjbU
 y36+n47bDaFSn+/dGbkj8hvN/wkab+gHqM/zvMx250UakvSJGYg98CeRKTN8XCakVbO4kMyO0vz
 HhvmoDvSL0ZPqIbXZqw==
X-Authority-Analysis: v=2.4 cv=Ctuys34D c=1 sm=1 tr=0 ts=695d10d3 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=_fLkURk_aflrY1IPiHIA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601060118

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

