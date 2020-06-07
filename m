Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5405FC433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 19:58:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AADD2074B
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 19:58:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HkBf3QUx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbgFGT6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 15:58:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55128 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgFGT6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 15:58:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057JwhV8173088;
        Sun, 7 Jun 2020 19:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ec1fNSUKuO90d6eZR6JaBc58UZyfeUDA+EuFhTERtxE=;
 b=HkBf3QUxQzEBzeYAKi9cTa/jqSXEj2IT7/119r1Yti8EXaMbv4Xo77N7++yjFNQnqogr
 7D5uDzbuyDrIf++1me0b563AnJj6mnpPAePWLOGN9l9xNV0c3IwlPigKfJ4xUw3CkP94
 WTyZjseTyGa6hKeWGkIZ0XYWVApFiTmZXTEdaZ1ksxxH+P19wXdVIvGRjUO72RSKzCL/
 pG8RgwfKkq+B+lVx48FP6Zeb/E7+XZuhI/bTCiWDd7yZYJeyR6J1/4y1hUCyBX1zZy+R
 fKWDk5LUoNMC3X8B/h9WoySx/EmaRTGyp2v0X80xbS4/s/SwsFXtHJV+BC8SDE5q+jYM aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 31g33kuy7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 19:58:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057JwHBY132651;
        Sun, 7 Jun 2020 19:58:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 31gmwnxraw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 19:58:42 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057Jwg6E008219;
        Sun, 7 Jun 2020 19:58:42 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 12:58:41 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
Subject: [PATCH v4 3/4] target: fix NULL pointer dereference
Date:   Sun,  7 Jun 2020 19:58:32 +0000
Message-Id: <1591559913-8388-4-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006070155
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NULL pointer dereference happens when the following conditions are met
1) A SCSI command is received for a non-existing LU or cdb
initialization fails in target_setup_cmd_from_cdb().
2) Tracing is enabled.

The following call sequences lead to NULL pointer dereference:

1) iscsit_setup_scsi_cmd
     transport_lookup_cmd_lun <-- lookup fails.
          or
     target_setup_cmd_from_cdb() <-- cdb initialization fails
   iscsit_process_scsi_cmd
     iscsit_sequence_cmd
       transport_send_check_condition_and_sense
         trace_target_cmd_complete <-- NULL dereference

2) target_submit_cmd_map_sgls
     transport_lookup_cmd_lun <-- lookup fails
          or
     target_setup_cmd_from_cdb() <-- cdb initialization fails
       transport_send_check_condition_and_sense
         trace_target_cmd_complete <-- NULL dereference

In the above sequence, cmd->t_task_cdb is uninitialized which when
referenced in trace_target_cmd_complete() causes NULL pointer dereference.

The fix is to use the helper, target_cmd_init_cdb() and call it after
transport_init_se_cmd() is called, so that cmd->t_task_cdb can
be initialized and hence can be referenced in trace_target_cmd_complete().

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 18 +++++++++++-------
 drivers/target/target_core_transport.c | 31 +++++++++++++++++++++++++------
 drivers/target/target_core_xcopy.c     |  3 +++
 3 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 1b453629b516..93534dcc66c9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1167,6 +1167,16 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
+	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
+	if (cmd->sense_reason) {
+		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
+		}
+
+		goto attach_cmd;
+	}
+
 	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd);
 	if (cmd->sense_reason)
 		goto attach_cmd;
@@ -1174,14 +1184,8 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
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
index 7ea77933e64d..0fbb38254535 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1413,6 +1413,9 @@ void transport_init_se_cmd(
 sense_reason_t
 target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
+	sense_reason_t ret;
+
+	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
@@ -1421,7 +1424,8 @@ void transport_init_se_cmd(
 		pr_err("Received SCSI CDB with command_size: %d that"
 			" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
 			scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
-		return TCM_INVALID_CDB_FIELD;
+		ret = TCM_INVALID_CDB_FIELD;
+		goto err;
 	}
 	/*
 	 * If the received CDB is larger than TCM_MAX_COMMAND_SIZE,
@@ -1436,10 +1440,10 @@ void transport_init_se_cmd(
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
 				(unsigned long)sizeof(cmd->__t_task_cdb));
-			return TCM_OUT_OF_RESOURCES;
+			ret = TCM_OUT_OF_RESOURCES;
+			goto err;
 		}
-	} else
-		cmd->t_task_cdb = &cmd->__t_task_cdb[0];
+	}
 	/*
 	 * Copy the original CDB into cmd->
 	 */
@@ -1447,6 +1451,15 @@ void transport_init_se_cmd(
 
 	trace_target_sequencer_start(cmd);
 	return 0;
+
+err:
+	/*
+	 * Copy the CDB here to allow trace_target_cmd_complete() to
+	 * print the cdb to the trace buffers.
+	 */
+	memcpy(cmd->t_task_cdb, cdb, min(scsi_command_size(cdb),
+					 (unsigned int)TCM_MAX_COMMAND_SIZE));
+	return ret;
 }
 EXPORT_SYMBOL(target_cmd_init_cdb);
 
@@ -1456,8 +1469,6 @@ void transport_init_se_cmd(
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
 
-	target_cmd_init_cdb(cmd, cdb);
-
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
 		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
@@ -1621,6 +1632,14 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	 */
 	if (flags & TARGET_SCF_BIDI_OP)
 		se_cmd->se_cmd_flags |= SCF_BIDI;
+
+	rc = target_cmd_init_cdb(se_cmd, cdb);
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
index 5f1bab37a6bf..7f9c93b5cba6 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -526,6 +526,9 @@ static int target_xcopy_setup_pt_cmd(
 	}
 	cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 
+	if (target_cmd_init_cdb(cmd, cdb))
+		return -EINVAL;
+
 	cmd->tag = 0;
 	if (target_setup_cmd_from_cdb(cmd, cdb))
 		return -EINVAL;
-- 
1.8.3.1

