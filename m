Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182301F94D;
	Tue,  8 Oct 2024 02:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353088; cv=none; b=VbD9J1cjxIux/g7hkwjL6zrS78+0cc+4k0hArQ4+xQ1Zdbe4meIQJLoM9y0bruWs8sZDhynVXNWFEZDGd35QgTXhBlcFT6l3Aw1uh0gz5xvU1IhketqU2VfEvtiXCfzpgioJKw5rbWu9F4+l6cZ9QbYEvmMzwDO7+xTCkmNp7TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353088; c=relaxed/simple;
	bh=eqSewDr4xj2Sb8JzbR0bnGZwK1Pr7LkYPy6Vpdxs4PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=liATNYgsBrazihffumryUOC29RZiAUQHtkDRZuM97e5p/iccUPdBH6sGB5prNM/mBe0csJV+BdHOhTCvUDb5qD9wsQmZdw80ov2g5ITFGwzSjsz45nmKwzNhBQSQRvo7jfwnz6a40PqG3jlEX2vJUqjN0eLtsz1PdKmiXtFWw/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F/UP5Gyp; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F/UP5Gyp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4981MaiX016128;
	Tue, 8 Oct 2024 02:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=TvkTw
	q41Nq01f3w6l/f1GTqJd99SYlUmj31/V9CcjGs=; b=F/UP5GypwaEXUi9zd0Uoa
	czKveogUYbJQR65Z0tWwyx3RdW0/Zd5t/VhAGmSOapT0Uu6hy0IuDW03s9RcIQ1r
	XTzsFH0R1o5VhRU7Cf4G3LoaUQW2HdrcUjZv3uzV3moLm6IvwVZpI8FkcFPB/hTw
	fOr31WC6F+RExWl/nRwSKqLoXzTrxKIMqgbrFJH/ROIEp5bK68gbTBZo7x/LATNb
	XbcqxdzopOx+ZKrqoyzTOYyX31ihjg+FBWpadOeVJjXKBOdMB1PT3RqySozh4zUZ
	sUNuAdiQisxFD7jHpMmsS4gvrrjgphi+nZAk+NcVOgQNjDUu94w7oaXgSPDZdBEo
	g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 422yyv4sdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4981HhDO004682;
	Tue, 8 Oct 2024 02:04:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uw6k8ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:44 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49824dJ5004476;
	Tue, 8 Oct 2024 02:04:43 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-39-198-64.vpn.oracle.com [10.39.198.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uw6k87u-8;
	Tue, 08 Oct 2024 02:04:43 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 7/7] scsi: target: Add atomic support to target_core_iblock
Date: Mon,  7 Oct 2024 21:03:16 -0500
Message-ID: <20241008020437.78788-8-michael.christie@oracle.com>
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
X-Proofpoint-GUID: oqxbd1V21j4ufplQdHz5p884tZgAYYu_
X-Proofpoint-ORIG-GUID: oqxbd1V21j4ufplQdHz5p884tZgAYYu_

This has target_core_iblock use the LIO helper function to translate its
block_device atomic settings to LIO settings. If we then get a write
that LIO has indicated is atomic via the SCF_ATOMIC flag, we use the
REQ_ATOMIC flag to tell the block layer to perform an atomic write.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 3a191bc35e04..afcd62f81d20 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -147,6 +147,8 @@ static int iblock_configure_device(struct se_device *dev)
 	if (bdev_nonrot(bd))
 		dev->dev_attrib.is_nonrot = 1;
 
+	target_configure_write_atomic_from_bdev(&dev->dev_attrib, bd);
+
 	bi = bdev_get_integrity(bd);
 	if (!bi)
 		return 0;
@@ -762,6 +764,9 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			else if (!bdev_write_cache(ib_dev->ibd_bd))
 				opf |= REQ_FUA;
 		}
+
+		if (cmd->se_cmd_flags & SCF_ATOMIC)
+			opf |= REQ_ATOMIC;
 	} else {
 		opf = REQ_OP_READ;
 		miter_dir = SG_MITER_FROM_SG;
-- 
2.34.1

