Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74990C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 15:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 520DB20809
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 15:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aM8guXAk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405059AbgFSPlz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 11:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394008AbgFSPlf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 11:41:35 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79D3C06174E;
        Fri, 19 Jun 2020 08:41:34 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id gl26so10652572ejb.11;
        Fri, 19 Jun 2020 08:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KxptnYnfHSGRIej/uEjkXn1kN63Oa8BnOXMgrYh96nA=;
        b=aM8guXAkFbP8SbiVfoTeNX1Po93NWpTkCHyQH3/TMvLM6y+M94MbhY7XQVb5A6FWKU
         WcFUeoCbVe3+Kfx9nACDSw6EgPHcXpF8MyAutFzm+GLhkeuu8hJ3SEtRwRv0BWC5cSSI
         k3fXrEQv0wD5EWm5weldeM6oH3PvARJ9Txys3P2Ak5lDMiuODgproasV+9PCtwYU0aQg
         pIk4Or7iWk4jyLaP7JrBpqK4OhDzVGe2oIdavGra9sv+b3oT5ieEIH8Cr0QmRD/SFACD
         pgTE7f4sxnRkNZ2nleLyVfbPnvIAvnLfcKKxWyPj/A/rZMGLRq1cx35Q4fCghxvL4Bks
         vRbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KxptnYnfHSGRIej/uEjkXn1kN63Oa8BnOXMgrYh96nA=;
        b=B6sW7ACZVIxAHabJCufy84M1Aa1U1b+fKq1kgZLyNkcrvKE/uPurMRV4BYK/l+rZCa
         IuLZXqzsYCLaDZ3XFl2xjzGusSJy1pDZ7rku0EOyudqLUknPUeu7dbW/ArRuGr9+xrmt
         Qnfa+kSIGtO+feL2r1Ly3Q+fIRt/rvqXg0nLZSJdsx5hyz0ZP8CXaFWtzeBmj9XdqAIf
         Vc/TpN4ZlFwoe2iLwd/OZ3ynsXBGE81jjPDQIW7INOF3IYHvASFQqCYGtguBDbPhVAKX
         bzdnGyO34S7RQc89YTmjosJjF+6Rnx97Lfx6ki7K66IXmhBqztgQJ5mzAMesLizEDJwJ
         E0dQ==
X-Gm-Message-State: AOAM532jG7xl8PBpoQ1LOdrRL52hbfz7qYRMx1zFFAf6iiUzXt/RKBhj
        KqWFcbhXcejf0zbX3C8gfeU=
X-Google-Smtp-Source: ABdhPJzVILVefkmEhKmRh72ZLo4ICm97ZqUhUpB3InsILsQztqPmR9tULsbSQlp77mYJCa0ypg2IxA==
X-Received: by 2002:a17:906:39a:: with SMTP id b26mr4447391eja.204.1592581293647;
        Fri, 19 Jun 2020 08:41:33 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id ew9sm4986163ejb.121.2020.06.19.08.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2020 08:41:33 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
Cc:     beanhuo@micron.com
Subject: [PATCH v2 1/2] scsi: remove scsi_sdb_cache
Date:   Fri, 19 Jun 2020 17:41:16 +0200
Message-Id: <20200619154117.10262-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619154117.10262-1-huobean@gmail.com>
References: <20200619154117.10262-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

After 'commit f664a3cc17b7 ("scsi: kill off the legacy IO path")',
scsi_sdb_cache not be used any more, remove it.

Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c      |  3 ---
 drivers/scsi/scsi_lib.c  | 15 ---------------
 drivers/scsi/scsi_priv.h |  1 -
 3 files changed, 19 deletions(-)

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
index 0ba7a65e7c8d..c47650f7f0d3 100644
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

