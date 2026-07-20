Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D873F3D34AB
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538992; cv=none; b=cMIqb7ZGskrWvOcvTLLmT3F6zPG99LvT8IRwq7+k3VZEyd+gRdwKuEjZK1zStLPEDEVGN1tlOL6EjfP5CY2xueUT8zRUIkja67AeSCY3RpD9uy8jfaJg+P9SQKuRa9L5syDY7CHqwqEm1Qifz2CBhz4MLZME/RryEQZQy4NS5hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538992; c=relaxed/simple;
	bh=KqyBjmOApkNo8A90X03oG4tBRoknxE2WI8Dq3NAGlKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7v9VXdNqrnKUR/iT+pPIm2AIjMY4iPhsacK28FF+Bos6Z4odb/+46l52KS+jVrZFcZhKcGEn5WqHaF+ZOmxYmFsH3vKI/GCxBNMyou4/F4pbymUh6o9R3Z/2zehs3Oth8XCP/HhUgAUuwar7K3osnbY9buF2TU1D34q/qj8zdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=luXrjX1e; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ar7m2b9j; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="luXrjX1e";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ar7m2b9j"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K76Qlm1712942
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:16:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=3SSY0OgGKoS
	Vs9E09SCQPvkvuWD4iQ630uod93je2zE=; b=luXrjX1eqkXssWL12SFHBKhVraS
	gG0MMEzD0/1lZ+9nXquwuA+hD3euyq/3T05VZaV8sD0LsIYMUoNNi0b3EfM5tMCd
	R6dOCPvSnG6aXdPvO4l8jq86ERnPWUvU1Nv+gqjpLun5BRpXBnLgYwtlI0rVPqG7
	kKvvJxJzSEJfcaw1KmxoeRi67GJfI8f+7HGoSEgIN8gvdXYHmznH59WSVSV5fNlu
	QYfZQ4dsIDk5Y/8ZQNakHKpHLwBuqYK5DUTtfinwvetpHcmaA/q6gV+pKqKKFJ+3
	GFOpQ8kP0iH0WBLDMZllnmNR6rIOcimfwU9MiX9lyCl12Ty5psDrMXGSuMA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhf0c0k1n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:16:22 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51e4ba1cfabso116839741cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 02:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784538982; x=1785143782; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3SSY0OgGKoSVs9E09SCQPvkvuWD4iQ630uod93je2zE=;
        b=Ar7m2b9jDYqt2x3aNYnGYk+IGvRWBx6c7wYGV1q1nT5a3KgO+eOSqfOvgfrRTajvTM
         F81FRY2zlmvuubKzs38yGjlp0AslAoFg33Y+bNTycJQdf4L8sN+eqlksdvP8/VSqFBK1
         tHZa8llureQujLfBFtMs1Cr/1Ve2mU+crGGdRuRVSOVKENe/m3RQ8QRZ+G73lof+gsXj
         njtxx+pqqf3qGGA7g8uO8AAl58Bcd/UwZDW2o6Oko5ICVWFRWVk2MNiv1Tp8xtlGxTsz
         XauO0Z4wrHRDt7PcGuaQKIlzMBjI/FUkcZgJGKk0BtkT/kx53HVDNFUtZSA5LeZIbq3i
         nyFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784538982; x=1785143782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3SSY0OgGKoSVs9E09SCQPvkvuWD4iQ630uod93je2zE=;
        b=bWvAPRCe63bcCr+6MfbXOhe8gr+ZSsYGpZ5PdS3n5ppagzS2BGZ8KA1YClTASgp7WP
         13pCUQuXUeg0N62iQ8T6VhclEeSXm4cOYAjaH65m5DsTgem0tg73oDwg97NZsBPM56ec
         NW4DhkwuxkFt8N3crXpVef0LP5tggQO7LAy7EaH45YUQ6P+oLWk29xckMFzNRlD9y24X
         fO4ldYaJZrffM+0//qNw7otgGokvt03LMEbSTbbeuzlCN4+/4VJZW1i1W49hB4eAkSm4
         agpbdFpOD3MZwQwYPcGwxBrj7tPOQONU2pFeiefyQgx+19l7MPh6YCglUhxjHbKLqeXx
         Pfqw==
X-Gm-Message-State: AOJu0YxNILm+UGxbsDwRUjkXOOnziL8KLgfnAjA0wsUNhbNHwrKG170X
	S3lRTR3tN1Jylhn/Nk7XyuZ7AZAF+xsFRk2VSZJMiF6cWvQYwOL2CZYxvk+xbYKg/RCXPujk1v7
	WN66iTHXlTgvOLjAaGzGd6IxXyYAo0U8cVM5lYon/f9Z5pCqDYILu2USAb9b2bXjH
