Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CBD4B1470
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788191296; cv=none; b=EAaT2+2TiHE18fF7P3z99jVPUOjKf408mZ16tdN7witUe2m0WF8Aic7KjVqN1X0wf864K7GYaivuz0C+rJzUJEvWFDLuN2XVgM9r1Q8uzlkbnDRg+w0LRD5FVkgD71WpNJeZ7Dpe51SszhGO5JddRWm2Oex4Tn82v/O6E525pCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788191296; c=relaxed/simple;
	bh=N4AdlAsQKxMJdowNshEikVOytfPVWy9gkAWSYoaqOCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmcYlDXJ1NEBpBjXqAcKl3R71ASFaTYA+QX53EECCtdBnb6JCYdY/NHfmQw3O6f+qZR1EQXPcfvtaWe0Wf1j3TerM7X4hgemw4MODxahqSyeMEwjG+k8/76JZOLAlHE4H1G9lGsf/ikDWywoPcKUfjYZkk0zQ2Tk2pV6E/JOLzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=W4SojzgP; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CvpJJPTy; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="W4SojzgP";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CvpJJPTy"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67VETSSr3969243
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 15:48:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=uCsZ3FqknJ4
	Cg45n8QFzBYP04ODkNeuhexPi+TmKkwI=; b=W4SojzgPN/KxEI1QZcFHTQkkI4o
	kLoj5HjsQJaaHcF3UIgrrD9Q4ffPLiMpDQhaPUysXeo4WG3lYzRrK8duXosf6bVI
	3J/dyf7+u3lQk9DsBsRMW/NsFCDEkH+LPAPzV9pxswBefkXKMO6s4Z/3mEAHQe22
	af/yySr829HOKhK8LxTk9o+MEyVJQs0TFpCpLqkeGC6OQ6GJcetfxXlWEo5/PA6J
	ew48ic9E2ydthS3my4Az4gyQQ/RzQA+dyFzVb1GnZTQb+661YeYrg7l4IYoChlxq
	J/uhTrqetGfAS8xukZeIR/SJcRdRQ7DU8f5HglS/Lon6t0X4+HQM1B/mNIg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gd6h91pcx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 15:48:14 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-933023a5980so751519185a.3
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 08:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788191293; x=1788796093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uCsZ3FqknJ4Cg45n8QFzBYP04ODkNeuhexPi+TmKkwI=;
        b=CvpJJPTywmHJSlnttU0KPkB/g+BUWZe1wrMUDx1iwkDyXQEwv898BQSj6OCKpBIMGl
         BI4kMY4soOPSMCQENbv5kTZvl7HHlIlWS4vbuUwkZwMLzawOUBfNZbyFuytiia3/gUnY
         jTC1wPO/7pXIS3cLvQy2QoNkGT3zfcAZ0bQe8ytZQPopXhE/F958xtUv5La2M9V7fQCz
         P4bSpqlTb806zul4GGYNRSX/YzNXAyy0vIogu0nqQvfYMaONkyd/PrM+PDeIth9+Ad0n
         Ja5Gzvm2ZAC87Jpn99iqreNKsh8wUkqvRHsSc+m8b9RnxsYgQQn8j3idGBdDC6l2F0Wq
         GJhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788191293; x=1788796093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uCsZ3FqknJ4Cg45n8QFzBYP04ODkNeuhexPi+TmKkwI=;
        b=s9iDUviQb4/rFXhYaNM4CgGrBVrB8aszH2dof9azNtabChg8acJYuPeILM+e2p4U2Y
         98j55/Ajt/OO4c9M1jUbQc3LCesLjMCBCuqJtuIC+hDxW8EpXo2brI50WtCHHRO9ZU0u
         Ph/4WITJhZP8Kxfwq4sQACnK2etz0eQxA5IhneqlBOpD1UkGHNecxcPTONw0FePftq6z
         0xvH5IOIPe3/SMCZYrYdfonIz6JxGz8LnBZysvrweVIS2ydXx7vnas0kLxkciWJ9cs82
         guW2aWzFbv/fuzWnZ826pm2lCqR6xhWYZMn3R2oVWtN/ks4MsRiegok7aSCJ7VjSSGmb
         CZSA==
X-Gm-Message-State: AFuF++mcNfM934qPxLBq9ZHnr04L7tdX2PFRfu3guQQ6JKe6rY5fz1iV
	JCzD4mm7j5g2sfh3TKmOdPUzGVf6bWm+73601d4vlGEo3dpux04Kookz7Z3laGfk31euKyCwdga
	3+ooFZGmZZRqj2jFavAzXTBUTy5m6cqsqFGZCchwksdGAjrqgOgLdwmG7AYG91BMR
