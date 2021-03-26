Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6B4C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 06:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 332A761A36
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 06:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCZGJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 02:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhCZGJN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 02:09:13 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9084BC0613AA;
        Thu, 25 Mar 2021 23:09:12 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso3739532pji.3;
        Thu, 25 Mar 2021 23:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ak4+6/Le73R2AqNhvkzsYCdlvXiggVWfndGzWqhkeW8=;
        b=blDsomwLMc6m/Lk0gOR07b4Ck1mkwWtCut3wpIn+zUmU4ukHZAH+512REYOUWSY53O
         SZDiEDTELmKYqxEgLkJNH97a7KhySqU3xctk9+0J+2PU8BaGslk2nai0uWCAqTURUHco
         HJu8yRh0D2nA1jCzS5JmVZwqr+Sl5m4ceH0hA7q4Ao2HgVSB/WejDnzem9u2Lsp0fCJp
         xvPpRC5eYc2IEp6e2PRko9jxk2Fk3pmCqaaTENAekcL4fS/6SWyjTHPx4z5dBoHW/ePl
         I6V5h5pDclJFsdqVGbfsScW9rbHeJhFK/McGI/q1u1XCp6hAkZcDhtn286YLJgjhR+QG
         6S+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ak4+6/Le73R2AqNhvkzsYCdlvXiggVWfndGzWqhkeW8=;
        b=E+BsEXau2PbC6ZWJFpmmgGG+pHjbN/8q9w9JMfTPD5W9TmirVk8JVfyJyoRaHcbV9m
         GTdN8LK2ZhXlZX4NOcNkLT646FqC9dERBgyat96dMzbZKA3r1mgq6DKWWwtwoLFbYGmd
         i2F3ygiciOmlbrFtOsTBgExZiNiWvR2MaGYNOx5xnI7umImU05nowq9tpW95tOu/A3GQ
         BIJhsPZ6KaygyVHOs/Zmkgf5EQyYZ26vURpT4i0nxH3pt0F6GV5e8iNN6bD/SCDs5BOJ
         NyR5xf0NLxFt0Vmy7LIN4RltxPuVJwP/QRKBY1kAa0g/o4HGPkdlUFizEi8l6mFYEJv6
         FlEQ==
X-Gm-Message-State: AOAM533NZeSxbRsXnWiXD0djpdVaZJ4IOL5ij16Rh8H0AKtx7rqiRhtr
        /FmiePPgy9Np4C3bYccQZeA=
X-Google-Smtp-Source: ABdhPJxWdx7l/dNt2K7Uoy9pLJaPYBsLvP+aWpiFY7K037YZqN80Lc5d9IkAAP/ZgvrVKr0wH2d4aQ==
X-Received: by 2002:a17:902:bcc8:b029:e6:f010:aa15 with SMTP id o8-20020a170902bcc8b02900e6f010aa15mr13681229pls.55.1616738952219;
        Thu, 25 Mar 2021 23:09:12 -0700 (PDT)
Received: from localhost.localdomain ([202.85.220.39])
        by smtp.gmail.com with ESMTPSA id m7sm7908634pfd.52.2021.03.25.23.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 23:09:11 -0700 (PDT)
From:   dudengke <pinganddu90@gmail.com>
To:     bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, dudengke <dengke.du@ucas.com.cn>
Subject: [PATCH] __scsi_remove_device: fix comments minor error
Date:   Fri, 26 Mar 2021 14:09:02 +0800
Message-Id: <20210326060902.1851811-1-pinganddu90@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: dudengke <dengke.du@ucas.com.cn>

Signed-off-by: dudengke <dengke.du@ucas.com.cn>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b6378c8ca783..86e8d0bf821d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1458,7 +1458,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 
 	/*
 	 * Paired with the kref_get() in scsi_sysfs_initialize().  We have
-	 * remoed sysfs visibility from the device, so make the target
+	 * removed sysfs visibility from the device, so make the target
 	 * invisible if this was the last device underneath it.
 	 */
 	scsi_target_reap(scsi_target(sdev));
-- 
2.25.1

