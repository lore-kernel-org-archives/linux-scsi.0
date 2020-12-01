Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF364C64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40EC620659
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:33:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eU6NtadC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgLAIdE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:33:04 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51812 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbgLAIdE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:33:04 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18Vq6h026033
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:32:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=EFOowl+NqYu6DsUkggYqH0Lix5z6bo23QeUXVokTySk=;
 b=eU6NtadCGPLH/yCY7UH89iM8C/TIUZlq9ScPS4DTT6z6hj+6PG02Bxq5OGn5Xu2RTFPT
 nwZQUIz4NRyFsMrueieiXyj+I0QW4MUDg2vcyOQZAuZlj7AShcPjn7xBAFGUKjAgMjjv
 6v40mM7MsFTEeiieq24OBLw0MbSqnHKIcB+mfRl485hOo9w6RmdIaKYpy6WLjJk4ngsS
 1FWkJSe/9uLMZ8SMyokuw5rMM/2mlFsg/f0Y0e4t22788By+EQ8wfiY+7/W4YZQHjz4K
 hhtG0aAkpKdPk6ETFVTeiYELwm9pGwt9abig9Yeb/TqvQ8uWGpmtRsvXVwj1zENOmesP Iw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 353pxsf7n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:32:22 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:32:20 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:32:20 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 886B23F7040;
        Tue,  1 Dec 2020 00:32:20 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18WKiY024333;
        Tue, 1 Dec 2020 00:32:20 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18WKcB024332;
        Tue, 1 Dec 2020 00:32:20 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 11/15] qla2xxx: Fix flash update in 28XX adapters on big endian machines
Date:   Tue, 1 Dec 2020 00:27:26 -0800
Message-ID: <20201201082730.24158-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201201082730.24158-1-njavali@marvell.com>
References: <20201201082730.24158-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Flash update failed due to missing endian conversion in FLT region access
as well as in checksum computation.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_sup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 0f92e9a044dc..f771fabcba59 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -2634,14 +2634,14 @@ qla28xx_extract_sfub_and_verify(struct scsi_qla_host *vha, uint32_t *buf,
 	    sizeof(struct secure_flash_update_block));
 
 	for (i = 0; i < (sizeof(struct secure_flash_update_block) >> 2); i++)
-		check_sum += p[i];
+		check_sum += le32_to_cpu(p[i]);
 
 	check_sum = (~check_sum) + 1;
 
-	if (check_sum != p[i]) {
+	if (check_sum != le32_to_cpu(p[i])) {
 		ql_log(ql_log_warn, vha, 0x7097,
 		    "SFUB checksum failed, 0x%x, 0x%x\n",
-		    check_sum, p[i]);
+		    check_sum, le32_to_cpu(p[i]));
 		return QLA_COMMAND_ERROR;
 	}
 
@@ -2721,7 +2721,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	if (ha->flags.secure_adapter && region.attribute) {
 
 		ql_log(ql_log_warn + ql_dbg_verbose, vha, 0xffff,
-		    "Region %x is secure\n", region.code);
+		    "Region %x is secure\n", le16_to_cpu(region.code));
 
 		switch (le16_to_cpu(region.code)) {
 		case FLT_REG_FW:
@@ -2775,7 +2775,7 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		default:
 			ql_log(ql_log_warn + ql_dbg_verbose, vha,
 			    0xffff, "Secure region %x not supported\n",
-			    region.code);
+			    le16_to_cpu(region.code));
 			rval = QLA_COMMAND_ERROR;
 			goto done;
 		}
-- 
2.19.0.rc0