X-Gm-Gg: AR+sD10v5Bi4cdQ/44rlO5PVB5kPDplypx1Zj9E5fEjx0Wth4Bt1mUTLoEg9PHliHEa
	eOXuFxI3VeuL4PNThE2530fidU999PgMbSvOUaVngzMygGuiv6plouDTL91pOqevkvxEg/+O3B6
	9JxX9Zpph+LDwoBsETjofPT/bso0K9ChEtp2Ff6+SvnaZwnT1SF5/XdXCgjy/8x8yhiOw7ksA49
	mbExQ3H69iEcX0//zPb+PM9VPR1KzHzm9WCQFg4stf5Ri3w0DDvVcawtG2R09TKaov1fcbep90g
	x1dV9fhCfaT70nC18OSJJBH87nAwcyWXkGpKsfMUgckAr1Er3g1Esi+BMyXj4H4kgs/LPxctfH9
	Pl4E1iO1sdWTNlCiy9Dl+ud66S/9bYjNKKRhfUJ8GEvyHZcM=
X-Received: by 2002:a05:620a:29cc:b0:930:f1db:b9e7 with SMTP id af79cd13be357-93913966079mr2783349585a.38.1788191293304;
        Mon, 31 Aug 2026 08:48:13 -0700 (PDT)
X-Received: by 2002:a05:620a:29cc:b0:930:f1db:b9e7 with SMTP id af79cd13be357-93913966079mr2783341085a.38.1788191292756;
        Mon, 31 Aug 2026 08:48:12 -0700 (PDT)
Received: from trex (250.red-81-38-139.dynamicip.rima-tde.net. [81.38.139.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce0b456sm1558315e9.2.2026.08.31.08.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 08:48:11 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, stanleyjhu@google.com, beanhuo@micron.com,
        beanhuo@iokpp.de, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, can.guo@oss.qualcomm.com,
        sumit.garg@oss.qualcomm.com, jenswi@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org
Subject: [PATCH v5 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Date: Mon, 31 Aug 2026 17:48:01 +0200
Message-ID: <20260831154804.719528-3-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831154804.719528-1-jorge.ramirez@oss.qualcomm.com>
References: <20260831154804.719528-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=W6UIkxWk c=1 sm=1 tr=0 ts=6a95a23e cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=N2KLPU99T7rsMuN2xAoQUA==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=PY6Zn8H8AAAA:8 a=1XWaLZrsAAAA:8 a=ArVhE-LcdHC59WzGYIMA:9
 a=NFOGd7dJGGMPyQGDc5-O:22 a=ySS05r0LPNlNiX1MMvNp:22
X-Proofpoint-ORIG-GUID: yQjclddnJNggWL0tn09j_nXB0yKxHtbI
X-Proofpoint-GUID: yQjclddnJNggWL0tn09j_nXB0yKxHtbI
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDEzNSBTYWx0ZWRfX8J0Gde2Kbu4s
 GEpGYUx1V6l4jJIcZcUKtC7ogoJ35fyt2czC826Jx3RUVaaZqytHu4x2bKuXyT4xEHHoXs2y499
 +coHsBqAeQvDvr/7TKnOu06FOPf16IQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDEzNSBTYWx0ZWRfX/dx+F+NbLhcg
 7qK2bX1fRqN8QtsGyKLAsQottHzIyrc9MzNbyRieCsvqyPUcIHddla9F9jnEIDh1fFgqwwxHBGC
 gqhGxBbQmbQNjlF8ryqYExWf6rOiUimkml2L4K7xy17F8XjJC4jipHgReZvAj0ZLM8fwxidXwhf
 U242RtGVXb/85w2f+THpn0sSn9oEuIpqiCrgIJTa+mKLZ5LZvr1A3Gl5juGblhOBAazgDyAdW5V
 IygkVFCX2yBN/YIdjGo9mJCmYpuS85DGSMRqT6RMFSHZA8s1YQr7yMvI+mo9skRQO/aXJiJ5+8d
 IEycRCWrYOgUgLo5Cuy9+uJTxbizYkSG2PQgShzWiFLArskS8PcDc+uklg410hnR/tL5l+WT+ml
 8H4pk5QSTgbkv8eSFtNTvKqd6fpQol9Guh9FMujeaPhC0QDP70ghLXCNQXrBT8+GicIvkDgIlCR
 ffccT2gXieE1MdEq5Ig==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_05,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608310135

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
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
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

