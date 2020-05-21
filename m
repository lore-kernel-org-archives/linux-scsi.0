Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71065C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 22:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D1020814
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 22:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RrYct0+s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgEUWNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 18:13:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52036 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730496AbgEUWNh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 18:13:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LMBgvX088579;
        Thu, 21 May 2020 22:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=9YRfha0jNa9hnhJDV+gAeDyqKeCLpYT5TrWFhI+mfpg=;
 b=RrYct0+sic6+TRzW4A+ICn3DmbStHsdt0Kao2DsCRuKGrD8Sd+DfZd9J1ltfJDAOI1R7
 DxP/WLTneiSeutEBWWtJyimMd1YHACJEwiyO8lfjTjmiuOYgE3fRQJ16O9Xn9XtWbmpa
 PMv/yVVQpANZBUJu+/wMvcHcDH3yi4lAv+e9BtqnR0XJD1W1CxWaawZaqe/2wzvnJK8C
 r3evSLtIQ5sMVmqfUzVLxx3HvgGHKnssNskAcreEp6lZDHW2NBBWvlbth4HFjO1AFEP6
 d5AL1NQM0XnBmc49VTHjD/b1cK//LE4caX6nmBEWZzx7cwveDPB+FQnmHQzZAOoDYOr/ dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3127krk01n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 21 May 2020 22:13:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04LMCgJK187456;
        Thu, 21 May 2020 22:13:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 313gj6d2cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 May 2020 22:13:33 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04LMDWtI024886;
        Thu, 21 May 2020 22:13:32 GMT
Received: from supannee-devvm-ol7.osdevelopmeniad.oraclevcn.com (/100.100.231.179)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 15:13:31 -0700
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     martin.petersen@oracle.com, mchristi@redhat.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     shirley.ma@oracle.com
Subject: [PATCH v2 1/3] target: factor out a new helper, target_cmd_init_cdb()
Date:   Thu, 21 May 2020 22:13:23 +0000
Message-Id: <1590099205-7997-2-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590099205-7997-1-git-send-email-sudhakar.panneerselvam@oracle.com>
References: <1590099205-7997-1-git-send-email-sudhakar.panneerselvam@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
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

target_setup_cmd_from_cdb() is called after a successful call to
transport_lookup_cmd_lun(). The new helper factors out the code that can
be called before the call to transport_lookup_cmd_lun(). This helper
will be used in an upcoming commit to address NULL pointer dereference.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/target_core_transport.c | 16 ++++++++++++----
 include/target/target_core_fabric.h    |  1 +
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e6b448f43071..f2f7c5b818cc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1410,11 +1410,8 @@ void transport_init_se_cmd(
 }
 
 sense_reason_t
-target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
+target_cmd_init_cdb(struct se_cmd *cmd, unsigned char *cdb)
 {
-	struct se_device *dev = cmd->se_dev;
-	sense_reason_t ret;
-
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
@@ -1448,6 +1445,17 @@ void transport_init_se_cmd(
 	memcpy(cmd->t_task_cdb, cdb, scsi_command_size(cdb));
 
 	trace_target_sequencer_start(cmd);
+	return 0;
+}
+EXPORT_SYMBOL(target_cmd_init_cdb);
+
+sense_reason_t
+target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
+{
+	struct se_device *dev = cmd->se_dev;
+	sense_reason_t ret;
+
+	target_cmd_init_cdb(cmd, cdb);
 
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 063f133e47c2..6a2bfcca0c98 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -152,6 +152,7 @@ void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
 		struct se_session *, u32, int, int, unsigned char *);
 sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
+sense_reason_t target_cmd_init_cdb(struct se_cmd *, unsigned char *);
 sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
 int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
 		unsigned char *, unsigned char *, u64, u32, int, int, int,
-- 
1.8.3.1

