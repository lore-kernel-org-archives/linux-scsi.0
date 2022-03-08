Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721BEC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 08:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344984AbiCHIWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 03:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344963AbiCHIWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 03:22:08 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70093F336
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 00:21:10 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22881NID019263
        for <linux-scsi@vger.kernel.org>; Tue, 8 Mar 2022 00:21:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=TqUDQMyqkT6jEv2rF4y5UEMCjb3/kGaUhhXCyyFspC0=;
 b=kiWwYeuuSTjYTHFXP6m97Midh5yOa2LeXAMKJ/rHvJ9ZKM7EtWXhkyUpdekMYDvrYLD+
 AJ87yC7vpWiNd5pGeg4ilkacgcVcJVwKGLcNJCExii0xRIaaM88p3KufXp4Ta0na+ojv
 Yul7iW0KUtbIm4dnO0QpGAoO0MV5lfjGe/2bu/67pl1UvwoeJSA2+GYaFkcERSMMA/KF
 5McZ7m8AtKIRj+sQ4BUHQPiCdW+lSQ1L9TJUkZ+RwCJa9kSOOzh69Nyuxhe1I8RvBLKs
 0XluNakJHXGnvH1H3xrtOMEckz6/ulj8JNwAZ32DRi+tuu2kgF8Wt+UuvR0A1xaaQqp1 FQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38p838b-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 08 Mar 2022 00:21:09 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Mar
 2022 00:21:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Mar 2022 00:21:06 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 178525B692E;
        Tue,  8 Mar 2022 00:21:06 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 2288L50m009837;
        Tue, 8 Mar 2022 00:21:05 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 2288L5mW009836;
        Tue, 8 Mar 2022 00:21:05 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/13] qla2xxx: Fix hang due to session stuck
Date:   Tue, 8 Mar 2022 00:20:42 -0800
Message-ID: <20220308082048.9774-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220308082048.9774-1-njavali@marvell.com>
References: <20220308082048.9774-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: yEbOd8jI35AXqzCvZzk_ifwqhLwqK7hA
X-Proofpoint-ORIG-GUID: yEbOd8jI35AXqzCvZzk_ifwqhLwqK7hA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-08_03,2022-03-04_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

User experience device lost. The log shows Get port data base
command was queued up, failed, and requeued again. Every time
it is requeued, it set the FCF_ASYNC_ACTIVE. This prevents any
recovery code from occurring because driver thinks a recovery is in
progress for this session. In essence, this session is hung.
The reason it gets into this place is the session deletion got
in front of this call due to link perturbation.

Break the requeue cycle and exit.
The session deletion code will trigger a session relogin.

Cc: stable@vger.kernel.org
Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  4 ++++
 drivers/scsi/qla2xxx/qla_init.c | 19 +++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 47d7fa1c7ae8..b0579bce5b88 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5437,4 +5437,8 @@ struct ql_vnd_tgt_stats_resp {
 #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
+
+#define SESSION_DELETE(_fcport) (_fcport->disc_state == DSC_DELETE_PEND || \
+				 _fcport->disc_state == DSC_DELETED)
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6ffe44b805b6..3c58a2911937 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -575,6 +575,14 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 	struct srb_iocb *lio;
 	int rval = QLA_FUNCTION_FAILED;
 
+	if (SESSION_DELETE(fcport)) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		       "%s: %8phC is being delete - not sending command.\n",
+		       __func__, fcport->port_name);
+		fcport->flags &= ~FCF_ASYNC_ACTIVE;
+		return rval;
+	}
+
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
@@ -1338,8 +1346,15 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	struct port_database_24xx *pd;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT) ||
-	    fcport->loop_id == FC_NO_LOOP_ID) {
+	if (SESSION_DELETE(fcport)) {
+		ql_log(ql_log_warn, vha, 0xffff,
+		       "%s: %8phC is being delete - not sending command.\n",
+		       __func__, fcport->port_name);
+		fcport->flags &= ~FCF_ASYNC_ACTIVE;
+		return rval;
+	}
+
+	if (!vha->flags.online || fcport->flags & FCF_ASYNC_SENT) {
 		ql_log(ql_log_warn, vha, 0xffff,
 		    "%s: %8phC online %d flags %x - not sending command.\n",
 		    __func__, fcport->port_name, vha->flags.online, fcport->flags);
-- 
2.19.0.rc0

