Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C856F3D410D
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784151819; cv=none; b=LNHFiFE2toWQHKUdFa80vbid1fz0NxtM/1qOuBGjhVMnYafLbcGEoapJfVmD9kDECKE5Xf43jYN1bXi1a0xOW8htyqN5IXSdwhqgf7SNENRnRLDBeBL43yTsNXK7l7ptn7DBPUdN0JnCI1PeVAhK1uKUN3mDMR3vqTXGTpRGi0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784151819; c=relaxed/simple;
	bh=Cm4K6aQ9ZencuOBmb0xy9mNwsQdxcUIENIj4qEuugS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soyyf92Tc949BQG/KvFIE8OEdbCqtmWfG80rPK4cLp4E8jDP1MNPbCSXHmRmxZW/VpjEYRsfYRAQIIrOOsAzroCJ/iXGTdnEJRlgpiXPmZXtY41whMVNQhhZ18ZhlESbOieVsi7beSQ8nvSMXiPSPm2jtCA+whBILejooD1X958=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=olsEgkq4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RALyv+Gq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="olsEgkq4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RALyv+Gq"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66FKPist333368
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 21:43:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=TQbg8chsvAP
	bq/1Q3wQohaUWLuiSfKaiHqBS/qBy66o=; b=olsEgkq4pNu3FHZMKxNUaLF36eV
	bahSBKfCTFdips/fsIGOfl1Qu557YoIxNyRenKQrVpPKwrQ8T0pa64vELI0LF+Dl
	vi40jXuop9tRJ4YLYhtM3l04A8++8ztl1EaoWabeEFpO8+e4SZu8nqvYnYcSX6/N
	8QANEP9FXgCZ+8mSfB5hiQqrv5a3s+6J2BERU+Dsepu9JpF2WhCnRWUhRmEcn+L+
	4Rnjp7urul0BirNIRemIFSQ1+5UMZGTRGOH4oatzXzCGqzzNxh2IkN2uphiXl2z7
	ZQvpsR7AIg7qffylzV2qrv3y7Bt/RmO5ZJNXwKoAm2cCstbgFncztCZoXMg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fed061fj3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 21:43:36 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e623b0e95so718121185a.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 14:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784151816; x=1784756616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TQbg8chsvAPbq/1Q3wQohaUWLuiSfKaiHqBS/qBy66o=;
        b=RALyv+Gq1M/AhS+LbVqDn+pVk/Pdx808aB46eOX/MFA7J+GdoUpr//dVJT6wapiRYj
         Cnvm3QiV7HThEB7CrxUbSBMlsMGAn8QkrwFq1pKC7/p9WQpnJd/jFOtJjo/vnQ9Dc0Z/
         yX8zKJ+u6jB4Q+46Vs+1kpCYIbYvsFVGKFHy9eYNLiswnMVbwLhpHUymXCIUjcKI0FXI
         tYXDxvV29H3UJGvWg6niRsgC2xbwc4PsQjA//eXCrO/AXWthbIEQuwjG8AMLbt31gbMm
         94DAty8WhF4sBaF3pXdboq55kVlqYkk8EorAJp8fpfrajlgkgmy2YkrldEZtRgNj6LN8
         H4oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784151816; x=1784756616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TQbg8chsvAPbq/1Q3wQohaUWLuiSfKaiHqBS/qBy66o=;
        b=Ni5GIVVKw5BzIeAE/3lWMgCbiPtocCO2lrQX1d6QLfs2xVftzowhc+siRMDVMLnI2t
         CvsNObJH7QJbb4hA8bT1MwEMqxQyyzkc/YLusN17H46XerHwjUHIqPqHfYTzOBKZs6RM
         E3CRirbtnD8AufvxETPLDpH5IIeAtY/yyfANXIgUshw+Hmb0w0TDdqcR1J8zURoC2x/l
         I01vgAlpBXLcBxtiYuyyxwcCmtFC+RIOzirwzL91zB/sDjSP6Fdr1rUwR+TSwN1NzxWJ
         ba59/XXfOuxfQajgSHZBuXXjP53c8DderiOs+i6y3MjU85QwdBlSy+3nueMb5wIYAN9D
         k8Qw==
