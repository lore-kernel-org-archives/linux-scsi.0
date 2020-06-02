Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7287C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 18:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 839C520734
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 18:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YCU3OtMp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFBSf4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 14:35:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43992 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgFBSfz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 14:35:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052IVte6015483;
        Tue, 2 Jun 2020 18:35:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=DsrzYb0yfNOPRoQbP0Iiw1HMepnMgAQRBDXqN9gvAKQ=;
 b=YCU3OtMpOVJ6A9CzYvIB2Xt6JnJsgWj8ZveWd12kRTOJOeACmgGdm8ZIjVg+PYqxgD4g
 bDP4BdZiMSEycE7DuHm+4feVpZVOiBhneLryCz5S5eFIvLrpkg95GJFpLZ32bPhXCK+B
 Ym4UXVFj+H2v1c3jmCr5SeM0Y6LOsjBoevBl+oRiMzROnxWnMiugMzfan2wpauCyo2lk
 MfqxQM5PGAzWjxX0aLz8/iW7XSnmZlm/q8F21npYu9w5DouBaF9o213iyc4WhgNVYZF1
 X8dfJMWyZczzyuLltnzzcs0dM2dtf0IS3hXG9l1jCSSW3OYNPF995GlURF7YGz20kxEu aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31bewqwkwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 18:35:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052IXGE7166679;
        Tue, 2 Jun 2020 18:33:53 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dxq9yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 18:33:53 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 052IXqR0003020;
        Tue, 2 Jun 2020 18:33:52 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 11:33:52 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
Subject: [PATCH v3 2/3] target: fix NULL pointer dereference
Date:   Tue,  2 Jun 2020 18:33:44 +0000
Message-Id: <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006020134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020134
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
 drivers/target/iscsi/iscsi_target.c    | 19 ++++++++++++-------
 drivers/target/target_core_transport.c | 28 ++++++++++++++++++++++------
 drivers/target/target_core_xcopy.c     |  3 +++
 3 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 59379d662626..1110ea507b83 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1167,6 +1167,17 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	target_get_sess_cmd(&cmd->se_cmd, true);
 
+	cmd->se_cmd.orig_fe_lun = scsilun_to_int(&hdr->lun);
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
index f2f7c5b818cc..4282fa98ff35 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1412,6 +1412,9 @@ void transport_init_se_cmd(
 sense_reason_t
 target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
+	sense_reason_t ret;
+
+	cmd->t_task_cdb = &cmd->__t_task_cdb[0];
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
@@ -1420,7 +1423,8 @@ void transport_init_se_cmd(
 		pr_err("Received SCSI CDB with command_size: %d that"
 			" exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
 			scsi_command_size(cdb), SCSI_MAX_VARLEN_CDB_SIZE);
-		return TCM_INVALID_CDB_FIELD;
+		ret = TCM_INVALID_CDB_FIELD;
+		goto err;
 	}
 	/*
 	 * If the received CDB is larger than TCM_MAX_COMMAND_SIZE,
@@ -1435,10 +1439,10 @@ void transport_init_se_cmd(
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
@@ -1446,6 +1450,13 @@ void transport_init_se_cmd(
 
 	trace_target_sequencer_start(cmd);
 	return 0;
+
+err:
+	/* Copy the CDB here to allow trace_target_cmd_complete() to
+	 * print the cdb to the trace buffers.
+	 */
+	memcpy(cmd->t_task_cdb, cdb, min(scsi_command_size(cdb), (unsigned int)TCM_MAX_COMMAND_SIZE));
+	return ret;
 }
 EXPORT_SYMBOL(target_cmd_init_cdb);
 
@@ -1455,8 +1466,6 @@ void transport_init_se_cmd(
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
 
-	target_cmd_init_cdb(cmd, cdb);
-
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
 		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
@@ -1598,6 +1607,13 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
 				data_length, data_dir, task_attr, sense);
 
+	se_cmd->orig_fe_lun = unpacked_lun;
+	rc = target_cmd_init_cdb(se_cmd, cdb);
+	if (rc) {
+		transport_send_check_condition_and_sense(se_cmd, rc, 0);
+		return 0;
+	}
+
 	if (flags & TARGET_SCF_USE_CPUID)
 		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
 	else
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index bd3ed6ce7571..fdd8234906b6 100644
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

