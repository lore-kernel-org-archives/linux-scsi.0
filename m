Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05D1BC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jul 2022 18:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiGRSEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 14:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbiGRSEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 14:04:34 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC6A2ED7C
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 11:04:32 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31e55e88567so2881627b3.15
        for <linux-scsi@vger.kernel.org>; Mon, 18 Jul 2022 11:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NWd4oljylJpm15QI+9XW2O50oFX4hIWhG0QplH8ZUcc=;
        b=WZP90pTPH10CAWvZhZJBuczOui98Td8io0fgStFdSWAL73qQaJOJaqCxLfQdQpGnex
         h33Pw3BOS4ET/QLPR1qNefP/G6rXf1JHCz52O8Ex/DUD674t9qZBWErA0swipGhzp+HS
         R1XZQHVH523oSJJKwFazN8Ti51cG/nzXH6QkKYO4+f5VaUYhkINc+gbpJigOkK1C43/l
         mh8zdvBek5v4XHA/4GWHxm8pAfC3WrLHYwGGi+Pq8WQVmbiV3AY9biHCAVSPzRsCku9d
         8L9f/sbHn50lydL6aMWRg5XLmS8aV0h6tLek/icbhqlibGJsit49/PtmhrUwMxvxt7Wi
         UYDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NWd4oljylJpm15QI+9XW2O50oFX4hIWhG0QplH8ZUcc=;
        b=mWY5s8wdgLR39JlvxDLK+gikXtMzb3r1c0cQyxzG1fKoaksiyUFyiWzBORxRKm8tHG
         FIjoAYT2ls1LDPsHsKNXOGddDIJFLtVBxgZSH5nxEcaJfVN64glvPPhhNRK7yZGZF0nV
         v+E2NdcsOWm8Vz6QQsnA7xzZHFLkNOvObUL0LDZZKblRnUj+N+2Qoliq+Tr8QY+XxBtt
         7kogdVSAbt7adHYHQkd2HMgsfar7qiF5tqsiGKYsdc+Qp4DF/r5sauGyHEH45nsJUbHH
         eZmJkrHJanPShV5KhClEww5IGvGaCTOqShmugJtHNZMEbR5BcWgMyvm3xIsSMwtW7qu3
         rH8A==
X-Gm-Message-State: AJIora9t11+7jIoMX7jJbn5cQ7iZiCUxZKWk9DXjCIuPUFEARyF+xsNu
        9FxeXoxVTuB6rPHyEI58LvQIJcDube38hIeLaQ==
X-Google-Smtp-Source: AGRyM1uB1P/tEFzS7Z6lx8XrCNRWsqlv7V1H3xl8sl1/sKEhqaX33ZIQYN0i8q9S8220iDZ4ZD8+1sQkqrtnq9PlHQ==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:f922:7e91:d8e8:24c4])
 (user=justinstitt job=sendgmr) by 2002:a05:6902:124c:b0:66e:d96f:2661 with
 SMTP id t12-20020a056902124c00b0066ed96f2661mr28116509ybu.499.1658167471383;
 Mon, 18 Jul 2022 11:04:31 -0700 (PDT)
Date:   Mon, 18 Jul 2022 11:04:21 -0700
In-Reply-To: <20220708211447.135209-1-justinstitt@google.com>
Message-Id: <20220718180421.49697-1-justinstitt@google.com>
Mime-Version: 1.0
References: <20220708211447.135209-1-justinstitt@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2] target: iscsi: fix clang -Wformat warnings
From:   Justin Stitt <justinstitt@google.com>
To:     justinstitt@google.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        llvm@lists.linux.dev, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, michael.christie@oracle.com,
        mingzhe.zou@easystack.cn, nathan@kernel.org,
        ndesaulniers@google.com, target-devel@vger.kernel.org,
        trix@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When building with Clang we encounter these warnings:
| drivers/target/iscsi/iscsi_target_login.c:719:24: error: format
| specifies type 'unsigned short' but the argument has type 'int'
| [-Werror,-Wformat] " from node: %s\n", atomic_read(&sess->nconn),
-
| drivers/target/iscsi/iscsi_target_login.c:767:12: error: format
| specifies type 'unsigned short' but the argument has type 'int'
| [-Werror,-Wformat] " %s\n", atomic_read(&sess->nconn),
-
| drivers/target/iscsi/iscsi_target.c:4365:12: error: format specifies
| type 'unsigned short' but the argument has type 'int' [-Werror,-Wformat]
| " %s\n", atomic_read(&sess->nconn)

For all warnings, the format specifier is `%hu` which describes an
unsigned short. The resulting type of atomic_read is an int. The
proposed fix is to listen to Clang and swap the format specifier.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
diff from v1->v2:
Combined two similar patches into one:
* https://lore.kernel.org/all/20220708221314.466294-1-justinstitt@google.com/
* https://lore.kernel.org/llvm/20220708211447.135209-1-justinstitt@google.com/

 drivers/target/iscsi/iscsi_target.c       | 2 +-
 drivers/target/iscsi/iscsi_target_login.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e368f038ff5c..bfb717065344 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4361,7 +4361,7 @@ int iscsit_close_connection(
 
 	spin_lock_bh(&sess->conn_lock);
 	atomic_dec(&sess->nconn);
-	pr_debug("Decremented iSCSI connection count to %hu from node:"
+	pr_debug("Decremented iSCSI connection count to %d from node:"
 		" %s\n", atomic_read(&sess->nconn),
 		sess->sess_ops->InitiatorName);
 	/*
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 6b94eecc4790..0778591abae7 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -715,7 +715,7 @@ void iscsi_post_login_handler(
 
 		list_add_tail(&conn->conn_list, &sess->sess_conn_list);
 		atomic_inc(&sess->nconn);
-		pr_debug("Incremented iSCSI Connection count to %hu"
+		pr_debug("Incremented iSCSI Connection count to %d"
 			" from node: %s\n", atomic_read(&sess->nconn),
 			sess->sess_ops->InitiatorName);
 		spin_unlock_bh(&sess->conn_lock);
@@ -763,7 +763,7 @@ void iscsi_post_login_handler(
 	spin_lock_bh(&sess->conn_lock);
 	list_add_tail(&conn->conn_list, &sess->sess_conn_list);
 	atomic_inc(&sess->nconn);
-	pr_debug("Incremented iSCSI Connection count to %hu from node:"
+	pr_debug("Incremented iSCSI Connection count to %d from node:"
 		" %s\n", atomic_read(&sess->nconn),
 		sess->sess_ops->InitiatorName);
 	spin_unlock_bh(&sess->conn_lock);
-- 
2.37.0.170.g444d1eabd0-goog

