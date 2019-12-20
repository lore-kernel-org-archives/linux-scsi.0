Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61007C2D0D3
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 337212082E
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 22:37:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="okHZj2ex"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfLTWhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 17:37:53 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:39335 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfLTWhx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Dec 2019 17:37:53 -0500
Received: by mail-pl1-f173.google.com with SMTP id g6so1761028plp.6
        for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2019 14:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TR50D1oWdKZG2Cyvx16HWmJZASkpTJakL1ivm45biiA=;
        b=okHZj2exdgxGH3Xdn1GgRKcECr8idDNfyqqXRPI7Kn1/BD4y3Do6nnQ/gbSwLcgFOG
         uKPzGSZIFfcZbWuz8YNWNDVxMrHK2QipATgHWdICi2Q5I5EfLZ9tdU8Nm0YTXvSBYqup
         9KcjrfkWK82bq1b2prBAYaZfgrDcadrlgnZdcxlvcGpBMtop7x2LxLmJH5zVLfcVt9Zs
         DGhwCjdBivRY8MPmTSf6FLqJmPEWojflXJlzifRyZVqjA95NWKtdp9ZTL0+vRyMV95hn
         KZqi4Re2mnNzLdShKMA0PsyYZOWI20woqXtc+hd+U4dLFMnlyJD4RPK8YxJYQkxElZGQ
         KL/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TR50D1oWdKZG2Cyvx16HWmJZASkpTJakL1ivm45biiA=;
        b=EngDeioW6cXQqes7kdEezlD6GT3w3LOG40DUqXO3OqGGh0vt1irWSTxiLiYxK6vDHW
         NXyykZg7v7HL9jtCiAkJYme0TY6QNg5BGby9QYTOKC0xaPIcBFhOlgyw6qQg5Yuh1Zjz
         aTJ4t2NcAaQ/qBkmbCZr44FKFwYI6fz/7OmGlfAUIiVim55KlREvcLEIaMUaOnCUbJvj
         fg2dPLmlfBe6aYz4aMu9Kc7hJsLNERvXD7Itzmv3n/nR7sOt5iCteKU6PPdsx7QLdhEg
         QnoXrHMXJulJmUJcme7odV6SA3UQrdQIbtpBbWJl4bMn6VefjZuFRByr/Grx14n4F0bY
         2VGQ==
X-Gm-Message-State: APjAAAWdWu25RYIPrxm2b96YMI2XK5z+tPUHmn5/qSFrrsE/1dilGYlp
        helb6VL46+16NP55FP4oUC++LY5R
X-Google-Smtp-Source: APXvYqyIw6SDcQkB00Kj6LvBQRWmpcSA8VKci3Ctw9Hx1d2ZAxHarAsbltNNeOpClaxT1j5Su0D3mw==
X-Received: by 2002:a17:90a:d50:: with SMTP id 16mr18705621pju.117.1576881471050;
        Fri, 20 Dec 2019 14:37:51 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j28sm12219877pgb.36.2019.12.20.14.37.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Dec 2019 14:37:50 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     maier@linux.ibm.com, dwagner@suse.de, bvanassche@acm.org,
        James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v2 17/32] elx: efct: Hardware queues creation and deletion
Date:   Fri, 20 Dec 2019 14:37:08 -0800
Message-Id: <20191220223723.26563-18-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20191220223723.26563-1-jsmart2021@gmail.com>
References: <20191220223723.26563-1-jsmart2021@gmail.com>
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
 drivers/scsi/elx/efct/efct_hw_queues.c | 1456 ++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw_queues.h |   67 ++
 2 files changed, 1523 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.c
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.h

