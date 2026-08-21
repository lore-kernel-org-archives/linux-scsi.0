Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F844C9567
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787324789; cv=none; b=g0LBpBGThvAgOXDxH8xv+mUURQVJspP/O0M/QtRYFBsqhQ3D+SwFK8JEYlucG26Kd6hxWRyWgfyx7dJxHk184ycI02B27twgwS220Aq+4i+KFpM0NDDok8H+S9OnJmndqAZlB8z+ZHXPG/x5V8jh4IG9D/JXpb+8GGmtCffK7/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787324789; c=relaxed/simple;
	bh=sD00N96MX+cXHCKZfKm2MT7C5Z/K0H47C57CyGtLjlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+/zF9KamWQLq+5trgFoSQ4bczONnn+6O6AE31B+zncAZDqniXG8Sy0BYAmAfKeW/tU077jQNcRrCEE/0TSJr1gMCwYtVVLQUES17yFCD5e61PX8YLsOQGXQxZ1EYFHRKUsXCkZkRzvhl7ANVBFowIWyXZxhHTlpQ2y10CIIwSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CIrC1CMc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e6WdVkU/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CIrC1CMc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e6WdVkU/"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LCoXhQ1249460
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:06:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=qlvi7ccrXBz
	fPu4z9BFos2jADP8tokNi9C60HKQzio4=; b=CIrC1CMc3jeaHUd9t/G3DfGylmr
	tahsY9iebdfKUBsDE+3VJy+xcZUg1MCnh6mLgWyI/JW0YuYTFvDVEveIRpzvzvjF
	2UxDoTCVF7iUOGmBC1QioqeJXe7C1/M1tZP7Tplknq0WvgPfmRRGIicIr/4XzEG7
	wDDDr7cs0Ux8SxbmTeKbOeZjRfX3I0Rj6AO/KmHq0giic0JK+HWm+QxM6D6eZWCt
	gPG2z3UcwA7iBxzHjPKqyx6NdSxLEwdW0iPksC36svZkWqdqlZQ0c9waZRfslHOM
	B/eyjssyTgE38GTRzfpm6/PQI3756alBquWGjV+RyoVNX6cKT+sOkFx794Q==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g6ebutk2g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:06:26 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52d28f8737eso19736231cf.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 08:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787324786; x=1787929586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qlvi7ccrXBzfPu4z9BFos2jADP8tokNi9C60HKQzio4=;
        b=e6WdVkU/vwxKc2ySQHfMihFkZFpTZCwpR13tGw/GlKNIH/elXQBemNvbO+BjwM0Ped
         Nqx+ov4/WlL5zCm2QK+F9PXofW6d11wFOMIsUmD1uV6hqdEqTgwW77vrrvffOX3HMCwM
         fDKrtS4asXMFkZLw7zW7pwyOqEyqWsb10IpXNsumSPEVXbYIlWYr4Aklr96+EKQudKVZ
         LMpOE7K3IuQegsWfsG2pkgDuWO896TjFqcXq8m2ePXVueRMsNQK3zGSRzICkMoIVpMdB
         q3sQdOF4gU+V+4qsvZ8lPVXl1ynD5+ig1qWN2MZ3z1MXrKuodn5CuipCXaLzS3vJe3F9
         8PbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787324786; x=1787929586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qlvi7ccrXBzfPu4z9BFos2jADP8tokNi9C60HKQzio4=;
        b=Lc21b3D9YC7QdHkGlGnK1QoaHUPungoT0R/nri20rnaqSvOB5KiTRNyzyshUAYxT+f
         LT/M8u1tVjluBmZMbngwb7DRJ3hP5TFqGemvx5zs60Br46DllKWxWK+CfautYRLF7Zyd
         NfLTfIffHGfA4GAqDvCgz+AkF+HtO0pD1Q2xHLYks93NJQoQyWjrB7gUflc/B9S/cMfO
         nPSumkxHwQNvMIkwdJ9oHE+SUTm31yVMeqft1NLUD1RWjuNncsEmYtlbYXuKvYoa7Ir1
         tvPZMrwW9WCK/lwG2QEjRAwrS1OHcfbMPw9R2AuSdtJCV/wPNE/OeWBIIk0PwwDIRQY3
         GoPA==
