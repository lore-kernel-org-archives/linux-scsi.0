Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35FE0C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 17:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 183B620826
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 17:42:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Aox5eFf0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgEURms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 13:42:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43592 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgEURms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 13:42:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LHfToB004118;
        Thu, 21 May 2020 17:42:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=t3cSDk2gMuVwGARildF+1sisp9O9Dn8QB2djFgBudT4=;
 b=Aox5eFf0Qvf7ehKfGPmHq6ZPnNwbBBqbKpNHwsvOQE0nhAYOoEIwiCb1X1TtdKFgifAF
 Xu5U4BH6Nz5RXryEj6cMokp6P0ojfej7EUiRU+/btg3qDqqW88MwS6PZ9oDui2eU8evO
 /sBTucPuLFK11Qm0bcUThHCMiYBqilGPmIFwAViZaz9TRc66n9QW0EVgWYE8Pcl7v5iE
 Jd7sXTHNXqCNECZBuuDw82gtiGzMVAqLPRNzA28hJ+ouxQdCouDhnOfvyiQDqCxN9JG0
 USaAn/pI0hSBqLG7gTc3Vc26ZHyZsXnHU+U6iH/1Arw1j7Jh1O6n68DT8S4otkeUnR9T sg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31501rgc5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 17:42:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LHdFux106039;
        Thu, 21 May 2020 17:42:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 315022un3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 17:42:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04LHgjnf003053;
        Thu, 21 May 2020 17:42:45 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 10:42:44 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com, ssudhakarp@gmail.com
Subject: [PATCH 3/3] target: rename target_setup_cmd_from_cdb() to target_parse_cdb()
Date:   Thu, 21 May 2020 17:42:39 +0000
Message-Id: <1590082959-1034-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005210127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005210128
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
index a90b80aee9d8..38b14291eb76 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1185,7 +1185,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	/* only used for printks or comparing with ->ref_task_tag */
 	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
-	cmd->sense_reason = target_setup_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
+	cmd->sense_reason = target_parse_cdb(&cmd->se_cmd);
 	if (cmd->sense_reason)
 		goto attach_cmd;
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2e878188dff7..329c301129c2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1450,7 +1450,7 @@ void transport_init_se_cmd(
 EXPORT_SYMBOL(target_init_cmd_from_cdb);
 
 sense_reason_t
-target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
+target_parse_cdb(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	sense_reason_t ret;
@@ -1472,7 +1472,7 @@ void transport_init_se_cmd(
 	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
 	return 0;
 }
-EXPORT_SYMBOL(target_setup_cmd_from_cdb);
+EXPORT_SYMBOL(target_parse_cdb);
 
 /*
  * Used by fabric module frontends to queue tasks directly.
@@ -1636,7 +1636,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 		return 0;
 	}
 
-	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
+	rc = target_parse_cdb(se_cmd);
 	if (rc != 0) {
 		transport_generic_request_failure(se_cmd, rc);
 		return 0;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index b20c25343cf1..5cd1e81b33f8 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -530,7 +530,7 @@ static int target_xcopy_setup_pt_cmd(
 		return -EINVAL;
 
 	cmd->tag = 0;
-	if (target_setup_cmd_from_cdb(cmd, cdb))
+	if (target_parse_cdb(cmd))
 		return -EINVAL;
 
 	if (transport_generic_map_mem_to_cmd(cmd, xop->xop_data_sg,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 5c92a5ccc9f0..6eb04a87ca97 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -153,7 +153,7 @@ void	transport_init_se_cmd(struct se_cmd *,
 		struct se_session *, u32, int, int, unsigned char *);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
 sense_reason_t target_init_cmd_from_cdb(struct se_cmd *, unsigned char *);
-sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
+sense_reason_t target_parse_cdb(struct se_cmd *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u64, u32, int, int, int,
 		struct scatterlist *, u32, struct scatterlist *, u32,
-- 
1.8.3.1

