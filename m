Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3123C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 04:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DAE0613AB
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 04:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhEJEN2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 00:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhEJEN2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 00:13:28 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCD2C061573;
        Sun,  9 May 2021 21:12:14 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so9308405oto.0;
        Sun, 09 May 2021 21:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dPstqEklPpZa3UgyUnrSIzFfCZyfYs0ZBJQCh0WA7Ss=;
        b=McMwvi48AdJ0kezV7SkQP7nEWrLrXdNXhvMFZhJo93eirJrzFIq9DAEmgu2d/5N0H4
         EmvHQZv1XxsqKOPv62/S1UmvQjGNkQvvcPxyIgxdzS0cYRDsbGjgd4bb0YKlkP481IRe
         cS89Ys1t06vW1WbneYNt0IEMc7PZARk3uWoPfhIDYZFcfdlQsw9hZ0tg7w1eBCzu77PI
         NZcT/aGkwYP5zq+g8VW9xR5yLNcPw92BBMtvO1pKH12XW3h0qd2QCYKk78TG0TesD5UR
         rP8g8AR9/H0KTOIiYM1vIQtkPbbeRp1MxP9GRNY2WvxXEeQu/YIJc/FyjiZz2z0at9Fl
         Q/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=dPstqEklPpZa3UgyUnrSIzFfCZyfYs0ZBJQCh0WA7Ss=;
        b=rnSQYKTImkUFSKwQab0pxNULHW/GVHQVau+JdGTfFzkx4NjQbQjL/arBaXm7eAw3mD
         +xxnIVJtwkPGf8eNsyJquS9fL0bFW0s+oOa0ltK8Wuh4G177vpAy1b3jvbygmcogtgpV
         yNmfVwxDcbkry+Ipz27HuJWjjD2712dFttEyFxdwRxYNWPpqsXhWRgYmotzxdh1YT5oy
         P1eaKE63eQ0b1StRZUd0V9yp3OStRM9AhGSZK98DVo+OQeIeqtt/Onp65PaIaiccZz5n
         ewi6qkTOy5/shubEdFJgK0IygLgZCHJesgNla7K9vYgzPRRL43wrUIMsxQUGmU68JmgO
         ZfIA==
X-Gm-Message-State: AOAM533A9LH79MmbNBzGVoGJVB3LJMie+2Oui7ygiKnWjuKaotD09jsK
        Ov1SxFBqeXcHh1wIb5jY+wVVMuNB+Po=
X-Google-Smtp-Source: ABdhPJy0cCkX4WtZ403SR5/QQYCQCnJudb9FDnBUfwiqT89cncFKuS9FjhPYoHpUe+zvVS9yZ+6E1A==
X-Received: by 2002:a9d:5e0a:: with SMTP id d10mr18957698oti.44.1620619934208;
        Sun, 09 May 2021 21:12:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f13sm2974152ote.46.2021.05.09.21.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 21:12:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] scsi: qedf: Drop unnecessary NULL checks after container_of
Date:   Sun,  9 May 2021 21:12:11 -0700
Message-Id: <20210510041211.2051325-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The result of container_of() operations is never NULL unless the embedded
element is the first element of the structure, which is not the case here.
The NULL checks are therefore unnecessary and misleading. Remove them.

The changes in this patch were made automatically using the following
Coccinelle script.

@@
type t;
identifier v;
statement s;
@@

<+...
(
  t v = container_of(...);
|
  v = container_of(...);
)
  ...
  when != v
- if (\( !v \| v == NULL \) ) s
...+>

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/scsi/qedf/qedf_io.c   | 5 -----
 drivers/scsi/qedf/qedf_main.c | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 4869ef813dc4..6184bc485811 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -23,11 +23,6 @@ static void qedf_cmd_timeout(struct work_struct *work)
 	struct qedf_ctx *qedf;
 	struct qedf_rport *fcport;
 
-	if (io_req == NULL) {
-		QEDF_INFO(NULL, QEDF_LOG_IO, "io_req is NULL.\n");
-		return;
-	}
-
 	fcport = io_req->fcport;
 	if (io_req->fcport == NULL) {
 		QEDF_INFO(NULL, QEDF_LOG_IO,  "fcport is NULL.\n");
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 69f7784233f9..9c7efdf40dd5 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3971,10 +3971,6 @@ void qedf_stag_change_work(struct work_struct *work)
 	struct qedf_ctx *qedf =
 	    container_of(work, struct qedf_ctx, stag_work.work);
 
-	if (!qedf) {
-		QEDF_ERR(NULL, "qedf is NULL");
-		return;
-	}
 	QEDF_ERR(&qedf->dbg_ctx, "Performing software context reset.\n");
 	qedf_ctx_soft_reset(qedf->lport);
 }
-- 
2.25.1

