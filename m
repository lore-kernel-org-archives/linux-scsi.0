Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A933CC4BA2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78F4720658
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:41:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cgdDNaFU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgBZWlF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:41:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16878 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727887AbgBZWlF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:41:05 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMVS63003759;
        Wed, 26 Feb 2020 14:41:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=zvmclC3GnNbMV4NaGakMZKGzUm5O9RIGuzHln/SWj4A=;
 b=cgdDNaFURImGPLhnzxWIhKwKLhVO2HmFIgqIaJZMxLVuTCD42FUvTw0lDua144fMrPed
 1VCXmPh2f0lU1fJv5qWDb0lZMmeayTkTUXU+9YA/c6OKNb1F6H1eB3rDb59bJruu8tgb
 f5Z5tlnFIslAplKLuK7dt4m17dOVDs/4c1uChzxQ7+BjEtIdJ5SIrYQ0SjqK+d8huQtE
 wafmHYmKe4uKLjSEA2aXctpMWcBbAYg2mRwcaJPhVxnhTPm/nEvBOdG03DtZGlolwFsR
 MxhLTJHuURf6Mffu8YUnlLU5gIRWwNyGDiOYy85GGNhueP8FHvjSV401UgOHHyJsImS7 oQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ydcm15b97-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:41:03 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:41:02 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:41:01 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id EAD4C3F7041;
        Wed, 26 Feb 2020 14:41:01 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMf1fM024613;
        Wed, 26 Feb 2020 14:41:01 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMf17p024612;
        Wed, 26 Feb 2020 14:41:01 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 13/18] qla2xxx: Fix NPIV instantiation after FW dump
Date:   Wed, 26 Feb 2020 14:40:17 -0800
Message-ID: <20200226224022.24518-14-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200226224022.24518-1-hmadhani@marvell.com>
References: <20200226224022.24518-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

NPIV re-enable code was block after FW has been initialized.
The blocking check was too broad. The patch reduce the check
down to make sure if FW is initialized or not.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ca5eb518927b..bd13b0d3cfea 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1388,7 +1388,7 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 
-	if (qla2x00_chip_is_down(vha))
+	if (!vha->hw->flags.fw_started)
 		return QLA_INVALID_COMMAND;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1038,
-- 
2.12.0

