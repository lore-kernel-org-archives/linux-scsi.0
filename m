Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7122CC43334
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbiFHL7D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238411AbiFHL67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:58:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A503B1737DF
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:58:58 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2587SoaC013216
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:58:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=NutlbQgXdjMJytU1iXryHSxrLgiP1HO81OoP+AOrDFI=;
 b=DNmypFpFfUTLxVeTQbaWHN0mTddqY1HNedvSyswrP0xvKdQ8GJ3+P5M1FIR7+uFA1IPH
 Kew7RKEn/O6h0CSIZyGsLoMATivBOe2mpQ3DQDbUO4h1S388mBVaHYgKvkFwJ1c3XCdZ
 JaV34FEYvBlEhZvH9M2Tx78EaefFb0vnNognuDHyYTJNArqpW2O+5cJ8aBu94yeiEmTa
 Ncc8bVbwwuh0o4TL9N0tgUzGM7AEcLT7SuIatRJUtxX9FojswcPD3fcuV9/njuqk9Ukl
 w/+7yH1cPuiJCRH6iePH6G2UAfH9eAXXT+uqI4r9y+QuuCT+DiU92jkGsgvymcxjHBvN bQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3gjqdps05t-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:58:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 8 Jun
 2022 04:58:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 5B4543F708C;
        Wed,  8 Jun 2022 04:58:56 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/10] qla2xxx: edif: fix session thrash
Date:   Wed, 8 Jun 2022 04:58:45 -0700
Message-ID: <20220608115849.16693-7-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: B6IM4GgjmTtOlE5h3fXo29Hj6q8L5u3o
X-Proofpoint-GUID: B6IM4GgjmTtOlE5h3fXo29Hj6q8L5u3o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Current code prematurely sends out prli before authentication application
has given the ok to do it. This cause prli failure and session tear down.
This patch prevents prli from going out before authentication
app gives the ok.

Fixes: 91f6f5fbe87b ("scsi: qla2xxx: edif: Reduce connection thrash")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_edif.c |  2 +-
 drivers/scsi/qla2xxx/qla_edif.h |  4 ++++
 drivers/scsi/qla2xxx/qla_init.c | 10 +++++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index dd3593333d7b..5ada36acf129 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -3517,7 +3517,7 @@ int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
 	if (qla_bsg_check(vha, bsg_job, fcport))
 		return 0;
 
-	if (fcport->loop_id == FC_NO_LOOP_ID) {
+	if (EDIF_SESS_DELETE(fcport)) {
 		ql_dbg(ql_dbg_edif, vha, 0x910d,
 		    "%s ELS code %x, no loop id.\n", __func__,
 		    bsg_request->rqst_data.r_els.els_code);
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
index 3561e22b8f0f..7cdb89ccdc6e 100644
--- a/drivers/scsi/qla2xxx/qla_edif.h
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -141,4 +141,8 @@ struct enode {
 	(DBELL_ACTIVE(_fcport->vha) && \
 	 (_fcport->disc_state == DSC_LOGIN_AUTH_PEND))
 
+#define EDIF_SESS_DELETE(_s) \
+	(qla_ini_mode_enabled(_s->vha) && (_s->disc_state == DSC_DELETE_PEND || \
+	 _s->disc_state == DSC_DELETED))
+
 #endif	/* __QLA_EDIF_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d915c1f85fa2..6070834104f6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1762,8 +1762,16 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		break;
 
 	case DSC_LOGIN_PEND:
-		if (fcport->fw_login_state == DSC_LS_PLOGI_COMP)
+		if (vha->hw->flags.edif_enabled)
+			break;
+
+		if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
+			ql_dbg(ql_dbg_disc, vha, 0x2118,
+			       "%s %d %8phC post %s PRLI\n",
+			       __func__, __LINE__, fcport->port_name,
+			       NVME_TARGET(vha->hw, fcport) ? "NVME" : "FC");
 			qla24xx_post_prli_work(vha, fcport);
+		}
 		break;
 
 	case DSC_UPD_FCPORT:
-- 
2.19.0.rc0

