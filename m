Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00768CA9EAB
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9A712089C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vJs5Daeg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503023AbfJRVTM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:19:12 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34894 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502466AbfJRVTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:19:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id 205so4619495pfw.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GOFcf4eRhVQiqMYL+TG4stH9Od9veSUGc3DLLx0Y+cA=;
        b=vJs5DaegoKjjoRYlZhsx0cn+TkRnJ4rRF+NrxfQozwiUq7Lm3Pw9EAykM6aa/V+5vt
         PzUjtvvlpUxhmxtR3UnKT+GuLR++J3kdacrlikQJ8vKXM/G6s1KKd3/kXr9/TYvOyKc+
         FPuVhAd67nl9NYRPQz7n+IzUYOk044uQw5VRF82sHqD28CaBKTjup/x35CyWWJePFA7k
         NhbAttUwqv+8YlF982I772OpFfTPp0ksel7n6Ox2RYWW23WTg781AZ3qXrlDNiGs7m7L
         cE1ZZytys8SqisLv0UsgS3M4W+h//qdkF593Pb8cUlZPz/2hc0U5CjXVfNcXm2m4LtZr
         rTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GOFcf4eRhVQiqMYL+TG4stH9Od9veSUGc3DLLx0Y+cA=;
        b=ASsi9LX0OUnEHIoq8LDluHx8TvPF6kUBudP4dXsU5J/yB+oEswcJKRveW+S8CLnaz1
         U0JpNv0bnCv1svVx8CcEpoyiifnkt3qiUfQIbiTdVdLoCaaBjTXELeMhY14pv7EH/vHg
         X2xUQDkgFQNK6HOrGNDciIwaPaA90InzawCesLDSnvMyygtvLY/aGazwird7PmP8rlRi
         +YaEuj5OvXcprVAPUiED9J6Ez7NCjcCjArg99bhq0a6Nr3095j5BjjOp6ZmWR4PPnn9/
         3Z6OHwiDXWkpkmy8Iox1Yw00oNzKO6mfJqMAiQYbzSamxDBm808tpRt9qDrSB7KaM7b7
         z1gQ==
X-Gm-Message-State: APjAAAUHgbv16DpnEOrkofFfy+GfF5gnEqJTmYDUogtEHyvyNkbP8mJu
        M/aAOHzafyICzNctQjrBfK0lY2NF
X-Google-Smtp-Source: APXvYqz1ozb6nhamUu++VnXOl0dgnAHzNO+vHaEAbN6+G58MLiglbmQ9DPyRb2Gj0mILVZL99Ytl9w==
X-Received: by 2002:a17:90a:3608:: with SMTP id s8mr13713115pjb.44.1571433551315;
        Fri, 18 Oct 2019 14:19:11 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 22sm7538878pfo.131.2019.10.18.14.19.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 18 Oct 2019 14:19:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 10/16] lpfc: Revise interrupt coalescing for missing scenarios
Date:   Fri, 18 Oct 2019 14:18:26 -0700
Message-Id: <20191018211832.7917-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191018211832.7917-1-jsmart2021@gmail.com>
References: <20191018211832.7917-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The existing "auto eq delay" mechanism was sometimes skipping over
an eq, not ramping the coalescing down under light load fast enough,
and in other cases never kicked in as cpu sharing by multiple vectors
didn't quite add up right.

Tweak the interrupt mechanism such that:
- Add a flag to the eq to force checking for colaescing values
  when being serviced in the interrupt handler.  The flag will
  be set by any CQ bound to the EQ whenever the number of CQ
  elements process in a single scan meets or exceeds the hardware
  queue notify level. E.g. there's a significant number of
  completions happening.
- In the heartbeat work item that checks coalescing:
 - Replace the structure that was counting the number of EQs
   that interrupted on a single cpu with a new structure that
   looks at the EQ to see whether EQ currently has a coalescing
   value (thus it should be re-evaluate) or was marked by the
   new flag indicating heavy completions.
 - When a cpu, which may be servicing multiple vectors, had
   at least 1 EQ that should be checked, a new coalescing delay
   is calculated based on the number of interrupts that occurred
   on the cpu.
 - The new coalescing value is then applied to the EQs that
   had interrupted on the cpu.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  1 -
 drivers/scsi/lpfc/lpfc_init.c | 51 ++++++++++++++++++-------------------------
 drivers/scsi/lpfc/lpfc_sli.c  |  3 ++-
 drivers/scsi/lpfc/lpfc_sli4.h |  1 +
 4 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 1cd3016f7783..ac86b80230e7 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -210,7 +210,6 @@ struct lpfc_sli_intf {
 #define LPFC_MAX_IMAX          5000000
 #define LPFC_DEF_IMAX          0
 
-#define LPFC_IMAX_THRESHOLD    1000
 #define LPFC_MAX_AUTO_EQ_DELAY 120
 #define LPFC_EQ_DELAY_STEP     15
 #define LPFC_EQD_ISR_TRIGGER   20000
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 8292b66e4b07..316a2c2beb0c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1235,10 +1235,9 @@ lpfc_hb_eq_delay_work(struct work_struct *work)
 					     struct lpfc_hba, eq_delay_work);
 	struct lpfc_eq_intr_info *eqi, *eqi_new;
 	struct lpfc_queue *eq, *eq_next;
