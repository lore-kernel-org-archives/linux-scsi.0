Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7520C35B136
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787814240; cv=none; b=SkYqCgC4e8KT4YPJHeF6TJVD9YQXNk1RG59ugfIbatmTkHgywcJka5eBpiSgPCwBJXYoWSbpcEJgsX+QUjqUb7I3CdOktpphiWwZsh+GYO87GnkRFxN3m5zIOr0pDioR1Nuz8/aycn4/xKuEWLpBHt5jWNqX0WZb4EYfJJzMaXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787814240; c=relaxed/simple;
	bh=y1ZnMdD2QuOEZND6UGhj4zLO8yEjmatUPzsNEo1nN6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPhtDYcSdPfcvCZnuastoHv4SJWggnMR+Z6W/xNQzO5LJgLlWHa/NXoo9GljEkbeFOk6GAEEYMrCRNER+MH4n4TvVIsPwR0UmZbraa4eDl1nAXE6rDBO2sKxTEXXL0HpdNfZlKbOn2KSqdJOMPyqCoHdCRnooPtQyOLNxhqAjkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jHum/W2u; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FKBK08kP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jHum/W2u";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FKBK08kP"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67R6R8Rk2619612
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:03:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=3lcTDATJyX4
	U7tMBzNdZ6G2/MK8hjPYhCbHwcSgogLM=; b=jHum/W2umYi/wMGEu34O73xjt18
	gyqM6qs34sPZILogv6NPb/hjQ9wPpDguvUChZVJhg0UzTL12LMoEXB9eawpwBC0B
	meHuGHPfwj2YZsScsgwqNBx9EOse+EAZ8F8QBSiKYOZ30vejJwieSH7u7+hIuSkm
	2dKSkRQ1dPevTAR4oVQxFuWeCda/p7J6WDQkmjVZNlsxeZk/DxhfEmbd7y6mNdjH
	pp1j2VuZlIRKQ6OW8Y9vVgmHDEwbIjZ6Jvria/t3HMspBzJL0wXAlLq4OzxPJggI
	QfChEYWrmkxtCpVijgzE7FYaI8bTnGwTy4rMYfIx0WUa3UiMFIJryxlkHxQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ga03u3q6k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:03:57 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52827090cc5so7733491cf.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 00:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787814237; x=1788419037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3lcTDATJyX4U7tMBzNdZ6G2/MK8hjPYhCbHwcSgogLM=;
        b=FKBK08kPFUjk/N36Lb8szdn36ayuPxQwBYnDIOVVLqa0xdDcM3StqWnvvJ71a/VLou
         mLxXj3COWy70J34HKTqlDYct6jr9ier3fALBA4qVsdAtN6abg8pcYhnW6FYqZ1H7iCbr
         WF7FOqorEft7KK2gn26gL8JNt0IH0mgd68KCfUOkPNQu6SVvp+WyyJuJwzYYJ+7FyjVc
         Jz0MBZLM123+JrLUjUwpxXS46bqXrCKEkCs0630Wwp2YMp4UFm3lGsPu6FsywXsB03y/
         o46ihlpQk8XKqsB04BO5N8Ypuotsj8+/lFEGsA88jlFPxk0X63xKor5fOJixkfbx12fw
         LFRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787814237; x=1788419037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3lcTDATJyX4U7tMBzNdZ6G2/MK8hjPYhCbHwcSgogLM=;
        b=UPAvqIzleQzSOvNLANfHTPtESTwQesNLmP3RBZtpD+niHL+yD3FeGylttvM9yI+Qpt
         VaTV+NjCHP2qLE4MGPlE50dXyq5IlmwuJxhFdmaVAlH3Jp3NIQs+sCl/LvGRM7LBEF+1
         uC/XzipFqoREpvlD+yjVhpGZ3/BCJsGt9wxdoT3d6+BUMNSaP6YCkV1ENzJTMxYsP/34
         N1Aenm6n81eUbO+XSF7UFbH2VBDUP22yig9W7Qj1/n49YuK6QeYnbR5/s3pxwXHZ/jeV
         UCpafD2WvcWErKJnTfQAeN96Qr3WrentAWTQbejY5Gkx/w6x4ZrHKg90IbDJpnghmZGK
         RRYA==
X-Gm-Message-State: AFuF++k5qYxhyB7q4GCPOCh2Qtz41kB/I5mdqGM/GP6uHymDfxD+wXTt
	DQAXDWNRA+3iwwC4UY9UH+ZgNfM2F+/+UQ8OdazJZVCAT9LSp3wIhruxtTZUuPYNtabN0ZBPN20
	vT/EOwMK9gcsvC2hXEZBh6/mriWHyiB1OyrX7AGzHuLqm5mA8SnPqMud/pG+rEiS2
