Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AEFC2D0A8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5334720809
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="exhO9MML"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgI1Fwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 01:52:50 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60178 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725287AbgI1Fwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 01:52:49 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S5onqO007767
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:52:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=2fVsC3l7l9u6rd0/zzvtQoft92wai9N5voHHnvphUSc=;
 b=exhO9MMLQQLa/Yg1jM3zFSBTkLnnVKACj8W1yZRia9H+4xC8P5I2HYWNuh+R4Cux4a19
 DcRNOtq67eJ3qMR1o7kUQrR9CnJLy8wcKPr+mpUZRJ9VLA4TWIUshdlF+nakMmrRDggg
 +WOs2AhmPjnOmc4CRCddPsLqPhyc5HW3581HOvxafKsOmjFtMIjc4k+aZEEqkmPw6IQ0
 ctgxwplala2rUtB4u0g9jk0ZO9rw4vjrA0pb2rE5fZTDZHqia7lT3oICS6zdHlTcFh6X
 6iqgIzEuu662lXkmqnHdne9UWOyh/pZqVcsaUz9kci4ot2G5RG/lozhQz3PYidqgSN7c JQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teem5sj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:52:49 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Sep
 2020 22:52:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 27 Sep 2020 22:52:48 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8E9543F703F;
        Sun, 27 Sep 2020 22:52:48 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08S5qmK0004029;
        Sun, 27 Sep 2020 22:52:48 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08S5qmwc004020;
        Sun, 27 Sep 2020 22:52:48 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 5/7] qla2xxx: fix crash on session cleanup with unload
Date:   Sun, 27 Sep 2020 22:50:21 -0700
Message-ID: <20200928055023.3950-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200928055023.3950-1-njavali@marvell.com>
References: <20200928055023.3950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_05:2020-09-24,2020-09-28 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On unload, session cleanup prematurely gave the signal for driver
unload path to advance.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 7711f95033c0..2a0d3c85766a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1231,14 +1231,15 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	case DSC_DELETE_PEND:
 		return;
 	case DSC_DELETED:
-		if (tgt && tgt->tgt_stop && (tgt->sess_count == 0))
-			wake_up_all(&tgt->waitQ);
-		if (sess->vha->fcport_count == 0)
-			wake_up_all(&sess->vha->fcport_waitQ);
-
 		if (!sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] &&
-			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT])
+			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT]) {
+			if (tgt && tgt->tgt_stop && tgt->sess_count == 0)
+				wake_up_all(&tgt->waitQ);
+
+			if (sess->vha->fcport_count == 0)
+				wake_up_all(&sess->vha->fcport_waitQ);
 			return;
+		}
 		break;
 	case DSC_UPD_FCPORT:
 		/*
-- 
2.19.0.rc0

