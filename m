Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14212C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 04:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D00A66138C
	for <linux-scsi@archiver.kernel.org>; Mon, 10 May 2021 04:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhEJEJ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 00:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhEJEJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 00:09:26 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C360EC061573;
        Sun,  9 May 2021 21:08:21 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id k25so14666086oic.4;
        Sun, 09 May 2021 21:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oJUQEbV77gLPFPebnUgArJPF0r/oSrX9JEGl+nPDzGo=;
        b=SJmRazWfGyKyENkVTbbRoORY803IJpnk3AB4JlNAShd+WHC68KnF1zHK+2ZfkbEK4p
         yfUJ5w5jXPUfGOXj33SAf6qcEVRbzYb23QKEUcxaMVzpmAj9xnK9DW/Div4gIjs5Qr+l
         3br9HL6nqEaMErocqYVPzfOmaHabU/LKaU+Vl20fsXstYVYFOX5YF3Ut9i7KKpuFutcC
         CL/GAb9bCm9+pn9QTAp7vvKTSyJVbCXEK/d47Y2S+5kYEhJEBltmfwfKLtAlq2o8RWEI
         I1veuza5C/sDLNKbfQguiG4gYVh/ea1/o3TgYfRqU3zAq6ii85dbaxS3b50Otu9xvvMs
         Yb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=oJUQEbV77gLPFPebnUgArJPF0r/oSrX9JEGl+nPDzGo=;
        b=oC+4mqmUAJo4zzbOrdkufeBJN/EmQuS5SBeq/xTWCjqFq0UNtyrye3QrnxDNOzbkru
         JqLeJMxMQy2zO0eAtaaZkf9M8FADIGt4mSWcPlnGPTqCnwoU56ohiqHAwB3cpwZpqtDZ
         seIGjdygpT/BQCKmx1ayaL5Ep2GUPA7EnQCOush9IBihEy8hgr01lZPWH6D1NEf+K3B5
         yqhNhIxfSVJ/xHJh6zld2i5O0Fg20BLAv158V8OlpVCkCF5gCady2qhLDxaFAWVPhjqh
         N+bZS5feoowOgR0zkF18jT5knXNh3zftrQ1gxfgRYxyIsy67AGvSqj+ikiK3TokWqSvu
         4yEA==
X-Gm-Message-State: AOAM533KfIVOFsPI+10Am9Yv5BAI71KUi/nXjRuCmuLWXYgJLGjQ2vSs
        3gwUPC82k8fWGR8WJVDn0TI=
X-Google-Smtp-Source: ABdhPJzbPz5gq60dA3ewoRmhZRe473t8Nm/xDP5TKJS0TB5VlAOITqGY/H9Tfaik1/KYPjEEab235A==
X-Received: by 2002:aca:c413:: with SMTP id u19mr24299020oif.41.1620619700547;
        Sun, 09 May 2021 21:08:20 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z9sm2460329oos.16.2021.05.09.21.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 21:08:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Hou Pu <houpu@bytedance.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH] scsi: target: iscsi: Drop unnecessary container_of
Date:   Sun,  9 May 2021 21:08:17 -0700
Message-Id: <20210510040817.2050266-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The structure pointer passed to container_of() is never NULL; that was
already checked. That means that the result of container_of() operations
on it is also never NULL, even though se_node_acl is the first element
of the structure embedding it. On top of that, it is misleading to perform
a NULL check on the result of container_of() because the position of the
contained element could change, which would make the test invalid.
Remove the unnecessary NULL check.

As it turns out, the container_of operation was only made for the purpose
of the NULL check. If the container_of is actually needed, it is repeated
later. Remove the container_of operation as well.

The NULL check was identified and removed with the following Coccinelle
script.

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

Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hou Pu <houpu@bytedance.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/target/iscsi/iscsi_target_nego.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 151e2949bb75..fb1b5816a5b6 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -118,13 +118,6 @@ static u32 iscsi_handle_authentication(
 					" CHAP auth\n");
 			return -1;
 		}
-		iscsi_nacl = container_of(se_nacl, struct iscsi_node_acl,
-				se_node_acl);
-		if (!iscsi_nacl) {
-			pr_err("Unable to locate struct iscsi_node_acl for"
-					" CHAP auth\n");
-			return -1;
-		}
 
 		if (se_nacl->dynamic_node_acl) {
 			iscsi_tpg = container_of(se_nacl->se_tpg,
-- 
2.25.1

