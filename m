Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202991DDD1;
	Tue,  8 Oct 2024 02:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353098; cv=none; b=sOXKEF+DviCCgyJVibbgIKZKEfi6RHY8jZUPEtVmr45itsRpu3+oFgHs0lTzsoB3pmIeS6X8Un7JeduMndlQCHPnU1Hywo4RETB+Tbz9ppLQWXCkqJHNlyTMhn7N0rY9N6bmpQXGABiSLjaeagPN0NTwoP6jn6bE9wQNaopOJ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353098; c=relaxed/simple;
	bh=BxRgNUiypZpJ7+6rGgPPgax/nVWnfmxXRJ9dk5djXMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JS4DbVyEMuYZzAKqhUbGhjuxupRcHY1WNjXvvuRrlZL2pxpHzLApimqLSdeujhSswUc5Case7sJlmZJlrUrOoex92GCfoMPlUmQTrmEZkel2tWkwXL7As8h2V+n+GR2RTW5T092nqH+FNxtBgJG9kYwEXr10octNbcrKFf7YqXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IH+ODx00; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IH+ODx00"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4981Ngd0026309;
	Tue, 8 Oct 2024 02:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=i9ulD
	3t0spaBDdQPsDWCMGrwActQMyKHzQztlGyTsaM=; b=IH+ODx00EYf+PyrY45Pki
	BWTzvhPwGt80m3xjZ5UBB32VL4G5Jwcuv/1isDVQX4VCy34URJ9Wr0hdsbCm6ZHA
	59zcmZeLxYjYZPp+aFzqF9KcTTf+ugCFCLVMGUuj4xqH4yCPcFkn/SGlxa1hJYAX
	cIjW00s359l++B/kzpz3SMOdV045OYUASQcfEETuPBFfCYP7D8Phw86m1SluXLYo
	uPGkDzM5x28pA+C0iSmKewxWLQExHm9KytEs+hoEaIkazoPVxrOan2kNolAvmtwe
	5N3tIRPj9RBnbnb27vF1gNoPOS1bdy19DKjpK5dIMGOeHc18Lf0g8FMBnSpNY3du
	Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42300dvsjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 497N7Fp2004673;
	Tue, 8 Oct 2024 02:04:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uw6k89j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:42 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49824dIx004476;
	Tue, 8 Oct 2024 02:04:41 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-39-198-64.vpn.oracle.com [10.39.198.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uw6k87u-5;
	Tue, 08 Oct 2024 02:04:41 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/7] scsi: target: Add WRITE_ATOMIC_16 handler
Date: Mon,  7 Oct 2024 21:03:13 -0500
Message-ID: <20241008020437.78788-5-michael.christie@oracle.com>
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
X-Proofpoint-GUID: JSVeox7xXELl4SsJGddg482rjPjQQL5y
X-Proofpoint-ORIG-GUID: JSVeox7xXELl4SsJGddg482rjPjQQL5y

This adds the core LIO code to process the WRITE_ATOMIC_16 command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_sbc.c  | 48 +++++++++++++++++++++++++++++++
 include/target/target_core_base.h |  1 +
 2 files changed, 49 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index fe8beb7dbab1..0ae0d4ec0ac3 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -764,6 +764,46 @@ sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 	return 0;
 }
 
+static int
+sbc_check_atomic(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
+{
+	struct se_dev_attrib *attrib = &dev->dev_attrib;
+	u16 boundary, transfer_len;
+	u32 lba;
+
+	if (!attrib->atomic_supported)
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+
+	lba = transport_lba_32(cdb);
+	boundary = get_unaligned_be16(&cdb[10]);
+	transfer_len = get_unaligned_be16(&cdb[12]);
+
+	if (!boundary) {
+		if (transfer_len > attrib->atomic_max_len)
+			return TCM_INVALID_CDB_FIELD;
+	} else {
+		if (transfer_len > attrib->atomic_max_with_boundary)
+			return TCM_INVALID_CDB_FIELD;
+
+		if (boundary > attrib->atomic_max_boundary)
+			return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (attrib->atomic_granularity) {
+		if (transfer_len % attrib->atomic_granularity)
+			return TCM_INVALID_CDB_FIELD;
+
+		if (boundary && boundary % attrib->atomic_granularity)
+			return TCM_INVALID_CDB_FIELD;
+	}
+
+	if (dev->dev_attrib.atomic_alignment &&
+	    lba % dev->dev_attrib.atomic_alignment)
+		return TCM_INVALID_CDB_FIELD;
+
+	return 0;
+}
+
 sense_reason_t
 sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 {
@@ -861,6 +901,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 		break;
 	case WRITE_16:
 	case WRITE_VERIFY_16:
+	case WRITE_ATOMIC_16:
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 
@@ -872,6 +913,13 @@ sbc_parse_cdb(struct se_cmd *cmd, struct exec_cmd_ops *ops)
 			return ret;
 
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
+		if (cdb[0] == WRITE_ATOMIC_16) {
+			cmd->se_cmd_flags |= SCF_ATOMIC;
+
+			ret = sbc_check_atomic(dev, cmd, cdb);
+			if (ret)
+				return ret;
+		}
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case VARIABLE_LENGTH_CMD:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6c87bd018983..7b8ed21bea03 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -157,6 +157,7 @@ enum se_cmd_flags_table {
 	SCF_USE_CPUID				= (1 << 16),
 	SCF_TASK_ATTR_SET			= (1 << 17),
 	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
+	SCF_ATOMIC				= (1 << 19),
 };
 
 /*
-- 
2.34.1

