Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE927C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A345B2071E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:45:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="J72ELQK5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgHYGpK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 02:45:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24374 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729076AbgHYGpJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 02:45:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07P6Tf6c009541
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:45:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=VnTVh/yU7PojCrNzzdukUrIOKyWn/xDt8nobcmBYgts=;
 b=J72ELQK5MP1V+oukcXtiWCieQiwdlOk6/2AdTuQ+x1rSHguOzm/LiBhyyj8ER6Q76U0f
 p7Q4BcokSxeBXftkT6q4Ywqu8MEkDORGVrm5cMOlm3vVwA9b0UTgFvDFiM4A7NhcVw4L
 rj2Qy9vWMOjPJkNvyk90H3Fyz5J1uH4DPrfjHbq/EG01aAxD9IHpR8lPOpSgZT8EVzSb
 oZNjQOlssO8JmbyBtkB7+Ht+aSVMM0cGRJ/fQgewQ0wGL2AH4jAPMTwkxOXCQX4szZGw
 xAiar1aHmSQtgQAZVO43704b3a27YD+uCSIheb4a8ItVGSXManXnVBFaM7ZVzep6+BY+ IA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3332vmtby5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:45:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Aug
 2020 23:45:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 Aug 2020 23:45:07 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B5E773F7043;
        Mon, 24 Aug 2020 23:45:06 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07P6j6tw016414;
        Mon, 24 Aug 2020 23:45:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07P6j6Sx016413;
        Mon, 24 Aug 2020 23:45:06 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/8] qedf: Correct the comment in qedf_initiate_els.
Date:   Mon, 24 Aug 2020 23:43:48 -0700
Message-ID: <20200825064354.16361-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200825064354.16361-1-jhasan@marvell.com>
References: <20200825064354.16361-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

 -Corrected the comment in qedf_initiate_els().

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_els.c b/drivers/scsi/qedf/qedf_els.c
index 6cb8c9b..625e58c 100644
--- a/drivers/scsi/qedf/qedf_els.c
+++ b/drivers/scsi/qedf/qedf_els.c
@@ -124,7 +124,7 @@ static int qedf_initiate_els(struct qedf_rport *fcport, unsigned int op,
 	task = qedf_get_task_mem(&qedf->tasks, xid);
 	qedf_init_mp_task(els_req, task, sqe);
 
-	/* Put timer on original I/O request */
+	/* Put timer on els request */
 	if (timer_msec)
 		qedf_cmd_timer_set(qedf, els_req, timer_msec);
 
-- 
1.8.3.1

