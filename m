Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75932C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 16 May 2023 18:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjEPSxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 14:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjEPSxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 14:53:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1E87694
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 11:53:41 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1ae4e264e03so39055ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 11:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684263220; x=1686855220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Pk1Ym98CAL6qXwBiPYZvFlbe0VglO6+8jZGIG05Xp8=;
        b=KxN2EQePjx/oBE4mr0Ivha7U4E5oLutD8Vgk6bm3RmUAXFlf2NeoIHJu6ZfrQSTphD
         Caesg0DmFM8HXRAC+l5WWamUdooUSkghqfh6SZfgtP9lyzZYaPX0F9dnpXnOINDEl6Tz
         l7cgdiQZLx/7+Y60ysPFMRSYDILSGO/4smUHlJhgfDBeIuX77JVoFJNLm2qUTG3x0PMF
         IWih+ZYk55wI7KQiQsOFSk760MC8q+ujM4czzs462bCUaodjrwM+Yg+9Cofibjom/dEf
         Zmo9DJSvH/xL1tUu4Ly8u9a1WYQdt9GlCJlRryNcwpfXXqsPEQrRBjMkZuEYEZQunQTe
         IqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684263220; x=1686855220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Pk1Ym98CAL6qXwBiPYZvFlbe0VglO6+8jZGIG05Xp8=;
        b=I+oMnzUWj2tRoWCgQHvP/T9IfuEWIMTojcIoHfNR5ZwDhmtUSdiiBYigeeHM1kofeb
         6lqveQbR0t1iQBpUj+9FbRwRgkYsVDtC3ingGaIUhWoF3sp400RED7Hq9BSMB8WJLVEE
         eEBKE9rYplzPnu/AS5aVuuqSzPQa+pl1EAoECUMQVcd2nCsQoffU8CyP49gzi+OwGcDG
         SXiE8xeciXqW64t7/1ohHjai1lJ7xqGllmc4wOuVD7CMWeBrTOsn+LkXA60CtJruafNC
         cby2EGbSpZXPCimeQmg0ifAKKNnpH1Purvh6c2bpZSmjjtcQyxotYNkQ7opE9gka6nKH
         agXQ==
X-Gm-Message-State: AC+VfDw9dKrbJNfQ5gnsZPtDdYUuSF8aSIeZ6+m4RUZXvh7z9i5nL8zE
        RKQ7vzWE9MhzdCreWPdsHYI=
X-Google-Smtp-Source: ACHHUZ4tATREvCMlQnUe4YfuANGktqg2UV8uWOPopvvPZXXEElAkwZVR82ZpdpQmUusF5ChRFIYFaQ==
X-Received: by 2002:a17:902:e5ce:b0:1ae:e2b:3ad8 with SMTP id u14-20020a170902e5ce00b001ae0e2b3ad8mr10674319plf.66.1684263220207;
        Tue, 16 May 2023 11:53:40 -0700 (PDT)
Received: from Osmten.. ([103.84.150.77])
        by smtp.gmail.com with ESMTPSA id bi7-20020a170902bf0700b001a9b29b6759sm15852607plb.183.2023.05.16.11.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 11:53:39 -0700 (PDT)
From:   Osama Muhammad <osmtendev@gmail.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, Osama Muhammad <osmtendev@gmail.com>,
        Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: [PATCH] megaraid_sas_debugfs.c: Fix error checking for debugfs_create_dir
Date:   Tue, 16 May 2023 23:53:14 +0500
Message-Id: <20230516185314.10371-1-osmtendev@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the error checking in megaraid_sas_debugfs.c in
debugfs_create_dir. The correct way to check if an error occurred
is 'IS_ERR' inline function.

Signed-off-by: Osama Muhammad <osmtendev@gmail.com>
Suggested-by: Ivan Orlov <ivan.orlov0322@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_debugfs.c b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
index c69760775efa..8f0df9a1816e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_debugfs.c
+++ b/drivers/scsi/megaraid/megaraid_sas_debugfs.c
@@ -102,7 +102,7 @@ static const struct file_operations megasas_debugfs_raidmap_fops = {
 void megasas_init_debugfs(void)
 {
 	megasas_debugfs_root = debugfs_create_dir("megaraid_sas", NULL);
-	if (!megasas_debugfs_root)
+	if (IS_ERR(megasas_debugfs_root))
 		pr_info("Cannot create debugfs root\n");
 }
 
@@ -129,10 +129,10 @@ megasas_setup_debugfs(struct megasas_instance *instance)
 	if (fusion) {
 		snprintf(name, sizeof(name),
 			 "scsi_host%d", instance->host->host_no);
-		if (!instance->debugfs_root) {
+		if (IS_ERR(instance->debugfs_root)) {
 			instance->debugfs_root =
 				debugfs_create_dir(name, megasas_debugfs_root);
-			if (!instance->debugfs_root) {
+			if (IS_ERR(instance->debugfs_root)) {
 				dev_err(&instance->pdev->dev,
 					"Cannot create per adapter debugfs directory\n");
 				return;
@@ -144,7 +144,7 @@ megasas_setup_debugfs(struct megasas_instance *instance)
 			debugfs_create_file(name, S_IRUGO,
 					    instance->debugfs_root, instance,
 					    &megasas_debugfs_raidmap_fops);
-		if (!instance->raidmap_dump) {
+		if (IS_ERR(instance->raidmap_dump)) {
 			dev_err(&instance->pdev->dev,
 				"Cannot create raidmap debugfs file\n");
 			debugfs_remove(instance->debugfs_root);
-- 
2.34.1

