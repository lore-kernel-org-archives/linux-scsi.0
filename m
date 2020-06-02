Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AAF1C433E1
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 18:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C09020734
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 18:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e631SW8H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFBSeE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 14:34:04 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgFBSeD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 14:34:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052IWvO5016183;
        Tue, 2 Jun 2020 18:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4FzlDQq2SX1nQ00+Y8nfejo7LEk087HZedlKKBiKN/E=;
 b=e631SW8HkUSoXZ5WBd/WYuxvPp3si3XPu9MqFRre054jnrN+ouSTyQ1jOYjcj7V6zCPA
 OWZ+OennA19OOWIDmlBQx9v0VAn1XKU1XzqMtfCSnTxPnKcGNsaDoSG9pkP1HVvyxnwU
 USE4bfhufGsM+OYtkntgLuVsXRkAPVyOBSuM8ENEhqNxdz900YOynOJTmur3AkyWHCpu
 vVrSU/jIpQ2FeMLrX+2VEDQpOI1Z7T0WyTI1/yZqK1UYbt0gZfuY89w7PcQYn4gIetMs
 /aGHXI2ta09EQPDmwBYTTtuY/00hn9dW/0fbuvMhGicOzmlZiyV+s0v2fpt6dmbhY3aK tQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31bewqwkp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 18:34:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 052IXxMF106664;
        Tue, 2 Jun 2020 18:34:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31c25ppp7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 18:34:00 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 052IXr5D027079;
        Tue, 2 Jun 2020 18:33:53 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jun 2020 11:33:53 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, michael.christie@oracle.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
Subject: [PATCH v3 3/3] target: rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()
Date:   Tue,  2 Jun 2020 18:33:45 +0000
Message-Id: <1591122825-2652-4-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9640 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020134
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
index 1110ea507b83..c0966dd4937c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1185,7 +1185,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	/* only used for printks or comparing with ->ref_task_tag */
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
-	cmd->sense_reason = target_setup_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
+	cmd->sense_reason = target_cmd_parse_cdb(&cmd->se_cmd);
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4282fa98ff35..a55a8aaae6b3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1461,7 +1461,7 @@ void transport_init_se_cmd(
 EXPORT_SYMBOL(target_cmd_init_cdb);
 
 sense_reason_t
-target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
+target_cmd_parse_cdb(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
@@ -1483,7 +1483,7 @@ void transport_init_se_cmd(
 	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
 	return 0;
 }
-EXPORT_SYMBOL(target_setup_cmd_from_cdb);
+EXPORT_SYMBOL(target_cmd_parse_cdb);
 
 /*
  * Used by fabric module frontends to queue tasks directly.
@@ -1645,7 +1645,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		return 0;
 	}
 
-	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
+	rc = target_cmd_parse_cdb(se_cmd);
 	if (rc != 0) {
 		transport_generic_request_failure(se_cmd, rc);
 		return 0;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index fdd8234906b6..842563ba10f6 100644
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
index 6a2bfcca0c98..1e7ea57d0463 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -153,7 +153,7 @@ void	transport_init_se_cmd(struct se_cmd *,
 		struct se_session *, u32, int, int, unsigned char *);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
 sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
-sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
+sense_reason_t target_cmd_parse_cdb(struct se_cmd *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u64, u32, int, int, int,
 		struct scatterlist *, u32, struct scatterlist *, u32,
-- 
1.8.3.1

