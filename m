Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C15C4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5724E61351
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 23:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhFAX52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 19:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235277AbhFAX5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 19:57:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D78C061761
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 16:55:34 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id d5-20020a17090ab305b02901675357c371so2056433pjr.1
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 16:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K6XUjD1/ojGZcG1cK20r/V+Da6Z1wuH0WDIHRQUX6EA=;
        b=gHdGIHai26EPLI2f4HmUNPdTxQEudxuhSLKBNNeenRVsgx9pdgfTHYNYND4rjzPlSX
         b3GQAWs5C1WTGITIT9JxSgPu9JuVyBNv1vP7M8jempA8B28WGIsY/oBGZw/PW88wDgXV
         BVngem8rO6Dvd8auJMtK267ds/dcCOBcuV1fbx0YhTYmCCk9FpR8zh24OxXM6GynD3mR
         ONyWemJXYodVtR2S8GJJHjGT/nyMEfFUBivIHeXKqNDK5Dt3vMhuuN4vUSJCSfZ5JCU+
         Rpd/rYhTdoLMqqfqAjub/RsHHYKENuhXomMaA4V5j6INIv+nD+G3BzdjwpNM7rXBjEwt
         Oapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K6XUjD1/ojGZcG1cK20r/V+Da6Z1wuH0WDIHRQUX6EA=;
        b=IT6Q7EXR20IgN7WuN+eVwdhZ0RpPuS5fbYo9xRPkw6TMRd/QmsNdgl1xg4iutni6oZ
         VXqLGU55RhQ/pkr+x0Y9I4lP4gZfUGlUwXxUJ8ILcmHUoLAJnJ0RrPmimzqbzUgXZFmZ
         PGug7pYzXDBbAvDtxYzBryHrUNfDfCTQgFZl50o4rzI2UkyMD2qj5ZrXMPJk+kVkRVPq
         O9zWI8V4cefyMBUR2kFsvmgxDbH9sbkkatAM4Jze6PnI2e4853CETTTH8du/aCeJeZel
         t3AXL25T1/6Oy3N4LnLLgMpek5bru33l9Ytzi1tJMVrz7MxBMM7gCcB3Lso6I/IYPuGG
         VH7g==
X-Gm-Message-State: AOAM532VWtjE9yA9iWzS43FpDTyxwqp8KrG/fYgurFO9uPZifFRCoHkm
        MqhF/T5RsGE22TskUg8gufgAIm53rsE=
X-Google-Smtp-Source: ABdhPJz6Ygb94Y/+nqk6bTfrz5Nd2Wb7N40yBgTesMo5BBi04yrSjDqUjWGmcA9s5DJg0pqVFCqmvA==
X-Received: by 2002:a17:90a:46cf:: with SMTP id x15mr2410711pjg.183.1622591732201;
        Tue, 01 Jun 2021 16:55:32 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm13915357pfm.187.2021.06.01.16.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 16:55:31 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v9 18/31] elx: efct: Driver initialization routines
Date:   Tue,  1 Jun 2021 16:54:59 -0700
Message-Id: <20210601235512.20104-19-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210601235512.20104-1-jsmart2021@gmail.com>
References: <20210601235512.20104-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch continues the efct driver population.

This patch adds driver definitions for:
Emulex FC Target driver init, attach and hardware setup routines.

Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>

---
v9:
Non-functional changes:
  Remove EFC_SUCCESS/EFC_FAIL defines and use 0 and -Exxx errno values.
  Remove EFCT_xxx/EFCT_HW_RTN_xxx defines and use appropriate -Exxx errno
       values.
  Correct indentation on line continuations.
