Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B75C64E7B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFBCF2075A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 13:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgLBN2o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:28:44 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26358 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727530AbgLBN2o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 08:28:44 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B2DP5tW002247
        for <linux-scsi@vger.kernel.org>; Wed, 2 Dec 2020 05:28:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NyC0MfKXK6PUROgzRa9rrQoMY9gBnXJvyZM0lmyrPOI=;
 b=JlRDFoMRULlRupNRnxEGkcwfFxJp0OnGTmTpcST2peqM8vIlXI+4Fr58Gd8nuxJjmjsT
 aPEnwyZh8EoDf2rMU4VUEzYdZAzY9ff+ZKigGRe3antG07ZcQXCQLJth7zqO85PtnDcQ
 T/3Bq19drag/2Km9g4aqMIvGEpLb9zlgxf1hrYq5QxiB/xvxDInJd2JSHezJsZxIF8Fp
 lazwZCXYlbivDldKj31EdP1mf1+RaXpU1tiJryBDXZg2ybuah//3aV1nJLoeiptBVuyW
 oZG8E261m4c4JR/Hi6HX9/R3ZiDeHTHIPjhrlehT3X+8saP3alfSxO5GKl6lniwLn9tC sQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3568jf8g36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Dec 2020 05:28:03 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Dec
 2020 05:28:02 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Dec 2020 05:28:02 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6AF533F7040;
        Wed,  2 Dec 2020 05:28:02 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B2DS2ES020087;
        Wed, 2 Dec 2020 05:28:02 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B2DS2DU020086;
        Wed, 2 Dec 2020 05:28:02 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 11/15] qla2xxx: Fix flash update in 28XX adapters on big endian machines
Date:   Wed, 2 Dec 2020 05:23:08 -0800
Message-ID: <20201202132312.19966-12-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201202132312.19966-1-njavali@marvell.com>
References: <20201202132312.19966-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_06:2020-11-30,2020-12-02 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Flash update failed due to missing endian conversion in FLT region access
as well as in checksum computation.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

