Return-Path: <SRS0=8h8k=DT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94483C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F3BF2073A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Oct 2020 22:52:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FtUkblK4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390666AbgJLWwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Oct 2020 18:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390548AbgJLWwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2020 18:52:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D0DC0613D1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:18 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b193so14997766pga.6
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2020 15:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=TEwZqRbGBnVYlfhkXsNwitAygus3c9lmyPCEa4UYlUU=;
        b=FtUkblK4UY/Ld0XEKvzPkcu7XpkReDLBgvWyXHmWvpdoCLJaDQEEm+OszxoMhvmAZ2
         x3CTIlba54eqCAufr3+Jsrcvi8nkEpmlKcXvfubzTuDrQsK8deS4u8O6upRhfj8V9zCO
         R8R2DZyN1mJ0qb5UVkSo99Soq7IaX8paROMRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=TEwZqRbGBnVYlfhkXsNwitAygus3c9lmyPCEa4UYlUU=;
        b=VC/3ikKY+N8+NJ2yDtkXJkFH7PjOPb09uBbAj/SURe4zJcnV0WNwyMZcMoSGtgyxx9
         Tqg1u5ubA7c0mFBRoDDYwCt5LCujWAt0aKehLfYS78b8FLoB/k+GvN9fuPhlNBvSGfHB
         28qHwL7Rpt9VMJ8FppiBThFsy2NySpAF62YgwHxJcQPr6FqGZLsV569O/JLi95c88i3W
         KA2kyLPZovfmkbrTGVk6Tld4V/+Sbf0mmaJS8ndAqxSeIMUj9sf5BQs+eJ/ZSZRmvf2N
         Ny0dk/DWyeyI8kOfO7j9b6bxU+NMuBrrpW/sadX/tkWI+Oe57djPwENR8RD/lyv4BfmT
         TK/g==
X-Gm-Message-State: AOAM5316EJYYU8TeB8BpESFYPBLHvNa16nn5MkE21DSFGLxPK62/71Dc
        Xio/O1lC6kioMREa9F/lBZo7ikUQddB3rG1uW55WNY1dBQKnRerWJT3qZcsCeM69kNP2jCBGAMY
        YiJhalSJFQiuFzwxzpWECWTfTI3SVKTD9/D58AOJ5pwmpC5vE3d+7F6D8crSXwDjU6SgMMkUILj
        OMfWg=
X-Google-Smtp-Source: ABdhPJz304pvQsqPDe0eJaTNQRPmeh+s95XxouZZC1nNdAcbYw0CmKzoqo8jaJdo/ntOMQiuE/Vr3g==
X-Received: by 2002:a63:4516:: with SMTP id s22mr11973276pga.369.1602543137182;
        Mon, 12 Oct 2020 15:52:17 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x5sm21222287pfr.83.2020.10.12.15.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 15:52:16 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH v4 15/31] elx: libefc: Extended link Service IO handling
Date:   Mon, 12 Oct 2020 15:51:31 -0700
Message-Id: <20201012225147.54404-16-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012225147.54404-1-james.smart@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007970ca05b18126c3"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000007970ca05b18126c3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch continues the libefc library population.

This patch adds library interface definitions for:
Functions to build and send ELS/CT/BLS commands and responses.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v4:
  New patch added ELS handling to libefc library.
  New els_io_req for discovery io object.
---
 drivers/scsi/elx/libefc/efc_els.c | 1152 +++++++++++++++++++++++++++++
 drivers/scsi/elx/libefc/efc_els.h |  107 +++
 2 files changed, 1259 insertions(+)
 create mode 100644 drivers/scsi/elx/libefc/efc_els.c
 create mode 100644 drivers/scsi/elx/libefc/efc_els.h

