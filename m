Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC02C4363D
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F5BE20709
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="OB0HGzh4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390831AbgJLWwe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390685AbgJLWwY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:24 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701F7C0613D2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:24 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x16so15906591pgj.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=tbfEcG4QyWtBF7ZADYqki9N7NJ5eAjU1CsIt+FQKZnk=;
        b=OB0HGzh4paJMhNGxn1Q7ZG2K/31O+SfHU8lZc1tolwtYpuq9NBRrHZr+BSlClxrUH6
         IZ9qJwRw5K9PQTKcR1EcyU5sbS2y5J1aBvtZWdbvqngLGJF6815soqD4eTZLgRiiesIh
         oGgsFEklN//mFJhf4osFweE7tRKP/p9ar1yoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=tbfEcG4QyWtBF7ZADYqki9N7NJ5eAjU1CsIt+FQKZnk=;
        b=JBRutzq/KOdEk2SlmC6OsNfeufE4sl5tDkWVIWpTvFHyuqg8JjKSUZaebSnvJqgUg/
         30feLFvxOrQg3najhXJk8f7CAxruExZa8IKM2g/UyMMNL/s7mZsxWhRFFXLF4XotWnZ7
         3TB8Hjm19zaekF8SKTVafNcN6RyVQV/5sQEK8536pj+zj9GC2ZE60mrCnGb0EkLWUKj2
         SKo0r0l3F3aYdtDSI5I/epWEGaRyDduWyT5U/l+oEVqnFWwj3Oy7EdKZX3dElKjEvm/O
         YmNIEMCBJDCf07arv9mnbDwEOBb8MPT1DC5W/HqXnv+G3tDRDR0SZ/JFBaeKlsyJVm/9
         Dn5A==
X-Gm-Message-State: AOAM532QAd6iXL5vMC8RJMlKqRI97h/rriZihOm8wxVugH6o2ice6AtE
        f8KGzdaR8KIRCAMpqERmSre4KZ+/ISnFb8Pq2YFGRPrlCJXzDUbec/3n2IO8I3DdTb7XsnhLNCQ
        Dv668lBXFADxxg+W+toj9N9gUEnOUZ8O2wfsRnEnRBU0jKFNHTlvAk01BF6D+jnjGzPJHygoN8c
        mcdzQ=
X-Google-Smtp-Source: ABdhPJyaqKzK4dUyiMDGH0mxdBA0i9b3EVgzkT7f5uoDIaQRcJzsPZWd/Xsklo1BwYVqfVW0bDjUww==
X-Received: by 2002:a17:90a:1bc3:: with SMTP id r3mr22896928pjr.196.1602543142936;
        Mon, 12 Oct 2020 15:52:22 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:22 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 19/31] elx: efct: Hardware queues creation and deletion
Date:   Mon, 12 Oct 2020 15:51:35 -0700
Message-Id: <20201012225147.54404-20-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000cfa03705b181265e"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000cfa03705b181265e
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines for queue creation, deletion, and configuration.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  Changes for MRQ support.
  Mbox request API.
---
 drivers/scsi/elx/efct/efct_hw.h        |   4 +
 drivers/scsi/elx/efct/efct_hw_queues.c | 677 +++++++++++++++++++++++++
 2 files changed, 681 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.c

diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 513be4525867..44649d649229 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -610,6 +610,10 @@ efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev);
 enum efct_hw_rtn efct_hw_init(struct efct_hw *hw);
 enum efct_hw_rtn
 efct_hw_parse_filter(struct efct_hw *hw, void *value);
+enum efct_hw_rtn
+efct_hw_init_queues(struct efct_hw *hw);
+void
+efct_hw_map_wq_cpu(struct efct_hw *hw);
 uint64_t
 efct_get_wwnn(struct efct_hw *hw);
 uint64_t
