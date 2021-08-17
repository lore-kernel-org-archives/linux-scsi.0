Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD125C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8ADE60FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 05:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbhHQFOi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 01:14:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58766 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237763AbhHQFO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 01:14:26 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17H2m1BP006952
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=T+z5LjyzOpct1kqOk8a0LU12K7aL/fXOBQo76Il/z9s=;
 b=Z4erhVWUn6nE/HUz30RNFG8fAQQKFLoekZGoeyAyJtAcmSc3DjeRfX+uTXwHL1EVJjer
 K4r3brm6DCqs26arikVQTHqtpuqQNMWsH/kIs0ud2g/SVE15OViyL2H5PFFThpgxotUN
 udk8Pv3tiQhr5iFsrEc7+qjdM0e7GaEogvp7NPzl3GvVxZHGnp7oI58VGcFS0mycBQIc
 6emuTj2rCil9HZ/c18AXhFHZOGRAwzZDttjV4HA/KkBpAuRhISHfW8UsOaQmGdpxG0ri
 RYNpsl+uv17jOWFV85KSMwWuFw1NnNkU0fG88uZiyulxUqmN2/A/ySvQQyLztoj/SGej GA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3ag4n0rdcu-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 22:13:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 16 Aug
 2021 22:13:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 16 Aug 2021 22:13:51 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AC0EB3F70B1;
        Mon, 16 Aug 2021 22:13:51 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 17H5DpOF002548;
        Mon, 16 Aug 2021 22:13:51 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 17H5DpWr002547;
        Mon, 16 Aug 2021 22:13:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 09/12] qla2xxx: fix NVME retry
Date:   Mon, 16 Aug 2021 22:13:12 -0700
Message-ID: <20210817051315.2477-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210817051315.2477-1-njavali@marvell.com>
References: <20210817051315.2477-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: wWzwTXFl0Gf6Ffu6UQwiZvB4YNJrjMFh
X-Proofpoint-ORIG-GUID: wWzwTXFl0Gf6Ffu6UQwiZvB4YNJrjMFh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-17_01,2021-08-16_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

For target port that register itself as both FCP + NVME,
initiator driver will try to login one mode at a time. If the last
mode did not succeed, then driver will try the other mode.

When error is encountered, current code only flip to other mode
one time (NVME->FCP) and remain on the last mode.  Driver wrongly
assumed target port does not support PRLI NVME, instead it was
not ready to receive PRLI.

