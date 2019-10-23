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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC14CA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FED420679
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l0CdUQks"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407558AbfJWV41 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:27 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:35545 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405939AbfJWV40 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:26 -0400
Received: by mail-wr1-f44.google.com with SMTP id l10so23287417wrb.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ONOZeH4UKytD7npsS5KF4cYg/H9xWHJheuiiApDR5iw=;
        b=l0CdUQks74vE6aAMH9QgF9GgPtl4pl9Vnz06NkOs/upeDyIgwbZvSoK4vGzcxi2y13
         KE8zhVD2ksqr9/G6Sr0ceqSXsC5pixquPoIZxvn9GWXn2A6ugTKGst98CjIp4Owp97mB
         PS1SL34RZnftU4HMjh8qxl+G9Fqhl3htk1ndhpiw+RcSd/o4/3L4siKrH+b/hxrh1gkf
         9YEsEw0JpSArB72UMiYkiZbBkXIkqYt3xWHyL6TNe4mKCKM1T2eyL315i/mco8nFQgmO
         GbrzvuzIxWcX/J/f7DwAVSd+k5BbFC+cXBhLCoqs2ZVBDzhHnpKHh9saLYrGZlZU8pAp
         IdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ONOZeH4UKytD7npsS5KF4cYg/H9xWHJheuiiApDR5iw=;
        b=HJgvT6yT8T6ERoUcu9TqFJFzLcL2RpHQNYXOQAR2Shkr1O6VqPvfeoXimIE/NvMzZL
         LD/eOTO3XZ6nZ6CAyAvbLk3LN966RSzJFmcfJ+6c7Xug7nCZIkD+FF10HPIfW+HF20Jb
         eYugDi+tcU+wzj8acvbAwuKLkVOeDmkpPduO5LfRFiDdMRPoIzgMV1bdHK25nRwCWpUG
         erNKQFGA2mpS6/qJmUmJC34tjdx9eS7yudOZTmKtqCDeSxRxKRhBn6ZIiDVq9zZWmVel
         1MT+RX+kYKOwk+3Hmbat2Ks/VSVXtYfjfAAQnapVz86e/f9ngWFW8LCWmZLzDsxhPgqb
         FmaA==
X-Gm-Message-State: APjAAAWQczOTIvwvh+VIwSandCsH5NVoPu3xnuQiJzPq+E5CFauCbsEd
        U/gBJaWvo5aKCkzYKrsaXa6VLDuZ
X-Google-Smtp-Source: APXvYqwUFtumq9BZnqasixmeO1TQ8I4+uShG/IaCKChJ1qQaHqQcX54XIVmLIKs2VDhaOuMJIMr0Fg==
X-Received: by 2002:adf:b1d1:: with SMTP id r17mr735140wra.201.1571867781995;
        Wed, 23 Oct 2019 14:56:21 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:21 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 09/32] elx: libefc: Emulex FC discovery library APIs and definitions
Date:   Wed, 23 Oct 2019 14:55:34 -0700
Message-Id: <20191023215557.12581-10-jsmart2021@gmail.com>
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

This patch continues the libefc library population.

This patch adds library interface definitions for:
- SLI/Local FC port objects
- efc_domain_s: FC domain (aka fabric) objects
- efc_node_s: FC node (aka remote ports) objects
- A sparse vector interface that manages lookup tables
  for the objects.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/libefc/efc.h     | 188 +++++++++
 drivers/scsi/elx/libefc/efc_lib.c | 263 +++++++++++++
 drivers/scsi/elx/libefc/efclib.h  | 796 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 1247 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc.h
 create mode 100644 drivers/scsi/elx/libefc/efc_lib.c
 create mode 100644 drivers/scsi/elx/libefc/efclib.h

