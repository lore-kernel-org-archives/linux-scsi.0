Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28ACC27C76
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 19:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbjAYTnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 14:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbjAYTnT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 14:43:19 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4003043926
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2023 11:43:18 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id k13so18951155plg.0
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jan 2023 11:43:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhHqG4Q6Wqwz7zFntIlbEm2+z6QU8BU/fnN4Y+JJnTA=;
        b=jhNllj+iJl7fXsF+J70F6O9sdio7s2ZR7pwABIUC9vkPffNT73TdwULb5tTAU9wmhT
         2V7XlkwH9BF60BkHORW5i0P/9uxGWm/5H3pl46ewc5bYasghKGYeolqTA/q4KTOmNJJr
         grjtx/p7J8hYvCnVqGUr4BD2IaNCYQnXpUwVt6jDRgBJJpX1O4spe4m5lF99PFZiH/2Y
         eLVMKY88+0RqDBmK5KlTgugqxKQ0G9jSfNj2GhWjIPuVAA0dE9unkScdWclU2X31t+XN
         Bhp/2WZjDcXeICTnS8CTqJm6UgP6U0sUwoRbTwSr7rj8BkTVglDar0+ElUD7nVXcJgTl
         e/IQ==
X-Gm-Message-State: AFqh2krc/BBW6f/AbWMGfE6nCiifgJKSgp9ssyZgNOUlYTEfUqalD0JF
        dV94xuDLWmApfyFEI4G+3mk=
X-Google-Smtp-Source: AMrXdXsRHF0GZ5owlu2rN52z48UfPCaU79CGsrU7VP4eghOA7gVn5kTqIbSWdSaT7vRHHjJwFtOB7g==
X-Received: by 2002:a17:90a:fa43:b0:229:e620:6c19 with SMTP id dt3-20020a17090afa4300b00229e6206c19mr26670003pjb.0.1674675797701;
        Wed, 25 Jan 2023 11:43:17 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7512:ed47:db25:4294])
        by smtp.gmail.com with ESMTPSA id q25-20020a637519000000b004d182686e08sm3612785pgc.39.2023.01.25.11.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 11:43:16 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH] scsi: core: Fix the scsi_device_put() might_sleep annotation
Date:   Wed, 25 Jan 2023 11:43:11 -0800
Message-Id: <20230125194311.249553-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Although most calls of scsi_device_put() happen from non-atomic context,
alua_rtpg_queue() calls this function from atomic context if
alua_rtpg_queue() itself is called from atomic context. alua_rtpg_queue()
is always called from contexts where the caller must hold at least one
reference to the scsi device in question. This means that the reference
taken by alua_rtpg_queue() itself can't be the last one, and thus can be
dropped without entering the code path in which scsi_device_put() might
actually sleep. Hence move the might_sleep() annotation from
scsi_device_put() into scsi_device_dev_release().

[1] https://lore.kernel.org/linux-scsi/b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com/
[2] https://lore.kernel.org/linux-scsi/55c35e64-a7d4-9072-46fd-e8eae6a90e96@linux.ibm.com/

Note: a significant part of the above description was written by Martin
Wilck.

Fixes: f93ed747e2c7 ("scsi: core: Release SCSI devices synchronously")
Cc: Martin Wilck <mwilck@suse.com>
Cc: Steffen Maier <maier@linux.ibm.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sachin Sant <sachinp@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>
Reported-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c       | 2 --
 drivers/scsi/scsi_sysfs.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1426b9b03612..9feb0323bc44 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -588,8 +588,6 @@ void scsi_device_put(struct scsi_device *sdev)
 {
 	struct module *mod = sdev->host->hostt->module;
 
-	might_sleep();
-
 	put_device(&sdev->sdev_gendev);
 	module_put(mod);
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 981d1bab2120..8ef9a5494340 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -451,6 +451,8 @@ static void scsi_device_dev_release(struct device *dev)
 	struct scsi_vpd *vpd_pgb0 = NULL, *vpd_pgb1 = NULL, *vpd_pgb2 = NULL;
 	unsigned long flags;
 
+	might_sleep();
+
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
