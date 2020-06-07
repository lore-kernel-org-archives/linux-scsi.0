Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64797C433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 19:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A41D2075A
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 19:58:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ajv2Dz2i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgFGT6r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 15:58:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44338 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgFGT6q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 15:58:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057Jrebn033288;
        Sun, 7 Jun 2020 19:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=mcwc6RjRN7FV46afRgBlKpqczvH2Px7GqWF1rZqAW2o=;
 b=ajv2Dz2i9PlJxpSHYJdgXLP7YAjcSxef6oheBGMUCRgI1XOm5gelOQVOrotFgC2cg+cQ
 7MTQyBYXSvtPcOEb0f9vsZcVw3QZScFaKeyuln0eG8iXxIO+Zh9UaRyvrUvMaC6zpnfc
 K+mAO9R+3Cu8QZB1sukkAuH5pmGyfyEbMnurYdXcxZvtYP9o07y67AhKi9eiuFZKm3Ys
 3xmr6JF8gMqQSQGYuKrlyHFV0Wjv4gXNlVgpZxUmO6lO3/e2uTI08etfgnmPUoEX6qyR
 bu5Ss6/YhcXnKQvHnRN4eEQBmFLmGbIwyHxi7ISZXE8f6WxEqQ3O5FCA0mzvEm9coAmu Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31g2jqv0r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 19:58:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057JvYHS087640;
        Sun, 7 Jun 2020 19:58:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31gn2u784h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 19:58:42 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057Jwfw9008216;
        Sun, 7 Jun 2020 19:58:41 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 12:58:41 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
Subject: [PATCH v4 2/4] target: initialize LUN in transport_init_se_cmd().
Date:   Sun,  7 Jun 2020 19:58:31 +0000
Message-Id: <1591559913-8388-3-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006070155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Initialization of orig_fe_lun is moved to transport_init_se_cmd() from
transport_lookup_cmd_lun(). This helps for the cases where the scsi request
fails before the call to transport_lookup_cmd_lun() so that
trace_target_cmd_complete() can print the LUN information to the trace
buffer. Due to this change, the lun parameter is removed from
transport_lookup_cmd_lun() and transport_lookup_tmr_lun().

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 11 +++++------
 drivers/target/target_core_device.c    | 19 ++++++++-----------
 drivers/target/target_core_tmr.c       |  4 ++--
 drivers/target/target_core_transport.c | 12 +++++++-----
 drivers/target/target_core_xcopy.c     |  4 ++--
 drivers/usb/gadget/function/f_tcm.c    |  6 ++++--
 include/target/target_core_fabric.h    |  6 +++---
 7 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 59379d662626..1b453629b516 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1158,7 +1158,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
 			conn->sess->se_sess, be32_to_cpu(hdr->data_length),
 			cmd->data_direction, sam_task_attr,
-			cmd->sense_buffer + 2);
+			cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -1167,8 +1167,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
-	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
-						     scsilun_to_int(&hdr->lun));
+	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd);
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
@@ -2000,7 +1999,8 @@ static enum tcm_tmreq_table iscsit_convert_tmf(u8 iscsi_tmf)
 
 	transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
 			      conn->sess->se_sess, 0, DMA_NONE,
