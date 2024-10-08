Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8201E521;
	Tue,  8 Oct 2024 02:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353086; cv=none; b=WslkpdOe/yAts5xwztCL6a6jaPm64L0PCn9SJmjAsmfpeMJB53L+/KByEG1lWpF6AgAKQSqGvjbwCW1mCveBndFt9xkD7xOdj5a0bVn7owxaArlp78KnOakDcAfgCIR9nMz9tTkAAeTPBLlXv5RgVQepreEl5S/C11QqFLioLbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353086; c=relaxed/simple;
	bh=Qo2bBHz6o0RWSFxOXBuxks1PCu1IoFznnowEk7qC9Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrYTLuolOKFL6AD/Se/fqA8deVFXoU0NDanrQnj+O3yoJDc+y/QCqgEPc5QJCVChU932LGSdKMuz1rVRN8+AuJvi54dcN42PkYWPx1htbqjGCR0kq5/qEAK6qjsUGPbWYnvg3gv1b3YpV6F1lIQo6yfWD6F6+qAco2/q9D6V21I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NcmxiaHT; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NcmxiaHT"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4981NRCF017174;
	Tue, 8 Oct 2024 02:04:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=sGres
	LzoD2uP6/wO1wXeMUqH11/coc1Pc/HHk6IJdVI=; b=NcmxiaHTy8vA6HdhZRxMU
	dPK4bhUjiSV3D/Yc0a2mepwO5Gjq4TMEplbrHdoRqU5T6RcDH2Y7M+Ixc/XjNj9/
	WaBFXZffARJUe8LA3i7C1PyvsaLPhqSzoxx9wyfHE9IxmquDwzxPu46NhaFpDyqq
	/0UqUQk2WAVHKMeunSvz6UqqKqgzZZWmma2oKEt4MU7wjqbe2L5fwaGxFS7g0IjE
	Lih9MvaTieYei3vZxZqP73VLgsChzwdJu1oKkHwEHgeFd159h4NYb9NiM951wm2z
	JSdf/YN24xzp3Lzb6S1rjPlyozeMTnf+kbBUYG1FXtW4qqic7t88KX/ri+8The/s
	Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 422yyv4sde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49820vbZ004624;
	Tue, 8 Oct 2024 02:04:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uw6k89u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:42 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49824dJ1004476;
	Tue, 8 Oct 2024 02:04:42 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-39-198-64.vpn.oracle.com [10.39.198.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uw6k87u-6;
	Tue, 08 Oct 2024 02:04:42 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 5/7] scsi: target: Report atomic values in INQUIRY
Date: Mon,  7 Oct 2024 21:03:14 -0500
Message-ID: <20241008020437.78788-6-michael.christie@oracle.com>
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
X-Proofpoint-GUID: x3GvuTW_Czb4w-fqKRoSGdJQdeRdGr6Q
X-Proofpoint-ORIG-GUID: x3GvuTW_Czb4w-fqKRoSGdJQdeRdGr6Q

This reports the atomic values in the Block Limits VPD page.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_spc.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ea14a3835681..ce5eec5c8b8a 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -521,7 +521,6 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 		have_tp = 1;
 
 	buf[0] = dev->transport->get_device_type(dev);
-	buf[3] = have_tp ? 0x3c : 0x10;
 
 	/* Set WSNZ to 1 */
 	buf[4] = 0x01;
@@ -562,11 +561,10 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	else
 		put_unaligned_be32(dev->dev_attrib.optimal_sectors, &buf[12]);
 
-	/*
-	 * Exit now if we don't support TP.
-	 */
+	put_unaligned_be16(12, &buf[2]);
+
 	if (!have_tp)
-		goto max_write_same;
+		goto try_atomic;
 
 	/*
 	 * Set MAXIMUM UNMAP LBA COUNT
@@ -595,9 +593,29 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * MAXIMUM WRITE SAME LENGTH
 	 */
-max_write_same:
 	put_unaligned_be64(dev->dev_attrib.max_write_same_len, &buf[36]);
 
+	put_unaligned_be16(40, &buf[2]);
+
+try_atomic:
+	/*
+	 * ATOMIC
+	 */
+	if (!dev->dev_attrib.atomic_supported)
+		goto done;
+
+	if (dev->dev_attrib.atomic_max_len < io_max_blocks)
+		put_unaligned_be32(dev->dev_attrib.atomic_max_len, &buf[44]);
+	else
+		put_unaligned_be32(io_max_blocks, &buf[44]);
+
+	put_unaligned_be32(dev->dev_attrib.atomic_alignment, &buf[48]);
+	put_unaligned_be32(dev->dev_attrib.atomic_granularity, &buf[52]);
+	put_unaligned_be32(dev->dev_attrib.atomic_max_with_boundary, &buf[56]);
+	put_unaligned_be32(dev->dev_attrib.atomic_max_boundary, &buf[60]);
+
+	put_unaligned_be16(60, &buf[2]);
+done:
 	return 0;
 }
 
-- 
2.34.1

