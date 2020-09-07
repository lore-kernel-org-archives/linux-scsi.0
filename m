Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B2DC2BB84
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 17:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D92206E7
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 17:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IS9CbZVV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgIGRtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 13:49:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20024 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729211AbgIGMQC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 08:16:02 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087C58XV027366
        for <linux-scsi@vger.kernel.org>; Mon, 7 Sep 2020 05:15:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=8YkRep2lAGMOCH7N2ZCB7QzcP3vhWfcsTxi/5W1hgUI=;
 b=IS9CbZVVf+rpQTyb9LYim/tgVedgY9WhYJKCB97B+3O+58h0V6fmZ3yM7HOZMD7NOOuF
 0I7/tcCH2UMXvi5x5BVN0vdpgKx+IY5nqYskcv9CbCptkANTQNn6wuz8K/Kcn3M4D8ON
 DpNEIcYQ+fAjebwOeTTvdIIH1Q7sFBmwUKrNMKJP7arLBUOLjr3AQb9SreiBfQaT5I2D
 UvabJGaXrsRh3RAsMN5yPeMjBPqmjY/GaxYJ7OYduzL72C2nVzKun+VILNuC3X8GK3z7
 QYBD/lNHchAS4msNbRiu0NB0ZSMT1Z6XvIUpi8eTy1DE9nGxT02x+3BuK9ags3mqA88a IA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pqv0x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2020 05:15:57 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:15:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 05:15:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2CFF23F703F;
        Mon,  7 Sep 2020 05:15:56 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 087CFuUo005210;
        Mon, 7 Sep 2020 05:15:56 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 087CFuJe005201;
        Mon, 7 Sep 2020 05:15:56 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 2/8] qedf: Correct the comment in qedf_initiate_els
Date:   Mon, 7 Sep 2020 05:14:37 -0700
Message-ID: <20200907121443.5150-3-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200907121443.5150-1-jhasan@marvell.com>
References: <20200907121443.5150-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_06:2020-09-07,2020-09-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

 Correction of the comment in qedf_initiate_els().
 Comment was misleading, hence corrected it.

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

