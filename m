Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4023EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 10:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233687AbiEWJ77 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 05:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiEWJ7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 05:59:34 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1652F637D;
        Mon, 23 May 2022 02:59:22 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4B82F48013;
        Mon, 23 May 2022 09:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1653299959; x=1655114360; bh=qQAjOGupWrO70e6x8sXxn5mR0
        BOKHV35CD2SaHjt98M=; b=cmNGEcDmatSeVVlNOSzvNHJmaAf98XWiQ7TYqzzG8
        MWYKWkFnQRUeyCLbrsp0Gs12T0dDZAzyZUeS4aVnSzyaMR3lQUCuhzF1nXbxdT/i
        0SnT30bJo8yccUTSk/KYZmqSSip0Er/vsXT25qKxkRM+nTRKWMlup0kQoQv7LOck
        Os=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dm2W3b-KxVm4; Mon, 23 May 2022 12:59:19 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id F2AF2482EA;
        Mon, 23 May 2022 12:59:18 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 23 May 2022 12:59:18 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-09.corp.yadro.com (172.17.11.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.22; Mon, 23 May 2022 12:59:18 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     Mike Christie <michael.christie@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Subject: [PATCH v5 3/3] target: iscsi: control authentication per ACL
Date:   Mon, 23 May 2022 12:59:05 +0300
Message-ID: <20220523095905.26070-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523095905.26070-1-d.bogdanov@yadro.com>
References: <20220523095905.26070-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
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
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c  | 31 +++++++++++++++++++
 drivers/target/iscsi/iscsi_target_nego.c      |  8 ++++-
 .../target/iscsi/iscsi_target_nodeattrib.c    |  1 +
 include/target/iscsi/iscsi_target_core.h      |  2 ++
 4 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 1096201f1599..c41b369a0bb9 100644
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
index f06f16d63fe6..9ce35a59962b 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -813,6 +813,7 @@ static int iscsi_target_do_authentication(
 
 static bool iscsi_conn_auth_required(struct iscsit_conn *conn)
 {
+	struct iscsi_node_acl *nacl;
 	struct se_node_acl *se_nacl;
 
 	if (conn->sess->sess_ops->SessionType) {
@@ -839,7 +840,12 @@ static bool iscsi_conn_auth_required(struct iscsit_conn *conn)
 
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
index 874cb33c9be0..d63efdefb18e 100644
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
index 4dd62947f8db..94d06ddfd80a 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -26,6 +26,7 @@ struct sock;
 #define ISCSI_RX_THREAD_NAME		"iscsi_trx"
 #define ISCSI_TX_THREAD_NAME		"iscsi_ttx"
 #define ISCSI_IQN_LEN			224
+#define NA_AUTHENTICATION_INHERITED	-1
 
 /* struct iscsi_node_attrib sanity values */
 #define NA_DATAOUT_TIMEOUT		3
@@ -715,6 +716,7 @@ struct iscsi_login {
 } ____cacheline_aligned;
 
 struct iscsi_node_attrib {
+	s32			authentication;
 	u32			dataout_timeout;
 	u32			dataout_timeout_retries;
 	u32			default_erl;
-- 
2.25.1

