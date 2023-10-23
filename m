Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B4BBC25B46
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 21:57:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbjJWV5G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 17:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbjJWV5D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 17:57:03 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3BA10D3;
        Mon, 23 Oct 2023 14:56:59 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-27d104fa285so3271434a91.2;
        Mon, 23 Oct 2023 14:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698098219; x=1698703019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IMmTgdt0sRo6a6NvHol68KyIZZ4Zv+cZHY8Wdw0Zpt0=;
        b=blef7qEipNcN1iCjwn8ezuZharF3kli/NZfpfo8SCK6zVt8/Z+uRWOr6YiISYMmaGY
         42EDn0RpzMuFdubRIRkIzcd7oIsgR9op/urrUpxaytTtcfeJDKao/GWUQgBPIeN33DeY
         ZusDlWx4TdpkUIsSMRaHsinuFf0sDuVmuoWDRxDSqA5/LvIPxowLAwbt3okkP4cCVLC/
         kigmUQs29XzLJOZ3mfowlojZRevxEykgzYHfQCxJXBcdZQDNLhDyl/4WptEMeMta/dgT
         o6etgaaSg1A7Rx+kl/ie9AoIEqUQT4GrE0yAWq98tJZn0KZ/D4J/DjER/KQu44Fl5z4X
         UZmA==
X-Gm-Message-State: AOJu0YwRhj6QlloyfeNabasLz7yvfeXZV5rPiqZyPITuh5bxfKdbsSVp
        dz2L+2tnUQEVglGFPpj92Nlm7KkyQAs=
X-Google-Smtp-Source: AGHT+IFSYWod3gz2NJ0PLxDcdtkNj17oMNzmmwucZAmfxjwUtF3yLPxwD2h2khPvSEeNp141ht/JcA==
X-Received: by 2002:a17:90a:d407:b0:27d:7ebe:2e8 with SMTP id r7-20020a17090ad40700b0027d7ebe02e8mr11215883pju.9.1698098218958;
        Mon, 23 Oct 2023 14:56:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090acc0c00b0027d12b1e29dsm7851029pju.25.2023.10.23.14.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 14:56:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.g.garry@oracle.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH v14 05/19] scsi: Add an argument to scsi_eh_flush_done_q()
Date:   Mon, 23 Oct 2023 14:53:56 -0700
Message-ID: <20231023215638.3405959-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
In-Reply-To: <20231023215638.3405959-1-bvanassche@acm.org>
References: <20231023215638.3405959-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch prepares for using the host pointer directly in
scsi_eh_flush_done_q() in a later patch.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-eh.c             | 2 +-
 drivers/scsi/libsas/sas_scsi_host.c | 2 +-
 drivers/scsi/scsi_error.c           | 5 +++--
 include/scsi/scsi_eh.h              | 3 ++-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 4cf4f57e57b8..9a1a06a8e5db 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -738,7 +738,7 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
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