X-Gm-Message-State: AOJu0Yy2HG49xGdE/FBYjqVmHP9KXnYpBZrtbGXqO12MovioQxkDkIPk
	tlFrblNEWGOTZDjF+ezRdSNx3O0PfD22kvkm9wjHlE/wlpVJPenUJpObJ9e8BQ5UbcslSccv/ZW
	m8u3WP3TB2rR4vzntYg1xXOJfw5cTAykQU6GT+b78bVuO2GbW9SQ3BkCglk81sm3Q
X-Gm-Gg: AR+sD12TJEbMzSyZexkRGmxAUSsEVvu3fe0rxyU8/bKMSZT23iWOEWH91cGWmUK2Zxo
	trCnq0IejueB/Jqr0y2I6EA0LPSoD1qB2JX3j04vNO63g8QJqLx7TGu+Y/N7anPzsshznMD+uLU
	gVAH876vAvuwCVRcb2fWl3WspGg/6hFDPAnQkD+pXX9xqJDM3Z0VfN2YQ4QgnPrtDLUTLS3CFuF
	Fdn56/tdx4zz2FJJ0l2MB4rGL5zUNobpgWkd1GGSS0jPolqXPwDc/iJcZS8BWKQM8UhR3/YyCeU
	k9Vcu2EHYFTzzgELoMkvIhlC/iRxNQu0CTDGX7pTJ0XVIXkaGTl/DP8zuGbMYN9OQUAzAdxe61j
	CntRyM0ihZ0kmDVHgj+cVmjLiFK/2OU9coiSYYRfePEVXldGImd8=
X-Received: by 2002:ac8:5a0a:0:b0:52d:8679:ba91 with SMTP id d75a77b69052e-52df5665d69mr63016021cf.8.1787324785605;
        Fri, 21 Aug 2026 08:06:25 -0700 (PDT)
X-Received: by 2002:ac8:5a0a:0:b0:52d:8679:ba91 with SMTP id d75a77b69052e-52df5665d69mr63015081cf.8.1787324785078;
        Fri, 21 Aug 2026 08:06:25 -0700 (PDT)
