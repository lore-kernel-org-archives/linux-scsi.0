Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8D73F23DB
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784191063; cv=none; b=WtxYsgySxigOsGUmC3uAwKft0l8ElvwFSHafj8iAb2/sk0wxiadvmgPPat/YKb1AUhEmc2J0QT8kMrMF1myPyI54pU05uSs6ucAwxh2TE0P57k3k64xrVxzsf8f+aZfS+kz8v1LjmgRZCYM+VQtP02nS7+sTUxkzYPtX0MgzNtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784191063; c=relaxed/simple;
	bh=NCMb0CAxTVCcPUPM3ObrHiyfUVdP5M/LsUrX5gE5HoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkzOftt8mizv7cMFKhjbAwb5kF1J9/BMjQH7iR8xtaseKH/qoNcF55NEwKvrWtYrHxn0+tW9fIwIs0Dp6FiMIVurLjJV8EEMhz/26FsWSbv0bLmkU/Wxb/zH/R4IA5KAo4jOvAvsum8u88kdgdhmGzHBU1TmQ80Fra6yEgqpYNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hlHEw8Ei; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=f7dOEYRC; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hlHEw8Ei";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="f7dOEYRC"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G7DkpQ1848138
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:37:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=Vuwauky0S7U
	MDJ8ZgbId8W1CiyJ3qKKODKvrCHME6gg=; b=hlHEw8EiO6Te84IfBJxuj5IYC6F
	3pS+lBJMkXDizUjRZZu/bjN3NRtdVIB6Cqx0+sUn67tISa4gyLrExoy5MgOFeRJU
	PJ6u5hMQfLDrCe/JMFrKuRx+CB3IPY/MuaqJkOdUH79fjCE2QD5MeWjwVbF1E3L0
	01kRgNTPa+2KTVMzC3xvYy5ihDNuW4gJNpsC6Zwru6C7wIVZeVPE/YJ0Htws660/
	GWmzlfUQm9AiUb2QrL1hpvgI1E87wzx5F4HVOg18/T8myfn5LSd01Qshev1bnZq6
	Mhk0WuLyQv8pzB+vz1HEGksXVO3vu6ogSSTc2X8TMCVnPDJI7bPYmOtyZdg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fetb7rd6s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 08:37:41 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92d1cae5939so887430885a.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 01:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784191060; x=1784795860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vuwauky0S7UMDJ8ZgbId8W1CiyJ3qKKODKvrCHME6gg=;
        b=f7dOEYRC8oyO3M1ksRvF1AWM3nrFJSDX1DUpYVMe4YVnzEHVvhA5WNlbEo3T/vNAXY
         OVNssFKZj4yw1rho3eSbAT3nZLtxBG8wel4mewuCdq7V1DcxIULhfv8eKfi80agohmuM
         XTB+7KHHALc1GbuQ93g81rMktwlmGvzrDCW5XihhV5Svj/WSisH/f7YWFZ0p0X+v7wx6
         eNhxxZcEkz3bd4ZlyRRTKe6MQM/47rHxwhdDOowwy5D6RpRmsFUkS8kwn2C+tr+ao2Es
         6R173gQmp5+Ivj9dogs4cVrsYSoKdzrH/fwkk4i7m9XyUJD4DcO+wHKMNZs8ePUooF7M
         6t2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784191060; x=1784795860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vuwauky0S7UMDJ8ZgbId8W1CiyJ3qKKODKvrCHME6gg=;
        b=nqxGk6iZs6hk3dyFWYB8diZrIB6H/sImSA0pKYg6/rQUxwvFhfCq3zImjXkngkxGoh
         cap0r5K4+o9Gystq77IRw3eZtDW04tSFf6PNRArHFuJLW6TgStn6j3j04ZqgMtAymq9d
         pJIMfU+B0cnAOscvpjjJp2KMIG7qJgorFtVh3oRgdU8A3TI0T/LmUgecjV4mEBaJ1RNe
         yWXMruyI9tqDmJmCXd/5t3uk+D6fS60FILxCJuPPKU23FyTVkBGCCpLDJaTE/VGIvS36
         XTqjoaw+e+kqkWBU8H+dEJnqJonEmkPMmstTljfaHM8OIrT4KKP49Tk6jW6CVFMTNWU5
         2mnA==