X-Gm-Gg: AR+sD12yyTGD+XJJWUBbJLyQCH4fajG+aXiSAjY71rmWs3jcSkQPcSgIKGRjv4Kz5xF
	rCmA3/DCNc8VN5/EFarDhcGJTHGGtEGLB3rPnk+BtkkLeDanBfQUhvB06Ovah/tnOmL8EA46bKd
	lRso98pCidRcfI9UbPw6GB0/E8fQohOC9YXGdoaIglYXwdbjRUU5dZog9IkdO1mX4N3ajFX8Cvq
	qscuWe0mplbMoZkFwCkm/uu9DIOWdRWGawXYeEnkhA2vk0fu01pXl2dDaILW7tLd5+P2jyR4j2F
	wbMbak6yuziphI463YLLrIlk+nIPhz08sUvPUMmV4Sd0cCjzLEHUIRhAvaB2u0FQWWfx5foQQ56
	UeG8amHj2GsdsD+cMWYrN+FWkNAQfDc1MOCAfR8oY3ewLPyH+Dg==
X-Received: by 2002:a05:622a:4d85:b0:528:ce0:e9f8 with SMTP id d75a77b69052e-52fa1a4aaa1mr51871901cf.3.1787814236763;
        Thu, 27 Aug 2026 00:03:56 -0700 (PDT)
X-Received: by 2002:a05:622a:4d85:b0:528:ce0:e9f8 with SMTP id d75a77b69052e-52fa1a4aaa1mr51871481cf.3.1787814236308;
        Thu, 27 Aug 2026 00:03:56 -0700 (PDT)
Received: from trex (137.red-79-144-199.dynamicip.rima-tde.net. [79.144.199.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b0d263dd5sm28306585e9.1.2026.08.27.00.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:03:54 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, beanhuo@iokpp.de,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, can.guo@oss.qualcomm.com,
        sumit.garg@oss.qualcomm.com, jenswi@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org
Subject: [PATCH v4 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Date: Thu, 27 Aug 2026 09:03:36 +0200
Message-ID: <20260827070345.2853821-3-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com>
References: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA1NiBTYWx0ZWRfX/qOgT9p2JwfL
 s12zWtT0r61y/r/Q1PmNvqRdHF102cDN4HuFQU8kz76uuHEZWEknhwkhDJN/QbSBSx2SV5Ck5gt
 vJnCe3cwG5kq43x2dlDqbPB1wEx/awAUeIPpag8RBGXNdgQnG7YaACQBC/wEMJGmY8+IIxcmojk
 FSUnN1FwQ+TqFrpIKJ7Vfj8nSMx7l9rIdxmdMDY+aXojwShpMMuvIPf+5qlRMYA0fs/mJA/3IFx
 V5OPoyLph1gL0FUM/kxI+9+a8Vhj8OvXDQPtvnSGRkpN2yn1yFyMXz7opJ7OBUjyu1FE42YYQ+R
 b4acSjvdpLd/633uVG3h5SgQfr2YkNZl95BwDWmyWJ6RIll+TQ4wHETVkh18C/c3xJiqPEdoPSB
 /BDogUIeEBUvYdnwiolhr1d3q0sdUEP+iRTHC7yU16VZs3iVY0igbV5yVo3m/NN0ZGR8tm0ybUv
 5gkaxXGkiO7uAUChahg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA1NiBTYWx0ZWRfX06FBmEzBk6y3
 oVh0C+y9rhmepv0DOgDUwo26rPUZwbvlrNHgi5JXQYJzeFiSAvl26k6s7Xtn4lxq4WxJymeWzly
 T3cd/fvflQlrxM5Ml9PTbFmspuQ3iFs=
X-Proofpoint-ORIG-GUID: aDbplr4YZylmzphneEjqJus6dbGBpkJL
X-Authority-Analysis: v=2.4 cv=RcqgzVtv c=1 sm=1 tr=0 ts=6a8fe15d cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=qBhfTSQT0jQfJ5OHMlDVQg==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=ArVhE-LcdHC59WzGYIMA:9 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: aDbplr4YZylmzphneEjqJus6dbGBpkJL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_03,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270056

The RPMB authentication key is derived from the dev_id handed to the
RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
is the eMMC CID: a fixed 16-byte value the key derivation depends on.

The UFS RPMB id is "<device_id>-R<region>", which is variable length
and longer than 16 bytes. Handing it to the RPMB subsystem as-is would
tie the derived key to a length OP-TEE does not expect and diverge from
the fixed-CID eMMC ABI, forcing OP-TEE to be taught about
variable-length UFS ids.

A fixed 16-byte dev_id is needed so the derived key stays stable and
unique per region while matching the eMMC CID layout OP-TEE relies on,
keeping the key-derivation ABI identical with no OP-TEE change. The
reduction to a fixed 16 bytes must also be reproducible by the
bootloaders (such as U-Boot) that derive the same dev_id.

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
index 79e6cd2b20a0..cb3ac23fa01a 100644
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
 #define UFS_RPMB_UA_RETRIES		3	/* Retries for the power-on UNIT ATTENTION */
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

