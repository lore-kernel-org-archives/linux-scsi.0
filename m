Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFB7C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:22:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C387D60724
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 10:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbhHEKW0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 06:22:26 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:15312 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240353AbhHEKWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 06:22:23 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175AC5f4010038
        for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2021 03:22:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=zSPgXOcPHG0DcqjCMH2PoWiIzfjB3/NkXs3UfvIZ4mk=;
 b=RsBfN5JRlbaRoMZYS14dE8mUKi5adWyzCHjm29T4QPd16JpJGTqvp/VBtQqBzQeOkdVJ
 228zIq/q3HBDkduoS/uAjWKXHI/5kc1A6NbdB04RALzn+//3F1Nz4lFbkDkPh8v0oq9f
 jzLHhfQDtrDcaNjITKmFd3jGdZIRfUfgMBdxKWxAdCCkjeeCnEK8aOKLTvs5syZ2go1+
 SZB/dJFSVcYstwkcWEcraXee8Ho5pzgG62EYnJeRu61TpoJlDn8BY1Zf7fgxnEvZaxWj
 FLt1qG7e3L04jVlRnW+GD4vXJJLJUnUAUnCZEnyxsT45bS1HbmlfORW8cdpJPUzbJwbZ pw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a8bkb8dqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 05 Aug 2021 03:22:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 5 Aug
 2021 03:22:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 5 Aug 2021 03:22:06 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B2CF63F7065;
        Thu,  5 Aug 2021 03:22:06 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 175AM6dt020250;
        Thu, 5 Aug 2021 03:22:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 175AM6Cq020249;
        Thu, 5 Aug 2021 03:22:06 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/14] qla2xxx: Changes to support FCP2 Target
Date:   Thu, 5 Aug 2021 03:19:55 -0700
Message-ID: <20210805102005.20183-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210805102005.20183-1-njavali@marvell.com>
References: <20210805102005.20183-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: qStWQu2jTUBb8437xAMFEjE4letZNyQ3
X-Proofpoint-ORIG-GUID: qStWQu2jTUBb8437xAMFEjE4letZNyQ3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-05_03:2021-08-05,2021-08-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Add changes to support FCP2 Target.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |  3 +--
 drivers/scsi/qla2xxx/qla_init.c |  6 ++++++
 drivers/scsi/qla2xxx/qla_os.c   | 11 +++++++++++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f2d05592c1e2..25549a8a2d72 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -12,8 +12,7 @@
  * ----------------------------------------------------------------------
  * | Module Init and Probe        |       0x0199       |                |
  * | Mailbox commands             |       0x1206       | 0x11a5-0x11ff	|
- * | Device Discovery             |       0x2134       | 0x210e-0x2116  |
- * |				  | 		       | 0x211a         |
+ * | Device Discovery             |       0x2134       | 0x210e-0x2115  |
  * |                              |                    | 0x211c-0x2128  |
  * |                              |                    | 0x212c-0x2134  |
  * | Queue Command and IO tracing |       0x3074       | 0x300b         |
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 24683ac1a620..be09dc4b3bf2 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1787,6 +1787,12 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 
 	fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 	if (fcport) {
+		if (fcport->flags & FCF_FCP2_DEVICE) {
+			ql_dbg(ql_dbg_disc, vha, 0x2115,
+			       "Delaying session delete for FCP2 portid=%06x "
+			       "%8phC ", fcport->d_id.b24, fcport->port_name);
+			return;
+		}
 		fcport->scan_needed = 1;
 		fcport->rscn_gen++;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 921bd4d127f4..61ae8cbba670 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3981,6 +3981,17 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
 	    "Mark all dev lost\n");
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (fcport->loop_id != FC_NO_LOOP_ID &&
+		    (fcport->flags & FCF_FCP2_DEVICE) &&
+		    fcport->port_type == FCT_TARGET &&
+		    !qla2x00_reset_active(vha)) {
+			ql_dbg(ql_dbg_disc, vha, 0x211a,
+			       "Delaying session delete for FCP2 flags 0x%x "
+			       "port_type = 0x%x port_id=%06x %phC", fcport->flags,
+			       fcport->port_type, fcport->d_id.b24,
+			       fcport->port_name);
+			continue;
+		}
 		fcport->scan_state = 0;
 		qlt_schedule_sess_for_deletion(fcport);
 	}
-- 
2.19.0.rc0

