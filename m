Return-Path: <SRS0=dBT0=W2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29481C3A59B
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED9BF23431
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Aug 2019 22:24:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZJUNF2uU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfH3WYM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Aug 2019 18:24:12 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60448 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728111AbfH3WYM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Aug 2019 18:24:12 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UMKOPG002131;
        Fri, 30 Aug 2019 15:24:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=eYisqo3iAYADGKs4K4pGqTbsGbttW75cF92zSjfrAA4=;
 b=ZJUNF2uUET1Iz5/NuUpfWZCF2EWqJkm8RUKTnbglNpeHloAXcYwz1lutGXwMdPaFT2aT
 vkO3EkO4vZPlsYOMwa0pjvWgPojCbDLEXwGvbhirFEok37p+4/fZdY/xuH0NpdPaV2tv
 x09oXPKUSTTyFJ9xgZ+dC6tbU/xa8leiTSV5QhCIfQ2LYPMMaPaBm/54Tio6ctN82C1v
 +hcD7G5ZSlv9B4Uj5z/K6GWBPK8TAEpncLLDFMSSgbq5Pq7SqHb86uOtwB5ukYwOOpOs
 Eo2C/2YT4+QeHAhPVa4hN0qlA2dRESGkuGh0t3TCKaRyXiM2vPlVQkuxsa+at+xWOMSc /g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2uk4rm2daa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Aug 2019 15:24:08 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Aug
 2019 15:24:06 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 30 Aug 2019 15:24:06 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CBB953F7040;
        Fri, 30 Aug 2019 15:24:05 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7UMO5No023727;
        Fri, 30 Aug 2019 15:24:05 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7UMO5cX023726;
        Fri, 30 Aug 2019 15:24:05 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/6] qla2xxx: Fix message indicating vectors used by driver
Date:   Fri, 30 Aug 2019 15:23:57 -0700
Message-ID: <20190830222402.23688-2-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190830222402.23688-1-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_09:2019-08-29,2019-08-30 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch updates log message which indicates number
of vectors used by driver instead of displaying failure
to get maximum requested vectors. Driver will always
request maximum vectors during initialization. In the
event driver is not able to get maximum requested vectors,
it will adjust the allocated vectors. This is normal and
does not imply failure in driver.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d81b5ecce24b..4c26630c1c3e 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3466,10 +3466,8 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 		    ha->msix_count, ret);
 		goto msix_out;
 	} else if (ret < ha->msix_count) {
-		ql_log(ql_log_warn, vha, 0x00c6,
-		    "MSI-X: Failed to enable support "
-		     "with %d vectors, using %d vectors.\n",
-		    ha->msix_count, ret);
+		ql_log(ql_log_info, vha, 0x00c6,
+		    "MSI-X: Using %d vectors\n", ret);
 		ha->msix_count = ret;
 		/* Recalculate queue values */
 		if (ha->mqiobase && (ql2xmqsupport || ql2xnvmeenable)) {
-- 
2.12.0

