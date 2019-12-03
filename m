Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29498C432C3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC14D2080A
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 22:37:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RKPA3502"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfLCWhJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 17:37:09 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3486 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727240AbfLCWhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 17:37:08 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB3MZwlK017144;
        Tue, 3 Dec 2019 14:37:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=wkiYYQxMRyLbq6hMvUcUnHH4dmPE7sav416nNZZmXpI=;
 b=RKPA3502Pp29RFNYuJueKlX5KOceAWdgf/eChBMrO1ZZ4TIq845+7sa0eIdsT3ZFvt2X
 q9rBoBewx5Oh5WVDzy/L1TvZUXu06deJnLRLnBnK/GAE2CyOHSU3JVqUHzcLm4PR2+KS
 BGW9OZkmljonrzCP+xMSwdx0EOjuJ6LjWMT0ry9oE/5/sS6EWEJXJ1f5Ye2bJ5TNp2BW
 i32ppYwGujLbrJ1+FINOXY6NOwTX3If4Kam9QZ3OHACDJCl82fk+xeh57kUNm+Vn6Qj3
 UXIr1ThuP6F3xcp1dGqt8vhbxsSWa7mUXOFG42hqoq9ToNfb5+UWZZYoo/08Y3CBnyES 7A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wkrtsnbd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 03 Dec 2019 14:37:05 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 3 Dec
 2019 14:37:04 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 3 Dec 2019 14:37:04 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 004BD3F7045;
        Tue,  3 Dec 2019 14:37:03 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xB3Mb3a1022152;
        Tue, 3 Dec 2019 14:37:03 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xB3Mb3OY022151;
        Tue, 3 Dec 2019 14:37:03 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 2/3] qla2xxx: Added support for MPI and PEP regions for ISP28XX
Date:   Tue, 3 Dec 2019 14:36:56 -0800
Message-ID: <20191203223657.22109-3-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191203223657.22109-1-hmadhani@marvell.com>
References: <20191203223657.22109-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-03_07:2019-12-02,2019-12-03 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Michael Hernandez <mhernandez@marvell.com>

This patch adds support for MPI/PEP region updates which is required
with secure flash updates for ISP28XX.

Fixes: 3f006ac342c0 ("scsi: qla2xxx: Secure flash update support for ISP28XX")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_fw.h  |  4 ++++
 drivers/scsi/qla2xxx/qla_sup.c | 27 ++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 59f6903e5abe..9dc09c117416 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1523,6 +1523,10 @@ struct qla_flt_header {
 #define FLT_REG_NVRAM_SEC_28XX_1	0x10F
 #define FLT_REG_NVRAM_SEC_28XX_2	0x111
 #define FLT_REG_NVRAM_SEC_28XX_3	0x113
+#define FLT_REG_MPI_PRI_28XX		0xD3
+#define FLT_REG_MPI_SEC_28XX		0xF0
+#define FLT_REG_PEP_PRI_28XX		0xD1
+#define FLT_REG_PEP_SEC_28XX		0xF1
 
 struct qla_flt_region {
 	uint16_t code;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index b93a0d99e573..ae9d7422e78b 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2725,8 +2725,11 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		ql_log(ql_log_warn + ql_dbg_verbose, vha, 0xffff,
 		    "Region %x is secure\n", region.code);
 
-		if (region.code == FLT_REG_FW ||
-		    region.code == FLT_REG_FW_SEC_27XX) {
+		switch (region.code) {
+		case FLT_REG_FW:
+		case FLT_REG_FW_SEC_27XX:
+		case FLT_REG_MPI_PRI_28XX:
+		case FLT_REG_MPI_SEC_28XX:
 			fw_array = dwptr;
 
 			/* 1st fw array */
@@ -2757,9 +2760,23 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 				buf_size_without_sfub += risc_size;
 				fw_array += risc_size;
 			}
-		} else {
-			ql_log(ql_log_warn + ql_dbg_verbose, vha, 0xffff,
-			    "Secure region %x not supported\n",
+			break;
+
+		case FLT_REG_PEP_PRI_28XX:
+		case FLT_REG_PEP_SEC_28XX:
+			fw_array = dwptr;
+
+			/* 1st fw array */
+			risc_size = be32_to_cpu(fw_array[3]);
+			risc_attr = be32_to_cpu(fw_array[9]);
+
+			buf_size_without_sfub = risc_size;
+			fw_array += risc_size;
+			break;
+
+		default:
+			ql_log(ql_log_warn + ql_dbg_verbose, vha,
+			    0xffff, "Secure region %x not supported\n",
 			    region.code);
 			rval = QLA_COMMAND_ERROR;
 			goto done;
-- 
2.12.0