diff --git a/drivers/scsi/elx/efct/efct_hw_queues.c b/drivers/scsi/elx/efct/efct_hw_queues.c
new file mode 100644
index 000000000000..7586064e2da5
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_hw_queues.c
@@ -0,0 +1,677 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_hw.h"
+#include "efct_unsol.h"
+
+enum efct_hw_rtn
+efct_hw_init_queues(struct efct_hw *hw)
+{
+	struct hw_eq *eq = NULL;
+	struct hw_cq *cq = NULL;
+	struct hw_wq *wq = NULL;
+	struct hw_mq *mq = NULL;
+
+	struct hw_eq *eqs[EFCT_HW_MAX_NUM_EQ];
+	struct hw_cq *cqs[EFCT_HW_MAX_NUM_EQ];
+	struct hw_rq *rqs[EFCT_HW_MAX_NUM_EQ];
+	u32 i = 0, j;
+
+	hw->eq_count = 0;
+	hw->cq_count = 0;
+	hw->mq_count = 0;
+	hw->wq_count = 0;
+	hw->rq_count = 0;
+	hw->hw_rq_count = 0;
+	INIT_LIST_HEAD(&hw->eq_list);
+
+	for (i = 0; i < hw->config.n_eq; i++) {
+		/* Create EQ */
+		eq = efct_hw_new_eq(hw, EFCT_HW_EQ_DEPTH);
+		if (!eq) {
+			efct_hw_queue_teardown(hw);
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+
+		eqs[i] = eq;
+
+		/* Create one MQ */
+		if (!i) {
+			cq = efct_hw_new_cq(eq,
+					    hw->num_qentries[SLI4_QTYPE_CQ]);
+			if (!cq) {
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_NO_MEMORY;
+			}
+
+			mq = efct_hw_new_mq(cq, EFCT_HW_MQ_DEPTH);
+			if (!mq) {
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_NO_MEMORY;
+			}
+		}
+
+		/* Create WQ */
+		cq = efct_hw_new_cq(eq, hw->num_qentries[SLI4_QTYPE_CQ]);
+		if (!cq) {
+			efct_hw_queue_teardown(hw);
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+
+		wq = efct_hw_new_wq(cq, hw->num_qentries[SLI4_QTYPE_WQ]);
+		if (!wq) {
+			efct_hw_queue_teardown(hw);
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+	}
+
+	/* Create CQ set */
+	if (efct_hw_new_cq_set(eqs, cqs, i, hw->num_qentries[SLI4_QTYPE_CQ])) {
+		efct_hw_queue_teardown(hw);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* Create RQ set */
+	if (efct_hw_new_rq_set(cqs, rqs, i, EFCT_HW_RQ_ENTRIES_DEF)) {
+		efct_hw_queue_teardown(hw);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	for (j = 0; j < i ; j++) {
+		rqs[j]->filter_mask = 0;
+		rqs[j]->is_mrq = true;
+		rqs[j]->base_mrq_id = rqs[0]->hdr->id;
+	}
+
+	hw->hw_mrq_count = i;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+void
+efct_hw_map_wq_cpu(struct efct_hw *hw)
+{
+	struct efct *efct = hw->os;
+	u32 cpu = 0, i;
+
+	/* Init cpu_map array */
+	for_each_possible_cpu(cpu) {
+		hw->wq_cpu_array[cpu] = NULL;
+	}
+
+	for (i = 0; i < hw->config.n_eq; i++) {
+		const struct cpumask *maskp;
+
+		/* Get a CPU mask for all CPUs affinitized to this vector */
+		maskp = pci_irq_get_affinity(efct->pci, i);
+		if (!maskp) {
+			efc_log_debug(efct, "maskp null for vector:%d\n", i);
+			continue;
+		}
+
+		/* Loop through all CPUs associated with vector idx */
+		for_each_cpu_and(cpu, maskp, cpu_present_mask) {
+			efc_log_debug(efct, "CPU:%d irq vector:%d\n", cpu, i);
+			hw->wq_cpu_array[cpu] = hw->hw_wq[i];
+		}
+	}
+
+}
+
+struct hw_eq *
+efct_hw_new_eq(struct efct_hw *hw, u32 entry_count)
+{
+	struct hw_eq *eq = kzalloc(sizeof(*eq), GFP_KERNEL);
+
+	if (!eq)
+		return NULL;
+
+	eq->type = SLI4_QTYPE_EQ;
+	eq->hw = hw;
+	eq->entry_count = entry_count;
+	eq->instance = hw->eq_count++;
+	eq->queue = &hw->eq[eq->instance];
+	INIT_LIST_HEAD(&eq->cq_list);
+
+	if (sli_queue_alloc(&hw->sli, SLI4_QTYPE_EQ, eq->queue,	entry_count,
+				NULL)) {
+		efc_log_err(hw->os, "EQ[%d] alloc failure\n", eq->instance);
+		kfree(eq);
+		return NULL;
+	}
+
+	sli_eq_modify_delay(&hw->sli, eq->queue, 1, 0, 8);
+	hw->hw_eq[eq->instance] = eq;
+	INIT_LIST_HEAD(&eq->list_entry);
+	list_add_tail(&eq->list_entry, &hw->eq_list);
+	efc_log_debug(hw->os, "create eq[%2d] id %3d len %4d\n", eq->instance,
+				eq->queue->id, eq->entry_count);
+	return eq;
+}
+
+struct hw_cq *
+efct_hw_new_cq(struct hw_eq *eq, u32 entry_count)
+{
+	struct efct_hw *hw = eq->hw;
+	struct hw_cq *cq = kzalloc(sizeof(*cq), GFP_KERNEL);
+
+	if (!cq)
+		return NULL;
+
+	cq->eq = eq;
+	cq->type = SLI4_QTYPE_CQ;
+	cq->instance = eq->hw->cq_count++;
+	cq->entry_count = entry_count;
+	cq->queue = &hw->cq[cq->instance];
+
+	INIT_LIST_HEAD(&cq->q_list);
+
+	if (sli_queue_alloc(&hw->sli, SLI4_QTYPE_CQ, cq->queue,
+				cq->entry_count, eq->queue)) {
+		efc_log_err(hw->os, "CQ[%d] allocation failure len=%d\n",
+				    eq->instance, eq->entry_count);
+		kfree(cq);
+		return NULL;
+	}
+
+	hw->hw_cq[cq->instance] = cq;
+	INIT_LIST_HEAD(&cq->list_entry);
+	list_add_tail(&cq->list_entry, &eq->cq_list);
+	efc_log_debug(hw->os, "create cq[%2d] id %3d len %4d\n", cq->instance,
+				cq->queue->id, cq->entry_count);
+	return cq;
+}
+
+u32
+efct_hw_new_cq_set(struct hw_eq *eqs[], struct hw_cq *cqs[],
+		   u32 num_cqs, u32 entry_count)
+{
+	u32 i;
+	struct efct_hw *hw = eqs[0]->hw;
+	struct sli4 *sli4 = &hw->sli;
+	struct hw_cq *cq = NULL;
+	struct sli4_queue *qs[SLI4_MAX_CQ_SET_COUNT];
+	struct sli4_queue *assefct[SLI4_MAX_CQ_SET_COUNT];
+
+	/* Initialise CQS pointers to NULL */
+	for (i = 0; i < num_cqs; i++)
+		cqs[i] = NULL;
+
+	for (i = 0; i < num_cqs; i++) {
+		cq = kzalloc(sizeof(*cq), GFP_KERNEL);
+		if (!cq)
+			goto error;
+
+		cqs[i]          = cq;
+		cq->eq          = eqs[i];
+		cq->type        = SLI4_QTYPE_CQ;
+		cq->instance    = hw->cq_count++;
+		cq->entry_count = entry_count;
+		cq->queue       = &hw->cq[cq->instance];
+		qs[i]           = cq->queue;
+		assefct[i]       = eqs[i]->queue;
+		INIT_LIST_HEAD(&cq->q_list);
+	}
+
+	if (sli_cq_alloc_set(sli4, qs, num_cqs, entry_count, assefct)) {
+		efc_log_err(hw->os, "Failed to create CQ Set.\n");
+		goto error;
+	}
+
+	for (i = 0; i < num_cqs; i++) {
+		hw->hw_cq[cqs[i]->instance] = cqs[i];
+		INIT_LIST_HEAD(&cqs[i]->list_entry);
+		list_add_tail(&cqs[i]->list_entry, &cqs[i]->eq->cq_list);
+	}
+
+	return EFC_SUCCESS;
+
+error:
+	for (i = 0; i < num_cqs; i++) {
+		kfree(cqs[i]);
+		cqs[i] = NULL;
+	}
+	return EFC_FAIL;
+}
+
+struct hw_mq *
+efct_hw_new_mq(struct hw_cq *cq, u32 entry_count)
+{
+	struct efct_hw *hw = cq->eq->hw;
+	struct hw_mq *mq = kzalloc(sizeof(*mq), GFP_KERNEL);
+
+	if (!mq)
+		return NULL;
+
+	mq->cq = cq;
+	mq->type = SLI4_QTYPE_MQ;
+	mq->instance = cq->eq->hw->mq_count++;
+	mq->entry_count = entry_count;
+	mq->entry_size = EFCT_HW_MQ_DEPTH;
+	mq->queue = &hw->mq[mq->instance];
+
+	if (sli_queue_alloc(&hw->sli, SLI4_QTYPE_MQ, mq->queue, mq->entry_size,
+			    cq->queue)) {
+		efc_log_err(hw->os, "MQ allocation failure\n");
+		kfree(mq);
+		return NULL;
+	}
+
+	hw->hw_mq[mq->instance] = mq;
+	INIT_LIST_HEAD(&mq->list_entry);
+	list_add_tail(&mq->list_entry, &cq->q_list);
+	efc_log_debug(hw->os, "create mq[%2d] id %3d len %4d\n", mq->instance,
+				mq->queue->id, mq->entry_count);
+	return mq;
+}
+
+struct hw_wq *
+efct_hw_new_wq(struct hw_cq *cq, u32 entry_count)
+{
+	struct efct_hw *hw = cq->eq->hw;
+	struct hw_wq *wq = kzalloc(sizeof(*wq), GFP_KERNEL);
+
+	if (!wq)
+		return NULL;
+
+	wq->hw = cq->eq->hw;
+	wq->cq = cq;
+	wq->type = SLI4_QTYPE_WQ;
+	wq->instance = cq->eq->hw->wq_count++;
+	wq->entry_count = entry_count;
+	wq->queue = &hw->wq[wq->instance];
+	wq->wqec_set_count = EFCT_HW_WQEC_SET_COUNT;
+	wq->wqec_count = wq->wqec_set_count;
+	wq->free_count = wq->entry_count - 1;
+	INIT_LIST_HEAD(&wq->pending_list);
+
+	if (sli_queue_alloc(&hw->sli, SLI4_QTYPE_WQ, wq->queue,
+				    wq->entry_count, cq->queue)) {
+		efc_log_err(hw->os, "WQ allocation failure\n");
+		kfree(wq);
+		return NULL;
+	}
+
+	hw->hw_wq[wq->instance] = wq;
+	INIT_LIST_HEAD(&wq->list_entry);
+	list_add_tail(&wq->list_entry, &cq->q_list);
+	efc_log_debug(hw->os, "create wq[%2d] id %3d len %4d cls %d\n",
+		wq->instance, wq->queue->id, wq->entry_count, wq->class);
+	return wq;
+}
+
+u32
+efct_hw_new_rq_set(struct hw_cq *cqs[], struct hw_rq *rqs[],
+		   u32 num_rq_pairs, u32 entry_count)
+{
+	struct efct_hw *hw = cqs[0]->eq->hw;
+	struct hw_rq *rq = NULL;
+	struct sli4_queue *qs[SLI4_MAX_RQ_SET_COUNT * 2] = { NULL };
+	u32 i, q_count, size;
+
+	/* Initialise RQS pointers */
+	for (i = 0; i < num_rq_pairs; i++)
+		rqs[i] = NULL;
+
+	/*
+	 * Allocate an RQ object SET, where each element in set
+	 * encapsulates 2 SLI queues (for rq pair)
+	 */
+	for (i = 0, q_count = 0; i < num_rq_pairs; i++, q_count += 2) {
+		rq = kzalloc(sizeof(*rq), GFP_KERNEL);
+		if (!rq)
+			goto error;
+
+		rqs[i] = rq;
+		rq->instance = hw->hw_rq_count++;
+		rq->cq = cqs[i];
+		rq->type = SLI4_QTYPE_RQ;
+		rq->entry_count = entry_count;
+
+		/* Header RQ */
+		rq->hdr = &hw->rq[hw->rq_count];
+		rq->hdr_entry_size = EFCT_HW_RQ_HEADER_SIZE;
+		hw->hw_rq_lookup[hw->rq_count] = rq->instance;
+		hw->rq_count++;
+		qs[q_count] = rq->hdr;
+
+		/* Data RQ */
+		rq->data = &hw->rq[hw->rq_count];
+		rq->data_entry_size = hw->config.rq_default_buffer_size;
+		hw->hw_rq_lookup[hw->rq_count] = rq->instance;
+		hw->rq_count++;
+		qs[q_count + 1] = rq->data;
+
+		rq->rq_tracker = NULL;
+	}
+
+	if (sli_fc_rq_set_alloc(&hw->sli, num_rq_pairs, qs,
+				cqs[0]->queue->id,
+			    rqs[0]->entry_count,
+			    rqs[0]->hdr_entry_size,
+			    rqs[0]->data_entry_size)) {
+		efc_log_err(hw->os, "RQ Set alloc failure for base CQ=%d\n",
+			    cqs[0]->queue->id);
+		goto error;
+	}
+
+	for (i = 0; i < num_rq_pairs; i++) {
+		hw->hw_rq[rqs[i]->instance] = rqs[i];
+		INIT_LIST_HEAD(&rqs[i]->list_entry);
+		list_add_tail(&rqs[i]->list_entry, &cqs[i]->q_list);
+		size = sizeof(struct efc_hw_sequence *) * rqs[i]->entry_count;
+		rqs[i]->rq_tracker = kzalloc(size, GFP_KERNEL);
+		if (!rqs[i]->rq_tracker)
+			goto error;
+	}
+
+	return EFC_SUCCESS;
+
+error:
+	for (i = 0; i < num_rq_pairs; i++) {
+		if (rqs[i]) {
+			kfree(rqs[i]->rq_tracker);
+			kfree(rqs[i]);
+		}
+	}
+
+	return EFC_FAIL;
+}
+
+void
+efct_hw_del_eq(struct hw_eq *eq)
+{
+	struct hw_cq *cq;
+	struct hw_cq *cq_next;
+
+	if (!eq)
+		return;
+
+	list_for_each_entry_safe(cq, cq_next, &eq->cq_list, list_entry)
+		efct_hw_del_cq(cq);
+	list_del(&eq->list_entry);
+	eq->hw->hw_eq[eq->instance] = NULL;
+	kfree(eq);
+}
+
+void
+efct_hw_del_cq(struct hw_cq *cq)
+{
+	struct hw_q *q;
+	struct hw_q *q_next;
+
+	if (!cq)
+		return;
+
+	list_for_each_entry_safe(q, q_next, &cq->q_list, list_entry) {
+		switch (q->type) {
+		case SLI4_QTYPE_MQ:
+			efct_hw_del_mq((struct hw_mq *)q);
+			break;
+		case SLI4_QTYPE_WQ:
+			efct_hw_del_wq((struct hw_wq *)q);
+			break;
+		case SLI4_QTYPE_RQ:
+			efct_hw_del_rq((struct hw_rq *)q);
+			break;
+		default:
+			break;
+		}
+	}
+	list_del(&cq->list_entry);
+	cq->eq->hw->hw_cq[cq->instance] = NULL;
+	kfree(cq);
+}
+
+void
+efct_hw_del_mq(struct hw_mq *mq)
+{
+	if (!mq)
+		return;
+
+	list_del(&mq->list_entry);
+	mq->cq->eq->hw->hw_mq[mq->instance] = NULL;
+	kfree(mq);
+}
+
+void
+efct_hw_del_wq(struct hw_wq *wq)
+{
+	if (!wq)
+		return;
+
+	list_del(&wq->list_entry);
+	wq->cq->eq->hw->hw_wq[wq->instance] = NULL;
+	kfree(wq);
+}
+
+void
+efct_hw_del_rq(struct hw_rq *rq)
+{
+	struct efct_hw *hw = NULL;
+
+	if (!rq)
+		return;
+	/* Free RQ tracker */
+	kfree(rq->rq_tracker);
+	rq->rq_tracker = NULL;
+	list_del(&rq->list_entry);
+	hw = rq->cq->eq->hw;
+	hw->hw_rq[rq->instance] = NULL;
+	kfree(rq);
+}
+
+void
+efct_hw_queue_teardown(struct efct_hw *hw)
+{
+	struct hw_eq *eq;
+	struct hw_eq *eq_next;
+
+	if (!hw->eq_list.next)
+		return;
+
+	list_for_each_entry_safe(eq, eq_next, &hw->eq_list, list_entry)
+		efct_hw_del_eq(eq);
+}
+
+static inline int
+efct_hw_rqpair_find(struct efct_hw *hw, u16 rq_id)
+{
+	return efct_hw_queue_hash_find(hw->rq_hash, rq_id);
+}
+
+static struct efc_hw_sequence *
+efct_hw_rqpair_get(struct efct_hw *hw, u16 rqindex, u16 bufindex)
+{
+	struct sli4_queue *rq_hdr = &hw->rq[rqindex];
+	struct efc_hw_sequence *seq = NULL;
+	struct hw_rq *rq = hw->hw_rq[hw->hw_rq_lookup[rqindex]];
+	unsigned long flags = 0;
+
+	if (bufindex >= rq_hdr->length) {
+		efc_log_err(hw->os,
+				"RQidx %d bufidx %d exceed ring len %d for id %d\n",
+				rqindex, bufindex, rq_hdr->length, rq_hdr->id);
+		return NULL;
+	}
+
+	/* rq_hdr lock also covers rqindex+1 queue */
+	spin_lock_irqsave(&rq_hdr->lock, flags);
+
+	seq = rq->rq_tracker[bufindex];
+	rq->rq_tracker[bufindex] = NULL;
+
+	if (!seq) {
+		efc_log_err(hw->os,
+			     "RQbuf NULL, rqidx %d, bufidx %d, cur q idx = %d\n",
+			     rqindex, bufindex, rq_hdr->index);
+	}
+
+	spin_unlock_irqrestore(&rq_hdr->lock, flags);
+	return seq;
+}
+
+int
+efct_hw_rqpair_process_rq(struct efct_hw *hw, struct hw_cq *cq,
+			  u8 *cqe)
+{
+	u16 rq_id;
+	u32 index;
+	int rqindex;
+	int rq_status;
+	u32 h_len;
+	u32 p_len;
+	struct efc_hw_sequence *seq;
+	struct hw_rq *rq;
+
+	rq_status = sli_fc_rqe_rqid_and_index(&hw->sli, cqe,
+					      &rq_id, &index);
+	if (rq_status != 0) {
+		switch (rq_status) {
+		case SLI4_FC_ASYNC_RQ_BUF_LEN_EXCEEDED:
+		case SLI4_FC_ASYNC_RQ_DMA_FAILURE:
+			/* just get RQ buffer then return to chip */
+			rqindex = efct_hw_rqpair_find(hw, rq_id);
+			if (rqindex < 0) {
+				efc_log_test(hw->os,
+					      "status=%#x: lookup fail id=%#x\n",
+					     rq_status, rq_id);
+				break;
+			}
+
+			/* get RQ buffer */
+			seq = efct_hw_rqpair_get(hw, rqindex, index);
+
+			/* return to chip */
+			if (efct_hw_rqpair_sequence_free(hw, seq)) {
+				efc_log_test(hw->os,
+					      "status=%#x,fail rtrn buf to RQ\n",
+					     rq_status);
+				break;
+			}
+			break;
+		case SLI4_FC_ASYNC_RQ_INSUFF_BUF_NEEDED:
+		case SLI4_FC_ASYNC_RQ_INSUFF_BUF_FRM_DISC:
+			/*
+			 * since RQ buffers were not consumed, cannot return
+			 * them to chip
+			 */
+			efc_log_debug(hw->os, "Warning: RCQE status=%#x,\n",
+				       rq_status);
+			fallthrough;
+		default:
+			break;
+		}
+		return EFC_FAIL;
+	}
+
+	rqindex = efct_hw_rqpair_find(hw, rq_id);
+	if (rqindex < 0) {
+		efc_log_test(hw->os, "Error: rq_id lookup failed for id=%#x\n",
+			      rq_id);
+		return EFC_FAIL;
+	}
+
+	rq = hw->hw_rq[hw->hw_rq_lookup[rqindex]];
+	rq->use_count++;
+
+	seq = efct_hw_rqpair_get(hw, rqindex, index);
+	if (WARN_ON(!seq))
+		return EFC_FAIL;
+
+	seq->hw = hw;
+	seq->auto_xrdy = 0;
+	seq->out_of_xris = 0;
+
+	sli_fc_rqe_length(&hw->sli, cqe, &h_len, &p_len);
+	seq->header->dma.len = h_len;
+	seq->payload->dma.len = p_len;
+	seq->fcfi = sli_fc_rqe_fcfi(&hw->sli, cqe);
+	seq->hw_priv = cq->eq;
+
+	efct_unsolicited_cb(hw->os, seq);
+
+	return EFC_SUCCESS;
+}
+
+static int
+efct_hw_rqpair_put(struct efct_hw *hw, struct efc_hw_sequence *seq)
+{
+	struct sli4_queue *rq_hdr = &hw->rq[seq->header->rqindex];
+	struct sli4_queue *rq_payload = &hw->rq[seq->payload->rqindex];
+	u32 hw_rq_index = hw->hw_rq_lookup[seq->header->rqindex];
+	struct hw_rq *rq = hw->hw_rq[hw_rq_index];
+	u32 phys_hdr[2];
+	u32 phys_payload[2];
+	int qindex_hdr;
+	int qindex_payload;
+	unsigned long flags = 0;
+
+	/* Update the RQ verification lookup tables */
+	phys_hdr[0] = upper_32_bits(seq->header->dma.phys);
+	phys_hdr[1] = lower_32_bits(seq->header->dma.phys);
+	phys_payload[0] = upper_32_bits(seq->payload->dma.phys);
+	phys_payload[1] = lower_32_bits(seq->payload->dma.phys);
+
+	/* rq_hdr lock also covers payload / header->rqindex+1 queue */
+	spin_lock_irqsave(&rq_hdr->lock, flags);
+
+	/*
+	 * Note: The header must be posted last for buffer pair mode because
+	 *       posting on the header queue posts the payload queue as well.
+	 *       We do not ring the payload queue independently in RQ pair mode.
+	 */
+	qindex_payload = sli_rq_write(&hw->sli, rq_payload,
+				      (void *)phys_payload);
+	qindex_hdr = sli_rq_write(&hw->sli, rq_hdr, (void *)phys_hdr);
+	if (qindex_hdr < 0 ||
+	    qindex_payload < 0) {
+		efc_log_err(hw->os, "RQ_ID=%#x write failed\n", rq_hdr->id);
+		spin_unlock_irqrestore(&rq_hdr->lock, flags);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* ensure the indexes are the same */
+	WARN_ON(qindex_hdr != qindex_payload);
+
+	/* Update the lookup table */
+	if (!rq->rq_tracker[qindex_hdr]) {
+		rq->rq_tracker[qindex_hdr] = seq;
+	} else {
+		efc_log_test(hw->os,
+			      "expected rq_tracker[%d][%d] buffer to be NULL\n",
+			     hw_rq_index, qindex_hdr);
+	}
+
+	spin_unlock_irqrestore(&rq_hdr->lock, flags);
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+enum efct_hw_rtn
+efct_hw_rqpair_sequence_free(struct efct_hw *hw, struct efc_hw_sequence *seq)
+{
+	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
+
+	/*
+	 * Post the data buffer first. Because in RQ pair mode, ringing the
+	 * doorbell of the header ring will post the data buffer as well.
+	 */
+	if (efct_hw_rqpair_put(hw, seq)) {
+		efc_log_err(hw->os, "error writing buffers\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	return rc;
+}
+
+int
+efct_efc_hw_sequence_free(struct efc *efc, struct efc_hw_sequence *seq)
+{
+	struct efct *efct = efc->base;
+
+	return efct_hw_rqpair_sequence_free(&efct->hw, seq);
+}
-- 
2.26.2


--000000000000cfa03705b181265e
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgoovCAwvtLDsGkQF4
M54Hv5D0nm9cNufnEKPuSoZQa00wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjIzWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAEY7+NHZj1+DqvRAw6Q3EtgfsvP2RxbozF1w
6OQlEQLRdAGYPZKC0gvp6bsWC0/K7C2x7UpAkV65viFQzniCnO/qiWiDMx6ZIJQLSw9MmVZS83uj
MeyKdHFhTnVjLPhGg1+3ElAKjk2T9H6l3ILm6OOgv5gjXiggi7bF99lVLRaxZi1RCm+Qi36QjYyy
G8zMoMSQKG/b6NuMPtPTZSBMbevn105HHtgl7RUookFbIThoEj9nBtFzazLe9SR4HKt0e1MqK3tl
snMLNePgQtP56ncbdHOtvosLlKi4KYhIWOBw9BMSbTmf/TCc9OuWmphQRBt5xGHHGXt2JnjPwevr
v8A=
--000000000000cfa03705b181265e--
