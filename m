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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA58ACA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 836C721906
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 21:56:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sGYY4Q07"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436624AbfJWV4m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 17:56:42 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:36074 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436617AbfJWV4l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 17:56:41 -0400
Received: by mail-wm1-f49.google.com with SMTP id c22so468390wmd.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Oct 2019 14:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=upYOOKTrPqUptmFLcTVCr+aqFA4p8D4eFDLfO1eb0Ls=;
        b=sGYY4Q07ojR1lcLHrJinjr/2jnhoj3pYSJfzOL9PP1S8FO49p98Mdh7nP9oJ7vtDTw
         nRnYOIKsJXD0uG1BuKnA7P42UKkM/QZsKBB1rbJyTV8hAohbj1GJ+fYngobaL6rn9LUh
         y6zpI3Brti4VY3rrAnRGGZBZqPnpto3f+dMrrFMbw6KYS/Kffo7HVrMPCHp5cnvwTlu4
         K1W0G8aQHqn4B3GbXkVem/CxdryIbcPtBXcIryJLcORkxC5PbVVTMaQzXfg1+8fAV7Ex
         BCQxoHekwoRZJ4uQrDm0xDitycW25kvGD+sEt54usGT8BEfzRbl0WnKmPwnFQJBRiFvP
         POhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=upYOOKTrPqUptmFLcTVCr+aqFA4p8D4eFDLfO1eb0Ls=;
        b=EGESvDpuTE/a213oEDGfWxFdWTE8kI0wZd6PwrJpHXwK+JQ9VoiuHOkaoF2w1JCxy3
         CZaw9FAIUcmNm3XNnK5i88Kb5pikO55BL4/IyLY7CK9S/y6LUz8H5xdCTlfkt2X6mzXV
         wRcd8mTIl3wM5hugOte9Bg1dWBCfOD5mtHjZqCuXHRaW2zxjequERe3QBy4JIsvsX9Un
         3rcoMpcSord9AFMqQhkOe5tbwa2+SPrni1esJwboNm3mwXur5SSctG0Ww5d56A+JUetk
         PkiGLoX+55tNc3xClDdAyqn6MH928KQIXxRh3BaG25IaOYbKk1Y0Qc3RrHNYyY+MOo2i
         uBwA==
X-Gm-Message-State: APjAAAX5xfeP1vDtpFRFROAQRgobTJ5V00sN9wFFcvQZWutGU7cHIMBJ
        v1BnFAk1CIWM+CqADzEiZWkCt1Xs
X-Google-Smtp-Source: APXvYqzOAI4k777OCQdXX5mS8GjamMxccKalusR2KGWBDJ0Xr1r1gvNbjMf5UmHafwuRgkfnHCQgTQ==
X-Received: by 2002:a05:600c:23cc:: with SMTP id p12mr1773036wmb.163.1571867793482;
        Wed, 23 Oct 2019 14:56:33 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h17sm796775wme.6.2019.10.23.14.56.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 14:56:32 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: [PATCH 16/32] elx: efct: Driver initialization routines
