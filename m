Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB38BC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 22:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F89120826
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 22:13:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IrjA0pAq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgEUWNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 18:13:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52034 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730454AbgEUWNh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 18:13:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LMBpgt088651;
        Thu, 21 May 2020 22:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=wCIsyyLwDZAPXKxBz08awx1T9AIEcQ1NtANpUNu2B60=;
 b=IrjA0pAqAa7gNgWpj1FCW9h1tqPJ4owSMRVs67NaMHvRwALTBt4B4Ev8rL2vfP6mo1t1
 XVx82bLt3Y4tka0bIGqO4rEbp+BzpbgpDPVzKVIZt9jRGCMxrIyekJY9dICOOJym2hrz
 DKYzLvT9aLWIsFbN8msrrBVTEeIcSf6HRJSU0ojcI7HXg2NGxpuaJzMBt+WstXp/hMve
 aa/GZj1aM42kCLleEBcUphKQVITlUi+p8Oo+eHypZ0C9vLwtlUhit7HRfi2aGPMqZo8M
 GM1pCdi6m4ghQA/rjS677R6ywEKpJ9JOh8/RzyXtvjbp6X0JTXK/ySgqXRWQoJLUz/9E Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krk01p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 22:13:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LMDDJJ149069;
        Thu, 21 May 2020 22:13:33 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3cgj5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 22:13:33 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04LMDWPW005381;
        Thu, 21 May 2020 22:13:32 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 15:13:32 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, mchristi@redhat.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
Subject: [PATCH v2 3/3] target: rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()
Date:   Thu, 21 May 2020 22:13:25 +0000
Message-Id: <1590099205-7997-4-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590099205-7997-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1590099205-7997-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005210165
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
index 1110ea507b83..d89983b2e8d6 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1185,7 +1185,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	/* only used for printks or comparing with ->ref_task_tag */
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
-	cmd->sense_reason = target_setup_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
+	cmd->sense_reason = target_cmd_parse_cdb(&cmd->se_cmd, hdr->cdb);
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 67bfac1081c1..74ef89c1e7fb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1450,7 +1450,7 @@ void transport_init_se_cmd(
 EXPORT_SYMBOL(target_cmd_init_cdb);
 
 sense_reason_t
-target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
+target_cmd_parse_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
@@ -1472,7 +1472,7 @@ void transport_init_se_cmd(
 	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
 	return 0;
 }
-EXPORT_SYMBOL(target_setup_cmd_from_cdb);
+EXPORT_SYMBOL(target_cmd_parse_cdb);
 
 /*
  * Used by fabric module frontends to queue tasks directly.
@@ -1636,7 +1636,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		return 0;
 	}
 
-	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
+	rc = target_cmd_parse_cdb(se_cmd, cdb);
 	if (rc != 0) {
 		transport_generic_request_failure(se_cmd, rc);
 		return 0;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index fdd8234906b6..ed43086bf965 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -530,7 +530,7 @@ static int target_xcopy_setup_pt_cmd(
 		return -EINVAL;
 
 	cmd->tag = 0;
-	if (target_setup_cmd_from_cdb(cmd, cdb))
+	if (target_cmd_parse_cdb(cmd, cdb))
 		return -EINVAL;
 
 	if (transport_generic_map_mem_to_cmd(cmd, xop->xop_data_sg,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 6a2bfcca0c98..65496b2a7ad6 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -153,7 +153,7 @@ void	transport_init_se_cmd(struct se_cmd *,
 		struct se_session *, u32, int, int, unsigned char *);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
 sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
-sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
+sense_reason_t target_cmd_parse_cdb(struct se_cmd *, unsigned char *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u64, u32, int, int, int,
 		struct scatterlist *, u32, struct scatterlist *, u32,
-- 
1.8.3.1