diff --git a/drivers/scsi/elx/efct/efct_hw_queues.c b/drivers/scsi/elx/efct/efct_hw_queues.c
new file mode 100644
index 000000000000..8bbeef8ad22d
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_hw_queues.c
@@ -0,0 +1,1456 @@
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
+/**
+ * Given the parsed queue topology spec, the SLI queues are created and
+ * initialized
+ */
+enum efct_hw_rtn
+efct_hw_init_queues(struct efct_hw *hw, struct efct_hw_qtop *qtop)
+{
+	u32 i, j, k;
+	u32 default_lengths[QTOP_LAST], len;
+	u32 rqset_len = 0, rqset_count = 0;
+	u8 rqset_filter_mask = 0;
+	struct hw_eq *eqs[EFCT_HW_MAX_MRQS];
+	struct hw_cq *cqs[EFCT_HW_MAX_MRQS];
+	struct hw_rq *rqs[EFCT_HW_MAX_MRQS];
+	struct efct_hw_qtop_entry *qt, *next_qt;
+	struct efct_hw_mrq mrq;
+	bool use_mrq = false;
+
+	struct hw_eq *eq = NULL;
+	struct hw_cq *cq = NULL;
+	struct hw_wq *wq = NULL;
+	struct hw_rq *rq = NULL;
+	struct hw_mq *mq = NULL;
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
+/* Allocate a new EQ object */
+struct hw_eq *
+efct_hw_new_eq(struct efct_hw *hw, u32 entry_count)
+{
+	struct hw_eq *eq = kmalloc(sizeof(*eq), GFP_KERNEL);
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
+/* Allocate a new CQ object */
+struct hw_cq *
+efct_hw_new_cq(struct hw_eq *eq, u32 entry_count)
+{
+	struct efct_hw *hw = eq->hw;
+	struct hw_cq *cq = kmalloc(sizeof(*cq), GFP_KERNEL);
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
+/* Allocate a new CQ Set of objects */
+u32
+efct_hw_new_cq_set(struct hw_eq *eqs[], struct hw_cq *cqs[],
+		   u32 num_cqs, u32 entry_count)
+{
+	u32 i;
+	struct efct_hw *hw = eqs[0]->hw;
+	struct sli4 *sli4 = &hw->sli;
+	struct hw_cq *cq = NULL;
+	struct sli4_queue *qs[SLI_MAX_CQ_SET_COUNT];
+	struct sli4_queue *assefct[SLI_MAX_CQ_SET_COUNT];
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
+/* Allocate a new MQ object */
+struct hw_mq *
+efct_hw_new_mq(struct hw_cq *cq, u32 entry_count)
+{
+	struct efct_hw *hw = cq->eq->hw;
+	struct hw_mq *mq = kmalloc(sizeof(*mq), GFP_KERNEL);
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
+/* Allocate a new WQ object */
+struct hw_wq *
+efct_hw_new_wq(struct hw_cq *cq, u32 entry_count,
+	       u32 class, u32 ulp)
+{
+	struct efct_hw *hw = cq->eq->hw;
+	struct hw_wq *wq = kmalloc(sizeof(*wq), GFP_KERNEL);
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
+/* Allocate an RQ object, which encapsulates 2 SLI queues (for rq pair) */
+struct hw_rq *
+efct_hw_new_rq(struct hw_cq *cq, u32 entry_count, u32 ulp)
+{
+	struct efct_hw *hw = cq->eq->hw;
+	struct hw_rq *rq = kmalloc(sizeof(*rq), GFP_KERNEL);
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
+					sizeof(struct efc_hw_sequence *),
+					GFP_ATOMIC);
+		if (!rq->rq_tracker)
+			return NULL;
+
+		memset(rq->rq_tracker, 0,
+		       rq->entry_count * sizeof(struct efc_hw_sequence *));
+	}
+	return rq;
+}
+
+/**
+ * Allocate an RQ object SET, where each element in set
+ * encapsulates 2 SLI queues (for rq pair)
+ */
+u32
+efct_hw_new_rq_set(struct hw_cq *cqs[], struct hw_rq *rqs[],
+		   u32 num_rq_pairs, u32 entry_count)
+{
+	struct efct_hw *hw = cqs[0]->eq->hw;
+	struct hw_rq *rq = NULL;
+	struct sli4_queue *qs[SLI_MAX_RQ_SET_COUNT * 2] = { NULL };
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
+		size = sizeof(struct efc_hw_sequence *) * rqs[i]->entry_count;
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
+void
+efct_hw_del_eq(struct hw_eq *eq)
+{
+	if (eq) {
+		struct hw_cq *cq;
+		struct hw_cq *cq_next;
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
+void
+efct_hw_del_cq(struct hw_cq *cq)
+{
+	if (cq) {
+		struct hw_q *q;
+		struct hw_q *q_next;
+
+		list_for_each_entry_safe(q, q_next, &cq->q_list, list_entry) {
+			switch (q->type) {
+			case SLI_QTYPE_MQ:
+				efct_hw_del_mq((struct hw_mq *)q);
+				break;
+			case SLI_QTYPE_WQ:
+				efct_hw_del_wq((struct hw_wq *)q);
+				break;
+			case SLI_QTYPE_RQ:
+				efct_hw_del_rq((struct hw_rq *)q);
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
+void
+efct_hw_del_mq(struct hw_mq *mq)
+{
+	if (mq) {
+		list_del(&mq->list_entry);
+		mq->cq->eq->hw->hw_mq[mq->instance] = NULL;
+		kfree(mq);
+	}
+}
+
+void
+efct_hw_del_wq(struct hw_wq *wq)
+{
+	if (wq) {
+		list_del(&wq->list_entry);
+		wq->cq->eq->hw->hw_wq[wq->instance] = NULL;
+		kfree(wq);
+	}
+}
+
+void
+efct_hw_del_rq(struct hw_rq *rq)
+{
+	struct efct_hw *hw = NULL;
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
+void
+efct_hw_queue_dump(struct efct_hw *hw)
+{
+	struct hw_eq *eq;
+	struct hw_cq *cq;
+	struct hw_q *q;
+	struct hw_mq *mq;
+	struct hw_wq *wq;
+	struct hw_rq *rq;
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
+					mq = (struct hw_mq *)q;
+					efc_log_debug(hw->os,
+						       "    mq[%d] id %2d\n",
+					       mq->instance, mq->queue->id);
+					break;
+				case SLI_QTYPE_WQ:
+					wq = (struct hw_wq *)q;
+					efc_log_debug(hw->os,
+						       "    wq[%d] id %2d\n",
+						wq->instance, wq->queue->id);
+					break;
+				case SLI_QTYPE_RQ:
+					rq = (struct hw_rq *)q;
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
+void
+efct_hw_queue_teardown(struct efct_hw *hw)
+{
+	u32 i;
+	struct hw_eq *eq;
+	struct hw_eq *eq_next;
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
+ * Allocate a WQ to an IO object
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
+ */
+struct hw_wq *
+efct_hw_queue_next_wq(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	struct hw_eq *eq;
+	struct hw_wq *wq = NULL;
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
+u32
+efct_hw_qtop_eq_count(struct efct_hw *hw)
+{
+	return hw->qtop->entry_counts[QTOP_EQ];
+}
+
+#define TOKEN_LEN		32
+
+/* token types */
+enum tok_type {
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
+/* token sub-types */
+enum tok_subtype {
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
+/* convert queue subtype to QTOP entry */
+static enum efct_hw_qtop_type
+subtype2qtop(enum tok_subtype q)
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
+/* Declare token object */
+struct tok {
+	enum tok_type type;
+	enum tok_subtype subtype;
+	char string[TOKEN_LEN];
+};
+
+/* Declare token array object */
+struct tokarray {
+	struct tok *tokens;
+	u32 alloc_count;
+	u32 inuse_count;
+	u32 iter_idx;
+};
+
+/* token match structure */
+struct tokmatch {
+	char *s;
+	enum tok_type type;
+	enum tok_subtype subtype;
+};
+
+static int
+idstart(int c)
+{
+	return	isalpha(c) || (c == '_') || (c == '$');
+}
+
+static int
+idchar(int c)
+{
+	return idstart(c) || isdigit(c);
+}
+
+/* single character matches */
+static struct tokmatch cmatches[] = {
+	{"(", TOK_LPAREN},
+	{")", TOK_RPAREN},
+	{":", TOK_COLON},
+	{"=", TOK_EQUALS},
+};
+
+/* identifier match strings */
+static struct tokmatch smatches[] = {
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
+/* The string is scanned and the next token is returned */
+static const char *
+tokenize(const char *s, struct tok *tok)
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
+/* convert token type to string */
+static const char *
+token_type2s(enum tok_type type)
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
+/* convert token sub-type to string */
+static const char *
+token_subtype2s(enum tok_subtype subtype)
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
+/*
+ * A syntax error message is found, the input tokens are dumped up to and
+ * including the token that failed as indicated by the current iterator index.
+ */
+static void
+tok_syntax(struct efct_hw *hw, struct tokarray *tokarray)
+{
+	u32 i;
+	struct tok *tok;
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
+/*
+ * Parses tokens of type TOK_NUMBER and TOK_NUMBER_VALUE, returning a numeric
+ * value
+ */
+static u32
+tok_getnumber(struct efct_hw *hw, struct efct_hw_qtop *qtop,
+	      struct tok *tok)
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
+/* The tokens are semantically parsed, to generate QTOP entries */
+static void
+parse_sub_filter(struct efct_hw *hw, struct efct_hw_qtop_entry *qt,
+		 struct tok *tok, struct efct_hw_qtop *qtop)
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
+/* The tokens are semantically parsed, to generate QTOP entries */
+static int
+parse_topology(struct efct_hw *hw, struct tokarray *tokarray,
+	       struct efct_hw_qtop *qtop)
+{
+	struct efct_hw_qtop_entry *qt = qtop->entries + qtop->inuse_count;
+	struct tok *tok;
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
+/*
+ * The queue topology object is allocated, and filled with the results of
+ * parsing the passed in queue topology string
+ */
+struct efct_hw_qtop *
+efct_hw_qtop_parse(struct efct_hw *hw, const char *qtop_string)
+{
+	struct efct_hw_qtop *qtop;
+	struct tokarray tokarray;
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
+void
+efct_hw_qtop_free(struct efct_hw_qtop *qtop)
+{
+	if (qtop) {
+		kfree(qtop->entries);
+		kfree(qtop);
+	}
+}
diff --git a/drivers/scsi/elx/efct/efct_hw_queues.h b/drivers/scsi/elx/efct/efct_hw_queues.h
new file mode 100644
index 000000000000..afa43209f823
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_hw_queues.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFCT_HW_QUEUES_H__
+#define __EFCT_HW_QUEUES_H__
+
+#include "efct_hw.h"
+
+#define EFCT_HW_MQ_DEPTH	128
+
+enum efct_hw_qtop_type {
+	QTOP_EQ = 0,
+	QTOP_CQ,
+	QTOP_WQ,
+	QTOP_RQ,
+	QTOP_MQ,
+	QTOP_LAST,
+};
+
+struct efct_hw_qtop_entry {
+	enum		efct_hw_qtop_type entry;
+	bool		set_default;
+	u32		len;
+	u8		class;
+	u8		ulp;
+	u8		filter_mask;
+};
+
+struct efct_hw_mrq {
+	struct rq_config {
+		struct hw_eq *eq;
+		u32	len;
+		u8	class;
+		u8	ulp;
+		u8	filter_mask;
+	} rq_cfg[16];
+	u32 num_pairs;
+};
+
+#define MAX_TOKENS			256
+#define EFCT_HW_MAX_QTOP_ENTRIES	200
+
+struct efct_hw_qtop {
+	void		*os;
+	struct efct_hw_qtop_entry *entries;
+	u32		alloc_count;
+	u32		inuse_count;
+	u32		entry_counts[QTOP_LAST];
+	u32		rptcount[10];
+	u32		rptcount_idx;
+};
+
+struct efct_hw_qtop *
+efct_hw_qtop_parse(struct efct_hw *hw, const char *qtop_string);
+void efct_hw_qtop_free(struct efct_hw_qtop *qtop);
+const char *efct_hw_qtop_entry_name(enum efct_hw_qtop_type entry);
+u32 efct_hw_qtop_eq_count(struct efct_hw *hw);
+
+enum efct_hw_rtn
+efct_hw_init_queues(struct efct_hw *hw, struct efct_hw_qtop *qtop);
+extern  struct hw_wq
+*efct_hw_queue_next_wq(struct efct_hw *hw, struct efct_hw_io *io);
+
+#endif /* __EFCT_HW_QUEUES_H__ */
-- 
2.13.7

