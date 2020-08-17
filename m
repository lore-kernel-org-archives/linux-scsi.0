Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6FBEC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C465920829
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:55:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q2RqlflI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgHQIzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728640AbgHQIzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:55:06 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4857FC061388;
        Mon, 17 Aug 2020 01:55:06 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id m71so7911119pfd.1;
        Mon, 17 Aug 2020 01:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=i3YmxLHQm4C9rpRDNyqYBl1hzYIOBuXCpBG9eSqKocA=;
        b=q2RqlflIosSWjEW5ihBRffG2ydwOfneUbuVPVIL0V607PveCwS51neeFaDxHEru92A
         GPu+J3VM9xNFWMCAM/fm74Q9+6JPkYqpWfXkiP8BqUnjWXA1poZxUbd4787LZ0v+Xu3M
         lvc8qTZTaUaVZ+5Sqsy1CjGA7YLKVsPKqtIzofNCD4pfpT00xOfxiU2tDd4Ye9b1ISOy
         D+A0zgBsBSwJsoSRKsftsx/X+ATutKj9lwKDgFlDWHsrbwpo9Ajy8eaYBPhWaBMe+oLT
         ugAKpcR28ytIp/TofY9ZLsjij9EkYWxlgG3Avk39Bd+m1Fr74uMRrmrfU150hk0aS9ij
         KVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i3YmxLHQm4C9rpRDNyqYBl1hzYIOBuXCpBG9eSqKocA=;
        b=KB0n2apoU6MOfGFtxfwgeu2uGz/CP16VAe/yUUd8p33Sqw8IoFQVXZ4yCT5THD14ar
         eruoqRkYKCVJbpRg7o4coVt33P1iKp2XVm1d9GUQPYSxB2rRfEue8jVMQ5zk24aShnqu
         7KD2UC/XAVa2tiCmRG59aNaN/d4PnVYLRj9sb/GYMkk2kMGWAinHPL+7NL1lQhZdCL1H
         c7glL+77hiJqmTSsOmHr5xeWWMe2r7PPbVC+WrZPxUI5UZ2yEopOky5Aps5nqR3VQOTl
         GquwJLmoTZI/fQmIJiuWcIySND42SQ4J9G5D1j99CalDgKQTdLHvt0972qAPZV7tOl+b
         4GzA==
X-Gm-Message-State: AOAM532SNZCDuIkucGMdyszXCeDUoXWPp66QWx/We5NairdR1JOebI/Y
        gea9H6r9i6hboE4HLcfllX0=
X-Google-Smtp-Source: ABdhPJwFE528F8McvzPMZNZ9fzvA/dqHQ1qHYLBTKwXGtLq3IheQPon7tMzbcyScOIfbM/xxS7FitA==
X-Received: by 2002:a63:3d06:: with SMTP id k6mr9544204pga.316.1597654505767;
        Mon, 17 Aug 2020 01:55:05 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id x12sm18236990pff.48.2020.08.17.01.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:55:05 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     keescook@chromium.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 8/8] scsi: pmcraid: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:24:09 +0530
Message-Id: <20200817085409.25268-9-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817085409.25268-1-allen.cryptic@gmail.com>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/pmcraid.c | 29 +++++++++++++++--------------
 drivers/scsi/pmcraid.h |  9 +++++++--
 2 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index aa9ae2ae8579..b7bbefcbb11d 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4198,7 +4198,7 @@ static irqreturn_t pmcraid_isr_msix(int irq, void *dev_id)
 		}
 	}
 
-	tasklet_schedule(&(pinstance->isr_tasklet[hrrq_id]));
+	tasklet_schedule(&(pinstance->isr_tasklet[hrrq_id]).tasklet);
 
 	return IRQ_HANDLED;
 }