Received: from trex (137.red-79-144-199.dynamicip.rima-tde.net. [79.144.199.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b14b8050sm17960936f8f.19.2026.08.21.08.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 08:06:22 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        beanhuo@iokpp.de, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: [PATCH v3 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Date: Fri, 21 Aug 2026 17:06:08 +0200
Message-ID: <20260821150612.3944782-3-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260821150612.3944782-1-jorge.ramirez@oss.qualcomm.com>
References: <20260821150612.3944782-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: KY0fXj8UFUKcxbPo9n3MPNlN7ODLCU8n
X-Proofpoint-ORIG-GUID: KY0fXj8UFUKcxbPo9n3MPNlN7ODLCU8n
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfXylZ2zdjrX6vl
 u8LjDC1JA2E83vB1MOoR0JN2eKYWUD9eVH0NUWvqMYIZESWgCaSj3l63fLslF0GMAvhvioCQT6U
 nah7o0YvxU0hcyZQyEno1FGj9rTUYQM=
X-Authority-Analysis: v=2.4 cv=QJlYgALL c=1 sm=1 tr=0 ts=6a886972 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=qBhfTSQT0jQfJ5OHMlDVQg==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=OSdCpuDsIsRB4DqEP3sA:9 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfXxY1BrMCaJzLM
 xUmLEXUhzIJ83OvumCCJTaXpCoupFvf9hq/B1O64hW8a7jdU1lwKuB8xFlpIGCC0wSy0rJSkypN
 C1Q+6dhMycqR/2E79062GoJW87hZzvB+2b+BYNMOLHaG7sKlalbdPqIimn8eYaoCHLVo9ON6/2g
 a47Aumw7k3QNx/AM6srR8pxUR3Dt89Pw09S1KQSU1Li90/dDC2VwlpEIzkYFc7fHwO1CGgqwUp1
 jvsKGFwKl0jUG5iRA0ohFw1Hcl0zznedqDwGEIyj5PmQDb/f327l24vIk1gRmUWwc6eANV18VaZ
 wAMfcnn/1eTHHuciluE4H4N78YeDHFm6K+ZhVFUpcbYjOMzu/A1MpNseA6xVCTpFvbHl1+u4KQB
 7iNy1CD0MLCm6G2JbeyLWosS3yB5gL3exC9ZWeRepqsHRILlQzlcI+zX8uCkcqFHQEcUMpSw63W
 iU0ON1xhze6Tv1HTCmw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210117

The RPMB authentication key is derived from the dev_id handed to the
RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
is the eMMC CID, a fixed 16-byte value, and it derives the key on that
assumption.

The UFS RPMB id built here is "<device_id>-R<region>", which is variable
length and longer than 16 bytes. Passing it verbatim would tie the
derived key to a length OP-TEE does not expect and diverge from the
fixed-CID eMMC ABI, requiring OP-TEE to be taught about variable-length
UFS ids.

Hash the UFS id into a fixed 16-byte dev_id with blake2b instead. This
keeps the derived key stable and unique per region while matching the
eMMC CID layout OP-TEE relies on, so the key-derivation ABI stays
identical and no OP-TEE change is needed. blake2b is used because it is
already available in bootloaders such as U-Boot that must derive the
same dev_id, avoiding the need to add a blake2s implementation there.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
---
 drivers/ufs/Kconfig         | 1 +
 drivers/ufs/core/ufs-rpmb.c | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/Kconfig b/drivers/ufs/Kconfig
index f662e7ce71f1..b62c00e7ff06 100644
--- a/drivers/ufs/Kconfig
+++ b/drivers/ufs/Kconfig
@@ -7,6 +7,7 @@ menuconfig SCSI_UFSHCD
 	tristate "Universal Flash Storage Controller"
 	depends on SCSI && SCSI_DMA
 	depends on RPMB || !RPMB
+	select CRYPTO_LIB_BLAKE2B if RPMB
 	select PM_DEVFREQ
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select NLS
diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index d0c7ea7a36f4..a1e169ad3096 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -10,6 +10,7 @@
  *	Can Guo <can.guo@oss.qualcomm.com>
  */
 
+#include <crypto/blake2b.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -21,6 +22,7 @@
 #include <linux/unaligned.h>
 #include "ufshcd-priv.h"
 
+#define UFS_RPMB_ID_LEN			16	/* Match eMMC CID Length */
 #define UFS_RPMB_SEC_PROTOCOL		0xEC	/* JEDEC UFS application */
 #define UFS_RPMB_SEC_PROTOCOL_ID	0x01	/* JEDEC UFS RPMB protocol ID, CDB byte3 */
 
@@ -153,6 +155,7 @@ static void ufs_rpmb_device_release(struct device *dev)
 int ufs_rpmb_probe(struct ufs_hba *hba)
 {
 	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
+	u8 dev_id[UFS_RPMB_ID_LEN];
 	struct rpmb_dev *rdev;
 	char *cid = NULL;
 	int region;
@@ -213,8 +216,10 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 			goto err_out;
 		}
 
-		descr.dev_id = cid;
-		descr.dev_id_len = strlen(cid);
+		blake2b(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LEN);
+
+		descr.dev_id = dev_id;
+		descr.dev_id_len = UFS_RPMB_ID_LEN;
 		descr.capacity = cap;
 
 		/* Register RPMB device */
-- 
2.54.0

