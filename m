Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81E95C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57BA420768
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uI0NEJH0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbgF3Vu2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729914AbgF3Vu0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:26 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2C8C061755
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g75so20202382wme.5
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=io+Zeq/+U3NiyRaaTcMdFhr8ZIuCHN8lFu3lkOE9z9E=;
        b=uI0NEJH0wcb8tijXxysWs1UGB+ZhKtSJsLbD6LPNYgUUA4w1s4CANv63JPKxLGSL0Q
         umOdm+mBQzSONfqE60IAh0bhzyUwxANq8C7LWszmZTQxMTeNbGi8TJFOF910Sz6jX7IA
         NhReII651ZrdZKVdlke7v/5YtFIMIwQJmlEGta5Sji308UAk2BXnozvNI0HxZmTlFatk
         ECOlZAhLvDa+m5GsSM0wa7sx/8ns4BWi5yLyHtLaVrl0QHxMg+1RAjFzsU/PmXbz+zmk
         ubO4YUCfF7Ba86jbVrYXynbgbq6227VbNl1tIeM7uPcTc6nd+xJt72g8LuX+OaPb8I11
         k1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=io+Zeq/+U3NiyRaaTcMdFhr8ZIuCHN8lFu3lkOE9z9E=;
        b=htKr8VJcnFWcOpOL5xa6mq1JPKVJVe1x+kxcycWE/wvJIr/PWAKWJU3jyZStm0OQk3
         LDBHQH0DPfRkIUT9M5eEoRWKdJKKw9dGIXvpn7SHYuGol7Ux2MnRzROvK+BOKQa17wFy
         +zZOOLxZZHKt6bY+M8E1hfxcoDeRnJ/JzqmIKoq3pVtvM+4ccjhvb3nFxg5cdBbMX5k+
         IZZDFPUPXGBxbHQOefka+uMGnsN/X7r+jpglPLOKdPbeZ+n79jlSW4dHdY3xZwAYckR+
         Q9n97vzPUmEIx+QnNOjK2BZx5nheylNScuE3JuV5cK9n/S+rv6xf/m2BnsJcUMrBb+/Z
         yYxg==
X-Gm-Message-State: AOAM530mORi3W7D5T41zVm0QoH+mf8yNX0lgtaftX2fGaIrvn1j3FrZ2
        iZmgHQ+1Lr7/6PDraX+e1SfQO8TX
X-Google-Smtp-Source: ABdhPJy/5cEqcpFCon8FBWm4I2rslaCZ6fkgXCWQ7PEL+V8TbALq5UcLWPXH+HnNpsR4UKv+DQabbQ==
X-Received: by 2002:a1c:bb44:: with SMTP id l65mr24715364wmf.51.1593553824560;
        Tue, 30 Jun 2020 14:50:24 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:24 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 08/14] lpfc: Fix kdump hang on PPC
Date:   Tue, 30 Jun 2020 14:49:55 -0700
Message-Id: <20200630215001.70793-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When the kdump kernel shuts down lpfc calls flush_work_queue on an
interrupt to schedule the cq handler. When there is only one cpu active
on the kdump kernel, it is possible for the work_on to get scheduled on a
non-active cpu causing it to never be scheduled.

When in the kdump environment, per-cpu affinity of cq's to cpus is not
necessary. In those cases, use a general queue_work rather than a
queue_work_on().

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c439cf9a82c7..2fc8a1db81a4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/fc/fc_fs.h>
 #include <linux/aer.h>
+#include <linux/crash_dump.h>
 #ifdef CONFIG_X86
 #include <asm/set_memory.h>
 #endif
@@ -13723,6 +13724,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 {
 	struct lpfc_queue *cq = NULL, *childq;
 	uint16_t cqid;
+	int ret = 0;
 
 	/* Get the reference to the corresponding CQ */
 	cqid = bf_get_le32(lpfc_eqe_resource_id, eqe);
@@ -13744,7 +13746,12 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba *phba, struct lpfc_eqe *eqe,
 	/* Save EQ associated with this CQ */
 	cq->assoc_qp = speq;
 
-	if (!queue_work_on(cq->chann, phba->wq, &cq->spwork))
+	if (is_kdump_kernel())
+		ret = queue_work(phba->wq, &cq->spwork);
+	else
+		ret = queue_work_on(cq->chann, phba->wq, &cq->spwork);
+
+	if (!ret)
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0390 Cannot schedule soft IRQ "
 				"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
@@ -13857,6 +13864,7 @@ __lpfc_sli4_sp_process_cq(struct lpfc_queue *cq)
 	struct lpfc_hba *phba = cq->phba;
 	unsigned long delay;
 	bool workposted = false;
+	int ret = 0;
 
 	/* Process and rearm the CQ */
 	switch (cq->type) {
@@ -13883,8 +13891,13 @@ __lpfc_sli4_sp_process_cq(struct lpfc_queue *cq)
 	}
 
 	if (delay) {
-		if (!queue_delayed_work_on(cq->chann, phba->wq,
-					   &cq->sched_spwork, delay))
+		if (is_kdump_kernel())
+			ret = queue_delayed_work(phba->wq, &cq->sched_spwork,
+						delay);
+		else
+			ret = queue_delayed_work_on(cq->chann, phba->wq,
+						&cq->sched_spwork, delay);
+		if (!ret)
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0394 Cannot schedule soft IRQ "
 				"for cqid=%d on CPU %d\n",
@@ -14236,6 +14249,7 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_queue *eq,
 	struct lpfc_queue *cq = NULL;
 	uint32_t qidx = eq->hdwq;
 	uint16_t cqid, id;
+	int ret = 0;
 
 	if (unlikely(bf_get_le32(lpfc_eqe_major_code, eqe) != 0)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -14295,7 +14309,11 @@ lpfc_sli4_hba_handle_eqe(struct lpfc_hba *phba, struct lpfc_queue *eq,
 	else
 		cq->isr_timestamp = 0;
 #endif
-	if (!queue_work_on(cq->chann, phba->wq, &cq->irqwork))
+	if (is_kdump_kernel())
+		ret = queue_work(phba->wq, &cq->irqwork);
+	else
+		ret = queue_work_on(cq->chann, phba->wq, &cq->irqwork);
+	if (!ret)
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0363 Cannot schedule soft IRQ "
 				"for CQ eqcqid=%d, cqid=%d on CPU %d\n",
@@ -14323,14 +14341,20 @@ __lpfc_sli4_hba_process_cq(struct lpfc_queue *cq)
 	struct lpfc_hba *phba = cq->phba;
 	unsigned long delay;
 	bool workposted = false;
+	int ret = 0;
 
 	/* process and rearm the CQ */
 	workposted |= __lpfc_sli4_process_cq(phba, cq, lpfc_sli4_fp_handle_cqe,
 					     &delay);
 
 	if (delay) {
-		if (!queue_delayed_work_on(cq->chann, phba->wq,
-					   &cq->sched_irqwork, delay))
+		if (is_kdump_kernel())
+			ret = queue_delayed_work(phba->wq, &cq->sched_irqwork,
+						delay);
+		else
+			ret = queue_delayed_work_on(cq->chann, phba->wq,
+						&cq->sched_irqwork, delay);
+		if (!ret)
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0367 Cannot schedule soft IRQ "
 				"for cqid=%d on CPU %d\n",
-- 
2.25.0

