Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BD0C4707F
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 00:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 798DD61009
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 00:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhE1AeH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 20:34:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61142 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233148AbhE1AeG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 May 2021 20:34:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14S0VCHn008640
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 17:32:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=NaQXxllFV6NynN9/Bp99j0jqc/6AJi8uN4E6kjH108g=;
 b=QHzTXTEyYuuriUQwWJrrWG3tac0wpupQUF/xaaE4q8Tow8ghFQSqr1xdg31+5tgDU4aZ
 uZxXje0TC8vTxBItA3ygAariiSK+fPCL6HLW/ubSfVzF2roOvvsB+lJMvNESRw4q7d2u
 g8jhbI7Iay9i1rxi0RWDBoYZFwB2fvq3SrvkN741k+zu9fea6iIQ0RbwYgm1qfauWSwU
 TdCJSKWlwDdwEfOP/9RRwyjum+fYtoTr8G4myivFGAMmIlRcvTkfu910M7V+H6Qdu+U3
 TcJuSV1zK9I3W6QfVNx3z2/fe4ktSQScngr5ThhcliLG+EofKB4ThtScJBdsgtx5qtJ3 vg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38t9e7txc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 27 May 2021 17:32:32 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 17:32:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 27 May 2021 17:32:31 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2869D3F7040;
        Thu, 27 May 2021 17:32:31 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 14S0WUs3022744;
        Thu, 27 May 2021 17:32:30 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 14S0WUUS022743;
        Thu, 27 May 2021 17:32:30 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH] qedf: Update the max_id value in host structure.
Date:   Thu, 27 May 2021 17:32:06 -0700
Message-ID: <20210528003206.22709-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: NJiAQLsZA0rfU9s7wkEB_UNId235bG7S
X-Proofpoint-ORIG-GUID: NJiAQLsZA0rfU9s7wkEB_UNId235bG7S
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-27_13:2021-05-27,2021-05-27 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@cavium.com>

 - Update the max_id value in host structure.

Signed-off-by: Saurav Kashyap <saurav.kashyap@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index c5f37277..322046f4 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2089,6 +2089,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	vn_port->host->max_lun = qedf_max_lun;
 	vn_port->host->sg_tablesize = QEDF_MAX_BDS_PER_CMD;
 	vn_port->host->max_cmd_len = QEDF_MAX_CDB_LEN;
+	vn_port->host->max_id = QEDF_MAX_SESSIONS;
 
 	rc = scsi_add_host(vn_port->host, &vport->dev);
 	if (rc) {
@@ -3855,6 +3856,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 		host->transportt = qedf_fc_transport_template;
 		host->max_lun = qedf_max_lun;
 		host->max_cmd_len = QEDF_MAX_CDB_LEN;
+		host->max_id = QEDF_MAX_SESSIONS;
 #ifdef USE_BLK_MQ
 		host->use_blk_mq = qedf_use_blk_mq;
 		if (shost_use_blk_mq(host)) {
-- 
2.18.2

