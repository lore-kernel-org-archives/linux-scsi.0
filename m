Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E371CA9EBC
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF29A205ED
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnZHPezb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436627AbfJWV4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:45 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:52080 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436619AbfJWV4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:44 -0400
Received: by mail-wm1-f51.google.com with SMTP id q70so527581wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8AgmvOO8eO2HxDj/Fl/SkISa7wOIdGTMxCWeJCf27ck=;
        b=CnZHPezblyl7FIbTaDjjI3wjedcTMt7N7xZSDU/1ZDfYnQVDNsPe0M6kF1H45IgC0M
         2e614AxvebcBzsTo+IeimRm1XYNSdbLkP1VEITJkF0ZA2UOr0e8ytoX3QF9XGMm3XSYf
         dLe+W6H/U2q5kb2ml3LCPkgq7g38MmMLfSoMTrwqA3pOXae12euLEEgoeKv82hqUFZzU
         CtsxJGJRNCVA1XBaKqbJfJ1kYZP6WShSWgo5xhkp9n3QY+Nut5VLYUwVeSdQg0Js9jcV
         IcxdJLyDzZVkvRS5+Xst2mTXUdtI1t7bNu/A0NrXjfdotme5AmjsHLs5xNqiIiqi6hQN
         0xCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8AgmvOO8eO2HxDj/Fl/SkISa7wOIdGTMxCWeJCf27ck=;
        b=c1j/9EevtROwj6Y3nFgb+3VdGBfTTvaME+kgxMy/R0mSiExy6UaZ3AayccOR+f0dM8
         pDcvoLC/Ht3IrF4/8zPPEqLesM5nV+MRed/jaGtzJCSsbixCViY1/vnz4zDUyasN21x0
         3eyHN/3ucWNgVPbJnzbr2NkIUQcyhExAlzBkn16Ok3+3dgts5VgRP2/3/VfDxNUGgSji
         r2vM8bufStvqQgvU1kboIDJ09ZFutenj0iZC0uMAkTl5H279TvUeWwsgYzsrIZpIQnh4
         IoW9fjg/3sFmnSovRKIKYnncUaprBKk7XIv1KAgbvilAxsMewK8+oGef/Aoj2CEXO5TZ
         gr9w==
X-Gm-Message-State: APjAAAUskG9rIB0ymLOzqv2Wrx4gon87WJ0W2+bweYHtp3s94Z5udUgk
        Q00VSeOlrbz3a91UR14SwpNguQpw
X-Google-Smtp-Source: APXvYqwKUwZMSOfipUO4nS2+gyLgW5ImwINguUowvDGprHN0DFg3z4kwd6n0iGiMzlgzg/lhGlHRKg==
X-Received: by 2002:a1c:d8:: with SMTP id 207mr1772943wma.65.1571867795065;
        Wed, 23 Oct 2019 14:56:35 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:34 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 17/32] elx: efct: Hardware queues creation and deletion
Date:   Wed, 23 Oct 2019 14:55:42 -0700
Message-Id: <20191023215557.12581-18-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191023215557.12581-1-jsmart2021@gmail.com>
References: <20191023215557.12581-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Routines for queue creation, deletion, and configuration.
Driven by strings describing configuration topology with
parsers for the strings.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_hw_queues.c | 1717 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw_queues.h |   66 ++
 2 files changed, 1783 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.c
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.h

