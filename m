Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFF6224CC;
	Tue,  8 Oct 2024 02:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353103; cv=none; b=YzK+JyB7M5jd/Avpu3CD7W9iJhphLgpm8GAB0fJjtwfAsAeM9x/2k++7gP63XchHiYll2qVabdl+hb2UziJUMo4D7PWIEX9cE0ZulVfc5iq09qqUYH0hY4dRIBLwIC29ylh8ByMkR+OsD9HDpD9I/yRcjFkZ/0h94aWiTiaFIWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353103; c=relaxed/simple;
	bh=mMCxSq4EQQadsTzskF7bLTw2eUbERwgl89Pn6rwHKmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Br+FSJ4x5DxOx57HFqTf5lNI72/LizYklVnGFC65wbr258h+Et04spoHvES3Qeh/xndur11Mocgcg1RCagJBGW0gS/ou733I8JmFFhOiLfX7crWzwTnnfILg9IwQsjDcfnbbH2uYuh/ggItjhPa0YMIZkbXb5bWmXdZoi+t/H/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GJwTIkI5; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GJwTIkI5"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4981NXxw028752;
	Tue, 8 Oct 2024 02:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=ZtZre
	JKu/rmW6f77/GCc2ShZ8Fpl2MJMTfBA9s99mF8=; b=GJwTIkI5PUSlTsxpLQFpZ
	4nOjUv8hDjn5Sf8EZYhTSy1uBrdCSxGkyP/eFXxua6Wqk7KrspH6NnPWS2VQtLil
	NtUCfdh8lHi6sBx2Li8PVL07gLZXRgIFkgNZ0oueabgLJvoyBOPgqtWx3og9gSZB
	4Y8aQPlNBibMCi9bg2zdk1WLXV5XYuKjvbgbuPBeiLpQIXguTYL86x+QIBz2quQ2
	EUri/L4XVpHFXo4TMnSRm8/597Rcn2b74BseodmmYFKc3f307KCFTLNqpI4IIluK
	Mrf2CrEkMDcjRltsSs/9Casta05yUCOnpGWMaMMNnh/g6oySnWR40Cl2sniKQoaQ
	w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 423063mqk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:05:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 497N7Fp1004673;
	Tue, 8 Oct 2024 02:04:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uw6k89a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:41 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49824dIv004476;
	Tue, 8 Oct 2024 02:04:41 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-39-198-64.vpn.oracle.com [10.39.198.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uw6k87u-4;
	Tue, 08 Oct 2024 02:04:41 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 3/7] scsi: target: Add helper to setup atomic values from block_device
Date: Mon,  7 Oct 2024 21:03:12 -0500
Message-ID: <20241008020437.78788-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20241008020437.78788-1-michael.christie@oracle.com>
References: <20241008020437.78788-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-08_01,2024-10-07_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410080011
X-Proofpoint-ORIG-GUID: iOPSVtSQTBpvxPGq2lvGOH8MRvwc1i4o
X-Proofpoint-GUID: iOPSVtSQTBpvxPGq2lvGOH8MRvwc1i4o

This adds a helper function that sets up the atomic value based on a
block_device similar to what we do for unmap.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c  | 18 ++++++++++++++++++
 include/target/target_core_backend.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index b709a64c0ff3..4741de3d1061 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -793,6 +793,24 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	return dev;
 }
 
+void target_configure_write_atomic_from_bdev(struct se_dev_attrib *attrib,
+					     struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	int block_size = bdev_logical_block_size(bdev);
+
+	if (!bdev_can_atomic_write(bdev))
+		return;
+
+	attrib->atomic_supported = true;
+	attrib->atomic_max_len = queue_atomic_write_max_bytes(q) / block_size;
+	attrib->atomic_granularity = queue_atomic_write_unit_min_bytes(q) /
+								block_size;
+	attrib->atomic_max_with_boundary = 0;
+	attrib->atomic_max_boundary = 0;
+}
+EXPORT_SYMBOL_GPL(target_configure_write_atomic_from_bdev);
+
 /*
  * Check if the underlying struct block_device supports discard and if yes
  * configure the UNMAP parameters.
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index d394306f8f49..e32de80854b6 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -123,6 +123,8 @@ bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
 bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
 				      struct block_device *bdev);
+void target_configure_write_atomic_from_bdev(struct se_dev_attrib *attrib,
+					     struct block_device *bdev);
 
 static inline bool target_dev_configured(struct se_device *se_dev)
 {
-- 
2.34.1

