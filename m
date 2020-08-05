Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A0DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCFD522CB3
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:47:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="kfCrLGV6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgHEEru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 00:47:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28930 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbgHEEru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 00:47:50 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0754ll2A007044
        for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2020 21:47:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=HSrhICL+l6PibeSHcC7kpM/iAyeIK7hXRPn8BAVe3Ws=;
 b=kfCrLGV65N/C6TO62BwbdM1YjNmIVmsbHdUUlHGzvHEhFY06cZ8xYG39W4H5F53FMDDo
 cUUrzD7ZiVavDCgBDJ6c7GzOoFXr+jAY2j1yEzK3w5RQml3VkE7qB0pPhmW20n16nC/K
 lpnHN0MUjZhCKRa+rh7fihPCxC8Wsus77sLVNxNoW5KGgHc/0oGZ3GFOp3FGicrV/k5b
 fzfYaoeo9nej5rfZygvcSyv0ej/qltPR++EOc0ODvM/fe/weZjrU+7CRZSUA851GGaUS
 2wqHTOoayyK5DcsJjYtVC5EoWwwrHwUgh8asuSXPG+Y5yMBhPk4ych5dRu8OYEBU1MDD gg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8fex8j0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 21:47:49 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:47:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Aug 2020 21:47:40 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 268EC3F703F;
        Tue,  4 Aug 2020 21:47:40 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0754leWg030644;
        Tue, 4 Aug 2020 21:47:40 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0754ldCH030635;
        Tue, 4 Aug 2020 21:47:39 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 08/10] qla2xxx: Check if FW supports MQ before enabling
Date:   Tue, 4 Aug 2020 21:44:00 -0700
Message-ID: <20200805044402.30543-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200805044402.30543-1-njavali@marvell.com>
References: <20200805044402.30543-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_03:2020-08-03,2020-08-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

OS boot during Boot from SAN was stuck at dracut emergency shell
after enabling nvme driver parameter. For non MQ support the driver
was enabling MQ. Add a check to confirm if FW supports MQ.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9b59f032a569..fda812b9b564 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2017,6 +2017,11 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
 	/* Determine queue resources */
 	ha->max_req_queues = ha->max_rsp_queues = 1;
 	ha->msix_count = QLA_BASE_VECTORS;
+
+	/* Check if FW supports MQ or not */
+	if (!(ha->fw_attributes & BIT_6))
+		goto mqiobase_exit;
+
 	if (!ql2xmqsupport || !ql2xnvmeenable ||
 	    (!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
 		goto mqiobase_exit;
-- 
2.19.0.rc0

