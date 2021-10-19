Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70532C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 07:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A2D461391
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 07:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbhJSHVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 03:21:19 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:33742 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234475AbhJSHVP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 03:21:15 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C537441742;
        Tue, 19 Oct 2021 07:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received; s=mta-01; t=
        1634627940; x=1636442341; bh=+WWgJoKT69RcJTWMWdRmmfuC3QQK0gpvehh
        +aNXvGnI=; b=AqLtnOcgDZXp3fF+M2Upx3qa6ez88fTz85WVx9QHAJEBmHV6jy0
        UH8tzZTLn2KbvXXJ8i8qtZ4SBvtv39JfCSuQ9I4+FDCg0MBh5gZvR4tIIYl6DNWO
        1M+kM834zWV1yKltwuFDHseeayby3b1AwesxGIwarrrxsmTIgJroxnxY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0W6cpMXpkBeF; Tue, 19 Oct 2021 10:19:00 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 145AA41752;
        Tue, 19 Oct 2021 10:18:56 +0300 (MSK)
Received: from NB-591.corp.yadro.com (10.178.112.183) by
 T-EXCH-04.corp.yadro.com (172.17.100.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Tue, 19 Oct 2021 10:18:54 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH v3 3/3] target: iscsi: control authentication per ACL
Date:   Tue, 19 Oct 2021 10:18:43 +0300
Message-ID: <20211019071843.14890-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019071843.14890-1-d.bogdanov@yadro.com>
References: <20211019071843.14890-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.178.112.183]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add acls/{ACL}/attrib/authentication attribute that controls authentication
for particular ACL. By default, this attribute inherits a value of the
authentication attribute of the target port group to keep backward
compatibility.

authentication attribute has 3 states:
 "0" - authentication is turned off for this ACL
 "1" - authentication is required for this ACL
 "-1" - authentication is inherited from TPG

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
Reviewed-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
v2:
 show effective value (-1) for inherited mode
---
 drivers/target/iscsi/iscsi_target_configfs.c  | 31 +++++++++++++++++++
 drivers/target/iscsi/iscsi_target_nego.c      |  8 ++++-
 .../target/iscsi/iscsi_target_nodeattrib.c    |  1 +
 include/target/iscsi/iscsi_target_core.h      |  2 ++
 4 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index e3750b64cc0c..6f204f0cedf9 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -314,6 +314,36 @@ ISCSI_NACL_ATTR(random_datain_pdu_offsets);
 ISCSI_NACL_ATTR(random_datain_seq_offsets);
 ISCSI_NACL_ATTR(random_r2t_offsets);
 
+static ssize_t iscsi_nacl_attrib_authentication_show(struct config_item *item,
+		char *page)
+{
+	struct se_node_acl *se_nacl = attrib_to_nacl(item);
+	struct iscsi_node_acl *nacl = to_iscsi_nacl(se_nacl);
+
+	return sprintf(page, "%d\n", nacl->node_attrib.authentication);
+}
+
+static ssize_t iscsi_nacl_attrib_authentication_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct se_node_acl *se_nacl = attrib_to_nacl(item);
+	struct iscsi_node_acl *nacl = to_iscsi_nacl(se_nacl);
+	s32 val;
+	int ret;
+
+	ret = kstrtos32(page, 0, &val);
+	if (ret)
+		return ret;
+	if (val != 0 && val != 1 && val != NA_AUTHENTICATION_INHERITED)
+		return -EINVAL;
+
+	nacl->node_attrib.authentication = val;
+
+	return count;
+}
+
+CONFIGFS_ATTR(iscsi_nacl_attrib_, authentication);
+
 static struct configfs_attribute *lio_target_nacl_attrib_attrs[] = {
 	&iscsi_nacl_attrib_attr_dataout_timeout,
 	&iscsi_nacl_attrib_attr_dataout_timeout_retries,
@@ -323,6 +353,7 @@ static struct configfs_attribute *lio_target_nacl_attrib_attrs[] = {
 	&iscsi_nacl_attrib_attr_random_datain_pdu_offsets,
 	&iscsi_nacl_attrib_attr_random_datain_seq_offsets,
 	&iscsi_nacl_attrib_attr_random_r2t_offsets,
+	&iscsi_nacl_attrib_attr_authentication,
 	NULL,
 };
 
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 89b24d7d031d..a65ffc7d05b3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -813,6 +813,7 @@ static int iscsi_target_do_authentication(
 
 static bool iscsi_conn_auth_required(struct iscsi_conn *conn)
 {
+	struct iscsi_node_acl *nacl;
 	struct se_node_acl *se_nacl;
 
 	if (conn->sess->sess_ops->SessionType) {
@@ -839,7 +840,12 @@ static bool iscsi_conn_auth_required(struct iscsi_conn *conn)
 
 	pr_debug("Known ACL %s is trying to connect\n",
 		 se_nacl->initiatorname);
-	return conn->tpg->tpg_attrib.authentication;
+
+	nacl = to_iscsi_nacl(se_nacl);
+	if (nacl->node_attrib.authentication == NA_AUTHENTICATION_INHERITED)
+		return conn->tpg->tpg_attrib.authentication;
+
+	return nacl->node_attrib.authentication;
 }
 
 static int iscsi_target_handle_csg_zero(
diff --git a/drivers/target/iscsi/iscsi_target_nodeattrib.c b/drivers/target/iscsi/iscsi_target_nodeattrib.c
index e3ac247bffe8..baf1c93fa1e3 100644
--- a/drivers/target/iscsi/iscsi_target_nodeattrib.c
+++ b/drivers/target/iscsi/iscsi_target_nodeattrib.c
@@ -30,6 +30,7 @@ void iscsit_set_default_node_attribues(
 {
 	struct iscsi_node_attrib *a = &acl->node_attrib;
 
+	a->authentication = NA_AUTHENTICATION_INHERITED;
 	a->dataout_timeout = NA_DATAOUT_TIMEOUT;
 	a->dataout_timeout_retries = NA_DATAOUT_TIMEOUT_RETRIES;
 	a->nopin_timeout = NA_NOPIN_TIMEOUT;
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 21c1aaa6dae2..0913909fa765 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -26,6 +26,7 @@ struct sock;
 #define ISCSI_RX_THREAD_NAME		"iscsi_trx"
 #define ISCSI_TX_THREAD_NAME		"iscsi_ttx"
 #define ISCSI_IQN_LEN			224
+#define NA_AUTHENTICATION_INHERITED	-1
 
 /* struct iscsi_node_attrib sanity values */
 #define NA_DATAOUT_TIMEOUT		3
@@ -714,6 +715,7 @@ struct iscsi_login {
 } ____cacheline_aligned;
 
 struct iscsi_node_attrib {
+	s32			authentication;
 	u32			dataout_timeout;
 	u32			dataout_timeout_retries;
 	u32			default_erl;
-- 
2.25.1