---
 drivers/scsi/elx/efct/efct_driver.c |  786 ++++++++++++++++++
 drivers/scsi/elx/efct/efct_driver.h |  109 +++
 drivers/scsi/elx/efct/efct_hw.c     | 1153 +++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h     |   15 +
 drivers/scsi/elx/efct/efct_xport.c  |  500 ++++++++++++
 drivers/scsi/elx/efct/efct_xport.h  |  186 +++++
 6 files changed, 2749 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_driver.c
 create mode 100644 drivers/scsi/elx/efct/efct_driver.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw.c
 create mode 100644 drivers/scsi/elx/efct/efct_xport.c
 create mode 100644 drivers/scsi/elx/efct/efct_xport.h

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
new file mode 100644
index 000000000000..2fa5996fc0d5
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -0,0 +1,786 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+
+#include "efct_hw.h"
+#include "efct_unsol.h"
+#include "efct_scsi.h"
+
+LIST_HEAD(efct_devices);
+
+static int logmask;
+module_param(logmask, int, 0444);
+MODULE_PARM_DESC(logmask, "logging bitmask (default 0)");
+
+static struct libefc_function_template efct_libefc_templ = {
+	.issue_mbox_rqst = efct_issue_mbox_rqst,
+	.send_els = efct_els_hw_srrs_send,
+	.send_bls = efct_efc_bls_send,
+
+	.new_nport = efct_scsi_tgt_new_nport,
+	.del_nport = efct_scsi_tgt_del_nport,
+	.scsi_new_node = efct_scsi_new_initiator,
+	.scsi_del_node = efct_scsi_del_initiator,
+	.hw_seq_free = efct_efc_hw_sequence_free,
+};
+
+static int
+efct_device_init(void)
+{
+	int rc;
+
+	/* driver-wide init for target-server */
+	rc = efct_scsi_tgt_driver_init();
+	if (rc) {
+		pr_err("efct_scsi_tgt_init failed rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = efct_scsi_reg_fc_transport();
+	if (rc) {
+		pr_err("failed to register to FC host\n");
+		return rc;
+	}
+
+	return 0;
+}
+
+static void
+efct_device_shutdown(void)
+{
+	efct_scsi_release_fc_transport();
+
+	efct_scsi_tgt_driver_exit();
+}
+
+static void *
+efct_device_alloc(u32 nid)
+{
+	struct efct *efct = NULL;
+
+	efct = kzalloc_node(sizeof(*efct), GFP_KERNEL, nid);
+	if (!efct)
+		return efct;
+
+	INIT_LIST_HEAD(&efct->list_entry);
+	list_add_tail(&efct->list_entry, &efct_devices);
+
+	return efct;
+}
+
+static void
+efct_teardown_msix(struct efct *efct)
+{
+	u32 i;
+
+	for (i = 0; i < efct->n_msix_vec; i++) {
+		free_irq(pci_irq_vector(efct->pci, i),
+			 &efct->intr_context[i]);
+	}
+
+	pci_free_irq_vectors(efct->pci);
+}
+
+static int
+efct_efclib_config(struct efct *efct, struct libefc_function_template *tt)
+{
+	struct efc *efc;
+	struct sli4 *sli;
+	int rc = 0;
+
+	efc = kzalloc(sizeof(*efc), GFP_KERNEL);
+	if (!efc)
+		return -ENOMEM;
+
+	efct->efcport = efc;
+
+	memcpy(&efc->tt, tt, sizeof(*tt));
+	efc->base = efct;
+	efc->pci = efct->pci;
+
+	efc->def_wwnn = efct_get_wwnn(&efct->hw);
+	efc->def_wwpn = efct_get_wwpn(&efct->hw);
+	efc->enable_tgt = 1;
+	efc->log_level = EFC_LOG_LIB;
+
+	sli = &efct->hw.sli;
+	efc->max_xfer_size = sli->sge_supported_length *
+			     sli_get_max_sgl(&efct->hw.sli);
+	efc->sli = sli;
+	efc->fcfi = efct->hw.fcf_indicator;
+
+	rc = efcport_init(efc);
+	if (rc)
+		efc_log_err(efc, "efcport_init failed\n");
+
+	return rc;
+}
+
+static int efct_request_firmware_update(struct efct *efct);
+
+static const char*
+efct_pci_model(u16 device)
+{
+	switch (device) {
+	case EFCT_DEVICE_LANCER_G6:	return "LPE31004";
+	case EFCT_DEVICE_LANCER_G7:	return "LPE36000";
+	default:			return "unknown";
+	}
+}
+
+static int
+efct_device_attach(struct efct *efct)
+{
+	u32 rc = 0, i = 0;
+
+	if (efct->attached) {
+		efc_log_err(efct, "Device is already attached\n");
+		return -EIO;
+	}
+
+	snprintf(efct->name, sizeof(efct->name), "[%s%d] ", "fc",
+		 efct->instance_index);
+
+	efct->logmask = logmask;
+	efct->filter_def = EFCT_DEFAULT_FILTER;
+	efct->max_isr_time_msec = EFCT_OS_MAX_ISR_TIME_MSEC;
+
+	efct->model = efct_pci_model(efct->pci->device);
+
+	efct->efct_req_fw_upgrade = true;
+
+	/* Allocate transport object and bring online */
+	efct->xport = efct_xport_alloc(efct);
+	if (!efct->xport) {
+		efc_log_err(efct, "failed to allocate transport object\n");
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	rc = efct_xport_attach(efct->xport);
+	if (rc) {
+		efc_log_err(efct, "failed to attach transport object\n");
+		goto xport_out;
+	}
+
+	rc = efct_xport_initialize(efct->xport);
+	if (rc) {
+		efc_log_err(efct, "failed to initialize transport object\n");
+		goto xport_out;
+	}
+
+	rc = efct_efclib_config(efct, &efct_libefc_templ);
+	if (rc) {
+		efc_log_err(efct, "failed to init efclib\n");
+		goto efclib_out;
+	}
+
+	for (i = 0; i < efct->n_msix_vec; i++) {
+		efc_log_debug(efct, "irq %d enabled\n", i);
+		enable_irq(pci_irq_vector(efct->pci, i));
+	}
+
+	efct->attached = true;
+
+	if (efct->efct_req_fw_upgrade)
+		efct_request_firmware_update(efct);
+
+	return rc;
+
+efclib_out:
+	efct_xport_detach(efct->xport);
+xport_out:
+	efct_xport_free(efct->xport);
+	efct->xport = NULL;
+out:
+	return rc;
+}
+
+static int
+efct_device_detach(struct efct *efct)
+{
+	int i;
+
+	if (!efct || !efct->attached) {
+		pr_err("Device is not attached\n");
+		return -EIO;
+	}
+
+	if (efct_xport_control(efct->xport, EFCT_XPORT_SHUTDOWN))
+		efc_log_err(efct, "Transport Shutdown timed out\n");
+
+	for (i = 0; i < efct->n_msix_vec; i++)
+		disable_irq(pci_irq_vector(efct->pci, i));
+
+	efct_xport_detach(efct->xport);
+
+	efct_xport_free(efct->xport);
+	efct->xport = NULL;
+
+	efcport_destroy(efct->efcport);
+	kfree(efct->efcport);
+
+	efct->attached = false;
+
+	return 0;
+}
+
+static void
+efct_fw_write_cb(int status, u32 actual_write_length,
+		 u32 change_status, void *arg)
+{
+	struct efct_fw_write_result *result = arg;
+
+	result->status = status;
+	result->actual_xfer = actual_write_length;
+	result->change_status = change_status;
+
+	complete(&result->done);
+}
+
+static int
+efct_firmware_write(struct efct *efct, const u8 *buf, size_t buf_len,
+		    u8 *change_status)
+{
+	int rc = 0;
+	u32 bytes_left;
+	u32 xfer_size;
+	u32 offset;
+	struct efc_dma dma;
+	int last = 0;
+	struct efct_fw_write_result result;
+
+	init_completion(&result.done);
+
+	bytes_left = buf_len;
+	offset = 0;
+
+	dma.size = FW_WRITE_BUFSIZE;
+	dma.virt = dma_alloc_coherent(&efct->pci->dev,
+				      dma.size, &dma.phys, GFP_DMA);
+	if (!dma.virt)
+		return -ENOMEM;
+
+	while (bytes_left > 0) {
+		if (bytes_left > FW_WRITE_BUFSIZE)
+			xfer_size = FW_WRITE_BUFSIZE;
+		else
+			xfer_size = bytes_left;
+
+		memcpy(dma.virt, buf + offset, xfer_size);
+
+		if (bytes_left == xfer_size)
+			last = 1;
+
+		efct_hw_firmware_write(&efct->hw, &dma, xfer_size, offset,
+				       last, efct_fw_write_cb, &result);
+
+		if (wait_for_completion_interruptible(&result.done) != 0) {
+			rc = -ENXIO;
+			break;
+		}
+
+		if (result.actual_xfer == 0 || result.status != 0) {
+			rc = -EFAULT;
+			break;
+		}
+
+		if (last)
+			*change_status = result.change_status;
+
+		bytes_left -= result.actual_xfer;
+		offset += result.actual_xfer;
+	}
+
+	dma_free_coherent(&efct->pci->dev, dma.size, dma.virt, dma.phys);
+	return rc;
+}
+
+static int
+efct_fw_reset(struct efct *efct)
+{
+	/*
+	 * Firmware reset to activate the new firmware.
+	 * Function 0 will update and load the new firmware
+	 * during attach.
+	 */
+	if (timer_pending(&efct->xport->stats_timer))
+		del_timer(&efct->xport->stats_timer);
+
+	if (efct_hw_reset(&efct->hw, EFCT_HW_RESET_FIRMWARE)) {
+		efc_log_info(efct, "failed to reset firmware\n");
+		return -EIO;
+	}
+
+	efc_log_info(efct, "successfully reset firmware.Now resetting port\n");
+
+	efct_device_detach(efct);
+	return efct_device_attach(efct);
+}
+
+static int
+efct_request_firmware_update(struct efct *efct)
+{
+	int rc = 0;
+	u8 file_name[256], fw_change_status = 0;
+	const struct firmware *fw;
+	struct efct_hw_grp_hdr *fw_image;
+
+	snprintf(file_name, 256, "%s.grp", efct->model);
+
+	rc = request_firmware(&fw, file_name, &efct->pci->dev);
+	if (rc) {
+		efc_log_debug(efct, "Firmware file(%s) not found.\n", file_name);
+		return rc;
+	}
+
+	fw_image = (struct efct_hw_grp_hdr *)fw->data;
+
+	if (!strncmp(efct->hw.sli.fw_name[0], fw_image->revision,
+		     strnlen(fw_image->revision, 16))) {
+		efc_log_debug(efct,
+			      "Skip update. Firmware is already up to date.\n");
+		goto exit;
+	}
+
+	efc_log_info(efct, "Firmware update is initiated. %s -> %s\n",
+		     efct->hw.sli.fw_name[0], fw_image->revision);
+
+	rc = efct_firmware_write(efct, fw->data, fw->size, &fw_change_status);
+	if (rc) {
+		efc_log_err(efct, "Firmware update failed. rc = %d\n", rc);
+		goto exit;
+	}
+
+	efc_log_info(efct, "Firmware updated successfully\n");
+	switch (fw_change_status) {
+	case 0x00:
+		efc_log_info(efct, "New firmware is active.\n");
+		break;
+	case 0x01:
+		efc_log_info(efct,
+			"System reboot needed to activate the new firmware\n");
+		break;
+	case 0x02:
+	case 0x03:
+		efc_log_info(efct,
+			     "firmware reset to activate the new firmware\n");
+		efct_fw_reset(efct);
+		break;
+	default:
+		efc_log_info(efct, "Unexected value change_status:%d\n",
+			     fw_change_status);
+		break;
+	}
+
+exit:
+	release_firmware(fw);
+
+	return rc;
+}
+
+static void
+efct_device_free(struct efct *efct)
+{
+	if (efct) {
+		list_del(&efct->list_entry);
+		kfree(efct);
+	}
+}
+
+static int
+efct_device_interrupts_required(struct efct *efct)
+{
+	int rc;
+
+	rc = efct_hw_setup(&efct->hw, efct, efct->pci);
+	if (rc < 0)
+		return rc;
+
+	return efct->hw.config.n_eq;
+}
+
+static irqreturn_t
+efct_intr_thread(int irq, void *handle)
+{
+	struct efct_intr_context *intr_ctx = handle;
+	struct efct *efct = intr_ctx->efct;
+
+	efct_hw_process(&efct->hw, intr_ctx->index, efct->max_isr_time_msec);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t
+efct_intr_msix(int irq, void *handle)
+{
+	return IRQ_WAKE_THREAD;
+}
+
+static int
+efct_setup_msix(struct efct *efct, u32 num_intrs)
+{
+	int rc = 0, i;
+
+	if (!pci_find_capability(efct->pci, PCI_CAP_ID_MSIX)) {
+		dev_err(&efct->pci->dev,
+			"%s : MSI-X not available\n", __func__);
+		return -EIO;
+	}
+
+	efct->n_msix_vec = num_intrs;
+
+	rc = pci_alloc_irq_vectors(efct->pci, num_intrs, num_intrs,
+				   PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+
+	if (rc < 0) {
+		dev_err(&efct->pci->dev, "Failed to alloc irq : %d\n", rc);
+		return rc;
+	}
+
+	for (i = 0; i < num_intrs; i++) {
+		struct efct_intr_context *intr_ctx = NULL;
+
+		intr_ctx = &efct->intr_context[i];
+		intr_ctx->efct = efct;
+		intr_ctx->index = i;
+
+		rc = request_threaded_irq(pci_irq_vector(efct->pci, i),
+					  efct_intr_msix, efct_intr_thread, 0,
+					  EFCT_DRIVER_NAME, intr_ctx);
+		if (rc) {
+			dev_err(&efct->pci->dev,
+				"Failed to register %d vector: %d\n", i, rc);
+			goto out;
+		}
+	}
+
+	return rc;
+
+out:
+	while (--i >= 0)
+		free_irq(pci_irq_vector(efct->pci, i),
+			 &efct->intr_context[i]);
+
+	pci_free_irq_vectors(efct->pci);
+	return rc;
+}
+
+static struct pci_device_id efct_pci_table[] = {
+	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G6), 0},
+	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G7), 0},
+	{}	/* terminate list */
+};
+
+static int
+efct_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct efct *efct = NULL;
+	int rc;
+	u32 i, r;
+	int num_interrupts = 0;
+	int nid;
+
+	dev_info(&pdev->dev, "%s\n", EFCT_DRIVER_NAME);
+
+	rc = pci_enable_device_mem(pdev);
+	if (rc)
+		return rc;
+
+	pci_set_master(pdev);
+
+	rc = pci_set_mwi(pdev);
+	if (rc) {
+		dev_info(&pdev->dev, "pci_set_mwi returned %d\n", rc);
+		goto mwi_out;
+	}
+
+	rc = pci_request_regions(pdev, EFCT_DRIVER_NAME);
+	if (rc) {
+		dev_err(&pdev->dev, "pci_request_regions failed %d\n", rc);
+		goto req_regions_out;
+	}
+
+	/* Fetch the Numa node id for this device */
+	nid = dev_to_node(&pdev->dev);
+	if (nid < 0) {
+		dev_err(&pdev->dev, "Warning Numa node ID is %d\n", nid);
+		nid = 0;
+	}
+
+	/* Allocate efct */
+	efct = efct_device_alloc(nid);
+	if (!efct) {
+		dev_err(&pdev->dev, "Failed to allocate efct\n");
+		rc = -ENOMEM;
+		goto alloc_out;
+	}
+
+	efct->pci = pdev;
+	efct->numa_node = nid;
+
+	/* Map all memory BARs */
+	for (i = 0, r = 0; i < EFCT_PCI_MAX_REGS; i++) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
+			efct->reg[r] = ioremap(pci_resource_start(pdev, i),
+					       pci_resource_len(pdev, i));
+			r++;
+		}
+
+		/*
+		 * If the 64-bit attribute is set, both this BAR and the
+		 * next form the complete address. Skip processing the
+		 * next BAR.
+		 */
+		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM_64)
+			i++;
+	}
+
+	pci_set_drvdata(pdev, efct);
+
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0 ||
+	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
+		dev_warn(&pdev->dev, "trying DMA_BIT_MASK(32)\n");
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0 ||
+		    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) {
+			dev_err(&pdev->dev, "setting DMA_BIT_MASK failed\n");
+			rc = -1;
+			goto dma_mask_out;
+		}
+	}
+
+	num_interrupts = efct_device_interrupts_required(efct);
+	if (num_interrupts < 0) {
+		efc_log_err(efct, "efct_device_interrupts_required failed\n");
+		rc = -1;
+		goto dma_mask_out;
+	}
+
+	/*
+	 * Initialize MSIX interrupts, note,
+	 * efct_setup_msix() enables the interrupt
+	 */
+	rc = efct_setup_msix(efct, num_interrupts);
+	if (rc) {
+		dev_err(&pdev->dev, "Can't setup msix\n");
+		goto dma_mask_out;
+	}
+	/* Disable interrupt for now */
+	for (i = 0; i < efct->n_msix_vec; i++) {
+		efc_log_debug(efct, "irq %d disabled\n", i);
+		disable_irq(pci_irq_vector(efct->pci, i));
+	}
+
+	rc = efct_device_attach(efct);
+	if (rc)
+		goto attach_out;
+
+	return 0;
+
+attach_out:
+	efct_teardown_msix(efct);
+dma_mask_out:
+	pci_set_drvdata(pdev, NULL);
+
+	for (i = 0; i < EFCT_PCI_MAX_REGS; i++) {
+		if (efct->reg[i])
+			iounmap(efct->reg[i]);
+	}
+	efct_device_free(efct);
+alloc_out:
+	pci_release_regions(pdev);
+req_regions_out:
+	pci_clear_mwi(pdev);
+mwi_out:
+	pci_disable_device(pdev);
+	return rc;
+}
+
+static void
+efct_pci_remove(struct pci_dev *pdev)
+{
+	struct efct *efct = pci_get_drvdata(pdev);
+	u32 i;
+
+	if (!efct)
+		return;
+
+	efct_device_detach(efct);
+
+	efct_teardown_msix(efct);
+
+	for (i = 0; i < EFCT_PCI_MAX_REGS; i++) {
+		if (efct->reg[i])
+			iounmap(efct->reg[i]);
+	}
+
+	pci_set_drvdata(pdev, NULL);
+
+	efct_device_free(efct);
+
+	pci_release_regions(pdev);
+
+	pci_disable_device(pdev);
+}
+
+static void
+efct_device_prep_for_reset(struct efct *efct, struct pci_dev *pdev)
+{
+	if (efct) {
+		efc_log_debug(efct,
+			      "PCI channel disable preparing for reset\n");
+		efct_device_detach(efct);
+		/* Disable interrupt and pci device */
+		efct_teardown_msix(efct);
+	}
+	pci_disable_device(pdev);
+}
+
+static void
+efct_device_prep_for_recover(struct efct *efct)
+{
+	if (efct) {
+		efc_log_debug(efct, "PCI channel preparing for recovery\n");
+		efct_hw_io_abort_all(&efct->hw);
+	}
+}
+
+/**
+ * efct_pci_io_error_detected - method for handling PCI I/O error
+ * @pdev: pointer to PCI device.
+ * @state: the current PCI connection state.
+ *
+ * This routine is registered to the PCI subsystem for error handling. This
+ * function is called by the PCI subsystem after a PCI bus error affecting
+ * this device has been detected. When this routine is invoked, it dispatches
+ * device error detected handling routine, which will perform the proper
+ * error detected operation.
+ *
+ * Return codes
+ * PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
+ * PCI_ERS_RESULT_DISCONNECT - device could not be recovered
+ */
+static pci_ers_result_t
+efct_pci_io_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
+{
+	struct efct *efct = pci_get_drvdata(pdev);
+	pci_ers_result_t rc;
+
+	switch (state) {
+	case pci_channel_io_normal:
+		efct_device_prep_for_recover(efct);
+		rc = PCI_ERS_RESULT_CAN_RECOVER;
+		break;
+	case pci_channel_io_frozen:
+		efct_device_prep_for_reset(efct, pdev);
+		rc = PCI_ERS_RESULT_NEED_RESET;
+		break;
+	case pci_channel_io_perm_failure:
+		efct_device_detach(efct);
+		rc = PCI_ERS_RESULT_DISCONNECT;
+		break;
+	default:
+		efc_log_debug(efct, "Unknown PCI error state:0x%x\n", state);
+		efct_device_prep_for_reset(efct, pdev);
+		rc = PCI_ERS_RESULT_NEED_RESET;
+		break;
+	}
+
+	return rc;
+}
+
+static pci_ers_result_t
+efct_pci_io_slot_reset(struct pci_dev *pdev)
+{
+	int rc;
+	struct efct *efct = pci_get_drvdata(pdev);
+
+	rc = pci_enable_device_mem(pdev);
+	if (rc) {
+		efc_log_err(efct, "failed to enable PCI device after reset\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	/*
+	 * As the new kernel behavior of pci_restore_state() API call clears
+	 * device saved_state flag, need to save the restored state again.
+	 */
+
+	pci_save_state(pdev);
+
+	pci_set_master(pdev);
+
+	rc = efct_setup_msix(efct, efct->n_msix_vec);
+	if (rc)
+		efc_log_err(efct, "rc %d returned, IRQ allocation failed\n",
+			    rc);
+
+	/* Perform device reset */
+	efct_device_detach(efct);
+	/* Bring device to online*/
+	efct_device_attach(efct);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static void
+efct_pci_io_resume(struct pci_dev *pdev)
+{
+	struct efct *efct = pci_get_drvdata(pdev);
+
+	/* Perform device reset */
+	efct_device_detach(efct);
+	/* Bring device to online*/
+	efct_device_attach(efct);
+}
+
+MODULE_DEVICE_TABLE(pci, efct_pci_table);
+
+static struct pci_error_handlers efct_pci_err_handler = {
+	.error_detected = efct_pci_io_error_detected,
+	.slot_reset = efct_pci_io_slot_reset,
+	.resume = efct_pci_io_resume,
+};
+
+static struct pci_driver efct_pci_driver = {
+	.name		= EFCT_DRIVER_NAME,
+	.id_table	= efct_pci_table,
+	.probe		= efct_pci_probe,
+	.remove		= efct_pci_remove,
+	.err_handler	= &efct_pci_err_handler,
+};
+
+static
+int __init efct_init(void)
+{
+	int rc;
+
+	rc = efct_device_init();
+	if (rc) {
+		pr_err("efct_device_init failed rc=%d\n", rc);
+		return rc;
+	}
+
+	rc = pci_register_driver(&efct_pci_driver);
+	if (rc) {
+		pr_err("pci_register_driver failed rc=%d\n", rc);
+		efct_device_shutdown();
+	}
+
+	return rc;
+}
+
+static void __exit efct_exit(void)
+{
+	pci_unregister_driver(&efct_pci_driver);
+	efct_device_shutdown();
+}
+
+module_init(efct_init);
+module_exit(efct_exit);
+MODULE_VERSION(EFCT_DRIVER_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Broadcom");
diff --git a/drivers/scsi/elx/efct/efct_driver.h b/drivers/scsi/elx/efct/efct_driver.h
new file mode 100644
index 000000000000..dab8eac4f243
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_driver.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_DRIVER_H__)
+#define __EFCT_DRIVER_H__
+
+/***************************************************************************
+ * OS specific includes
+ */
+#include <stdarg.h>
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/firmware.h>
+#include "../include/efc_common.h"
+#include "../libefc/efclib.h"
+#include "efct_hw.h"
+#include "efct_io.h"
+#include "efct_xport.h"
+
+#define EFCT_DRIVER_NAME			"efct"
+#define EFCT_DRIVER_VERSION			"1.0.0.0"
+
+/* EFCT_DEFAULT_FILTER-
+ * MRQ filter to segregate the IO flow.
+ */
+#define EFCT_DEFAULT_FILTER			"0x01ff22ff,0,0,0"
+
+/* EFCT_OS_MAX_ISR_TIME_MSEC -
+ * maximum time driver code should spend in an interrupt
+ * or kernel thread context without yielding
+ */
+#define EFCT_OS_MAX_ISR_TIME_MSEC		1000
+
+#define EFCT_FC_MAX_SGL				64
+#define EFCT_FC_DIF_SEED			0
+
+/* Watermark */
+#define EFCT_WATERMARK_HIGH_PCT			90
+#define EFCT_WATERMARK_LOW_PCT			80
+#define EFCT_IO_WATERMARK_PER_INITIATOR		8
+
+#define EFCT_PCI_MAX_REGS			6
+#define MAX_PCI_INTERRUPTS			16
+
+struct efct_intr_context {
+	struct efct		*efct;
+	u32			index;
+};
+
+struct efct {
+	struct pci_dev			*pci;
+	void __iomem			*reg[EFCT_PCI_MAX_REGS];
+
+	u32				n_msix_vec;
+	bool				attached;
+	bool				soft_wwn_enable;
+	u8				efct_req_fw_upgrade;
+	struct efct_intr_context	intr_context[MAX_PCI_INTERRUPTS];
+	u32				numa_node;
+
+	char				name[EFC_NAME_LENGTH];
+	u32				instance_index;
+	struct list_head		list_entry;
+	struct efct_scsi_tgt		tgt_efct;
+	struct efct_xport		*xport;
+	struct efc			*efcport;
+	struct Scsi_Host		*shost;
+	int				logmask;
+	u32				max_isr_time_msec;
+
+	const char			*desc;
+
+	const char			*model;
+
+	struct efct_hw			hw;
+
+	u32				rq_selection_policy;
+	char				*filter_def;
+	int				topology;
+
+	/* Look up for target node */
+	struct xarray			lookup;
+
+	/*
+	 * Target IO timer value:
+	 * Zero: target command timeout disabled.
+	 * Non-zero: Timeout value, in seconds, for target commands
+	 */
+	u32				target_io_timer_sec;
+
+	int				speed;
+	struct dentry			*sess_debugfs_dir;
+};
+
+#define FW_WRITE_BUFSIZE		(64 * 1024)
+
+struct efct_fw_write_result {
+	struct completion done;
+	int status;
+	u32 actual_xfer;
+	u32 change_status;
+};
+
+extern struct list_head			efct_devices;
+
+#endif /* __EFCT_DRIVER_H__ */
diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
new file mode 100644
index 000000000000..e726b9314ab9
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -0,0 +1,1153 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_hw.h"
+#include "efct_unsol.h"
+
+struct efct_mbox_rqst_ctx {
+	int (*callback)(struct efc *efc, int status, u8 *mqe, void *arg);
+	void *arg;
+};
+
+static int
+efct_hw_link_event_init(struct efct_hw *hw)
+{
+	hw->link.status = SLI4_LINK_STATUS_MAX;
+	hw->link.topology = SLI4_LINK_TOPO_NONE;
+	hw->link.medium = SLI4_LINK_MEDIUM_MAX;
+	hw->link.speed = 0;
+	hw->link.loop_map = NULL;
+	hw->link.fc_id = U32_MAX;
+
+	return 0;
+}
+
+static int
+efct_hw_read_max_dump_size(struct efct_hw *hw)
+{
+	u8 buf[SLI4_BMBX_SIZE];
+	struct efct *efct = hw->os;
+	int rc = 0;
+	struct sli4_rsp_cmn_set_dump_location *rsp;
+
+	/* attempt to detemine the dump size for function 0 only. */
+	if (PCI_FUNC(efct->pci->devfn) != 0)
+		return rc;
+
+	if (sli_cmd_common_set_dump_location(&hw->sli, buf, 1, 0, NULL, 0))
+		return -EIO;
+
+	rsp = (struct sli4_rsp_cmn_set_dump_location *)
+	      (buf + offsetof(struct sli4_cmd_sli_config, payload.embed));
+
+	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+	if (rc != 0) {
+		efc_log_debug(hw->os, "set dump location cmd failed\n");
+		return rc;
+	}
+
+	hw->dump_size =
+	  le32_to_cpu(rsp->buffer_length_dword) & SLI4_CMN_SET_DUMP_BUFFER_LEN;
+
+	efc_log_debug(hw->os, "Dump size %x\n",	hw->dump_size);
+
+	return rc;
+}
+
+static int
+__efct_read_topology_cb(struct efct_hw *hw, int status, u8 *mqe, void *arg)
+{
+	struct sli4_cmd_read_topology *read_topo =
+				(struct sli4_cmd_read_topology *)mqe;
+	u8 speed;
+	struct efc_domain_record drec = {0};
+	struct efct *efct = hw->os;
+
+	if (status || le16_to_cpu(read_topo->hdr.status)) {
+		efc_log_debug(hw->os, "bad status cqe=%#x mqe=%#x\n", status,
+			      le16_to_cpu(read_topo->hdr.status));
+		return -EIO;
+	}
+
+	switch (le32_to_cpu(read_topo->dw2_attentype) &
+		SLI4_READTOPO_ATTEN_TYPE) {
+	case SLI4_READ_TOPOLOGY_LINK_UP:
+		hw->link.status = SLI4_LINK_STATUS_UP;
+		break;
+	case SLI4_READ_TOPOLOGY_LINK_DOWN:
+		hw->link.status = SLI4_LINK_STATUS_DOWN;
+		break;
+	case SLI4_READ_TOPOLOGY_LINK_NO_ALPA:
+		hw->link.status = SLI4_LINK_STATUS_NO_ALPA;
+		break;
+	default:
+		hw->link.status = SLI4_LINK_STATUS_MAX;
+		break;
+	}
+
+	switch (read_topo->topology) {
+	case SLI4_READ_TOPO_NON_FC_AL:
+		hw->link.topology = SLI4_LINK_TOPO_NON_FC_AL;
+		break;
+	case SLI4_READ_TOPO_FC_AL:
+		hw->link.topology = SLI4_LINK_TOPO_FC_AL;
+		if (hw->link.status == SLI4_LINK_STATUS_UP)
+			hw->link.loop_map = hw->loop_map.virt;
+		hw->link.fc_id = read_topo->acquired_al_pa;
+		break;
+	default:
+		hw->link.topology = SLI4_LINK_TOPO_MAX;
+		break;
+	}
+
+	hw->link.medium = SLI4_LINK_MEDIUM_FC;
+
+	speed = (le32_to_cpu(read_topo->currlink_state) &
+		 SLI4_READTOPO_LINKSTATE_SPEED) >> 8;
+	switch (speed) {
+	case SLI4_READ_TOPOLOGY_SPEED_1G:
+		hw->link.speed =  1 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_2G:
+		hw->link.speed =  2 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_4G:
+		hw->link.speed =  4 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_8G:
+		hw->link.speed =  8 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_16G:
+		hw->link.speed = 16 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_32G:
+		hw->link.speed = 32 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_64G:
+		hw->link.speed = 64 * 1000;
+		break;
+	case SLI4_READ_TOPOLOGY_SPEED_128G:
+		hw->link.speed = 128 * 1000;
+		break;
+	}
+
+	drec.speed = hw->link.speed;
+	drec.fc_id = hw->link.fc_id;
+	drec.is_nport = true;
+	efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_FOUND, &drec);
+
+	return 0;
+}
+
+static int
+efct_hw_cb_link(void *ctx, void *e)
+{
+	struct efct_hw *hw = ctx;
+	struct sli4_link_event *event = e;
+	struct efc_domain *d = NULL;
+	int rc = 0;
+	struct efct *efct = hw->os;
+
+	efct_hw_link_event_init(hw);
+
+	switch (event->status) {
+	case SLI4_LINK_STATUS_UP:
+
+		hw->link = *event;
+		efct->efcport->link_status = EFC_LINK_STATUS_UP;
+
+		if (event->topology == SLI4_LINK_TOPO_NON_FC_AL) {
+			struct efc_domain_record drec = {0};
+
+			efc_log_info(hw->os, "Link Up, NPORT, speed is %d\n",
+				     event->speed);
+			drec.speed = event->speed;
+			drec.fc_id = event->fc_id;
+			drec.is_nport = true;
+			efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_FOUND,
+				      &drec);
+		} else if (event->topology == SLI4_LINK_TOPO_FC_AL) {
+			u8 buf[SLI4_BMBX_SIZE];
+
+			efc_log_info(hw->os, "Link Up, LOOP, speed is %d\n",
+				     event->speed);
+
+			if (!sli_cmd_read_topology(&hw->sli, buf,
+						   &hw->loop_map)) {
+				rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
+						__efct_read_topology_cb, NULL);
+			}
+
+			if (rc)
+				efc_log_debug(hw->os, "READ_TOPOLOGY failed\n");
+		} else {
+			efc_log_info(hw->os, "%s(%#x), speed is %d\n",
+				     "Link Up, unsupported topology ",
+				     event->topology, event->speed);
+		}
+		break;
+	case SLI4_LINK_STATUS_DOWN:
+		efc_log_info(hw->os, "Link down\n");
+
+		hw->link.status = event->status;
+		efct->efcport->link_status = EFC_LINK_STATUS_DOWN;
+
+		d = efct->efcport->domain;
+		if (d)
+			efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_LOST, d);
+		break;
+	default:
+		efc_log_debug(hw->os, "unhandled link status %#x\n",
+			      event->status);
+		break;
+	}
+
+	return 0;
+}
+
+int
+efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev)
+{
+	u32 i, max_sgl, cpus;
+
+	if (hw->hw_setup_called)
+		return 0;
+
+	/*
+	 * efct_hw_init() relies on NULL pointers indicating that a structure
+	 * needs allocation. If a structure is non-NULL, efct_hw_init() won't
+	 * free/realloc that memory
+	 */
+	memset(hw, 0, sizeof(struct efct_hw));
+
+	hw->hw_setup_called = true;
+
+	hw->os = os;
+
+	mutex_init(&hw->bmbx_lock);
+	spin_lock_init(&hw->cmd_lock);
+	INIT_LIST_HEAD(&hw->cmd_head);
+	INIT_LIST_HEAD(&hw->cmd_pending);
+	hw->cmd_head_count = 0;
+
+	/* Create mailbox command ctx pool */
+	hw->cmd_ctx_pool = mempool_create_kmalloc_pool(EFCT_CMD_CTX_POOL_SZ,
+					sizeof(struct efct_command_ctx));
+	if (!hw->cmd_ctx_pool) {
+		efc_log_err(hw->os, "failed to allocate mailbox buffer pool\n");
+		return -EIO;
+	}
+
+	/* Create mailbox request ctx pool for library callback */
+	hw->mbox_rqst_pool = mempool_create_kmalloc_pool(EFCT_CMD_CTX_POOL_SZ,
+					sizeof(struct efct_mbox_rqst_ctx));
+	if (!hw->mbox_rqst_pool) {
+		efc_log_err(hw->os, "failed to allocate mbox request pool\n");
+		return -EIO;
+	}
+
+	spin_lock_init(&hw->io_lock);
+	INIT_LIST_HEAD(&hw->io_inuse);
+	INIT_LIST_HEAD(&hw->io_free);
+	INIT_LIST_HEAD(&hw->io_wait_free);
+
+	atomic_set(&hw->io_alloc_failed_count, 0);
+
+	hw->config.speed = SLI4_LINK_SPEED_AUTO_16_8_4;
+	if (sli_setup(&hw->sli, hw->os, pdev, ((struct efct *)os)->reg)) {
+		efc_log_err(hw->os, "SLI setup failed\n");
+		return -EIO;
+	}
+
+	efct_hw_link_event_init(hw);
+
+	sli_callback(&hw->sli, SLI4_CB_LINK, efct_hw_cb_link, hw);
+
+	/*
+	 * Set all the queue sizes to the maximum allowed.
+	 */
+	for (i = 0; i < ARRAY_SIZE(hw->num_qentries); i++)
+		hw->num_qentries[i] = hw->sli.qinfo.max_qentries[i];
+	/*
+	 * Adjust the size of the WQs so that the CQ is twice as big as
+	 * the WQ to allow for 2 completions per IO. This allows us to
+	 * handle multi-phase as well as aborts.
+	 */
+	hw->num_qentries[SLI4_QTYPE_WQ] = hw->num_qentries[SLI4_QTYPE_CQ] / 2;
+
+	/*
+	 * The RQ assignment for RQ pair mode.
+	 */
+
+	hw->config.rq_default_buffer_size = EFCT_HW_RQ_SIZE_PAYLOAD;
+	hw->config.n_io = hw->sli.ext[SLI4_RSRC_XRI].size;
+
+	cpus = num_possible_cpus();
+	hw->config.n_eq = cpus > EFCT_HW_MAX_NUM_EQ ? EFCT_HW_MAX_NUM_EQ : cpus;
+
+	max_sgl = sli_get_max_sgl(&hw->sli) - SLI4_SGE_MAX_RESERVED;
+	max_sgl = (max_sgl > EFCT_FC_MAX_SGL) ? EFCT_FC_MAX_SGL : max_sgl;
+	hw->config.n_sgl = max_sgl;
+
+	(void)efct_hw_read_max_dump_size(hw);
+
+	return 0;
+}
+
+static void
+efct_logfcfi(struct efct_hw *hw, u32 j, u32 i, u32 id)
+{
+	efc_log_info(hw->os,
+		     "REG_FCFI: filter[%d] %08X -> RQ[%d] id=%d\n",
+		     j, hw->config.filter_def[j], i, id);
+}
+
+static inline void
+efct_hw_init_free_io(struct efct_hw_io *io)
+{
+	/*
+	 * Set io->done to NULL, to avoid any callbacks, should
+	 * a completion be received for one of these IOs
+	 */
+	io->done = NULL;
+	io->abort_done = NULL;
+	io->status_saved = false;
+	io->abort_in_progress = false;
+	io->type = 0xFFFF;
+	io->wq = NULL;
+}
+
+static u8 efct_hw_iotype_is_originator(u16 io_type)
+{
+	switch (io_type) {
+	case EFCT_HW_FC_CT:
+	case EFCT_HW_ELS_REQ:
+		return 0;
+	default:
+		return -EIO;
+	}
+}
+
+static void
+efct_hw_io_restore_sgl(struct efct_hw *hw, struct efct_hw_io *io)
+{
+	/* Restore the default */
+	io->sgl = &io->def_sgl;
+	io->sgl_count = io->def_sgl_count;
+}
+
+static void
+efct_hw_wq_process_io(void *arg, u8 *cqe, int status)
+{
+	struct efct_hw_io *io = arg;
+	struct efct_hw *hw = io->hw;
+	struct sli4_fc_wcqe *wcqe = (void *)cqe;
+	u32	len = 0;
+	u32 ext = 0;
+
+	/* clear xbusy flag if WCQE[XB] is clear */
+	if (io->xbusy && (wcqe->flags & SLI4_WCQE_XB) == 0)
+		io->xbusy = false;
+
+	/* get extended CQE status */
+	switch (io->type) {
+	case EFCT_HW_BLS_ACC:
+	case EFCT_HW_BLS_RJT:
+		break;
+	case EFCT_HW_ELS_REQ:
+		sli_fc_els_did(&hw->sli, cqe, &ext);
+		len = sli_fc_response_length(&hw->sli, cqe);
+		break;
+	case EFCT_HW_ELS_RSP:
+	case EFCT_HW_FC_CT_RSP:
+		break;
+	case EFCT_HW_FC_CT:
+		len = sli_fc_response_length(&hw->sli, cqe);
+		break;
+	case EFCT_HW_IO_TARGET_WRITE:
+		len = sli_fc_io_length(&hw->sli, cqe);
+		break;
+	case EFCT_HW_IO_TARGET_READ:
+		len = sli_fc_io_length(&hw->sli, cqe);
+		break;
+	case EFCT_HW_IO_TARGET_RSP:
+		break;
+	case EFCT_HW_IO_DNRX_REQUEUE:
+		/* release the count for re-posting the buffer */
+		/* efct_hw_io_free(hw, io); */
+		break;
+	default:
+		efc_log_err(hw->os, "unhandled io type %#x for XRI 0x%x\n",
+			    io->type, io->indicator);
+		break;
+	}
+	if (status) {
+		ext = sli_fc_ext_status(&hw->sli, cqe);
+		/*
+		 * If we're not an originator IO, and XB is set, then issue
+		 * abort for the IO from within the HW
+		 */
+		if ((!efct_hw_iotype_is_originator(io->type)) &&
+		    wcqe->flags & SLI4_WCQE_XB) {
+			int rc;
+
+			efc_log_debug(hw->os, "aborting xri=%#x tag=%#x\n",
+				      io->indicator, io->reqtag);
+
+			/*
+			 * Because targets may send a response when the IO
+			 * completes using the same XRI, we must wait for the
+			 * XRI_ABORTED CQE to issue the IO callback
+			 */
+			rc = efct_hw_io_abort(hw, io, false, NULL, NULL);
+			if (rc == 0) {
+				/*
+				 * latch status to return after abort is
+				 * complete
+				 */
+				io->status_saved = true;
+				io->saved_status = status;
+				io->saved_ext = ext;
+				io->saved_len = len;
+				goto exit_efct_hw_wq_process_io;
+			} else if (rc == -EINPROGRESS) {
+				/*
+				 * Already being aborted by someone else (ABTS
+				 * perhaps). Just return original
+				 * error.
+				 */
+				efc_log_debug(hw->os, "%s%#x tag=%#x\n",
+					      "abort in progress xri=",
+					      io->indicator, io->reqtag);
+
+			} else {
+				/* Failed to abort for some other reason, log
+				 * error
+				 */
+				efc_log_debug(hw->os, "%s%#x tag=%#x rc=%d\n",
+					      "Failed to abort xri=",
+					      io->indicator, io->reqtag, rc);
+			}
+		}
+	}
+
+	if (io->done) {
+		efct_hw_done_t done = io->done;
+
+		io->done = NULL;
+
+		if (io->status_saved) {
+			/* use latched status if exists */
+			status = io->saved_status;
+			len = io->saved_len;
+			ext = io->saved_ext;
+			io->status_saved = false;
+		}
+
+		/* Restore default SGL */
+		efct_hw_io_restore_sgl(hw, io);
+		done(io, len, status, ext, io->arg);
+	}
+
+exit_efct_hw_wq_process_io:
+	return;
+}
+
+static int
+efct_hw_setup_io(struct efct_hw *hw)
+{
+	u32	i = 0;
+	struct efct_hw_io	*io = NULL;
+	uintptr_t	xfer_virt = 0;
+	uintptr_t	xfer_phys = 0;
+	u32	index;
+	bool new_alloc = true;
+	struct efc_dma *dma;
+	struct efct *efct = hw->os;
+
+	if (!hw->io) {
+		hw->io = kmalloc_array(hw->config.n_io, sizeof(io), GFP_KERNEL);
+		if (!hw->io)
+			return -ENOMEM;
+
+		memset(hw->io, 0, hw->config.n_io * sizeof(io));
+
+		for (i = 0; i < hw->config.n_io; i++) {
+			hw->io[i] = kzalloc(sizeof(*io), GFP_KERNEL);
+			if (!hw->io[i])
+				goto error;
+		}
+
+		/* Create WQE buffs for IO */
+		hw->wqe_buffs = kzalloc((hw->config.n_io * hw->sli.wqe_size),
+					GFP_KERNEL);
+		if (!hw->wqe_buffs) {
+			kfree(hw->io);
+			return -ENOMEM;
+		}
+
+	} else {
+		/* re-use existing IOs, including SGLs */
+		new_alloc = false;
+	}
+
+	if (new_alloc) {
+		dma = &hw->xfer_rdy;
+		dma->size = sizeof(struct fcp_txrdy) * hw->config.n_io;
+		dma->virt = dma_alloc_coherent(&efct->pci->dev,
+					       dma->size, &dma->phys, GFP_DMA);
+		if (!dma->virt)
+			return -ENOMEM;
+	}
+	xfer_virt = (uintptr_t)hw->xfer_rdy.virt;
+	xfer_phys = hw->xfer_rdy.phys;
+
+	/* Initialize the pool of HW IO objects */
+	for (i = 0; i < hw->config.n_io; i++) {
+		struct hw_wq_callback *wqcb;
+
+		io = hw->io[i];
+
+		/* initialize IO fields */
+		io->hw = hw;
+
+		/* Assign a WQE buff */
+		io->wqe.wqebuf = &hw->wqe_buffs[i * hw->sli.wqe_size];
+
+		/* Allocate the request tag for this IO */
+		wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_io, io);
+		if (!wqcb) {
+			efc_log_err(hw->os, "can't allocate request tag\n");
+			return -ENOSPC;
+		}
+		io->reqtag = wqcb->instance_index;
+
+		/* Now for the fields that are initialized on each free */
+		efct_hw_init_free_io(io);
+
+		/* The XB flag isn't cleared on IO free, so init to zero */
+		io->xbusy = 0;
+
+		if (sli_resource_alloc(&hw->sli, SLI4_RSRC_XRI,
+				       &io->indicator, &index)) {
+			efc_log_err(hw->os,
+				    "sli_resource_alloc failed @ %d\n", i);
+			return -ENOMEM;
+		}
+
+		if (new_alloc) {
+			dma = &io->def_sgl;
+			dma->size = hw->config.n_sgl *
+					sizeof(struct sli4_sge);
+			dma->virt = dma_alloc_coherent(&efct->pci->dev,
+						       dma->size, &dma->phys,
+						       GFP_DMA);
+			if (!dma->virt) {
+				efc_log_err(hw->os, "dma_alloc fail %d\n", i);
+				memset(&io->def_sgl, 0,
+				       sizeof(struct efc_dma));
+				return -ENOMEM;
+			}
+		}
+		io->def_sgl_count = hw->config.n_sgl;
+		io->sgl = &io->def_sgl;
+		io->sgl_count = io->def_sgl_count;
+
+		if (hw->xfer_rdy.size) {
+			io->xfer_rdy.virt = (void *)xfer_virt;
+			io->xfer_rdy.phys = xfer_phys;
+			io->xfer_rdy.size = sizeof(struct fcp_txrdy);
+
+			xfer_virt += sizeof(struct fcp_txrdy);
+			xfer_phys += sizeof(struct fcp_txrdy);
+		}
+	}
+
+	return 0;
+error:
+	for (i = 0; i < hw->config.n_io && hw->io[i]; i++) {
+		kfree(hw->io[i]);
+		hw->io[i] = NULL;
+	}
+
+	kfree(hw->io);
+	hw->io = NULL;
+
+	return -ENOMEM;
+}
+
+static int
+efct_hw_init_prereg_io(struct efct_hw *hw)
+{
+	u32 i, idx = 0;
+	struct efct_hw_io *io = NULL;
+	u8 cmd[SLI4_BMBX_SIZE];
+	int rc = 0;
+	u32 n_rem;
+	u32 n = 0;
+	u32 sgls_per_request = 256;
+	struct efc_dma **sgls = NULL;
+	struct efc_dma req;
+	struct efct *efct = hw->os;
+
+	sgls = kmalloc_array(sgls_per_request, sizeof(*sgls), GFP_KERNEL);
+	if (!sgls)
+		return -ENOMEM;
+
+	memset(&req, 0, sizeof(struct efc_dma));
+	req.size = 32 + sgls_per_request * 16;
+	req.virt = dma_alloc_coherent(&efct->pci->dev, req.size, &req.phys,
+				      GFP_DMA);
+	if (!req.virt) {
+		kfree(sgls);
+		return -ENOMEM;
+	}
+
+	for (n_rem = hw->config.n_io; n_rem; n_rem -= n) {
+		/* Copy address of SGL's into local sgls[] array, break
+		 * out if the xri is not contiguous.
+		 */
+		u32 min = (sgls_per_request < n_rem) ? sgls_per_request : n_rem;
+
+		for (n = 0; n < min; n++) {
+			/* Check that we have contiguous xri values */
+			if (n > 0) {
+				if (hw->io[idx + n]->indicator !=
+				    hw->io[idx + n - 1]->indicator + 1)
+					break;
+			}
+
+			sgls[n] = hw->io[idx + n]->sgl;
+		}
+
+		if (sli_cmd_post_sgl_pages(&hw->sli, cmd,
+				hw->io[idx]->indicator,	n, sgls, NULL, &req)) {
+			rc = -EIO;
+			break;
+		}
+
+		rc = efct_hw_command(hw, cmd, EFCT_CMD_POLL, NULL, NULL);
+		if (rc) {
+			efc_log_err(hw->os, "SGL post failed, rc=%d\n", rc);
+			break;
+		}
+
+		/* Add to tail if successful */
+		for (i = 0; i < n; i++, idx++) {
+			io = hw->io[idx];
+			io->state = EFCT_HW_IO_STATE_FREE;
+			INIT_LIST_HEAD(&io->list_entry);
+			list_add_tail(&io->list_entry, &hw->io_free);
+		}
+	}
+
+	dma_free_coherent(&efct->pci->dev, req.size, req.virt, req.phys);
+	memset(&req, 0, sizeof(struct efc_dma));
+	kfree(sgls);
+
+	return rc;
+}
+
+static int
+efct_hw_init_io(struct efct_hw *hw)
+{
+	u32 i, idx = 0;
+	bool prereg = false;
+	struct efct_hw_io *io = NULL;
+	int rc = 0;
+
+	prereg = hw->sli.params.sgl_pre_registered;
+
+	if (prereg)
+		return efct_hw_init_prereg_io(hw);
+
+	for (i = 0; i < hw->config.n_io; i++, idx++) {
+		io = hw->io[idx];
+		io->state = EFCT_HW_IO_STATE_FREE;
+		INIT_LIST_HEAD(&io->list_entry);
+		list_add_tail(&io->list_entry, &hw->io_free);
+	}
+
+	return rc;
+}
+
+static int
+efct_hw_config_set_fdt_xfer_hint(struct efct_hw *hw, u32 fdt_xfer_hint)
+{
+	int rc = 0;
+	u8 buf[SLI4_BMBX_SIZE];
+	struct sli4_rqst_cmn_set_features_set_fdt_xfer_hint param;
+
+	memset(&param, 0, sizeof(param));
+	param.fdt_xfer_hint = cpu_to_le32(fdt_xfer_hint);
+	/* build the set_features command */
+	sli_cmd_common_set_features(&hw->sli, buf,
+		SLI4_SET_FEATURES_SET_FTD_XFER_HINT, sizeof(param), &param);
+
+	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+	if (rc)
+		efc_log_warn(hw->os, "set FDT hint %d failed: %d\n",
+			     fdt_xfer_hint, rc);
+	else
+		efc_log_info(hw->os, "Set FTD transfer hint to %d\n",
+			     le32_to_cpu(param.fdt_xfer_hint));
+
+	return rc;
+}
+
+static int
+efct_hw_config_rq(struct efct_hw *hw)
+{
+	u32 min_rq_count, i, rc;
+	struct sli4_cmd_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG];
+	u8 buf[SLI4_BMBX_SIZE];
+
+	efc_log_info(hw->os, "using REG_FCFI standard\n");
+
+	/*
+	 * Set the filter match/mask values from hw's
+	 * filter_def values
+	 */
+	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
+		rq_cfg[i].rq_id = cpu_to_le16(0xffff);
+		rq_cfg[i].r_ctl_mask = (u8)hw->config.filter_def[i];
+		rq_cfg[i].r_ctl_match = (u8)(hw->config.filter_def[i] >> 8);
+		rq_cfg[i].type_mask = (u8)(hw->config.filter_def[i] >> 16);
+		rq_cfg[i].type_match = (u8)(hw->config.filter_def[i] >> 24);
+	}
+
+	/*
+	 * Update the rq_id's of the FCF configuration
+	 * (don't update more than the number of rq_cfg
+	 * elements)
+	 */
+	min_rq_count = (hw->hw_rq_count < SLI4_CMD_REG_FCFI_NUM_RQ_CFG)	?
+			hw->hw_rq_count : SLI4_CMD_REG_FCFI_NUM_RQ_CFG;
+	for (i = 0; i < min_rq_count; i++) {
+		struct hw_rq *rq = hw->hw_rq[i];
+		u32 j;
+
+		for (j = 0; j < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; j++) {
+			u32 mask = (rq->filter_mask != 0) ?
+				rq->filter_mask : 1;
+
+			if (!(mask & (1U << j)))
+				continue;
+
+			rq_cfg[i].rq_id = cpu_to_le16(rq->hdr->id);
+			efct_logfcfi(hw, j, i, rq->hdr->id);
+		}
+	}
+
+	rc = -EIO;
+	if (!sli_cmd_reg_fcfi(&hw->sli, buf, 0,	rq_cfg))
+		rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+
+	if (rc != 0) {
+		efc_log_err(hw->os, "FCFI registration failed\n");
+		return rc;
+	}
+	hw->fcf_indicator =
+		le16_to_cpu(((struct sli4_cmd_reg_fcfi *)buf)->fcfi);
+
+	return rc;
+}
+
+static int
+efct_hw_config_mrq(struct efct_hw *hw, u8 mode, u16 fcf_index)
+{
+	u8 buf[SLI4_BMBX_SIZE], mrq_bitmask = 0;
+	struct hw_rq *rq;
+	struct sli4_cmd_reg_fcfi_mrq *rsp = NULL;
+	struct sli4_cmd_rq_cfg rq_filter[SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG];
+	u32 rc, i;
+
+	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
+		goto issue_cmd;
+
+	/* Set the filter match/mask values from hw's filter_def values */
+	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
+		rq_filter[i].rq_id = cpu_to_le16(0xffff);
+		rq_filter[i].type_mask = (u8)hw->config.filter_def[i];
+		rq_filter[i].type_match = (u8)(hw->config.filter_def[i] >> 8);
+		rq_filter[i].r_ctl_mask = (u8)(hw->config.filter_def[i] >> 16);
+		rq_filter[i].r_ctl_match = (u8)(hw->config.filter_def[i] >> 24);
+	}
+
+	rq = hw->hw_rq[0];
+	rq_filter[0].rq_id = cpu_to_le16(rq->hdr->id);
+	rq_filter[1].rq_id = cpu_to_le16(rq->hdr->id);
+
+	mrq_bitmask = 0x2;
+issue_cmd:
+	efc_log_debug(hw->os, "Issue reg_fcfi_mrq count:%d policy:%d mode:%d\n",
+		      hw->hw_rq_count, hw->config.rq_selection_policy, mode);
+	/* Invoke REG_FCFI_MRQ */
+	rc = sli_cmd_reg_fcfi_mrq(&hw->sli, buf, mode, fcf_index,
+				  hw->config.rq_selection_policy, mrq_bitmask,
+				  hw->hw_mrq_count, rq_filter);
+	if (rc) {
+		efc_log_err(hw->os, "sli_cmd_reg_fcfi_mrq() failed\n");
+		return -EIO;
+	}
+
+	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+
+	rsp = (struct sli4_cmd_reg_fcfi_mrq *)buf;
+
+	if ((rc) || (le16_to_cpu(rsp->hdr.status))) {
+		efc_log_err(hw->os, "FCFI MRQ reg failed. cmd=%x status=%x\n",
+			    rsp->hdr.command, le16_to_cpu(rsp->hdr.status));
+		return -EIO;
+	}
+
+	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
+		hw->fcf_indicator = le16_to_cpu(rsp->fcfi);
+
+	return 0;
+}
+
+static void
+efct_hw_queue_hash_add(struct efct_queue_hash *hash,
+		       u16 id, u16 index)
+{
+	u32 hash_index = id & (EFCT_HW_Q_HASH_SIZE - 1);
+
+	/*
+	 * Since the hash is always bigger than the number of queues, then we
+	 * never have to worry about an infinite loop.
+	 */
+	while (hash[hash_index].in_use)
+		hash_index = (hash_index + 1) & (EFCT_HW_Q_HASH_SIZE - 1);
+
+	/* not used, claim the entry */
+	hash[hash_index].id = id;
+	hash[hash_index].in_use = true;
+	hash[hash_index].index = index;
+}
+
+static int
+efct_hw_config_sli_port_health_check(struct efct_hw *hw, u8 query, u8 enable)
+{
+	int rc = 0;
+	u8 buf[SLI4_BMBX_SIZE];
+	struct sli4_rqst_cmn_set_features_health_check param;
+	u32 health_check_flag = 0;
+
+	memset(&param, 0, sizeof(param));
+
+	if (enable)
+		health_check_flag |= SLI4_RQ_HEALTH_CHECK_ENABLE;
+
+	if (query)
+		health_check_flag |= SLI4_RQ_HEALTH_CHECK_QUERY;
+
+	param.health_check_dword = cpu_to_le32(health_check_flag);
+
+	/* build the set_features command */
+	sli_cmd_common_set_features(&hw->sli, buf,
+		SLI4_SET_FEATURES_SLI_PORT_HEALTH_CHECK, sizeof(param), &param);
+
+	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+	if (rc)
+		efc_log_err(hw->os, "efct_hw_command returns %d\n", rc);
+	else
+		efc_log_debug(hw->os, "SLI Port Health Check is enabled\n");
+
+	return rc;
+}
+
+int
+efct_hw_init(struct efct_hw *hw)
+{
+	int rc;
+	u32 i = 0;
+	int rem_count;
+	unsigned long flags = 0;
+	struct efct_hw_io *temp;
+	struct efc_dma *dma;
+
+	/*
+	 * Make sure the command lists are empty. If this is start-of-day,
+	 * they'll be empty since they were just initialized in efct_hw_setup.
+	 * If we've just gone through a reset, the command and command pending
+	 * lists should have been cleaned up as part of the reset
+	 * (efct_hw_reset()).
+	 */
+	spin_lock_irqsave(&hw->cmd_lock, flags);
+	if (!list_empty(&hw->cmd_head)) {
+		spin_unlock_irqrestore(&hw->cmd_lock, flags);
+		efc_log_err(hw->os, "command found on cmd list\n");
+		return -EIO;
+	}
+	if (!list_empty(&hw->cmd_pending)) {
+		spin_unlock_irqrestore(&hw->cmd_lock, flags);
+		efc_log_err(hw->os, "command found on pending list\n");
+		return -EIO;
+	}
+	spin_unlock_irqrestore(&hw->cmd_lock, flags);
+
+	/* Free RQ buffers if prevously allocated */
+	efct_hw_rx_free(hw);
+
+	/*
+	 * The IO queues must be initialized here for the reset case. The
+	 * efct_hw_init_io() function will re-add the IOs to the free list.
+	 * The cmd_head list should be OK since we free all entries in
+	 * efct_hw_command_cancel() that is called in the efct_hw_reset().
+	 */
+
+	/* If we are in this function due to a reset, there may be stale items
+	 * on lists that need to be removed.  Clean them up.
+	 */
+	rem_count = 0;
+	while ((!list_empty(&hw->io_wait_free))) {
+		rem_count++;
+		temp = list_first_entry(&hw->io_wait_free, struct efct_hw_io,
+					list_entry);
+		list_del_init(&temp->list_entry);
+	}
+	if (rem_count > 0)
+		efc_log_debug(hw->os, "rmvd %d items from io_wait_free list\n",
+			      rem_count);
+
+	rem_count = 0;
+	while ((!list_empty(&hw->io_inuse))) {
+		rem_count++;
+		temp = list_first_entry(&hw->io_inuse, struct efct_hw_io,
+					list_entry);
+		list_del_init(&temp->list_entry);
+	}
+	if (rem_count > 0)
+		efc_log_debug(hw->os, "rmvd %d items from io_inuse list\n",
+			      rem_count);
+
+	rem_count = 0;
+	while ((!list_empty(&hw->io_free))) {
+		rem_count++;
+		temp = list_first_entry(&hw->io_free, struct efct_hw_io,
+					list_entry);
+		list_del_init(&temp->list_entry);
+	}
+	if (rem_count > 0)
+		efc_log_debug(hw->os, "rmvd %d items from io_free list\n",
+			      rem_count);
+
+	/* If MRQ not required, Make sure we dont request feature. */
+	if (hw->config.n_rq == 1)
+		hw->sli.features &= (~SLI4_REQFEAT_MRQP);
+
+	if (sli_init(&hw->sli)) {
+		efc_log_err(hw->os, "SLI failed to initialize\n");
+		return -EIO;
+	}
+
+	if (hw->sliport_healthcheck) {
+		rc = efct_hw_config_sli_port_health_check(hw, 0, 1);
+		if (rc != 0) {
+			efc_log_err(hw->os, "Enable port Health check fail\n");
+			return rc;
+		}
+	}
+
+	/*
+	 * Set FDT transfer hint, only works on Lancer
+	 */
+	if (hw->sli.if_type == SLI4_INTF_IF_TYPE_2) {
+		/*
+		 * Non-fatal error. In particular, we can disregard failure to
+		 * set EFCT_HW_FDT_XFER_HINT on devices with legacy firmware
+		 * that do not support EFCT_HW_FDT_XFER_HINT feature.
+		 */
+		efct_hw_config_set_fdt_xfer_hint(hw, EFCT_HW_FDT_XFER_HINT);
+	}
+
+	/* zero the hashes */
+	memset(hw->cq_hash, 0, sizeof(hw->cq_hash));
+	efc_log_debug(hw->os, "Max CQs %d, hash size = %d\n",
+		      EFCT_HW_MAX_NUM_CQ, EFCT_HW_Q_HASH_SIZE);
+
+	memset(hw->rq_hash, 0, sizeof(hw->rq_hash));
+	efc_log_debug(hw->os, "Max RQs %d, hash size = %d\n",
+		      EFCT_HW_MAX_NUM_RQ, EFCT_HW_Q_HASH_SIZE);
+
+	memset(hw->wq_hash, 0, sizeof(hw->wq_hash));
+	efc_log_debug(hw->os, "Max WQs %d, hash size = %d\n",
+		      EFCT_HW_MAX_NUM_WQ, EFCT_HW_Q_HASH_SIZE);
+
+	rc = efct_hw_init_queues(hw);
+	if (rc)
+		return rc;
+
+	rc = efct_hw_map_wq_cpu(hw);
+	if (rc)
+		return rc;
+
+	/* Allocate and p_st RQ buffers */
+	rc = efct_hw_rx_allocate(hw);
+	if (rc) {
+		efc_log_err(hw->os, "rx_allocate failed\n");
+		return rc;
+	}
+
+	rc = efct_hw_rx_post(hw);
+	if (rc) {
+		efc_log_err(hw->os, "WARNING - error posting RQ buffers\n");
+		return rc;
+	}
+
+	if (hw->config.n_eq == 1) {
+		rc = efct_hw_config_rq(hw);
+		if (rc) {
+			efc_log_err(hw->os, "config rq failed %d\n", rc);
+			return rc;
+		}
+	} else {
+		rc = efct_hw_config_mrq(hw, SLI4_CMD_REG_FCFI_SET_FCFI_MODE, 0);
+		if (rc != 0) {
+			efc_log_err(hw->os, "REG_FCFI_MRQ FCFI reg failed\n");
+			return rc;
+		}
+
+		rc = efct_hw_config_mrq(hw, SLI4_CMD_REG_FCFI_SET_MRQ_MODE, 0);
+		if (rc != 0) {
+			efc_log_err(hw->os, "REG_FCFI_MRQ MRQ reg failed\n");
+			return rc;
+		}
+	}
+
+	/*
+	 * Allocate the WQ request tag pool, if not previously allocated
+	 * (the request tag value is 16 bits, thus the pool allocation size
+	 * of 64k)
+	 */
+	hw->wq_reqtag_pool = efct_hw_reqtag_pool_alloc(hw);
+	if (!hw->wq_reqtag_pool) {
+		efc_log_err(hw->os, "efct_hw_reqtag_init failed %d\n", rc);
+		return rc;
+	}
+
+	rc = efct_hw_setup_io(hw);
+	if (rc) {
+		efc_log_err(hw->os, "IO allocation failure\n");
+		return rc;
+	}
+
+	rc = efct_hw_init_io(hw);
+	if (rc) {
+		efc_log_err(hw->os, "IO initialization failure\n");
+		return rc;
+	}
+
+	dma = &hw->loop_map;
+	dma->size = SLI4_MIN_LOOP_MAP_BYTES;
+	dma->virt = dma_alloc_coherent(&hw->os->pci->dev, dma->size, &dma->phys,
+				       GFP_DMA);
+	if (!dma->virt)
+		return -EIO;
+
+	/*
+	 * Arming the EQ allows (e.g.) interrupts when CQ completions write EQ
+	 * entries
+	 */
+	for (i = 0; i < hw->eq_count; i++)
+		sli_queue_arm(&hw->sli, &hw->eq[i], true);
+
+	/*
+	 * Initialize RQ hash
+	 */
+	for (i = 0; i < hw->rq_count; i++)
+		efct_hw_queue_hash_add(hw->rq_hash, hw->rq[i].id, i);
+
+	/*
+	 * Initialize WQ hash
+	 */
+	for (i = 0; i < hw->wq_count; i++)
+		efct_hw_queue_hash_add(hw->wq_hash, hw->wq[i].id, i);
+
+	/*
+	 * Arming the CQ allows (e.g.) MQ completions to write CQ entries
+	 */
+	for (i = 0; i < hw->cq_count; i++) {
+		efct_hw_queue_hash_add(hw->cq_hash, hw->cq[i].id, i);
+		sli_queue_arm(&hw->sli, &hw->cq[i], true);
+	}
+
+	/* Set RQ process limit*/
+	for (i = 0; i < hw->hw_rq_count; i++) {
+		struct hw_rq *rq = hw->hw_rq[i];
+
+		hw->cq[rq->cq->instance].proc_limit = hw->config.n_io / 2;
+	}
+
+	/* record the fact that the queues are functional */
+	hw->state = EFCT_HW_STATE_ACTIVE;
+	/*
+	 * Allocate a HW IOs for send frame.
+	 */
+	hw->hw_wq[0]->send_frame_io = efct_hw_io_alloc(hw);
+	if (!hw->hw_wq[0]->send_frame_io)
+		efc_log_err(hw->os, "alloc for send_frame_io failed\n");
+
+	/* Initialize send frame sequence id */
+	atomic_set(&hw->send_frame_seq_id, 0);
+
+	return 0;
+}
+
+int
+efct_hw_parse_filter(struct efct_hw *hw, void *value)
+{
+	int rc = 0;
+	char *p = NULL;
+	char *token;
+	u32 idx = 0;
+
+	for (idx = 0; idx < ARRAY_SIZE(hw->config.filter_def); idx++)
+		hw->config.filter_def[idx] = 0;
+
+	p = kstrdup(value, GFP_KERNEL);
+	if (!p || !*p) {
+		efc_log_err(hw->os, "p is NULL\n");
+		return -ENOMEM;
+	}
+
+	idx = 0;
+	while ((token = strsep(&p, ",")) && *token) {
+		if (kstrtou32(token, 0, &hw->config.filter_def[idx++]))
+			efc_log_err(hw->os, "kstrtoint failed\n");
+
+		if (!p || !*p)
+			break;
+
+		if (idx == ARRAY_SIZE(hw->config.filter_def))
+			break;
+	}
+	kfree(p);
+
+	return rc;
+}
+
+u64
+efct_get_wwnn(struct efct_hw *hw)
+{
+	struct sli4 *sli = &hw->sli;
+	u8 p[8];
+
+	memcpy(p, sli->wwnn, sizeof(p));
+	return get_unaligned_be64(p);
+}
+
+u64
+efct_get_wwpn(struct efct_hw *hw)
+{
+	struct sli4 *sli = &hw->sli;
+	u8 p[8];
+
+	memcpy(p, sli->wwpn, sizeof(p));
+	return get_unaligned_be64(p);
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index d5f1d8c05209..6c8ed6a59f5e 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -583,4 +583,19 @@ struct efct_hw_grp_hdr {
 	u8			revision[32];
 };
 
+static inline int
+efct_hw_get_link_speed(struct efct_hw *hw) {
+	return hw->link.speed;
+}
+
+int
+efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev);
+int efct_hw_init(struct efct_hw *hw);
+int
+efct_hw_parse_filter(struct efct_hw *hw, void *value);
+uint64_t
+efct_get_wwnn(struct efct_hw *hw);
+uint64_t
+efct_get_wwpn(struct efct_hw *hw);
+
 #endif /* __EFCT_H__ */
diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
new file mode 100644
index 000000000000..58dad8af9e72
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -0,0 +1,500 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_unsol.h"
+
+static struct dentry *efct_debugfs_root;
+static atomic_t efct_debugfs_count;
+
+static struct scsi_host_template efct_template = {
+	.module			= THIS_MODULE,
+	.name			= EFCT_DRIVER_NAME,
+	.supported_mode		= MODE_TARGET,
+};
+
+/* globals */
+static struct fc_function_template efct_xport_functions;
+static struct fc_function_template efct_vport_functions;
+
+static struct scsi_transport_template *efct_xport_fc_tt;
+static struct scsi_transport_template *efct_vport_fc_tt;
+
+struct efct_xport *
+efct_xport_alloc(struct efct *efct)
+{
+	struct efct_xport *xport;
+
+	xport = kzalloc(sizeof(*xport), GFP_KERNEL);
+	if (!xport)
+		return xport;
+
+	xport->efct = efct;
+	return xport;
+}
+
+static int
+efct_xport_init_debugfs(struct efct *efct)
+{
+	/* Setup efct debugfs root directory */
+	if (!efct_debugfs_root) {
+		efct_debugfs_root = debugfs_create_dir("efct", NULL);
+		atomic_set(&efct_debugfs_count, 0);
+		if (!efct_debugfs_root) {
+			efc_log_err(efct, "failed to create debugfs entry\n");
+			goto debugfs_fail;
+		}
+	}
+
+	/* Create a directory for sessions in root */
+	if (!efct->sess_debugfs_dir) {
+		efct->sess_debugfs_dir = debugfs_create_dir("sessions", NULL);
+		if (!efct->sess_debugfs_dir) {
+			efc_log_err(efct,
+				    "failed to create debugfs entry for sessions\n");
+			goto debugfs_fail;
+		}
+		atomic_inc(&efct_debugfs_count);
+	}
+
+	return 0;
+
+debugfs_fail:
+	return -EIO;
+}
+
+static void efct_xport_delete_debugfs(struct efct *efct)
+{
+	/* Remove session debugfs directory */
+	debugfs_remove(efct->sess_debugfs_dir);
+	efct->sess_debugfs_dir = NULL;
+	atomic_dec(&efct_debugfs_count);
+
+	if (atomic_read(&efct_debugfs_count) == 0) {
+		/* remove root debugfs directory */
+		debugfs_remove(efct_debugfs_root);
+		efct_debugfs_root = NULL;
+	}
+}
+
+int
+efct_xport_attach(struct efct_xport *xport)
+{
+	struct efct *efct = xport->efct;
+	int rc;
+
+	rc = efct_hw_setup(&efct->hw, efct, efct->pci);
+	if (rc) {
+		efc_log_err(efct, "%s: Can't setup hardware\n", efct->desc);
+		return rc;
+	}
+
+	efct_hw_parse_filter(&efct->hw, (void *)efct->filter_def);
+
+	xport->io_pool = efct_io_pool_create(efct, efct->hw.config.n_sgl);
+	if (!xport->io_pool) {
+		efc_log_err(efct, "Can't allocate IO pool\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void
+efct_xport_link_stats_cb(int status, u32 num_counters,
+			 struct efct_hw_link_stat_counts *counters, void *arg)
+{
+	union efct_xport_stats_u *result = arg;
+
+	result->stats.link_stats.link_failure_error_count =
+		counters[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter;
+	result->stats.link_stats.loss_of_sync_error_count =
+		counters[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter;
+	result->stats.link_stats.primitive_sequence_error_count =
+		counters[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter;
+	result->stats.link_stats.invalid_transmission_word_error_count =
+		counters[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter;
+	result->stats.link_stats.crc_error_count =
+		counters[EFCT_HW_LINK_STAT_CRC_COUNT].counter;
+
+	complete(&result->stats.done);
+}
+
+static void
+efct_xport_host_stats_cb(int status, u32 num_counters,
+			 struct efct_hw_host_stat_counts *counters, void *arg)
+{
+	union efct_xport_stats_u *result = arg;
+
+	result->stats.host_stats.transmit_kbyte_count =
+		counters[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter;
+	result->stats.host_stats.receive_kbyte_count =
+		counters[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter;
+	result->stats.host_stats.transmit_frame_count =
+		counters[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter;
+	result->stats.host_stats.receive_frame_count =
+		counters[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter;
+
+	complete(&result->stats.done);
+}
+
+static void
+efct_xport_async_link_stats_cb(int status, u32 num_counters,
+			       struct efct_hw_link_stat_counts *counters,
+			       void *arg)
+{
+	union efct_xport_stats_u *result = arg;
+
+	result->stats.link_stats.link_failure_error_count =
+		counters[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter;
+	result->stats.link_stats.loss_of_sync_error_count =
+		counters[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter;
+	result->stats.link_stats.primitive_sequence_error_count =
+		counters[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter;
+	result->stats.link_stats.invalid_transmission_word_error_count =
+		counters[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter;
+	result->stats.link_stats.crc_error_count =
+		counters[EFCT_HW_LINK_STAT_CRC_COUNT].counter;
+}
+
+static void
+efct_xport_async_host_stats_cb(int status, u32 num_counters,
+			       struct efct_hw_host_stat_counts *counters,
+			       void *arg)
+{
+	union efct_xport_stats_u *result = arg;
+
+	result->stats.host_stats.transmit_kbyte_count =
+		counters[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter;
+	result->stats.host_stats.receive_kbyte_count =
+		counters[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter;
+	result->stats.host_stats.transmit_frame_count =
+		counters[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter;
+	result->stats.host_stats.receive_frame_count =
+		counters[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter;
+}
+
+static void
+efct_xport_config_stats_timer(struct efct *efct);
+
+static void
+efct_xport_stats_timer_cb(struct timer_list *t)
+{
+	struct efct_xport *xport = from_timer(xport, t, stats_timer);
+	struct efct *efct = xport->efct;
+
+	efct_xport_config_stats_timer(efct);
+}
+
+static void
+efct_xport_config_stats_timer(struct efct *efct)
+{
+	u32 timeout = 3 * 1000;
+	struct efct_xport *xport = NULL;
+
+	if (!efct) {
+		pr_err("%s: failed to locate EFCT device\n", __func__);
+		return;
+	}
+
+	xport = efct->xport;
+	efct_hw_get_link_stats(&efct->hw, 0, 0, 0,
+			       efct_xport_async_link_stats_cb,
+			       &xport->fc_xport_stats);
+	efct_hw_get_host_stats(&efct->hw, 0, efct_xport_async_host_stats_cb,
+			       &xport->fc_xport_stats);
+
+	timer_setup(&xport->stats_timer,
+		    &efct_xport_stats_timer_cb, 0);
+	mod_timer(&xport->stats_timer,
+		  jiffies + msecs_to_jiffies(timeout));
+}
+
+int
+efct_xport_initialize(struct efct_xport *xport)
+{
+	struct efct *efct = xport->efct;
+	int rc = 0;
+
+	/* Initialize io lists */
+	spin_lock_init(&xport->io_pending_lock);
+	INIT_LIST_HEAD(&xport->io_pending_list);
+	atomic_set(&xport->io_active_count, 0);
+	atomic_set(&xport->io_pending_count, 0);
+	atomic_set(&xport->io_total_free, 0);
+	atomic_set(&xport->io_total_pending, 0);
+	atomic_set(&xport->io_alloc_failed_count, 0);
+	atomic_set(&xport->io_pending_recursing, 0);
+
+	rc = efct_hw_init(&efct->hw);
+	if (rc) {
+		efc_log_err(efct, "efct_hw_init failure\n");
+		goto out;
+	}
+
+	rc = efct_scsi_tgt_new_device(efct);
+	if (rc) {
+		efc_log_err(efct, "failed to initialize target\n");
+		goto hw_init_out;
+	}
+
+	rc = efct_scsi_new_device(efct);
+	if (rc) {
+		efc_log_err(efct, "failed to initialize initiator\n");
+		goto tgt_dev_out;
+	}
+
+	/* Get FC link and host statistics perodically*/
+	efct_xport_config_stats_timer(efct);
+
+	efct_xport_init_debugfs(efct);
+
+	return rc;
+
+tgt_dev_out:
+	efct_scsi_tgt_del_device(efct);
+
+hw_init_out:
+	efct_hw_teardown(&efct->hw);
+out:
+	return rc;
+}
+
+int
+efct_xport_status(struct efct_xport *xport, enum efct_xport_status cmd,
+		  union efct_xport_stats_u *result)
+{
+	int rc = 0;
+	struct efct *efct = NULL;
+	union efct_xport_stats_u value;
+
+	efct = xport->efct;
+
+	switch (cmd) {
+	case EFCT_XPORT_CONFIG_PORT_STATUS:
+		if (xport->configured_link_state == 0) {
+			/*
+			 * Initial state is offline. configured_link_state is
+			 * set to online explicitly when port is brought online
+			 */
+			xport->configured_link_state = EFCT_XPORT_PORT_OFFLINE;
+		}
+		result->value = xport->configured_link_state;
+		break;
+
+	case EFCT_XPORT_PORT_STATUS:
+		/* Determine port status based on link speed. */
+		value.value = efct_hw_get_link_speed(&efct->hw);
+		if (value.value == 0)
+			result->value = EFCT_XPORT_PORT_OFFLINE;
+		else
+			result->value = EFCT_XPORT_PORT_ONLINE;
+		break;
+
+	case EFCT_XPORT_LINK_SPEED:
+		result->value = efct_hw_get_link_speed(&efct->hw);
+		break;
+
+	case EFCT_XPORT_LINK_STATISTICS:
+		memcpy((void *)result, &efct->xport->fc_xport_stats,
+		       sizeof(union efct_xport_stats_u));
+		break;
+	case EFCT_XPORT_LINK_STAT_RESET: {
+		/* Create a completion to synchronize the stat reset process */
+		init_completion(&result->stats.done);
+
+		/* First reset the link stats */
+		rc = efct_hw_get_link_stats(&efct->hw, 0, 1, 1,
+					    efct_xport_link_stats_cb, result);
+		if (rc)
+			break;
+
+		/* Wait for completion to be signaled when the cmd completes */
+		if (wait_for_completion_interruptible(&result->stats.done)) {
+			/* Undefined failure */
+			efc_log_debug(efct, "sem wait failed\n");
+			rc = -EIO;
+			break;
+		}
+
+		/* Next reset the host stats */
+		rc = efct_hw_get_host_stats(&efct->hw, 1,
+					    efct_xport_host_stats_cb, result);
+
+		if (rc)
+			break;
+
+		/* Wait for completion to be signaled when the cmd completes */
+		if (wait_for_completion_interruptible(&result->stats.done)) {
+			/* Undefined failure */
+			efc_log_debug(efct, "sem wait failed\n");
+			rc = -EIO;
+			break;
+		}
+		break;
+	}
+	default:
+		rc = -EIO;
+		break;
+	}
+
+	return rc;
+}
+
+static int
+efct_get_link_supported_speeds(struct efct *efct)
+{
+	u32 supported_speeds = 0;
+	u32 link_module_type, i;
+	struct {
+		u32 lmt_speed;
+		u32 speed;
+	} supported_speed_list[] = {
+		{SLI4_LINK_MODULE_TYPE_1GB, FC_PORTSPEED_1GBIT},
+		{SLI4_LINK_MODULE_TYPE_2GB, FC_PORTSPEED_2GBIT},
+		{SLI4_LINK_MODULE_TYPE_4GB, FC_PORTSPEED_4GBIT},
+		{SLI4_LINK_MODULE_TYPE_8GB, FC_PORTSPEED_8GBIT},
+		{SLI4_LINK_MODULE_TYPE_16GB, FC_PORTSPEED_16GBIT},
+		{SLI4_LINK_MODULE_TYPE_32GB, FC_PORTSPEED_32GBIT},
+		{SLI4_LINK_MODULE_TYPE_64GB, FC_PORTSPEED_64GBIT},
+		{SLI4_LINK_MODULE_TYPE_128GB, FC_PORTSPEED_128GBIT},
+	};
+
+	link_module_type = sli_get_lmt(&efct->hw.sli);
+
+	/* populate link supported speeds */
+	for (i = 0; i < ARRAY_SIZE(supported_speed_list); i++) {
+		if (link_module_type & supported_speed_list[i].lmt_speed)
+			supported_speeds |= supported_speed_list[i].speed;
+	}
+
+	return supported_speeds;
+}
+
+int
+efct_scsi_new_device(struct efct *efct)
+{
+	struct Scsi_Host *shost = NULL;
+	int error = 0;
+	struct efct_vport *vport = NULL;
+
+	shost = scsi_host_alloc(&efct_template, sizeof(*vport));
+	if (!shost) {
+		efc_log_err(efct, "failed to allocate Scsi_Host struct\n");
+		return -ENOMEM;
+	}
+
+	/* save shost to initiator-client context */
+	efct->shost = shost;
+
+	/* save efct information to shost LLD-specific space */
+	vport = (struct efct_vport *)shost->hostdata;
+	vport->efct = efct;
+
+	/*
+	 * Set initial can_queue value to the max SCSI IOs. This is the maximum
+	 * global queue depth (as opposed to the per-LUN queue depth --
+	 * .cmd_per_lun This may need to be adjusted for I+T mode.
+	 */
+	shost->can_queue = efct->hw.config.n_io;
+	shost->max_cmd_len = 16; /* 16-byte CDBs */
+	shost->max_id = 0xffff;
+	shost->max_lun = 0xffffffff;
+
+	/*
+	 * can only accept (from mid-layer) as many SGEs as we've
+	 * pre-registered
+	 */
+	shost->sg_tablesize = sli_get_max_sgl(&efct->hw.sli);
+
+	/* attach FC Transport template to shost */
+	shost->transportt = efct_xport_fc_tt;
+	efc_log_debug(efct, "transport template=%p\n", efct_xport_fc_tt);
+
+	/* get pci_dev structure and add host to SCSI ML */
+	error = scsi_add_host_with_dma(shost, &efct->pci->dev,
+				       &efct->pci->dev);
+	if (error) {
+		efc_log_debug(efct, "failed scsi_add_host_with_dma\n");
+		return -EIO;
+	}
+
+	/* Set symbolic name for host port */
+	snprintf(fc_host_symbolic_name(shost),
+		 sizeof(fc_host_symbolic_name(shost)),
+		     "Emulex %s FV%s DV%s", efct->model,
+		     efct->hw.sli.fw_name[0], EFCT_DRIVER_VERSION);
+
+	/* Set host port supported classes */
+	fc_host_supported_classes(shost) = FC_COS_CLASS3;
+
+	fc_host_supported_speeds(shost) = efct_get_link_supported_speeds(efct);
+
+	fc_host_node_name(shost) = efct_get_wwnn(&efct->hw);
+	fc_host_port_name(shost) = efct_get_wwpn(&efct->hw);
+	fc_host_max_npiv_vports(shost) = 128;
+
+	return 0;
+}
+
+struct scsi_transport_template *
+efct_attach_fc_transport(void)
+{
+	struct scsi_transport_template *efct_fc_template = NULL;
+
+	efct_fc_template = fc_attach_transport(&efct_xport_functions);
+
+	if (!efct_fc_template)
+		pr_err("failed to attach EFCT with fc transport\n");
+
+	return efct_fc_template;
+}
+
+struct scsi_transport_template *
+efct_attach_vport_fc_transport(void)
+{
+	struct scsi_transport_template *efct_fc_template = NULL;
+
+	efct_fc_template = fc_attach_transport(&efct_vport_functions);
+
+	if (!efct_fc_template)
+		pr_err("failed to attach EFCT with fc transport\n");
+
+	return efct_fc_template;
+}
+
+int
+efct_scsi_reg_fc_transport(void)
+{
+	/* attach to appropriate scsi_tranport_* module */
+	efct_xport_fc_tt = efct_attach_fc_transport();
+	if (!efct_xport_fc_tt) {
+		pr_err("%s: failed to attach to scsi_transport_*", __func__);
+		return -EIO;
+	}
+
+	efct_vport_fc_tt = efct_attach_vport_fc_transport();
+	if (!efct_vport_fc_tt) {
+		pr_err("%s: failed to attach to scsi_transport_*", __func__);
+		efct_release_fc_transport(efct_xport_fc_tt);
+		efct_xport_fc_tt = NULL;
+		return -EIO;
+	}
+
+	return 0;
+}
+
+void
+efct_scsi_release_fc_transport(void)
+{
+	/* detach from scsi_transport_* */
+	efct_release_fc_transport(efct_xport_fc_tt);
+	efct_xport_fc_tt = NULL;
+	if (efct_vport_fc_tt)
+		efct_release_fc_transport(efct_vport_fc_tt);
+
+	efct_vport_fc_tt = NULL;
+}
diff --git a/drivers/scsi/elx/efct/efct_xport.h b/drivers/scsi/elx/efct/efct_xport.h
new file mode 100644
index 000000000000..89f3c20ecb59
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_xport.h
@@ -0,0 +1,186 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_XPORT_H__)
+#define __EFCT_XPORT_H__
+
+enum efct_xport_ctrl {
+	EFCT_XPORT_PORT_ONLINE = 1,
+	EFCT_XPORT_PORT_OFFLINE,
+	EFCT_XPORT_SHUTDOWN,
+	EFCT_XPORT_POST_NODE_EVENT,
+	EFCT_XPORT_WWNN_SET,
+	EFCT_XPORT_WWPN_SET,
+};
+
+enum efct_xport_status {
+	EFCT_XPORT_PORT_STATUS,
+	EFCT_XPORT_CONFIG_PORT_STATUS,
+	EFCT_XPORT_LINK_SPEED,
+	EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+	EFCT_XPORT_LINK_STATISTICS,
+	EFCT_XPORT_LINK_STAT_RESET,
+	EFCT_XPORT_IS_QUIESCED
+};
+
+struct efct_xport_link_stats {
+	bool		rec;
+	bool		gec;
+	bool		w02of;
+	bool		w03of;
+	bool		w04of;
+	bool		w05of;
+	bool		w06of;
+	bool		w07of;
+	bool		w08of;
+	bool		w09of;
+	bool		w10of;
+	bool		w11of;
+	bool		w12of;
+	bool		w13of;
+	bool		w14of;
+	bool		w15of;
+	bool		w16of;
+	bool		w17of;
+	bool		w18of;
+	bool		w19of;
+	bool		w20of;
+	bool		w21of;
+	bool		clrc;
+	bool		clof1;
+	u32		link_failure_error_count;
+	u32		loss_of_sync_error_count;
+	u32		loss_of_signal_error_count;
+	u32		primitive_sequence_error_count;
+	u32		invalid_transmission_word_error_count;
+	u32		crc_error_count;
+	u32		primitive_sequence_event_timeout_count;
+	u32		elastic_buffer_overrun_error_count;
+	u32		arbitration_fc_al_timeout_count;
+	u32		advertised_receive_bufftor_to_buffer_credit;
+	u32		current_receive_buffer_to_buffer_credit;
+	u32		advertised_transmit_buffer_to_buffer_credit;
+	u32		current_transmit_buffer_to_buffer_credit;
+	u32		received_eofa_count;
+	u32		received_eofdti_count;
+	u32		received_eofni_count;
+	u32		received_soff_count;
+	u32		received_dropped_no_aer_count;
+	u32		received_dropped_no_available_rpi_resources_count;
+	u32		received_dropped_no_available_xri_resources_count;
+};
+
+struct efct_xport_host_stats {
+	bool		cc;
+	u32		transmit_kbyte_count;
+	u32		receive_kbyte_count;
+	u32		transmit_frame_count;
+	u32		receive_frame_count;
+	u32		transmit_sequence_count;
+	u32		receive_sequence_count;
+	u32		total_exchanges_originator;
+	u32		total_exchanges_responder;
+	u32		receive_p_bsy_count;
+	u32		receive_f_bsy_count;
+	u32		dropped_frames_due_to_no_rq_buffer_count;
+	u32		empty_rq_timeout_count;
+	u32		dropped_frames_due_to_no_xri_count;
+	u32		empty_xri_pool_count;
+};
+
+struct efct_xport_host_statistics {
+	struct completion		done;
+	struct efct_xport_link_stats	link_stats;
+	struct efct_xport_host_stats	host_stats;
+};
+
+union efct_xport_stats_u {
+	u32	value;
+	struct efct_xport_host_statistics stats;
+};
+
+struct efct_xport_fcp_stats {
+	u64		input_bytes;
+	u64		output_bytes;
+	u64		input_requests;
+	u64		output_requests;
+	u64		control_requests;
+};
+
+struct efct_xport {
+	struct efct		*efct;
+	/* wwpn requested by user for primary nport */
+	u64			req_wwpn;
+	/* wwnn requested by user for primary nport */
+	u64			req_wwnn;
+
+	/* Nodes */
+	/* number of allocated nodes */
+	u32			nodes_count;
+	/* used to track how often IO pool is empty */
+	atomic_t		io_alloc_failed_count;
+	/* array of pointers to nodes */
+	struct efc_node		**nodes;
+
+	/* Io pool and counts */
+	/* pointer to IO pool */
+	struct efct_io_pool	*io_pool;
+	/* lock for io_pending_list */
+	spinlock_t		io_pending_lock;
+	/* list of IOs waiting for HW resources
+	 *  lock: xport->io_pending_lock
+	 *  link: efct_io_s->io_pending_link
+	 */
+	struct list_head	io_pending_list;
+	/* count of totals IOS allocated */
+	atomic_t		io_total_alloc;
+	/* count of totals IOS free'd */
+	atomic_t		io_total_free;
+	/* count of totals IOS that were pended */
+	atomic_t		io_total_pending;
+	/* count of active IOS */
+	atomic_t		io_active_count;
+	/* count of pending IOS */
+	atomic_t		io_pending_count;
+	/* non-zero if efct_scsi_check_pending is executing */
+	atomic_t		io_pending_recursing;
+
+	/* Port */
+	/* requested link state */
+	u32			configured_link_state;
+
+	/* Timer for Statistics */
+	struct timer_list	stats_timer;
+	union efct_xport_stats_u fc_xport_stats;
+	struct efct_xport_fcp_stats fcp_stats;
+};
+
+struct efct_rport_data {
+	struct efc_node		*node;
+};
+
+struct efct_xport *
+efct_xport_alloc(struct efct *efct);
+int
+efct_xport_attach(struct efct_xport *xport);
+int
+efct_xport_initialize(struct efct_xport *xport);
+void
+efct_xport_detach(struct efct_xport *xport);
+int
+efct_xport_control(struct efct_xport *xport, enum efct_xport_ctrl cmd, ...);
+int
+efct_xport_status(struct efct_xport *xport, enum efct_xport_status cmd,
+		  union efct_xport_stats_u *result);
+void
+efct_xport_free(struct efct_xport *xport);
+
+struct scsi_transport_template *efct_attach_fc_transport(void);
+struct scsi_transport_template *efct_attach_vport_fc_transport(void);
+void
+efct_release_fc_transport(struct scsi_transport_template *transport_template);
+
+#endif /* __EFCT_XPORT_H__ */
-- 
2.26.2

