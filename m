Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647D41E535;
	Tue,  8 Oct 2024 02:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353087; cv=none; b=Co+VDQfeFh7IrlYKkgXdP7OzDcvlpEEfBZhGdRxLxLA++ms6+dYpkwt2ula0/90OZggD+lUGJWVNkQDHus4Ioc1qxhiu4i8nbTl8c+wAtJ4IELVXf9q+M+yEG+IaPKBWJ+Tit8bNGEYldtp0Jp5zOoQSblk4q+GC+U/O5gyjsRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353087; c=relaxed/simple;
	bh=240Fjp5I/hgUap1+AA+uwubZn0ov7SSs7o8LorTQ8NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gn9YcPMG552pY8v9qJZ+lA6mFqMrYGmNwgCDAXJMLH1OCWJzLpg3J1QAmoErvan7r5CY4ARX8Uev+s9hXlu2DTmJJe33qb/waP5OpzHxS0IXSfQ1fZb3mX5cqTtI68lpSUm0sFMbacpF3/CWVJz//czMDJYTdWZYYFZeH9LB5p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QlQOEulq; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QlQOEulq"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4981NPqf029078;
	Tue, 8 Oct 2024 02:04:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=cD00d
	o1qDxGmCw7I1jk21vOZvcxUiOYRtq0zTqZPsPs=; b=QlQOEulq58XhWt/TQE4OK
	I2qncNirio4Q9tI7UalCsg8CAyo8ZDK4vmwk3rt/3ZxQT1saEzm8P8RQchBr5pua
	a6QlGVnyljikpwa3GPxmZB4d1wcwqqYUEvPcY5aYA9DQQelRpmbLyAyOH5nItf9U
	TRRTjQnPOVGv88XbKhpCMS/B0pf4L37gDdd6fSybZ3Ydqfo2XEwwKiL50+RuWRwu
	eQzn0JG1UBdeJ56D6PuTnAh0QxcZVZC28O2ZXK6qhFhGw3rTBKE3pCBzf1G/53mo
	PxxVynDlFrFHpJ1dmNJoYQkyWWlRXZSBsWE5Xn3mXp8zhSV/z9h5A/NeyUNvruw2
	g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 423034mwjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 497N7Fp4004673;
	Tue, 8 Oct 2024 02:04:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uw6k8aa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 08 Oct 2024 02:04:43 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49824dJ3004476;
	Tue, 8 Oct 2024 02:04:43 GMT
Received: from mnc-mac.us.oracle.com (dhcp-10-39-198-64.vpn.oracle.com [10.39.198.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uw6k87u-7;
	Tue, 08 Oct 2024 02:04:43 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 6/7] scsi: target: Add WRITE_ATOMIC_16 support to RSOC
Date: Mon,  7 Oct 2024 21:03:15 -0500
Message-ID: <20241008020437.78788-7-michael.christie@oracle.com>
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
X-Proofpoint-GUID: _XVsRFTuZud2TDsqajHNNI03RkHFfLZS
X-Proofpoint-ORIG-GUID: _XVsRFTuZud2TDsqajHNNI03RkHFfLZS

This has us report if the device supports WRITE_ATOMIC_16 in the
REPORT_SUPPORTED_OPERATION_CODES command.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_spc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ce5eec5c8b8a..3c28b0ec5daf 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1470,6 +1470,24 @@ static struct target_opcode_descriptor tcm_opcode_write_same32 = {
 	.update_usage_bits = set_dpofua_usage_bits32,
 };
 
+static bool tcm_is_atomic_enabled(struct target_opcode_descriptor *descr,
+				  struct se_cmd *cmd)
+{
+	return cmd->se_dev->dev_attrib.atomic_supported;
+}
+
+static struct target_opcode_descriptor tcm_opcode_write_atomic16 = {
+	.support = SCSI_SUPPORT_FULL,
+	.opcode = WRITE_ATOMIC_16,
+	.cdb_size = 16,
+	.usage_bits = {WRITE_ATOMIC_16, 0xf8, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, 0xff, 0xff,
+		       0xff, 0xff, SCSI_GROUP_NUMBER_MASK, SCSI_CONTROL_MASK},
+	.enabled = tcm_is_atomic_enabled,
+	.update_usage_bits = set_dpofua_usage_bits,
+};
+
 static bool tcm_is_caw_enabled(struct target_opcode_descriptor *descr,
 			       struct se_cmd *cmd)
 {
@@ -2026,6 +2044,7 @@ static struct target_opcode_descriptor *tcm_supported_opcodes[] = {
 	&tcm_opcode_write16,
 	&tcm_opcode_write_verify16,
 	&tcm_opcode_write_same32,
+	&tcm_opcode_write_atomic16,
 	&tcm_opcode_compare_write,
 	&tcm_opcode_read_capacity,
 	&tcm_opcode_read_capacity16,
-- 
2.34.1