X-Gm-Message-State: AOJu0Yzp9nXfQZ96CkhnA72JvwuRhnJ6HKMYr2xwny7wF41GoB0QJHiX
	IZiADImC9zIO3UDouBNiU4MnnhgYPx+wx5TScDPOt6HsmG1Z+NXHQBju26Bn2o9+A/SU4Hwl+k9
	chKRTqW7H77i5mpbKx6d2+b6+ztsgGKcKR3Tr2c8Ttb0NQGGw8mlMIqZrSwa0bskF
X-Gm-Gg: AfdE7cmyN4GIIqILfaXYG0Y40iPElUE5R0U3wdQoAw1NdmKpfxoMm4xSWAjHML2HxwV
	dcwG5eCQgoxdP5V7643dPcL+xTQS8Mp2hhKEL0CXlu4FtEgXXbWVdPZa1/8hbiMG8ww1Bmu9L8b
	XrZHJrTWcxR1viPyJUwTZqSo6hGMvCdBzF9FCPYzxkeA4cgZWPBMOjr/jR8psN+FLrGRVP+O5w5
	38+19RIkJG0LnLAGcNDwaU9A2jPdIQEl2CsWpxpjiJM5iizEA1laBa74Ly3xb+a8jvISYSImx6y
	QaPCewQocqKoh0v5rHO+vFMga4LO5wq94RnFmpCB1gjnAl2dQw+ugZSgC9oxu8f5jsuLH/My2v8
	mt7UBYFFFD1CapUef9FBbodfDRdl3Tu0HwE1ghGMCqB4PBw/xOTI=
X-Received: by 2002:a05:622a:259a:b0:51b:f40b:2fb5 with SMTP id d75a77b69052e-51e4ede808bmr52744511cf.17.1784151815954;
        Wed, 15 Jul 2026 14:43:35 -0700 (PDT)