diff --git a/drivers/scsi/elx/libefc/efc.h b/drivers/scsi/elx/libefc/efc.h
new file mode 100644
index 000000000000..f24ddeef99b8
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc.h
@@ -0,0 +1,188 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * EFC linux driver common include file
+ */
+
+#if !defined(__EFC_H__)
+#define __EFC_H__
+
+/***************************************************************************
+ * OS specific includes
+ */
+#include <stdarg.h>
+#include <linux/version.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/interrupt.h>
+#include <asm-generic/ioctl.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/bitmap.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <asm/byteorder.h>
+#include <linux/timer.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/sched.h>
+#include <asm/current.h>
+#include <asm/cacheflush.h>
+#include <linux/pagemap.h>
+#include <linux/kthread.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/jiffies.h>
+#include <linux/ctype.h>
+#include <linux/debugfs.h>
+#include <linux/firmware.h>
+
+#include "../include/efc_common.h"
+#include "efclib.h"
+
+/* Linux driver specific definitions */
+
+#define EFC_MIN_DMA_ALIGNMENT		16
+/* maximum DMA allocation that is expected to reliably succeed  */
+#define EFC_MAX_DMA_ALLOC		(64 * 1024)
+
+#define EFC_MAX_LUN			256
+#define EFC_NUM_UNSOLICITED_FRAMES	1024
+
+#define EFC_MAX_NUMA_NODES		8
+
+/* Per driver instance (efc_t) definitions */
+#define EFC_MAX_DOMAINS		1
+#define EFC_MAX_REMOTE_NODES		2048
+
+/**
+ * @brief Sparse vector structure.
+ */
+struct sparse_vector_s {
+	void *os;
+	u32 max_idx;		/**< maximum index value */
+	void **array;			/**< pointer to 3D array */
+};
+
+/**
+ * @brief Sparse Vector API
+ *
+ * This is a trimmed down sparse vector implementation tuned to the problem of
+ * 24-bit FC_IDs. In this case, the 24-bit index value is broken down in three
+ * 8-bit values. These values are used to index up to three 256 element arrays.
+ * Arrays are allocated, only when needed. @n @n
+ * The lookup can complete in constant time (3 indexed array references). @n @n
+ * A typical use case would be that the fabric/directory FC_IDs would cause two
+ * rows to be allocated, and the fabric assigned remote nodes would cause two
+ * rows to be allocated, with the root row always allocated. This gives five
+ * rows of 256 x sizeof(void*), resulting in 10k.
+ */
+/*!
+ * @defgroup spv Sparse Vector
+ */
+
+#define SPV_ROWLEN	256
+#define SPV_DIM		3
+
+void efc_spv_del(struct sparse_vector_s *spv);
+struct sparse_vector_s *efc_spv_new(void *os);
+void efc_spv_set(struct sparse_vector_s *sv, u32 idx, void *value);
+void *efc_spv_get(struct sparse_vector_s *sv, u32 idx);
+
+#define efc_assert(cond, ...)	\
+	do {			\
+		if (!(cond)) {	\
+			pr_err("%s(%d) assertion (%s) failed\n",\
+				__FILE__, __LINE__, #cond);\
+			dump_stack();\
+		} \
+	} while (0)
+
+int efc_dma_copy_in(struct efc_dma_s *dma, void *buffer,
+		    u32 buffer_length);
+
+#include "efc_sm.h"
+
+struct efc_drv_s {
+	bool attached;
+};
+
+#define efc_is_fc_initiator_enabled()	(efc->enable_ini)
+#define efc_is_fc_target_enabled()	(efc->enable_tgt)
+
+#define domain_sm_trace(domain)						\
+	efc_log_debug(domain->efc, "[domain:%s] %-20s %-20s\n",\
+		      domain->display_name, __func__, efc_sm_event_name(evt))\
+
+#define domain_trace(domain, fmt, ...) \
+	efc_log_debug(domain->efc,\
+		      "[%s]" fmt, domain->display_name, ##__VA_ARGS__)\
+
+#define node_sm_trace()				\
+	efc_log_debug(node->efc,\
+		"[%s] %-20s\n", node->display_name, efc_sm_event_name(evt))\
+
+#define sport_sm_trace(sport)\
+	efc_log_debug(sport->efc,\
+		"[%s] %-20s\n", sport->display_name, efc_sm_event_name(evt))\
+
+enum efc_hw_rtn_e {
+	EFC_HW_RTN_SUCCESS = 0,
+	EFC_HW_RTN_SUCCESS_SYNC = 1,
+	EFC_HW_RTN_ERROR = -1,
+	EFC_HW_RTN_NO_RESOURCES = -2,
+	EFC_HW_RTN_NO_MEMORY = -3,
+	EFC_HW_RTN_IO_NOT_ACTIVE = -4,
+	EFC_HW_RTN_IO_ABORT_IN_PROGRESS = -5,
+	EFC_HW_RTN_IO_PORT_OWNED_ALREADY_ABORTED = -6,
+	EFC_HW_RTN_INVALID_ARG = -7,
+};
+
+#define EFC_HW_RTN_IS_ERROR(e) ((e) < 0)
+
+enum efc_scsi_del_initiator_reason_e {
+	EFC_SCSI_INITIATOR_DELETED,
+	EFC_SCSI_INITIATOR_MISSING,
+};
+
+enum efc_scsi_del_target_reason_e {
+	EFC_SCSI_TARGET_DELETED,
+	EFC_SCSI_TARGET_MISSING,
+};
+
+#define EFC_SCSI_CALL_COMPLETE	0 /* All work is done */
+#define EFC_SCSI_CALL_ASYNC	1 /* Work will be completed asynchronously */
+
+#include "efc_domain.h"
+#include "efc_sport.h"
+#include "efc_node.h"
+
+/* Timeouts */
+#ifndef EFC_FC_ELS_SEND_DEFAULT_TIMEOUT
+#define EFC_FC_ELS_SEND_DEFAULT_TIMEOUT		0
+#endif
+
+#ifndef EFC_FC_ELS_DEFAULT_RETRIES
+#define EFC_FC_ELS_DEFAULT_RETRIES		3
+#endif
+
+#ifndef EFC_FC_FLOGI_TIMEOUT_SEC
+#define EFC_FC_FLOGI_TIMEOUT_SEC		5 /* shorter than default */
+#endif
+
+#ifndef EFC_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC
+#define EFC_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC	30000000 /* 30 seconds */
+#endif
+
+#endif /* __EFC_H__ */
diff --git a/drivers/scsi/elx/libefc/efc_lib.c b/drivers/scsi/elx/libefc/efc_lib.c
new file mode 100644
index 000000000000..c2696193b6da
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_lib.c
@@ -0,0 +1,263 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "efc.h"
+
+int efcport_init(struct efc_lport *efc)
+{
+	u32 rc = 0;
+
+	spin_lock_init(&efc->lock);
+	INIT_LIST_HEAD(&efc->vport_list);
+
+	/* Create Node pool */
+	rc = efc_node_create_pool(efc, EFC_MAX_REMOTE_NODES);
+	if (rc)
+		efc_log_err(efc, "Can't allocate node pool\n");
+
+	return rc;
+}
+
+void efcport_destroy(struct efc_lport *efc)
+{
+	efc_node_free_pool(efc);
+}
+
+/**
+ * @brief Sparse Vector API.
+ *
+ * This is a trimmed down sparse vector implementation tuned to the problem of
+ * 24-bit FC_IDs. In this case, the 24-bit index value is broken down in three
+ * 8-bit values. These values are used to index up to three 256 element arrays.
+ * Arrays are allocated, only when needed. @n @n
+ * The lookup can complete in constant time (3 indexed array references). @n @n
+ * A typical use case would be that the fabric/directory FC_IDs would cause two
+ * rows to be allocated, and the fabric assigned remote nodes would cause two
+ * rows to be allocated, with the root row always allocated. This gives five
+ * rows of 256 x sizeof(void*), resulting in 10k.
+ */
+
+/**
+ * @ingroup spv
+ * @brief Allocate a new sparse vector row.
+ *
+ * @param os OS handle
+ * @param rowcount Count of rows.
+ *
+ * @par Description
+ * A new sparse vector row is allocated.
+ *
+ * @param rowcount Number of elements in a row.
+ *
+ * @return Returns the pointer to a row.
+ */
+static void
+**efc_spv_new_row(u32 rowcount)
+{
+	return kzalloc(sizeof(void *) * rowcount, GFP_ATOMIC);
+}
+
+/**
+ * @ingroup spv
+ * @brief Delete row recursively.
+ *
+ * @par Description
+ * This function recursively deletes the rows in this sparse vector
+ *
+ * @param os OS handle
+ * @param a Pointer to the row.
+ * @param n Number of elements in the row.
+ * @param depth Depth of deleting.
+ *
+ * @return None.
+ */
+static void
+_efc_spv_del(void *os, void **a, u32 n, u32 depth)
+{
+	if (a) {
+		if (depth) {
+			u32 i;
+
+			for (i = 0; i < n; i++)
+				_efc_spv_del(os, a[i], n, depth - 1);
+
+			kfree(a);
+		}
+	}
+}
+
+/**
+ * @ingroup spv
+ * @brief Delete a sparse vector.
+ *
+ * @par Description
+ * The sparse vector is freed.
+ *
+ * @param spv Pointer to the sparse vector object.
+ */
+void
+efc_spv_del(struct sparse_vector_s *spv)
+{
+	if (spv) {
+		_efc_spv_del(spv->os, spv->array, SPV_ROWLEN, SPV_DIM);
+		kfree(spv);
+	}
+}
+
+/**
+ * @ingroup spv
+ * @brief Instantiate a new sparse vector object.
+ *
+ * @par Description
+ * A new sparse vector is allocated.
+ *
+ * @param os OS handle
+ *
+ * @return Returns the pointer to the sparse vector, or NULL.
+ */
+struct sparse_vector_s
+*efc_spv_new(void *os)
+{
+	struct sparse_vector_s *spv;
+	u32 i;
+
+	spv = kzalloc(sizeof(*spv), GFP_ATOMIC);
+	if (!spv)
+		return NULL;
+
+	spv->os = os;
+	spv->max_idx = 1;
+	for (i = 0; i < SPV_DIM; i++)
+		spv->max_idx *= SPV_ROWLEN;
+
+	return spv;
+}
+
+/**
+ * @ingroup spv
+ * @brief Return the address of a cell.
+ *
+ * @par Description
+ * Returns the address of a cell, allocates sparse rows as needed if the
+ *         alloc_new_rows parameter is set.
+ *
+ * @param sv Pointer to the sparse vector.
+ * @param idx Index of which to return the address.
+ * @param alloc_new_rows If TRUE, then new rows may be allocated to set values,
+ *                       Set to FALSE for retrieving values.
+ *
+ * @return Returns the pointer to the cell, or NULL.
+ */
+static void
+*efc_spv_new_cell(struct sparse_vector_s *sv, u32 idx,
+		   bool alloc_new_rows)
+{
+	u32 a = (idx >> 16) & 0xff;
+	u32 b = (idx >>  8) & 0xff;
+	u32 c = (idx >>  0) & 0xff;
+	void **p;
+
+	if (idx >= sv->max_idx)
+		return NULL;
+
+	if (!sv->array) {
+		sv->array = (alloc_new_rows ?
+			     efc_spv_new_row(SPV_ROWLEN) : NULL);
+		if (!sv->array)
+			return NULL;
+	}
+	p = sv->array;
+	if (!p[a]) {
+		p[a] = (alloc_new_rows ? efc_spv_new_row(SPV_ROWLEN) : NULL);
+		if (!p[a])
+			return NULL;
+	}
+	p = p[a];
+	if (!p[b]) {
+		p[b] = (alloc_new_rows ? efc_spv_new_row(SPV_ROWLEN) : NULL);
+		if (!p[b])
+			return NULL;
+	}
+	p = p[b];
+
+	return &p[c];
+}
+
+/**
+ * @ingroup spv
+ * @brief Set the sparse vector cell value.
+ *
+ * @par Description
+ * Sets the sparse vector at @c idx to @c value.
+ *
+ * @param sv Pointer to the sparse vector.
+ * @param idx Index of which to store.
+ * @param value Value to store.
+ *
+ * @return None.
+ */
+void
+efc_spv_set(struct sparse_vector_s *sv, u32 idx, void *value)
+{
+	void **ref = efc_spv_new_cell(sv, idx, true);
+
+	if (ref)
+		*ref = value;
+}
+
+/**
+ * @ingroup spv
+ * @brief Return the sparse vector cell value.
+ *
+ * @par Description
+ * Returns the value at @c idx.
+ *
+ * @param sv Pointer to the sparse vector.
+ * @param idx Index of which to return the value.
+ *
+ * @return Returns the cell value, or NULL.
+ */
+void
+*efc_spv_get(struct sparse_vector_s *sv, u32 idx)
+{
+	void **ref = efc_spv_new_cell(sv, idx, false);
+
+	if (ref)
+		return *ref;
+
+	return NULL;
+}
+
+/*
+ * @brief copy into dma buffer
+ *
+ * Copies into a dma buffer, updates the len element
+ *
+ * @param dma DMA descriptor
+ * @param buffer address of buffer to copy from
+ * @param buffer_length buffer length in bytes
+ *
+ * @return returns bytes copied for success,
+ * a negative error code value for failure.
+ */
+
+int
+efc_dma_copy_in(struct efc_dma_s *dma, void *buffer, u32 buffer_length)
+{
+	if (!dma)
+		return -1;
+	if (!buffer)
+		return -1;
+	if (buffer_length == 0)
+		return 0;
+	if (buffer_length > dma->size)
+		buffer_length = dma->size;
+	memcpy(dma->virt, buffer, buffer_length);
+	dma->len = buffer_length;
+	return buffer_length;
+}
diff --git a/drivers/scsi/elx/libefc/efclib.h b/drivers/scsi/elx/libefc/efclib.h
new file mode 100644
index 000000000000..bbb80bbd2ab1
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efclib.h
@@ -0,0 +1,796 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCLIB_H__)
+#define __EFCLIB_H__
+
+#include "scsi/fc/fc_els.h"
+#include "scsi/fc/fc_fs.h"
+#include "scsi/fc/fc_ns.h"
+#include "scsi/fc/fc_gs.h"
+#include "scsi/fc_frame.h"
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_fc.h>
+#include <linux/completion.h>
+#include "../include/efc_common.h"
+
+#define EFC_SERVICE_PARMS_LENGTH	0x74
+#define EFC_DISPLAY_NAME_LENGTH		32
+#define EFC_DISPLAY_BUS_INFO_LENGTH	16
+
+#define EFC_WWN_LENGTH			32
+
+/**
+ * Local port topology.
+ */
+
+enum efc_sport_topology_e {
+	EFC_SPORT_TOPOLOGY_UNKNOWN = 0,
+	EFC_SPORT_TOPOLOGY_FABRIC,
+	EFC_SPORT_TOPOLOGY_P2P,
+	EFC_SPORT_TOPOLOGY_LOOP,
+};
+
+/**
+ * Common (transport agnostic) shared declarations
+ */
+
+#define enable_target_rscn(efc)	1
+
+enum efc_node_shutd_rsn_e {
+	EFC_NODE_SHUTDOWN_DEFAULT = 0,
+	EFC_NODE_SHUTDOWN_EXPLICIT_LOGO,
+	EFC_NODE_SHUTDOWN_IMPLICIT_LOGO,
+};
+
+enum efc_node_send_ls_acc_e {
+	EFC_NODE_SEND_LS_ACC_NONE = 0,
+	EFC_NODE_SEND_LS_ACC_PLOGI,
+	EFC_NODE_SEND_LS_ACC_PRLI,
+};
+
+#define EFC_LINK_STATUS_UP   0
+#define EFC_LINK_STATUS_DOWN 1
+
+/* State machine context header  */
+struct efc_sm_ctx_s {
+	void *(*current_state)(struct efc_sm_ctx_s *ctx,
+			       u32 evt, void *arg);
+
+	const char *description;
+	void	*app;			/** Application-specific handle. */
+};
+
+/**
+ * @brief Description of discovered Fabric Domain
+ * struct efc_domain_record_s - libefc discovered Fabric Domain
+ * @index:	FCF table index (used in REG_FCFI)
+ * @priority:	FCF reported priority
+ * @address:	Switch WWN
+ * @vlan:	bitmap of valid VLAN IDs
+ * @loop:	FC-AL position map
+ * @speed:	link speed
+ * @fc_id:	our ports fc_id
+ */
+struct efc_domain_record_s {
+	u32	index;
+	u32	priority;
+	u8		address[6];
+	u8		wwn[8];
+	union {
+		u8	vlan[512];
+		u8	loop[128];
+	} map;
+	u32	speed;
+	u32	fc_id;
+	bool		is_loop;
+	bool		is_nport;
+};
+
+/*
+ * @brief Fabric/Domain events
+ */
+enum efc_hw_domain_event_e {
+	EFC_HW_DOMAIN_ALLOC_OK,		/**< domain successfully allocated */
+	EFC_HW_DOMAIN_ALLOC_FAIL,	/**< domain allocation failed */
+	EFC_HW_DOMAIN_ATTACH_OK,	/**< successfully attached to domain */
+	EFC_HW_DOMAIN_ATTACH_FAIL,	/**< domain attach failed */
+	EFC_HW_DOMAIN_FREE_OK,		/**< successfully freed domain */
+	EFC_HW_DOMAIN_FREE_FAIL,	/**< domain free failed */
+	EFC_HW_DOMAIN_LOST,
+	/**< prev discovered domain no longer available */
+	EFC_HW_DOMAIN_FOUND,		/**< new domain discovered */
+	/**< prev discovered domain props have changed */
+	EFC_HW_DOMAIN_CHANGED,
+};
+
+enum efc_hw_port_event_e {
+	EFC_HW_PORT_ALLOC_OK,		/**< port successfully allocated */
+	EFC_HW_PORT_ALLOC_FAIL,		/**< port allocation failed */
+	EFC_HW_PORT_ATTACH_OK,		/**< successfully attached to port */
+	EFC_HW_PORT_ATTACH_FAIL,	/**< port attach failed */
+	EFC_HW_PORT_FREE_OK,		/**< successfully freed port */
+	EFC_HW_PORT_FREE_FAIL,		/**< port free failed */
+};
+
+enum efc_hw_remote_node_event_e {
+	EFC_HW_NODE_ATTACH_OK,
+	EFC_HW_NODE_ATTACH_FAIL,
+	EFC_HW_NODE_FREE_OK,
+	EFC_HW_NODE_FREE_FAIL,
+	EFC_HW_NODE_FREE_ALL_OK,
+	EFC_HW_NODE_FREE_ALL_FAIL,
+};
+
+enum efc_hw_node_els_event_e {
+	EFC_HW_SRRS_ELS_REQ_OK,
+	EFC_HW_SRRS_ELS_CMPL_OK,
+	EFC_HW_SRRS_ELS_REQ_FAIL,
+	EFC_HW_SRRS_ELS_CMPL_FAIL,
+	EFC_HW_SRRS_ELS_REQ_RJT,
+	EFC_HW_ELS_REQ_ABORTED,
+};
+
+/**
+ * @brief SLI Port object
+ *
+ * The SLI Port object represents the connection between the driver and the
+ * FC/FCoE domain. In some topologies / hardware, it is possible to have
+ * multiple connections to the domain via different WWN. Each would require
+ * a separate SLI port object.
+ *
+ * @efc:		pointer to efc
+ * @tgt_id:		target id
+ * @display_name:	sport display name
+ * @domain:		current fabric domain
+ * @is_vport:		this SPORT is a virtual port
+ * @wwpn:		WWPN from HW (host endian)
+ * @wwnn:		WWNN from HW (host endian)
+ * @node_list:		list of nodes
+ * @ini_sport:		initiator backend private sport data
+ * @tgt_sport:		target backend private sport data
+ * @tgt_data:		target backend private pointer
+ * @ini_data:		initiator backend private pointer
+ * @ctx:		state machine context
+ * @hw:			pointer to HW
+ * @indicator:		VPI
+ * @fc_id:		FC address
+ * @efc_dma_s:		memory for Service Parameter
+ * @wwnn_str:		WWN (ASCII)
+ * @sli_wwpn:		WWPN (wire endian)
+ * @sli_wwnn:		WWNN (wire endian)
+ * @sm_free_req_pending:Free request received while waiting for attach response
+ * @sm:			sport context state machine
+ * @lookup:		fc_id to node lookup object
+ * @enable_ini:		SCSI initiator enabled for this node
+ * @enable_tgt:		SCSI target enabled for this node
+ * @enable_rscn:	This SPORT will be expecting RSCN
+ * @shutting_down:	sport in process of shutting down
+ * @p2p_winner:		TRUE if we're the point-to-point winner
+ * @topology:		topology: fabric/p2p/unknown
+ * @service_params:	Login parameters
+ * @p2p_remote_port_id:	Remote node's port id for p2p
+ * @p2p_port_id:	our port's id
+ */
+struct efc_sli_port_s {
+	struct list_head list_entry;
+	struct efc_lport *efc;
+	u32 tgt_id;
+	u32 index;
+	u32 instance_index;
+	char display_name[EFC_DISPLAY_NAME_LENGTH];
+	struct efc_domain_s *domain;
+	bool is_vport;
+	u64	wwpn;
+	u64	wwnn;
+	struct list_head node_list;
+	void	*ini_sport;
+	void	*tgt_sport;
+	void	*tgt_data;
+	void	*ini_data;
+
+	/*
+	 * Members private to HW/SLI
+	 */
+	void	*hw;
+	u32	indicator;
+	u32	fc_id;
+	struct efc_dma_s	dma;
+
+	u8		wwnn_str[EFC_WWN_LENGTH];
+	__be64		sli_wwpn;
+	__be64		sli_wwnn;
+	bool		free_req_pending;
+	bool		attached;
+
+	/*
+	 * Implementation specific fields allowed here
+	 */
+	struct efc_sm_ctx_s	sm;
+	struct sparse_vector_s *lookup;
+	bool		enable_ini;
+	bool		enable_tgt;
+	bool		enable_rscn;
+	bool		shutting_down;
+	bool		p2p_winner;
+	enum efc_sport_topology_e topology;
+	u8		service_params[EFC_SERVICE_PARMS_LENGTH];
+	u32	p2p_remote_port_id;
+	u32	p2p_port_id;
+};
+
+/**
+ * @brief Fibre Channel domain object
+ *
+ * This object is a container for the various SLI components needed
+ * to connect to the domain of a FC or FCoE switch
+ * @efc:		pointer back to efc
+ * @instance_index:	unique instance index value
+ * @display_name:	Node display name
+ * @sport_list:		linked list of SLI ports
+ * @ini_domain:		initiator backend private domain data
+ * @tgt_domain:		target backend private domain data
+ * @hw:			pointer to HW
+ * @sm:			state machine context
+ * @fcf:		FC Forwarder table index
+ * @fcf_indicator:	FCFI
+ * @vlan_id:		VLAN tag for this domain
+ * @indicator:		VFI
+ * @dma:		memory for Service Parameters
+ * @req_rediscover_fcf:	TRUE if fcf rediscover is needed
+ *			(in response to Vlink Clear async event)
+ * @fcf_wwn:		WWN for FCF/switch
+ * @drvsm:		driver domain sm context
+ * @drvsm_lock:		driver domain sm lock
+ * @attached:		set true after attach completes
+ * @is_fc:		is FC
+ * @is_loop:		is loop topology
+ * @is_nlport:		is public loop
+ * @domain_found_pending:A domain found is pending, drec is updated
+ * @req_domain_free:	True if domain object should be free'd
+ * @req_accept_frames:	set in domain state machine to enable frames
+ * @domain_notify_pend:	Set in domain SM to avoid duplicate node event post
+ * @pending_drec:	Pending drec if a domain found is pending
+ * @service_params:	any sports service parameters
+ * @flogi_service_params:Fabric/P2p service parameters from FLOGI
+ * @lookup:		d_id to node lookup object
+ * @sport:		Pointer to first (physical) SLI port
+ */
+struct efc_domain_s {
+	struct list_head	list_entry;
+	struct efc_lport *efc;
+	u32 instance_index;
+	char display_name[EFC_DISPLAY_NAME_LENGTH];
+	struct list_head sport_list;
+	void *ini_domain;
+	void *tgt_domain;
+
+	/* Declarations private to HW/SLI */
+	void *hw;
+	u32 fcf;
+	u32 fcf_indicator;
+	u32 indicator;
+	struct efc_dma_s dma;
+	bool req_rediscover_fcf;
+
+	/* Declarations private to FC transport */
+	u64 fcf_wwn;
+	struct efc_sm_ctx_s drvsm;
+	bool attached;
+	bool is_fc;
+	bool is_loop;
+	bool is_nlport;
+	bool domain_found_pending;
+	bool req_domain_free;
+	bool req_accept_frames;
+	bool domain_notify_pend;
+
+	struct efc_domain_record_s pending_drec;
+	u8 service_params[EFC_SERVICE_PARMS_LENGTH];
+	u8 flogi_service_params[EFC_SERVICE_PARMS_LENGTH];
+
+	struct sparse_vector_s *lookup;
+
+	struct efc_sli_port_s *sport;
+	u32 sport_instance_count;
+};
+
+/**
+ * @brief Remote Node object
+ *
+ * This object represents a connection between the SLI port and another
+ * Nx_Port on the fabric. Note this can be either a well known port such
+ * as a F_Port (i.e. ff:ff:fe) or another N_Port.
+ * @indicator:		RPI
+ * @fc_id:		FC address
+ * @attached:		true if attached
+ * @node_group:		true if in node group
+ * @free_group:		true if the node group should be free'd
+ * @sport:		associated SLI port
+ * @node:		associated node
+ */
+struct efc_remote_node_s {
+	/*
+	 * Members private to HW/SLI
+	 */
+	u32	indicator;
+	u32	index;
+	u32	fc_id;
+
+	bool attached;
+	bool node_group;
+	bool free_group;
+
+	struct efc_sli_port_s	*sport;
+	void *node;
+};
+
+/**
+ * @brief FC Node object
+ * @efc:		pointer back to efc structure
+ * @instance_index:	unique instance index value
+ * @display_name:	Node display name
+ * @hold_frames:	hold incoming frames if true
+ * @lock:		node wide lock
+ * @active_ios:		active I/O's for this node
+ * @max_wr_xfer_size:	Max write IO size per phase for the transport
+ * @ini_node:		backend initiator private node data
+ * @tgt_node:		backend target private node data
+ * @rnode:		Remote node
+ * @sm:			state machine context
+ * @evtdepth:		current event posting nesting depth
+ * @req_free:		this node is to be free'd
+ * @attached:		node is attached (REGLOGIN complete)
+ * @fcp_enabled:	node is enabled to handle FCP
+ * @rscn_pending:	for name server node RSCN is pending
+ * @send_plogi:		send PLOGI accept, upon completion of node attach
+ * @send_plogi_acc:	TRUE if io_alloc() is enabled.
+ * @send_ls_acc:	type of LS acc to send
+ * @ls_acc_io:		SCSI IO for LS acc
+ * @ls_acc_oxid:	OX_ID for pending accept
+ * @ls_acc_did:		D_ID for pending accept
+ * @shutdown_reason:	reason for node shutdown
+ * @sparm_dma_buf:	service parameters buffer
+ * @service_params:	plogi/acc frame from remote device
+ * @pend_frames_lock:	lock for inbound pending frames list
+ * @pend_frames:	inbound pending frames list
+ * @pend_frames_processed:count of frames processed in hold frames interval
+ * @ox_id_in_use:	used to verify one at a time us of ox_id
+ * @els_retries_remaining:for ELS, number of retries remaining
+ * @els_req_cnt:	number of outstanding ELS requests
+ * @els_cmpl_cnt:	number of outstanding ELS completions
+ * @abort_cnt:		Abort counter for debugging purpos
+ * @current_state_name:	current node state
+ * @prev_state_name:	previous node state
+ * @current_evt:	current event
+ * @prev_evt:		previous event
+ * @targ:		node is target capable
+ * @init:		node is init capable
+ * @refound:		Handle node refound case when node is being deleted
+ * @els_io_pend_list:	list of pending (not yet processed) ELS IOs
+ * @els_io_active_list:	list of active (processed) ELS IOs
+ * @nodedb_state:	Node debugging, saved state
+ * @gidpt_delay_timer:	GIDPT delay timer
+ * @time_last_gidpt_msec:Start time of last target RSCN GIDPT
+ * @wwnn:		remote port WWNN
+ * @wwpn:		remote port WWPN
+ * @chained_io_count:	Statistics : count of IOs with chained SGL's
+ */
+struct efc_node_s {
+	struct list_head list_entry;
+	struct efc_lport *efc;
+	u32 instance_index;
+	char display_name[EFC_DISPLAY_NAME_LENGTH];
+	struct efc_sli_port_s *sport;
+	bool hold_frames;
+	spinlock_t active_ios_lock;
+	struct list_head active_ios;
+	u64 max_wr_xfer_size;
+	void *ini_node;
+	void *tgt_node;
+
+	struct efc_remote_node_s	rnode;
+	/* Declarations private to FC transport */
+	struct efc_sm_ctx_s		sm;
+	u32		evtdepth;
+
+	bool req_free;
+	bool attached;
+	bool fcp_enabled;
+	bool rscn_pending;
+	bool send_plogi;
+	bool send_plogi_acc;
+	bool io_alloc_enabled;
+
+	enum efc_node_send_ls_acc_e	send_ls_acc;
+	void			*ls_acc_io;
+	u32		ls_acc_oxid;
+	u32		ls_acc_did;
+	enum efc_node_shutd_rsn_e	shutdown_reason;
+	struct efc_dma_s		sparm_dma_buf;
+	u8			service_params[EFC_SERVICE_PARMS_LENGTH];
+	spinlock_t		pend_frames_lock;
+	struct list_head	pend_frames;
+	u32		pend_frames_processed;
+	u32		ox_id_in_use;
+	u32		els_retries_remaining;
+	u32		els_req_cnt;
+	u32		els_cmpl_cnt;
+	u32		abort_cnt;
+
+	char current_state_name[EFC_DISPLAY_NAME_LENGTH];
+	char prev_state_name[EFC_DISPLAY_NAME_LENGTH];
+	int		current_evt;
+	int		prev_evt;
+	bool targ;
+	bool init;
+	bool refound;
+	struct list_head	els_io_pend_list;
+	struct list_head	els_io_active_list;
+
+	void *(*nodedb_state)(struct efc_sm_ctx_s *ctx,
+			      u32 evt, void *arg);
+	struct timer_list		gidpt_delay_timer;
+	time_t			time_last_gidpt_msec;
+
+	char wwnn[EFC_WWN_LENGTH];
+	char wwpn[EFC_WWN_LENGTH];
+
+	u32		chained_io_count;
+};
+
+/**
+ * @brief Virtual port specification
+ *
+ * Collection of the information required to restore a virtual port across
+ * link events
+ * @domain_instance:	instance index of this domain for the sport
+ * @wwnn:		node name
+ * @wwpn:		port name
+ * @fc_id:		port id
+ * @tgt_data:		target backend pointer
+ * @ini_data:		initiator backend pointe
+ * @sport:		Used to match record after attaching for update
+ *
+ */
+
+struct efc_vport_spec_s {
+	struct list_head list_entry;
+	u32 domain_instance;
+	u64 wwnn;
+	u64 wwpn;
+	u32 fc_id;
+	bool enable_tgt;
+	bool enable_ini;
+	void	*tgt_data;
+	void	*ini_data;
+	struct efc_sli_port_s *sport;
+};
+
+#define node_printf(node, fmt, args...) \
+	pr_info("[%s] " fmt, node->display_name, ##args)
+
+/**
+ * @brief Node SM IO Context Callback structure
+ *
+ * Structure used as callback argument
+ * @status:	completion status
+ * @ext_status:	extended completion status
+ * @header:	completion header buffer
+ * @payload:	completion payload buffers
+ * @els_rsp:	ELS response buffer
+ */
+
+struct efc_node_cb_s {
+	int status;
+	int ext_status;
+	struct efc_hw_rq_buffer_s *header;
+	struct efc_hw_rq_buffer_s *payload;
+	struct efc_dma_s els_rsp;
+};
+
+/*
+ * @brief HW unsolicited callback status
+ */
+enum efc_hw_unsol_status_e {
+	EFC_HW_UNSOL_SUCCESS,
+	EFC_HW_UNSOL_ERROR,
+	EFC_HW_UNSOL_ABTS_RCVD,
+	EFC_HW_UNSOL_MAX,	/**< must be last */
+};
+
+/*
+ * @brief Defines the type of RQ buffer
+ */
+enum efc_hw_rq_buffer_type_e {
+	EFC_HW_RQ_BUFFER_TYPE_HDR,
+	EFC_HW_RQ_BUFFER_TYPE_PAYLOAD,
+	EFC_HW_RQ_BUFFER_TYPE_MAX,
+};
+
+/*
+ * @brief Defines a wrapper for the RQ payload buffers so that we can place it
+ * back on the proper queue.
+ */
+struct efc_hw_rq_buffer_s {
+	u16 rqindex;
+	struct efc_dma_s dma;
+};
+
+/*
+ * @brief Defines a general FC sequence object,
+ * consisting of a header, payload buffers
+ * and a HW IO in the case of port owned XRI
+ */
+struct efc_hw_sequence_s {
+	struct list_head list_entry;
+	void *hw;	/* HW that owns this sequence */
+	/* sequence information */
+	u8 fcfi;		/* FCFI associated with sequence */
+	u8 auto_xrdy;	/* If auto XFER_RDY was generated */
+	u8 out_of_xris;	/* If IO wld have been
+			 *assisted if XRIs were available
+			 */
+	struct efc_hw_rq_buffer_s *header;
+	struct efc_hw_rq_buffer_s *payload; /* rcvd frame payload buff */
+
+	/* other "state" information from the SRB (sequence coalescing) */
+	enum efc_hw_unsol_status_e status;
+	u32 xri;		/* XRI assoc with seq; seq coalescing only */
+	struct efct_hw_io_s *hio;/* HW IO */
+
+	void *hw_priv;		/* HW private context */
+};
+
+struct libefc_function_template {
+	/*Domain*/
+	int (*hw_domain_alloc)(struct efc_lport *efc,
+			       struct efc_domain_s *domain, u32 fcf);
+
+	int (*hw_domain_attach)(struct efc_lport *efc,
+				struct efc_domain_s *domain, u32 fc_id);
+
+	int (*hw_domain_free)(struct efc_lport *hw, struct efc_domain_s *d);
+
+	int (*hw_domain_force_free)(struct efc_lport *efc,
+				    struct efc_domain_s *domain);
+	int (*new_domain)(struct efc_lport *efc, struct efc_domain_s *d);
+	void (*del_domain)(struct efc_lport *efc, struct efc_domain_s *d);
+
+	void (*domain_hold_frames)(struct efc_lport *efc,
+				   struct efc_domain_s *domain);
+	void (*domain_accept_frames)(struct efc_lport *efc,
+				     struct efc_domain_s *domain);
+
+	/*Sport*/
+	int (*hw_port_alloc)(struct efc_lport *hw, struct efc_sli_port_s *sp,
+			     struct efc_domain_s *d, u8 *val);
+
+	int (*hw_port_attach)(struct efc_lport *hw, struct efc_sli_port_s *sp,
+			      u32 fc_id);
+
+	int (*hw_port_free)(struct efc_lport *hw, struct efc_sli_port_s *sp);
+
+	int (*new_sport)(struct efc_lport *efc, struct efc_sli_port_s *sp);
+	void (*del_sport)(struct efc_lport *efc, struct efc_sli_port_s *sp);
+
+	/*Node*/
+	int (*hw_node_alloc)(struct efc_lport *hw, struct efc_remote_node_s *n,
+			     u32 fc_addr, struct efc_sli_port_s *sport);
+
+	int (*hw_node_attach)(struct efc_lport *hw, struct efc_remote_node_s *n,
+			      struct efc_dma_s *sparams);
+
+	int (*hw_node_detach)(struct efc_lport *hw,
+			      struct efc_remote_node_s *r);
+
+	int (*hw_node_free_resources)(struct efc_lport *efc,
+				      struct efc_remote_node_s *node);
+	int (*node_purge_pending)(struct efc_lport *efc, struct efc_node_s *n);
+
+	void (*node_io_cleanup)(struct efc_lport *efc, struct efc_node_s *node,
+				bool force);
+	void (*node_els_cleanup)(struct efc_lport *efc, struct efc_node_s *node,
+				 bool force);
+	void (*node_abort_all_els)(struct efc_lport *efc, struct efc_node_s *n);
+
+	/*Scsi*/
+
+	void (*scsi_io_alloc_disable)(struct efc_lport *efc,
+				      struct efc_node_s *node);
+	void (*scsi_io_alloc_enable)(struct efc_lport *efc,
+				     struct efc_node_s *node);
+
+	int (*scsi_validate_node)(struct efc_lport *efc, struct efc_node_s *n);
+	int (*scsi_new_node)(struct efc_lport *efc, struct efc_node_s *n);
+
+	int (*scsi_del_node)(struct efc_lport *efc,
+			     struct efc_node_s *node, int reason);
+
+	/*Send ELS*/
+
+	void *(*els_send)(struct efc_lport *efc, struct efc_node_s *node,
+			  u32 cmd, u32 timeout_sec, u32 retries);
+
+	void *(*els_send_ct)(struct efc_lport *efc, struct efc_node_s *node,
+			     u32 cmd, u32 timeout_sec, u32 retries);
+
+	void *(*els_send_resp)(struct efc_lport *efc, struct efc_node_s *node,
+			       u32 cmd, u16 ox_id);
+
+	void *(*bls_send_acc_hdr)(struct efc_lport *efc, struct efc_node_s *n,
+				  struct fc_frame_header *hdr);
+	void *(*send_flogi_p2p_acc)(struct efc_lport *efc, struct efc_node_s *n,
+				    u32 ox_id, u32 s_id);
+
+	int (*send_ct_rsp)(struct efc_lport *efc, struct efc_node_s *node,
+			   __be16 ox_id, struct fc_ct_hdr *hdr,
+			   u32 rsp_code, u32 reason_code, u32 rsn_code_expl);
+
+	void *(*send_ls_rjt)(struct efc_lport *efc, struct efc_node_s *node,
+			     u32 ox, u32 rcode, u32 rcode_expl, u32 vendor);
+
+	int (*dispatch_fcp_cmd)(struct efc_node_s *node,
+				struct efc_hw_sequence_s *seq);
+
+	int (*recv_abts_frame)(struct efc_lport *efc, struct efc_node_s *node,
+			       struct efc_hw_sequence_s *seq);
+};
+
+#define EFC_LOG_LIB		0x01 /* General logging, not categorized */
+#define EFC_LOG_NODE		0x02 /* lport layer logging */
+#define EFC_LOG_PORT		0x04 /* lport layer logging */
+#define EFC_LOG_DOMAIN		0x08 /* lport layer logging */
+#define EFC_LOG_ELS		0x10 /* lport layer logging */
+#define EFC_LOG_DOMAIN_SM	0x20 /* lport layer logging */
+#define EFC_LOG_SM		0x40 /* lport layer logging */
+
+/**
+ * @brief efc library port structure
+ * @base:	ponter to host structure
+ * @req_wwpn:	wwpn requested by user for primary sport
+ * @req_wwnn:	wwnn requested by user for primary sport
+ * @nodes_count:number of allocated nodes
+ * @nodes:	array of pointers to nodes
+ * @nodes_free_list: linked list of free nodes
+ * @vport_list:	list of VPORTS (NPIV)
+ * @configured_link_state:requested link state
+ * @lock:	Device wide lock
+ * @domain_list:linked list of virtual fabric objects
+ * @domain:	pointer to first (physical) domain (also on domain_list)
+ * @domain_instance_count:domain instance count
+ * @domain_list_empty_cb:domain list empty callback
+ *
+ */
+struct efc_lport {
+	void *base;
+	struct pci_dev  *pcidev;
+	u64 req_wwpn;
+	u64 req_wwnn;
+
+	u64 def_wwpn;
+	u64 def_wwnn;
+	u64 max_xfer_size;
+	u32 nodes_count;
+	struct efc_node_s **nodes;
+	struct list_head nodes_free_list;
+
+	u32 link_status;
+
+	/* vport */
+	struct list_head vport_list;
+
+	struct libefc_function_template tt;
+	spinlock_t lock;
+
+	bool enable_ini;
+	bool enable_tgt;
+
+	u32 log_level;
+
+	struct efc_domain_s *domain;
+	void (*domain_free_cb)(struct efc_lport *efc, void *arg);
+	void *domain_free_cb_arg;
+
+	/*
+	 * tgt_rscn_delay - delay in kicking off RSCN processing
+	 * (nameserver queries) after receiving an RSCN on the
+	 * target. This prevents thrashing of nameserver
+	 * requests due to a huge burst of RSCNs received in a
+	 * short period of time
+	 * Note: this is only valid when target RSCN handling
+	 * is enabled -- see ctrlmask.
+	 */
+	time_t tgt_rscn_delay_msec;
+
+	/*
+	 * tgt_rscn_period - determines maximum frequency when
+	 * processing back-to-back
+	 * RSCNs; e.g. if this value is 30, there will never be any
+	 * more than 1 RSCN handling per 30s window. This prevents
+	 * initiators on a faulty link generating
+	 * many RSCN from causing the target to continually query the
+	 * nameserver.
+	 * Note:this is only valid when target RSCN handling is enabled
+	 */
+	time_t tgt_rscn_period_msec;
+
+	bool external_loopback;
+	u32 nodedb_mask;
+};
+
+/*
+ * EFC library registration
+ * **********************************/
+int efcport_init(struct efc_lport *efc);
+void efcport_destroy(struct efc_lport *efc);
+/*
+ * EFC Domain
+ * **********************************/
+int efc_domain_cb(void *arg, int event, void *data);
+void efc_domain_force_free(struct efc_domain_s *domain);
+void
+efc_register_domain_free_cb(struct efc_lport *efc,
+			    void (*callback)(struct efc_lport *efc, void *arg),
+			    void *arg);
+
+/*
+ * EFC Local port
+ * **********************************/
+int efc_lport_cb(void *arg, int event, void *data);
+int8_t efc_vport_create_spec(struct efc_lport *efc, u64 wwnn,
+			     u64 wwpn, u32 fc_id, bool enable_ini,
+			     bool enable_tgt, void *tgt_data, void *ini_data);
+int efc_sport_vport_new(struct efc_domain_s *domain, u64 wwpn,
+			u64 wwnn, u32 fc_id, bool ini, bool tgt,
+			void *tgt_data, void *ini_data, bool restore_vport);
+int efc_sport_vport_del(struct efc_lport *efc, struct efc_domain_s *domain,
+			u64 wwpn, u64 wwnn);
+
+void efc_vport_del_all(struct efc_lport *efc);
+
+struct efc_sli_port_s *efc_sport_find(struct efc_domain_s *domain, u32 d_id);
+
+/*
+ * EFC Node
+ * **********************************/
+int efc_remote_node_cb(void *arg, int event, void *data);
+u64 efc_node_get_wwnn(struct efc_node_s *node);
+u64 efc_node_get_wwpn(struct efc_node_s *node);
+struct efc_node_s *efc_node_find(struct efc_sli_port_s *sport, u32 id);
+void efc_node_fcid_display(u32 fc_id, char *buffer, u32 buf_len);
+
+void efc_node_post_els_resp(struct efc_node_s *node, u32 evt, void *arg);
+void efc_node_post_shutdown(struct efc_node_s *node, u32 evt, void *arg);
+/*
+ * EFC FCP/ELS/CT interface
+ * **********************************/
+int efc_node_recv_abts_frame(struct efc_lport *efc,
+			     struct efc_node_s *node,
+			     struct efc_hw_sequence_s *seq);
+int
+efc_node_recv_els_frame(struct efc_node_s *node, struct efc_hw_sequence_s *s);
+int efc_domain_dispatch_frame(void *arg, struct efc_hw_sequence_s *seq);
+
+int efc_node_dispatch_frame(void *arg, struct efc_hw_sequence_s *seq);
+
+int
+efc_node_recv_ct_frame(struct efc_node_s *node, struct efc_hw_sequence_s *seq);
+int
+efc_node_recv_fcp_cmd(struct efc_node_s *node, struct efc_hw_sequence_s *seq);
+int
+efc_node_recv_bls_no_sit(struct efc_node_s *node, struct efc_hw_sequence_s *s);
+
+/*
+ * EFC SCSI INTERACTION LAYER
+ * **********************************/
+void
+efc_scsi_del_initiator_complete(struct efc_lport *efc, struct efc_node_s *node);
+void
+efc_scsi_del_target_complete(struct efc_lport *efc, struct efc_node_s *node);
+void efc_scsi_io_list_empty(struct efc_lport *efc, struct efc_node_s *node);
+
+#endif /* __EFCLIB_H__ */
-- 
2.13.7

