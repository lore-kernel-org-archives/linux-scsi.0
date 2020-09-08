Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E29A1C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABE7421897
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 05:27:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AX6T0pyL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgIHF1K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 01:27:10 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54262 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728516AbgIHF1J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 01:27:09 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0885P5Mp023578;
        Mon, 7 Sep 2020 22:27:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zDviW05fqJeHHUhQzDHiw0QT8l1FpHJPqkIHBDOEOZk=;
 b=AX6T0pyLqoknwrFvitGSJzpG4G6+FfKN84FCOxTxB8JCy8juqjoLnmCiLtau8sVQPCbW
 7pS5yiEfxQFfv26QSN5VamDQqDo5lFJZ53sfUyX6o0OZUjZrRuTRcl9XkGsds+ndymjW
 RqlW1dZsC3kTkbnPosIdIBxem8WgEDMqgNc60ywpAdiOoGxLBdmuWPc1rb/5IxcnDkZD
 hBE3qmJs1EvM8J+7ARXkynFOO0D3FAjjAFVn50nXMJQMngriUSubDGGIst3W5kOK4l5z
 C/yA6DurB79wj4c5Cj/UWQif6fVLW+CUfmCZUzqW6FoXfW1xwUqF1DMb3kABWh5EuhKG Pw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33c81pt6dy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 22:27:02 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 22:27:01 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 22:27:01 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 22:27:01 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5C70B3F703F;
        Mon,  7 Sep 2020 22:27:01 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0885R1nG022001;
        Mon, 7 Sep 2020 22:27:01 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0885R1Q0021992;
        Mon, 7 Sep 2020 22:27:01 -0700
From:   Manish Rangankar <mrangankar@marvell.com>
To:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 6/8] qedi: Mark all connections for recovery on link down event
Date:   Mon, 7 Sep 2020 22:24:10 -0700
Message-ID: <20200908052412.21917-7-mrangankar@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200908052412.21917-1-mrangankar@marvell.com>
References: <20200908052412.21917-1-mrangankar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_02:2020-09-07,2020-09-08 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Nilesh Javali <njavali@marvell.com>

  For short time cable pulls, the in-flight i/o to the FW,
is never cleaned up, resulting in the behaviour of stale i/o
completion causing list_del corruption and soft lockup of the
system. So, on link down event, mark all the connections for
recovery, causing cleanup of all the in-flight i/o immediately.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
---
 drivers/scsi/qedi/qedi_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 2db99613b8a9..4f43e2a24b50 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1127,6 +1127,15 @@ static void qedi_schedule_recovery_handler(void *dev)
 	schedule_delayed_work(&qedi->recovery_work, 0);
 }
 
+static void qedi_set_conn_recovery(struct iscsi_cls_session *cls_session)
+{
+	struct iscsi_session *session = cls_session->dd_data;
+	struct iscsi_conn *conn = session->leadconn;
+	struct qedi_conn *qedi_conn = conn->dd_data;
+
+	qedi_start_conn_recovery(qedi_conn->qedi, qedi_conn);
+}
+
 static void qedi_link_update(void *dev, struct qed_link_output *link)
 {
 	struct qedi_ctx *qedi = (struct qedi_ctx *)dev;
@@ -1138,6 +1147,7 @@ static void qedi_link_update(void *dev, struct qed_link_output *link)
 		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
 			  "Link Down event.\n");
 		atomic_set(&qedi->link_state, QEDI_LINK_DOWN);
+		iscsi_host_for_each_session(qedi->shost, qedi_set_conn_recovery);
 	}
 }
 
-- 
2.25.0

