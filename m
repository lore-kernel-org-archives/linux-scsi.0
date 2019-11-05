Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66518C5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39A6F21929
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="mp+1iw5c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389174AbfKEPHY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:07:24 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4554 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389083AbfKEPHX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:07:23 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA5F0S2P015378;
        Tue, 5 Nov 2019 07:07:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=6l2z+lmSC8lPuQQnXVdmh9YYsQGWKr70ZpfmVXnLeCU=;
 b=mp+1iw5cPAoEd5evDuvrLfkzoDqLhpp3LCnvDvx74t9+cVfwUDeqVgp6GKOmkGb6IK6n
 Jj/5b6KWpRZxQpGm2iSBMy/psrvsmsxGiVZMak+xkXOBCDo2RC80YoCWf2UHphwkA2+N
 qbvq49J62bt3/1mt7C0E50lRo602xzOpngalA+ylm/zJAfA4+KQOvHrLIgM+Ma4xTGqf
 v0K5+PbzVVE0DHLB9ro2xrKSyp+qu//swhrb6DQM3F/KDo9mNtP8/Q2qk0O+JdJVXBB5
 O7BRCXkCmj7DN/7dPTWOcnJSKISEuXXnQHEQhk5H2gbcGfqHNSBuIatsjxDUHayUUJvO Tg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2w19amtrkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Nov 2019 07:07:21 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 5 Nov
 2019 07:07:19 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 5 Nov 2019 07:07:19 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A7B9C3F7040;
        Tue,  5 Nov 2019 07:07:19 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id xA5F7JPe008163;
        Tue, 5 Nov 2019 07:07:19 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id xA5F7JNA008162;
        Tue, 5 Nov 2019 07:07:19 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 7/8] qla2xxx: Fix device connect issues in P2P configuration
Date:   Tue, 5 Nov 2019 07:06:56 -0800
Message-ID: <20191105150657.8092-8-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191105150657.8092-1-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-05_05:2019-11-05,2019-11-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

P2P need to take the alternate plogi route.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  | 1 +
 drivers/scsi/qla2xxx/qla_init.c | 9 +++++++++
 drivers/scsi/qla2xxx/qla_iocb.c | 5 ++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index d11416dcee4e..5b163ad85c34 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -917,4 +917,5 @@ int qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode);
 
 /* nvme.c */
 void qla_nvme_unregister_remote_port(struct fc_port *fcport);
+void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index ff4528702b4e..6bb4ddd90b6e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1717,6 +1717,15 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 	qla24xx_fcport_handle_login(vha, fcport);
 }
 
+void qla_handle_els_plogi_done(scsi_qla_host_t *vha,
+				      struct event_arg *ea)
+{
+	ql_dbg(ql_dbg_disc, vha, 0x2118,
+	    "%s %d %8phC post PRLI\n",
+	    __func__, __LINE__, ea->fcport->port_name);
+	qla24xx_post_prli_work(vha, ea->fcport);
+}
+
 /*
  * RSCN(s) came in for this fcport, but the RSCN(s) was not able
  * to be consumed by the fcport
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 2b675da34bda..b25f87ff8cde 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2760,9 +2760,8 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 		case CS_COMPLETE:
 			memset(&ea, 0, sizeof(ea));
 			ea.fcport = fcport;
-			ea.data[0] = MBS_COMMAND_COMPLETE;
-			ea.sp = sp;
-			qla24xx_handle_plogi_done_event(vha, &ea);
+			ea.rc = res;
+			qla_handle_els_plogi_done(vha, &ea);
 			break;
 
 		case CS_IOCB_ERROR:
-- 
2.12.0

