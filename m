Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0792CCA47B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 21:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240424AbiGHVPD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 17:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239194AbiGHVPB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 17:15:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751FD13E05
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 14:15:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m68-20020a253f47000000b006683bd91962so16746118yba.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2022 14:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qSHdgGbpXhivocKOF8obQspta2jJCcet6Y7m8IlB0FE=;
        b=eruosEj+j8n8myliab6/ptl973Q0ZXiNMt6UUDheQNd7pnmyszOGFDf+GDlr7eL8uS
         hdca4eZ5qUiIDcup6y1Canc4LvG+Fvn+yr7mQAyFEKjAmT0UJu2HEhhyzDDI8YLxk0Fd
         EeTRQoPSqmilnT/J9DeHmpahsCPR9f5ZCWS9BXgx+QDfCcIT/TW/rYUOw2vfc6OeSWbA
         ncBQTQ/t3m5KouK0Gm9XJ360+XoCbBsf0HSTutjeZauKG5LVUCuxi5HLfyYKaObseGvb
         rYs+GPWldYsgt1ipEkRc22K6DILfhi16spn41fYYk4PP57TowU75f90w3nq8ef7fPf2n
         td7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qSHdgGbpXhivocKOF8obQspta2jJCcet6Y7m8IlB0FE=;
        b=rmCtw6j6VEawUF5ltHS9KpU3lYr7J4YVhMTkdGcByFd45IaYoKGwChwdL310AIG77E
         ExVOyUjSgyl1L3J7YeXdjHqiqyVD1kT+Q/461kP4eRoEkH+6krhFBgyo3Dk2TbEyi+j2
         VSVJ132xPdiXxGooP9vGC9034jo+wMgV2g9rR1eicn0EJK1usp1QgudZCV0yOEoTzGNG
         SHo5JDSDJTxvW76nFbYOAnKDeAUTbXHVyAwRVHnE9dmpKs54/UDr4bZGJsKpSLvBh99G
         Y/i7TyqBr54ReC/inUvtHRvW8hI2Zd+SzkRSVpgB+hKEpaZu0ckYMrdO+FS2WNBTHCWZ
         /f+w==
X-Gm-Message-State: AJIora/62K7L+i4x+LCVQvixsv2cLzqy0lEz02v9MZ0708Hrw6YIIW7S
        erWsJwAUGzUkfykBmUsMFDF2XnXxr9cFJ29x7w==
X-Google-Smtp-Source: AGRyM1uadBJfbfldQBG3bWmaKwMY9oR7OdO3yCwtqywlN5csybNvYWICIA7nMB70vrKcu2KBBRATcenb9irlXL5AyQ==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:f21c:9185:9405:36f])
 (user=justinstitt job=sendgmr) by 2002:a0d:f285:0:b0:31b:c2d6:2ce9 with SMTP
 id b127-20020a0df285000000b0031bc2d62ce9mr6555061ywf.172.1657314899764; Fri,
 08 Jul 2022 14:14:59 -0700 (PDT)
Date:   Fri,  8 Jul 2022 14:14:47 -0700
Message-Id: <20220708211447.135209-1-justinstitt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] target: iscsi: fix clang -Wformat warning
From:   Justin Stitt <justinstitt@google.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mingzhe Zou <mingzhe.zou@easystack.cn>,
        Justin Stitt <justinstitt@google.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
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

For both warnings, the format specifier is `%hu` which describes an
unsigned short. The resulting type of atomic_read is an int. The
proposed fix is to listen to Clang and swap the format specifier.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
2.37.0.rc0.161.g10f37bed90-goog

