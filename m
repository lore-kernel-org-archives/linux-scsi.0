Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BACC4727C
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 15:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E30DD2085B
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 15:51:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sslab.ics.keio.ac.jp header.i=@sslab.ics.keio.ac.jp header.b="f3RBVLLI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgI3PvO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 11:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3PvO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2020 11:51:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD14C061755
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2020 08:51:14 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x5so1281406plo.6
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2020 08:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vpAOYUtfsOyAnKG5VAGbK9i/Ip7+aawrrhrrv5e7Aow=;
        b=f3RBVLLIxzZH0O+nmMeo4aAZ/5pDTI5pFFd7hPJEQNI4d9h2/IXnVGAS9oy1GRMLPv
         22WHfdrYrR2Xze3Ubmk8qql6DTlpb54OUs6KVISU4qZJRzgwVvKAWRcAWjVH9X8CQJ5w
         YMSKo3P5PgDvF5nzhm0i/FvAeTUnRvw9gNxAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vpAOYUtfsOyAnKG5VAGbK9i/Ip7+aawrrhrrv5e7Aow=;
        b=KaDQZn6zQLBRbp2mOLMEe+61YJrX9HVCB78CiEG6yiWD59ZpLe9oa77VMVxNmydS3Z
         PaYPgEpwxqXmsSkFf+3qZ9N8Q/TaTVtGjfTgRJtoP4rckWpwvLsM52vBRjovQROWWWUZ
         eIFiVe0jh2NgovTdiAd2CsqZrsDIrQiRQxiUssSq/u8vXp+gia4yKCtv7pxLtSmvxBY/
         2tO0fiV9txN5g0r5giiJ99Z0gcTzDU7uws1Teo4dfZRhytMgonS1pBSDqLxFM1KzfWFk
         Fz/Vo32gKXDz3GlUtaUrhVB7u7UeaOvp07V58tPsvo0Ib414trU6/1QdbVrhSxlYTheh
         Gy9Q==
X-Gm-Message-State: AOAM533YZmKwnCA1cO/WWH8BJV2sacevgL9metmbyRYi+lAsKmxdlF+A
        v9QIqKNhxFxntOWPmECGHtiNlQ==
X-Google-Smtp-Source: ABdhPJzHs0GayQ9rUgfEDKB4ax/PNP+Us+d3WU+XwlorKT3a0zGMeb844e3NFc+EANxiNp6A1d4CtA==
X-Received: by 2002:a17:90a:ee0d:: with SMTP id e13mr3287288pjy.227.1601481073583;
        Wed, 30 Sep 2020 08:51:13 -0700 (PDT)
Received: from brooklyn.i.sslab.ics.keio.ac.jp (sslab-relay.ics.keio.ac.jp. [131.113.126.173])
        by smtp.googlemail.com with ESMTPSA id a18sm2505677pgw.50.2020.09.30.08.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 08:51:12 -0700 (PDT)
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     keitasuzuki.park@sslab.ics.keio.ac.jp,
        takafumi@sslab.ics.keio.ac.jp, Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kevin Barnett <kevin.barnett@microsemi.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Scott Teel <scott.teel@microsemi.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2] scsi: hpsa: fix memory leak in hpsa_init_one
Date:   Wed, 30 Sep 2020 15:50:59 +0000
Message-Id: <20200930155100.11528-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When hpsa_scsi_add_host fails, h->lastlogicals is leaked since it lacks
free in the error handler.

Fix this by adding free when hpsa_scsi_add_host fails.

This patch also renames the numbered labels to detailed names.

Fixes: cf47723763a7 ("hpsa: correct initialization order issue")
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
---
 drivers/scsi/hpsa.c | 52 +++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 48d5da59262b..4911ca22efe4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8691,19 +8691,19 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!h->lockup_detected) {
 		dev_err(&h->pdev->dev, "Failed to allocate lockup detector\n");
 		rc = -ENOMEM;
-		goto clean1;	/* aer/h */
+		goto out_destroy_workqueue;	/* aer/h */
 	}
 	set_lockup_detected_for_all_cpus(h, 0);
 
 	rc = hpsa_pci_init(h);
 	if (rc)
-		goto clean2;	/* lu, aer/h */
+		goto out_free_lockup_detected;	/* lu, aer/h */
 
 	/* relies on h-> settings made by hpsa_pci_init, including
 	 * interrupt_mode h->intr */
 	rc = hpsa_scsi_host_alloc(h);
 	if (rc)
-		goto clean2_5;	/* pci, lu, aer/h */
+		goto out_free_pci_init;	/* pci, lu, aer/h */
 
 	sprintf(h->devname, HPSA "%d", h->scsi_host->host_no);
 	h->ctlr = number_of_controllers;
@@ -8719,7 +8719,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			dac = 0;
 		} else {
 			dev_err(&pdev->dev, "no suitable DMA available\n");
-			goto clean3;	/* shost, pci, lu, aer/h */
+			goto out_scsi_host_put;	/* shost, pci, lu, aer/h */
 		}
 	}
 
@@ -8728,13 +8728,13 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rc = hpsa_request_irqs(h, do_hpsa_intr_msi, do_hpsa_intr_intx);
 	if (rc)
