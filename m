Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FB9C05027
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Feb 2023 13:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjBTNG5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Feb 2023 08:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjBTNG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Feb 2023 08:06:56 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26641B56C
        for <linux-scsi@vger.kernel.org>; Mon, 20 Feb 2023 05:06:27 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id qi12-20020a17090b274c00b002341621377cso1203217pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 20 Feb 2023 05:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sfHtb/zHB96BjYELnqz+o3Vr1tNpZTz7etngSFIZ1vo=;
        b=UuxKS4MwuhRL5hYFkE5zbZ7MBdgFaaTjhlCzkX71wnbiEM8oXK9Kij00dlKMSwDnGy
         tztQ+hSEfSI+XhZHogPsHM4NqXp+Sfq+4h1LwYjITUR2igPEwFBebwRYms17KJe9tS2W
         16QutIgfrDMO4M7k5UJUJeI3p/L6dO4yO+xXE479fEaoHf9iRIFWfWWChWsK9lIMLNnV
         3VPXBkkDOFQ72YSYqUJoGzthRcxSP6HMAbipC0uM/5qi+Oq4rmrYvLlePPImJR34SJRt
         ukM4MPdFBH7ppSb4H0cJjApW7ByeKaKBZ7qjDyRkhPFxy3Uh2PtmkumxregYCWLHIPDW
         wpcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sfHtb/zHB96BjYELnqz+o3Vr1tNpZTz7etngSFIZ1vo=;
        b=cAMot+6YcASso2YuaZfAiROgyLV0gN44ic3KWKULwEaBEXrl8d34V8tCdv9Qqhiex4
         FyR9MEukU/UEH9JPfZ9GBh5kReyWuT8MBQoB71/BRhTjOamSohrfVyrXmZYlZv1rIWrb
         romU9ECrFJyrymKXbOereLsyO5ZYfTylDV2iDYocmPEOLbFMppF4t+yBz0ShtAiaUelo
         wMnbR+rBc1NvzJxEpvLTpuaOFbNvOsJedgFRSSafuJTamVWZsLhp8iemuZJFrDTjJUC0
         inJZNGVNurMWacq5882Q04//A62bbeytWB5q5bE5YBEBl74s8UrN73VMRMPoNiI0YWkd
         MJgQ==
X-Gm-Message-State: AO0yUKUs9zRpp5JqhENVYEz3X8ZzpU/9drNCd3+M7fqH/TtosZwIOI91
        2iCvSMwGngFlNiuWCtiypMgNig==
X-Google-Smtp-Source: AK7set+w2cotSWXrGUnJu8a45S5LpFzT4Wc4StvUwnKAWBhe0JpdOFF923RPOsBjoUnn+Wz1TlTQtw==
X-Received: by 2002:a17:902:ecce:b0:19a:af51:c282 with SMTP id a14-20020a170902ecce00b0019aaf51c282mr1576792plh.0.1676898387230;
        Mon, 20 Feb 2023 05:06:27 -0800 (PST)
Received: from HTW5T2C6VL.bytedance.net ([139.177.225.231])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902684800b0019aa8149cb3sm7856357pln.219.2023.02.20.05.06.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Feb 2023 05:06:26 -0800 (PST)
From:   Fengnan Chang <changfengnan@bytedance.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org,
        Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH] scsi: remove unused sd_cdb_cache
Date:   Mon, 20 Feb 2023 21:05:30 +0800
Message-Id: <20230220130530.62854-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sd_cdb_cache is useless, just remove it.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
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

