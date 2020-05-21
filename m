Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D294CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 17:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE0920826
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 17:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NBGrkUoH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgEURmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 13:42:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55546 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgEURmq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 13:42:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LHfr4Q001152;
        Thu, 21 May 2020 17:42:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=3vAePDPi+npiOpQDJxOaHa6u0om2XELh3gbbEAPYVvo=;
 b=NBGrkUoHRTj1mUFJM8yxMjbmOic7BFojWIvRpiR/sHM+VBhRbllzMIgwXRZHkSSiBmqb
 M0jYNGHsbWKSNfldZi87Dfnj2ouqdRI3qGocywMyGMGzrQL4wf/wZ/qIOirdcmJ67PP6
 6e/+8gF6uRKYZHnj2cssuuzIe50t6kfYkub6dxE3plx9gWipjqDqX7BQ/9pREbA5kj5s
 EqUMbqoC7HY6AbSpUtcgfSMMp4uV3GZrn8Si2fUjSwrNeDav92Qe7I4/wO7bVHYDkZFd
 O6OMDXj6NR5vw0oRWU6C9ePNVpsUcXjVAI9+iRh3auBOnoZipJnK11IOuqExQ0r+UC6T 7A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31284m9v09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 17:42:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LHggTr061135;
        Thu, 21 May 2020 17:42:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 313gj62a8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 17:42:43 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04LHgXYT002978;
        Thu, 21 May 2020 17:42:33 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 10:42:33 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com, ssudhakarp@gmail.com
Subject: [PATCH 2/3] target: fix NULL pointer dereference
Date:   Thu, 21 May 2020 17:42:27 +0000
Message-Id: <1590082947-993-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005210128
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NULL pointer dereference happens when a SCSI command is received for a
non-existing LU and tracing is enabled. The following call sequences
lead to NULL pointer dereference:

1) iscsit_setup_scsi_cmd
     transport_lookup_cmd_lun <-- lookup fails.
   iscsit_process_scsi_cmd
     iscsit_sequence_cmd
       transport_send_check_condition_and_sense
         trace_target_cmd_complete <-- NULL dereference

2) target_submit_cmd_map_sgls
     transport_lookup_cmd_lun <-- lookup fails
       transport_send_check_condition_and_sense
         trace_target_cmd_complete <-- NULL dereference

In the above sequence, cmd->t_task_cdb is uninitialized which when
referenced in trace_target_cmd_complete() causes NULL pointer dereference.

The fix is to use the helper, target_init_cmd_from_cdb() and call it
before transport_lookup_cmd_lun() is called, so that cmd->t_task_cdb can
be initialized and hence can be referenced in
trace_target_cmd_complete().

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 19 ++++++++++++-------
 drivers/target/target_core_transport.c | 11 +++++++++--
 drivers/target/target_core_xcopy.c     |  3 +++
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 59379d662626..a90b80aee9d8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1167,6 +1167,17 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
+	cmd->se_cmd.orig_fe_lun = scsilun_to_int(&hdr->lun);
+	cmd->sense_reason = target_init_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
+	if (cmd->sense_reason) {
+		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
+		}
+
+		goto attach_cmd;
+	}
+
 	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
 						     scsilun_to_int(&hdr->lun));
 	if (cmd->sense_reason)
@@ -1175,14 +1186,8 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	/* only used for printks or comparing with ->ref_task_tag */
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
 	cmd->sense_reason = target_setup_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
-	if (cmd->sense_reason) {
-		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
-			return iscsit_add_reject_cmd(cmd,
-					ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
-		}
-
+	if (cmd->sense_reason)
 		goto attach_cmd;
-	}
 
 	if (iscsit_build_pdu_and_seq_lists(cmd, payload_length) < 0) {
 		return iscsit_add_reject_cmd(cmd,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f93e25baa664..2e878188dff7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1455,8 +1455,6 @@ void transport_init_se_cmd(
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
 
-	target_init_cmd_from_cdb(cmd, cdb);
-
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
 		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
@@ -1619,6 +1617,15 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 */
 	if (flags & TARGET_SCF_BIDI_OP)
 		se_cmd->se_cmd_flags |= SCF_BIDI;
+
+	se_cmd->orig_fe_lun = unpacked_lun;
+	rc = target_init_cmd_from_cdb(se_cmd, cdb);
+	if (rc) {
+		transport_send_check_condition_and_sense(se_cmd, rc, 0);
+		target_put_sess_cmd(se_cmd);
+		return 0;
+	}
+
 	/*
 	 * Locate se_lun pointer and attach it to struct se_cmd
 	 */
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index bd3ed6ce7571..b20c25343cf1 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -526,6 +526,9 @@ static int target_xcopy_setup_pt_cmd(
 	}
 	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 
+	if (target_init_cmd_from_cdb(cmd, cdb))
+		return -EINVAL;
+
 	cmd->tag = 0;
 	if (target_setup_cmd_from_cdb(cmd, cdb))
 		return -EINVAL;
-- 
1.8.3.1