-	unsigned char *eqcnt = NULL;
+	unsigned char *ena_delay = NULL;
 	uint32_t usdelay;
 	int i;
-	bool update = false;
 
 	if (!phba->cfg_auto_imax || phba->pport->load_flag & FC_UNLOADING)
 		return;
@@ -1247,44 +1246,36 @@ lpfc_hb_eq_delay_work(struct work_struct *work)
 	    phba->pport->fc_flag & FC_OFFLINE_MODE)
 		goto requeue;
 
-	eqcnt = kcalloc(num_possible_cpus(), sizeof(unsigned char),
-			GFP_KERNEL);
-	if (!eqcnt)
+	ena_delay = kcalloc(phba->sli4_hba.num_possible_cpu, sizeof(*ena_delay),
+			    GFP_KERNEL);
+	if (!ena_delay)
 		goto requeue;
 
-	if (phba->cfg_irq_chann > 1) {
-		/* Loop thru all IRQ vectors */
-		for (i = 0; i < phba->cfg_irq_chann; i++) {
-			/* Get the EQ corresponding to the IRQ vector */
-			eq = phba->sli4_hba.hba_eq_hdl[i].eq;
-			if (!eq)
-				continue;
-			if (eq->q_mode) {
-				update = true;
-				break;
-			}
-			if (eqcnt[eq->last_cpu] < 2)
-				eqcnt[eq->last_cpu]++;
+	for (i = 0; i < phba->cfg_irq_chann; i++) {
+		/* Get the EQ corresponding to the IRQ vector */
+		eq = phba->sli4_hba.hba_eq_hdl[i].eq;
+		if (!eq)
+			continue;
+		if (eq->q_mode || eq->q_flag & HBA_EQ_DELAY_CHK) {
+			eq->q_flag &= ~HBA_EQ_DELAY_CHK;
+			ena_delay[eq->last_cpu] = 1;
 		}
-	} else
-		update = true;
+	}
 
 	for_each_present_cpu(i) {
 		eqi = per_cpu_ptr(phba->sli4_hba.eq_info, i);
-		if (!update && eqcnt[i] < 2) {
-			eqi->icnt = 0;
-			continue;
+		if (ena_delay[i]) {
+			usdelay = (eqi->icnt >> 10) * LPFC_EQ_DELAY_STEP;
+			if (usdelay > LPFC_MAX_AUTO_EQ_DELAY)
+				usdelay = LPFC_MAX_AUTO_EQ_DELAY;
+		} else {
+			usdelay = 0;
 		}
 
-		usdelay = (eqi->icnt / LPFC_IMAX_THRESHOLD) *
-			   LPFC_EQ_DELAY_STEP;
-		if (usdelay > LPFC_MAX_AUTO_EQ_DELAY)
-			usdelay = LPFC_MAX_AUTO_EQ_DELAY;
-
 		eqi->icnt = 0;
 
 		list_for_each_entry_safe(eq, eq_next, &eqi->list, cpu_list) {
-			if (eq->last_cpu != i) {
+			if (unlikely(eq->last_cpu != i)) {
 				eqi_new = per_cpu_ptr(phba->sli4_hba.eq_info,
 						      eq->last_cpu);
 				list_move_tail(&eq->cpu_list, &eqi_new->list);
@@ -1296,7 +1287,7 @@ lpfc_hb_eq_delay_work(struct work_struct *work)
 		}
 	}
 
-	kfree(eqcnt);
+	kfree(ena_delay);
 
 requeue:
 	queue_delayed_work(phba->wq, &phba->eq_delay_work,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bb0e155eb32c..0e6674bd15c6 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13640,6 +13640,7 @@ __lpfc_sli4_process_cq(struct lpfc_hba *phba, struct lpfc_queue *cq,
 			phba->sli4_hba.sli4_write_cq_db(phba, cq, consumed,
 						LPFC_QUEUE_NOARM);
 			consumed = 0;
+			cq->assoc_qp->q_flag |= HBA_EQ_DELAY_CHK;
 		}
 
 		if (count == LPFC_NVMET_CQ_NOTIFY)
@@ -14278,7 +14279,7 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	fpeq->last_cpu = raw_smp_processor_id();
 
 	if (icnt > LPFC_EQD_ISR_TRIGGER &&
-	    phba->cfg_irq_chann == 1 &&
+	    fpeq->q_flag & HBA_EQ_DELAY_CHK &&
 	    phba->cfg_auto_imax &&
 	    fpeq->q_mode != LPFC_MAX_AUTO_EQ_DELAY &&
 	    phba->sli.sli_flag & LPFC_SLI_USE_EQDR)
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 0d4882a9e634..c9e068ca0fec 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -199,6 +199,7 @@ struct lpfc_queue {
 	uint8_t q_flag;
 #define HBA_NVMET_WQFULL	0x1 /* We hit WQ Full condition for NVMET */
 #define HBA_NVMET_CQ_NOTIFY	0x1 /* LPFC_NVMET_CQ_NOTIFY CQEs this EQE */
+#define HBA_EQ_DELAY_CHK	0x2 /* EQ is a candidate for coalescing */
 #define LPFC_NVMET_CQ_NOTIFY	4
 	void __iomem *db_regaddr;
 	uint16_t dpp_enable;
-- 
2.13.7