@@ -4267,7 +4267,7 @@ static irqreturn_t pmcraid_isr(int irq, void *dev_id)
 				pinstance->int_regs.ioa_host_interrupt_clr_reg);
 
 			tasklet_schedule(
-					&(pinstance->isr_tasklet[hrrq_id]));
+				&(pinstance->isr_tasklet[hrrq_id].tasklet));
 		}
 	}
 
@@ -4380,20 +4380,20 @@ static void pmcraid_worker_function(struct work_struct *workp)
  * Return Value
  *	None
  */
-static void pmcraid_tasklet_function(unsigned long instance)
+static void pmcraid_tasklet_function(struct tasklet_struct *t)
 {
-	struct pmcraid_isr_param *hrrq_vector;
-	struct pmcraid_instance *pinstance;
+	struct pmcraid_tsk_param *tsk_param = from_tasklet(tsk_param, t,
+							   tasklet);
+	int id = tsk_param->isr_tasklet_id;
+	struct pmcraid_instance *pinstance = container_of(tsk_param,
+							  typeof(*pinstance),
+							  isr_tasklet[id]);
 	unsigned long hrrq_lock_flags;
 	unsigned long pending_lock_flags;
 	unsigned long host_lock_flags;
 	spinlock_t *lockp; /* hrrq buffer lock */
-	int id;
 	u32 resp;
 
-	hrrq_vector = (struct pmcraid_isr_param *)instance;
-	pinstance = hrrq_vector->drv_inst;
-	id = hrrq_vector->hrrq_id;
 	lockp = &(pinstance->hrrq_lock[id]);
 
 	/* loop through each of the commands responded by IOA. Each HRRQ buf is
@@ -4882,10 +4882,11 @@ static int pmcraid_allocate_config_buffers(struct pmcraid_instance *pinstance)
 static void pmcraid_init_tasklets(struct pmcraid_instance *pinstance)
 {
 	int i;
-	for (i = 0; i < pinstance->num_hrrq; i++)
-		tasklet_init(&pinstance->isr_tasklet[i],
-			     pmcraid_tasklet_function,
-			     (unsigned long)&pinstance->hrrq_vector[i]);
+	for (i = 0; i < pinstance->num_hrrq; i++) {
+		pinstance->isr_tasklet[i].isr_tasklet_id = i;
+		tasklet_setup(&pinstance->isr_tasklet[i].tasklet,
+			     pmcraid_tasklet_function);
+	}
 }
 
 /**
@@ -4900,7 +4901,7 @@ static void pmcraid_kill_tasklets(struct pmcraid_instance *pinstance)
 {
 	int i;
 	for (i = 0; i < pinstance->num_hrrq; i++)
-		tasklet_kill(&pinstance->isr_tasklet[i]);
+		tasklet_kill(&pinstance->isr_tasklet[i].tasklet);
 }
 
 /**
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 15c962108075..68dab849d4c1 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -617,6 +617,11 @@ struct pmcraid_isr_param {
 	u8 hrrq_id;			/* hrrq entry index */
 };
 
+/* Tasklet parameters (one for each enabled tasklet) */
+struct pmcraid_tsk_param {
+	struct tasklet_struct tasklet;
+	u8 isr_tasklet_id;              /* isr_tasklet entry index */
+};
 
 /* AEN message header sent as part of event data to applications */
 struct pmcraid_aen_msg {
@@ -752,8 +757,8 @@ struct pmcraid_instance {
 	spinlock_t free_pool_lock;		/* free pool lock */
 	spinlock_t pending_pool_lock;		/* pending pool lock */
 
-	/* Tasklet to handle deferred processing */
-	struct tasklet_struct isr_tasklet[PMCRAID_NUM_MSIX_VECTORS];
+	/* Tasklet parameters and tasklets to handle deferred processing */
+	struct pmcraid_tsk_param isr_tasklet[PMCRAID_NUM_MSIX_VECTORS];
 
 	/* Work-queue (Shared) for deferred reset processing */
 	struct work_struct worker_q;
-- 
2.17.1