diff --git a/drivers/scsi/elx/libefc/efc_els.c b/drivers/scsi/elx/libefc/efc_els.c
new file mode 100644
index 000000000000..a3914b5e7ac5
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_els.c
@@ -0,0 +1,1152 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+/*
+ * Functions to build and send ELS/CT/BLS commands and responses.
+ */
+
+#include "efc.h"
+#include "efc_els.h"
+#include "../libefc_sli/sli4.h"
+
+#define EFC_LOG_ENABLE_ELS_TRACE(efc)		\
+		(((efc) != NULL) ? (((efc)->logmask & (1U << 1)) != 0) : 0)
+
+#define node_els_trace()  \
+	do { \
+		if (EFC_LOG_ENABLE_ELS_TRACE(efc)) \
+			efc_log_info(efc, "[%s] %-20s\n", \
+				node->display_name, __func__); \
+	} while (0)
+
+#define els_io_printf(els, fmt, ...) \
+	efc_log_err((struct efc *)els->node->efc,\
+		      "[%s] %-8s " fmt, \
+		      els->node->display_name,\
+		      els->display_name, ##__VA_ARGS__)
+
+#define EFC_ELS_RSP_LEN			1024
+#define EFC_ELS_GID_PT_RSP_LEN		8096
+
+void
+efc_io_alloc_enable(struct efc_node *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->els_ios_lock, flags);
+	node->els_io_enabled = true;
+	spin_unlock_irqrestore(&node->els_ios_lock, flags);
+}
+
+void
+efc_io_alloc_disable(struct efc_node *node)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&node->els_ios_lock, flags);
+	node->els_io_enabled = false;
+	spin_unlock_irqrestore(&node->els_ios_lock, flags);
+}
+
+struct efc_els_io_req *
+efc_els_io_alloc(struct efc_node *node, u32 reqlen)
+{
+	return efc_els_io_alloc_size(node, reqlen, EFC_ELS_RSP_LEN);
+}
+
+struct efc_els_io_req *
+efc_els_io_alloc_size(struct efc_node *node, u32 reqlen, u32 rsplen)
+{
+	struct efc *efc;
+	struct efc_els_io_req *els;
+	unsigned long flags = 0;
+
+	efc = node->efc;
+
+	spin_lock_irqsave(&node->els_ios_lock, flags);
+
+	if (!node->els_io_enabled) {
+		efc_log_err(efc, "els io alloc disabled\n");
+		spin_unlock_irqrestore(&node->els_ios_lock, flags);
+		return NULL;
+	}
+
+	els = kzalloc(sizeof(struct efc_els_io_req), GFP_ATOMIC);
+	if (!els) {
+		atomic_add_return(1, &efc->els_io_alloc_failed_count);
+		spin_unlock_irqrestore(&node->els_ios_lock, flags);
+		return NULL;
+	}
+
+	/* initialize refcount */
+	kref_init(&els->ref);
+	els->release = _efc_els_io_free;
+
+	/* populate generic io fields */
+	els->node = node;
+
+	/* now allocate DMA for request and response */
+	els->io.req.size = reqlen;
+	els->io.req.virt = dma_alloc_coherent(&efc->pci->dev, els->io.req.size,
+					       &els->io.req.phys, GFP_DMA);
+	if (!els->io.req.virt) {
+		kfree(els);
+		spin_unlock_irqrestore(&node->els_ios_lock, flags);
+		return NULL;
+	}
+
+	els->io.rsp.size = rsplen;
+	els->io.rsp.virt = dma_alloc_coherent(&efc->pci->dev, els->io.rsp.size,
+						&els->io.rsp.phys, GFP_DMA);
+	if (!els->io.rsp.virt) {
+		dma_free_coherent(&efc->pci->dev, els->io.req.size,
+					els->io.req.virt, els->io.req.phys);
+		kfree(els);
+		els = NULL;
+	}
+
+	if (els) {
+		/* initialize fields */
+		els->els_retries_remaining = EFC_FC_ELS_DEFAULT_RETRIES;
+
+		/* add els structure to ELS IO list */
+		INIT_LIST_HEAD(&els->list_entry);
+		list_add_tail(&els->list_entry, &node->els_ios_list);
+	}
+
+	spin_unlock_irqrestore(&node->els_ios_lock, flags);
+	return els;
+}
+
+void
+efc_els_io_free(struct efc_els_io_req *els)
+{
+	kref_put(&els->ref, els->release);
+}
+
+void
+_efc_els_io_free(struct kref *arg)
+{
+	struct efc_els_io_req *els =
+				container_of(arg, struct efc_els_io_req, ref);
+	struct efc *efc;
+	struct efc_node *node;
+	int send_empty_event = false;
+	unsigned long flags = 0;
+
+	node = els->node;
+	efc = node->efc;
+
+	spin_lock_irqsave(&node->els_ios_lock, flags);
+
+	list_del(&els->list_entry);
+	/* Send list empty event if the IO allocator
+	 * is disabled, and the list is empty
+	 * If node->els_io_enabled was not checked,
+	 * the event would be posted continually
+	 */
+	send_empty_event = (!node->els_io_enabled) &&
+			   list_empty(&node->els_ios_list);
+
+	spin_unlock_irqrestore(&node->els_ios_lock, flags);
+
+	/* free ELS request and response buffers */
+	dma_free_coherent(&efc->pci->dev, els->io.rsp.size,
+			  els->io.rsp.virt, els->io.rsp.phys);
+	dma_free_coherent(&efc->pci->dev, els->io.req.size,
+			  els->io.req.virt, els->io.req.phys);
+
+	kfree(els);
+
+	if (send_empty_event)
+		efc_scsi_io_list_empty(node->efc, node);
+}
+
+static void
+efc_els_retry(struct efc_els_io_req *els);
+
+static void
+efc_els_delay_timer_cb(struct timer_list *t)
+{
+	struct efc_els_io_req *els = from_timer(els, t, delay_timer);
+
+	/* Retry delay timer expired, retry the ELS request */
+	efc_els_retry(els);
+}
+
+static int
+efc_els_req_cb(void *arg, u32 length, int status, u32 ext_status)
+{
+	struct efc_els_io_req *els;
+	struct efc_node *node;
+	struct efc *efc;
+	struct efc_node_cb cbdata;
+	u32 reason_code;
+
+	els = arg;
+	node = els->node;
+	efc = node->efc;
+
+	if (status)
+		els_io_printf(els, "status x%x ext x%x\n", status, ext_status);
+
+	/* set the response len element of els->rsp */
+	els->io.rsp.len = length;
+
+	cbdata.status = status;
+	cbdata.ext_status = ext_status;
+	cbdata.header = NULL;
+	cbdata.els_rsp = els->io.rsp;
+
+	/* set the response len element of els->rsp */
+	cbdata.rsp_len = length;
+
+	/* FW returns the number of bytes received on the link in
+	 * the WCQE, not the amount placed in the buffer; use this info to
+	 * check if there was an overrun.
+	 */
+	if (length > els->io.rsp.size) {
+		efc_log_warn(efc,
+			      "ELS response returned len=%d > buflen=%zu\n",
+			     length, els->io.rsp.size);
+		efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL, &cbdata);
+		return EFC_SUCCESS;
+	}
+
+	/* Post event to ELS IO object */
+	switch (status) {
+	case SLI4_FC_WCQE_STATUS_SUCCESS:
+		efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_OK, &cbdata);
+		break;
+
+	case SLI4_FC_WCQE_STATUS_LS_RJT:
+		reason_code = (ext_status >> 16) & 0xff;
+
+		/* delay and retry if reason code is Logical Busy */
+		switch (reason_code) {
+		case ELS_RJT_BUSY:
+			els->node->els_req_cnt--;
+			els_io_printf(els,
+				"LS_RJT Logical Busy, delay and retry\n");
+			timer_setup(&els->delay_timer,
+				    efc_els_delay_timer_cb, 0);
+			mod_timer(&els->delay_timer,
+				  jiffies + msecs_to_jiffies(5000));
+			break;
+		default:
+			efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_RJT,
+					    &cbdata);
+			break;
+		}
+		break;
+
+	case SLI4_FC_WCQE_STATUS_LOCAL_REJECT:
+		switch (ext_status) {
+		case SLI4_FC_LOCAL_REJECT_SEQUENCE_TIMEOUT:
+			efc_els_retry(els);
+			break;
+		default:
+			efc_log_err(efc, "LOCAL_REJECT with ext status:%x\n",
+				    ext_status);
+			efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL,
+					    &cbdata);
+			break;
+		}
+		break;
+	default:	/* Other error */
+		efc_log_warn(efc, "els req failed status x%x, ext_status x%x\n",
+			     status, ext_status);
+		efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL, &cbdata);
+		break;
+	}
+
+	return EFC_SUCCESS;
+}
+
+void efc_disc_io_complete(struct efc_disc_io *io, u32 len, u32 status,
+			  u32 ext_status)
+{
+	struct efc_els_io_req *els =
+				container_of(io, struct efc_els_io_req, io);
+
+	WARN_ON(!els->cb);
+
+	((efc_hw_srrs_cb_t) els->cb) (els, len, status, ext_status);
+}
+
+static void efc_els_send_req(struct efc_node *node, struct efc_els_io_req *els,
+			     enum efc_disc_io_type io_type)
+{
+	int rc = 0;
+	struct efc *efc = node->efc;
+	struct efc_node_cb cbdata;
+
+	/* update ELS request counter */
+	els->node->els_req_cnt++;
+
+	/* Prepare the IO request details */
+	els->io.io_type = io_type;
+	els->io.xmit_len = els->io.req.size;
+	els->io.rsp_len = els->io.rsp.size;
+	els->io.rpi = node->rnode.indicator;
+	els->io.vpi = node->nport->indicator;
+	els->io.s_id = node->nport->fc_id;
+	els->io.d_id = node->rnode.fc_id;
+
+	if (node->rnode.attached)
+		els->io.rpi_registered = true;
+
+	els->cb = efc_els_req_cb;
+
+	rc = efc->tt.send_els(efc, &els->io);
+	if (!rc)
+		return;
+
+	cbdata.status = INT_MAX;
+	cbdata.ext_status = INT_MAX;
+	cbdata.els_rsp = els->io.rsp;
+	efc_log_err(efc, "efc_els_send failed: %d\n", rc);
+	efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL, &cbdata);
+}
+
+static void
+efc_els_retry(struct efc_els_io_req *els)
+{
+	struct efc *efc;
+	struct efc_node_cb cbdata;
+	u32 rc;
+
+	efc = els->node->efc;
+	cbdata.status = INT_MAX;
+	cbdata.ext_status = INT_MAX;
+	cbdata.els_rsp = els->io.rsp;
+
+
+	if (els->els_retries_remaining) {
+		els->els_retries_remaining--;
+		rc = efc->tt.send_els(efc, &els->io);
+	} else {
+		rc = EFC_FAIL;
+	}
+
+	if (rc) {
+		efc_log_err(efc, "ELS retries exhausted\n");
+		efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_REQ_FAIL, &cbdata);
+	}
+}
+
+static int
+efc_els_acc_cb(void *arg, u32 length, int status, u32 ext_status)
+{
+	struct efc_els_io_req *els;
+	struct efc_node *node;
+	struct efc *efc;
+	struct efc_node_cb cbdata;
+
+	els = arg;
+	node = els->node;
+	efc = node->efc;
+
+	cbdata.status = status;
+	cbdata.ext_status = ext_status;
+	cbdata.header = NULL;
+	cbdata.els_rsp = els->io.rsp;
+
+	/* Post node event */
+	switch (status) {
+	case SLI4_FC_WCQE_STATUS_SUCCESS:
+		efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_CMPL_OK, &cbdata);
+		break;
+
+	default:	/* Other error */
+		efc_log_warn(efc, "[%s] %-8s failed status x%x, ext x%x\n",
+			     node->display_name, els->display_name,
+			     status, ext_status);
+		efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_CMPL_FAIL, &cbdata);
+		break;
+	}
+
+	return EFC_SUCCESS;
+}
+
+static void
+efc_els_send_rsp(struct efc_els_io_req *els, u32 rsplen)
+{
+	int rc;
+	struct efc_node_cb cbdata;
+	struct efc_node *node = els->node;
+	struct efc *efc = node->efc;
+
+	/* increment ELS completion counter */
+	node->els_cmpl_cnt++;
+
+	els->io.io_type = EFC_DISC_IO_ELS_RESP;
+	els->cb = efc_els_acc_cb;
+
+	/* Prepare the IO request details */
+	els->io.xmit_len = rsplen;
+	els->io.rsp_len = els->io.rsp.size;
+	els->io.rpi = node->rnode.indicator;
+	els->io.vpi = node->nport->indicator;
+	if (node->nport->fc_id != U32_MAX)
+		els->io.s_id = node->nport->fc_id;
+	else
+		els->io.s_id = els->io.iparam.els.s_id;
+	els->io.d_id = node->rnode.fc_id;
+
+	if (node->attached)
+		els->io.rpi_registered = true;
+
+	rc = efc->tt.send_els(efc, &els->io);
+	if (!rc)
+		return;
+
+	cbdata.status = INT_MAX;
+	cbdata.ext_status = INT_MAX;
+	cbdata.els_rsp = els->io.rsp;
+	efc_els_io_cleanup(els, EFC_HW_SRRS_ELS_CMPL_FAIL, &cbdata);
+}
+
+int
+efc_send_plogi(struct efc_node *node)
+{
+	struct efc_els_io_req *els;
+	struct efc *efc = node->efc;
+	struct fc_els_flogi  *plogi;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*plogi));
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+	els->display_name = "plogi";
+
+	/* Build PLOGI request */
+	plogi = els->io.req.virt;
+
+	memcpy(plogi, node->nport->service_params, sizeof(*plogi));
+
+	plogi->fl_cmd = ELS_PLOGI;
+	memset(plogi->_fl_resvd, 0, sizeof(plogi->_fl_resvd));
+
+	efc_els_send_req(node, els, EFC_DISC_IO_ELS_REQ);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_flogi(struct efc_node *node)
+{
+	struct efc_els_io_req *els;
+	struct efc *efc;
+	struct fc_els_flogi  *flogi;
+
+	efc = node->efc;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*flogi));
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "flogi";
+
+	/* Build FLOGI request */
+	flogi = els->io.req.virt;
+
+	memcpy(flogi, node->nport->service_params, sizeof(*flogi));
+	flogi->fl_cmd = ELS_FLOGI;
+	memset(flogi->_fl_resvd, 0, sizeof(flogi->_fl_resvd));
+
+	efc_els_send_req(node, els, EFC_DISC_IO_ELS_REQ);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_fdisc(struct efc_node *node)
+{
+	struct efc_els_io_req *els;
+	struct efc *efc;
+	struct fc_els_flogi *fdisc;
+
+	efc = node->efc;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*fdisc));
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "fdisc";
+
+	/* Build FDISC request */
+	fdisc = els->io.req.virt;
+
+	memcpy(fdisc, node->nport->service_params, sizeof(*fdisc));
+	fdisc->fl_cmd = ELS_FDISC;
+	memset(fdisc->_fl_resvd, 0, sizeof(fdisc->_fl_resvd));
+
+	efc_els_send_req(node, els, EFC_DISC_IO_ELS_REQ);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_prli(struct efc_node *node)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els;
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp spp;
+	} *pp;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*pp));
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "prli";
+
+	/* Build PRLI request */
+	pp = els->io.req.virt;
+
+	memset(pp, 0, sizeof(*pp));
+
+	pp->prli.prli_cmd = ELS_PRLI;
+	pp->prli.prli_spp_len = 16;
+	pp->prli.prli_len = cpu_to_be16(sizeof(*pp));
+	pp->spp.spp_type = FC_TYPE_FCP;
+	pp->spp.spp_type_ext = 0;
+	pp->spp.spp_flags = FC_SPP_EST_IMG_PAIR;
+	pp->spp.spp_params = cpu_to_be32(FCP_SPPF_RD_XRDY_DIS |
+			       (node->nport->enable_ini ?
+			       FCP_SPPF_INIT_FCN : 0) |
+			       (node->nport->enable_tgt ?
+			       FCP_SPPF_TARG_FCN : 0));
+
+	efc_els_send_req(node, els, EFC_DISC_IO_ELS_REQ);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_logo(struct efc_node *node)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els;
+	struct fc_els_logo *logo;
+	struct fc_els_flogi  *sparams;
+
+	node_els_trace();
+
+	sparams = (struct fc_els_flogi *)node->nport->service_params;
+
+	els = efc_els_io_alloc(node, sizeof(*logo));
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "logo";
+
+	/* Build LOGO request */
+
+	logo = els->io.req.virt;
+
+	memset(logo, 0, sizeof(*logo));
+	logo->fl_cmd = ELS_LOGO;
+	hton24(logo->fl_n_port_id, node->rnode.nport->fc_id);
+	logo->fl_n_port_wwn = sparams->fl_wwpn;
+
+	efc_els_send_req(node, els, EFC_DISC_IO_ELS_REQ);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_adisc(struct efc_node *node)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els;
+	struct fc_els_adisc *adisc;
+	struct fc_els_flogi  *sparams;
+	struct efc_nport *nport = node->nport;
+
+	node_els_trace();
+
+	sparams = (struct fc_els_flogi *)node->nport->service_params;
+
+	els = efc_els_io_alloc(node, sizeof(*adisc));
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "adisc";
+
+	/* Build ADISC request */
+
+	adisc = els->io.req.virt;
+
+	memset(adisc, 0, sizeof(*adisc));
+	adisc->adisc_cmd = ELS_ADISC;
+	hton24(adisc->adisc_hard_addr, nport->fc_id);
+	adisc->adisc_wwpn = sparams->fl_wwpn;
+	adisc->adisc_wwnn = sparams->fl_wwnn;
+	hton24(adisc->adisc_port_id, node->rnode.nport->fc_id);
+
+	efc_els_send_req(node, els, EFC_DISC_IO_ELS_REQ);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_scr(struct efc_node *node)
+{
+	struct efc_els_io_req *els;
+	struct efc *efc = node->efc;
+	struct fc_els_scr *req;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*req));
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "scr";
+
+	req = els->io.req.virt;
+
+	memset(req, 0, sizeof(*req));
+	req->scr_cmd = ELS_SCR;
+	req->scr_reg_func = ELS_SCRF_FULL;
+
+	efc_els_send_req(node, els, EFC_DISC_IO_ELS_REQ);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_ls_rjt(struct efc_node *node, u32 ox_id, u32 reason_code,
+		u32 reason_code_expl, u32 vendor_unique)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els = NULL;
+	struct fc_els_ls_rjt *rjt;
+
+	els = efc_els_io_alloc(node, sizeof(*rjt));
+	if (!els) {
+		efc_log_err(efc, "els IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	node_els_trace();
+
+	els->display_name = "ls_rjt";
+
+	memset(&els->io.iparam, 0, sizeof(els->io.iparam));
+	els->io.iparam.els.ox_id = ox_id;
+
+	rjt = els->io.req.virt;
+	memset(rjt, 0, sizeof(*rjt));
+
+	rjt->er_cmd = ELS_LS_RJT;
+	rjt->er_reason = reason_code;
+	rjt->er_explan = reason_code_expl;
+
+	efc_els_send_rsp(els, sizeof(*rjt));
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_plogi_acc(struct efc_node *node, u32 ox_id)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els = NULL;
+	struct fc_els_flogi  *plogi;
+	struct fc_els_flogi  *req = (struct fc_els_flogi *)node->service_params;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*plogi));
+	if (!els) {
+		efc_log_err(efc, "els IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "plogi_acc";
+
+	memset(&els->io.iparam, 0, sizeof(els->io.iparam));
+	els->io.iparam.els.ox_id = ox_id;
+
+	plogi = els->io.req.virt;
+
+	/* copy our port's service parameters to payload */
+	memcpy(plogi, node->nport->service_params, sizeof(*plogi));
+	plogi->fl_cmd = ELS_LS_ACC;
+	memset(plogi->_fl_resvd, 0, sizeof(plogi->_fl_resvd));
+
+	/* Set Application header support bit if requested */
+	if (req->fl_csp.sp_features & cpu_to_be16(FC_SP_FT_BCAST))
+		plogi->fl_csp.sp_features |= cpu_to_be16(FC_SP_FT_BCAST);
+
+	efc_els_send_rsp(els, sizeof(*plogi));
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_flogi_p2p_acc(struct efc_node *node, u32 ox_id, u32 s_id)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els = NULL;
+	struct fc_els_flogi  *flogi;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*flogi));
+	if (!els) {
+		efc_log_err(efc, "els IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "flogi_p2p_acc";
+
+	memset(&els->io.iparam, 0, sizeof(els->io.iparam));
+	els->io.iparam.els.ox_id = ox_id;
+	els->io.iparam.els.s_id = s_id;
+
+	flogi = els->io.req.virt;
+
+	/* copy our port's service parameters to payload */
+	memcpy(flogi, node->nport->service_params, sizeof(*flogi));
+	flogi->fl_cmd = ELS_LS_ACC;
+	memset(flogi->_fl_resvd, 0, sizeof(flogi->_fl_resvd));
+
+	memset(flogi->fl_cssp, 0, sizeof(flogi->fl_cssp));
+
+	efc_els_send_rsp(els, sizeof(*flogi));
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_prli_acc(struct efc_node *node, u32 ox_id)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els = NULL;
+	struct {
+		struct fc_els_prli prli;
+		struct fc_els_spp spp;
+	} *pp;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*pp));
+	if (!els) {
+		efc_log_err(efc, "els IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "prli_acc";
+
+	memset(&els->io.iparam, 0, sizeof(els->io.iparam));
+	els->io.iparam.els.ox_id = ox_id;
+
+	pp = els->io.req.virt;
+	memset(pp, 0, sizeof(*pp));
+
+	pp->prli.prli_cmd = ELS_LS_ACC;
+	pp->prli.prli_spp_len = 0x10;
+	pp->prli.prli_len = cpu_to_be16(sizeof(*pp));
+	pp->spp.spp_type = FC_TYPE_FCP;
+	pp->spp.spp_type_ext = 0;
+	pp->spp.spp_flags = FC_SPP_EST_IMG_PAIR | FC_SPP_RESP_ACK;
+
+	pp->spp.spp_params = cpu_to_be32(FCP_SPPF_RD_XRDY_DIS |
+					(node->nport->enable_ini ?
+					 FCP_SPPF_INIT_FCN : 0) |
+					(node->nport->enable_tgt ?
+					 FCP_SPPF_TARG_FCN : 0));
+
+	efc_els_send_rsp(els, sizeof(*pp));
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_prlo_acc(struct efc_node *node, u32 ox_id)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els = NULL;
+	struct {
+		struct fc_els_prlo prlo;
+		struct fc_els_spp spp;
+	} *pp;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*pp));
+	if (!els) {
+		efc_log_err(efc, "els IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "prlo_acc";
+
+	memset(&els->io.iparam, 0, sizeof(els->io.iparam));
+	els->io.iparam.els.ox_id = ox_id;
+
+	pp = els->io.req.virt;
+	memset(pp, 0, sizeof(*pp));
+	pp->prlo.prlo_cmd = ELS_LS_ACC;
+	pp->prlo.prlo_obs = 0x10;
+	pp->prlo.prlo_len = cpu_to_be16(sizeof(*pp));
+
+	pp->spp.spp_type = FC_TYPE_FCP;
+	pp->spp.spp_type_ext = 0;
+	pp->spp.spp_flags = FC_SPP_RESP_ACK;
+
+	efc_els_send_rsp(els, sizeof(*pp));
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_ls_acc(struct efc_node *node, u32 ox_id)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els = NULL;
+	struct fc_els_ls_acc *acc;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*acc));
+	if (!els) {
+		efc_log_err(efc, "els IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "ls_acc";
+
+	memset(&els->io.iparam, 0, sizeof(els->io.iparam));
+	els->io.iparam.els.ox_id = ox_id;
+
+	acc = els->io.req.virt;
+	memset(acc, 0, sizeof(*acc));
+
+	acc->la_cmd = ELS_LS_ACC;
+
+	efc_els_send_rsp(els, sizeof(*acc));
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_logo_acc(struct efc_node *node, u32 ox_id)
+{
+	struct efc_els_io_req *els = NULL;
+	struct efc *efc = node->efc;
+	struct fc_els_ls_acc *logo;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*logo));
+	if (!els) {
+		efc_log_err(efc, "els IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "logo_acc";
+
+	memset(&els->io.iparam, 0, sizeof(els->io.iparam));
+	els->io.iparam.els.ox_id = ox_id;
+
+	logo = els->io.req.virt;
+	memset(logo, 0, sizeof(*logo));
+
+	logo->la_cmd = ELS_LS_ACC;
+
+	efc_els_send_rsp(els, sizeof(*logo));
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_adisc_acc(struct efc_node *node, u32 ox_id)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els = NULL;
+	struct fc_els_adisc *adisc;
+	struct fc_els_flogi  *sparams;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*adisc));
+	if (!els) {
+		efc_log_err(efc, "els IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->display_name = "adisc_acc";
+
+	/* Go ahead and send the ELS_ACC */
+	memset(&els->io.iparam, 0, sizeof(els->io.iparam));
+	els->io.iparam.els.ox_id = ox_id;
+
+	sparams = (struct fc_els_flogi  *)node->nport->service_params;
+	adisc = els->io.req.virt;
+	memset(adisc, 0, sizeof(*adisc));
+	adisc->adisc_cmd = ELS_LS_ACC;
+	adisc->adisc_wwpn = sparams->fl_wwpn;
+	adisc->adisc_wwnn = sparams->fl_wwnn;
+	hton24(adisc->adisc_port_id, node->rnode.nport->fc_id);
+
+	efc_els_send_rsp(els, sizeof(*adisc));
+
+	return EFC_SUCCESS;
+}
+
+static inline void
+fcct_build_req_header(struct fc_ct_hdr  *hdr, u16 cmd, u16 max_size)
+{
+	hdr->ct_rev = FC_CT_REV;
+	hdr->ct_fs_type = FC_FST_DIR;
+	hdr->ct_fs_subtype = FC_NS_SUBTYPE;
+	hdr->ct_options = 0;
+	hdr->ct_cmd = cpu_to_be16(cmd);
+	/* words */
+	hdr->ct_mr_size = cpu_to_be16(max_size / (sizeof(u32)));
+	hdr->ct_reason = 0;
+	hdr->ct_explan = 0;
+	hdr->ct_vendor = 0;
+}
+
+int
+efc_ns_send_rftid(struct efc_node *node)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els;
+	struct {
+		struct fc_ct_hdr hdr;
+		struct fc_ns_rft_id rftid;
+	} *ct;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*ct));
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->io.iparam.ct.r_ctl = FC_RCTL_ELS_REQ;
+	els->io.iparam.ct.type = FC_TYPE_CT;
+	els->io.iparam.ct.df_ctl = 0;
+	els->io.iparam.ct.timeout = EFC_FC_ELS_SEND_DEFAULT_TIMEOUT;
+
+	els->display_name = "rftid";
+
+	ct = els->io.req.virt;
+	memset(ct, 0, sizeof(*ct));
+	fcct_build_req_header(&ct->hdr, FC_NS_RFT_ID,
+				sizeof(struct fc_ns_rft_id));
+
+	hton24(ct->rftid.fr_fid.fp_fid, node->rnode.nport->fc_id);
+	ct->rftid.fr_fts.ff_type_map[FC_TYPE_FCP / FC_NS_BPW] =
+		cpu_to_be32(1 << (FC_TYPE_FCP % FC_NS_BPW));
+
+	efc_els_send_req(node, els, EFC_DISC_IO_CT_REQ);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_ns_send_rffid(struct efc_node *node)
+{
+	struct efc *efc = node->efc;
+	struct efc_els_io_req *els;
+	struct {
+		struct fc_ct_hdr hdr;
+		struct fc_ns_rff_id rffid;
+	} *ct;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc(node, sizeof(*ct));
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->io.iparam.ct.r_ctl = FC_RCTL_ELS_REQ;
+	els->io.iparam.ct.type = FC_TYPE_CT;
+	els->io.iparam.ct.df_ctl = 0;
+	els->io.iparam.ct.timeout = EFC_FC_ELS_SEND_DEFAULT_TIMEOUT;
+
+	els->display_name = "rffid";
+	ct = els->io.req.virt;
+
+	memset(ct, 0, sizeof(*ct));
+	fcct_build_req_header(&ct->hdr, FC_NS_RFF_ID,
+			      sizeof(struct fc_ns_rff_id));
+
+	hton24(ct->rffid.fr_fid.fp_fid, node->rnode.nport->fc_id);
+	if (node->nport->enable_ini)
+		ct->rffid.fr_feat |= FCP_FEAT_INIT;
+	if (node->nport->enable_tgt)
+		ct->rffid.fr_feat |= FCP_FEAT_TARG;
+	ct->rffid.fr_type = FC_TYPE_FCP;
+
+	efc_els_send_req(node, els, EFC_DISC_IO_CT_REQ);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_ns_send_gidpt(struct efc_node *node)
+{
+	struct efc_els_io_req *els = NULL;
+	struct efc *efc = node->efc;
+	struct {
+		struct fc_ct_hdr hdr;
+		struct fc_ns_gid_pt gidpt;
+	} *ct;
+
+	node_els_trace();
+
+	els = efc_els_io_alloc_size(node, sizeof(*ct), EFC_ELS_GID_PT_RSP_LEN);
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	els->io.iparam.ct.r_ctl = FC_RCTL_ELS_REQ;
+	els->io.iparam.ct.type = FC_TYPE_CT;
+	els->io.iparam.ct.df_ctl = 0;
+	els->io.iparam.ct.timeout = EFC_FC_ELS_SEND_DEFAULT_TIMEOUT;
+
+	els->display_name = "gidpt";
+
+	ct = els->io.req.virt;
+
+	memset(ct, 0, sizeof(*ct));
+	fcct_build_req_header(&ct->hdr, FC_NS_GID_PT,
+			      sizeof(struct fc_ns_gid_pt));
+
+	ct->gidpt.fn_pt_type = FC_TYPE_FCP;
+
+	efc_els_send_req(node, els, EFC_DISC_IO_CT_REQ);
+
+	return EFC_SUCCESS;
+}
+
+void
+efc_els_io_cleanup(struct efc_els_io_req *els,
+		    enum efc_hw_node_els_event node_evt, void *arg)
+{
+	/* don't want further events that could come; e.g. abort requests
+	 * from the node state machine; thus, disable state machine
+	 */
+	els->els_req_free = true;
+	efc_node_post_els_resp(els->node, node_evt, arg);
+
+	efc_els_io_free(els);
+}
+
+static int
+efc_ct_acc_cb(void *arg, u32 length, int status, u32 ext_status)
+{
+	struct efc_els_io_req *els = arg;
+
+	efc_els_io_free(els);
+
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_ct_rsp(struct efc *efc, struct efc_node *node, u16 ox_id,
+		 struct fc_ct_hdr *ct_hdr, u32 cmd_rsp_code,
+		 u32 reason_code, u32 reason_code_explanation)
+{
+	struct efc_els_io_req *els = NULL;
+	struct fc_ct_hdr  *rsp = NULL;
+
+	els = efc_els_io_alloc(node, 256);
+	if (!els) {
+		efc_log_err(efc, "IO alloc failed\n");
+		return EFC_FAIL;
+	}
+
+	rsp = els->io.rsp.virt;
+
+	*rsp = *ct_hdr;
+
+	fcct_build_req_header(rsp, cmd_rsp_code, 0);
+	rsp->ct_reason = reason_code;
+	rsp->ct_explan = reason_code_explanation;
+
+	els->display_name = "ct_rsp";
+	els->cb = efc_ct_acc_cb;
+
+	/* Prepare the IO request details */
+	els->io.io_type = EFC_DISC_IO_CT_RESP;
+	els->io.xmit_len = sizeof(*rsp);
+
+	els->io.rpi = node->rnode.indicator;
+	els->io.d_id = node->rnode.fc_id;
+
+	memset(&els->io.iparam, 0, sizeof(els->io.iparam));
+
+	els->io.iparam.ct.ox_id = ox_id;
+	els->io.iparam.ct.r_ctl = 3;
+	els->io.iparam.ct.type = FC_TYPE_CT;
+	els->io.iparam.ct.df_ctl = 0;
+	els->io.iparam.ct.timeout = 5;
+
+	if (efc->tt.send_els(efc, &els->io)) {
+		efc_els_io_free(els);
+		return EFC_FAIL;
+	}
+	return EFC_SUCCESS;
+}
+
+int
+efc_send_bls_acc(struct efc_node *node, struct fc_frame_header *hdr)
+{
+	struct sli_bls_params bls;
+	struct fc_ba_acc *acc;
+	struct efc *efc = node->efc;
+
+	memset(&bls, 0, sizeof(bls));
+	bls.ox_id = be16_to_cpu(hdr->fh_ox_id);
+	bls.rx_id = be16_to_cpu(hdr->fh_rx_id);
+	bls.s_id = ntoh24(hdr->fh_d_id);
+	bls.d_id = node->rnode.fc_id;
+	bls.rpi = node->rnode.indicator;
+	bls.vpi = node->nport->indicator;
+
+	acc = (void *)bls.payload;
+	acc->ba_ox_id = cpu_to_be16(bls.ox_id);
+	acc->ba_rx_id = cpu_to_be16(bls.rx_id);
+	acc->ba_high_seq_cnt = cpu_to_be16(U16_MAX);
+
+	return efc->tt.send_bls(efc, FC_RCTL_BA_ACC, &bls);
+}
diff --git a/drivers/scsi/elx/libefc/efc_els.h b/drivers/scsi/elx/libefc/efc_els.h
new file mode 100644
index 000000000000..cf231a147cea
--- /dev/null
+++ b/drivers/scsi/elx/libefc/efc_els.h
@@ -0,0 +1,107 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#ifndef __EFC_ELS_H__
+#define __EFC_ELS_H__
+
+struct efc_els_io_req {
+	struct list_head	list_entry;
+	struct kref		ref;
+	void			(*release)(struct kref *arg);
+	struct efc_node		*node;
+	void			*cb;
+	uint32_t		els_retries_remaining;
+	bool			els_req_free;
+	struct timer_list       delay_timer;
+
+	const char		*display_name;
+
+	struct efc_disc_io	io;
+};
+
+typedef int(*efc_hw_srrs_cb_t)(void *arg, u32 length, int status,
+			       u32 ext_status);
+
+void efc_io_alloc_enable(struct efc_node *node);
+void efc_io_alloc_disable(struct efc_node *node);
+void _efc_els_io_free(struct kref *arg);
+struct efc_els_io_req *
+efc_els_io_alloc(struct efc_node *node, u32 reqlen);
+struct efc_els_io_req *
+efc_els_io_alloc_size(struct efc_node *node, u32 reqlen, u32 rsplen);
+void efc_els_io_free(struct efc_els_io_req *els);
+
+/* ELS command send */
+typedef void (*els_cb_t)(struct efc_node *node,
+			 struct efc_node_cb *cbdata, void *arg);
+int
+efc_send_plogi(struct efc_node *node);
+int
+efc_send_flogi(struct efc_node *node);
+int
+efc_send_fdisc(struct efc_node *node);
+int
+efc_send_prli(struct efc_node *node);
+int
+efc_send_prlo(struct efc_node *node);
+int
+efc_send_logo(struct efc_node *node);
+int
+efc_send_adisc(struct efc_node *node);
+int
+efc_send_pdisc(struct efc_node *node);
+int
+efc_send_scr(struct efc_node *node);
+int
+efc_ns_send_rftid(struct efc_node *node);
+int
+efc_ns_send_rffid(struct efc_node *node);
+int
+efc_ns_send_gidpt(struct efc_node *node);
+void
+efc_els_io_cleanup(struct efc_els_io_req *els, enum efc_hw_node_els_event,
+		   void *arg);
+
+/* ELS acc send */
+int
+efc_send_ls_acc(struct efc_node *node, u32 ox_id);
+int
+efc_send_ls_rjt(struct efc_node *node, u32 ox_id, u32 reason_cod,
+		u32 reason_code_expl, u32 vendor_unique);
+int
+efc_send_flogi_p2p_acc(struct efc_node *node, u32 ox_id, u32 s_id);
+int
+efc_send_flogi_acc(struct efc_node *node, u32 ox_id, u32 is_fport);
+int
+efc_send_plogi_acc(struct efc_node *node, u32 ox_id);
+int
+efc_send_prli_acc(struct efc_node *node, u32 ox_id);
+int
+efc_send_logo_acc(struct efc_node *node, u32 ox_id);
+int
+efc_send_prlo_acc(struct efc_node *node, u32 ox_id);
+int
+efc_send_adisc_acc(struct efc_node *node, u32 ox_id);
+
+int
+efc_bls_send_acc_hdr(struct efc *efc, struct efc_node *node,
+		     struct fc_frame_header *hdr);
+int
+efc_bls_send_rjt_hdr(struct efc_els_io_req *io, struct fc_frame_header *hdr);
+
+int
+efc_els_io_list_empty(struct efc_node *node, struct list_head *list);
+
+/* CT */
+int
+efc_send_ct_rsp(struct efc *efc, struct efc_node *node, u16 ox_id,
+		 struct fc_ct_hdr *ct_hdr, u32 cmd_rsp_code, u32 reason_code,
+		 u32 reason_code_explanation);
+
+int
+efc_send_bls_acc(struct efc_node *node, struct fc_frame_header *hdr);
+
+#endif /* __EFC_ELS_H__ */
-- 
2.26.2


--0000000000007970ca05b18126c3
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgpKCBJqa7YO94P0Pt
9bydxr/8gB9OKYOvLCKmkMWO8ggwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDEyMjI1MjE3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBACMtLJoaZPlkSaQgRunQkGBvytN/4oTmSoWE
nw/WTAkKJsKcJdFsb+UTfeAVjwoYTlB+upFWs8gPPSkKWpE1JdJJ39YtuYgmFT65MSEOKsIlUjNe
cymc+FL/Kee4g+hcPCrhJciTu2+3p9Nubup1pp2g+RUmcPUWj2IplO4Phk/R6CfTQOPtYvF5D4rR
tNUeSLLihVNr/Ek0F+aO/juQz49QDnGlXMElw2fzPWhiiW+xOhoVfkWR/T8L5d+o9TeJUCUvprGm
LxVrlQDRIE0lQRy2xtvv4TXu7WmkyA0YDVlLO65KTlcrfcL/8S1BwtLITV+z8gKUsa+MYgcHakx0
biY=
--0000000000007970ca05b18126c3--
