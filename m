Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5611DA23;
	Tue,  8 Oct 2024 02:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353098; cv=none; b=r15siLKFgJenc03mjqDPArqcxsgYh7qAkE8X+N+RYc6lwtsLwcbAQqdrV7A3ZNZET0/DSBxtxsTXG4p1B9YciujVKN9rkGv50bdVTOGJmpvZDeVWNWw3KCwcsqefjp5z0GMzeCKNShrB+1n3G49zYzkukJDbtzqB+uzH/o6bgYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353098; c=relaxed/simple;
	bh=82BbjiaRGg1Q9oIzUyzslP7fiOwJuJ2oj7gVP3Uoros=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQABOzfTBjnj1CGXgMZCBYmdSpaAUjt0FCunMvcgdTgBcGgrip1/GWcw7D9aoru5w/ig9vLEmMgUgtCR8ubUjwArAHOlDB5+ztsrVRgs9lL2K+8Jk01XCx3p+G9A7aK84JHwCFBd+codKPn6GzZFO0NcFykSWTLPaOXMsvnggng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hlULDFS1; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hlULDFS1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4981MbNH024471;
	Tue, 8 Oct 2024 02:04:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=k7+Ms
	6pxTDF8/yNlA8b0BKvQYPRC3oihaK/Rh1QnpOQ=; b=hlULDFS1uLtzZJTL8Hu+W
	1uiOcCUaxXoKlja+3HtJVt2Nw2l2JnLnKJsWGDrAzqEa0ZDUes5vkwGFbUZVSYh6
	1L9tHJmEw7yP7pIFh0q2+T/qbDfiZzpFOTtuW0UW3pYwkVHLz48Xbm9EN+QZ6Thi
	4aO33uD09kwBzRqeidBZX5h8AQd5Eeqo3kYO6s/hMmdSETmVwrIit0qghCx3hAAf
	e8zykKwJYQxp/eTKVaiFPJPZ/a/U4xzjGiAjLtKeNEp0PsXAyQCBNPtBo+hZQZQL
	iezPJU/BQPB5yfYe4dE9jp3wRrzw0/yzkp5UZ97zyE282jWJ6MHxfov8gaAaQLqW
	A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42300dvsjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 497NtQUo004852;
	Tue, 8 Oct 2024 02:04:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uw6k88g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:40 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49824dIr004476;
	Tue, 8 Oct 2024 02:04:39 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-39-198-64.vpn.oracle.com [10.39.198.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uw6k87u-2;
	Tue, 08 Oct 2024 02:04:39 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/7] scsi: target: Rename target_configure_unmap_from_queue
Date: Mon,  7 Oct 2024 21:03:10 -0500
Message-ID: <20241008020437.78788-2-michael.christie@oracle.com>
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
X-Proofpoint-GUID: s8_8uWV9AxBtsNhhxx_qPm8x6yWsyjSn
X-Proofpoint-ORIG-GUID: s8_8uWV9AxBtsNhhxx_qPm8x6yWsyjSn

Rename target_configure_unmap_from_queue to
target_configure_unmap_from_bdev since it now takes a bdev.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c  | 6 +++---
 drivers/target/target_core_file.c    | 4 ++--
 drivers/target/target_core_iblock.c  | 4 ++--
 include/target/target_core_backend.h | 4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7d43d92c44d4..b709a64c0ff3 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -797,8 +797,8 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
  * Check if the underlying struct block_device supports discard and if yes
  * configure the UNMAP parameters.
  */
-bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct block_device *bdev)
+bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
+				      struct block_device *bdev)
 {
 	int block_size = bdev_logical_block_size(bdev);
 
@@ -816,7 +816,7 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 		bdev_discard_alignment(bdev) / block_size;
 	return true;
 }
-EXPORT_SYMBOL(target_configure_unmap_from_queue);
+EXPORT_SYMBOL(target_configure_unmap_from_bdev);
 
 /*
  * Convert from blocksize advertised to the initiator to the 512 byte
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 2d78ef74633c..b2610073e8cc 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -92,8 +92,8 @@ static bool fd_configure_unmap(struct se_device *dev)
 	struct inode *inode = file->f_mapping->host;
 
 	if (S_ISBLK(inode->i_mode))
-		return target_configure_unmap_from_queue(&dev->dev_attrib,
-							 I_BDEV(inode));
+		return target_configure_unmap_from_bdev(&dev->dev_attrib,
+							I_BDEV(inode));
 
 	/* Limit UNMAP emulation to 8k Number of LBAs (NoLB) */
 	dev->dev_attrib.max_unmap_lba_count = 0x2000;
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c8dc92a7d63e..3a191bc35e04 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -83,8 +83,8 @@ static bool iblock_configure_unmap(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 
-	return target_configure_unmap_from_queue(&dev->dev_attrib,
-						 ib_dev->ibd_bd);
+	return target_configure_unmap_from_bdev(&dev->dev_attrib,
+						ib_dev->ibd_bd);
 }
 
 static int iblock_configure_device(struct se_device *dev)
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 4063a701081b..d394306f8f49 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -121,8 +121,8 @@ sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 
 bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
-bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-				       struct block_device *bdev);
+bool target_configure_unmap_from_bdev(struct se_dev_attrib *attrib,
+				      struct block_device *bdev);
 
 static inline bool target_dev_configured(struct se_device *se_dev)
 {
-- 
2.34.1