X-Gm-Gg: AfdE7cmgbfsEElFAhwJOgwr+olljyZns1pXncN84w7HYkI79PlrZdtc1gYvCP/RXPU6
	c88IbGNyJ85m1+KrTiuO9wmnaYTrZKnsvYRbPSdcS/I8CihTP9S3w3DwcppMidPuaXd5N3elVso
	4N7P4Ujce7Xolb5MrxPII4KgkceDRGRKYY42JuAKYbXey2CHWs4zOGFbTYP/oeN2ZOBM2uOjgG+
	mzy0Ppl4es3w+nj8g4A57+5slAPMbVmGSDv3Qa2p5OzbJJ+TJkIOLwNnHNIJBfNPpUE6JmUYvGu
	F7kSjh7x6KYbI4FouuFUL2kv11EEsnRUSCtxhZHEcN7m6Zjq9dUD6NGJ5w+pl+biKijMeVmVKBx
	51B+vCYkuVhTmzH91umTJtA0Mt71rA/kFXzliD7q7hEsYgE4w4jY=
X-Received: by 2002:ac8:59d4:0:b0:51b:ff45:bc82 with SMTP id d75a77b69052e-5213daa1d49mr120693831cf.54.1784538982106;
        Mon, 20 Jul 2026 02:16:22 -0700 (PDT)
X-Received: by 2002:ac8:59d4:0:b0:51b:ff45:bc82 with SMTP id d75a77b69052e-5213daa1d49mr120693621cf.54.1784538981551;
        Mon, 20 Jul 2026 02:16:21 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49563969482sm12331985e9.3.2026.07.20.02.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:16:20 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, can.guo@oss.qualcomm.com,
        beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jenswi@kernel.org, sumit.garg@oss.qualcomm.com
Subject: [PATCH v2 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Date: Mon, 20 Jul 2026 11:16:11 +0200
Message-ID: <20260720091614.544968-3-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=HeYkiCE8 c=1 sm=1 tr=0 ts=6a5de766 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=EUspDBNiAAAA:8
 a=h40Y9pVjyjmjd-OtGDwA:9 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: grMmPjWMVX2UR4sW_ThVLFw81tzPvMm9
X-Proofpoint-ORIG-GUID: grMmPjWMVX2UR4sW_ThVLFw81tzPvMm9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDEwMiBTYWx0ZWRfX7A2PZLiquWr8
 hz78WP4lnUNNtB9babjgT497h49XXrGMYPQL+nLahFok+MUanN/uiQj1CvvDqnT65TCHhwACBjH
 tEe5B20P3OULpzIyVhMRCC5WIP6Hjc8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDEwMiBTYWx0ZWRfXy1wzVw7ejCTx
 2raohvH/pJN/hW8+ZCDQdX/0Tvm8+8EP3JfCDfOWOwkuLWOc9786fk+IJcRq71F0oCzqKZeyh7C
 dcJFq4WUig4u+O1bwAbDjLHSuvoHFKNY9GxIoRb2F+D4jq0HfYPISBDRt+rvz7An0fqUs6hmR7I
 oL34KhuDIWWOJF1IXEbmgsKTJrxz8n0ctTWsjLRWxzv3he+0jHNb7Ydg5Gj5UsE0YOgu3Lzc5lp
 NPm0snbYukYPtyzAgEz3XkDfGfzG6ToghhysS84ancx/8FiT/tvpIqTCbKB65XHYxikT8ETG/MF
 6qT20lZsTC0G+zKSrQBSdCtRXHCyF9SjQSSLOsYA3GdeYAFZkesqm18erzTLUgQOa/VR60G3d0j
 eLcZiagdkNMH5+gUZGqNxW/XBa6wQl8C+JzlxwYDTQxPyBQFgTtqEV2w9Ukx5q3pRSP7Khur/dc
 M96xBcNEzw/Rl6m5ZDw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200102

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
 drivers/ufs/Kconfig         |  1 +
 drivers/ufs/core/ufs-rpmb.c | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

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
index d0c7ea7a36f4..0d8399b6497a 100644
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
 
@@ -154,6 +156,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 {
 	struct ufs_rpmb_dev *ufs_rpmb, *it, *tmp;
 	struct rpmb_dev *rdev;
+	char *dev_id = NULL;
 	char *cid = NULL;
 	int region;
 	u32 cap;
@@ -213,8 +216,17 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
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
+		blake2b(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LEN);
+
+		descr.dev_id = dev_id;
+		descr.dev_id_len = UFS_RPMB_ID_LEN;
 		descr.capacity = cap;
 
 		/* Register RPMB device */
@@ -228,6 +240,8 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 
 		kfree(cid);
 		cid = NULL;
+		kfree(dev_id);
+		dev_id = NULL;
 
 		ufs_rpmb->rdev = rdev;
 		ufs_rpmb->region_id = region;
@@ -240,6 +254,7 @@ int ufs_rpmb_probe(struct ufs_hba *hba)
 	return 0;
 err_out:
 	kfree(cid);
+	kfree(dev_id);
 	list_for_each_entry_safe(it, tmp, &hba->rpmbs, node) {
 		list_del(&it->node);
 		device_unregister(&it->dev);
-- 
2.54.0