Date:   Wed, 23 Oct 2019 14:55:41 -0700
Message-Id: <20191023215557.12581-17-jsmart2021@gmail.com>
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
Emulex FC Target driver init, attach and hardware setup routines.

Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/elx/efct/efct_driver.c | 1243 +++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_driver.h |  154 +++++
 drivers/scsi/elx/efct/efct_hw.c     | 1298 +++++++++++++++++++++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h     |   15 +
 drivers/scsi/elx/efct/efct_xport.c  |  665 ++++++++++++++++++
 drivers/scsi/elx/efct/efct_xport.h  |  216 ++++++
 6 files changed, 3591 insertions(+)
 create mode 100644 drivers/scsi/elx/efct/efct_driver.c
 create mode 100644 drivers/scsi/elx/efct/efct_driver.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw.c
 create mode 100644 drivers/scsi/elx/efct/efct_xport.c
 create mode 100644 drivers/scsi/elx/efct/efct_xport.h

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
new file mode 100644
index 000000000000..4928e5753d88
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -0,0 +1,1243 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_utils.h"
+
+#include "efct_els.h"
+#include "efct_hw.h"
+#include "efct_unsol.h"
+#include "efct_scsi.h"
+
+static int efct_proc_open(struct inode *inode, struct file *file);
+static int efct_proc_get(struct seq_file *m, void *v);
+
+static void efct_device_interrupt_handler(struct efct_s *efct, u32 vector);
+static void efct_teardown_msix(struct efct_s *efct);
+static int efct_fw_reset(struct efct_s *efct);
+static int
+efct_firmware_write(struct efct_s *efct, const u8 *buf, size_t buf_len,
+		    u8 *change_status);
+static int
+efct_efclib_config(struct efct_s *efct, struct libefc_function_template *tt);
+
+struct efct_s *efct_devices[MAX_EFCT_DEVICES];
+
+static const struct file_operations efct_proc_fops = {
+	.owner = THIS_MODULE,
+	.open = efct_proc_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int logmask;
+module_param(logmask, int, 0444);
+MODULE_PARM_DESC(logmask, "logging bitmask (default 0)");
+
+#define FW_WRITE_BUFSIZE (64 * 1024)
+struct efct_fw_write_result {
+	struct completion done;
+	int status;
+	u32 actual_xfer;
+	u32 change_status;
+};
+
+struct libefc_function_template efct_libefc_templ = {
+	.hw_domain_alloc = efct_hw_domain_alloc,
+	.hw_domain_attach = efct_hw_domain_attach,
+	.hw_domain_free = efct_hw_domain_free,
+	.hw_domain_force_free = efct_hw_domain_force_free,
+	.domain_hold_frames = efct_domain_hold_frames,
+	.domain_accept_frames = efct_domain_accept_frames,
+
+	.hw_port_alloc = efct_hw_port_alloc,
+	.hw_port_attach = efct_hw_port_attach,
+	.hw_port_free = efct_hw_port_free,
+
+	.hw_node_alloc = efct_hw_node_alloc,
+	.hw_node_attach = efct_hw_node_attach,
+	.hw_node_detach = efct_hw_node_detach,
+	.hw_node_free_resources = efct_hw_node_free_resources,
+	.node_purge_pending = efct_node_purge_pending,
+
+	.scsi_io_alloc_disable = efct_scsi_io_alloc_disable,
+	.scsi_io_alloc_enable = efct_scsi_io_alloc_enable,
+	.scsi_validate_node = efct_scsi_validate_initiator,
+	.new_domain = efct_scsi_tgt_new_domain,
+	.del_domain = efct_scsi_tgt_del_domain,
+	.new_sport = efct_scsi_tgt_new_sport,
+	.del_sport = efct_scsi_tgt_del_sport,
+	.scsi_new_node = efct_scsi_new_initiator,
+	.scsi_del_node = efct_scsi_del_initiator,
+
+	.els_send = efct_els_req_send,
+	.els_send_ct = efct_els_send_ct,
+	.els_send_resp = efct_els_resp_send,
+	.bls_send_acc_hdr = efct_bls_send_acc_hdr,
+	.send_flogi_p2p_acc = efct_send_flogi_p2p_acc,
+	.send_ct_rsp = efct_send_ct_rsp,
+	.send_ls_rjt = efct_send_ls_rjt,
+
+	.node_io_cleanup = efct_node_io_cleanup,
+	.node_els_cleanup = efct_node_els_cleanup,
+	.node_abort_all_els = efct_node_abort_all_els,
+
+	.dispatch_fcp_cmd = efct_dispatch_fcp_cmd,
+	.recv_abts_frame = efct_node_recv_abts_frame,
+};
+
+static char *queue_topology =
+	"eq cq rq cq mq $nulp($nwq(cq wq:ulp=$rpt1)) cq wq:len=256:class=1";
+/**
+ * @brief Perform driver wide initialization
+ *
+ * This function is called prior to enumerating PCI devices, with subsequent
+ * calls to efct_device_attach.  For EFCT, this function invokes the back end
+ * functions efct_scsi_tgt_driver_init(), and efct_scsi_ini_driver_init()
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+int
+efct_device_init(void)
+{
+	int rc;
+
+	hw_global.queue_topology_string = queue_topology;
+
+	/* driver-wide init for target-server */
+	rc = efct_scsi_tgt_driver_init();
+	if (rc) {
+		pr_err("efct_scsi_tgt_init failed rc=%d\n",
+			     rc);
+		return -1;
+	}
+
+	rc = efct_scsi_reg_fc_transport();
+	if (rc) {
+		pr_err("failed to register to FC host\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+/**
+ * @brief Perform driver wide shutdown complete actions
+ *
+ * This function is called shutdown for all devices has completed
+ *
+ * @return none
+ */
+void
+efct_device_shutdown(void)
+{
+	efct_scsi_release_fc_transport();
+
+	efct_scsi_tgt_driver_exit();
+}
+
+/*
+ * @brief allocate efct device
+ *
+ * @param nid Numa node ID
+ *
+ * @return pointer to EFCT structure
+ */
+
+void *efct_device_alloc(u32 nid)
+{
+	struct efct_s *efct = NULL;
+	u32 i;
+
+	efct = kmalloc_node(sizeof(*efct), GFP_ATOMIC, nid);
+
+	if (efct) {
+		memset(efct, 0, sizeof(*efct));
+		for (i = 0; i < ARRAY_SIZE(efct_devices); i++) {
+			if (!efct_devices[i]) {
+				efct->instance_index = i;
+				efct_devices[i] = efct;
+				break;
+			}
+		}
+
+		if (i == ARRAY_SIZE(efct_devices)) {
+			pr_err("Exceeded max supported devices.\n");
+			kfree(efct);
+			efct = NULL;
+		} else {
+			efct->attached = false;
+		}
+	}
+	return efct;
+}
+
+static int
+efct_fw_reset(struct efct_s *efct)
+{
+	int rc = 0;
+	int index = 0;
+	u8 bus, dev;
+	struct efct_s *other_efct;
+
+	bus = efct->pcidev->bus->number;
+	dev = PCI_SLOT(efct->pcidev->devfn);
+
+	while ((other_efct = efct_get_instance(index++)) != NULL) {
+		u8 other_bus, other_dev;
+
+		other_bus = other_efct->pcidev->bus->number;
+		other_dev = PCI_SLOT(other_efct->pcidev->devfn);
+
+		if (bus == other_bus && dev == other_dev &&
+		    timer_pending(&other_efct->xport->stats_timer)) {
+			efc_log_debug(other_efct,
+				       "removing link stats timer\n");
+			del_timer(&other_efct->xport->stats_timer);
+		}
+	}
+
+	if (efct_hw_reset(&efct->hw, EFCT_HW_RESET_FIRMWARE)) {
+		efc_log_test(efct, "failed to reset firmware\n");
+		rc = -1;
+	} else {
+		efc_log_debug(efct,
+			       "successfully reset firmware.Now resetting port\n");
+		/* now flag all functions on the same device
+		 * as this port as uninitialized
+		 */
+		index = 0;
+
+		while ((other_efct = efct_get_instance(index++)) != NULL) {
+			u8 other_bus, other_dev;
+
+			other_bus = other_efct->pcidev->bus->number;
+			other_dev = PCI_SLOT(other_efct->pcidev->devfn);
+
+			if (bus == other_bus && dev == other_dev) {
+				if (other_efct->hw.state !=
+						EFCT_HW_STATE_UNINITIALIZED) {
+					other_efct->hw.state =
+						EFCT_HW_STATE_QUEUES_ALLOCATED;
+				}
+				efct_device_detach(efct);
+				rc = efct_device_attach(efct);
+
+				efc_log_debug(other_efct,
+					       "re-start driver with new firmware\n");
+			}
+		}
+	}
+	return rc;
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
+efct_firmware_write(struct efct_s *efct, const u8 *buf, size_t buf_len,
+		    u8 *change_status)
+{
+	int rc = 0;
+	u32 bytes_left;
+	u32 xfer_size;
+	u32 offset;
+	struct efc_dma_s dma;
+	int last = 0;
+	struct efct_fw_write_result result;
+
+	init_completion(&result.done);
+
+	bytes_left = buf_len;
+	offset = 0;
+
+	dma.size = FW_WRITE_BUFSIZE;
+	dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
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
+	dma_free_coherent(&efct->pcidev->dev, dma.size, dma.virt, dma.phys);
+	return rc;
+}
+
+	int
+efct_request_firmware_update(struct efct_s *efct)
+{
+	int rc = 0;
+	u8 file_name[256], fw_change_status;
+	const struct firmware *fw;
+	struct efct_hw_grp_hdr *fw_image;
+
+	snprintf(file_name, 256, "%s.grp", efct->model);
+	rc = request_firmware(&fw, file_name, &efct->pcidev->dev);
+	if (rc) {
+		efc_log_err(efct, "Firmware file(%s) not found.\n", file_name);
+		return rc;
+	}
+	fw_image = (struct efct_hw_grp_hdr *)fw->data;
+
+	/* Check if firmware provided is compatible with this particular
+	 * Adapter of not
+	 */
+	if ((be32_to_cpu(fw_image->magic_number) != EFCT_HW_OBJECT_G5) &&
+	    (be32_to_cpu(fw_image->magic_number) != EFCT_HW_OBJECT_G6)) {
+		efc_log_warn(efct,
+			      "Invalid FW image found Magic: 0x%x Size: %ld\n",
+			be32_to_cpu(fw_image->magic_number), fw->size);
+		rc = -1;
+		goto exit;
+	}
+
+	if (!strncmp(efct->fw_version, fw_image->revision,
+		     strnlen(fw_image->revision, 16))) {
+		efc_log_debug(efct,
+			       "No update req. Firmware is already up to date.\n");
+		rc = 0;
+		goto exit;
+	}
+	rc = efct_firmware_write(efct, fw->data, fw->size, &fw_change_status);
+	if (rc) {
+		efc_log_err(efct,
+			     "Firmware update failed. Return code = %d\n", rc);
+	} else {
+		efc_log_info(efct, "Firmware updated successfully\n");
+		switch (fw_change_status) {
+		case 0x00:
+			efc_log_debug(efct,
+				       "No reset needed, new firmware is active.\n");
+			break;
+		case 0x01:
+			efc_log_warn(efct,
+				      "A physical device reset (host reboot) is needed to activate the new firmware\n");
+			break;
+		case 0x02:
+		case 0x03:
+			efc_log_debug(efct,
+				       "firmware is resetting to activate the new firmware\n");
+			efct_fw_reset(efct);
+			break;
+		default:
+			efc_log_debug(efct,
+				       "Unexected value change_status: %d\n",
+				fw_change_status);
+			break;
+		}
+	}
+
+exit:
+	release_firmware(fw);
+
+	return rc;
+}
+
+/**
+ * @brief free efct device
+ *
+ * @param efct pointer to efct structure
+ *
+ * @return none
+ */
+
+void efct_device_free(struct efct_s *efct)
+{
+	if (efct) {
+		efct_devices[efct->instance_index] = NULL;
+
+		kfree(efct);
+	}
+}
+
+/**
+ * @brief return the number of interrupts required per HBA
+ *
+ * @param efct pointer to efct structure
+ *
+ * @return the number of interrupts or a negative value on error.
+ */
+int
+efct_device_interrupts_required(struct efct_s *efct)
+{
+	if (efct_hw_setup(&efct->hw, efct, efct->pcidev)
+				!= EFCT_HW_RTN_SUCCESS) {
+		return -1;
+	}
+	return efct_hw_qtop_eq_count(&efct->hw);
+}
+
+static int
+efct_efclib_config(struct efct_s *efct, struct libefc_function_template *tt)
+{
+	struct efc_lport *efc;
+	struct sli4_s	*sli;
+
+	efc = kmalloc(sizeof(*efc), GFP_KERNEL);
+	if (!efc)
+		return -1;
+
+	memset(efc, 0, sizeof(struct efc_lport));
+	efct->efcport = efc;
+
+	memcpy(&efc->tt, tt, sizeof(*tt));
+	efc->base = efct;
+	efc->pcidev = efct->pcidev;
+
+	efc->def_wwnn = efct_get_wwn(&efct->hw, EFCT_HW_WWN_NODE);
+	efc->def_wwpn = efct_get_wwn(&efct->hw, EFCT_HW_WWN_PORT);
+	efc->enable_tgt = 1;
+	efc->log_level = EFC_LOG_LIB;
+
+	sli = &efct->hw.sli;
+	efc->max_xfer_size = sli->sge_supported_length *
+			     sli_get_max_sgl(&efct->hw.sli);
+
+	efcport_init(efc);
+
+	return 0;
+}
+
+/**
+ * @brief Initialize resources when pci devices attach
+ *
+ * @param efct pointer to efct structure
+ *
+ * @return 0 for success, a negative error code value for failure.
+ */
+
+int
+efct_device_attach(struct efct_s *efct)
+{
+	u32 rc = 0, i = 0;
+
+	if (efct->attached) {
+		efc_log_warn(efct, "Device is already attached\n");
+		rc = -1;
+	} else {
+		snprintf(efct->display_name, sizeof(efct->display_name),
+			 "[%s%d] ", "fc",  efct->instance_index);
+
+		efct->logmask = logmask;
+		efct->enable_numa_support = 1;
+		efct->filter_def = "0,0,0,0";
+		efct->max_isr_time_msec = EFCT_OS_MAX_ISR_TIME_MSEC;
+		efct->model =
+			(efct->pcidev->device == EFCT_DEVICE_ID_LPE31004) ?
+			"LPE31004" : "unknown";
+		efct->fw_version = (const char *)efct_hw_get_ptr(&efct->hw,
+							EFCT_HW_FW_REV);
+		efct->driver_version = EFCT_DRIVER_VERSION;
+
+		efct->efct_req_fw_upgrade = true;
+
+		/* Allocate transport object and bring online */
+		efct->xport = efct_xport_alloc(efct);
+		if (!efct->xport) {
+			efc_log_err(efct, "failed to allocate transport object\n");
+			rc = -1;
+		} else if (efct_xport_attach(efct->xport) != 0) {
+			efc_log_err(efct, "failed to attach transport object\n");
+			rc = -1;
+		} else if (efct_xport_initialize(efct->xport) != 0) {
+			efc_log_err(efct, "failed to initialize transport object\n");
+			rc = -1;
+		} else if (efct_efclib_config(efct, &efct_libefc_templ)) {
+			efc_log_err(efct, "failed to init efclib\n");
+			rc = -1;
+		} else if (efct_start_event_processing(efct)) {
+			efc_log_err(efct, "failed to start event processing\n");
+			rc = -1;
+		} else {
+			for (i = 0; i < efct->n_msix_vec; i++) {
+				efc_log_debug(efct, "irq %d enabled\n",
+					efct->msix_vec[i].vector);
+				enable_irq(efct->msix_vec[i].vector);
+			}
+		}
+
+		efct->desc = efct->hw.sli.modeldesc;
+		efc_log_info(efct, "adapter model description: %s\n",
+			      efct->desc);
+
+		if (rc == 0) {
+			efct->attached = true;
+		} else {
+			efct_teardown_msix(efct);
+			if (efct->xport) {
+				efct_xport_free(efct->xport);
+				efct->xport = NULL;
+			}
+		}
+
+		if (efct->efct_req_fw_upgrade) {
+			efc_log_debug(efct, "firmware update is in progress\n");
+			efct_request_firmware_update(efct);
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * @brief interrupt handler
+ *
+ * Interrupt handler
+ *
+ * @param efct pointer to efct structure
+ * @param vector Zero-based interrupt vector number.
+ *
+ * @return none
+ */
+
+static void
+efct_device_interrupt_handler(struct efct_s *efct, u32 vector)
+{
+	efct_hw_process(&efct->hw, vector, efct->max_isr_time_msec);
+}
+
+/**
+ * @brief free resources when pci device detach
+ *
+ * @param efct pointer to efct structure
+ *
+ * @return 0 for success, a negative error code value for failure.
+ */
+
+int
+efct_device_detach(struct efct_s *efct)
+{
+	int rc = 0;
+
+	if (efct) {
+		if (!efct->attached) {
+			efc_log_warn(efct, "Device is not attached\n");
+			return -1;
+		}
+
+		rc = efct_xport_control(efct->xport, EFCT_XPORT_SHUTDOWN);
+		if (rc)
+			efc_log_err(efct, "Transport Shutdown timed out\n");
+
+		efct_stop_event_processing(efct);
+
+		if (efct_xport_detach(efct->xport) != 0)
+			efc_log_err(efct, "Transport detach failed\n");
+
+		efct_xport_free(efct->xport);
+		efct->xport = NULL;
+
+		efcport_destroy(efct->efcport);
+		kfree(efct->efcport);
+
+		efct->attached = false;
+	}
+
+	return 0;
+}
+
+/**
+ * @brief handle MSIX interrupts
+ *
+ * Interrupt entry point for MSIX interrupts.
+ * Simply schedule the interrupt tasklet
+ *
+ * @param irq interrupt request number
+ * @param handle pointer to interrupt context structure
+ *
+ * @return IRQ_HANDLED (always handled)
+ */
+
+static irqreturn_t
+efct_intr_msix(int irq, void *handle)
+{
+	struct efct_os_intr_context_s *intr_context = handle;
+
+	complete(&intr_context->done);
+	return IRQ_HANDLED;
+}
+
+/**
+ * @brief Process interrupt events
+ *
+ * Process events in a kernel thread context.  A counting semaphore is used,
+ * this function waits on the semaphore, the interrupt handler increments it.
+ *
+ * @param thread pointer to the thread object
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+static int
+efct_intr_thread(struct efct_os_intr_context_s *intr_context)
+{
+	struct efct_s *efct = intr_context->efct;
+	int rc;
+	u32 tstart, tnow;
+
+	tstart = jiffies_to_msecs(jiffies);
+
+	while (!kthread_should_stop()) {
+		rc = wait_for_completion_timeout(&intr_context->done,
+				  usecs_to_jiffies(100000));
+		if (!rc)
+			continue;
+
+		efct_device_interrupt_handler(efct, intr_context->index);
+
+		/* If we've been running for too long, then yield */
+		tnow = jiffies_to_msecs(jiffies);
+		if ((tnow - tstart) > 5000) {
+			cond_resched();
+			tstart = tnow;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * @brief setup MSIX interrupts
+ *
+ * Sets up MSIX interrupts.  Currently a single vector is requested and used.
+ *
+ * @param efct pointer to efct structure
+ * @param num_interrupts The number of MSI-X interrupts to acquire
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+static int
+efct_setup_msix(struct efct_s *efct, u32 num_interrupts)
+{
+	int	rc = 0;
+	u32 i;
+
+	if (!pci_find_capability(efct->pcidev, PCI_CAP_ID_MSIX)) {
+		dev_err(&efct->pcidev->dev,
+			"%s : MSI-X not available\n", __func__);
+		return -EINVAL;
+	}
+
+	if (num_interrupts > ARRAY_SIZE(efct->msix_vec)) {
+		dev_err(&efct->pcidev->dev,
+			"%s : num_interrupts: %d greater than vectors\n",
+			__func__, num_interrupts);
+		return -1;
+	}
+
+	efct->n_msix_vec = num_interrupts;
+	for (i = 0; i < num_interrupts; i++)
+		efct->msix_vec[i].entry = i;
+
+	rc = pci_enable_msix_exact(efct->pcidev,
+				   efct->msix_vec, efct->n_msix_vec);
+	if (!rc) {
+		for (i = 0; i < num_interrupts; i++) {
+			rc = request_irq(efct->msix_vec[i].vector,
+					 efct_intr_msix,
+					 0, EFCT_DRIVER_NAME,
+					 &efct->intr_context[i]);
+			if (rc)
+				break;
+		}
+	} else {
+		dev_err(&efct->pcidev->dev,
+			"%s : rc % d returned, IRQ allocation failed\n",
+			   __func__, rc);
+	}
+
+	return rc;
+}
+
+/**
+ * @brief tear down MSIX interrupts
+ *
+ * Previously setup MSIX interrupts are taken down
+ *
+ * @param efct pointer to efct structure
+ *
+ * @return none
+ */
+
+static void
+efct_teardown_msix(struct efct_s *efct)
+{
+	u32 i;
+
+	for (i = 0; i < efct->n_msix_vec; i++) {
+		synchronize_irq(efct->msix_vec[i].vector);
+		free_irq(efct->msix_vec[i].vector,
+			 &efct->intr_context[i]);
+	}
+	pci_disable_msix(efct->pcidev);
+}
+
+static struct pci_device_id efct_pci_table[] = {
+	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_ID_LPE31004), 0},
+	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_ID_G7), 0},
+	{}	/* terminate list */
+};
+
+/**
+ * @brief return pointer to efct structure given instance index
+ *
+ * A pointer to an efct structure is returned given an instance index.
+ *
+ * @param index index to efct_devices array
+ *
+ * @return efct pointer
+ */
+
+struct efct_s *efct_get_instance(u32 index)
+{
+	if (index < ARRAY_SIZE(efct_devices))
+		return efct_devices[index];
+
+	return NULL;
+}
+
+/**
+ * @brief instantiate PCI device
+ *
+ * This is the PCI device probe entry point,
+ * called by the Linux PCI subsystem once for
+ * each matching device/function.
+ *
+ * The efct structure is allocated, and initiatlized
+ *
+ * @param pdev pointer PCI device structure
+ * @param ent poitner to PCI device Id structure
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+static int
+efct_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct efct_s		*efct = NULL;
+	int		rc;
+	u32	i, r;
+	int		num_interrupts = 0;
+	int		nid;				/* Numa node id */
+	struct task_struct	*thread = NULL;
+
+	dev_info(&pdev->dev, "%s\n", EFCT_DRIVER_NAME);
+
+	rc = pci_enable_device_mem(pdev);
+	if (rc)
+		goto efct_pci_probe_err_enable;
+
+	pci_set_master(pdev);
+
+	rc = pci_set_mwi(pdev);
+	if (rc) {
+		dev_info(&pdev->dev,
+			 "pci_set_mwi returned %d\n", rc);
+		goto efct_pci_probe_err_set_mwi;
+	}
+
+	rc = pci_request_regions(pdev, EFCT_DRIVER_NAME);
+	if (rc) {
+		dev_err(&pdev->dev, "pci_request_regions failed\n");
+		goto efct_pci_probe_err_request_regions;
+	}
+
+	/* Fetch the Numa node id for this device */
+	nid = dev_to_node(&pdev->dev);
+	if (nid < 0) {
+		dev_err(&pdev->dev,
+			"Warning Numa node ID is %d\n", nid);
+		nid = 0;
+	}
+
+	/* Allocate efct */
+	efct = efct_device_alloc(nid);
+	if (!efct) {
+		dev_err(&pdev->dev, "Failed to allocate efct_t\n");
+		rc = -ENOMEM;
+		goto efct_pci_probe_err_efct_device_alloc;
+	}
+
+	efct->pcidev = pdev;
+
+	if (efct->enable_numa_support)
+		efct->numa_node = nid;
+
+	/* Map all memory BARs */
+	for (i = 0, r = 0; i < EFCT_PCI_MAX_REGS; i++) {
+		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
+			efct->reg[r] = ioremap(pci_resource_start(pdev, i),
+						  pci_resource_len(pdev, i));
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
+		dev_warn(&pdev->dev,
+			 "trying DMA_BIT_MASK(32)\n");
+		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0 ||
+		    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) {
+			dev_err(&pdev->dev,
+				"setting DMA_BIT_MASK failed\n");
+			rc = -1;
+			goto efct_pci_probe_err_setup_thread;
+		}
+	}
+
+	num_interrupts = efct_device_interrupts_required(efct);
+	if (num_interrupts < 0) {
+		efc_log_err(efct, "efct_device_interrupts_required failed\n");
+		rc = -1;
+		goto efct_pci_probe_err_setup_thread;
+	}
+
+	/*
+	 * Initialize MSIX interrupts, note,
+	 * efct_setup_msix() enables the interrupt
+	 */
+	rc = efct_setup_msix(efct, num_interrupts);
+	if (rc) {
+		dev_err(&pdev->dev, "Can't setup msix\n");
+		goto efct_pci_probe_err_setup_msix;
+	}
+	/* Disable interrupt for now */
+	for (i = 0; i < efct->n_msix_vec; i++) {
+		efc_log_debug(efct, "irq %d disabled\n",
+			       efct->msix_vec[i].vector);
+		disable_irq(efct->msix_vec[i].vector);
+	}
+
+	rc = efct_device_attach((struct efct_s *)efct);
+	if (rc)
+		goto efct_pci_probe_err_setup_msix;
+
+	return 0;
+
+efct_pci_probe_err_setup_msix:
+	for (i = 0; i < (u32)num_interrupts; i++) {
+		thread = efct->intr_context[i].thread;
+		if (!thread)
+			continue;
+
+		/* Call stop */
+		kthread_stop(thread);
+	}
+
+efct_pci_probe_err_setup_thread:
+	pci_set_drvdata(pdev, NULL);
+
+	for (i = 0; i < EFCT_PCI_MAX_REGS; i++) {
+		if (efct->reg[i])
+			iounmap(efct->reg[i]);
+	}
+	efct_device_free(efct);
+efct_pci_probe_err_efct_device_alloc:
+	pci_release_regions(pdev);
+efct_pci_probe_err_request_regions:
+	pci_clear_mwi(pdev);
+efct_pci_probe_err_set_mwi:
+	pci_disable_device(pdev);
+efct_pci_probe_err_enable:
+	return rc;
+}
+
+/**
+ * @brief remove PCI device instance
+ *
+ * Called when driver is unloaded, once for each PCI device/function instance.
+ *
+ * @param pdev pointer to PCI device structure
+ *
+ * @return none
+ */
+
+static void
+efct_pci_remove(struct pci_dev *pdev)
+{
+	struct efct_s *efct = pci_get_drvdata(pdev);
+	u32	i;
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
+	efct_devices[efct->instance_index] = NULL;
+
+	efct_device_free(efct);
+
+	pci_release_regions(pdev);
+
+	pci_disable_device(pdev);
+}
+
+/**
+ * efct_device_prep_dev_for_reset - Prepare EFCT device for pci slot reset
+ * @efct: pointer to EFCT data structure.
+ *
+ * This routine is called to prepare the EFCT device for PCI slot reset. It
+ * disables the device interrupt and pci device, and aborts the internal FCP
+ * pending I/Os
+ */
+static void
+efct_device_prep_for_reset(struct efct_s *efct, struct pci_dev *pdev)
+{
+	if (efct) {
+		efc_log_debug(efct,
+			       "PCI channel disable preparing for reset\n");
+		efct_device_detach(efct);
+		/* Disable interrupt and pci device */
+		efct_teardown_msix(efct);
+	}
+	pci_disable_device(pdev);
+}
+
+/**
+ * efct_device_prep_for_recover - Prepare EFCT device for pci slot recover
+ * @efct: pointer to EFCT hba data structure.
+ *
+ * This routine is called to prepare the SLI4 device for PCI slot recover. It
+ * aborts all the outstanding SCSI I/Os to the pci device.
+ */
+static void
+efct_device_prep_for_recover(struct efct_s *efct)
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
+	struct efct_s *efct = pci_get_drvdata(pdev);
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
+		efc_log_debug(efct, "Unknown PCI error state:0x%x\n",
+			       state);
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
+	struct efct_s *efct = pci_get_drvdata(pdev);
+
+	rc = pci_enable_device_mem(pdev);
+	if (rc) {
+		efc_log_err(efct,
+			     "failed to re-enable PCI device after reset.\n");
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
+	struct efct_s *efct = pci_get_drvdata(pdev);
+
+	/* Perform device reset */
+	efct_device_detach(efct);
+	/* Bring device to online*/
+	efct_device_attach(efct);
+}
+
+/**
+ * @brief Start event processing
+ *
+ * Start up the threads for event processing
+ *
+ * @param efct pointer to EFCT structure
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+int
+efct_start_event_processing(struct efct_s *efct)
+{
+	u32 i;
+
+	for (i = 0; i < efct->n_msix_vec; i++) {
+		char label[32];
+		struct efct_os_intr_context_s *intr_ctx = NULL;
+
+		intr_ctx = &efct->intr_context[i];
+
+		intr_ctx->efct = efct;
+		intr_ctx->index = i;
+
+		init_completion(&intr_ctx->done);
+
+		snprintf(label, sizeof(label),
+			 "efct:%d:%d", efct->instance_index, i);
+
+		intr_ctx->thread =
+			kthread_create((int(*)(void *)) efct_intr_thread,
+				       intr_ctx, label);
+
+		if (IS_ERR(intr_ctx->thread)) {
+			efc_log_err(efct, "kthread_create failed: %ld\n",
+				     PTR_ERR(intr_ctx->thread));
+			intr_ctx->thread = NULL;
+
+			return -1;
+		}
+
+		wake_up_process(intr_ctx->thread);
+	}
+
+	return 0;
+}
+
+/**
+ * @brief Stop event processing
+ *
+ * Interrupts are disabled, and any asynchronous thread (or tasklet) is stopped.
+ *
+ * @param efct pointer to EFCT structure
+ *
+ * @return none
+ */
+
+void
+efct_stop_event_processing(struct efct_s *efct)
+{
+	u32 i;
+	struct task_struct *thread = NULL;
+
+	for (i = 0; i < efct->n_msix_vec; i++) {
+		disable_irq(efct->msix_vec[i].vector);
+
+		thread = efct->intr_context[i].thread;
+		if (!thread)
+			continue;
+
+		/* Call stop */
+		kthread_stop(thread);
+	}
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
+static int efct_proc_open(struct inode *indoe, struct file *file)
+{
+	return single_open(file, efct_proc_get, NULL);
+}
+
+static int efct_proc_get(struct seq_file *m, void *v)
+{
+	u32 i;
+	u32 j;
+	u32 device_count = 0;
+
+	for (i = 0; i < ARRAY_SIZE(efct_devices); i++) {
+		if (efct_devices[i])
+			device_count++;
+	}
+
+	seq_printf(m, "%d\n", device_count);
+
+	for (i = 0; i < ARRAY_SIZE(efct_devices); i++) {
+		if (efct_devices[i]) {
+			struct efct_s *efct = efct_devices[i];
+
+			for (j = 0; j < efct->n_msix_vec; j++) {
+				seq_printf(m, "%d,%d,%d\n", i,
+					   efct->msix_vec[j].vector,
+					-1);
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * @brief driver load entry point
+ *
+ * Called when driver is loaded, device class EFCT_DRIVER_NAME is created, and
+ * PCI devices are enumerated.
+ *
+ * @return returns 0 for success, a negative error code value for failure.
+ */
+
+static
+int __init efct_init(void)
+{
+	int	rc = -ENODEV;
+
+	rc = efct_device_init();
+	if (rc) {
+		pr_err("efct_device_init failed rc=%d\n", rc);
+		return -ENOMEM;
+	}
+
+	rc = pci_register_driver(&efct_pci_driver);
+	if (rc)
+		goto l1;
+
+	proc_create(EFCT_DRIVER_NAME, 0444, NULL, &efct_proc_fops);
+	return rc;
+
+l1:
+	efct_device_shutdown();
+	return rc;
+}
+
+/**
+ * @brief driver unload entry point
+ *
+ * Called when driver is unloaded.
+ * PCI devices are removed, and device class objects
+ * removed.
+ *
+ * @return none
+ */
+
+static void __exit efct_exit(void)
+{
+	pci_unregister_driver(&efct_pci_driver);
+	remove_proc_entry(EFCT_DRIVER_NAME, NULL);
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
index 000000000000..75b4e6fa18a9
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_driver.h
@@ -0,0 +1,154 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
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
+#include <linux/sched/signal.h>
+#include "../include/efc_common.h"
+
+#define EFCT_DRIVER_NAME	"efct"
+#define EFCT_DRIVER_VERSION	"1.0.0.0"
+
+/* EFCT_OS_MAX_ISR_TIME_MSEC -
+ * maximum time driver code should spend in an interrupt
+ * or kernel thread context without yielding
+ */
+#define EFCT_OS_MAX_ISR_TIME_MSEC		1000
+
+#define EFCT_FC_RQ_SIZE_DEFAULT			1024
+#define EFCT_FC_MAX_SGL				64
+#define EFCT_FC_DIF_SEED			0
+
+/* Timeouts */
+#define EFCT_FC_ELS_SEND_DEFAULT_TIMEOUT	0
+#define EFCT_FC_ELS_DEFAULT_RETRIES		3
+#define EFCT_FC_FLOGI_TIMEOUT_SEC		5
+#define EFCT_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC    30000000 /* 30 seconds */
+
+/* Watermark */
+#define EFCT_WATERMARK_HIGH_PCT			90
+#define EFCT_WATERMARK_LOW_PCT			80
+#define EFCT_IO_WATERMARK_PER_INITIATOR		8
+
+#include "efct_utils.h"
+#include "../libefc/efclib.h"
+#include "efct_hw.h"
+#include "efct_io.h"
+#include "efct_xport.h"
+
+#define EFCT_PCI_MAX_REGS   6
+#define MAX_PCI_INTERRUPTS 16
+struct efct_s {
+	struct pci_dev	*pcidev;
+	void __iomem *reg[EFCT_PCI_MAX_REGS];
+
+	struct msix_entry msix_vec[MAX_PCI_INTERRUPTS];
+	u32 n_msix_vec;
+	struct efct_os_intr_context_s intr_context[MAX_PCI_INTERRUPTS];
+	u32 numa_node;
+
+	char display_name[EFC_DISPLAY_NAME_LENGTH];
+	bool attached;
+	struct efct_scsi_tgt_s tgt_efct;
+	struct efct_xport_s *xport;	/* Pointer to transport object */
+	struct efc_lport *efcport;	/* Discovery library object */
+	struct Scsi_Host *shost;	/* Scsi host for fc_host entries*/
+	int ctrlmask;
+	int logmask;
+	u32 max_isr_time_msec;		/* Maximum ISR time */
+
+	const char *desc;
+	u32 instance_index;
+
+	const char *model;
+	const char *driver_version;
+	const char *fw_version;
+
+	struct efct_hw_s hw;
+
+	u32 num_vports;
+	u32 rq_selection_policy;
+	char *filter_def;
+
+	bool soft_wwn_enable;
+
+	/*
+	 * Target IO timer value:
+	 * Zero: target command timeout disabled.
+	 * Non-zero: Timeout value, in seconds, for target commands
+	 */
+	u32 target_io_timer_sec;
+
+	int speed;
+	int topology;
+
+	bool enable_numa_support;	/* NUMA support enabled */
+	u8 efct_req_fw_upgrade;
+	u16 sw_feature_cap;
+	struct dentry *sess_debugfs_dir;
+};
+
+#define MAX_EFCT_DEVICES  64
+extern struct efct_s *efct_devices[MAX_EFCT_DEVICES];
+
+#define efct_is_fc_initiator_enabled()	(efct->enable_ini)
+#define efct_is_fc_target_enabled()	(efct->enable_tgt)
+
+struct efct_s *efct_get_instance(u32 index);
+void efct_stop_event_processing(struct efct_s *efct_os);
+int efct_start_event_processing(struct efct_s *efct_os);
+
+void *efct_device_alloc(u32 nid);
+int efct_device_interrupts_required(struct efct_s *efct);
+int efct_device_attach(struct efct_s *efct);
+int efct_device_detach(struct efct_s *efct);
+void efct_device_free(struct efct_s *efct);
+int efct_device_ioctl(struct efct_s *efct, unsigned int cmd,
+		      unsigned long arg);
+int efct_device_init(void);
+void efct_device_init_complete(void);
+void efct_device_shutdown(void);
+void efct_device_shutdown_complete(void);
+int efct_request_firmware_update(struct efct_s *efct);
+
+#endif /* __EFCT_DRIVER_H__ */
diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
new file mode 100644
index 000000000000..ecb3ccbf7c4c
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -0,0 +1,1298 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_hw.h"
+
+#define EFCT_HW_MQ_DEPTH		128
+#define EFCT_HW_WQ_TIMER_PERIOD_MS	500
+
+#define EFCT_HW_REQUE_XRI_REGTAG	65534
+
+/* HW global data */
+struct efct_hw_global_s hw_global;
+static void
+efct_hw_adjust_wqs(struct efct_hw_s *hw);
+
+/* WQE timeouts */
+static void
+target_wqe_timer_cb(struct timer_list *);
+static void
+shutdown_target_wqe_timer(struct efct_hw_s *hw);
+
+static enum efct_hw_rtn_e
+efct_hw_link_event_init(struct efct_hw_s *hw)
+{
+	hw->link.status = SLI_LINK_STATUS_MAX;
+	hw->link.topology = SLI_LINK_TOPO_NONE;
+	hw->link.medium = SLI_LINK_MEDIUM_MAX;
+	hw->link.speed = 0;
+	hw->link.loop_map = NULL;
+	hw->link.fc_id = U32_MAX;
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+/**
+ * @brief Adjust the number of WQs and CQs within the HW.
+ *
+ * @par Description
+ * Calculates the number of WQs and associated CQs needed in the HW based on
+ * the number of IOs. Calculates the starting CQ index for each WQ, RQ and
+ * MQ.
+ *
+ * @param hw Hardware context allocated by the caller.
+ */
+static void
+efct_hw_adjust_wqs(struct efct_hw_s *hw)
+{
+	u32 max_wq_num = hw->sli.qinfo.max_qcount[SLI_QTYPE_WQ];
+	u32 max_wq_entries = hw->num_qentries[SLI_QTYPE_WQ];
+	u32 max_cq_entries = hw->num_qentries[SLI_QTYPE_CQ];
+
+	/*
+	 * possibly adjust the the size of the WQs so that the CQ is twice as
+	 * big as the WQ to allow for 2 completions per IO. This allows us to
+	 * handle multi-phase as well as aborts.
+	 */
+	if (max_cq_entries < max_wq_entries * 2) {
+		hw->num_qentries[SLI_QTYPE_WQ] = max_cq_entries / 2;
+		max_wq_entries =  hw->num_qentries[SLI_QTYPE_WQ];
+	}
+
+	/*
+	 * Calculate the number of WQs to use base on the number of IOs.
+	 *
+	 * Note: We need to reserve room for aborts which must be sent down
+	 *       the same WQ as the IO. So we allocate enough WQ space to
+	 *       handle 2 times the number of IOs. Half of the space will be
+	 *       used for normal IOs and the other hwf is reserved for aborts.
+	 */
+	hw->config.n_wq = ((hw->config.n_io * 2) + (max_wq_entries - 1))
+			    / max_wq_entries;
+
+	/* make sure we haven't exceeded the max supported in the HW */
+	if (hw->config.n_wq > EFCT_HW_MAX_NUM_WQ)
+		hw->config.n_wq = EFCT_HW_MAX_NUM_WQ;
+
+	/* make sure we haven't exceeded the chip maximum */
+	if (hw->config.n_wq > max_wq_num)
+		hw->config.n_wq = max_wq_num;
+
+}
+
+static inline void
+efct_hw_add_io_timed_wqe(struct efct_hw_s *hw, struct efct_hw_io_s *io)
+{
+	unsigned long flags = 0;
+
+	if (hw->config.emulate_tgt_wqe_timeout && io->tgt_wqe_timeout) {
+		/*
+		 * Active WQE list currently only used for
+		 * target WQE timeouts.
+		 */
+		spin_lock_irqsave(&hw->io_lock, flags);
+		INIT_LIST_HEAD(&io->wqe_link);
+		list_add_tail(&io->wqe_link, &hw->io_timed_wqe);
+		io->submit_ticks = jiffies_64;
+		spin_unlock_irqrestore(&hw->io_lock, flags);
+	}
+}
+
+static inline void
+efct_hw_remove_io_timed_wqe(struct efct_hw_s *hw, struct efct_hw_io_s *io)
+{
+	unsigned long flags = 0;
+
+	if (hw->config.emulate_tgt_wqe_timeout) {
+		/*
+		 * If target wqe timeouts are enabled,
+		 * remove from active wqe list.
+		 */
+		spin_lock_irqsave(&hw->io_lock, flags);
+		if (io->wqe_link.next)
+			list_del(&io->wqe_link);
+		spin_unlock_irqrestore(&hw->io_lock, flags);
+	}
+}
+
+/**
+ * @ingroup devInitShutdown
+ * @brief If this is physical port 0, then read the max dump size.
+ *
+ * @par Description
+ * Queries the FW for the maximum dump size
+ *
+ * @param hw Hardware context allocated by the caller.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+static enum efct_hw_rtn_e
+efct_hw_read_max_dump_size(struct efct_hw_s *hw)
+{
+	u8	buf[SLI4_BMBX_SIZE];
+	u8 func;
+	struct efct_s *efct = hw->os;
+	int	rc = 0;
+
+	/* attempt to detemine the dump size for function 0 only. */
+	func = PCI_FUNC(efct->pcidev->devfn);
+	if (func == 0) {
+		if (!sli_cmd_common_set_dump_location(&hw->sli, buf,
+						     SLI4_BMBX_SIZE, 1, 0,
+						     NULL, 0)) {
+			struct sli4_rsp_cmn_set_dump_location_s *rsp =
+				(struct sli4_rsp_cmn_set_dump_location_s *)
+				(buf + offsetof(struct sli4_cmd_sli_config_s,
+						payload.embed));
+
+			rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL,
+					     NULL);
+			if (rc != EFCT_HW_RTN_SUCCESS) {
+				efc_log_test(hw->os,
+					      "set dump location cmd failed\n");
+				return rc;
+			}
+			hw->dump_size =
+				(le32_to_cpu(rsp->buffer_length_dword) &
+				 RSP_SET_DUMP_BUFFER_LEN);
+			efc_log_debug(hw->os, "Dump size %x\n",
+				       hw->dump_size);
+		}
+	}
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+/**
+ * @ingroup devInitShutdown
+ * @brief Set up the Hardware Abstraction Layer module.
+ *
+ * @par Description
+ * Calls set up to configure the hardware.
+ *
+ * @param hw Hardware context allocated by the caller.
+ * @param os Device abstraction.
+ * @param port_type Protocol type of port, such as FC and NIC.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_setup(struct efct_hw_s *hw, void *os, struct pci_dev *pdev)
+{
+	u32 i;
+	struct sli4_s *sli = &hw->sli;
+
+	if (!hw) {
+		pr_err("bad parameter(s) hw=%p\n", hw);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (hw->hw_setup_called)
+		return EFCT_HW_RTN_SUCCESS;
+
+	/*
+	 * efct_hw_init() relies on NULL pointers indicating that a structure
+	 * needs allocation. If a structure is non-NULL, efct_hw_init() won't
+	 * free/realloc that memory
+	 */
+	memset(hw, 0, sizeof(struct efct_hw_s));
+
+	hw->hw_setup_called = true;
+
+	hw->os = os;
+
+	spin_lock_init(&hw->cmd_lock);
+	INIT_LIST_HEAD(&hw->cmd_head);
+	INIT_LIST_HEAD(&hw->cmd_pending);
+	hw->cmd_head_count = 0;
+
+	spin_lock_init(&hw->io_lock);
+	spin_lock_init(&hw->io_abort_lock);
+
+	atomic_set(&hw->io_alloc_failed_count, 0);
+
+	hw->config.speed = FC_LINK_SPEED_AUTO_16_8_4;
+	hw->config.dif_seed = 0;
+	if (sli_setup(&hw->sli, hw->os, pdev, ((struct efct_s *)os)->reg)) {
+		efc_log_err(hw->os, "SLI setup failed\n");
+		return EFCT_HW_RTN_ERROR;
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
+
+	/*
+	 * The RQ assignment for RQ pair mode.
+	 */
+	hw->config.rq_default_buffer_size = EFCT_HW_RQ_SIZE_PAYLOAD;
+	hw->config.n_io = hw->sli.extent[SLI_RSRC_XRI].size;
+
+	(void)efct_hw_read_max_dump_size(hw);
+
+	/* calculate the number of WQs required. */
+	efct_hw_adjust_wqs(hw);
+
+	/* Set the default dif mode */
+	if (!(sli->features & SLI4_REQFEAT_DIF &&
+	      sli->t10_dif_inline_capable)) {
+		efc_log_test(hw->os,
+			      "not inline capable, setting mode to separate\n");
+		hw->config.dif_mode = EFCT_HW_DIF_MODE_SEPARATE;
+	}
+
+	hw->config.queue_topology = hw_global.queue_topology_string;
+
+	hw->qtop = efct_hw_qtop_parse(hw, hw->config.queue_topology);
+	if (!hw->qtop) {
+		efc_log_crit(hw->os, "Queue topology string is invalid\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	hw->config.n_eq = hw->qtop->entry_counts[QTOP_EQ];
+	hw->config.n_cq = hw->qtop->entry_counts[QTOP_CQ];
+	hw->config.n_rq = hw->qtop->entry_counts[QTOP_RQ];
+	hw->config.n_wq = hw->qtop->entry_counts[QTOP_WQ];
+	hw->config.n_mq = hw->qtop->entry_counts[QTOP_MQ];
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+static void
+efct_logfcfi(struct efct_hw_s *hw, u32 j, u32 i, u32 id)
+{
+	efc_log_info(hw->os,
+		      "REG_FCFI: filter[%d] %08X -> RQ[%d] id=%d\n",
+		     j, hw->config.filter_def[j], i, id);
+}
+
+/**
+ * @ingroup devInitShutdown
+ * @brief Allocate memory structures to prepare for the device operation.
+ *
+ * @par Description
+ * Allocates memory structures needed by the device and prepares the device
+ * for operation.
+ * @n @n @b Note: This function may be called more than once (for example, at
+ * initialization and then after a reset), but the size of the internal
+ * resources may not be changed without tearing down the HW
+ * (efct_hw_teardown()).
+ *
+ * @param hw Hardware context allocated by the caller.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+enum efct_hw_rtn_e
+efct_hw_init(struct efct_hw_s *hw)
+{
+	enum efct_hw_rtn_e	rc;
+	u32	i = 0;
+	u8		buf[SLI4_BMBX_SIZE];
+	u32	max_rpi;
+	int		rem_count;
+	u32	count;
+	unsigned long flags = 0;
+	struct efct_hw_io_s *temp;
+	struct sli4_cmd_rq_cfg_s rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG];
+	struct sli4_s *sli = &hw->sli;
+	struct efct_s *efct = hw->os;
+
+	/*
+	 * Make sure the command lists are empty. If this is start-of-day,
+	 * they'll be empty since they were just initialized in efct_hw_setup.
+	 * If we've just gone through a reset, the command and command pending
+	 * lists should have been cleaned up as part of the reset
+	 * (efct_hw_reset()).
+	 */
+	spin_lock_irqsave(&hw->cmd_lock, flags);
+		if (!list_empty(&hw->cmd_head)) {
+			efc_log_test(hw->os, "command found on cmd list\n");
+			spin_unlock_irqrestore(&hw->cmd_lock, flags);
+			return EFCT_HW_RTN_ERROR;
+		}
+		if (!list_empty(&hw->cmd_pending)) {
+			efc_log_test(hw->os,
+				      "command found on pending list\n");
+			spin_unlock_irqrestore(&hw->cmd_lock, flags);
+			return EFCT_HW_RTN_ERROR;
+		}
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
+	if (hw->io_wait_free.next) {
+		while ((!list_empty(&hw->io_wait_free))) {
+			rem_count++;
+			temp = list_first_entry(&hw->io_wait_free,
+						struct efct_hw_io_s,
+						list_entry);
+			list_del(&temp->list_entry);
+		}
+		if (rem_count > 0) {
+			efc_log_debug(hw->os,
+				       "rmvd %d items from io_wait_free list\n",
+				rem_count);
+		}
+	}
+	rem_count = 0;
+	if (hw->io_inuse.next) {
+		while ((!list_empty(&hw->io_inuse))) {
+			rem_count++;
+			temp = list_first_entry(&hw->io_inuse,
+						struct efct_hw_io_s,
+						list_entry);
+			list_del(&temp->list_entry);
+		}
+		if (rem_count > 0)
+			efc_log_debug(hw->os,
+				       "rmvd %d items from io_inuse list\n",
+				       rem_count);
+	}
+	rem_count = 0;
+	if (hw->io_free.next) {
+		while ((!list_empty(&hw->io_free))) {
+			rem_count++;
+			temp = list_first_entry(&hw->io_free,
+						struct efct_hw_io_s,
+						list_entry);
+			list_del(&temp->list_entry);
+		}
+		if (rem_count > 0)
+			efc_log_debug(hw->os,
+				       "rmvd %d items from io_free list\n",
+				       rem_count);
+	}
+
+	INIT_LIST_HEAD(&hw->io_inuse);
+	INIT_LIST_HEAD(&hw->io_free);
+	INIT_LIST_HEAD(&hw->io_wait_free);
+	INIT_LIST_HEAD(&hw->io_timed_wqe);
+
+	/* If MRQ not required, Make sure we dont request feature. */
+	if (hw->config.n_rq == 1)
+		hw->sli.features &= (~SLI4_REQFEAT_MRQP);
+
+	if (sli_init(&hw->sli)) {
+		efc_log_err(hw->os, "SLI failed to initialize\n");
+		return EFCT_HW_RTN_ERROR;
+	}
+	if (hw->sliport_healthcheck) {
+		rc = efct_hw_config_sli_port_health_check(hw, 0, 1);
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			efc_log_err(hw->os, "Enable port Health check fail\n");
+			return rc;
+		}
+	}
+
+	/*
+	 * Set FDT transfer hint, only works on Lancer
+	 */
+	if (hw->sli.if_type == SLI4_INTF_IF_TYPE_2 &&
+	    EFCT_HW_FDT_XFER_HINT != 0) {
+		/*
+		 * Non-fatal error. In particular, we can disregard failure to
+		 * set EFCT_HW_FDT_XFER_HINT on devices with legacy firmware
+		 * that do not support EFCT_HW_FDT_XFER_HINT feature.
+		 */
+		efct_hw_config_set_fdt_xfer_hint(hw, EFCT_HW_FDT_XFER_HINT);
+	}
+
+	/*
+	 * Verify that we have not exceeded any queue sizes
+	 */
+	if (hw->config.n_eq > sli->qinfo.max_qcount[SLI_QTYPE_EQ]) {
+		efc_log_err(hw->os, "requested %d EQ but %d allowed\n",
+			     hw->config.n_eq,
+			sli->qinfo.max_qcount[SLI_QTYPE_EQ]);
+		return EFCT_HW_RTN_ERROR;
+	}
+	if (hw->config.n_cq > sli->qinfo.max_qcount[SLI_QTYPE_CQ]) {
+		efc_log_err(hw->os, "requested %d CQ but %d allowed\n",
+			     hw->config.n_cq,
+			sli->qinfo.max_qcount[SLI_QTYPE_CQ]);
+		return EFCT_HW_RTN_ERROR;
+	}
+	if (hw->config.n_mq > sli->qinfo.max_qcount[SLI_QTYPE_MQ]) {
+		efc_log_err(hw->os, "requested %d MQ but %d allowed\n",
+			     hw->config.n_mq,
+			sli->qinfo.max_qcount[SLI_QTYPE_MQ]);
+		return EFCT_HW_RTN_ERROR;
+	}
+	if (hw->config.n_rq > sli->qinfo.max_qcount[SLI_QTYPE_RQ]) {
+		efc_log_err(hw->os, "requested %d RQ but %d allowed\n",
+			     hw->config.n_rq,
+			sli->qinfo.max_qcount[SLI_QTYPE_RQ]);
+		return EFCT_HW_RTN_ERROR;
+	}
+	if (hw->config.n_wq > sli->qinfo.max_qcount[SLI_QTYPE_WQ]) {
+		efc_log_err(hw->os, "requested %d WQ but %d allowed\n",
+			     hw->config.n_wq,
+			sli->qinfo.max_qcount[SLI_QTYPE_WQ]);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	/* zero the hashes */
+	memset(hw->cq_hash, 0, sizeof(hw->cq_hash));
+	efc_log_debug(hw->os, "Max CQs %d, hash size = %d\n",
+		       EFCT_HW_MAX_NUM_CQ, EFCT_HW_Q_HASH_SIZE);
+
+	memset(hw->rq_hash, 0, sizeof(hw->rq_hash));
+	efc_log_debug(hw->os, "Max RQs %d, hash size = %d\n",
+		       EFCT_HW_MAX_NUM_RQ, EFCT_HW_Q_HASH_SIZE);
+
+	memset(hw->wq_hash, 0, sizeof(hw->wq_hash));
+	efc_log_debug(hw->os, "Max WQs %d, hash size = %d\n",
+		       EFCT_HW_MAX_NUM_WQ, EFCT_HW_Q_HASH_SIZE);
+
+	rc = efct_hw_init_queues(hw, hw->qtop);
+	if (rc != EFCT_HW_RTN_SUCCESS)
+		return rc;
+
+	max_rpi = sli->extent[SLI_RSRC_RPI].size;
+	i = sli_fc_get_rpi_requirements(&hw->sli, max_rpi);
+	if (i) {
+		struct efc_dma_s payload_memory;
+
+		rc = EFCT_HW_RTN_ERROR;
+
+		if (hw->rnode_mem.size) {
+			dma_free_coherent(&efct->pcidev->dev,
+					  hw->rnode_mem.size,
+					  hw->rnode_mem.virt,
+					  hw->rnode_mem.phys);
+			memset(&hw->rnode_mem, 0, sizeof(struct efc_dma_s));
+		}
+
+		hw->rnode_mem.size = i;
+		hw->rnode_mem.virt = dma_alloc_coherent(&efct->pcidev->dev,
+							hw->rnode_mem.size,
+							&hw->rnode_mem.phys,
+							GFP_DMA);
+		if (!hw->rnode_mem.virt) {
+			efc_log_err(hw->os,
+				     "remote node memory allocation fail\n");
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+
+		payload_memory.size = 0;
+		if (!sli_cmd_post_hdr_templates(&hw->sli, buf,
+					       SLI4_BMBX_SIZE,
+						    &hw->rnode_mem,
+						    U16_MAX,
+						    &payload_memory)) {
+			rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL,
+					     NULL);
+
+			if (payload_memory.size != 0) {
+				/*
+				 * The command was non-embedded - need to
+				 * free the dma buffer
+				 */
+				dma_free_coherent(&efct->pcidev->dev,
+						  payload_memory.size,
+						  payload_memory.virt,
+						  payload_memory.phys);
+				memset(&payload_memory, 0,
+				       sizeof(struct efc_dma_s));
+			}
+		}
+
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			efc_log_err(hw->os,
+				     "header template registration failed\n");
+			return rc;
+		}
+	}
+
+	/* Allocate and post RQ buffers */
+	rc = efct_hw_rx_allocate(hw);
+	if (rc) {
+		efc_log_err(hw->os, "rx_allocate failed\n");
+		return rc;
+	}
+
+	/* Populate hw->seq_free_list */
+	if (!hw->seq_pool) {
+		u32 count = 0;
+		u32 i;
+
+		/*
+		 * Sum up the total number of RQ entries, to use to allocate
+		 * the sequence object pool
+		 */
+		for (i = 0; i < hw->hw_rq_count; i++)
+			count += hw->hw_rq[i]->entry_count;
+
+		hw->seq_pool = efct_array_alloc(hw->os,
+					sizeof(struct efc_hw_sequence_s),
+						count);
+		if (!hw->seq_pool) {
+			efc_log_err(hw->os, "malloc seq_pool failed\n");
+			return EFCT_HW_RTN_NO_MEMORY;
+		}
+	}
+
+	if (efct_hw_rx_post(hw))
+		efc_log_err(hw->os, "WARNING - error posting RQ buffers\n");
+
+	/* Allocate rpi_ref if not previously allocated */
+	if (!hw->rpi_ref) {
+		hw->rpi_ref = kmalloc_array(max_rpi, sizeof(*hw->rpi_ref),
+				      GFP_KERNEL);
+		if (!hw->rpi_ref)
+			return EFCT_HW_RTN_NO_MEMORY;
+
+		memset(hw->rpi_ref, 0, max_rpi * sizeof(*hw->rpi_ref));
+	}
+
+	for (i = 0; i < max_rpi; i++) {
+		atomic_set(&hw->rpi_ref[i].rpi_count, 0);
+		atomic_set(&hw->rpi_ref[i].rpi_attached, 0);
+	}
+
+	/*
+	 * Register a FCFI to allow unsolicited frames to be routed to the
+	 * driver
+	 */
+	if (hw->hw_mrq_count) {
+		efc_log_info(hw->os, "using REG_FCFI MRQ\n");
+
+		rc = efct_hw_config_mrq(hw,
+					SLI4_CMD_REG_FCFI_SET_FCFI_MODE,
+				0);
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			efc_log_err(hw->os,
+				     "REG_FCFI_MRQ FCFI reg failed\n");
+			return rc;
+		}
+
+		rc = efct_hw_config_mrq(hw,
+					SLI4_CMD_REG_FCFI_SET_MRQ_MODE,
+					0);
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			efc_log_err(hw->os,
+				     "REG_FCFI_MRQ MRQ reg failed\n");
+			return rc;
+		}
+	} else {
+		u32 min_rq_count;
+
+		efc_log_info(hw->os, "using REG_FCFI standard\n");
+
+		/*
+		 * Set the filter match/mask values from hw's
+		 * filter_def values
+		 */
+		for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
+			rq_cfg[i].rq_id = 0xffff;
+			rq_cfg[i].r_ctl_mask = (u8)
+					hw->config.filter_def[i];
+			rq_cfg[i].r_ctl_match = (u8)
+					(hw->config.filter_def[i] >>
+					 8);
+			rq_cfg[i].type_mask = (u8)
+					 (hw->config.filter_def[i] >>
+					  16);
+			rq_cfg[i].type_match = (u8)
+					 (hw->config.filter_def[i] >>
+					  24);
+		}
+
+		/*
+		 * Update the rq_id's of the FCF configuration
+		 * (don't update more than the number of rq_cfg
+		 * elements)
+		 */
+		min_rq_count = (hw->hw_rq_count <
+				SLI4_CMD_REG_FCFI_NUM_RQ_CFG)
+				? hw->hw_rq_count :
+				SLI4_CMD_REG_FCFI_NUM_RQ_CFG;
+		for (i = 0; i < min_rq_count; i++) {
+			struct hw_rq_s *rq = hw->hw_rq[i];
+			u32 j;
+
+			for (j = 0; j < SLI4_CMD_REG_FCFI_NUM_RQ_CFG;
+			     j++) {
+				u32 mask = (rq->filter_mask != 0) ?
+						 rq->filter_mask : 1;
+
+				if (mask & (1U << j)) {
+					rq_cfg[j].rq_id = rq->hdr->id;
+					efct_logfcfi(hw, j, i,
+						     rq->hdr->id);
+				}
+			}
+		}
+
+		rc = EFCT_HW_RTN_ERROR;
+		if (!sli_cmd_reg_fcfi(&hw->sli, buf,
+				     SLI4_BMBX_SIZE, 0,
+					  rq_cfg)) {
+			rc = efct_hw_command(hw, buf, EFCT_CMD_POLL,
+					     NULL, NULL);
+		}
+
+		if (rc != EFCT_HW_RTN_SUCCESS) {
+			efc_log_err(hw->os,
+				     "FCFI registration failed\n");
+			return rc;
+		}
+		hw->fcf_indicator =
+		le16_to_cpu(((struct sli4_cmd_reg_fcfi_s *)buf)->fcfi);
+	}
+
+	/*
+	 * Allocate the WQ request tag pool, if not previously allocated
+	 * (the request tag value is 16 bits, thus the pool allocation size
+	 * of 64k)
+	 */
+	rc = efct_hw_reqtag_init(hw);
+	if (rc) {
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
+	/* Set the DIF seed - only for lancer right now */
+	if (sli->if_type == SLI4_INTF_IF_TYPE_2 &&
+	    efct_hw_set_dif_seed(hw) != EFCT_HW_RTN_SUCCESS) {
+		efc_log_err(hw->os, "Failed to set DIF seed value\n");
+		return rc;
+	}
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
+	/* record the fact that the queues are functional */
+	hw->state = EFCT_HW_STATE_ACTIVE;
+
+	/* finally kick off periodic timer to check for timed out target WQEs */
+	if (hw->config.emulate_tgt_wqe_timeout) {
+		timer_setup(&hw->wqe_timer, &target_wqe_timer_cb, 0);
+
+		mod_timer(&hw->wqe_timer, jiffies +
+			  msecs_to_jiffies(EFCT_HW_WQ_TIMER_PERIOD_MS));
+	}
+	/*
+	 * Allocate a HW IOs for send frame.  Allocate one for each Class 1
+	 * WQ, or if there are none of those, allocate one for WQ[0]
+	 */
+	count = efct_varray_get_count(hw->wq_class_array[1]);
+	if (count > 0) {
+		struct hw_wq_s *wq;
+
+		for (i = 0; i < count; i++) {
+			wq = efct_varray_iter_next(hw->wq_class_array[1]);
+			wq->send_frame_io = efct_hw_io_alloc(hw);
+			if (!wq->send_frame_io)
+				efc_log_err(hw->os,
+					     "alloc for send_frame_io failed\n");
+		}
+	} else {
+		hw->hw_wq[0]->send_frame_io = efct_hw_io_alloc(hw);
+		if (!hw->hw_wq[0]->send_frame_io)
+			efc_log_err(hw->os,
+				     "alloc for send_frame_io failed\n");
+	}
+
+	/* Initialize send frame frame sequence id */
+	atomic_set(&hw->send_frame_seq_id, 0);
+
+	/* Initialize watchdog timer if enabled by user */
+	if (hw->watchdog_timeout) {
+		if (hw->watchdog_timeout < 1 ||
+		    hw->watchdog_timeout > 65534)
+			efc_log_err(hw->os,
+				     "WDT out of range: range is 1 - 65534\n");
+		else if (!efct_hw_config_watchdog_timer(hw))
+			efc_log_info(hw->os,
+				      "WDT timer config with tmo = %d secs\n",
+				     hw->watchdog_timeout);
+	}
+
+	return EFCT_HW_RTN_SUCCESS;
+}
+
+/**
+ * @brief Configure Multi-RQ
+ *
+ * @param hw       Hardware context allocated by the caller.
+ * @param mode      1 to set MRQ filters and 0 to set FCFI index
+ * @param fcf_index valid in mode 0
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+static int
+efct_hw_config_mrq(struct efct_hw_s *hw, u8 mode, u16 fcf_index)
+{
+	u8 buf[SLI4_BMBX_SIZE], mrq_bitmask = 0;
+	struct hw_rq_s *rq;
+	struct sli4_cmd_reg_fcfi_mrq_s *rsp = NULL;
+	u32 i, j;
+	struct sli4_cmd_rq_cfg_s rq_filter[SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG];
+	int rc;
+
+	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
+		goto issue_cmd;
+
+	/* Set the filter match/mask values from hw's filter_def values */
+	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
+		rq_filter[i].rq_id = 0xffff;
+		rq_filter[i].r_ctl_mask  = (u8)
+					    hw->config.filter_def[i];
+		rq_filter[i].r_ctl_match = (u8)
+					    (hw->config.filter_def[i] >> 8);
+		rq_filter[i].type_mask   = (u8)
+					    (hw->config.filter_def[i] >> 16);
+		rq_filter[i].type_match  = (u8)
+					    (hw->config.filter_def[i] >> 24);
+	}
+
+	/* Accumulate counts for each filter type used, build rq_ids[] list */
+	for (i = 0; i < hw->hw_rq_count; i++) {
+		rq = hw->hw_rq[i];
+		for (j = 0; j < SLI4_CMD_REG_FCFI_MRQ_NUM_RQ_CFG; j++) {
+			if (rq->filter_mask & (1U << j)) {
+				if (rq_filter[j].rq_id != 0xffff) {
+					/*
+					 * Already used. Bailout ifts not RQset
+					 * case
+					 */
+					if (!rq->is_mrq ||
+					    rq_filter[j].rq_id !=
+					     rq->base_mrq_id) {
+						efc_log_err(hw->os,
+							     "Wrong q top.\n");
+						return EFCT_HW_RTN_ERROR;
+					}
+					continue;
+				}
+
+				if (rq->is_mrq) {
+					rq_filter[j].rq_id = rq->base_mrq_id;
+					mrq_bitmask |= (1U << j);
+				} else {
+					rq_filter[j].rq_id = rq->hdr->id;
+				}
+			}
+		}
+	}
+
+issue_cmd:
+	/* Invoke REG_FCFI_MRQ */
+	rc = sli_cmd_reg_fcfi_mrq(&hw->sli,
+				  buf,	/* buf */
+				 SLI4_BMBX_SIZE, /* size */
+				 mode, /* mode 1 */
+				 fcf_index, /* fcf_index */
+				 /* RQ selection policy*/
+				 hw->config.rq_selection_policy,
+				 mrq_bitmask, /* MRQ bitmask */
+				 hw->hw_mrq_count, /* num_mrqs */
+				 rq_filter);/* RQ filter */
+	if (rc) {
+		efc_log_err(hw->os,
+			     "sli_cmd_reg_fcfi_mrq() failed: %d\n", rc);
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
+
+	rsp = (struct sli4_cmd_reg_fcfi_mrq_s *)buf;
+
+	if (rc != EFCT_HW_RTN_SUCCESS ||
+	    le16_to_cpu(rsp->hdr.status)) {
+		efc_log_err(hw->os,
+			     "FCFI MRQ reg failed. cmd = %x status = %x\n",
+			     rsp->hdr.command,
+			     le16_to_cpu(rsp->hdr.status));
+		return EFCT_HW_RTN_ERROR;
+	}
+
+	if (mode == SLI4_CMD_REG_FCFI_SET_FCFI_MODE)
+		hw->fcf_indicator = le16_to_cpu(rsp->fcfi);
+	return 0;
+}
+
+enum efct_hw_rtn_e
+efct_hw_set(struct efct_hw_s *hw, enum efct_hw_property_e prop, u32 value)
+{
+	enum efct_hw_rtn_e		rc = EFCT_HW_RTN_SUCCESS;
+	struct sli4_s *sli = &hw->sli;
+
+	switch (prop) {
+	case EFCT_HW_N_IO:
+		if (value > sli->extent[SLI_RSRC_XRI].size ||
+		    value == 0) {
+			efc_log_test(hw->os,
+				      "IO value out of range %d vs %d\n",
+				     value,
+				sli->extent[SLI_RSRC_XRI].size);
+			rc = EFCT_HW_RTN_ERROR;
+		} else {
+			hw->config.n_io = value;
+		}
+		break;
+	case EFCT_HW_N_SGL:
+		value += SLI4_SGE_MAX_RESERVED;
+		if (value > sli_get_max_sgl(&hw->sli)) {
+			efc_log_test(hw->os,
+				      "SGL value out of range %d vs %d\n",
+				     value, sli_get_max_sgl(&hw->sli));
+			rc = EFCT_HW_RTN_ERROR;
+		} else {
+			hw->config.n_sgl = value;
+		}
+		break;
+	case EFCT_HW_TOPOLOGY:
+		switch (value) {
+		case EFCT_HW_TOPOLOGY_AUTO:
+			sli_set_topology(&hw->sli,
+					 SLI4_READ_CFG_TOPO_FC);
+			break;
+		case EFCT_HW_TOPOLOGY_NPORT:
+			sli_set_topology(&hw->sli, SLI4_READ_CFG_TOPO_FC_DA);
+			break;
+		case EFCT_HW_TOPOLOGY_LOOP:
+			sli_set_topology(&hw->sli, SLI4_READ_CFG_TOPO_FC_AL);
+			break;
+		default:
+			efc_log_test(hw->os,
+				      "unsupported topology %#x\n", value);
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		hw->config.topology = value;
+		break;
+	case EFCT_HW_LINK_SPEED:
+
+		switch (value) {
+		case 0:		/* Auto-speed negotiation */
+			hw->config.speed = FC_LINK_SPEED_AUTO_16_8_4;
+			break;
+		case 2000:	/* FC speeds */
+			hw->config.speed = FC_LINK_SPEED_2G;
+			break;
+		case 4000:
+			hw->config.speed = FC_LINK_SPEED_4G;
+			break;
+		case 8000:
+			hw->config.speed = FC_LINK_SPEED_8G;
+			break;
+		case 16000:
+			hw->config.speed = FC_LINK_SPEED_16G;
+			break;
+		case 32000:
+			hw->config.speed = FC_LINK_SPEED_32G;
+			break;
+		default:
+			efc_log_test(hw->os, "unsupported speed %d\n", value);
+			rc = EFCT_HW_RTN_ERROR;
+		}
+		break;
+	case EFCT_HW_RQ_PROCESS_LIMIT: {
+		struct hw_rq_s *rq;
+		u32 i;
+
+		/* For each hw_rq object, set its parent CQ limit value */
+		for (i = 0; i < hw->hw_rq_count; i++) {
+			rq = hw->hw_rq[i];
+			hw->cq[rq->cq->instance].proc_limit = value;
+		}
+		break;
+	}
+	case EFCT_HW_RQ_DEFAULT_BUFFER_SIZE:
+		hw->config.rq_default_buffer_size = value;
+		break;
+	case EFCT_ESOC:
+		hw->config.esoc = value;
+		break;
+	case EFCT_HW_HIGH_LOGIN_MODE:
+		rc = sli_set_hlm(&hw->sli, value);
+		break;
+	case EFCT_HW_PREREGISTER_SGL:
+		rc = sli_set_sgl_preregister(&hw->sli, value);
+		break;
+	case EFCT_HW_EMULATE_TARGET_WQE_TIMEOUT:
+		hw->config.emulate_tgt_wqe_timeout = value;
+		break;
+	case EFCT_HW_BOUNCE:
+		hw->config.bounce = value;
+		break;
+	case EFCT_HW_RQ_SELECTION_POLICY:
+		hw->config.rq_selection_policy = value;
+		break;
+	case EFCT_HW_RR_QUANTA:
+		hw->config.rr_quanta = value;
+		break;
+	default:
+		efc_log_test(hw->os, "unsupported property %#x\n", prop);
+		rc = EFCT_HW_RTN_ERROR;
+	}
+
+	return rc;
+}
+
+enum efct_hw_rtn_e
+efct_hw_set_ptr(struct efct_hw_s *hw, enum efct_hw_property_e prop,
+		void *value)
+{
+	enum efct_hw_rtn_e rc = EFCT_HW_RTN_SUCCESS;
+
+	switch (prop) {
+	case EFCT_HW_WAR_VERSION:
+		hw->hw_war_version = value;
+		break;
+	case EFCT_HW_FILTER_DEF: {
+		char *p = NULL;
+		char *token;
+		u32 idx = 0;
+
+		for (idx = 0; idx < ARRAY_SIZE(hw->config.filter_def); idx++)
+			hw->config.filter_def[idx] = 0;
+
+		p = kstrdup(value, GFP_KERNEL);
+		if (!p || !*p) {
+			efc_log_err(hw->os, "p is NULL\n");
+			break;
+		}
+
+		idx = 0;
+		while ((token = strsep(&p, ",")) && *token) {
+			if (kstrtou32(token, 0, &hw->config.filter_def[idx++]))
+				efc_log_err(hw->os, "kstrtoint failed\n");
+
+			if (!p || !*p)
+				break;
+
+			if (idx == ARRAY_SIZE(hw->config.filter_def))
+				break;
+		}
+		kfree(p);
+
+		break;
+	}
+	default:
+		efc_log_test(hw->os, "unsupported property %#x\n", prop);
+		rc = EFCT_HW_RTN_ERROR;
+		break;
+	}
+	return rc;
+}
+
+enum efct_hw_rtn_e
+efct_hw_get(struct efct_hw_s *hw, enum efct_hw_property_e prop,
+	    u32 *value)
+{
+	enum efct_hw_rtn_e		rc = EFCT_HW_RTN_SUCCESS;
+	int			tmp;
+	struct sli4_s *sli = &hw->sli;
+
+	if (!value)
+		return EFCT_HW_RTN_ERROR;
+
+	*value = 0;
+
+	switch (prop) {
+	case EFCT_HW_N_IO:
+		*value = hw->config.n_io;
+		break;
+	case EFCT_HW_N_SGL:
+		*value = (hw->config.n_sgl - SLI4_SGE_MAX_RESERVED);
+		break;
+	case EFCT_HW_MAX_IO:
+		*value = sli->extent[SLI_RSRC_XRI].size;
+		break;
+	case EFCT_HW_MAX_NODES:
+		*value = sli->extent[SLI_RSRC_RPI].size;
+		break;
+	case EFCT_HW_MAX_RQ_ENTRIES:
+		*value = hw->num_qentries[SLI_QTYPE_RQ];
+		break;
+	case EFCT_HW_RQ_DEFAULT_BUFFER_SIZE:
+		*value = hw->config.rq_default_buffer_size;
+		break;
+	case EFCT_HW_MAX_SGE:
+		*value = sli->sge_supported_length;
+		break;
+	case EFCT_HW_MAX_SGL:
+		*value = sli_get_max_sgl(&hw->sli);
+		break;
+	case EFCT_HW_TOPOLOGY:
+		/*
+		 * Infer link.status based on link.speed.
+		 * Report EFCT_HW_TOPOLOGY_NONE if the link is down.
+		 */
+		if (hw->link.speed == 0) {
+			*value = EFCT_HW_TOPOLOGY_NONE;
+			break;
+		}
+		switch (hw->link.topology) {
+		case SLI_LINK_TOPO_NPORT:
+			*value = EFCT_HW_TOPOLOGY_NPORT;
+			break;
+		case SLI_LINK_TOPO_LOOP:
+			*value = EFCT_HW_TOPOLOGY_LOOP;
+			break;
+		case SLI_LINK_TOPO_NONE:
+			*value = EFCT_HW_TOPOLOGY_NONE;
+			break;
+		default:
+			efc_log_test(hw->os,
+				      "unsupported topology %#x\n",
+				     hw->link.topology);
+			rc = EFCT_HW_RTN_ERROR;
+			break;
+		}
+		break;
+	case EFCT_HW_CONFIG_TOPOLOGY:
+		*value = hw->config.topology;
+		break;
+	case EFCT_HW_LINK_SPEED:
+		*value = hw->link.speed;
+		break;
+	case EFCT_HW_LINK_CONFIG_SPEED:
+		switch (hw->config.speed) {
+		case FC_LINK_SPEED_10G:
+			*value = 10000;
+			break;
+		case FC_LINK_SPEED_AUTO_16_8_4:
+			*value = 0;
+			break;
+		case FC_LINK_SPEED_2G:
+			*value = 2000;
+			break;
+		case FC_LINK_SPEED_4G:
+			*value = 4000;
+			break;
+		case FC_LINK_SPEED_8G:
+			*value = 8000;
+			break;
+		case FC_LINK_SPEED_16G:
+			*value = 16000;
+			break;
+		case FC_LINK_SPEED_32G:
+			*value = 32000;
+			break;
+		default:
+			efc_log_test(hw->os,
+				      "unsupported speed %#x\n",
+				     hw->config.speed);
+			rc = EFCT_HW_RTN_ERROR;
+			break;
+		}
+		break;
+	case EFCT_HW_IF_TYPE:
+		*value = sli->if_type;
+		break;
+	case EFCT_HW_SLI_REV:
+		*value = sli->sli_rev;
+		break;
+	case EFCT_HW_SLI_FAMILY:
+		*value = sli->sli_family;
+		break;
+	case EFCT_HW_DIF_CAPABLE:
+		*value = sli->features & SLI4_REQFEAT_DIF;
+		break;
+	case EFCT_HW_DIF_SEED:
+		*value = hw->config.dif_seed;
+		break;
+	case EFCT_HW_DIF_MODE:
+		*value = hw->config.dif_mode;
+		break;
+	case EFCT_HW_DIF_MULTI_SEPARATE:
+		/* Lancer supports multiple DIF separates */
+		if (hw->sli.if_type == SLI4_INTF_IF_TYPE_2)
+			*value = true;
+		else
+			*value = false;
+		break;
+	case EFCT_HW_DUMP_MAX_SIZE:
+		*value = hw->dump_size;
+		break;
+	case EFCT_HW_DUMP_READY:
+		*value = sli_dump_is_ready(&hw->sli);
+		break;
+	case EFCT_HW_DUMP_PRESENT:
+		*value = sli_dump_is_present(&hw->sli);
+		break;
+	case EFCT_HW_RESET_REQUIRED:
+		tmp = sli_reset_required(&hw->sli);
+		if (tmp < 0)
+			rc = EFCT_HW_RTN_ERROR;
+		else
+			*value = tmp;
+		break;
+	case EFCT_HW_FW_ERROR:
+		*value = sli_fw_error_status(&hw->sli);
+		break;
+	case EFCT_HW_FW_READY:
+		*value = sli_fw_ready(&hw->sli);
+		break;
+	case EFCT_HW_HIGH_LOGIN_MODE:
+		*value = sli->features & SLI4_REQFEAT_HLM;
+		break;
+	case EFCT_HW_PREREGISTER_SGL:
+		*value = sli->sgl_pre_registration_required;
+		break;
+	case EFCT_HW_HW_REV1:
+		*value = sli->hw_rev[0];
+		break;
+	case EFCT_HW_HW_REV2:
+		*value = sli->hw_rev[1];
+		break;
+	case EFCT_HW_HW_REV3:
+		*value = sli->hw_rev[2];
+		break;
+	case EFCT_HW_LINK_MODULE_TYPE:
+		*value = sli->link_module_type;
+		break;
+	case EFCT_HW_EMULATE_TARGET_WQE_TIMEOUT:
+		*value = hw->config.emulate_tgt_wqe_timeout;
+		break;
+	case EFCT_HW_VPD_LEN:
+		*value = sli->vpd_length;
+		break;
+	case EFCT_HW_SEND_FRAME_CAPABLE:
+		*value = 0;
+		break;
+	case EFCT_HW_RQ_SELECTION_POLICY:
+		*value = hw->config.rq_selection_policy;
+		break;
+	case EFCT_HW_RR_QUANTA:
+		*value = hw->config.rr_quanta;
+		break;
+	case EFCT_HW_MAX_VPORTS:
+		*value = sli->extent[SLI_RSRC_VPI].size;
+		break;
+	default:
+		efc_log_test(hw->os, "unsupported property %#x\n", prop);
+		rc = EFCT_HW_RTN_ERROR;
+	}
+
+	return rc;
+}
+
+void *
+efct_hw_get_ptr(struct efct_hw_s *hw, enum efct_hw_property_e prop)
+{
+	void	*rc = NULL;
+	struct sli4_s *sli = &hw->sli;
+
+	switch (prop) {
+	case EFCT_HW_WWN_NODE:
+		rc = sli->wwnn;
+		break;
+	case EFCT_HW_WWN_PORT:
+		rc = sli->wwpn;
+		break;
+	case EFCT_HW_VPD:
+		/* make sure VPD length is non-zero */
+		if (sli->vpd_length)
+			rc = sli->vpd_data.virt;
+		break;
+	case EFCT_HW_FW_REV:
+		rc = sli->fw_name[0];
+		break;
+	case EFCT_HW_FW_REV2:
+		rc = sli->fw_name[1];
+		break;
+	case EFCT_HW_IPL:
+		rc = sli->ipl_name;
+		break;
+	case EFCT_HW_PORTNUM:
+		rc = sli->port_name;
+		break;
+	case EFCT_HW_BIOS_VERSION_STRING:
+		rc = sli->bios_version_string;
+		break;
+	default:
+		efc_log_test(hw->os, "unsupported property %#x\n", prop);
+	}
+
+	return rc;
+}
+
+/*
+ * @brief Return the WWN as a uint64_t.
+ *
+ * <h3 class="desc">Description</h3>
+ * Calls the HW property function for the WWNN or WWPN, and returns the value
+ * as a uint64_t.
+ *
+ * @param hw Pointer to the HW object.
+ * @param prop HW property.
+ *
+ * @return Returns uint64_t request value.
+ */
+
+uint64_t
+efct_get_wwn(struct efct_hw_s *hw, enum efct_hw_property_e prop)
+{
+	u8 *p = efct_hw_get_ptr(hw, prop);
+	u64 value = 0;
+
+	if (p) {
+		u32 i;
+
+		for (i = 0; i < sizeof(value); i++)
+			value = (value << 8) | p[i];
+	}
+
+	return value;
+}
diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
index 60e377b2e7e5..9636e6dbe259 100644
--- a/drivers/scsi/elx/efct/efct_hw.h
+++ b/drivers/scsi/elx/efct/efct_hw.h
@@ -1008,4 +1008,19 @@ struct efct_hw_grp_hdr {
 	u8 revision[32];
 };
 
+extern enum efct_hw_rtn_e
+efct_hw_setup(struct efct_hw_s *hw, void *os, struct pci_dev *pdev);
+enum efct_hw_rtn_e efct_hw_init(struct efct_hw_s *hw);
+extern enum efct_hw_rtn_e
+efct_hw_get(struct efct_hw_s *hw, enum efct_hw_property_e prop, u32 *value);
+extern void *
+efct_hw_get_ptr(struct efct_hw_s *hw, enum efct_hw_property_e prop);
+extern enum efct_hw_rtn_e
+efct_hw_set(struct efct_hw_s *hw, enum efct_hw_property_e prop, u32 value);
+extern enum efct_hw_rtn_e
+efct_hw_set_ptr(struct efct_hw_s *hw, enum efct_hw_property_e prop,
+		void *value);
+extern uint64_t
+efct_get_wwn(struct efct_hw_s *hw, enum efct_hw_property_e prop);
+
 #endif /* __EFCT_H__ */
diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
new file mode 100644
index 000000000000..83782794225f
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_xport.c
@@ -0,0 +1,665 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#include "efct_driver.h"
+#include "efct_unsol.h"
+
+/* Post node event callback argument. */
+struct efct_xport_post_node_event_s {
+	struct completion done;
+	atomic_t refcnt;
+	struct efc_node_s *node;
+	u32	evt;
+	void *context;
+};
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
+static void efct_xport_link_stats_cb(int status, u32 num_counters,
+				     struct efct_hw_link_stat_counts_s *c,
+				     void *arg);
+static void efct_xport_host_stats_cb(int status, u32 num_counters,
+				     struct efct_hw_host_stat_counts_s *c,
+				     void *arg);
+static void efct_xport_async_link_stats_cb(int status,
+					   u32 num_counters,
+				struct efct_hw_link_stat_counts_s *counters,
+				void *arg);
+static void efct_xport_async_host_stats_cb(int status,
+					   u32 num_counters,
+				struct efct_hw_host_stat_counts_s *counters,
+				void *arg);
+static void efct_xport_stats_timer_cb(struct timer_list *t);
+static void efct_xport_config_stats_timer(struct efct_s *efct);
+
+/**
+ * @brief Allocate a transport object.
+ *
+ * @par Description
+ * A transport object is allocated, and associated with a device instance.
+ *
+ * @param efct Pointer to device instance.
+ *
+ * @return Returns the pointer to the allocated transport object,
+ * or NULL if failed.
+ */
+struct efct_xport_s *
+efct_xport_alloc(struct efct_s *efct)
+{
+	struct efct_xport_s *xport;
+
+	xport = kmalloc(sizeof(*xport), GFP_KERNEL);
+	if (!xport)
+		return xport;
+
+	memset(xport, 0, sizeof(*xport));
+	xport->efct = efct;
+	return xport;
+}
+
+static int
+efct_xport_init_debugfs(struct efct_s *efct)
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
+				     "failed to create debugfs entry for sessions\n");
+			goto debugfs_fail;
+		}
+		atomic_inc(&efct_debugfs_count);
+	}
+
+	return 0;
+
+debugfs_fail:
+	return -1;
+}
+
+static void efct_xport_delete_debugfs(struct efct_s *efct)
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
+/**
+ * @brief Do as much allocation as possible, but do not initialization
+ * the device.
+ *
+ * @par Description
+ * Performs the functions required to get a device ready to run.
+ *
+ * @param xport Pointer to transport object.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+efct_xport_attach(struct efct_xport_s *xport)
+{
+	struct efct_s *efct = xport->efct;
+	int rc;
+	u32 max_sgl;
+	u32 n_sgl;
+	u32 value;
+
+	xport->fcfi.hold_frames = true;
+	spin_lock_init(&xport->fcfi.pend_frames_lock);
+	INIT_LIST_HEAD(&xport->fcfi.pend_frames);
+
+	rc = efct_hw_setup(&efct->hw, efct, efct->pcidev);
+	if (rc) {
+		efc_log_err(efct, "%s: Can't setup hardware\n", efct->desc);
+		return -1;
+	}
+
+	efct_hw_set(&efct->hw, EFCT_HW_RQ_SELECTION_POLICY,
+		    efct->rq_selection_policy);
+	efct_hw_get(&efct->hw, EFCT_HW_RQ_SELECTION_POLICY, &value);
+	efc_log_debug(efct, "RQ Selection Policy: %d\n", value);
+
+	efct_hw_set_ptr(&efct->hw, EFCT_HW_FILTER_DEF,
+			(void *)efct->filter_def);
+
+	efct_hw_get(&efct->hw, EFCT_HW_MAX_SGL, &max_sgl);
+	max_sgl -= SLI4_SGE_MAX_RESERVED;
+	n_sgl = (max_sgl > EFCT_FC_MAX_SGL) ? EFCT_FC_MAX_SGL : max_sgl;
+
+	/* Note: number of SGLs must be set for efc_node_create_pool */
+	if (efct_hw_set(&efct->hw, EFCT_HW_N_SGL, n_sgl) !=
+			EFCT_HW_RTN_SUCCESS) {
+		efc_log_err(efct,
+			     "%s: Can't set number of SGLs\n", efct->desc);
+		return -1;
+	}
+
+	efc_log_debug(efct, "%s: Configured for %d SGLs\n", efct->desc,
+		       n_sgl);
+
+	xport->io_pool = efct_io_pool_create(efct, EFCT_NUM_SCSI_IOS, n_sgl);
+	if (!xport->io_pool) {
+		efc_log_err(efct, "Can't allocate IO pool\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+/**
+ * @brief Initializes the device.
+ *
+ * @par Description
+ * Performs the functions required to make a device functional.
+ *
+ * @param xport Pointer to transport object.
+ *
+ * @return Returns 0 on success, or a non-zero value on failure.
+ */
+int
+efct_xport_initialize(struct efct_xport_s *xport)
+{
+	struct efct_s *efct = xport->efct;
+	int rc;
+	u32 max_hw_io;
+	u32 max_sgl;
+	u32 rq_limit;
+
+	/* booleans used for cleanup if initialization fails */
+	bool ini_device_set = false;
+	bool tgt_device_set = false;
+	bool hw_initialized = false;
+
+	efct_hw_get(&efct->hw, EFCT_HW_MAX_IO, &max_hw_io);
+	if (efct_hw_set(&efct->hw, EFCT_HW_N_IO, max_hw_io) !=
+			EFCT_HW_RTN_SUCCESS) {
+		efc_log_err(efct, "%s: Can't set number of IOs\n",
+			     efct->desc);
+		return -1;
+	}
+
+	efct_hw_get(&efct->hw, EFCT_HW_MAX_SGL, &max_sgl);
+	max_sgl -= SLI4_SGE_MAX_RESERVED;
+
+	efct_hw_get(&efct->hw, EFCT_HW_MAX_IO, &max_hw_io);
+
+	if (efct_hw_set(&efct->hw, EFCT_HW_TOPOLOGY, efct->topology) !=
+			EFCT_HW_RTN_SUCCESS) {
+		efc_log_err(efct, "%s: Can't set the toplogy\n", efct->desc);
+		return -1;
+	}
+	efct_hw_set(&efct->hw, EFCT_HW_RQ_DEFAULT_BUFFER_SIZE,
+		    EFCT_FC_RQ_SIZE_DEFAULT);
+
+	if (efct_hw_set(&efct->hw, EFCT_HW_LINK_SPEED, efct->speed) !=
+			EFCT_HW_RTN_SUCCESS) {
+		efc_log_err(efct, "%s: Can't set the link speed\n",
+			     efct->desc);
+		return -1;
+	}
+
+	if (efct->target_io_timer_sec) {
+		efc_log_debug(efct, "setting target io timer=%d\n",
+			       efct->target_io_timer_sec);
+		efct_hw_set(&efct->hw, EFCT_HW_EMULATE_TARGET_WQE_TIMEOUT,
+			    true);
+	}
+
+	/* Initialize vport list */
+	INIT_LIST_HEAD(&xport->vport_list);
+	spin_lock_init(&xport->io_pending_lock);
+	INIT_LIST_HEAD(&xport->io_pending_list);
+	atomic_set(&xport->io_active_count, 0);
+	atomic_set(&xport->io_pending_count, 0);
+	atomic_set(&xport->io_total_free, 0);
+	atomic_set(&xport->io_total_pending, 0);
+	atomic_set(&xport->io_alloc_failed_count, 0);
+	atomic_set(&xport->io_pending_recursing, 0);
+	rc = efct_hw_init(&efct->hw);
+	if (rc) {
+		efc_log_err(efct, "efct_hw_init failure\n");
+		goto efct_xport_init_cleanup;
+	} else {
+		hw_initialized = true;
+	}
+
+	rq_limit = max_hw_io / 2;
+	if (efct_hw_set(&efct->hw, EFCT_HW_RQ_PROCESS_LIMIT, rq_limit) !=
+			EFCT_HW_RTN_SUCCESS)
+		efc_log_err(efct, "%s: Can't set the RQ process limit\n",
+			     efct->desc);
+
+	rc = efct_scsi_tgt_new_device(efct);
+	if (rc) {
+		efc_log_err(efct, "failed to initialize target\n");
+		goto efct_xport_init_cleanup;
+	} else {
+		tgt_device_set = true;
+	}
+
+	rc = efct_scsi_new_device(efct);
+	if (rc) {
+		efc_log_err(efct, "failed to initialize initiator\n");
+		goto efct_xport_init_cleanup;
+	} else {
+		ini_device_set = true;
+	}
+
+	/* Get FC link and host statistics perodically*/
+	efct_xport_config_stats_timer(efct);
+
+	efct_xport_init_debugfs(efct);
+
+	return 0;
+
+efct_xport_init_cleanup:
+	if (tgt_device_set)
+		efct_scsi_tgt_del_device(efct);
+
+	if (hw_initialized) {
+		/* efct_hw_teardown can only execute after efct_hw_init */
+		efct_hw_teardown(&efct->hw);
+	}
+
+	return -1;
+}
+
+/**
+ * @brief Return status on a link.
+ *
+ * @par Description
+ * Returns status information about a link.
+ *
+ * @param xport Pointer to transport object.
+ * @param cmd Command to execute.
+ * @param result Pointer to result value.
+ *
+ * efct_xport_status(*xport, EFCT_XPORT_PORT_STATUS)
+ * efct_xport_status(*xport, EFCT_XPORT_LINK_SPEED, *result)
+ *	return link speed in MB/sec
+ * efct_xport_status(*xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED, *result)
+ *	[in] *result is speed to check in MB/s
+ *	returns 1 if supported, 0 if not
+ * efct_xport_status(*xport, EFCT_XPORT_LINK_STATISTICS, *result)
+ *	return link/host port stats
+ * efct_xport_status(*xport, EFCT_XPORT_LINK_STAT_RESET, *result)
+ *	resets link/host stats
+ *
+ *
+ * @return Returns 0 on success, or a negative error code value on failure.
+ */
+
+int
+efct_xport_status(struct efct_xport_s *xport, enum efct_xport_status_e cmd,
+		  union efct_xport_stats_u *result)
+{
+	u32 rc = 0;
+	struct efct_s *efct = NULL;
+	union efct_xport_stats_u value;
+	enum efct_hw_rtn_e hw_rc;
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
+		hw_rc = efct_hw_get(&efct->hw, EFCT_HW_LINK_SPEED,
+				    &value.value);
+		if (hw_rc == EFCT_HW_RTN_SUCCESS) {
+			if (value.value == 0)
+				result->value = 0;
+			else
+				result->value = 1;
+			rc = 0;
+		} else {
+			rc = -1;
+		}
+		break;
+
+	case EFCT_XPORT_LINK_SPEED: {
+		u32 speed;
+
+		result->value = 0;
+
+		rc = efct_hw_get(&efct->hw, EFCT_HW_LINK_SPEED, &speed);
+		if (rc == 0)
+			result->value = speed;
+		break;
+	}
+
+	case EFCT_XPORT_IS_SUPPORTED_LINK_SPEED: {
+		u32 speed;
+		u32 link_module_type;
+
+		speed = result->value;
+
+		rc = efct_hw_get(&efct->hw, EFCT_HW_LINK_MODULE_TYPE,
+				 &link_module_type);
+		if (rc == 0) {
+			switch (speed) {
+			case 1000:
+				rc = (link_module_type &
+					EFCT_HW_LINK_MODULE_TYPE_1GB) != 0;
+				break;
+			case 2000:
+				rc = (link_module_type &
+					EFCT_HW_LINK_MODULE_TYPE_2GB) != 0;
+				break;
+			case 4000:
+				rc = (link_module_type &
+					EFCT_HW_LINK_MODULE_TYPE_4GB) != 0;
+				break;
+			case 8000:
+				rc = (link_module_type &
+					EFCT_HW_LINK_MODULE_TYPE_8GB) != 0;
+				break;
+			case 10000:
+				rc = (link_module_type &
+					EFCT_HW_LINK_MODULE_TYPE_10GB) != 0;
+				break;
+			case 16000:
+				rc = (link_module_type &
+					EFCT_HW_LINK_MODULE_TYPE_16GB) != 0;
+				break;
+			case 32000:
+				rc = (link_module_type &
+					EFCT_HW_LINK_MODULE_TYPE_32GB) != 0;
+				break;
+			default:
+				rc = 0;
+				break;
+			}
+		} else {
+			rc = 0;
+		}
+		break;
+	}
+	case EFCT_XPORT_LINK_STATISTICS:
+		memcpy((void *)result, &efct->xport->fc_xport_stats,
+		       sizeof(union efct_xport_stats_u));
+		break;
+	case EFCT_XPORT_LINK_STAT_RESET: {
+		/* Create a completion to synchronize the stat reset process. */
+		init_completion(&result->stats.done);
+
+		/* First reset the link stats */
+		rc = efct_hw_get_link_stats(&efct->hw, 0, 1, 1,
+					    efct_xport_link_stats_cb, result);
+
+		/* Wait for completion to be signaled when the cmd completes */
+		if (wait_for_completion_interruptible(&result->stats.done)) {
+			/* Undefined failure */
+			efc_log_test(efct, "sem wait failed\n");
+			rc = -ENXIO;
+			break;
+		}
+
+		/* Next reset the host stats */
+		rc = efct_hw_get_host_stats(&efct->hw, 1,
+					    efct_xport_host_stats_cb, result);
+
+		/* Wait for completion to be signaled when the cmd completes */
+		if (wait_for_completion_interruptible(&result->stats.done)) {
+			/* Undefined failure */
+			efc_log_test(efct, "sem wait failed\n");
+			rc = -ENXIO;
+			break;
+		}
+		break;
+	}
+	default:
+		rc = -1;
+		break;
+	}
+
+	return rc;
+}
+
+static void
+efct_xport_stats_timer_cb(struct timer_list *t)
+{
+	struct efct_xport_s *xport = from_timer(xport, t, stats_timer);
+	struct efct_s *efct = xport->efct;
+
+	efct_xport_config_stats_timer(efct);
+}
+
+/**
+ * @brief Get FC link and host Statistics periodically
+ *
+ * @param hw Hardware context.
+ *
+ * @return NONE.
+ */
+static void
+efct_xport_config_stats_timer(struct efct_s *efct)
+{
+	u32 timeout = 3 * 1000;
+	struct efct_xport_s *xport = NULL;
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
+efct_scsi_new_device(struct efct_s *efct)
+{
+	struct Scsi_Host *shost = NULL;
+	int error = 0;
+	struct efct_vport_s *vport = NULL;
+	union efct_xport_stats_u speed;
+	u32 supported_speeds = 0;
+
+	shost = scsi_host_alloc(&efct_template, sizeof(*vport));
+	if (!shost) {
+		efc_log_err(efct, "failed to allocate Scsi_Host struct\n");
+		return -1;
+	}
+
+	/* save shost to initiator-client context */
+	efct->shost = shost;
+
+	/* save efct information to shost LLD-specific space */
+	vport = (struct efct_vport_s *)shost->hostdata;
+	vport->efct = efct;
+
+	/*
+	 * Set initial can_queue value to the max SCSI IOs. This is the maximum
+	 * global queue depth (as opposed to the per-LUN queue depth --
+	 * .cmd_per_lun This may need to be adjusted for I+T mode.
+	 */
+	shost->can_queue = efct_scsi_get_property(efct, EFCT_SCSI_MAX_IOS);
+	shost->max_cmd_len = 16; /* 16-byte CDBs */
+	shost->max_id = 0xffff;
+	shost->max_lun = 0xffffffff;
+
+	/*
+	 * can only accept (from mid-layer) as many SGEs as we've
+	 * pre-registered
+	 */
+	shost->sg_tablesize = efct_scsi_get_property(efct, EFCT_SCSI_MAX_SGL);
+
+	/* attach FC Transport template to shost */
+	shost->transportt = efct_xport_fc_tt;
+	efc_log_debug(efct, "transport template=%p\n", efct_xport_fc_tt);
+
+	/* get pci_dev structure and add host to SCSI ML */
+	error = scsi_add_host_with_dma(shost, &efct->pcidev->dev,
+				       &efct->pcidev->dev);
+	if (error) {
+		efc_log_test(efct, "failed scsi_add_host_with_dma\n");
+		return -1;
+	}
+
+	/* Set symbolic name for host port */
+	snprintf(fc_host_symbolic_name(shost),
+		 sizeof(fc_host_symbolic_name(shost)),
+		     "Emulex %s FV%s DV%s", efct->model,
+		     efct->fw_version, efct->driver_version);
+
+	/* Set host port supported classes */
+	fc_host_supported_classes(shost) = FC_COS_CLASS3;
+
+	speed.value = 1000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_1GBIT;
+	}
+	speed.value = 2000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_2GBIT;
+	}
+	speed.value = 4000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_4GBIT;
+	}
+	speed.value = 8000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_8GBIT;
+	}
+	speed.value = 10000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_10GBIT;
+	}
+	speed.value = 16000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_16GBIT;
+	}
+	speed.value = 32000;
+	if (efct_xport_status(efct->xport, EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+			      &speed)) {
+		supported_speeds |= FC_PORTSPEED_32GBIT;
+	}
+
+	fc_host_supported_speeds(shost) = supported_speeds;
+
+	fc_host_node_name(shost) = efct_get_wwn(&efct->hw, EFCT_HW_WWN_NODE);
+	fc_host_port_name(shost) = efct_get_wwn(&efct->hw, EFCT_HW_WWN_PORT);
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
+		return -1;
+	}
+
+	efct_vport_fc_tt = efct_attach_vport_fc_transport();
+	if (!efct_vport_fc_tt) {
+		pr_err("%s: failed to attach to scsi_transport_*", __func__);
+		efct_release_fc_transport(efct_xport_fc_tt);
+		efct_xport_fc_tt = NULL;
+		return -1;
+	}
+
+	return 0;
+}
+
+int
+efct_scsi_release_fc_transport(void)
+{
+	/* detach from scsi_transport_* */
+	efct_release_fc_transport(efct_xport_fc_tt);
+	efct_xport_fc_tt = NULL;
+	if (efct_vport_fc_tt)
+		efct_release_fc_transport(efct_vport_fc_tt);
+	efct_vport_fc_tt = NULL;
+
+	return 0;
+}
diff --git a/drivers/scsi/elx/efct/efct_xport.h b/drivers/scsi/elx/efct/efct_xport.h
new file mode 100644
index 000000000000..ad6a6bfaf8fb
--- /dev/null
+++ b/drivers/scsi/elx/efct/efct_xport.h
@@ -0,0 +1,216 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
+ * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
+ */
+
+#if !defined(__EFCT_XPORT_H__)
+#define __EFCT_XPORT_H__
+
+/**
+ * @brief FCFI lookup/pending frames
+ */
+struct efct_xport_fcfi_s {
+	/* lock to protect pending frames access*/
+	spinlock_t	pend_frames_lock;
+	struct list_head	pend_frames;
+	/* hold pending frames */
+	bool hold_frames;
+	/* count of pending frames that were processed */
+	u32	pend_frames_processed;
+};
+
+enum efct_xport_ctrl_e {
+	EFCT_XPORT_PORT_ONLINE = 1,
+	EFCT_XPORT_PORT_OFFLINE,
+	EFCT_XPORT_SHUTDOWN,
+	EFCT_XPORT_POST_NODE_EVENT,
+	EFCT_XPORT_WWNN_SET,
+	EFCT_XPORT_WWPN_SET,
+};
+
+enum efct_xport_status_e {
+	EFCT_XPORT_PORT_STATUS,
+	EFCT_XPORT_CONFIG_PORT_STATUS,
+	EFCT_XPORT_LINK_SPEED,
+	EFCT_XPORT_IS_SUPPORTED_LINK_SPEED,
+	EFCT_XPORT_LINK_STATISTICS,
+	EFCT_XPORT_LINK_STAT_RESET,
+	EFCT_XPORT_IS_QUIESCED
+};
+
+struct efct_xport_link_stats_s {
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
+	u32	link_failure_error_count;
+	u32	loss_of_sync_error_count;
+	u32	loss_of_signal_error_count;
+	u32	primitive_sequence_error_count;
+	u32	invalid_transmission_word_error_count;
+	u32	crc_error_count;
+	u32	primitive_sequence_event_timeout_count;
+	u32	elastic_buffer_overrun_error_count;
+	u32	arbitration_fc_al_timeout_count;
+	u32	advertised_receive_bufftor_to_buffer_credit;
+	u32	current_receive_buffer_to_buffer_credit;
+	u32	advertised_transmit_buffer_to_buffer_credit;
+	u32	current_transmit_buffer_to_buffer_credit;
+	u32	received_eofa_count;
+	u32	received_eofdti_count;
+	u32	received_eofni_count;
+	u32	received_soff_count;
+	u32	received_dropped_no_aer_count;
+	u32	received_dropped_no_available_rpi_resources_count;
+	u32	received_dropped_no_available_xri_resources_count;
+};
+
+struct efct_xport_host_stats_s {
+	bool		cc;
+	u32	transmit_kbyte_count;
+	u32	receive_kbyte_count;
+	u32	transmit_frame_count;
+	u32	receive_frame_count;
+	u32	transmit_sequence_count;
+	u32	receive_sequence_count;
+	u32	total_exchanges_originator;
+	u32	total_exchanges_responder;
+	u32	receive_p_bsy_count;
+	u32	receive_f_bsy_count;
+	u32	dropped_frames_due_to_no_rq_buffer_count;
+	u32	empty_rq_timeout_count;
+	u32	dropped_frames_due_to_no_xri_count;
+	u32	empty_xri_pool_count;
+};
+
+struct efct_xport_host_statistics_s {
+	struct completion done;
+	struct efct_xport_link_stats_s link_stats;
+	struct efct_xport_host_stats_s host_stats;
+};
+
+union efct_xport_stats_u {
+	u32 value;
+	struct efct_xport_host_statistics_s stats;
+};
+
+struct efct_xport_fcp_stats_s {
+	u64	input_bytes;
+	u64	output_bytes;
+	u64	input_requests;
+	u64	output_requests;
+	u64	control_requests;
+};
+
+/**
+ * @brief Transport private values
+ */
+struct efct_xport_s {
+	struct efct_s *efct;
+	/* wwpn requested by user for primary sport */
+	u64 req_wwpn;
+	/* wwnn requested by user for primary sport */
+	u64 req_wwnn;
+
+	struct efct_xport_fcfi_s fcfi;
+
+	/* Nodes */
+	/* number of allocated nodes */
+	u32 nodes_count;
+	/* array of pointers to nodes */
+	struct efc_node_s **nodes;
+	/* linked list of free nodes */
+	struct list_head nodes_free_list;
+
+	/* Io pool and counts */
+	/* pointer to IO pool */
+	struct efct_io_pool_s *io_pool;
+	/* used to track how often IO pool is empty */
+	atomic_t io_alloc_failed_count;
+	/* lock for io_pending_list */
+	spinlock_t io_pending_lock;
+	/* list of IOs waiting for HW resources
+	 *  lock: xport->io_pending_lock
+	 *  link: efct_io_s->io_pending_link
+	 */
+	struct list_head io_pending_list;
+	/* count of totals IOS allocated */
+	atomic_t io_total_alloc;
+	/* count of totals IOS free'd */
+	atomic_t io_total_free;
+	/* count of totals IOS that were pended */
+	atomic_t io_total_pending;
+	/* count of active IOS */
+	atomic_t io_active_count;
+	/* count of pending IOS */
+	atomic_t io_pending_count;
+	/* non-zero if efct_scsi_check_pending is executing */
+	atomic_t io_pending_recursing;
+
+	/* vport */
+	/* list of VPORTS (NPIV) */
+	struct list_head vport_list;
+
+	/* Port */
+	/* requested link state */
+	u32 configured_link_state;
+
+	/* Timer for Statistics */
+	struct timer_list     stats_timer;
+	union efct_xport_stats_u fc_xport_stats;
+	struct efct_xport_fcp_stats_s fcp_stats;
+};
+
+struct efct_rport_data_s {
+	struct efc_node_s *node;
+};
+
+extern struct efct_xport_s *
+efct_xport_alloc(struct efct_s *efct);
+extern int
+efct_xport_attach(struct efct_xport_s *xport);
+extern int
+efct_xport_initialize(struct efct_xport_s *xport);
+extern int
+efct_xport_detach(struct efct_xport_s *xport);
+extern int
+efct_xport_control(struct efct_xport_s *xport, enum efct_xport_ctrl_e cmd, ...);
+extern int
+efct_xport_status(struct efct_xport_s *xport, enum efct_xport_status_e cmd,
+		  union efct_xport_stats_u *result);
+extern void
+efct_xport_free(struct efct_xport_s *xport);
+
+int efct_lnx_xport_attach(void);
+struct scsi_transport_template *efct_attach_fc_transport(void);
+struct scsi_transport_template *efct_attach_vport_fc_transport(void);
+void efct_lnx_xport_detach(void);
+void
+efct_release_fc_transport(struct scsi_transport_template *transport_template);
+void efct_lnx_xport_remove_host(struct Scsi_Host *shost);
+int efct_lnx_xport_new_tgt(struct efc_node_s *node);
+int efct_lnx_xport_init_tgt(struct scsi_device *sdev);
+int efct_lnx_xport_del_tgt(struct efc_node_s *node,
+			   enum efct_scsi_del_target_reason_e reason);
+#endif /* __EFCT_XPORT_H__ */
-- 
2.13.7

