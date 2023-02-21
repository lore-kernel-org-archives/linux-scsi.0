Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D6DDC6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Feb 2023 11:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbjBULya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Feb 2023 06:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbjBULy2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2023 06:54:28 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2013F1F919
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 03:53:56 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id s5so4642641plg.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Feb 2023 03:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ol9FeLysbis9U0TA5QRI7MYyI0bXoO1zwaXDNMUzUeY=;
        b=q9+LVTBrAFK8cDuZOlqZyFBeU9/pgQjFuqN8/jJhdRKgezJMAZZ2C5aVbFv71CnHsw
         w2VjTfGLEBh/7NdrZvAdhY8px4HyWDO0Mykh7txDZ8IjOExyOY0IkmW3GhuxSda+Q/EV
         R/OcfcG67xFrrQobxxtEh1aRaAd9B5TBJMFTCz5KQFRNdj/E61TzHtvniHU1lEH4Eet9
         mCBTIhpdermcdv4ZklqAYuIuMVoF0XgQzFyTZq7d7hd5CqwfckTVC6s59H1Of9oLT9rv
         uqsKujDgfW0AqmFveAQe3abIMqQkPmGXHFcdArxSjuv+4Gw3GTTQVzO1gt/LFK6fRK2P
         FrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ol9FeLysbis9U0TA5QRI7MYyI0bXoO1zwaXDNMUzUeY=;
        b=KQn1r73Cptx/r/Ba6I17d/0OaBv6T92Sb6X6bKp5OvtLjUXxLlWBi+SnIF2hGwK28u
         UAf/6EwAdAftne2Ip+uwOwI0/GNcXLUd84o4mpddNyiIK1Ns20Em6jaRSNKnMkbLSXzS
         ZjJq/CtRlkKfWaSeKr2U/Bo5PIWTru7dVRMAc8FLmK02dIJJ1gNg2PmfblDhUecGJfp3
         DoBD+2Lft1EMbp8Hh6xNn251rZnSKfXZwXEItSwocjKPD9Wnsq72iejTYeEnbT/QxURs
         HH7eARz5Fq3xYCRnsmgKngHHxr6r0nMzqG97NT1nsRn07V5OOZLS0bTq9DQACDiUcY2o
         dJew==
X-Gm-Message-State: AO0yUKU2gTxqWbZ6+Dh9ZYfLwlP1bUZqkZEIhfprcAGunQDSrNclU+Me
        /qgo3JLp6wV/DJPWQcoygSb8QjDeYd6Ev9s3
X-Google-Smtp-Source: AK7set+LGH9IDY9e15B2PUf5INpfvghbR68QnwUyboUCwOyJOMetF3vfG6K/bT4e5cXOAGYNil+zKw==
X-Received: by 2002:a17:90a:29a3:b0:233:dd4d:6b1a with SMTP id h32-20020a17090a29a300b00233dd4d6b1amr4090918pjd.3.1676980435555;
        Tue, 21 Feb 2023 03:53:55 -0800 (PST)
Received: from HTW5T2C6VL.bytedance.net ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id t11-20020a17090a448b00b00230a3b016fcsm2274255pjg.10.2023.02.21.03.53.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Feb 2023 03:53:55 -0800 (PST)
From:   Fengnan Chang <changfengnan@bytedance.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org,
        Fengnan Chang <changfengnan@bytedance.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v2] scsi: remove unused sd_cdb_cache
Date:   Tue, 21 Feb 2023 19:53:40 +0800
Message-Id: <20230221115340.21201-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

since commit ce70fd9a551a ("scsi: core: Remove the cmd field
from struct scsi_request") stop use sd_cdb_cache,
sd_cdb_cache is unused, just remove it.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/sd.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 47dafe6b8a66..46d814035323 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -121,7 +121,6 @@ static void scsi_disk_release(struct device *cdev);
 
 static DEFINE_IDA(sd_index_ida);
 
-static struct kmem_cache *sd_cdb_cache;
 static mempool_t *sd_page_pool;
 static struct lock_class_key sd_bio_compl_lkclass;
 
@@ -3826,19 +3825,11 @@ static int __init init_sd(void)
 	if (err)
 		goto err_out;
 
-	sd_cdb_cache = kmem_cache_create("sd_ext_cdb", SD_EXT_CDB_SIZE,
-					 0, 0, NULL);
-	if (!sd_cdb_cache) {
-		printk(KERN_ERR "sd: can't init extended cdb cache\n");
-		err = -ENOMEM;
-		goto err_out_class;
-	}
-
 	sd_page_pool = mempool_create_page_pool(SD_MEMPOOL_SIZE, 0);
 	if (!sd_page_pool) {
 		printk(KERN_ERR "sd: can't init discard page pool\n");
 		err = -ENOMEM;
-		goto err_out_cache;
+		goto err_out_class;
 	}
 
 	err = scsi_register_driver(&sd_template.gendrv);
@@ -3849,10 +3840,6 @@ static int __init init_sd(void)
 
 err_out_driver:
 	mempool_destroy(sd_page_pool);
-
-err_out_cache:
-	kmem_cache_destroy(sd_cdb_cache);
-
 err_out_class:
 	class_unregister(&sd_disk_class);
 err_out:
@@ -3874,7 +3861,6 @@ static void __exit exit_sd(void)
 
 	scsi_unregister_driver(&sd_template.gendrv);
 	mempool_destroy(sd_page_pool);
-	kmem_cache_destroy(sd_cdb_cache);
 
 	class_unregister(&sd_disk_class);
 
-- 
2.37.1 (Apple Git-137.1)

