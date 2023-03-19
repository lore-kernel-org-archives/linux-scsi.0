Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F6CC761AF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Mar 2023 01:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCSB4i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Mar 2023 21:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjCSB4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Mar 2023 21:56:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911A623114;
        Sat, 18 Mar 2023 18:56:32 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32INTQEA029524;
        Sun, 19 Mar 2023 01:56:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=keuCnTYWfNUQYorkCDlFE6ZRa5IfkVBfsJkrKx+DgJI=;
 b=iMrNQTQNvuLtWMpTnXl66jbZIFE2UjXjq+2FbxL1CABVHnmqejVYZrKWkrYpXXrsA8vX
 wF1etYzgx2tocxPl+Fn/YndSaUa4LONvwSTKOVsOB3KwGLNXt311PRtg1HHUzOuwbxd3
 P5rPCci5HVfrOwdz3PLD799tS3H9d8DEzGTiVhAZTGRpOtaojeCMf5hscitJ+Z4QDoQu
 JLPWO2ukeLotYLkn5sP65vAGqycdpO12mI75SbsH4kHFrhdSZWjwiZpVkxkHXUgCqKq1
 AbtlFjQ/CsBzDhqnNO88Vx2aVYxUC74VspZMofZfoLfn06SSTPB3gz40lqAWbR91lekz nA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd3qdh3kt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32IN2RhV030974;
        Sun, 19 Mar 2023 01:56:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3raaucn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 19 Mar 2023 01:56:29 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32J1uO5K014254;
        Sun, 19 Mar 2023 01:56:29 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-118-173.vpn.oracle.com [10.154.118.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pd3raauaw-4;
        Sun, 19 Mar 2023 01:56:29 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     mlombard@redhat.com, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 3/9] scsi: target: Pass in cmd counter to use during cmd setup
Date:   Sat, 18 Mar 2023 20:56:14 -0500
Message-Id: <20230319015620.96006-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230319015620.96006-1-michael.christie@oracle.com>
References: <20230319015620.96006-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-18_16,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303190014
X-Proofpoint-GUID: qHFboD-Sh_-jcvzsP6kaTg67TmwANe-q
X-Proofpoint-ORIG-GUID: qHFboD-Sh_-jcvzsP6kaTg67TmwANe-q
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This allows target_get_sess_cmd users to pass in the cmd counter they want
to use. Right now we pass in the session's cmd counter but in the next
patch iSCSI will switch from per session to per conn so this patch will be
needed for that conversion.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 10 +++++----
 drivers/target/target_core_transport.c | 28 ++++++++++++--------------
 drivers/target/target_core_xcopy.c     |  8 ++++----
 drivers/usb/gadget/function/f_tcm.c    |  4 ++--
 include/target/target_core_fabric.h    |  8 +++++---
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index baf4da7bb3b4..87927a36f90d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1190,9 +1190,10 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
 	 */
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
-			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
-			 cmd->data_direction, sam_task_attr,
-			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
+			  conn->sess->se_sess, be32_to_cpu(hdr->data_length),
+			  cmd->data_direction, sam_task_attr,
+			  cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
 		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
@@ -2055,7 +2056,8 @@ iscsit_handle_task_mgt_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
 			  conn->sess->se_sess, 0, DMA_NONE,
 			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
-			  scsilun_to_int(&hdr->lun));
+			  scsilun_to_int(&hdr->lun),
+			  conn->sess->se_sess->cmd_cnt);
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 60647a49a1d3..c395606ab1a9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1441,14 +1441,12 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
  *
  * Preserves the value of @cmd->tag.
  */
-void __target_init_cmd(
-	struct se_cmd *cmd,
-	const struct target_core_fabric_ops *tfo,
-	struct se_session *se_sess,
-	u32 data_length,
-	int data_direction,
-	int task_attr,
-	unsigned char *sense_buffer, u64 unpacked_lun)
+void __target_init_cmd(struct se_cmd *cmd,
+		       const struct target_core_fabric_ops *tfo,
+		       struct se_session *se_sess, u32 data_length,
+		       int data_direction, int task_attr,
+		       unsigned char *sense_buffer, u64 unpacked_lun,
+		       struct target_cmd_counter *cmd_cnt)
 {
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
@@ -1468,6 +1466,7 @@ void __target_init_cmd(
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
 	cmd->orig_fe_lun = unpacked_lun;
+	cmd->cmd_cnt = cmd_cnt;
 
 	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
 		cmd->cpuid = raw_smp_processor_id();
@@ -1687,7 +1686,8 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * target_core_fabric_ops->queue_status() callback
 	 */
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, data_length,
-			  data_dir, task_attr, sense, unpacked_lun);
+			  data_dir, task_attr, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 
 	/*
 	 * Obtain struct se_cmd->cmd_kref reference. A second kref_get here is
@@ -1982,7 +1982,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	BUG_ON(!se_tpg);
 
 	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
-			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
+			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun,
+			  se_sess->cmd_cnt);
 	/*
 	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
 	 * allocation failure.
@@ -2986,7 +2987,6 @@ EXPORT_SYMBOL(transport_generic_free_cmd);
  */
 int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 {
-	struct se_session *se_sess = se_cmd->se_sess;
 	int ret = 0;
 
 	/*
@@ -3003,11 +3003,9 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * Users like xcopy do not use counters since they never do a stop
 	 * and wait.
 	 */
-	if (se_sess->cmd_cnt) {
-		if (!percpu_ref_tryget_live(&se_sess->cmd_cnt->refcnt))
+	if (se_cmd->cmd_cnt) {
+		if (!percpu_ref_tryget_live(&se_cmd->cmd_cnt->refcnt))
 			ret = -ESHUTDOWN;
-		else
-			se_cmd->cmd_cnt = se_sess->cmd_cnt;
 	}
 	if (ret && ack_kref)
 		target_put_sess_cmd(se_cmd);
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 49a83500c8b7..91ed015b588c 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -591,8 +591,8 @@ static int target_xcopy_read_source(
 		(unsigned long long)src_lba, transfer_length_block, src_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, src_bytes,
-			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
@@ -636,8 +636,8 @@ static int target_xcopy_write_destination(
 		(unsigned long long)dst_lba, transfer_length_block, dst_bytes);
 
 	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, dst_bytes,
-			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
-
+			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0,
+			  NULL);
 	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
 				remote_port);
 	if (rc < 0) {
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index 658e2e21fdd0..c21acebe8aae 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1054,7 +1054,7 @@ static void usbg_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
@@ -1183,7 +1183,7 @@ static void bot_cmd_work(struct work_struct *work)
 				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
 				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
 				  cmd->prio_attr, cmd->sense_iu.sense,
-				  cmd->unpacked_lun);
+				  cmd->unpacked_lun, NULL);
 		goto out;
 	}
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 65527174b8bc..d507e7885f17 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -151,9 +151,11 @@ void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
 
 
-void	__target_init_cmd(struct se_cmd *,
-		const struct target_core_fabric_ops *,
-		struct se_session *, u32, int, int, unsigned char *, u64);
+void	__target_init_cmd(struct se_cmd *cmd,
+		const struct target_core_fabric_ops *tfo,
+		struct se_session *sess, u32 data_length, int data_direction,
+		int task_attr, unsigned char *sense_buffer, u64 unpacked_lun,
+		struct target_cmd_counter *cmd_cnt);
 int	target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		unsigned char *sense, u64 unpacked_lun, u32 data_length,
 		int task_attr, int data_dir, int flags);
-- 
2.25.1

