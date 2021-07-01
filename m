Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C220C11F67
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61F246128A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbhGAVPK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:15:10 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:36416 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbhGAVPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:15:10 -0400
Received: by mail-pg1-f182.google.com with SMTP id e33so7394621pgm.3
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:12:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s20zXO0dLIDFGzVBLRtuSwjiyxrUNmAGgZq5yA2U39M=;
        b=MccNjE8f+loY61qCDuOIz7IhfXl/fCczzb/XAZZq0Ifrf7TaaMo0OH7RvZpyNfXsxA
         yNmCkFr7RJeBjG9QCkhtYCDu5fhAXoZpR1cTDr7kXwMAUKQQjFhBJFJHnNHLELnY3ZIj
         pPaEbRsbjvL3Y8zfFPJYJkpnhxamk5ZQxoOj2hjLG44VvbyxcpEq3xo9UfmrD14rlIvN
         p++XNu0ZbfsxNT5HhxGJ/apQb19NIzMQfxSdUnO8my5iimXMbkg1TeH9rmf56/jSiBsA
         z29XrB38NksMYETFOWWVLQeaWfZpgD8EIKAQXbX1vJFtVzG7prAH3CL5un/mWuNga1gM
         GAYA==
X-Gm-Message-State: AOAM531/uaMxRb/dniW5/XytNzSV9ycTFroQ14BHw/EMbFP9JnXIg3P3
        oIMAeAsUSNlJKtXd6WMkZvw=
X-Google-Smtp-Source: ABdhPJxKgRZUPe9yrFe+fJvoKpleYJw/mdVEzUKw+oCTTzB3WkhRN0gsJvIiIN8D3NiIKkQS53ol+w==
X-Received: by 2002:a65:6658:: with SMTP id z24mr1493619pgv.266.1625173958262;
        Thu, 01 Jul 2021 14:12:38 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:12:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH 02/21] libsas: Only abort commands from inside the error handler
Date:   Thu,  1 Jul 2021 14:12:05 -0700
Message-Id: <20210701211224.17070-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to the information I found in patch commit descriptions, for SATA
devices commands must be aborted from inside the libsas error handler.
Check host->ehandler to determine whether or not running inside the error
handler since host->host_eh_scheduled != 0 indicates that the SCSI error
handler has been scheduled but does not mean that is already running. This
patch restores code that was removed by commit 909657615d9b ("scsi: libsas:
allow async aborts").

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Yves-Alexis Perez <corsac@debian.org>
Fixes: c9f926000fe3 ("scsi: libsas: Disable asynchronous aborts for SATA devices")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libsas/sas_scsi_host.c | 5 ++++-
 include/scsi/libsas.h               | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index ee44a0d7730b..95e4d58ab9d4 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -462,6 +462,7 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 	int res = TMF_RESP_FUNC_FAILED;
 	struct sas_task *task = TO_SAS_TASK(cmd);
 	struct Scsi_Host *host = cmd->device->host;
+	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(host);
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct sas_internal *i = to_sas_internal(host->transportt);
 	unsigned long flags;
@@ -471,7 +472,7 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 
 	spin_lock_irqsave(host->host_lock, flags);
 	/* We cannot do async aborts for SATA devices */
-	if (dev_is_sata(dev) && !host->host_eh_scheduled) {
+	if (dev_is_sata(dev) && !ha->eh_running) {
 		spin_unlock_irqrestore(host->host_lock, flags);
 		return FAILED;
 	}
@@ -731,6 +732,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 	tries++;
 	retry = true;
 	spin_lock_irq(shost->host_lock);
+	ha->eh_running = true;
 	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
 	spin_unlock_irq(shost->host_lock);
 
@@ -767,6 +769,7 @@ void sas_scsi_recover_host(struct Scsi_Host *shost)
 
 	/* check if any new eh work was scheduled during the last run */
 	spin_lock_irq(&ha->lock);
+	ha->eh_running = false;
 	if (ha->eh_active == 0) {
 		shost->host_eh_scheduled = 0;
 		retry = false;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 6fe125a71b60..4a8fb324140e 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -364,6 +364,7 @@ struct sas_ha_struct {
 	struct mutex	  drain_mutex;
 	unsigned long	  state;
 	spinlock_t	  lock;
+	bool		  eh_running;
 	int		  eh_active;
 	wait_queue_head_t eh_wait_q;
 	struct list_head  eh_dev_q;