This patch will alternate back and forth on every PRLI failure
until login retry count has depleted or it is succeeded.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  9 ++++++--
 drivers/scsi/qla2xxx/qla_gs.c   |  8 +++++++
 drivers/scsi/qla2xxx/qla_init.c | 41 ++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_mbx.c  |  3 +++
 drivers/scsi/qla2xxx/qla_os.c   |  5 ++++
 5 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cb5bf2585cb7..be2eb75ee1a3 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2517,6 +2517,8 @@ typedef struct fc_port {
 	unsigned int n2n_flag:1;
 	unsigned int explicit_logout:1;
 	unsigned int prli_pend_timer:1;
+	unsigned int do_prli_nvme:1;
+
 	uint8_t nvme_flag;
 
 	uint8_t node_name[WWN_SIZE];
@@ -5351,9 +5353,12 @@ struct sff_8247_a0 {
 #define NVME_FCP_TARGET(fcport) \
 	(FCP_TYPE(fcport) && NVME_TYPE(fcport)) \
 
+#define NVME_PRIORITY(ha, fcport) \
+	(NVME_FCP_TARGET(fcport) && \
+	 (ha->fc4_type_priority == FC4_PRIORITY_NVME))
+
 #define NVME_TARGET(ha, fcport) \
-	((NVME_FCP_TARGET(fcport) && \
-	(ha->fc4_type_priority == FC4_PRIORITY_NVME)) || \
+	(fcport->do_prli_nvme || \
 	NVME_ONLY_TARGET(fcport)) \
 
 #define PRLI_PHASE(_cls) \
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index df6e3ef52e2c..ebc8fdb0b43d 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3504,6 +3504,14 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 			fcport->last_rscn_gen = fcport->rscn_gen;
 			fcport->fc4_type = rp->fc4type;
 			found = true;
+
+			if (fcport->scan_needed) {
+				if (NVME_PRIORITY(vha->hw, fcport))
+					fcport->do_prli_nvme = 1;
+				else
+					fcport->do_prli_nvme = 0;
+			}
+
 			/*
 			 * If device was not a fabric device before.
 			 */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 255f3a8884db..1e4e3e83b5c7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2000,6 +2000,7 @@ qla24xx_async_abort_command(srb_t *sp)
 static void
 qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 {
+	struct srb *sp;
 	WARN_ONCE(!qla2xxx_is_valid_mbs(ea->data[0]), "mbs: %#x\n",
 		  ea->data[0]);
 
@@ -2027,22 +2028,27 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			break;
 		}
 
+		sp = ea->sp;
 		ql_dbg(ql_dbg_disc, vha, 0x2118,
-		       "%s %d %8phC priority %s, fc4type %x\n",
+		       "%s %d %8phC priority %s, fc4type %x prev try %s\n",
 		       __func__, __LINE__, ea->fcport->port_name,
 		       vha->hw->fc4_type_priority == FC4_PRIORITY_FCP ?
-		       "FCP" : "NVMe", ea->fcport->fc4_type);
+		       "FCP" : "NVMe", ea->fcport->fc4_type,
+		       (sp->u.iocb_cmd.u.logio.flags & SRB_LOGIN_NVME_PRLI) ?
+			"NVME" : "FCP");
 
-		if (N2N_TOPO(vha->hw)) {
-			if (vha->hw->fc4_type_priority == FC4_PRIORITY_FCP) {
-				ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
-				ea->fcport->fc4_type |= FS_FC4TYPE_NVME;
-			} else {
-				ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
-				ea->fcport->fc4_type |= FS_FC4TYPE_FCP;
-			}
+		if (NVME_FCP_TARGET(ea->fcport)) {
+			if (sp->u.iocb_cmd.u.logio.flags & SRB_LOGIN_NVME_PRLI)
+				ea->fcport->do_prli_nvme = 0;
+			else
+				ea->fcport->do_prli_nvme = 1;
+		} else {
+			ea->fcport->do_prli_nvme = 0;
+		}
 
-			if (ea->fcport->n2n_link_reset_cnt < 3) {
+		if (N2N_TOPO(vha->hw)) {
+			if (ea->fcport->n2n_link_reset_cnt <
+			    vha->hw->login_retry_count) {
 				ea->fcport->n2n_link_reset_cnt++;
 				vha->relogin_jif = jiffies + 2 * HZ;
 				/*
@@ -2062,19 +2068,6 @@ qla24xx_handle_prli_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 			 * switch connect. login failed. Take connection down
 			 * and allow relogin to retrigger
 			 */
-			if (NVME_FCP_TARGET(ea->fcport)) {
-				ql_dbg(ql_dbg_disc, vha, 0x2118,
-				       "%s %d %8phC post %s prli\n",
-				       __func__, __LINE__,
-				       ea->fcport->port_name,
-				       (ea->fcport->fc4_type & FS_FC4TYPE_NVME)
-				       ? "NVMe" : "FCP");
-				if (vha->hw->fc4_type_priority == FC4_PRIORITY_NVME)
-					ea->fcport->fc4_type &= ~FS_FC4TYPE_NVME;
-				else
-					ea->fcport->fc4_type &= ~FS_FC4TYPE_FCP;
-			}
-
 			ea->fcport->flags &= ~FCF_ASYNC_SENT;
 			ea->fcport->keep_nport_handle = 0;
 			ea->fcport->logout_on_delete = 1;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index fcc219172aa9..438af0d55135 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4050,6 +4050,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 				fcport->n2n_flag = 1;
 				fcport->keep_nport_handle = 1;
 				fcport->login_retry = vha->hw->login_retry_count;
+				fcport->fc4_type = FS_FC4TYPE_FCP;
+				if (vha->flags.nvme_enabled)
+					fcport->fc4_type |= FS_FC4TYPE_NVME;
 
 				if (wwn_to_u64(vha->port_name) >
 				    wwn_to_u64(fcport->port_name)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bc8abe226fa6..064dbbeda0ee 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5184,6 +5184,11 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			    WWN_SIZE);
 
 			fcport->fc4_type = e->u.new_sess.fc4_type;
+			if (NVME_PRIORITY(vha->hw, fcport))
+				fcport->do_prli_nvme = 1;
+			else
+				fcport->do_prli_nvme = 0;
+
 			if (e->u.new_sess.fc4_type & FS_FCP_IS_N2N) {
 				fcport->dm_login_expire = jiffies +
 					QLA_N2N_WAIT_TIME * HZ;
-- 
2.23.1

