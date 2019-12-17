Return-Path: <SRS0=0Ioj=2H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CA7C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6F6520716
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Dec 2019 22:07:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NVtrBEMt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfLQWHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Dec 2019 17:07:10 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27522 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbfLQWHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Dec 2019 17:07:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBHM5eEh030252;
        Tue, 17 Dec 2019 14:06:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=myrCvAL0vjkazFygDKfMQo0yT991RJiY/umxyNNQORQ=;
 b=NVtrBEMtfDLvDulKt2iUTMt8KzrUEJKtRE73Zm3gwCVqR7p9WCYLO+WMmSzeETVAjDJX
 Jko0Z8Q1kk8etEHXYD4DY9tbB/TbSUxXRCqOnsxIAhvdh5DckXLHOZWJT3PhuCaxl8WT
 4XDoDbc73RyjebQO6bCTB/wn2C2p9U8omCOpP7vs0wq5eLJwVK+YCuhCVQ7g3825TVUC
 +h7Su9SNavClr5qI3AFjd5YZ1yC0qp7LDScQTzrJ+8pbicLRN2JBOX+ADnEp8nHtMwcT
 ORZDCKTwx3HbHxWwJLV+c6UDWWvaM0IIGxQ9e6u9N/5pg+IC3ayQ/VJQ0VRM07oefvLJ +Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wxn0wm224-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 17 Dec 2019 14:06:56 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 17 Dec
 2019 14:06:30 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 17 Dec 2019 14:06:30 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D70033F703F;
        Tue, 17 Dec 2019 14:06:30 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xBHM6Uwh028143;
        Tue, 17 Dec 2019 14:06:30 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xBHM6Urs028134;
        Tue, 17 Dec 2019 14:06:30 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 04/14] qla2xxx: Cleanup unused async_logout_done
Date:   Tue, 17 Dec 2019 14:06:07 -0800
Message-ID: <20191217220617.28084-5-hmadhani@marvell.com>
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

From: Shyam Sundar <ssundar@marvell.com>

This patch removes unused qla2x00_async_logout_done
from the  code.

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  1 -
 drivers/scsi/qla2xxx/qla_gbl.h  |  4 ----
 drivers/scsi/qla2xxx/qla_init.c | 10 ----------
 drivers/scsi/qla2xxx/qla_os.c   |  5 -----
 4 files changed, 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 81362517b404..3b9ecdeecc8e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3277,7 +3277,6 @@ enum qla_work_type {
 	QLA_EVT_IDC_ACK,
 	QLA_EVT_ASYNC_LOGIN,
 	QLA_EVT_ASYNC_LOGOUT,
-	QLA_EVT_ASYNC_LOGOUT_DONE,
 	QLA_EVT_ASYNC_ADISC,
 	QLA_EVT_UEVENT,
 	QLA_EVT_AENFX,
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5098bb96aa2c..dec295f077d2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -72,8 +72,6 @@ extern int qla2x00_async_adisc(struct scsi_qla_host *, fc_port_t *,
 extern int qla2x00_async_tm_cmd(fc_port_t *, uint32_t, uint32_t, uint32_t);
 extern void qla2x00_async_login_done(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
-extern void qla2x00_async_logout_done(struct scsi_qla_host *, fc_port_t *,
-    uint16_t *);
 struct qla_work_evt *qla2x00_alloc_work(struct scsi_qla_host *,
     enum qla_work_type);
 extern int qla24xx_async_gnl(struct scsi_qla_host *, fc_port_t *);
@@ -183,8 +181,6 @@ extern int qla2x00_post_async_login_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_post_async_logout_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
-extern int qla2x00_post_async_logout_done_work(struct scsi_qla_host *,
-    fc_port_t *, uint16_t *);
 extern int qla2x00_post_async_adisc_work(struct scsi_qla_host *, fc_port_t *,
     uint16_t *);
 extern int qla2x00_post_async_adisc_done_work(struct scsi_qla_host *,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 73de5ada9bc9..f71c31350f1b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2059,16 +2059,6 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 	return;
 }
 
-void
-qla2x00_async_logout_done(struct scsi_qla_host *vha, fc_port_t *fcport,
-    uint16_t *data)
-{
-	qlt_logo_completion_handler(fcport, data[0]);
-	fcport->login_gen++;
-	fcport->flags &= ~FCF_ASYNC_ACTIVE;
-	return;
-}
-
 /****************************************************************************/
 /*                QLogic ISP2x00 Hardware Support Functions.                */
 /****************************************************************************/
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6b6fabed99e2..ec1637e09f94 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4942,7 +4942,6 @@ int qla2x00_post_async_##name##_work(		\
 
 qla2x00_post_async_work(login, QLA_EVT_ASYNC_LOGIN);
 qla2x00_post_async_work(logout, QLA_EVT_ASYNC_LOGOUT);
-qla2x00_post_async_work(logout_done, QLA_EVT_ASYNC_LOGOUT_DONE);
 qla2x00_post_async_work(adisc, QLA_EVT_ASYNC_ADISC);
 qla2x00_post_async_work(prlo, QLA_EVT_ASYNC_PRLO);
 qla2x00_post_async_work(prlo_done, QLA_EVT_ASYNC_PRLO_DONE);
@@ -5230,10 +5229,6 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 		case QLA_EVT_ASYNC_LOGOUT:
 			rc = qla2x00_async_logout(vha, e->u.logio.fcport);
 			break;
-		case QLA_EVT_ASYNC_LOGOUT_DONE:
-			qla2x00_async_logout_done(vha, e->u.logio.fcport,
-			    e->u.logio.data);
-			break;
 		case QLA_EVT_ASYNC_ADISC:
 			qla2x00_async_adisc(vha, e->u.logio.fcport,
 			    e->u.logio.data);
-- 
2.12.0

