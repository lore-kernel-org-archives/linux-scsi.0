Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8857BC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Nov 2023 21:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233654AbjKNVSa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Nov 2023 16:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234044AbjKNVS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2023 16:18:29 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12218D5;
        Tue, 14 Nov 2023 13:18:26 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1cc1ee2d8dfso54695405ad.3;
        Tue, 14 Nov 2023 13:18:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699996705; x=1700601505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hEB5AQTRUTdOnsPOaGK+HSfWWF2oI6RKvZDS0NG1d3w=;
        b=CxWUYpQgciS7DTf0yx6ccrFZ0OEx4Rcwd2NU5I2KR8jWQIw/lgzhWOD6zREQHclt79
         MPbNh+CmkTTGrIB6uQRkw3l2de0ySYkoBpOvKzD96iE3PdxUIzBCdKgx8d9Hz0+kN/Ch
         41FM5184CckJQffLLm6n55gfaidtmyGLPw7t2Tq+pYO+j7YfXIPknJyZzHiZdye0AO/G
         KcToyFVj2ew6+GppC0692QYfzqXrRhS4OBleagXlCht9mKbv4+QMaWaSGJ+hAOD5dvXY
         Wdd6arBYW1pLU05bZG+BSnwSC48uHG7watBYCi2UMy5t5OO7vhd+SY6mi/FXWyzwR1Dk
         DGzw==
X-Gm-Message-State: AOJu0YyR+QgCZdrYXOcvaCWfTgpUo9vcQsndl3Ng81/ylCFdsIpp46fM
        3aJE8YgDd0NyHwch+H9WGcc=
X-Google-Smtp-Source: AGHT+IHhcjnOxAPLwOhAVYvIsTZ0lsfBJJswaQZJeMhWVew//IeJiHQw1atrNDCRu/cJhtU5ZxPdSQ==
X-Received: by 2002:a17:902:8c96:b0:1ce:16e7:f4f8 with SMTP id t22-20020a1709028c9600b001ce16e7f4f8mr3037620plo.11.1699996705438;
        Tue, 14 Nov 2023 13:18:25 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:2278:ad72:cefb:4d49])
        by smtp.gmail.com with ESMTPSA id ix7-20020a170902f80700b001c71ec1866fsm6169288plb.258.2023.11.14.13.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 13:18:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.g.garry@oracle.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH v15 05/19] scsi: Pass SCSI host pointer to scsi_eh_flush_done_q()
Date:   Tue, 14 Nov 2023 13:16:13 -0800
Message-ID: <20231114211804.1449162-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114211804.1449162-1-bvanassche@acm.org>
References: <20231114211804.1449162-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for using the host pointer directly in
scsi_eh_flush_done_q() in a later patch.

Acked-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-eh.c             | 2 +-
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 drivers/scsi/scsi_error.c           | 5 +++--
 include/scsi/scsi_eh.h              | 3 ++-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index b0d6e69c4a5b..ff03c4a6bad9 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -768,7 +768,7 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 	spin_unlock_irqrestore(ap->lock, flags);
 	ata_eh_release(ap);
 
-	scsi_eh_flush_done_q(&ap->eh_done_q);
+	scsi_eh_flush_done_q(host, &ap->eh_done_q);
 
 	/* clean up */
 	spin_lock_irqsave(ap->lock, flags);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9047cfcd1072..dd4fb97fdc4b 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -730,7 +730,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	/* now link into libata eh --- if we have any ata devices */
 	sas_ata_strategy_handler(shost);
 
-	scsi_eh_flush_done_q(&ha->eh_done_q);
+	scsi_eh_flush_done_q(shost, &ha->eh_done_q);
 
 	/* check if any new eh work was scheduled during the last run */
 	spin_lock_irq(&ha->lock);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c67cdcdc3ba8..7390131e7f0a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2188,9 +2188,10 @@ EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
 
 /**
  * scsi_eh_flush_done_q - finish processed commands or retry them.
+ * @shost:	SCSI host pointer.
  * @done_q:	list_head of processed commands.
  */
-void scsi_eh_flush_done_q(struct list_head *done_q)
+void scsi_eh_flush_done_q(struct Scsi_Host *shost, struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
 
@@ -2265,7 +2266,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 	if (shost->eh_deadline != -1)
 		shost->last_reset = 0;
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	scsi_eh_flush_done_q(&eh_done_q);
+	scsi_eh_flush_done_q(shost, &eh_done_q);
 }
 
 /**
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 1ae08e81339f..d2807d799fda 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -11,7 +11,8 @@ struct Scsi_Host;
 
 extern void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
 			       struct list_head *done_q);
-extern void scsi_eh_flush_done_q(struct list_head *done_q);
+extern void scsi_eh_flush_done_q(struct Scsi_Host *shost,
+				 struct list_head *done_q);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