-		goto clean3;	/* shost, pci, lu, aer/h */
+		goto out_scsi_host_put;	/* shost, pci, lu, aer/h */
 	rc = hpsa_alloc_cmd_pool(h);
 	if (rc)
-		goto clean4;	/* irq, shost, pci, lu, aer/h */
+		goto out_free_irqs;	/* irq, shost, pci, lu, aer/h */
 	rc = hpsa_alloc_sg_chain_blocks(h);
 	if (rc)
-		goto clean5;	/* cmd, irq, shost, pci, lu, aer/h */
+		goto out_free_cmd_pool;	/* cmd, irq, shost, pci, lu, aer/h */
 	init_waitqueue_head(&h->scan_wait_queue);
 	init_waitqueue_head(&h->event_sync_wait_queue);
 	mutex_init(&h->reset_mutex);
@@ -8747,25 +8747,25 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	spin_lock_init(&h->devlock);
 	rc = hpsa_put_ctlr_into_performant_mode(h);
 	if (rc)
-		goto clean6; /* sg, cmd, irq, shost, pci, lu, aer/h */
+		goto out_free_sg_chain_blocks; /* sg, cmd, irq, shost, pci, lu, aer/h */
 
 	/* create the resubmit workqueue */
 	h->rescan_ctlr_wq = hpsa_create_controller_wq(h, "rescan");
 	if (!h->rescan_ctlr_wq) {
 		rc = -ENOMEM;
-		goto clean7;
+		goto out_free_performant_mode;
 	}
 
 	h->resubmit_wq = hpsa_create_controller_wq(h, "resubmit");
 	if (!h->resubmit_wq) {
 		rc = -ENOMEM;
-		goto clean7;	/* aer/h */
+		goto out_free_performant_mode;	/* aer/h */
 	}
 
 	h->monitor_ctlr_wq = hpsa_create_controller_wq(h, "monitor");
 	if (!h->monitor_ctlr_wq) {
 		rc = -ENOMEM;
-		goto clean7;
+		goto out_free_performant_mode;
 	}
 
 	/*
@@ -8795,20 +8795,20 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			 * cannot goto clean7 or free_irqs will be called
 			 * again. Instead, do its work
 			 */
-			hpsa_free_performant_mode(h);	/* clean7 */
-			hpsa_free_sg_chain_blocks(h);	/* clean6 */
-			hpsa_free_cmd_pool(h);		/* clean5 */
+			hpsa_free_performant_mode(h);	/* out_free_performant_mode */
+			hpsa_free_sg_chain_blocks(h);	/* out_free_sg_chain_blocks */
+			hpsa_free_cmd_pool(h);		/* out_free_cmd_pool */
 			/*
 			 * skip hpsa_free_irqs(h) clean4 since that
 			 * was just called before request_irqs failed
 			 */
-			goto clean3;
+			goto out_scsi_host_put;
 		}
 
 		rc = hpsa_kdump_soft_reset(h);
 		if (rc)
 			/* Neither hard nor soft reset worked, we're hosed. */
-			goto clean7;
+			goto out_free_performant_mode;
 
 		dev_info(&h->pdev->dev, "Board READY.\n");
 		dev_info(&h->pdev->dev,
@@ -8854,7 +8854,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* hook into SCSI subsystem */
 	rc = hpsa_scsi_add_host(h);
 	if (rc)
-		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
+		goto out_free_lastlogicals; /* ll, perf, sg, cmd, irq, shost, pci, lu, aer/h */
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
@@ -8869,26 +8869,28 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				HPSA_EVENT_MONITOR_INTERVAL);
 	return 0;
 
-clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
+out_free_lastlogicals: /* ll, perf, sg, cmd, irq, shost, pci, lu, aer/h */
+	kfree(h->lastlogicals);
+out_free_performant_mode: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_performant_mode(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-clean6: /* sg, cmd, irq, pci, lockup, wq/aer/h */
+out_free_sg_chain_blocks: /* sg, cmd, irq, pci, lockup, wq/aer/h */
 	hpsa_free_sg_chain_blocks(h);
-clean5: /* cmd, irq, shost, pci, lu, aer/h */
+out_free_cmd_pool: /* cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_cmd_pool(h);
-clean4: /* irq, shost, pci, lu, aer/h */
+out_free_irqs: /* irq, shost, pci, lu, aer/h */
 	hpsa_free_irqs(h);
-clean3: /* shost, pci, lu, aer/h */
+out_scsi_host_put: /* shost, pci, lu, aer/h */
 	scsi_host_put(h->scsi_host);
 	h->scsi_host = NULL;
-clean2_5: /* pci, lu, aer/h */
+out_free_pci_init: /* pci, lu, aer/h */
 	hpsa_free_pci_init(h);
-clean2: /* lu, aer/h */
+out_free_lockup_detected: /* lu, aer/h */
 	if (h->lockup_detected) {
 		free_percpu(h->lockup_detected);
 		h->lockup_detected = NULL;
 	}
-clean1:	/* wq/aer/h */
+out_destroy_workqueue:	/* wq/aer/h */
 	if (h->resubmit_wq) {
 		destroy_workqueue(h->resubmit_wq);
 		h->resubmit_wq = NULL;
-- 
2.17.1