-			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2);
+			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
+			      scsilun_to_int(&hdr->lun));
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
@@ -2038,8 +2038,7 @@ static enum tcm_tmreq_table iscsit_convert_tmf(u8 iscsi_tmf)
 	 * Locate the struct se_lun for all TMRs not related to ERL=2 TASK_REASSIGN
 	 */
 	if (function != ISCSI_TM_FUNC_TASK_REASSIGN) {
-		ret = transport_lookup_tmr_lun(&cmd->se_cmd,
-					       scsilun_to_int(&hdr->lun));
+		ret = transport_lookup_tmr_lun(&cmd->se_cmd);
 		if (ret < 0) {
 			se_tmr->response = ISCSI_TMF_RSP_NO_LUN;
 			goto attach;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 46b0e1ceb77f..405d82d44717 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -45,7 +45,7 @@
 struct se_device *g_lun0_dev;
 
 sense_reason_t
-transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
+transport_lookup_cmd_lun(struct se_cmd *se_cmd)
 {
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
@@ -54,7 +54,7 @@
 	sense_reason_t ret = TCM_NO_SENSE;
 
 	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	deve = target_nacl_find_deve(nacl, se_cmd->orig_fe_lun);
 	if (deve) {
 		atomic_long_inc(&deve->total_cmds);
 
@@ -74,7 +74,6 @@
 
 		se_cmd->se_lun = se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
-		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 		se_cmd->lun_ref_active = true;
 
@@ -83,7 +82,7 @@
 			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
 				" Access for 0x%08llx\n",
 				se_cmd->se_tfo->fabric_name,
-				unpacked_lun);
+				se_cmd->orig_fe_lun);
 			rcu_read_unlock();
 			ret = TCM_WRITE_PROTECTED;
 			goto ref_dev;
@@ -98,18 +97,17 @@
 		 * REPORT_LUNS, et al to be returned when no active
 		 * MappedLUN=0 exists for this Initiator Port.
 		 */
-		if (unpacked_lun != 0) {
+		if (se_cmd->orig_fe_lun != 0) {
 			pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
 				" Access for 0x%08llx from %s\n",
 				se_cmd->se_tfo->fabric_name,
-				unpacked_lun,
+				se_cmd->orig_fe_lun,
 				nacl->initiatorname);
 			return TCM_NON_EXISTENT_LUN;
 		}
 
 		se_lun = se_sess->se_tpg->tpg_virt_lun0;
 		se_cmd->se_lun = se_sess->se_tpg->tpg_virt_lun0;
-		se_cmd->orig_fe_lun = 0;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 
 		percpu_ref_get(&se_lun->lun_ref);
@@ -145,7 +143,7 @@
 }
 EXPORT_SYMBOL(transport_lookup_cmd_lun);
 
-int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
+int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 {
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
@@ -155,7 +153,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 	unsigned long flags;
 
 	rcu_read_lock();
-	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	deve = target_nacl_find_deve(nacl, se_cmd->orig_fe_lun);
 	if (deve) {
 		se_lun = rcu_dereference(deve->se_lun);
 
@@ -166,7 +164,6 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 
 		se_cmd->se_lun = se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
-		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 		se_cmd->lun_ref_active = true;
 	}
@@ -177,7 +174,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 		pr_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
 			" Access for 0x%08llx for %s\n",
 			se_cmd->se_tfo->fabric_name,
-			unpacked_lun,
+			se_cmd->orig_fe_lun,
 			nacl->initiatorname);
 		return -ENODEV;
 	}
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index afbd492c76a9..89c84d472cd7 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -148,8 +148,8 @@ void core_tmr_abort_task(
 		 * code.
 		 */
 		if (!tmr->tmr_dev)
-			WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd,
-						se_cmd->orig_fe_lun) < 0);
+			WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) <
+					0);
 
 		target_put_cmd_and_wait(se_cmd);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f2f7c5b818cc..7ea77933e64d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1364,7 +1364,7 @@ void transport_init_se_cmd(
 	u32 data_length,
 	int data_direction,
 	int task_attr,
-	unsigned char *sense_buffer)
+	unsigned char *sense_buffer, u64 unpacked_lun)
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
@@ -1383,6 +1383,7 @@ void transport_init_se_cmd(
 	cmd->data_direction = data_direction;
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
+	cmd->orig_fe_lun = unpacked_lun;
 
 	cmd->state_active = false;
 }
@@ -1596,7 +1597,8 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 * target_core_fabric_ops->queue_status() callback
 	 */
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-				data_length, data_dir, task_attr, sense);
+				data_length, data_dir, task_attr, sense,
+				unpacked_lun);
 
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
@@ -1622,7 +1624,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	/*
 	 * Locate se_lun pointer and attach it to struct se_cmd
 	 */
-	rc = transport_lookup_cmd_lun(se_cmd, unpacked_lun);
+	rc = transport_lookup_cmd_lun(se_cmd);
 	if (rc) {
 		transport_send_check_condition_and_sense(se_cmd, rc, 0);
 		target_put_sess_cmd(se_cmd);
@@ -1790,7 +1792,7 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			      0, DMA_NONE, TCM_SIMPLE_TAG, sense);
+			      0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
@@ -1818,7 +1820,7 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 			goto failure;
 	}
 
-	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
+	ret = transport_lookup_tmr_lun(se_cmd);
 	if (ret)
 		goto failure;
 
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index bd3ed6ce7571..5f1bab37a6bf 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -585,7 +585,7 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, src_sectors, length);
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
-			      DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0]);
+			      DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
 
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
@@ -630,7 +630,7 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, dst_sectors, length);
 
 	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
-			      DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0]);
+			      DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
 
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 36504931b2d1..ac049909a8bf 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1049,7 +1049,8 @@ static void usbg_cmd_work(struct work_struct *work)
 		transport_init_se_cmd(se_cmd,
 				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
-				cmd->prio_attr, cmd->sense_iu.sense);
+				cmd->prio_attr, cmd->sense_iu.sense,
+				cmd->unpacked_lun);
 		goto out;
 	}
 
@@ -1179,7 +1180,8 @@ static void bot_cmd_work(struct work_struct *work)
 		transport_init_se_cmd(se_cmd,
 				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
-				cmd->prio_attr, cmd->sense_iu.sense);
+				cmd->prio_attr, cmd->sense_iu.sense,
+				cmd->unpacked_lun);
 		goto out;
 	}
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 6a2bfcca0c98..92f6cb20775e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -150,8 +150,8 @@ void	transport_register_session(struct se_portal_group *,
 
 void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
-		struct se_session *, u32, int, int, unsigned char *);
-sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
+		struct se_session *, u32, int, int, unsigned char *, u64);
+sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
 sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
 sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
@@ -188,7 +188,7 @@ int	transport_send_check_condition_and_sense(struct se_cmd *,
 void	core_tmr_release_req(struct se_tmr_req *);
 int	transport_generic_handle_tmr(struct se_cmd *);
 void	transport_generic_request_failure(struct se_cmd *, sense_reason_t);
-int	transport_lookup_tmr_lun(struct se_cmd *, u64);
+int	transport_lookup_tmr_lun(struct se_cmd *);
 void	core_allocate_nexus_loss_ua(struct se_node_acl *acl);
 
 struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
-- 
1.8.3.1