X-Gm-Message-State: AOJu0Yz65JP4oXH6XHW9w7bSnZ+HXMgHWExwQWptK1AP5UZa7YeDXQTS
	MB1PjnEZiNNnTy9iX5xuMK56G3DLIbcDYW2T0r3sHj2JkHtmOhlc+3EvGGTovrmfUkB5bNO21x4
	ugUZlKGu9QIN6oKQ8AxC40MoiFxPUkI5NyAL3mYB/XXqviVwHr3YDyKs0NcfUgQmM
X-Gm-Gg: AfdE7cmBrUg2u9KOpJn/NUN171FdYtdlqvJL5mAsTMJQopQdaaZxQBHeSMIHeJgwLRZ
	/hrGY23AFAr7+PcnhF1UAMI7GdxEQbylSecjknf8E5nmo77DK+O8wi0pFy9SWaBZ325ZP+vj/Dt
	1l8Zq4e7RrD8xXVEtDJ+zE0GzPF5Bt2Fae88vkcliwLygvBJop5VAkcVxm8dTkm6r3u3fa7etkR
	fAr/aayU4QbMXhG6XHTaFwHhwgICuYyawJ/szSpEPOb/rDjILDpL3F0/VDA5kTO4gPCHnFV7Zzg
	lQxvBvqInre2AASHVJr/SiwQvuGex5dwnkzRsgX8xXi8n/+JGSrTNfJLGvw5sH/LIPn45N3IsMe
	9VWPmx7D51Rx/3eCv/lmZnVtBQC1cv4h5IU5/vdqiNHafZVldams=
X-Received: by 2002:a05:622a:4185:b0:517:8470:2d2d with SMTP id d75a77b69052e-51e4237cd58mr115608711cf.29.1784191060686;
        Thu, 16 Jul 2026 01:37:40 -0700 (PDT)
X-Received: by 2002:a05:622a:4185:b0:517:8470:2d2d with SMTP id d75a77b69052e-51e4237cd58mr115608401cf.29.1784191060259;
        Thu, 16 Jul 2026 01:37:40 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e94e7asm43614295e9.12.2026.07.16.01.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 01:37:39 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: [PATCH v1 2/2] ufs: rpmb: use a fixed-length RPMB dev_id
Date: Thu, 16 Jul 2026 10:37:20 +0200
Message-ID: <20260716083728.2226422-3-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260716083728.2226422-1-jorge.ramirez@oss.qualcomm.com>
References: <20260716083728.2226422-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDA4OCBTYWx0ZWRfXwxTTbPoXmFz/
 7bzEVXVOFiO5EjACANJFXR69Z33S95Qfy+QLi85W6dVrGz8xuHSOQQH13vRvCSq8D4K5vSBtyzC
 CIrQ2eHR/2vk7xbyzOdtvEhxzOr5M+U=
X-Authority-Analysis: v=2.4 cv=dM2WXuZb c=1 sm=1 tr=0 ts=6a589855 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=OSdCpuDsIsRB4DqEP3sA:9 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDA4OCBTYWx0ZWRfXyjfzeRIE25p1
 QHaSWbGcdnSgJ6+WxtqYXawQPmfKZLsHwJ1zOibk9byP40GsyvInvT8jySDeix3F1Any4DM71UX
 SXRouWP72/fOVx0zETtH2uituFinTVhWqhcsi7iiAzDk7kwBKrbvnnde7WQBiqmBtxfPyZYHPCR
 x41rggQ1EMqtDfjOALVzAJ8EqPJ6bkjw/77KUELLYVN90CPAeAS9KaR14ZR0PbEsv+Nxlx578ME
 bczWH7Gz937lBnBPVAGkeCWf+NDmJ5+GGENC57usjXfAb1PnN3Uj+2eInL5m2+cKm3FmYuhF1QD
 TMLIDSkFFuMUudsYp5wP2/VKG9wysQlfVzcPPD7ACgrGuGZKYb2kx5PuTnlai31sjxPm3e5ooJR
 ZN7o6KJe/rn0vzETMZoLuOiN5bpB3lhU4lE65l92BtNng81dgeuOZhlP149IcuAw4wtos4gEFZH
 7H6EIKLPB7/PhcOqkHQ==
X-Proofpoint-ORIG-GUID: bjZm0A7GTCZe7FbzWulDKjKlzRHMxfx6
X-Proofpoint-GUID: bjZm0A7GTCZe7FbzWulDKjKlzRHMxfx6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_03,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607160088

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

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-rpmb.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index d0c7ea7a36f4..b800871269bb 100644
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
+		blake2s(NULL, 0, cid, strlen(cid), dev_id, UFS_RPMB_ID_LEN);
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

