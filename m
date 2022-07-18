Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7B2CCA482
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 15:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiGRP0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 11:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiGRP0P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 11:26:15 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEFA28725;
        Mon, 18 Jul 2022 08:26:13 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id C9612411F9;
        Mon, 18 Jul 2022 15:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:date:subject
        :subject:from:from:received:received:received:received; s=
        mta-01; t=1658157970; x=1659972371; bh=4CuWUVKnsBUNVDPLLZ3r91659
        TNXe6y8+vTDzs1Gzwk=; b=IgzSXq6f6L0alJAi/SouXCHN0oao7j/1M3ef+sdj9
        gL78JFfPszsM18VewYMCk1IzGorGjQitjeXdpBzqYjq9Ld5CzB3kCYVDHOchd3aS
        b7wTLObL8mzILoFlPWpXt6W/ZGgokLmkA1I0HFtIfCWCJEpp40LX+0lUWSw8mIri
        zg=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id f6RTaH-suo95; Mon, 18 Jul 2022 18:26:10 +0300 (MSK)
Received: from T-EXCH-01.corp.yadro.com (t-exch-01.corp.yadro.com [172.17.10.101])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 50E2741257;
        Mon, 18 Jul 2022 18:26:09 +0300 (MSK)
Received: from T-EXCH-08.corp.yadro.com (172.17.11.58) by
 T-EXCH-01.corp.yadro.com (172.17.10.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.669.32; Mon, 18 Jul 2022 18:26:09 +0300
Received: from NB-591.corp.yadro.com (10.199.18.20) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.9; Mon, 18 Jul 2022 18:26:08 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: [PATCH 3/4] target: iscsi: allow negotiate AuthMethod=None
Date:   Mon, 18 Jul 2022 18:25:54 +0300
Message-ID: <20220718152555.17084-4-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220718152555.17084-1-d.bogdanov@yadro.com>
References: <20220718152555.17084-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow to negotiate AuthMethod=None at CSG=0 (Security Negotiation) when
authentication is not required. That is some CHAP test in Windows HLK.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 13 +++++++++++++
 drivers/target/iscsi/iscsi_target_nego.c  |  2 +-
 drivers/target/iscsi/iscsi_target_nego.h  |  2 +-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 6b94eecc4790..d5d617f98195 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -341,6 +341,7 @@ static int iscsi_login_zero_tsih_s2(
 {
 	struct iscsi_node_attrib *na;
 	struct iscsit_session *sess = conn->sess;
+	struct iscsi_param *param;
 	bool iser = false;
 
 	sess->tpg = conn->tpg;
@@ -374,6 +375,18 @@ static int iscsi_login_zero_tsih_s2(
 
 	na = iscsit_tpg_get_node_attrib(sess);
 
+	/*
+	 * If ACL allows non-authorized access in TPG with CHAP,
+	 * then set None to AuthMethod.
+	 */
+	param = iscsi_find_param_from_key(AUTHMETHOD, conn->param_list);
+	if (param && !strstr(param->value, NONE)) {
+		if (!iscsi_conn_auth_required(conn))
+			if (iscsi_change_param_sprintf(conn, "AuthMethod=%s",
+						       NONE))
+				return -1;
+	}
+
 	/*
 	 * Need to send TargetPortalGroupTag back in first login response
 	 * on any iSCSI connection where the Initiator provides TargetName.
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 767646438391..a167fab80588 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -814,7 +814,7 @@ static int iscsi_target_do_authentication(
 	return 0;
 }
 
-static bool iscsi_conn_auth_required(struct iscsit_conn *conn)
+bool iscsi_conn_auth_required(struct iscsit_conn *conn)
 {
 	struct iscsi_node_acl *nacl;
 	struct se_node_acl *se_nacl;
diff --git a/drivers/target/iscsi/iscsi_target_nego.h b/drivers/target/iscsi/iscsi_target_nego.h
index 21d3cab90d08..41c3db3ddeaa 100644
--- a/drivers/target/iscsi/iscsi_target_nego.h
+++ b/drivers/target/iscsi/iscsi_target_nego.h
@@ -22,5 +22,5 @@ extern int iscsi_target_locate_portal(struct iscsi_np *, struct iscsit_conn *,
 extern int iscsi_target_start_negotiation(
 		struct iscsi_login *, struct iscsit_conn *);
 extern void iscsi_target_nego_release(struct iscsit_conn *);
-
+extern bool iscsi_conn_auth_required(struct iscsit_conn *conn);
 #endif /* ISCSI_TARGET_NEGO_H */
-- 
2.25.1

