Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E55C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B837E60E76
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 04:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbhHJEjS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 00:39:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42570 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237160AbhHJEjI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 00:39:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A4aPp6008585
        for <linux-scsi@vger.kernel.org>; Mon, 9 Aug 2021 21:38:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=wCNwj0rDU0n0UXjIQMWEx2NJm5Rg45xNdV8pBMNz5Vo=;
 b=L0WXogr+MoAjKhxtrUOu+57cSeMZKnA8fAQlW/ArU1WcwaOdzK/116M/RHjdX1ZCGCal
 cDm+E4DyCQKbGLVS4iwZeq60j5eIeEb3xsOOZWA1R09H3GMbKxl4WMu4sQObsZgUEdAB
 mmD+KNmgcUtrco6GYAiCx/KkXxadgd9GHZ9Nqso0HfAHf/F9KcSuz9xGQ8LpibxxalQg
 3iG7NOB2qn494/SA+/zSMbfq1KDSZOgS6b2iiJGgPVjD/WHl13WC/GQQ5mSeTMBS5q1r
 7kAxC6sZwY2i94InA7xglG+najbjYiAREtmZFI6vbtd6TDQSPDjXCb9zmchFXJHEy8gP og== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3abfu2gf6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 21:38:46 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 9 Aug
 2021 21:38:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 9 Aug 2021 21:38:45 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3304B3F7044;
        Mon,  9 Aug 2021 21:38:45 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17A4cjtj001200;
        Mon, 9 Aug 2021 21:38:45 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17A4cjo8001199;
        Mon, 9 Aug 2021 21:38:45 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 05/14] qla2xxx: Show OS name and version in FDMI-1
Date:   Mon, 9 Aug 2021 21:37:11 -0700
Message-ID: <20210810043720.1137-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 79wzYMM0sRocuDEptXfklEORdAO_hpg1
X-Proofpoint-GUID: 79wzYMM0sRocuDEptXfklEORdAO_hpg1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-10_01:2021-08-06,2021-08-10 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

To be consistent with other OS drivers, register OS name and
version in FDMI-1 fabric registration.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 drivers/scsi/qla2xxx/qla_gs.c  | 4 ++--
 drivers/scsi/qla2xxx/qla_os.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index af0e8be0eb9b..c081bf1c7578 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2790,7 +2790,7 @@ static const char * const port_dstate_str[] = {
 /*
  * FDMI HBA attribute types.
  */
-#define FDMI1_HBA_ATTR_COUNT			9
+#define FDMI1_HBA_ATTR_COUNT			10
 #define FDMI2_HBA_ATTR_COUNT			17
 
 #define FDMI_HBA_NODE_NAME			0x1
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index b0b15fac5f3b..c37478f1b538 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1730,8 +1730,6 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	size += alen;
 	ql_dbg(ql_dbg_disc, vha, 0x20a8,
 	    "FIRMWARE VERSION = %s.\n", eiter->a.fw_version);
-	if (callopt == CALLOPT_FDMI1)
-		goto done;
 	/* OS Name and Version */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_OS_NAME_AND_VERSION);
@@ -1754,6 +1752,8 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	size += alen;
 	ql_dbg(ql_dbg_disc, vha, 0x20a9,
 	    "OS VERSION = %s.\n", eiter->a.os_version);
+	if (callopt == CALLOPT_FDMI1)
+		goto done;
 	/* MAX CT Payload Length */
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_HBA_MAXIMUM_CT_PAYLOAD_LENGTH);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3b8230c35f26..995ab58d3288 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7990,7 +7990,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct cmd_type_7_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct cmd_type_crc_2) != 64);
 	BUILD_BUG_ON(sizeof(struct ct_entry_24xx) != 64);
-	BUILD_BUG_ON(sizeof(struct ct_fdmi1_hba_attributes) != 2344);
+	BUILD_BUG_ON(sizeof(struct ct_fdmi1_hba_attributes) != 2604);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi2_hba_attributes) != 4424);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi2_port_attributes) != 4164);
 	BUILD_BUG_ON(sizeof(struct ct_fdmi_hba_attr) != 260);
-- 
2.19.0.rc0

