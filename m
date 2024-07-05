Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7F833C7
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 05:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720158911; cv=none; b=Rgq8RfcH19CXlG8lcRLnCjTwknlCXYnjNPCZBbr6ViOjGMMJ4vkowXPXal9FM7IU4cFgDv7ruFvuwmD0PceEKeqn78QhOvwJnkp1w3qZEHZUbxi8xC6ZYJ85LJYVdx6bEyrEcX5ZueA6hfj7YQKgrP1B9/WZUW0Xv6FBZdbi2YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720158911; c=relaxed/simple;
	bh=2LGZJA2dbJqiMFSXV3ITV3lJOczGPgr16W4rKNtYGeM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WtslisSHGE9e24UH21JUDj/jqhbItvccYGjbJRjaZnYLLP7IIyLT04L9cMWSd0MF3srLDgVHWBK7dMQjl02pob6nVUAro8HwRHP+jthyqxLZta62+w4FVMvZSIfPx3S6a5p7ofncQBbapPUg9i++VHICC/8Xh/TPGKmjB1g50nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=en8YE9TO; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="en8YE9TO"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464NkFLj002580;
	Thu, 4 Jul 2024 22:55:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=oaTLh8kr96O1anDVi3814Ko
	6+14PQClWQn1BpBTmDlo=; b=en8YE9TOJT6kz3sISaMJHQ65DgrG2hvg7d79ypT
	E9PNG2ZhsJJsY/UbgnowEyTZ1AtJj7UCqE22Vpud9QYELuS7RrFxa/KSagI8MM/1
	C8jNQbR6W61ZQECnIH8TAbQtvqmDG/PDcTu0Ny38pcHc7EPYGdRud74BuGZk9DzY
	ohPjwElXbNJ6zX7h63rJDr8cQaTjagSyCI128qNKmJ3kL3vlf/CdJY9mp+Vw+1Wm
	iGbobz9v09tRoSTFO5mtkg2rRRCSaMK/WfHtMvN8MRnPx8Pi7vs57frEi81Xj/GG
	KfhrUL8g1SwjQDtaPxQ65r4nlwXWQKjnlde4VXnr9Bchlfw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 405s2eat2q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jul 2024 22:55:02 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 4 Jul 2024 22:55:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 4 Jul 2024 22:55:01 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 154423F70A7;
	Thu,  4 Jul 2024 22:54:58 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH] qla2xxx: fix misc smatch warns
Date: Fri, 5 Jul 2024 11:24:37 +0530
Message-ID: <20240705055437.42434-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: GWvYWeittGFgvxjLFyXPNXCPHSHgtQCx
X-Proofpoint-GUID: GWvYWeittGFgvxjLFyXPNXCPHSHgtQCx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-05_02,2024-07-03_01,2024-05-17_01

Fix always true condition warn reported by kernel test robot,

smatch warnings:
drivers/scsi/qla2xxx/qla_inline.h:645 val_is_in_range() warn: always true condition '(val <= 4294967295) => (0-u32max <= u32max)'

Fix missing error code warn reported by kernel test robot and
other misc warnings,

smatch warnings:
drivers/scsi/qla2xxx/qla_sup.c:3581 qla24xx_get_flash_version() warn: missing error code? 'ret'

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/oe-kbuild-all/202406210538.w875N70K-lkp@intel.com/
Closes: https://lore.kernel.org/all/202406210815.rPDRDMBi-lkp@intel.com/
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_inline.h | 12 +-----------
 drivers/scsi/qla2xxx/qla_sup.c    | 16 ++++++++--------
 2 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 30e332806f86..ef4b3cc1cd77 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -634,17 +634,7 @@ static inline int qla_mapq_alloc_qp_cpu_map(struct qla_hw_data *ha)
 
 static inline bool val_is_in_range(u32 val, u32 start, u32 end)
 {
-	if (start < end) {
-		if (val >= start && val <= end)
-			return true;
-		else
-			return false;
-	}
-
-	/* @end has wrapped */
-	if (val >= start  && val <= 0xffffffffu)
-		return true;
-	if (val <= end)
+	if (val >= start && val <= end)
 		return true;
 	else
 		return false;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index f0a1c5381075..6d16546e1729 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -3433,7 +3433,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	struct active_regions active_regions = { };
 
 	if (IS_P3P_TYPE(ha))
-		return ret;
+		return QLA_SUCCESS;
 
 	if (!mbuf)
 		return QLA_FUNCTION_FAILED;
@@ -3457,7 +3457,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		if (ret) {
 			ql_log(ql_log_info, vha, 0x017d,
 			    "Unable to read PCI EXP Rom Header(%x).\n", ret);
-			break;
+			return QLA_FUNCTION_FAILED;
 		}
 
 		bcode = mbuf + (pcihdr % 4);
@@ -3465,8 +3465,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 			/* No signature */
 			ql_log(ql_log_fatal, vha, 0x0059,
 			    "No matching ROM signature.\n");
-			ret = QLA_FUNCTION_FAILED;
-			break;
+			return QLA_FUNCTION_FAILED;
 		}
 
 		/* Locate PCI data structure. */
@@ -3476,7 +3475,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 		if (ret) {
 			ql_log(ql_log_info, vha, 0x018e,
 			    "Unable to read PCI Data Structure (%x).\n", ret);
-			break;
+			return QLA_FUNCTION_FAILED;
 		}
 
 		bcode = mbuf + (pcihdr % 4);
@@ -3487,8 +3486,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 			ql_log(ql_log_fatal, vha, 0x005a,
 			    "PCI data struct not found pcir_adr=%x.\n", pcids);
 			ql_dump_buffer(ql_dbg_init, vha, 0x0059, dcode, 32);
-			ret = QLA_FUNCTION_FAILED;
-			break;
+			return QLA_FUNCTION_FAILED;
 		}
 
 		/* Read version */
@@ -3544,6 +3542,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	if (ret) {
 		ql_log(ql_log_info, vha, 0x019e,
 		    "Unable to read FW version (%x).\n", ret);
+		return ret;
 	} else {
 		if (qla24xx_risc_firmware_invalid(dcode)) {
 			ql_log(ql_log_warn, vha, 0x005f,
@@ -3573,12 +3572,13 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
 	if (ret) {
 		ql_log(ql_log_info, vha, 0x019f,
 		    "Unable to read Gold FW version (%x).\n", ret);
+		return ret;
 	} else {
 		if (qla24xx_risc_firmware_invalid(dcode)) {
 			ql_log(ql_log_warn, vha, 0x0056,
 			    "Unrecognized golden fw at %#x.\n", faddr);
 			ql_dump_buffer(ql_dbg_init, vha, 0x0056, dcode, 32);
-			return ret;
+			return QLA_FUNCTION_FAILED;
 		}
 
 		for (i = 0; i < 4; i++)
-- 
2.23.1

