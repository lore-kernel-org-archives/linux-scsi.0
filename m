Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819A1C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D40960FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbhHQFOZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4768 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233861AbhHQFOY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2m1BK006952
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=FJ9/f4MipoUB90jnkPvdXK8dVHwHzABwP0lKsRfrCFU=;
 b=TbExNqjYUSiaOwyxhheLyQcWp+5mMgn/+hbMkGskv/3TYDPZjbmK6oBdY5RJqLlq26uJ
 5RBc656PCF2I/SG88sUlma9E8+orSra01+Hol9dsDybsZbbuZ4OGuHtGzVrOO6tYvIjq
 SR4ILN/2IErvvR0Ebj9XdrT4Z9U3Z097evfO6z4SqgXg0k0NZjkQT0FS9Pipe8/u8eYQ
 eSeOdCopmRZ2uoaHzAQv6r8H3wiT3OnBiLnN1YCpTwvP/Z5QeGI+rOagg7GLbWS9LjEH
 Q2F1g9DJh3zu1NKtRZHKoOPqiL2c9Y6+NNGMyFLQOrbff0+PmU6CDouavvjLNqJS8zWE Mg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0rdcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:51 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F02753F70A9;
        Mon, 16 Aug 2021 22:13:50 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5Docb002524;
        Mon, 16 Aug 2021 22:13:50 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5DoKR002523;
        Mon, 16 Aug 2021 22:13:50 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 03/12] qla2xxx: edif: fix edif enable flag
Date:   Mon, 16 Aug 2021 22:13:06 -0700
Message-ID: <20210817051315.2477-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: RVKVcHtZWL1E1e8q_Ft35CkMcozwD4DA
X-Proofpoint-ORIG-GUID: RVKVcHtZWL1E1e8q_Ft35CkMcozwD4DA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

edif_enabled is prematurely turned on if HW supports it.
FW too needs to support EDIF before enabling the bit.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  2 ++
 drivers/scsi/qla2xxx/qla_mbx.c | 14 +++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 55175e8a0749..47e8762545e5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4021,6 +4021,7 @@ struct qla_hw_data {
 		uint32_t	scm_supported_f:1;
 				/* Enabled in Driver */
 		uint32_t	scm_enabled:1;
+		uint32_t	edif_hw:1;
 		uint32_t	edif_enabled:1;
 		uint32_t	plogi_template_valid:1;
 		uint32_t	port_isolated:1;
@@ -4433,6 +4434,7 @@ struct qla_hw_data {
 	/* Cisco fabric attached */
 #define FW_ATTR_EXT0_SCM_CISCO		0x00002000
 #define FW_ATTR_EXT0_NVME2	BIT_13
+#define FW_ATTR_EXT0_EDIF	BIT_5
 	uint16_t	fw_attributes_ext[2];
 	uint32_t	fw_memory_size;
 	uint32_t	fw_transfer_size;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4dd008e06617..154e211bd4bf 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -663,6 +663,7 @@ qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
 }
 
 #define	NVME_ENABLE_FLAG	BIT_3
+#define	EDIF_HW_SUPPORT		BIT_10
 
 /*
  * qla2x00_execute_fw
@@ -795,10 +796,10 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		}
 	}
 
-	if (IS_QLA28XX(ha) && (mcp->mb[5] & BIT_10) && ql2xsecenable) {
-		ha->flags.edif_enabled = 1;
+	if (IS_QLA28XX(ha) && (mcp->mb[5] & EDIF_HW_SUPPORT)) {
+		ha->flags.edif_hw = 1;
 		ql_log(ql_log_info, vha, 0xffff,
-		    "%s: edif is enabled\n", __func__);
+		    "%s: edif HW\n", __func__);
 	}
 
 done:
@@ -1136,6 +1137,13 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 			       ha->fw_attributes_ext[0]);
 			vha->flags.nvme2_enabled = 1;
 		}
+
+		if (IS_QLA28XX(ha) && ha->flags.edif_hw && ql2xsecenable &&
+		    (ha->fw_attributes_ext[0] & FW_ATTR_EXT0_EDIF)) {
+			ha->flags.edif_enabled = 1;
+			ql_log(ql_log_info + ql_dbg_edif, vha, 0xffff,
+			       "%s: edif is enabled\n", __func__);
+		}
 	}
 
 	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
-- 
2.23.1

