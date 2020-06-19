Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B1FC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 13:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 267D220786
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 13:11:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VkGlO6Ux"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730380AbgFSNLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 09:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgFSNLG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 09:11:06 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4FCC06174E;
        Fri, 19 Jun 2020 06:11:05 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w7so7595659edt.1;
        Fri, 19 Jun 2020 06:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JP6uPpMAgWXgeAfAgXoDQSBoCbrd27SovfuK6ZrWwSg=;
        b=VkGlO6UxVIVq50qO62el0VgTbxXcwkOviiDL5bINq0+1IFLBt9orv8eo19RfPfDNMA
         LBeli6jfa3SY21Vv8XGflFLxzPb49ba6FFnjsfDQBz71Icnw3ygT5xFDaFr06Rm3fN3x
         u6j5D2Iky8+vhG229y9fXT4rSCxtFxExMzCI84flIdh63Ov7h6Ogk1A21LlwYQL/jIx7
         LE3RTqmaDcfcpSFo+BZGN/YqHs6ug48AldeXdeV4WFM2sK2BoiEI5YmHXeyAJIAiQu/B
         SRTH3a+nQNuoE8tUEKUQUAEQzoBVUNAeg4T/9hPSjzkBmK1f53T1BbnIw8Ih0axLMGOE
         J9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JP6uPpMAgWXgeAfAgXoDQSBoCbrd27SovfuK6ZrWwSg=;
        b=e4xlfBP/Sp70mIaB7++pwNPE9sQoUUZi3CX3FrriKEBOYf9JfUR8TIdJjpKx5hdJx5
         D6RbmkPKpBNDRIHelSTV5eHrYsS+TfUuNkCsogCHMoIXlW1Q1WHY+gO9w3XIdiz/PWFk
         QEed0lmbK3mBQzEf60Z/F7dUEb1cXr6L538dtFtYMVnaYlcrfe1V7fPY8EtEEk/qMDVY
         rtD+PLflHN4IYbUZTQfF0R7cJVvPiPBIsWsOhTn4oPIEt2G2GTRRF3B78USO+OkdOzVF
         xLJwTa+brh+U08NlIsHvUg2++FL7ZlfAsw9wx5hehvITpT4Y0bZBiIYKYEi0IBi1pUiv
         MtJg==
X-Gm-Message-State: AOAM532zOQ2cdaVh0J0aCEk7GQZURGM0LBaIdhIu0Rav8cJVo049IPih
        9sIpldAuZwN1o9iP6E7T/WJxeEK51ynk3g==
X-Google-Smtp-Source: ABdhPJyyNMLFYLoJfR+ir2N/SRgyBN/kGxj6gWtWg3ptOnlpJSoN2D3bOQ7Ub1Ayuf5EDgUH9y7xtg==
X-Received: by 2002:a05:6402:6d6:: with SMTP id n22mr3367940edy.362.1592572264186;
        Fri, 19 Jun 2020 06:11:04 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id m30sm4610677eda.16.2020.06.19.06.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 06:11:03 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     beanhuo@micron.com, bvanassche@acm.org
Subject: [RFC PATCH ] scsi: remove scsi_sdb_cache
Date:   Fri, 19 Jun 2020 15:10:42 +0200
Message-Id: <20200619131042.10759-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

After 'commit f664a3cc17b7 ("scsi: kill off the legacy IO path")',
scsi_sdb_cache not be used any more, remove it.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/scsi.c      |  3 ---
 drivers/scsi/scsi_lib.c  | 18 +-----------------
 drivers/scsi/scsi_priv.h |  1 -
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 56c24a73e0c7..24619c3bebd5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -754,9 +754,6 @@ static int __init init_scsi(void)
 {
 	int error;
 
-	error = scsi_init_queue();
-	if (error)
-		return error;
 	error = scsi_init_procfs();
 	if (error)
 		goto cleanup_queue;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0ba7a65e7c8d..3fadfe9447e8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -52,7 +52,6 @@
 #define  SCSI_INLINE_SG_CNT  2
 #endif
 
-static struct kmem_cache *scsi_sdb_cache;
 static struct kmem_cache *scsi_sense_cache;
 static struct kmem_cache *scsi_sense_isadma_cache;
 static DEFINE_MUTEX(scsi_sense_cache_mutex);
@@ -1955,24 +1954,10 @@ void scsi_unblock_requests(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_unblock_requests);
 
-int __init scsi_init_queue(void)
-{
-	scsi_sdb_cache = kmem_cache_create("scsi_data_buffer",
-					   sizeof(struct scsi_data_buffer),
-					   0, 0, NULL);
-	if (!scsi_sdb_cache) {
-		printk(KERN_ERR "SCSI: can't init scsi sdb cache\n");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
 void scsi_exit_queue(void)
 {
 	kmem_cache_destroy(scsi_sense_cache);
 	kmem_cache_destroy(scsi_sense_isadma_cache);
-	kmem_cache_destroy(scsi_sdb_cache);
 }
 
 /**
@@ -2039,7 +2024,6 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 		real_buffer[1] = data->medium_type;
 		real_buffer[2] = data->device_specific;
 		real_buffer[3] = data->block_descriptor_length;
-		
 
 		cmd[0] = MODE_SELECT;
 		cmd[4] = len;
@@ -2227,7 +2211,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 			goto illegal;
 		}
 		break;
-			
+
 	case SDEV_RUNNING:
 		switch (oldstate) {
 		case SDEV_CREATED:
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 22b6585e28b4..d12ada035961 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -93,7 +93,6 @@ extern struct request_queue *scsi_mq_alloc_queue(struct scsi_device *sdev);
 extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
 extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
-extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
 extern void scsi_evt_thread(struct work_struct *work);
 struct request_queue;
-- 
2.17.1

