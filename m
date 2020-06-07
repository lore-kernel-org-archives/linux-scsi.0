Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88AC6C433DF
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:00:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA9420760
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:00:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MKkCLqN7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgFGUAp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:00:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45072 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgFGUAo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:00:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057Jq9co032224;
        Sun, 7 Jun 2020 20:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=5PJTf5+SfMuSsMgcn6f39UNiG30lHFqvRfVQqleJgUc=;
 b=MKkCLqN7vcSsU7w6ejTvcnjBJy/dyR9W33us29cxF6kQUWYVrhz2RAZQG+PT+WsYDFX7
 dT0Sqk1X12PORDTIH43ymtKIfHWD11SGUm1HLrlry1vCps7NXLq+l9Kfy4Ddi/zq0xMU
 H+nUmT8tW8a5ITpIJbxCfi2WOy687cV6kL3PqYFX29cgfN+nnPkXofanYHsrEwp4LN/E
 QMR49Wictb1d+/npp2Hep4sCckfWiC7YbJggqvF9T1weLlzh9ixp6jnxg/WwHD2mvBVQ
 QlwiRyEh8XcYjZrBiIyo0ixY64ko6Nk3ZyCR22nbBLcdWbe/5U0gsOLBPFQQPzjSewP5 nA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31g2jqv0sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:00:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057JvYTE087688;
        Sun, 7 Jun 2020 19:58:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 31gn2u785a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 19:58:43 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057JwgpK008222;
        Sun, 7 Jun 2020 19:58:42 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 12:58:42 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
Subject: [PATCH v4 4/4] target: rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()
Date:   Sun,  7 Jun 2020 19:58:33 +0000
Message-Id: <1591559913-8388-5-git-send-email-sudhakar.panneerselvam@oracle.com>
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

This commit also removes the unused argument, cdb that was passed
to this function.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c    | 2 +-
 drivers/target/target_core_transport.c | 6 +++---
 drivers/target/target_core_xcopy.c     | 2 +-
 include/target/target_core_fabric.h    | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 93534dcc66c9..c9689610e186 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1183,7 +1183,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	/* only used for printks or comparing with ->ref_task_tag */
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
-	cmd->sense_reason = target_setup_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
+	cmd->sense_reason = target_cmd_parse_cdb(&cmd->se_cmd);
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0fbb38254535..229407d81613 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1464,7 +1464,7 @@ void transport_init_se_cmd(
 EXPORT_SYMBOL(target_cmd_init_cdb);
 
 sense_reason_t
-target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
+target_cmd_parse_cdb(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
@@ -1486,7 +1486,7 @@ void transport_init_se_cmd(
 	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
 	return 0;
 }
-EXPORT_SYMBOL(target_setup_cmd_from_cdb);
+EXPORT_SYMBOL(target_cmd_parse_cdb);
 
 /*
  * Used by fabric module frontends to queue tasks directly.
@@ -1650,7 +1650,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		return 0;
 	}
 
-	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
+	rc = target_cmd_parse_cdb(se_cmd);
 	if (rc != 0) {
 		transport_generic_request_failure(se_cmd, rc);
 		return 0;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 7f9c93b5cba6..0d00ccbeb050 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -530,7 +530,7 @@ static int target_xcopy_setup_pt_cmd(
 		return -EINVAL;
 
 	cmd->tag = 0;
-	if (target_setup_cmd_from_cdb(cmd, cdb))
+	if (target_cmd_parse_cdb(cmd))
 		return -EINVAL;
 
 	if (transport_generic_map_mem_to_cmd(cmd, xop->xop_data_sg,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 92f6cb20775e..6adf4d71acf6 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -153,7 +153,7 @@ void	transport_init_se_cmd(struct se_cmd *,
 		struct se_session *, u32, int, int, unsigned char *, u64);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
 sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
-sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
+sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u64, u32, int, int, int,
 		struct scatterlist *, u32, struct scatterlist *, u32,
-- 
1.8.3.1

