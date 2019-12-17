Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87649C2D0BF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C20A21582
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:09:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="rU1C3gvd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfLQWJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:09:10 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21646 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbfLQWJK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:09:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5aBp029957;
        Tue, 17 Dec 2019 14:07:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=TSvPLx7kcuUEquZStjqBJ1ehPGygOYm5QG5R1mgB84w=;
 b=rU1C3gvd9MWfVkFYYG0alJpIBwISxZa/k+GlopmZlDizB/D9gC79DwNQwqgQ5lUHn0cu
 6hMBX5EuTE6fMRza91p+Wk1Su2w9depU6iTd8cMSrB20DdJKAQTUjeutP/Ovjz619MfE
 uWOgCXb2kkAzx7EBWRth7JIXLKaVSSPMsHeAo5mNlpfcUFT7XmgU5fyCV6nRW5dsJaO2
 CVM302Jd1/HtFStwsyF8Sbe5dOYe14B2HOTiBpaj/GFr6rXNN1kVJ+frlBqFy2mWGYBh
 Fhq4i0zKm+U1rSgYqROjBNWEF8lzzCmxdAua62QPZtSq2blWkpA+WEYub5KY6ror+VQe NA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm22h-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:07:09 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:34 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:34 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 339163F703F;
        Tue, 17 Dec 2019 14:06:34 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6YxV028147;
        Tue, 17 Dec 2019 14:06:34 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6YmD028146;
        Tue, 17 Dec 2019 14:06:34 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 05/14] qla2xxx: Fix update_fcport for current_topology
Date:   Tue, 17 Dec 2019 14:06:08 -0800
Message-ID: <20191217220617.28084-6-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191217220617.28084-1-hmadhani@marvell.com>
References: <20191217220617.28084-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_04:2019-12-17,2019-12-17 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

logout_on_delete flag should not be set if the topology
is Loop. This patch fixes unintentional logout during
loop topology.

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f71c31350f1b..dd59bd30badd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5384,7 +5384,10 @@ qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	fcport->login_retry = vha->hw->login_retry_count;
 	fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 	fcport->deleted = 0;
-	fcport->logout_on_delete = 1;
+	if (vha->hw->current_topology == ISP_CFG_NL)
+		fcport->logout_on_delete = 0;
+	else
+		fcport->logout_on_delete = 1;
 	fcport->n2n_chip_reset = fcport->n2n_link_reset_cnt = 0;
 
 	switch (vha->hw->current_topology) {
-- 
2.12.0

