Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE89C433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 07:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC3464E9D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 07:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhBIHYh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Feb 2021 02:24:37 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:37980 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230155AbhBIHYZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 9 Feb 2021 02:24:25 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 780C5404CB;
        Tue,  9 Feb 2021 07:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :reply-to:references:in-reply-to:x-mailer:message-id:date:date
        :subject:subject:from:from:received:received:received; s=mta-01;
         t=1612855421; x=1614669822; bh=kRIpF7IkgQfkYswmb9aV92Jijt+zVmGO
        ROwzQTc2HtA=; b=eTQnkE24CCtKzXhzqifln5Z+X0XOjTErAyh+z2keSFcpSoFq
        UnzkDi9TnZIllZbdemtMlAHCw7dZjXeNVfAVrPLue/P7ZhucDtqF4UIm53heZeL+
        8bFj1DdlpAtqYrxX8+CJT1CbLH0yKEV/liXiRKT6TvEoFJD53dguWjnJWYE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id R3b2mUqTBTwi; Tue,  9 Feb 2021 10:23:41 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4EF504128C;
        Tue,  9 Feb 2021 10:23:41 +0300 (MSK)
Received: from localhost (10.199.0.114) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 9 Feb
 2021 10:23:41 +0300
From:   Aleksandr Miloserdov <a.miloserdov@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <r.bolshakov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>
Subject: [PATCH 1/2] scsi: target: core: Add cmd length set before cmd complete
Date:   Tue, 9 Feb 2021 10:22:01 +0300
Message-ID: <20210209072202.41154-2-a.miloserdov@yadro.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210209072202.41154-1-a.miloserdov@yadro.com>
References: <20210209072202.41154-1-a.miloserdov@yadro.com>
Reply-To: <a.miloserdov@yadro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.114]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TCM doesn't properly handle underflow case for service actions. One way to
prevent it is to always complete command with
target_complete_cmd_with_length, however it requires access to data_sg,
which is not always available.

This change introduces target_set_cmd_data_length function which allows to
set command data length before completing it.

Signed-off-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_transport.c | 15 +++++++++++----
 include/target/target_core_backend.h   |  1 +
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fca4bd079d02..c98540355512 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -879,11 +879,9 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
-void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
+void target_set_cmd_data_length(struct se_cmd *cmd, int length)
 {
-	if ((scsi_status == SAM_STAT_GOOD ||
-	     cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) &&
-	    length < cmd->data_length) {
+	if (length < cmd->data_length) {
 		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
 			cmd->residual_count += cmd->data_length - length;
 		} else {
@@ -893,6 +891,15 @@ void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int len
 
 		cmd->data_length = length;
 	}
+}
+EXPORT_SYMBOL(target_set_cmd_data_length);
+
+void target_complete_cmd_with_length(struct se_cmd *cmd, u8 scsi_status, int length)
+{
+	if (scsi_status == SAM_STAT_GOOD ||
+	    cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) {
+		target_set_cmd_data_length(cmd, length);
+	}
 
 	target_complete_cmd(cmd, scsi_status);
 }
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 6336780d83a7..ce2fba49c95d 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -72,6 +72,7 @@ int	transport_backend_register(const struct target_backend_ops *);
 void	target_backend_unregister(const struct target_backend_ops *);
 
 void	target_complete_cmd(struct se_cmd *, u8);
+void	target_set_cmd_data_length(struct se_cmd *, int);
 void	target_complete_cmd_with_length(struct se_cmd *, u8, int);
 
 void	transport_copy_sense_to_cmd(struct se_cmd *, unsigned char *);
-- 
2.26.2

