Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05083C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1C5661410
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbhGAVPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:17 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:54267 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbhGAVPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:17 -0400
Received: by mail-pj1-f43.google.com with SMTP id q91so5074616pjk.3
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:12:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ACIV/Uv9G7E37R3LvG77aEJt5LYtj5RU4MTXVZOrnX0=;
        b=BRyx6N2mPvFu53dNcf5gC+IxlXnxS9UfLUpuVAuyKSyM8WtsNXfnPU+YaJ4/TUT98n
         +YKtVNrTg4N2tAfP5vibB8x0I6FjgtElmII814G5Vxyk3QcVEfrA3qu+S+Fwev1iiEB0
         6RBsl21hQjRZHf2UOy/JhkzovLNMkLG8jUn/Jyv86Ks5BdbLOH9udYB44/1+IhF/CFgo
         pLS5Q17OJAjJs7MRuuMT0cLgjRZhi6vFIt9xNhSiu80JG4E+Ifpr57AcbPA3IX+dugXg
         1nzug1co/sy/IQfoK9AM4KmatFu5zHJ8msnpCbWQsxENARnn1IV4EwT7SMXPkEXzEzMh
         E6ew==
X-Gm-Message-State: AOAM533dDTGdVOykVh9+pXq+CS2PucgBmF4HZh3tG7DVoIo8iIlDJGW7
        BeExHTMH7OrWh6BXQSBp94U=
X-Google-Smtp-Source: ABdhPJwAyu6wuVEAIMnG3IosFk9vCKtB39wD50mUA9PFo0zgNJlc1Cbdb+e/QqiQ+ho3kAYKwqmcMA==
X-Received: by 2002:a17:90a:108f:: with SMTP id c15mr1516388pja.152.1625173965541;
        Thu, 01 Jul 2021 14:12:45 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:12:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 05/21] ata: Stop clearing host_eh_scheduled from error handlers
Date:   Thu,  1 Jul 2021 14:12:08 -0700
Message-Id: <20210701211224.17070-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that the caller of sas_ata_strategy_handler() clears host_eh_scheduled,
remove the code from the ATA core that that clears host_eh_scheduled.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-core.c |  2 --
 drivers/ata/libata-eh.c   | 30 +++---------------------------
 include/linux/libata.h    |  1 -
 3 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 61c762961ca8..b26fb305a56f 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -69,7 +69,6 @@ const struct ata_port_operations ata_base_port_ops = {
 	.postreset		= ata_std_postreset,
 	.error_handler		= ata_std_error_handler,
 	.sched_eh		= ata_std_sched_eh,
-	.end_eh			= ata_std_end_eh,
 };
 
 const struct ata_port_operations sata_port_ops = {
@@ -6419,7 +6418,6 @@ struct ata_port_operations ata_dummy_port_ops = {
 	.qc_issue		= ata_dummy_qc_issue,
 	.error_handler		= ata_dummy_error_handler,
 	.sched_eh		= ata_std_sched_eh,
-	.end_eh			= ata_std_end_eh,
 };
 EXPORT_SYMBOL_GPL(ata_dummy_port_ops);
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bb3637762985..e88ffbe31a36 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -724,12 +724,9 @@ void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
 		ata_for_each_link(link, ap, HOST_FIRST)
 			memset(&link->eh_info, 0, sizeof(link->eh_info));
 
-		/* end eh (clear host_eh_scheduled) while holding
-		 * ap->lock such that if exception occurs after this
-		 * point but before EH completion, SCSI midlayer will
-		 * re-initiate EH.
-		 */
-		ap->ops->end_eh(ap);
+		/* end eh while holding ap->lock */
+		if (ap->ops->end_eh)
+			ap->ops->end_eh(ap);
 
 		spin_unlock_irqrestore(ap->lock, flags);
 		ata_eh_release(ap);
@@ -936,27 +933,6 @@ void ata_std_sched_eh(struct ata_port *ap)
 }
 EXPORT_SYMBOL_GPL(ata_std_sched_eh);
 
-/**
- * ata_std_end_eh - non-libsas ata_ports complete eh with this common routine
- * @ap: ATA port to end EH for
- *
- * In the libata object model there is a 1:1 mapping of ata_port to
- * shost, so host fields can be directly manipulated under ap->lock, in
- * the libsas case we need to hold a lock at the ha->level to coordinate
- * these events.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-void ata_std_end_eh(struct ata_port *ap)
-{
-	struct Scsi_Host *host = ap->scsi_host;
-
-	host->host_eh_scheduled = 0;
-}
-EXPORT_SYMBOL(ata_std_end_eh);
-
-
 /**
  *	ata_port_schedule_eh - schedule error handling without a qc
  *	@ap: ATA port to schedule EH for
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5f550eb27f81..88f4f7e466fb 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1356,7 +1356,6 @@ extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 		      ata_postreset_fn_t postreset);
 extern void ata_std_error_handler(struct ata_port *ap);
 extern void ata_std_sched_eh(struct ata_port *ap);
-extern void ata_std_end_eh(struct ata_port *ap);
 extern int ata_link_nr_enabled(struct ata_link *link);
 
 /*