diff --git a/drivers/scsi/elx/efct/efct_hw_queues.c b/drivers/scsi/elx/efct/efct_hw_queues.c
new file mode 100644
index 000000000000..5196aa75553c
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_hw_queues.c
@@ -0,0 +1,1717 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_hw.h"
+#include "efct_hw_queues.h"
+#include "efct_unsol.h"
+
+static int
+efct_hw_rqpair_find(struct efct_hw_s *hw, u16 rq_id);
+static struct efc_hw_sequence_s *
+efct_hw_rqpair_get(struct efct_hw_s *hw, u16 rqindex, u16 bufindex);
+static int
+efct_hw_rqpair_put(struct efct_hw_s *hw, struct efc_hw_sequence_s *seq);
+/**
+ * @brief Initialize queues
+ *
+ * Given the parsed queue topology spec, the SLI queues are created and
+ * initialized
+ *
+ * @param hw pointer to HW object
+ * @param qtop pointer to queue topology
+ *
+ * @return returns 0 for success, an error code value for failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_init_queues(struct efct_hw_s *hw, struct efct_hw_qtop_s *qtop)
+{
+	u32 i, j, k;
+	u32 default_lengths[QTOP_LAST], len;
+	u32 rqset_len = 0, rqset_count = 0;
+	u8 rqset_filter_mask = 0;
+	struct hw_eq_s *eqs[EFCT_HW_MAX_MRQS];
+	struct hw_cq_s *cqs[EFCT_HW_MAX_MRQS];
+	struct hw_rq_s *rqs[EFCT_HW_MAX_MRQS];
+	struct efct_hw_qtop_entry_s *qt, *next_qt;
+	struct efct_hw_mrq_s mrq;
+	bool use_mrq = false;
+
+	struct hw_eq_s *eq = NULL;
+	struct hw_cq_s *cq = NULL;
+	struct hw_wq_s *wq = NULL;
+	struct hw_rq_s *rq = NULL;
+	struct hw_mq_s *mq = NULL;
+
+	mrq.num_pairs = 0;
+	default_lengths[QTOP_EQ] = 1024;
+	default_lengths[QTOP_CQ] = hw->num_qentries[SLI_QTYPE_CQ];
+	default_lengths[QTOP_WQ] = hw->num_qentries[SLI_QTYPE_WQ];
+	default_lengths[QTOP_RQ] = hw->num_qentries[SLI_QTYPE_RQ];
+	default_lengths[QTOP_MQ] = EFCT_HW_MQ_DEPTH;
+
+	hw->eq_count = 0;
+	hw->cq_count = 0;
+	hw->mq_count = 0;
+	hw->wq_count = 0;
+	hw->rq_count = 0;
+	hw->hw_rq_count = 0;
+	INIT_LIST_HEAD(&hw->eq_list);
+
+	/* If MRQ is requested, Check if it is supported by SLI. */
+	if (hw->config.n_rq > 1 &&
+	    !(hw->sli.features & SLI4_REQFEAT_MRQP)) {
+		efc_log_err(hw->os, "MRQ topology not supported by SLI4.\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (hw->config.n_rq > 1)
+		use_mrq = true;
+
+	/* Allocate class WQ pools */
+	for (i = 0; i < ARRAY_SIZE(hw->wq_class_array); i++) {
+		hw->wq_class_array[i] = efct_varray_alloc(hw->os,
+							  EFCT_HW_MAX_NUM_WQ);
+		if (!hw->wq_class_array[i]) {
+			efc_log_err(hw->os,
+				     "efct_varray_alloc for wq_class failed\n");
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+	}
+
+	/* Allocate per CPU WQ pools */
+	for (i = 0; i < ARRAY_SIZE(hw->wq_cpu_array); i++) {
+		hw->wq_cpu_array[i] = efct_varray_alloc(hw->os,
+							EFCT_HW_MAX_NUM_WQ);
+		if (!hw->wq_cpu_array[i]) {
+			efc_log_err(hw->os,
+				     "efct_varray_alloc for wq_class failed\n");
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+	}
+
+	for (i = 0, qt = qtop->entries; i < qtop->inuse_count; i++, qt++) {
+		if (i == qtop->inuse_count - 1)
+			next_qt = NULL;
+		else
+			next_qt = qt + 1;
+
+		switch (qt->entry) {
+		case QTOP_EQ:
+			len = (qt->len) ? qt->len : default_lengths[QTOP_EQ];
+
+			if (qt->set_default) {
+				default_lengths[QTOP_EQ] = len;
+				break;
+			}
+
+			eq = efct_hw_new_eq(hw, len);
+			if (!eq) {
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_NO_MEMORY;
+			}
+			break;
+
+		case QTOP_CQ:
+			len = (qt->len) ? qt->len : default_lengths[QTOP_CQ];
+
+			if (qt->set_default) {
+				default_lengths[QTOP_CQ] = len;
+				break;
+			}
+
+			/* If this CQ is for MRQ, then delay the creation */
+			if (!use_mrq || next_qt->entry != QTOP_RQ) {
+				if (!eq)
+					return EFCT_HW_RTN_NO_MEMORY;
+
+				cq = efct_hw_new_cq(eq, len);
+				if (!cq) {
+					efct_hw_queue_teardown(hw);
+					return EFCT_HW_RTN_NO_MEMORY;
+				}
+			}
+			break;
+
+		case QTOP_WQ: {
+			len = (qt->len) ? qt->len : default_lengths[QTOP_WQ];
+			if (qt->set_default) {
+				default_lengths[QTOP_WQ] = len;
+				break;
+			}
+
+			if ((hw->ulp_start + qt->ulp) > hw->ulp_max) {
+				efc_log_err(hw->os,
+					     "invalid ULP %d WQ\n", qt->ulp);
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_NO_MEMORY;
+			}
+
+			wq = efct_hw_new_wq(cq, len,
+					    qt->class, hw->ulp_start + qt->ulp);
+			if (!wq) {
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_NO_MEMORY;
+			}
+
+			/* Place this WQ on the EQ WQ array */
+			if (efct_varray_add(eq->wq_array, wq)) {
+				efc_log_err(hw->os,
+					     "QTOP_WQ:EQ efct_varray_add fail\n");
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_ERROR;
+			}
+
+			/* Place this WQ on the HW class array */
+			if (qt->class < ARRAY_SIZE(hw->wq_class_array)) {
+				if (efct_varray_add
+					(hw->wq_class_array[qt->class], wq)) {
+					efc_log_err(hw->os,
+						     "HW wq_class_array efct_varray_add failed\n");
+					efct_hw_queue_teardown(hw);
+					return EFCT_HW_RTN_ERROR;
+				}
+			} else {
+				efc_log_err(hw->os,
+					     "Invalid class value: %d\n",
+					    qt->class);
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_ERROR;
+			}
+
+			/*
+			 * Place this WQ on the per CPU list, asumming that EQs
+			 * are mapped to cpu given by the EQ instance modulo
+			 * number of CPUs
+			 */
+			if (efct_varray_add(hw->wq_cpu_array[eq->instance %
+					   num_online_cpus()], wq)) {
+				efc_log_err(hw->os,
+					     "HW wq_cpu_array efct_varray_add failed\n");
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_ERROR;
+			}
+
+			break;
+		}
+		case QTOP_RQ: {
+			len = (qt->len) ? qt->len : EFCT_HW_RQ_ENTRIES_DEF;
+
+			/*
+			 * Use the max supported queue length
+			 * if qtop rq len is not a valid value
+			 */
+			if (len > default_lengths[QTOP_RQ] ||
+			    (len % EFCT_HW_RQ_ENTRIES_MIN)) {
+				efc_log_info(hw->os,
+					      "QTOP RQ len %d is invalid. Using max supported RQ len %d\n",
+					len, default_lengths[QTOP_RQ]);
+				len = default_lengths[QTOP_RQ];
+			}
+
+			if (qt->set_default) {
+				default_lengths[QTOP_RQ] = len;
+				break;
+			}
+
+			if ((hw->ulp_start + qt->ulp) > hw->ulp_max) {
+				efc_log_err(hw->os,
+					     "invalid ULP %d RQ\n", qt->ulp);
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_NO_MEMORY;
+			}
+
+			if (use_mrq) {
+				k = mrq.num_pairs;
+				mrq.rq_cfg[k].len = len;
+				mrq.rq_cfg[k].ulp = hw->ulp_start + qt->ulp;
+				mrq.rq_cfg[k].filter_mask = qt->filter_mask;
+				mrq.rq_cfg[k].eq = eq;
+				mrq.num_pairs++;
+			} else {
+				rq = efct_hw_new_rq(cq, len,
+						    hw->ulp_start + qt->ulp);
+				if (!rq) {
+					efct_hw_queue_teardown(hw);
+					return EFCT_HW_RTN_NO_MEMORY;
+				}
+				rq->filter_mask = qt->filter_mask;
+			}
+			break;
+		}
+
+		case QTOP_MQ:
+			len = (qt->len) ? qt->len : default_lengths[QTOP_MQ];
+			if (qt->set_default) {
+				default_lengths[QTOP_MQ] = len;
+				break;
+			}
+
+			if (!cq)
+				return EFCT_HW_RTN_NO_MEMORY;
+
+			mq = efct_hw_new_mq(cq, len);
+			if (!mq) {
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_NO_MEMORY;
+			}
+			break;
+
+		default:
+			efc_log_crit(hw->os, "Unknown Queue\n");
+			break;
+		}
+	}
+
+	if (mrq.num_pairs) {
+		/* First create normal RQs. */
+		for (i = 0; i < mrq.num_pairs; i++) {
+			for (j = 0; j < mrq.num_pairs; j++) {
+				if (i != j &&
+				    mrq.rq_cfg[i].filter_mask ==
+				     mrq.rq_cfg[j].filter_mask) {
+					/* This should be created using set */
+					if (rqset_filter_mask &&
+					    rqset_filter_mask !=
+					     mrq.rq_cfg[i].filter_mask) {
+						efc_log_crit(hw->os,
+							      "Cant create > 1 RQ Set\n");
+						efct_hw_queue_teardown(hw);
+						return EFCT_HW_RTN_ERROR;
+					} else if (!rqset_filter_mask) {
+						rqset_filter_mask =
+						      mrq.rq_cfg[i].filter_mask;
+						rqset_len = mrq.rq_cfg[i].len;
+					}
+					eqs[rqset_count] = mrq.rq_cfg[i].eq;
+					rqset_count++;
+					break;
+				}
+			}
+			if (j == mrq.num_pairs) {
+				/* Normal RQ */
+				cq = efct_hw_new_cq(mrq.rq_cfg[i].eq,
+						    default_lengths[QTOP_CQ]);
+				if (!cq) {
+					efct_hw_queue_teardown(hw);
+					return EFCT_HW_RTN_NO_MEMORY;
+				}
+
+				rq = efct_hw_new_rq(cq, mrq.rq_cfg[i].len,
+						    mrq.rq_cfg[i].ulp);
+				if (!rq) {
+					efct_hw_queue_teardown(hw);
+					return EFCT_HW_RTN_NO_MEMORY;
+				}
+				rq->filter_mask = mrq.rq_cfg[i].filter_mask;
+			}
+		}
+
+		/* Now create RQ Set */
+		if (rqset_count) {
+			/* Create CQ set */
+			if (efct_hw_new_cq_set(eqs, cqs, rqset_count,
+					       default_lengths[QTOP_CQ])) {
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_ERROR;
+			}
+
+			/* Create RQ set */
+			if (efct_hw_new_rq_set(cqs, rqs, rqset_count,
+					       rqset_len)) {
+				efct_hw_queue_teardown(hw);
+				return EFCT_HW_RTN_ERROR;
+			}
+
+			for (i = 0; i < rqset_count ; i++) {
+				rqs[i]->filter_mask = rqset_filter_mask;
+				rqs[i]->is_mrq = true;
+				rqs[i]->base_mrq_id = rqs[0]->hdr->id;
+			}
+
+			hw->hw_mrq_count = rqset_count;
+		}
+	}
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+/**
+ * @brief Allocate a new EQ object
+ *
+ * A new EQ object is instantiated
+ *
+ * @param hw pointer to HW object
+ * @param entry_count number of entries in the EQ
+ *
+ * @return pointer to allocated EQ object
+ */
+struct hw_eq_s *
+efct_hw_new_eq(struct efct_hw_s *hw, u32 entry_count)
+{
+	struct hw_eq_s *eq = kmalloc(sizeof(*eq), GFP_KERNEL);
+
+	if (eq) {
+		memset(eq, 0, sizeof(*eq));
+		eq->type = SLI_QTYPE_EQ;
+		eq->hw = hw;
+		eq->entry_count = entry_count;
+		eq->instance = hw->eq_count++;
+		eq->queue = &hw->eq[eq->instance];
+		INIT_LIST_HEAD(&eq->cq_list);
+
+		eq->wq_array = efct_varray_alloc(hw->os, EFCT_HW_MAX_NUM_WQ);
+		if (!eq->wq_array) {
+			kfree(eq);
+			eq = NULL;
+		} else {
+			if (sli_queue_alloc(&hw->sli, SLI_QTYPE_EQ,
+					    eq->queue,
+					    entry_count, NULL)) {
+				efc_log_err(hw->os,
+					     "EQ[%d] allocation failure\n",
+					    eq->instance);
+				kfree(eq);
+				eq = NULL;
+			} else {
+				sli_eq_modify_delay(&hw->sli, eq->queue,
+						    1, 0, 8);
+				hw->hw_eq[eq->instance] = eq;
+				INIT_LIST_HEAD(&eq->list_entry);
+				list_add_tail(&eq->list_entry, &hw->eq_list);
+				efc_log_debug(hw->os,
+					       "create eq[%2d] id %3d len %4d\n",
+					      eq->instance, eq->queue->id,
+					      eq->entry_count);
+			}
+		}
+	}
+	return eq;
+}
+
+/**
+ * @brief Allocate a new CQ object
+ *
+ * A new CQ object is instantiated
+ *
+ * @param eq pointer to parent EQ object
+ * @param entry_count number of entries in the CQ
+ *
+ * @return pointer to allocated CQ object
+ */
+struct hw_cq_s *
+efct_hw_new_cq(struct hw_eq_s *eq, u32 entry_count)
+{
+	struct efct_hw_s *hw = eq->hw;
+	struct hw_cq_s *cq = kmalloc(sizeof(*cq), GFP_KERNEL);
+
+	if (cq) {
+		memset(cq, 0, sizeof(*cq));
+		cq->eq = eq;
+		cq->type = SLI_QTYPE_CQ;
+		cq->instance = eq->hw->cq_count++;
+		cq->entry_count = entry_count;
+		cq->queue = &hw->cq[cq->instance];
+
+		INIT_LIST_HEAD(&cq->q_list);
+
+		if (sli_queue_alloc(&hw->sli, SLI_QTYPE_CQ, cq->queue,
+				    cq->entry_count, eq->queue)) {
+			efc_log_err(hw->os,
+				     "CQ[%d] allocation failure len=%d\n",
+				    eq->instance,
+				    eq->entry_count);
+			kfree(cq);
+			cq = NULL;
+		} else {
+			hw->hw_cq[cq->instance] = cq;
+			INIT_LIST_HEAD(&cq->list_entry);
+			list_add_tail(&cq->list_entry, &eq->cq_list);
+			efc_log_debug(hw->os,
+				       "create cq[%2d] id %3d len %4d\n",
+				      cq->instance, cq->queue->id,
+				      cq->entry_count);
+		}
+	}
+	return cq;
+}
+
+/**
+ * @brief Allocate a new CQ Set of objects.
+ *
+ * @param eqs pointer to a set of EQ objects.
+ * @param cqs pointer to a set of CQ objects to be returned.
+ * @param num_cqs number of CQ queues in the set.
+ * @param entry_count number of entries in the CQ.
+ *
+ * @return 0 on success and -1 on failure.
+ */
+u32
+efct_hw_new_cq_set(struct hw_eq_s *eqs[], struct hw_cq_s *cqs[],
+		   u32 num_cqs, u32 entry_count)
+{
+	u32 i;
+	struct efct_hw_s *hw = eqs[0]->hw;
+	struct sli4_s *sli4 = &hw->sli;
+	struct hw_cq_s *cq = NULL;
+	struct sli4_queue_s *qs[SLI_MAX_CQ_SET_COUNT];
+	struct sli4_queue_s *assefct[SLI_MAX_CQ_SET_COUNT];
+
+	/* Initialise CQS pointers to NULL */
+	for (i = 0; i < num_cqs; i++)
+		cqs[i] = NULL;
+
+	for (i = 0; i < num_cqs; i++) {
+		cq = kmalloc(sizeof(*cq), GFP_KERNEL);
+		if (!cq)
+			goto error;
+
+		memset(cq, 0, sizeof(*cq));
+		cqs[i]          = cq;
+		cq->eq          = eqs[i];
+		cq->type        = SLI_QTYPE_CQ;
+		cq->instance    = hw->cq_count++;
+		cq->entry_count = entry_count;
+		cq->queue       = &hw->cq[cq->instance];
+		qs[i]           = cq->queue;
+		assefct[i]       = eqs[i]->queue;
+		INIT_LIST_HEAD(&cq->q_list);
+	}
+
+	if (!sli_cq_alloc_set(sli4, qs, num_cqs, entry_count, assefct)) {
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
+	return 0;
+
+error:
+	for (i = 0; i < num_cqs; i++) {
+		kfree(cqs[i]);
+		cqs[i] = NULL;
+	}
+	return -1;
+}
+
+/**
+ * @brief Allocate a new MQ object
+ *
+ * A new MQ object is instantiated
+ *
+ * @param cq pointer to parent CQ object
+ * @param entry_count number of entries in the MQ
+ *
+ * @return pointer to allocated MQ object
+ */
+struct hw_mq_s *
+efct_hw_new_mq(struct hw_cq_s *cq, u32 entry_count)
+{
+	struct efct_hw_s *hw = cq->eq->hw;
+	struct hw_mq_s *mq = kmalloc(sizeof(*mq), GFP_KERNEL);
+
+	if (mq) {
+		memset(mq, 0, sizeof(*mq));
+		mq->cq = cq;
+		mq->type = SLI_QTYPE_MQ;
+		mq->instance = cq->eq->hw->mq_count++;
+		mq->entry_count = entry_count;
+		mq->entry_size = EFCT_HW_MQ_DEPTH;
+		mq->queue = &hw->mq[mq->instance];
+
+		if (sli_queue_alloc(&hw->sli, SLI_QTYPE_MQ,
+				    mq->queue,
+				    mq->entry_size,
+				    cq->queue)) {
+			efc_log_err(hw->os, "MQ allocation failure\n");
+			kfree(mq);
+			mq = NULL;
+		} else {
+			hw->hw_mq[mq->instance] = mq;
+			INIT_LIST_HEAD(&mq->list_entry);
+			list_add_tail(&mq->list_entry, &cq->q_list);
+			efc_log_debug(hw->os,
+				       "create mq[%2d] id %3d len %4d\n",
+				      mq->instance, mq->queue->id,
+				      mq->entry_count);
+		}
+	}
+	return mq;
+}
+
+/**
+ * @brief Allocate a new WQ object
+ *
+ * A new WQ object is instantiated
+ *
+ * @param cq pointer to parent CQ object
+ * @param entry_count number of entries in the WQ
+ * @param class WQ class
+ * @param ulp index of chute
+ *
+ * @return pointer to allocated WQ object
+ */
+struct hw_wq_s *
+efct_hw_new_wq(struct hw_cq_s *cq, u32 entry_count,
+	       u32 class, u32 ulp)
+{
+	struct efct_hw_s *hw = cq->eq->hw;
+	struct hw_wq_s *wq = kmalloc(sizeof(*wq), GFP_KERNEL);
+
+	if (wq) {
+		memset(wq, 0, sizeof(*wq));
+		wq->hw = cq->eq->hw;
+		wq->cq = cq;
+		wq->type = SLI_QTYPE_WQ;
+		wq->instance = cq->eq->hw->wq_count++;
+		wq->entry_count = entry_count;
+		wq->queue = &hw->wq[wq->instance];
+		wq->ulp = ulp;
+		wq->wqec_set_count = EFCT_HW_WQEC_SET_COUNT;
+		wq->wqec_count = wq->wqec_set_count;
+		wq->free_count = wq->entry_count - 1;
+		wq->class = class;
+		INIT_LIST_HEAD(&wq->pending_list);
+
+		if (sli_queue_alloc(&hw->sli, SLI_QTYPE_WQ, wq->queue,
+				    wq->entry_count, cq->queue)) {
+			efc_log_err(hw->os, "WQ allocation failure\n");
+			kfree(wq);
+			wq = NULL;
+		} else {
+			hw->hw_wq[wq->instance] = wq;
+			INIT_LIST_HEAD(&wq->list_entry);
+			list_add_tail(&wq->list_entry, &cq->q_list);
+			efc_log_debug(hw->os,
+				       "create wq[%2d] id %3d len %4d cls %d ulp %d\n",
+				wq->instance, wq->queue->id,
+				wq->entry_count, wq->class, wq->ulp);
+		}
+	}
+	return wq;
+}
+
+/**
+ * @brief Allocate a struct hw_rq_s object
+ *
+ * Allocate an RQ object, which encapsulates 2 SLI queues (for rq pair)
+ *
+ * @param cq pointer to parent CQ object
+ * @param entry_count number of entries in the RQs
+ * @param ulp ULP index for this RQ
+ *
+ * @return pointer to newly allocated hw_rq_t
+ */
+struct hw_rq_s *
+efct_hw_new_rq(struct hw_cq_s *cq, u32 entry_count, u32 ulp)
+{
+	struct efct_hw_s *hw = cq->eq->hw;
+	struct hw_rq_s *rq = kmalloc(sizeof(*rq), GFP_KERNEL);
+
+	if (rq) {
+		memset(rq, 0, sizeof(*rq));
+		rq->instance = hw->hw_rq_count++;
+		rq->cq = cq;
+		rq->type = SLI_QTYPE_RQ;
+		rq->entry_count = entry_count;
+
+		/* Create the header RQ */
+		rq->hdr = &hw->rq[hw->rq_count];
+		rq->hdr_entry_size = EFCT_HW_RQ_HEADER_SIZE;
+
+		if (sli_fc_rq_alloc(&hw->sli, rq->hdr,
+				    rq->entry_count,
+				    rq->hdr_entry_size,
+				    cq->queue,
+				    true)) {
+			efc_log_err(hw->os,
+				     "RQ allocation failure - header\n");
+			kfree(rq);
+			return NULL;
+		}
+		/* Update hw_rq_lookup[] */
+		hw->hw_rq_lookup[hw->rq_count] = rq->instance;
+		hw->rq_count++;
+		efc_log_debug(hw->os,
+			      "create rq[%2d] id %3d len %4d hdr  size %4d\n",
+			      rq->instance, rq->hdr->id, rq->entry_count,
+			      rq->hdr_entry_size);
+
+		/* Create the default data RQ */
+		rq->data = &hw->rq[hw->rq_count];
+		rq->data_entry_size = hw->config.rq_default_buffer_size;
+
+		if (sli_fc_rq_alloc(&hw->sli, rq->data,
+				    rq->entry_count,
+				    rq->data_entry_size,
+				    cq->queue,
+				    false)) {
+			efc_log_err(hw->os,
+				     "RQ allocation failure - first burst\n");
+			kfree(rq);
+			return NULL;
+		}
+		/* Update hw_rq_lookup[] */
+		hw->hw_rq_lookup[hw->rq_count] = rq->instance;
+		hw->rq_count++;
+		efc_log_debug(hw->os,
+			       "create rq[%2d] id %3d len %4d data size %4d\n",
+			 rq->instance, rq->data->id, rq->entry_count,
+			 rq->data_entry_size);
+
+		hw->hw_rq[rq->instance] = rq;
+		INIT_LIST_HEAD(&rq->list_entry);
+		list_add_tail(&rq->list_entry, &cq->q_list);
+
+		rq->rq_tracker = kmalloc_array(rq->entry_count,
+					sizeof(struct efc_hw_sequence_s *),
+					GFP_ATOMIC);
+		if (!rq->rq_tracker)
+			return NULL;
+
+		memset(rq->rq_tracker, 0,
+		       rq->entry_count * sizeof(struct efc_hw_sequence_s *));
+	}
+	return rq;
+}
+
+/**
+ * @brief Allocate a struct hw_rq_s object SET
+ *
+ * Allocate an RQ object SET, where each element in set
+ * encapsulates 2 SLI queues (for rq pair)
+ *
+ * @param cqs pointers to be associated with RQs.
+ * @param rqs RQ pointers to be returned on success.
+ * @param num_rq_pairs number of rq pairs in the Set.
+ * @param entry_count number of entries in the RQs
+ * @param ulp ULP index for this RQ
+ *
+ * @return 0 in success and -1 on failure.
+ */
+u32
+efct_hw_new_rq_set(struct hw_cq_s *cqs[], struct hw_rq_s *rqs[],
+		   u32 num_rq_pairs, u32 entry_count)
+{
+	struct efct_hw_s *hw = cqs[0]->eq->hw;
+	struct hw_rq_s *rq = NULL;
+	struct sli4_queue_s *qs[SLI_MAX_RQ_SET_COUNT * 2] = { NULL };
+	u32 i, q_count, size;
+
+	/* Initialise RQS pointers */
+	for (i = 0; i < num_rq_pairs; i++)
+		rqs[i] = NULL;
+
+	for (i = 0, q_count = 0; i < num_rq_pairs; i++, q_count += 2) {
+		rq = kmalloc(sizeof(*rq), GFP_KERNEL);
+		if (!rq)
+			goto error;
+
+		memset(rq, 0, sizeof(*rq));
+		rqs[i] = rq;
+		rq->instance = hw->hw_rq_count++;
+		rq->cq = cqs[i];
+		rq->type = SLI_QTYPE_RQ;
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
+	if (!sli_fc_rq_set_alloc(&hw->sli, num_rq_pairs, qs,
+				cqs[0]->queue->id,
+			    rqs[0]->entry_count,
+			    rqs[0]->hdr_entry_size,
+			    rqs[0]->data_entry_size)) {
+		efc_log_err(hw->os,
+			     "RQ Set allocation failure for base CQ=%d\n",
+			    cqs[0]->queue->id);
+		goto error;
+	}
+
+	for (i = 0; i < num_rq_pairs; i++) {
+		hw->hw_rq[rqs[i]->instance] = rqs[i];
+		INIT_LIST_HEAD(&rqs[i]->list_entry);
+		list_add_tail(&rqs[i]->list_entry, &cqs[i]->q_list);
+		size = sizeof(struct efc_hw_sequence_s *) * rqs[i]->entry_count;
+		rqs[i]->rq_tracker = kmalloc(size, GFP_KERNEL);
+		if (!rqs[i]->rq_tracker)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	for (i = 0; i < num_rq_pairs; i++) {
+		if (rqs[i]) {
+			kfree(rqs[i]->rq_tracker);
+			kfree(rqs[i]);
+		}
+	}
+
+	return -1;
+}
+
+/**
+ * @brief Free an EQ object
+ *
+ * The EQ object and any child queue objects are freed
+ *
+ * @param eq pointer to EQ object
+ *
+ * @return none
+ */
+void
+efct_hw_del_eq(struct hw_eq_s *eq)
+{
+	if (eq) {
+		struct hw_cq_s *cq;
+		struct hw_cq_s *cq_next;
+
+		list_for_each_entry_safe(cq, cq_next, &eq->cq_list, list_entry)
+			efct_hw_del_cq(cq);
+		efct_varray_free(eq->wq_array);
+		list_del(&eq->list_entry);
+		eq->hw->hw_eq[eq->instance] = NULL;
+		kfree(eq);
+	}
+}
+
+/**
+ * @brief Free a CQ object
+ *
+ * The CQ object and any child queue objects are freed
+ *
+ * @param cq pointer to CQ object
+ *
+ * @return none
+ */
+void
+efct_hw_del_cq(struct hw_cq_s *cq)
+{
+	if (cq) {
+		struct hw_q_s *q;
+		struct hw_q_s *q_next;
+
+		list_for_each_entry_safe(q, q_next, &cq->q_list, list_entry) {
+			switch (q->type) {
+			case SLI_QTYPE_MQ:
+				efct_hw_del_mq((struct hw_mq_s *)q);
+				break;
+			case SLI_QTYPE_WQ:
+				efct_hw_del_wq((struct hw_wq_s *)q);
+				break;
+			case SLI_QTYPE_RQ:
+				efct_hw_del_rq((struct hw_rq_s *)q);
+				break;
+			default:
+				break;
+			}
+		}
+		list_del(&cq->list_entry);
+		cq->eq->hw->hw_cq[cq->instance] = NULL;
+		kfree(cq);
+	}
+}
+
+/**
+ * @brief Free a MQ object
+ *
+ * The MQ object is freed
+ *
+ * @param mq pointer to MQ object
+ *
+ * @return none
+ */
+void
+efct_hw_del_mq(struct hw_mq_s *mq)
+{
+	if (mq) {
+		list_del(&mq->list_entry);
+		mq->cq->eq->hw->hw_mq[mq->instance] = NULL;
+		kfree(mq);
+	}
+}
+
+/**
+ * @brief Free a WQ object
+ *
+ * The WQ object is freed
+ *
+ * @param wq pointer to WQ object
+ *
+ * @return none
+ */
+void
+efct_hw_del_wq(struct hw_wq_s *wq)
+{
+	if (wq) {
+		list_del(&wq->list_entry);
+		wq->cq->eq->hw->hw_wq[wq->instance] = NULL;
+		kfree(wq);
+	}
+}
+
+/**
+ * @brief Free an RQ object
+ *
+ * The RQ object is freed
+ *
+ * @param rq pointer to RQ object
+ *
+ * @return none
+ */
+void
+efct_hw_del_rq(struct hw_rq_s *rq)
+{
+	struct efct_hw_s *hw = NULL;
+
+	if (rq) {
+		/* Free RQ tracker */
+		kfree(rq->rq_tracker);
+		rq->rq_tracker = NULL;
+		list_del(&rq->list_entry);
+		hw = rq->cq->eq->hw;
+		hw->hw_rq[rq->instance] = NULL;
+		kfree(rq);
+	}
+}
+
+/**
+ * @brief Display HW queue objects
+ *
+ * The HW queue objects are displayed using efct_log
+ *
+ * @param hw pointer to HW object
+ *
+ * @return none
+ */
+void
+efct_hw_queue_dump(struct efct_hw_s *hw)
+{
+	struct hw_eq_s *eq;
+	struct hw_cq_s *cq;
+	struct hw_q_s *q;
+	struct hw_mq_s *mq;
+	struct hw_wq_s *wq;
+	struct hw_rq_s *rq;
+
+	list_for_each_entry(eq, &hw->eq_list, list_entry) {
+		efc_log_debug(hw->os, "eq[%d] id %2d\n",
+			       eq->instance, eq->queue->id);
+		list_for_each_entry(cq, &eq->cq_list, list_entry) {
+			efc_log_debug(hw->os, "cq[%d] id %2d current\n",
+				       cq->instance, cq->queue->id);
+			list_for_each_entry(q, &cq->q_list, list_entry) {
+				switch (q->type) {
+				case SLI_QTYPE_MQ:
+					mq = (struct hw_mq_s *)q;
+					efc_log_debug(hw->os,
+						       "    mq[%d] id %2d\n",
+					       mq->instance, mq->queue->id);
+					break;
+				case SLI_QTYPE_WQ:
+					wq = (struct hw_wq_s *)q;
+					efc_log_debug(hw->os,
+						       "    wq[%d] id %2d\n",
+						wq->instance, wq->queue->id);
+					break;
+				case SLI_QTYPE_RQ:
+					rq = (struct hw_rq_s *)q;
+					efc_log_debug(hw->os,
+						       "    rq[%d] hdr id %2d\n",
+					       rq->instance, rq->hdr->id);
+					break;
+				default:
+					break;
+				}
+			}
+		}
+	}
+}
+
+/**
+ * @brief Teardown HW queue objects
+ *
+ * The HW queue objects are freed
+ *
+ * @param hw pointer to HW object
+ *
+ * @return none
+ */
+void
+efct_hw_queue_teardown(struct efct_hw_s *hw)
+{
+	u32 i;
+	struct hw_eq_s *eq;
+	struct hw_eq_s *eq_next;
+
+	if (hw->eq_list.next) {
+		list_for_each_entry_safe(eq, eq_next, &hw->eq_list,
+					 list_entry) {
+			efct_hw_del_eq(eq);
+		}
+	}
+	for (i = 0; i < ARRAY_SIZE(hw->wq_cpu_array); i++) {
+		efct_varray_free(hw->wq_cpu_array[i]);
+		hw->wq_cpu_array[i] = NULL;
+	}
+	for (i = 0; i < ARRAY_SIZE(hw->wq_class_array); i++) {
+		efct_varray_free(hw->wq_class_array[i]);
+		hw->wq_class_array[i] = NULL;
+	}
+}
+
+/**
+ * @brief Allocate a WQ to an IO object
+ *
+ * The next work queue index is used to assign a WQ to an IO.
+ *
+ * If wq_steering is EFCT_HW_WQ_STEERING_CLASS, a WQ from io->wq_class is
+ * selected.
+ *
+ * If wq_steering is EFCT_HW_WQ_STEERING_REQUEST, then a WQ from the EQ that
+ * the IO request came in on is selected.
+ *
+ * If wq_steering is EFCT_HW_WQ_STEERING_CPU, then a WQ associted with the
+ * CPU the request is made on is selected.
+ *
+ * @param hw pointer to HW object
+ * @param io pointer to IO object
+ *
+ * @return Return pointer to next WQ
+ */
+struct hw_wq_s *
+efct_hw_queue_next_wq(struct efct_hw_s *hw, struct efct_hw_io_s *io)
+{
+	struct hw_eq_s *eq;
+	struct hw_wq_s *wq = NULL;
+	u32 cpuidx;
+
+	switch (io->wq_steering) {
+	case EFCT_HW_WQ_STEERING_CLASS:
+		if (unlikely(io->wq_class >= ARRAY_SIZE(hw->wq_class_array)))
+			break;
+
+		wq = efct_varray_iter_next(hw->wq_class_array[io->wq_class]);
+		break;
+	case EFCT_HW_WQ_STEERING_REQUEST:
+		eq = io->eq;
+		if (likely(eq))
+			wq = efct_varray_iter_next(eq->wq_array);
+		break;
+	case EFCT_HW_WQ_STEERING_CPU:
+		cpuidx = in_interrupt() ?
+			raw_smp_processor_id() : task_cpu(current);
+
+		if (likely(cpuidx < ARRAY_SIZE(hw->wq_cpu_array)))
+			wq = efct_varray_iter_next(hw->wq_cpu_array[cpuidx]);
+		break;
+	}
+
+	if (unlikely(!wq))
+		wq = hw->hw_wq[0];
+
+	return wq;
+}
+
+/**
+ * @brief Return count of EQs for a queue topology object
+ *
+ * The EQ count for in the HWs queue topology (hw->qtop) object is returned
+ *
+ * @param hw pointer to HW object
+ *
+ * @return count of EQs
+ */
+u32
+efct_hw_qtop_eq_count(struct efct_hw_s *hw)
+{
+	return hw->qtop->entry_counts[QTOP_EQ];
+}
+
+#define TOKEN_LEN		32
+
+/**
+ * @brief Declare token types
+ */
+enum tok_type_e {
+	TOK_LPAREN = 1,
+	TOK_RPAREN,
+	TOK_COLON,
+	TOK_EQUALS,
+	TOK_QUEUE,
+	TOK_ATTR_NAME,
+	TOK_NUMBER,
+	TOK_NUMBER_VALUE,
+	TOK_NUMBER_LIST,
+};
+
+/**
+ * @brief Declare token sub-types
+ */
+enum tok_subtype_e {
+	TOK_SUB_EQ = 100,
+	TOK_SUB_CQ,
+	TOK_SUB_RQ,
+	TOK_SUB_MQ,
+	TOK_SUB_WQ,
+	TOK_SUB_LEN,
+	TOK_SUB_CLASS,
+	TOK_SUB_ULP,
+	TOK_SUB_FILTER,
+};
+
+/**
+ * @brief convert queue subtype to QTOP entry
+ *
+ * @param q queue subtype
+ *
+ * @return QTOP entry or 0
+ */
+static enum efct_hw_qtop_entry_e
+subtype2qtop(enum tok_subtype_e q)
+{
+	switch (q) {
+	case TOK_SUB_EQ:	return QTOP_EQ;
+	case TOK_SUB_CQ:	return QTOP_CQ;
+	case TOK_SUB_RQ:	return QTOP_RQ;
+	case TOK_SUB_MQ:	return QTOP_MQ;
+	case TOK_SUB_WQ:	return QTOP_WQ;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/**
+ * @brief Declare token object
+ */
+struct tok_s {
+	enum tok_type_e type;
+	enum tok_subtype_e subtype;
+	char string[TOKEN_LEN];
+};
+
+/**
+ * @brief Declare token array object
+ */
+struct tokarray_s {
+	struct tok_s *tokens;		/* Pointer to array of tokens */
+	u32 alloc_count;		/* Number of tokens in the array */
+	u32 inuse_count;		/* Number of tokens posted to array */
+	u32 iter_idx;		/* Iterator index */
+};
+
+/**
+ * @brief Declare token match structure
+ */
+struct tokmatch_s {
+	char *s;
+	enum tok_type_e type;
+	enum tok_subtype_e subtype;
+};
+
+/**
+ * @brief test if character is ID start character
+ *
+ * @param c character to test
+ *
+ * @return TRUE if character is an ID start character
+ */
+static int
+idstart(int c)
+{
+	return	isalpha(c) || (c == '_') || (c == '$');
+}
+
+/**
+ * @brief test if character is an ID character
+ *
+ * @param c character to test
+ *
+ * @return TRUE if character is an ID character
+ */
+static int
+idchar(int c)
+{
+	return idstart(c) || isdigit(c);
+}
+
+/**
+ * @brief Declare single character matches
+ */
+static struct tokmatch_s cmatches[] = {
+	{"(", TOK_LPAREN},
+	{")", TOK_RPAREN},
+	{":", TOK_COLON},
+	{"=", TOK_EQUALS},
+};
+
+/**
+ * @brief Declare identifier match strings
+ */
+static struct tokmatch_s smatches[] = {
+	{"eq", TOK_QUEUE, TOK_SUB_EQ},
+	{"cq", TOK_QUEUE, TOK_SUB_CQ},
+	{"rq", TOK_QUEUE, TOK_SUB_RQ},
+	{"mq", TOK_QUEUE, TOK_SUB_MQ},
+	{"wq", TOK_QUEUE, TOK_SUB_WQ},
+	{"len", TOK_ATTR_NAME, TOK_SUB_LEN},
+	{"class", TOK_ATTR_NAME, TOK_SUB_CLASS},
+	{"ulp", TOK_ATTR_NAME, TOK_SUB_ULP},
+	{"filter", TOK_ATTR_NAME, TOK_SUB_FILTER},
+};
+
+/**
+ * @brief Scan string and return next token
+ *
+ * The string is scanned and the next token is returned
+ *
+ * @param s input string to scan
+ * @param tok pointer to place scanned token
+ *
+ * @return pointer to input string following scanned token, or NULL
+ */
+static const char *
+tokenize(const char *s, struct tok_s *tok)
+{
+	u32 i;
+
+	memset(tok, 0, sizeof(*tok));
+
+	/* Skip over whitespace */
+	while (*s && isspace(*s))
+		s++;
+
+	/* Return if nothing left in this string */
+	if (*s == 0)
+		return NULL;
+
+	/* Look for single character matches */
+	for (i = 0; i < ARRAY_SIZE(cmatches); i++) {
+		if (cmatches[i].s[0] == *s) {
+			tok->type = cmatches[i].type;
+			tok->subtype = cmatches[i].subtype;
+			tok->string[0] = *s++;
+			return s;
+		}
+	}
+
+	/* Scan for a hex number or decimal */
+	if ((s[0] == '0') && ((s[1] == 'x') || (s[1] == 'X'))) {
+		char *p = tok->string;
+
+		tok->type = TOK_NUMBER;
+
+		*p++ = *s++;
+		*p++ = *s++;
+		while ((*s == '.') || isxdigit(*s)) {
+			if ((p - tok->string) < (int)sizeof(tok->string))
+				*p++ = *s;
+			if (*s == ',')
+				tok->type = TOK_NUMBER_LIST;
+			s++;
+		}
+		*p = 0;
+		return s;
+	} else if (isdigit(*s)) {
+		char *p = tok->string;
+
+		tok->type = TOK_NUMBER;
+		while ((*s == ',') || isdigit(*s)) {
+			if ((p - tok->string) < (int)sizeof(tok->string))
+				*p++ = *s;
+			if (*s == ',')
+				tok->type = TOK_NUMBER_LIST;
+			s++;
+		}
+		*p = 0;
+		return s;
+	}
+
+	/* Scan for an ID */
+	if (idstart(*s)) {
+		char *p = tok->string;
+
+		for (*p++ = *s++; idchar(*s); s++) {
+			if ((p - tok->string) < TOKEN_LEN)
+				*p++ = *s;
+		}
+
+		/* See if this is a $ number value */
+		if (tok->string[0] == '$') {
+			tok->type = TOK_NUMBER_VALUE;
+		} else {
+			/* Look for a string match */
+			for (i = 0; i < ARRAY_SIZE(smatches); i++) {
+				if (strcmp(smatches[i].s, tok->string) == 0) {
+					tok->type = smatches[i].type;
+					tok->subtype = smatches[i].subtype;
+					return s;
+				}
+			}
+		}
+	}
+	return s;
+}
+
+/**
+ * @brief convert token type to string
+ *
+ * @param type token type
+ *
+ * @return string, or "unknown"
+ */
+static const char *
+token_type2s(enum tok_type_e type)
+{
+	switch (type) {
+	case TOK_LPAREN:
+		return "TOK_LPAREN";
+	case TOK_RPAREN:
+		return "TOK_RPAREN";
+	case TOK_COLON:
+		return "TOK_COLON";
+	case TOK_EQUALS:
+		return "TOK_EQUALS";
+	case TOK_QUEUE:
+		return "TOK_QUEUE";
+	case TOK_ATTR_NAME:
+		return "TOK_ATTR_NAME";
+	case TOK_NUMBER:
+		return "TOK_NUMBER";
+	case TOK_NUMBER_VALUE:
+		return "TOK_NUMBER_VALUE";
+	case TOK_NUMBER_LIST:
+		return "TOK_NUMBER_LIST";
+	}
+	return "unknown";
+}
+
+/**
+ * @brief convert token sub-type to string
+ *
+ * @param subtype token sub-type
+ *
+ * @return string, or "unknown"
+ */
+static const char *
+token_subtype2s(enum tok_subtype_e subtype)
+{
+	switch (subtype) {
+	case TOK_SUB_EQ:
+		return "TOK_SUB_EQ";
+	case TOK_SUB_CQ:
+		return "TOK_SUB_CQ";
+	case TOK_SUB_RQ:
+		return "TOK_SUB_RQ";
+	case TOK_SUB_MQ:
+		return "TOK_SUB_MQ";
+	case TOK_SUB_WQ:
+		return "TOK_SUB_WQ";
+	case TOK_SUB_LEN:
+		return "TOK_SUB_LEN";
+	case TOK_SUB_CLASS:
+		return "TOK_SUB_CLASS";
+	case TOK_SUB_ULP:
+		return "TOK_SUB_ULP";
+	case TOK_SUB_FILTER:
+		return "TOK_SUB_FILTER";
+	}
+	return "";
+}
+
+/**
+ * @brief Generate syntax error message
+ *
+ * A syntax error message is found, the input tokens are dumped up to and
+ * including the token that failed as indicated by the current iterator index.
+ *
+ * @param hw pointer to HW object
+ * @param tokarray pointer to token array object
+ *
+ * @return none
+ */
+static void
+tok_syntax(struct efct_hw_s *hw, struct tokarray_s *tokarray)
+{
+	u32 i;
+	struct tok_s *tok;
+
+	efc_log_test(hw->os, "Syntax error:\n");
+
+	for (i = 0, tok = tokarray->tokens; (i <= tokarray->inuse_count);
+	     i++, tok++) {
+		efc_log_test(hw->os, "%s [%2d]    %-16s %-16s %s\n",
+			      (i == tokarray->iter_idx) ? ">>>" : "   ", i,
+			     token_type2s(tok->type),
+			     token_subtype2s(tok->subtype), tok->string);
+	}
+}
+
+/**
+ * @brief parse a number
+ *
+ * Parses tokens of type TOK_NUMBER and TOK_NUMBER_VALUE, returning a numeric
+ * value
+ *
+ * @param hw pointer to HW object
+ * @param qtop pointer to QTOP object
+ * @param tok pointer to token to parse
+ *
+ * @return numeric value
+ */
+static u32
+tok_getnumber(struct efct_hw_s *hw, struct efct_hw_qtop_s *qtop,
+	      struct tok_s *tok)
+{
+	u32 rval = 0;
+	u32 num_cpus = num_online_cpus();
+
+	switch (tok->type) {
+	case TOK_NUMBER_VALUE:
+		if (strcmp(tok->string, "$ncpu") == 0)
+			rval = num_cpus;
+		else if (strcmp(tok->string, "$ncpu1") == 0)
+			rval = num_cpus - 1;
+		else if (strcmp(tok->string, "$nwq") == 0)
+			rval = (hw) ? hw->config.n_wq : 0;
+		else if (strcmp(tok->string, "$maxmrq") == 0)
+			rval = (num_cpus < EFCT_HW_MAX_MRQS)
+				? num_cpus : EFCT_HW_MAX_MRQS;
+		else if (strcmp(tok->string, "$nulp") == 0)
+			rval = hw->ulp_max - hw->ulp_start + 1;
+		else if ((qtop->rptcount_idx > 0) &&
+			 strcmp(tok->string, "$rpt0") == 0)
+			rval = qtop->rptcount[qtop->rptcount_idx - 1];
+		else if ((qtop->rptcount_idx > 1) &&
+			 strcmp(tok->string, "$rpt1") == 0)
+			rval = qtop->rptcount[qtop->rptcount_idx - 2];
+		else if ((qtop->rptcount_idx > 2) &&
+			 strcmp(tok->string, "$rpt2") == 0)
+			rval = qtop->rptcount[qtop->rptcount_idx - 3];
+		else if ((qtop->rptcount_idx > 3) &&
+			 strcmp(tok->string, "$rpt3") == 0)
+			rval = qtop->rptcount[qtop->rptcount_idx - 4];
+		else if (kstrtou32(tok->string, 0, &rval))
+			efc_log_debug(hw->os, "kstrtou32 failed\n");
+
+		break;
+	case TOK_NUMBER:
+		if (kstrtou32(tok->string, 0, &rval))
+			efc_log_debug(hw->os, "kstrtou32 failed\n");
+		break;
+	default:
+		break;
+	}
+	return rval;
+}
+
+/**
+ * @brief parse subfilter of a token
+ *
+ * The tokens are semantically parsed, to generate QTOP entries.
+ *
+ * @param pointer queue type
+ * @param token
+ * @param qtop ouptut QTOP object
+ *
+ * @return Nothing.
+ */
+static void
+parse_sub_filter(struct efct_hw_s *hw, struct efct_hw_qtop_entry_s *qt,
+		 struct tok_s *tok, struct efct_hw_qtop_s *qtop)
+{
+	u32 mask = 0;
+	char *p;
+	u32 v;
+
+	if (tok[3].type == TOK_NUMBER_LIST) {
+		mask = 0;
+		p = tok[3].string;
+
+		while ((p) && *p) {
+			if (kstrtou32(p, 0, &v))
+				efc_log_debug(hw->os, "kstrtou32 failed\n");
+			if (v < 32)
+				mask |= (1U << v);
+
+			p = strchr(p, ',');
+			if (p)
+				p++;
+		}
+		qt->filter_mask = mask;
+	} else {
+		qt->filter_mask = (1U << tok_getnumber(hw, qtop, &tok[3]));
+	}
+}
+
+/**
+ * @brief parse an array of tokens
+ *
+ * The tokens are semantically parsed, to generate QTOP entries.
+ *
+ * @param hw pointer to HW object
+ * @param tokarray array array of tokens
+ * @param qtop ouptut QTOP object
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+static int
+parse_topology(struct efct_hw_s *hw, struct tokarray_s *tokarray,
+	       struct efct_hw_qtop_s *qtop)
+{
+	struct efct_hw_qtop_entry_s *qt = qtop->entries + qtop->inuse_count;
+	struct tok_s *tok;
+	u32 num = 0;
+
+	for (; (tokarray->iter_idx < tokarray->inuse_count) &&
+	     ((tok = &tokarray->tokens[tokarray->iter_idx]) != NULL);) {
+		if (qtop->inuse_count >= qtop->alloc_count)
+			return -1;
+
+		qt = qtop->entries + qtop->inuse_count;
+
+		switch (tok[0].type) {
+		case TOK_QUEUE:
+			qt->entry = subtype2qtop(tok[0].subtype);
+			qt->set_default = false;
+			qt->len = 0;
+			qt->class = 0;
+			qtop->inuse_count++;
+
+			/* Advance current token index */
+			tokarray->iter_idx++;
+
+			/*
+			 * Parse for queue attributes, possibly multiple
+			 * instances
+			 */
+			while ((tokarray->iter_idx + 4) <=
+				tokarray->inuse_count) {
+				tok = &tokarray->tokens[tokarray->iter_idx];
+				if (tok[0].type == TOK_COLON &&
+				    tok[1].type == TOK_ATTR_NAME &&
+					tok[2].type == TOK_EQUALS &&
+					(tok[3].type == TOK_NUMBER ||
+					 tok[3].type == TOK_NUMBER_VALUE ||
+					 tok[3].type == TOK_NUMBER_LIST)) {
+					num = tok_getnumber(hw, qtop, &tok[3]);
+
+					switch (tok[1].subtype) {
+					case TOK_SUB_LEN:
+						qt->len = num;
+						break;
+					case TOK_SUB_CLASS:
+						qt->class = num;
+						break;
+					case TOK_SUB_ULP:
+						qt->ulp = num;
+						break;
+					case TOK_SUB_FILTER:
+						parse_sub_filter(hw, qt, tok,
+								 qtop);
+						break;
+					default:
+						break;
+					}
+					/* Advance current token index */
+					tokarray->iter_idx += 4;
+				} else {
+					break;
+				}
+				num = 0;
+			}
+			qtop->entry_counts[qt->entry]++;
+			break;
+
+		case TOK_ATTR_NAME:
+			if (((tokarray->iter_idx + 5) <=
+			      tokarray->inuse_count) &&
+			      tok[1].type == TOK_COLON &&
+			      tok[2].type == TOK_QUEUE &&
+			      tok[3].type == TOK_EQUALS &&
+			      (tok[4].type == TOK_NUMBER ||
+			      tok[4].type == TOK_NUMBER_VALUE)) {
+				qt->entry = subtype2qtop(tok[2].subtype);
+				qt->set_default = true;
+				switch (tok[0].subtype) {
+				case TOK_SUB_LEN:
+					qt->len = tok_getnumber(hw, qtop,
+								&tok[4]);
+					break;
+				case TOK_SUB_CLASS:
+					qt->class = tok_getnumber(hw, qtop,
+								  &tok[4]);
+					break;
+				case TOK_SUB_ULP:
+					qt->ulp = tok_getnumber(hw, qtop,
+								&tok[4]);
+					break;
+				default:
+					break;
+				}
+				qtop->inuse_count++;
+				tokarray->iter_idx += 5;
+			} else {
+				tok_syntax(hw, tokarray);
+				return -1;
+			}
+			break;
+
+		case TOK_NUMBER:
+		case TOK_NUMBER_VALUE: {
+			u32 rpt_count = 1;
+			u32 i;
+			u32 rpt_idx;
+
+			rpt_count = tok_getnumber(hw, qtop, tok);
+
+			if (tok[1].type == TOK_LPAREN) {
+				u32 iter_idx_save;
+
+				tokarray->iter_idx += 2;
+
+				/* save token array iteration index */
+				iter_idx_save = tokarray->iter_idx;
+
+				for (i = 0; i < rpt_count; i++) {
+					rpt_idx = qtop->rptcount_idx;
+
+					if (qtop->rptcount_idx <
+					    ARRAY_SIZE(qtop->rptcount)) {
+						qtop->rptcount[rpt_idx + 1] = i;
+					}
+
+					/* restore token array iteration idx */
+					tokarray->iter_idx = iter_idx_save;
+
+					/* parse, append to qtop */
+					parse_topology(hw, tokarray, qtop);
+
+					qtop->rptcount_idx = rpt_idx;
+				}
+			}
+			break;
+		}
+
+		case TOK_RPAREN:
+			tokarray->iter_idx++;
+			return 0;
+
+		default:
+			tok_syntax(hw, tokarray);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+/**
+ * @brief Parse queue topology string
+ *
+ * The queue topology object is allocated, and filled with the results of
+ * parsing the passed in queue topology string
+ *
+ * @param hw pointer to HW object
+ * @param qtop_string input queue topology string
+ *
+ * @return pointer to allocated QTOP object, or NULL if there was an error
+ */
+struct efct_hw_qtop_s *
+efct_hw_qtop_parse(struct efct_hw_s *hw, const char *qtop_string)
+{
+	struct efct_hw_qtop_s *qtop;
+	struct tokarray_s tokarray;
+	const char *s;
+
+	efc_log_debug(hw->os, "queue topology: %s\n", qtop_string);
+
+	/* Allocate a token array */
+	tokarray.tokens = kmalloc_array(MAX_TOKENS, sizeof(*tokarray.tokens),
+					GFP_KERNEL);
+	if (!tokarray.tokens)
+		return NULL;
+	memset(tokarray.tokens, 0, MAX_TOKENS * sizeof(*tokarray.tokens));
+	tokarray.alloc_count = MAX_TOKENS;
+	tokarray.inuse_count = 0;
+	tokarray.iter_idx = 0;
+
+	/* Parse the tokens */
+	for (s = qtop_string; (tokarray.inuse_count < tokarray.alloc_count) &&
+	     ((s = tokenize(s, &tokarray.tokens[tokarray.inuse_count]))) !=
+	       NULL;)
+		tokarray.inuse_count++;
+
+	/* Allocate a queue topology structure */
+	qtop = kmalloc(sizeof(*qtop), GFP_KERNEL);
+	if (!qtop) {
+		kfree(tokarray.tokens);
+		efc_log_err(hw->os, "malloc qtop failed\n");
+		return NULL;
+	}
+	memset(qtop, 0, sizeof(*qtop));
+	qtop->os = hw->os;
+
+	/* Allocate queue topology entries */
+	qtop->entries = kzalloc((EFCT_HW_MAX_QTOP_ENTRIES *
+				sizeof(*qtop->entries)), GFP_ATOMIC);
+	if (!qtop->entries) {
+		kfree(qtop);
+		kfree(tokarray.tokens);
+		return NULL;
+	}
+	qtop->alloc_count = EFCT_HW_MAX_QTOP_ENTRIES;
+	qtop->inuse_count = 0;
+
+	/* Parse the tokens */
+	if (parse_topology(hw, &tokarray, qtop)) {
+		efc_log_err(hw->os, "failed to parse tokens\n");
+		efct_hw_qtop_free(qtop);
+		kfree(tokarray.tokens);
+		return NULL;
+	}
+
+	/* Free the tokens array */
+	kfree(tokarray.tokens);
+
+	return qtop;
+}
+
+/**
+ * @brief free queue topology object
+ *
+ * @param qtop pointer to QTOP object
+ *
+ * @return none
+ */
+void
+efct_hw_qtop_free(struct efct_hw_qtop_s *qtop)
+{
+	if (qtop) {
+		kfree(qtop->entries);
+		kfree(qtop);
+	}
+}
diff --git a/drivers/scsi/elx/efct/efct_hw_queues.h b/drivers/scsi/elx/efct/efct_hw_queues.h
new file mode 100644
index 000000000000..363d48906670
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_hw_queues.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFCT_HW_QUEUES_H__
+#define __EFCT_HW_QUEUES_H__
+
+#define EFCT_HW_MQ_DEPTH	128
+#include "efct_hw.h"
+
+enum efct_hw_qtop_entry_e {
+	QTOP_EQ = 0,
+	QTOP_CQ,
+	QTOP_WQ,
+	QTOP_RQ,
+	QTOP_MQ,
+	QTOP_LAST,
+};
+
+struct efct_hw_qtop_entry_s {
+	enum efct_hw_qtop_entry_e entry;
+	bool set_default;
+	u32 len;
+	u8 class;
+	u8 ulp;
+	u8 filter_mask;
+};
+
+struct efct_hw_mrq_s {
+	struct rq_config {
+		struct hw_eq_s *eq;
+		u32 len;
+		u8 class;
+		u8 ulp;
+		u8 filter_mask;
+	} rq_cfg[16];
+	u32 num_pairs;
+};
+
+#define MAX_TOKENS			256
+#define EFCT_HW_MAX_QTOP_ENTRIES	200
+
+struct efct_hw_qtop_s {
+	void *os;
+	struct efct_hw_qtop_entry_s *entries;
+	u32 alloc_count;
+	u32 inuse_count;
+	u32 entry_counts[QTOP_LAST];
+	u32 rptcount[10];
+	u32 rptcount_idx;
+};
+
+struct efct_hw_qtop_s *
+efct_hw_qtop_parse(struct efct_hw_s *hw, const char *qtop_string);
+void efct_hw_qtop_free(struct efct_hw_qtop_s *qtop);
+const char *efct_hw_qtop_entry_name(enum efct_hw_qtop_entry_e entry);
+u32 efct_hw_qtop_eq_count(struct efct_hw_s *hw);
+
+enum efct_hw_rtn_e
+efct_hw_init_queues(struct efct_hw_s *hw, struct efct_hw_qtop_s *qtop);
+extern  struct hw_wq_s
+*efct_hw_queue_next_wq(struct efct_hw_s *hw, struct efct_hw_io_s *io);
+
+#endif /* __EFCT_HW_QUEUES_H__ */
-- 
2.13.7

