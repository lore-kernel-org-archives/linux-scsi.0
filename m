Return-Path: <SRS0=2Tp4=EA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666E1C4363A
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241FA223BD
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Oct 2020 23:03:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aG2kVVZd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420397AbgJYXDk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 19:03:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40702 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1419475AbgJYXDh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Oct 2020 19:03:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PMxD8I149169;
        Sun, 25 Oct 2020 23:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=j0e80+39/vPLi7qwyAw/9GrLFt2fQ3NQre3X7U3tIBs=;
 b=aG2kVVZdz0dl79JIFgbhWDGhQMbCeECFQz28sgFhWceuLag48HF/qdoNOAjhMoY4XY3K
 jEfkazzMHpVt9s3JxBTTAKB44k/8e9zPvahSIBii2hwLmta0udbPLB35H+OR2FSfXS1x
 gez9k4whHAafhzP5wfCa/F6apSGeCtGnSa3+TmFehY/MKPF5H90xkHoGWAF+5gaAvZW2
 IBYfSE5+TJOFwi4eLARIi9gzSUG2ASojGnEY727zbyNULMGhy4JTgYRHKcyYyJL88lb7
 2OePi1Sdp7o1EFUOr1OB5H9+DpAcDkSgzAOnI5/hx43yvV68bA4d+4nBJHK5kPaKXs68 uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sajmmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 25 Oct 2020 23:03:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09PN0Ea4140643;
        Sun, 25 Oct 2020 23:03:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1p1t8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 25 Oct 2020 23:03:26 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09PN3PXa013501;
        Sun, 25 Oct 2020 23:03:25 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 25 Oct 2020 16:03:25 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 3/7] tcm qlaxx: move sess cmd list/lock to driver
Date:   Sun, 25 Oct 2020 18:03:14 -0500
Message-Id: <1603666998-8086-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=2 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010250174
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9785 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010250174
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Except for debug output in the shutdown path, tcm qla2xxx is the only
driver using the se_session sess_cmd_list. This moves the list to that
driver so in the next patches we can remove the sess_cmd_lock from the
main IO path for the rest of the drivers.

Cc: Nilesh Javali <njavali@marvell.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |  2 ++
 drivers/scsi/qla2xxx/qla_target.c  |  2 +-
 drivers/scsi/qla2xxx/qla_target.h  |  1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 47 +++++++++++++++++++++++---------------
 4 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a165120..b6284ad 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2484,6 +2484,8 @@ enum rscn_addr_format {
 	int generation;
 
 	struct se_session *se_sess;
+	struct list_head sess_cmd_list;
+	spinlock_t sess_cmd_lock;
 	struct kref sess_kref;
 	struct qla_tgt *tgt;
 	unsigned long expires;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5c417d3..6cb4348 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4366,7 +4366,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	cmd->trc_flags |= TRC_NEW_CMD;
 
 	spin_lock_irqsave(&vha->cmd_list_lock, flags);
-	list_add_tail(&cmd->cmd_list, &vha->qla_cmd_list);
+	list_add_tail(&cmd->sess_cmd_list, &vha->qla_cmd_list);
 	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
 
 	INIT_WORK(&cmd->work, qlt_do_work);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 1cff7c6..10e5e6c8 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -856,6 +856,7 @@ struct qla_tgt_cmd {
 	uint8_t cmd_type;
 	uint8_t pad[7];
 	struct se_cmd se_cmd;
+	struct list_head sess_cmd_list;
 	struct fc_port *sess;
 	struct qla_qpair *qpair;
 	uint32_t reset_count;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 4abf24c..076e0ab 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -255,6 +255,7 @@ static void tcm_qla2xxx_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 static void tcm_qla2xxx_complete_free(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
+	unsigned long flags;
 
 	cmd->cmd_in_wq = 0;
 
@@ -265,6 +266,10 @@ static void tcm_qla2xxx_complete_free(struct work_struct *work)
 	cmd->trc_flags |= TRC_CMD_FREE;
 	cmd->cmd_sent_to_fw = 0;
 
+	spin_lock_irqsave(&cmd->sess->sess_cmd_lock, flags);
+	list_del_init(&cmd->sess_cmd_list);
+	spin_unlock_irqrestore(&cmd->sess->sess_cmd_lock, flags);
+
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
 }
 
@@ -451,13 +456,14 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	struct se_portal_group *se_tpg;
 	struct tcm_qla2xxx_tpg *tpg;
 #endif
-	int flags = TARGET_SCF_ACK_KREF;
+	int target_flags = TARGET_SCF_ACK_KREF, ret;
+	unsigned long flags;
 
 	if (bidi)
-		flags |= TARGET_SCF_BIDI_OP;
+		target_flags |= TARGET_SCF_BIDI_OP;
 
 	if (se_cmd->cpuid != WORK_CPU_UNBOUND)
-		flags |= TARGET_SCF_USE_CPUID;
+		target_flags |= TARGET_SCF_USE_CPUID;
 
 	sess = cmd->sess;
 	if (!sess) {
@@ -479,11 +485,17 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 		return 0;
 	}
 #endif
-
 	cmd->qpair->tgt_counters.qla_core_sbt_cmd++;
-	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
+	ret = target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
 				cmd->unpacked_lun, data_length, fcp_task_attr,
-				data_dir, flags);
+				data_dir, target_flags);
+	if (!ret) {
+		spin_lock_irqsave(&sess->sess_cmd_lock, flags);
+		list_add_tail(&cmd->sess_cmd_list, &sess->sess_cmd_list);
+		spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
+	}
+
+	return ret;
 }
 
 static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
@@ -617,25 +629,20 @@ static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
 static struct qla_tgt_cmd *tcm_qla2xxx_find_cmd_by_tag(struct fc_port *sess,
     uint64_t tag)
 {
-	struct qla_tgt_cmd *cmd = NULL;
-	struct se_cmd *secmd;
+	struct qla_tgt_cmd *cmd;
 	unsigned long flags;
 
 	if (!sess->se_sess)
 		return NULL;
 
-	spin_lock_irqsave(&sess->se_sess->sess_cmd_lock, flags);
-	list_for_each_entry(secmd, &sess->se_sess->sess_cmd_list, se_cmd_list) {
-		/* skip task management functions, including tmr->task_cmd */
-		if (secmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-			continue;
-
-		if (secmd->tag == tag) {
-			cmd = container_of(secmd, struct qla_tgt_cmd, se_cmd);
-			break;
-		}
+	spin_lock_irqsave(&sess->sess_cmd_lock, flags);
+	list_for_each_entry(cmd, &sess->sess_cmd_list, sess_cmd_list) {
+		if (cmd->se_cmd.tag == tag)
+			goto done;
 	}
-	spin_unlock_irqrestore(&sess->se_sess->sess_cmd_lock, flags);
+	cmd = NULL;
+done:
+	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
 
 	return cmd;
 }
@@ -1426,6 +1433,8 @@ static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
 	uint16_t loop_id = qlat_sess->loop_id;
 	unsigned long flags;
 
+	INIT_LIST_HEAD(&qlat_sess->sess_cmd_list);
+	spin_lock_init(&qlat_sess->sess_cmd_lock);
 	/*
 	 * And now setup se_nacl and session pointers into HW lport internal
 	 * mappings for fabric S_ID and LOOP_ID.
-- 
1.8.3.1