X-Received: by 2002:a05:622a:259a:b0:51b:f40b:2fb5 with SMTP id d75a77b69052e-51e4ede808bmr52744181cf.17.1784151815527;
        Wed, 15 Jul 2026 14:43:35 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541eb7372sm14200775e9.13.2026.07.15.14.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:43:34 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: [PATCH 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Date: Wed, 15 Jul 2026 23:39:16 +0200
Message-ID: <20260715214327.1933560-3-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260715214327.1933560-1-jorge.ramirez@oss.qualcomm.com>
References: <20260715214327.1933560-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDIxNyBTYWx0ZWRfX5JrmFsAZbaSW
 uQFBGHfpzB893/I9QI/9jFQGVoiyHdgzTAAK0qbUlXr4tEkfxpgXlIz+wfOChxVXO/X2COl+NSX
 +1ScD2ERqPUk04ZO87ou9Nenb+zrp/o=
X-Proofpoint-GUID: YqhzEPCgg5U84kIWFKQyhKzjJ5VxnsBg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDIxNyBTYWx0ZWRfX/khQVl132iJl
 8aYAGTlva6SitMXbW/pTPwawq5k3I90sheo27FIl+kBic1cUBai1MVS3vkfK39hFD6Drk6zUe6L
 0fyzhqVDNM8/xOKkDZWSp5djkvkOuVPl/udrlJE65nZuvSfq3gLuD5YTbdJfVi4OaM5ggeXKyMR
 JHegamYftyOSVT5aWHP1q3Jvu8PKMvUCZriuJr1GHS2mP6tQkvnq2e5zwdrAKsSge7dLiUqtDCJ
 eiFKYIqqmeCOx8v4M+StTPYp6I/9XMh/pxxuj12s08ECJX0CVBdkWgkPHysjECax7x5vvQGX+KT
 vSZyFFsrRMoiM87Uuuqn/hjvq1gc86Taj3v6IJPzIt951QtI5RoWaoXdn76baITMhMMkktrIrlE
 FlI8fE673pqOyyI9nbe30PpJa5Mq0hNPHRNLMopzbBVTfzHmOmCNpJiGmKP76FUTUkr+ZKCs1pm
 hsMwJzZA8x8Vu+KtMlQ==
X-Authority-Analysis: v=2.4 cv=Xb25Co55 c=1 sm=1 tr=0 ts=6a57ff08 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=h40Y9pVjyjmjd-OtGDwA:9 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: YqhzEPCgg5U84kIWFKQyhKzjJ5VxnsBg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_05,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607150217

The RPMB authentication key is derived from the dev_id handed to the
RPMB subsystem. OP-TEE implements the eMMC RPMB flow, where the dev_id
is the eMMC CID, a fixed 16-byte value, and it derives the key on that
assumption.

The UFS RPMB id built here is "<device_id>-R<region>", which is variable
length and longer than 16 bytes. Passing it verbatim would tie the
derived key to a length OP-TEE does not expect and diverge from the
fixed-CID eMMC ABI, requiring OP-TEE to be taught about variable-length
UFS ids.

Hash the UFS id into a fixed 16-byte dev_id with blake2s instead. This
keeps the derived key stable and unique per region while matching the
eMMC CID layout OP-TEE relies on, so the key-derivation ABI stays
identical and no OP-TEE change is needed.

Select CRYPTO_LIB_BLAKE2S when RPMB is enabled since ufs-rpmb.c now
depends on it.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
---
 drivers/ufs/Kconfig         |  1 +
 drivers/ufs/core/ufs-rpmb.c | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/Kconfig b/drivers/ufs/Kconfig
index f662e7ce71f1..0a050565872d 100644
--- a/drivers/ufs/Kconfig
+++ b/drivers/ufs/Kconfig
@@ -7,6 +7,7 @@ menuconfig SCSI_UFSHCD
 	tristate "Universal Flash Storage Controller"
 	depends on SCSI && SCSI_DMA
 	depends on RPMB || !RPMB
+	select CRYPTO_LIB_BLAKE2S if RPMB
 	select PM_DEVFREQ
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select NLS
diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index adbec80cf381..a7595be0884c 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -10,6 +10,7 @@
  *	Can Guo <can.guo@oss.qualcomm.com>
  */
 
+#include <crypto/blake2s.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -21,6 +22,7 @@
 #include <linux/unaligned.h>
 #include "ufshcd-priv.h"
 
+#define UFS_RPMB_ID_LEN			16	/* Match eMMC CID Length */
 #define UFS_RPMB_SEC_PROTOCOL		0xEC	/* JEDEC UFS application */
 #define UFS_RPMB_SEC_PROTOCOL_ID	0x01	/* JEDEC UFS RPMB protocol ID, CDB byte3 */
 
@@ -156,6 +158,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 {
 	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
 	struct rpmb_dev *rdev;
+	char *dev_id = NULL;
 	char *cid = NULL;
 	int region;
 	u32 cap;
@@ -215,8 +218,17 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 			goto err_out;
 		}
 
-		descr.dev_id = cid;
-		descr.dev_id_len = strlen(cid);
+		dev_id = kzalloc(UFS_RPMB_ID_LEN, GFP_KERNEL);
+		if (!dev_id) {
+			device_unregister(&ufs_rpmb->dev);
+			ret = -ENOMEM;
+			goto err_out;
+		}
+
+		blake2s(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LEN);
+
+		descr.dev_id = dev_id;
+		descr.dev_id_len = UFS_RPMB_ID_LEN;
 		descr.capacity = cap;
 
 		/* Register RPMB device */
@@ -230,6 +242,8 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 
 		kfree(cid);
 		cid = NULL;
+		kfree(dev_id);
+		dev_id = NULL;
 
 		ufs_rpmb->rdev = rdev;
 		ufs_rpmb->region_id = region;
@@ -242,6 +256,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 	return 0;
 err_out:
 	kfree(cid);
+	kfree(dev_id);
 	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
 		list_del(&it->node);
 		device_unregister(&it->dev);
-- 
2.54.0

