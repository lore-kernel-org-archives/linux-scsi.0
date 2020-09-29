Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53CDC4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:24:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B92D208FE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hTYafGAN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725776AbgI2KYT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:24:19 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15388 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725372AbgI2KYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 06:24:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TAKrlk011303
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:24:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=asQ6Wvz7l4H8lZQDG0F8MmYG8JOKHY7wrP+xJIlxEVk=;
 b=hTYafGAN55g6aV0dpCeWIlBQh5d6IxnsQS3BBSe8cv+W6Ka6hSbRg3fuBoCozegq1d+S
 GcXZxO2npB96MyqQWpNhoVHdemvaCkmdzMeFqdjQEtPvZor2kAyiPvOxkbxl8rOvTse+
 +HoQxBvAC9FNE9SMMNwd49ItoG0RBpBiqcbYTwI0lwaFNd2XJV9wcHh4Uxflb9V606CZ
 7aC3pm/05y91P9gLpAYLale5iCUVn7/HSIJ1sowPeSrN04Yw5FWVJ3NUEfdX6GcFvh/n
 g/wmNEZsIE6VyGQrnnicrS4lr43iHzyfdqCEK8CEXY9Qh01pt7YgSsgkxOh2JFpsDiPf 9g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 33teembdec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:24:18 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 03:24:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 03:24:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 03:24:17 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0FADA3F7048;
        Tue, 29 Sep 2020 03:24:17 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08TAOGfv032349;
        Tue, 29 Sep 2020 03:24:16 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08TAOGEh032348;
        Tue, 29 Sep 2020 03:24:16 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 5/7] qla2xxx: fix crash on session cleanup with unload
Date:   Tue, 29 Sep 2020 03:21:50 -0700
Message-ID: <20200929102152.32278-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200929102152.32278-1-njavali@marvell.com>
References: <20200929102152.32278-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On unload, session cleanup prematurely gave the signal for driver
unload path to advance.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

