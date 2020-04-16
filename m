Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4DCC2BA2B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 07:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFF1C20771
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 07:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438358AbgDPHLS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:11:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:48588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437186AbgDPHLP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 03:11:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5ED27AC85;
        Thu, 16 Apr 2020 07:11:06 +0000 (UTC)
Subject: Re: [PATCH v3 16/31] elx: efct: Driver initialization routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-17-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <01037050-b4f8-c171-ce53-deda6b9b0aa7@suse.de>
Date:   Thu, 16 Apr 2020 09:11:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-17-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Emulex FC Target driver init, attach and hardware setup routines.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Removed Queue topology string.
>    Used request_threaded_irq instead of a thread.
>    Use a static fuction to get the model.
>    Reworked efct_device_attach to use if statements and gotos.
>    Changed efct_fw_reset, removed accessing other functions.
>    Converted to use pci_alloc_irq_vectors api.
>    Removed proc interface.
>    Removed efct_hw_get and efct_hw_set functions. Driver implicitly
>      knows adapter configuration.
>    Many more small changes.
> ---
>   drivers/scsi/elx/efct/efct_driver.c |  856 +++++++++++++++++++++++++++
>   drivers/scsi/elx/efct/efct_driver.h |  142 +++++
>   drivers/scsi/elx/efct/efct_hw.c     | 1116 +++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/efct/efct_hw.h     |   15 +
>   drivers/scsi/elx/efct/efct_xport.c  |  523 ++++++++++++++++
>   drivers/scsi/elx/efct/efct_xport.h  |  201 +++++++
>   6 files changed, 2853 insertions(+)
>   create mode 100644 drivers/scsi/elx/efct/efct_driver.c
>   create mode 100644 drivers/scsi/elx/efct/efct_driver.h
>   create mode 100644 drivers/scsi/elx/efct/efct_hw.c
>   create mode 100644 drivers/scsi/elx/efct/efct_xport.c
>   create mode 100644 drivers/scsi/elx/efct/efct_xport.h
> 
> diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
> new file mode 100644
> index 000000000000..ff488fb774f1
> --- /dev/null
> +++ b/drivers/scsi/elx/efct/efct_driver.c
> @@ -0,0 +1,856 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include "efct_driver.h"
> +
> +#include "efct_els.h"
> +#include "efct_hw.h"
> +#include "efct_unsol.h"
> +#include "efct_scsi.h"
> +
> +struct efct *efct_devices[MAX_EFCT_DEVICES];
> +
> +static int logmask;
> +module_param(logmask, int, 0444);
> +MODULE_PARM_DESC(logmask, "logging bitmask (default 0)");
> +
> +static struct libefc_function_template efct_libefc_templ = {
> +	.hw_domain_alloc = efct_hw_domain_alloc,
> +	.hw_domain_attach = efct_hw_domain_attach,
> +	.hw_domain_free = efct_hw_domain_free,
> +	.hw_domain_force_free = efct_hw_domain_force_free,
> +	.domain_hold_frames = efct_domain_hold_frames,
> +	.domain_accept_frames = efct_domain_accept_frames,
> +
> +	.hw_port_alloc = efct_hw_port_alloc,
> +	.hw_port_attach = efct_hw_port_attach,
> +	.hw_port_free = efct_hw_port_free,
> +
> +	.hw_node_alloc = efct_hw_node_alloc,
> +	.hw_node_attach = efct_hw_node_attach,
> +	.hw_node_detach = efct_hw_node_detach,
> +	.hw_node_free_resources = efct_hw_node_free_resources,
> +	.node_purge_pending = efct_node_purge_pending,
> +
> +	.scsi_io_alloc_disable = efct_scsi_io_alloc_disable,
> +	.scsi_io_alloc_enable = efct_scsi_io_alloc_enable,
> +	.scsi_validate_node = efct_scsi_validate_initiator,
> +	.new_domain = efct_scsi_tgt_new_domain,
> +	.del_domain = efct_scsi_tgt_del_domain,
> +	.new_sport = efct_scsi_tgt_new_sport,
> +	.del_sport = efct_scsi_tgt_del_sport,
> +	.scsi_new_node = efct_scsi_new_initiator,
> +	.scsi_del_node = efct_scsi_del_initiator,
> +
> +	.els_send = efct_els_req_send,
> +	.els_send_ct = efct_els_send_ct,
> +	.els_send_resp = efct_els_resp_send,
> +	.bls_send_acc_hdr = efct_bls_send_acc_hdr,
> +	.send_flogi_p2p_acc = efct_send_flogi_p2p_acc,
> +	.send_ct_rsp = efct_send_ct_rsp,
> +	.send_ls_rjt = efct_send_ls_rjt,
> +
> +	.node_io_cleanup = efct_node_io_cleanup,
> +	.node_els_cleanup = efct_node_els_cleanup,
> +	.node_abort_all_els = efct_node_abort_all_els,
> +
> +	.dispatch_fcp_cmd = efct_dispatch_fcp_cmd,
> +	.recv_abts_frame = efct_node_recv_abts_frame,
> +};
> +
> +static int
> +efct_device_init(void)
> +{
> +	int rc;
> +
> +	/* driver-wide init for target-server */
> +	rc = efct_scsi_tgt_driver_init();
> +	if (rc) {
> +		pr_err("efct_scsi_tgt_init failed rc=%d\n",
> +			     rc);
> +		return rc;
> +	}
> +
> +	rc = efct_scsi_reg_fc_transport();
> +	if (rc) {
> +		pr_err("failed to register to FC host\n");
> +		return rc;
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static void
> +efct_device_shutdown(void)
> +{
> +	efct_scsi_release_fc_transport();
> +
> +	efct_scsi_tgt_driver_exit();
> +}
> +
> +static void *
> +efct_device_alloc(u32 nid)
> +{
> +	struct efct *efct = NULL;
> +	u32 i;
> +
> +	efct = kmalloc_node(sizeof(*efct), GFP_ATOMIC, nid);
> +

kzalloc_node() ?

> +	if (efct) {
> +		memset(efct, 0, sizeof(*efct));
> +		for (i = 0; i < ARRAY_SIZE(efct_devices); i++) {
> +			if (!efct_devices[i]) {
> +				efct->instance_index = i;
> +				efct_devices[i] = efct;
> +				break;
> +			}
> +		}
> +
> +		if (i == ARRAY_SIZE(efct_devices)) {
> +			pr_err("Exceeded max supported devices.\n");
> +			kfree(efct);
> +			efct = NULL;
> +		} else {
> +			efct->attached = false;
> +		}

Errm. This is wrong.
When we exit the for() loop above, i _will_ equal the array size.
Surely you mean

if (i < ARRAY_SIZE())

right?

> +	}
> +	return efct;
> +}
> +
> +static void
> +efct_teardown_msix(struct efct *efct)
> +{
> +	u32 i;
> +
> +	for (i = 0; i < efct->n_msix_vec; i++) {
> +		free_irq(pci_irq_vector(efct->pcidev, i),
> +			 &efct->intr_context[i]);
> +	}
> +
> +	pci_free_irq_vectors(efct->pcidev);
> +}
> +
> +static int
> +efct_efclib_config(struct efct *efct, struct libefc_function_template *tt)
> +{
> +	struct efc *efc;
> +	struct sli4 *sli;
> +	int rc = EFC_SUCCESS;
> +
> +	efc = kmalloc(sizeof(*efc), GFP_KERNEL);
> +	if (!efc)
> +		return EFC_FAIL;
> +
> +	memset(efc, 0, sizeof(struct efc));
> +	efct->efcport = efc;
> +
> +	memcpy(&efc->tt, tt, sizeof(*tt));
> +	efc->base = efct;
> +	efc->pcidev = efct->pcidev;
> +
> +	efc->def_wwnn = efct_get_wwnn(&efct->hw);
> +	efc->def_wwpn = efct_get_wwpn(&efct->hw);
> +	efc->enable_tgt = 1;
> +	efc->log_level = EFC_LOG_LIB;
> +
> +	sli = &efct->hw.sli;
> +	efc->max_xfer_size = sli->sge_supported_length *
> +			     sli_get_max_sgl(&efct->hw.sli);
> +
> +	rc = efcport_init(efc);
> +	if (rc)
> +		efc_log_err(efc, "efcport_init failed\n");
> +
> +	return rc;
> +}
> +
> +static int efct_request_firmware_update(struct efct *efct);
> +
> +static const char*
> +efct_pci_model(u16 device)
> +{
> +	switch (device) {
> +	case EFCT_DEVICE_LANCER_G6:	return "LPE31004";
> +	case EFCT_DEVICE_LANCER_G7:	return "LPE36000";
> +	default:			return "unknown";
> +	}
> +}
> +
> +static int
> +efct_device_attach(struct efct *efct)
> +{
> +	u32 rc = 0, i = 0;
> +
> +	if (efct->attached) {
> +		efc_log_err(efct, "Device is already attached\n");
> +		return EFC_FAIL;
> +	}
> +
> +	snprintf(efct->name, sizeof(efct->name), "[%s%d] ", "fc",
> +		 efct->instance_index);
> +
> +	efct->logmask = logmask;
> +	efct->filter_def = "0,0,0,0";
> +	efct->max_isr_time_msec = EFCT_OS_MAX_ISR_TIME_MSEC;
> +
> +	efct->model = efct_pci_model(efct->pcidev->device);
> +
> +	efct->efct_req_fw_upgrade = true;
> +
> +	/* Allocate transport object and bring online */
> +	efct->xport = efct_xport_alloc(efct);
> +	if (!efct->xport) {
> +		efc_log_err(efct, "failed to allocate transport object\n");
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	rc = efct_xport_attach(efct->xport);
> +	if (rc) {
> +		efc_log_err(efct, "failed to attach transport object\n");
> +		goto xport_out;
> +	}
> +
> +	rc = efct_xport_initialize(efct->xport);
> +	if (rc) {
> +		efc_log_err(efct, "failed to initialize transport object\n");
> +		goto xport_out;
> +	}
> +
> +	rc = efct_efclib_config(efct, &efct_libefc_templ);
> +	if (rc) {
> +		efc_log_err(efct, "failed to init efclib\n");
> +		goto efclib_out;
> +	}
> +
> +	for (i = 0; i < efct->n_msix_vec; i++) {
> +		efc_log_debug(efct, "irq %d enabled\n", i);
> +		enable_irq(pci_irq_vector(efct->pcidev, i));
> +	}
> +
> +	efct->attached = true;
> +
> +	if (efct->efct_req_fw_upgrade)
> +		efct_request_firmware_update(efct);
> +
> +	return rc;
> +
> +efclib_out:
> +	efct_xport_detach(efct->xport);
> +xport_out:
> +	if (efct->xport) {
> +		efct_xport_free(efct->xport);
> +		efct->xport = NULL;
> +	}
> +out:
> +	return rc;
> +}
> +
> +static int
> +efct_device_detach(struct efct *efct)
> +{
> +	int rc = 0, i;
> +
> +	if (efct) {
> +		if (!efct->attached) {
> +			efc_log_warn(efct, "Device is not attached\n");
> +			return EFC_FAIL;
> +		}
> +
> +		rc = efct_xport_control(efct->xport, EFCT_XPORT_SHUTDOWN);
> +		if (rc)
> +			efc_log_err(efct, "Transport Shutdown timed out\n");
> +
> +		for (i = 0; i < efct->n_msix_vec; i++)
> +			disable_irq(pci_irq_vector(efct->pcidev, i));
> +
> +		if (efct_xport_detach(efct->xport) != 0)
> +			efc_log_err(efct, "Transport detach failed\n");
> +
> +		efct_xport_free(efct->xport);
> +		efct->xport = NULL;
> +
> +		efcport_destroy(efct->efcport);
> +		kfree(efct->efcport);
> +
> +		efct->attached = false;
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static void
> +efct_fw_write_cb(int status, u32 actual_write_length,
> +		 u32 change_status, void *arg)
> +{
> +	struct efct_fw_write_result *result = arg;
> +
> +	result->status = status;
> +	result->actual_xfer = actual_write_length;
> +	result->change_status = change_status;
> +
> +	complete(&result->done);
> +}
> +
> +static int
> +efct_firmware_write(struct efct *efct, const u8 *buf, size_t buf_len,
> +		    u8 *change_status)
> +{
> +	int rc = 0;
> +	u32 bytes_left;
> +	u32 xfer_size;
> +	u32 offset;
> +	struct efc_dma dma;
> +	int last = 0;
> +	struct efct_fw_write_result result;
> +
> +	init_completion(&result.done);
> +
> +	bytes_left = buf_len;
> +	offset = 0;
> +
> +	dma.size = FW_WRITE_BUFSIZE;
> +	dma.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +				      dma.size, &dma.phys, GFP_DMA);
> +	if (!dma.virt)
> +		return -ENOMEM;
> +
> +	while (bytes_left > 0) {
> +		if (bytes_left > FW_WRITE_BUFSIZE)
> +			xfer_size = FW_WRITE_BUFSIZE;
> +		else
> +			xfer_size = bytes_left;
> +
> +		memcpy(dma.virt, buf + offset, xfer_size);
> +
> +		if (bytes_left == xfer_size)
> +			last = 1;
> +
> +		efct_hw_firmware_write(&efct->hw, &dma, xfer_size, offset,
> +				       last, efct_fw_write_cb, &result);
> +
> +		if (wait_for_completion_interruptible(&result.done) != 0) {
> +			rc = -ENXIO;
> +			break;
> +		}
> +
> +		if (result.actual_xfer == 0 || result.status != 0) {
> +			rc = -EFAULT;
> +			break;
> +		}
> +
> +		if (last)
> +			*change_status = result.change_status;
> +
> +		bytes_left -= result.actual_xfer;
> +		offset += result.actual_xfer;
> +	}
> +
> +	dma_free_coherent(&efct->pcidev->dev, dma.size, dma.virt, dma.phys);
> +	return rc;
> +}
> +
> +/*
> + * Firmware reset to activate the new firmware.
> + * Function 0 will update and load the new firmware
> + * during attach.
> + */
> +static int
> +efct_fw_reset(struct efct *efct)
> +{
> +	int rc = 0;
> +
> +	if (timer_pending(&efct->xport->stats_timer))
> +		del_timer(&efct->xport->stats_timer);
> +
> +	if (efct_hw_reset(&efct->hw, EFCT_HW_RESET_FIRMWARE)) {
> +		efc_log_info(efct, "failed to reset firmware\n");
> +		rc = -1;
> +	} else {
> +		efc_log_info(efct,
> +			"successfully reset firmware.Now resetting port\n");
> +
> +		efct_device_detach(efct);
> +		rc = efct_device_attach(efct);
> +	}
> +	return rc;
> +}
> +
> +static int
> +efct_request_firmware_update(struct efct *efct)
> +{
> +	int rc = 0;
> +	u8 file_name[256], fw_change_status = 0;
> +	const struct firmware *fw;
> +	struct efct_hw_grp_hdr *fw_image;
> +
> +	snprintf(file_name, 256, "%s.grp", efct->model);
> +
> +	rc = request_firmware(&fw, file_name, &efct->pcidev->dev);
> +	if (rc) {
> +		efc_log_debug(efct, "Firmware file(%s) not found.\n",
> +				file_name);
> +		return rc;
> +	}
> +
> +	fw_image = (struct efct_hw_grp_hdr *)fw->data;
> +
> +	if (!strncmp(efct->hw.sli.fw_name[0], fw_image->revision,
> +		     strnlen(fw_image->revision, 16))) {
> +		efc_log_debug(efct,
> +			"Skipped update. Firmware is already up to date.\n");
> +		goto exit;
> +	}
> +
> +	efc_log_info(efct, "Firmware update is initiated. %s -> %s\n",
> +		     efct->hw.sli.fw_name[0], fw_image->revision);
> +
> +	rc = efct_firmware_write(efct, fw->data, fw->size, &fw_change_status);
> +	if (rc) {
> +		efc_log_err(efct,
> +			     "Firmware update failed. Return code = %d\n", rc);
> +		goto exit;
> +	}
> +
> +	efc_log_info(efct, "Firmware updated successfully\n");
> +	switch (fw_change_status) {
> +	case 0x00:
> +		efc_log_info(efct, "New firmware is active.\n");
> +		break;
> +	case 0x01:
> +		efc_log_info(efct,
> +			"System reboot needed to activate the new firmware\n");
> +		break;
> +	case 0x02:
> +	case 0x03:
> +		efc_log_info(efct,
> +			"firmware is resetting to activate the new firmware\n");
> +		efct_fw_reset(efct);
> +		break;
> +	default:
> +		efc_log_info(efct,
> +			"Unexected value change_status:%d\n", fw_change_status);
> +		break;
> +	}
> +
> +exit:
> +	release_firmware(fw);
> +
> +	return rc;
> +}
> +
> +static void
> +efct_device_free(struct efct *efct)
> +{
> +	if (efct) {
> +		efct_devices[efct->instance_index] = NULL;
> +
> +		kfree(efct);
> +	}
> +}
> +
> +static int
> +efct_device_interrupts_required(struct efct *efct)
> +{
> +	if (efct_hw_setup(&efct->hw, efct, efct->pcidev)
> +				!= EFCT_HW_RTN_SUCCESS) {
> +		return -1;
> +	}
> +
> +	return efct->hw.config.n_eq;
> +}
> +
> +static irqreturn_t
> +efct_intr_thread(int irq, void *handle)
> +{
> +	struct efct_intr_context *intr_ctx = handle;
> +	struct efct *efct = intr_ctx->efct;
> +
> +	efct_hw_process(&efct->hw, intr_ctx->index, efct->max_isr_time_msec);
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t
> +efct_intr_msix(int irq, void *handle)
> +{
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static int
> +efct_setup_msix(struct efct *efct, u32 num_intrs)
> +{
> +	int	rc = 0, i;
> +

Drop the tab between 'int' and 'rc'.

> +	if (!pci_find_capability(efct->pcidev, PCI_CAP_ID_MSIX)) {
> +		dev_err(&efct->pcidev->dev,
> +			"%s : MSI-X not available\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	efct->n_msix_vec = num_intrs;
> +
> +	rc = pci_alloc_irq_vectors(efct->pcidev, num_intrs, num_intrs,
> +				   PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
> +
> +	if (rc < 0) {
> +		dev_err(&efct->pcidev->dev, "Failed to alloc irq : %d\n", rc);
> +		return rc;
> +	}
> +
> +	for (i = 0; i < num_intrs; i++) {
> +		struct efct_intr_context *intr_ctx = NULL;
> +
> +		intr_ctx = &efct->intr_context[i];
> +		intr_ctx->efct = efct;
> +		intr_ctx->index = i;
> +
> +		rc = request_threaded_irq(pci_irq_vector(efct->pcidev, i),
> +					  efct_intr_msix, efct_intr_thread, 0,
> +					  EFCT_DRIVER_NAME, intr_ctx);
> +		if (rc) {
> +			dev_err(&efct->pcidev->dev,
> +				"Failed to register %d vector: %d\n", i, rc);
> +			goto out;
> +		}
> +	}
> +
> +	return rc;
> +
> +out:
> +	while (--i >= 0)
> +		free_irq(pci_irq_vector(efct->pcidev, i),
> +			 &efct->intr_context[i]);
> +
> +	pci_free_irq_vectors(efct->pcidev);
> +	return rc;
> +}
> +
> +static struct pci_device_id efct_pci_table[] = {
> +	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G6), 0},
> +	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G7), 0},
> +	{}	/* terminate list */
> +};
> +
> +static int
> +efct_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct efct *efct = NULL;
> +	int rc;
> +	u32 i, r;
> +	int num_interrupts = 0;
> +	int nid;
> +
> +	dev_info(&pdev->dev, "%s\n", EFCT_DRIVER_NAME);
> +
> +	rc = pci_enable_device_mem(pdev);
> +	if (rc)
> +		return rc;
> +
> +	pci_set_master(pdev);
> +
> +	rc = pci_set_mwi(pdev);
> +	if (rc) {
> +		dev_info(&pdev->dev,
> +			 "pci_set_mwi returned %d\n", rc);
> +		goto mwi_out;
> +	}
> +
> +	rc = pci_request_regions(pdev, EFCT_DRIVER_NAME);
> +	if (rc) {
> +		dev_err(&pdev->dev, "pci_request_regions failed %d\n", rc);
> +		goto req_regions_out;
> +	}
> +
> +	/* Fetch the Numa node id for this device */
> +	nid = dev_to_node(&pdev->dev);
> +	if (nid < 0) {
> +		dev_err(&pdev->dev,
> +			"Warning Numa node ID is %d\n", nid);
> +		nid = 0;
> +	}
> +
> +	/* Allocate efct */
> +	efct = efct_device_alloc(nid);
> +	if (!efct) {
> +		dev_err(&pdev->dev, "Failed to allocate efct\n");
> +		rc = -ENOMEM;
> +		goto alloc_out;
> +	}
> +
> +	efct->pcidev = pdev;
> +
> +	efct->numa_node = nid;
> +
> +	/* Map all memory BARs */
> +	for (i = 0, r = 0; i < EFCT_PCI_MAX_REGS; i++) {
> +		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
> +			efct->reg[r] = ioremap(pci_resource_start(pdev, i),
> +						  pci_resource_len(pdev, i));
> +			r++;
> +		}
> +
> +		/*
> +		 * If the 64-bit attribute is set, both this BAR and the
> +		 * next form the complete address. Skip processing the
> +		 * next BAR.
> +		 */
> +		if (pci_resource_flags(pdev, i) & IORESOURCE_MEM_64)
> +			i++;
> +	}
> +
> +	pci_set_drvdata(pdev, efct);
> +
> +	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0 ||
> +	    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) {
> +		dev_warn(&pdev->dev,
> +			 "trying DMA_BIT_MASK(32)\n");
> +		if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0 ||
> +		    pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) {
> +			dev_err(&pdev->dev,
> +				"setting DMA_BIT_MASK failed\n");
> +			rc = -1;
> +			goto dma_mask_out;
> +		}
> +	}
> +
> +	num_interrupts = efct_device_interrupts_required(efct);
> +	if (num_interrupts < 0) {
> +		efc_log_err(efct, "efct_device_interrupts_required failed\n");
> +		rc = -1;
> +		goto dma_mask_out;
> +	}
> +
> +	/*
> +	 * Initialize MSIX interrupts, note,
> +	 * efct_setup_msix() enables the interrupt
> +	 */
> +	rc = efct_setup_msix(efct, num_interrupts);
> +	if (rc) {
> +		dev_err(&pdev->dev, "Can't setup msix\n");
> +		goto dma_mask_out;
> +	}
> +	/* Disable interrupt for now */
> +	for (i = 0; i < efct->n_msix_vec; i++) {
> +		efc_log_debug(efct, "irq %d disabled\n", i);
> +		disable_irq(pci_irq_vector(efct->pcidev, i));
> +	}
> +
> +	rc = efct_device_attach((struct efct *)efct);
> +	if (rc)
> +		goto attach_out;
> +
> +	return EFC_SUCCESS;
> +
> +attach_out:
> +	efct_teardown_msix(efct);
> +dma_mask_out:
> +	pci_set_drvdata(pdev, NULL);
> +
> +	for (i = 0; i < EFCT_PCI_MAX_REGS; i++) {
> +		if (efct->reg[i])
> +			iounmap(efct->reg[i]);
> +	}
> +	efct_device_free(efct);
> +alloc_out:
> +	pci_release_regions(pdev);
> +req_regions_out:
> +	pci_clear_mwi(pdev);
> +mwi_out:
> +	pci_disable_device(pdev);
> +	return rc;
> +}
> +
> +static void
> +efct_pci_remove(struct pci_dev *pdev)
> +{
> +	struct efct *efct = pci_get_drvdata(pdev);
> +	u32	i;
> +
> +	if (!efct)
> +		return;
> +
> +	efct_device_detach(efct);
> +
> +	efct_teardown_msix(efct);
> +
> +	for (i = 0; i < EFCT_PCI_MAX_REGS; i++) {
> +		if (efct->reg[i])
> +			iounmap(efct->reg[i]);
> +	}
> +
> +	pci_set_drvdata(pdev, NULL);
> +
> +	efct_devices[efct->instance_index] = NULL;
> +
> +	efct_device_free(efct);
> +
> +	pci_release_regions(pdev);
> +
> +	pci_disable_device(pdev);
> +}
> +
> +static void
> +efct_device_prep_for_reset(struct efct *efct, struct pci_dev *pdev)
> +{
> +	if (efct) {
> +		efc_log_debug(efct,
> +			       "PCI channel disable preparing for reset\n");
> +		efct_device_detach(efct);
> +		/* Disable interrupt and pci device */
> +		efct_teardown_msix(efct);
> +	}
> +	pci_disable_device(pdev);
> +}
> +
> +static void
> +efct_device_prep_for_recover(struct efct *efct)
> +{
> +	if (efct) {
> +		efc_log_debug(efct, "PCI channel preparing for recovery\n");
> +		efct_hw_io_abort_all(&efct->hw);
> +	}
> +}
> +
> +/**
> + * efct_pci_io_error_detected - method for handling PCI I/O error
> + * @pdev: pointer to PCI device.
> + * @state: the current PCI connection state.
> + *
> + * This routine is registered to the PCI subsystem for error handling. This
> + * function is called by the PCI subsystem after a PCI bus error affecting
> + * this device has been detected. When this routine is invoked, it dispatches
> + * device error detected handling routine, which will perform the proper
> + * error detected operation.
> + *
> + * Return codes
> + * PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
> + * PCI_ERS_RESULT_DISCONNECT - device could not be recovered
> + */
> +static pci_ers_result_t
> +efct_pci_io_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
> +{
> +	struct efct *efct = pci_get_drvdata(pdev);
> +	pci_ers_result_t rc;
> +
> +	switch (state) {
> +	case pci_channel_io_normal:
> +		efct_device_prep_for_recover(efct);
> +		rc = PCI_ERS_RESULT_CAN_RECOVER;
> +		break;
> +	case pci_channel_io_frozen:
> +		efct_device_prep_for_reset(efct, pdev);
> +		rc = PCI_ERS_RESULT_NEED_RESET;
> +		break;
> +	case pci_channel_io_perm_failure:
> +		efct_device_detach(efct);
> +		rc = PCI_ERS_RESULT_DISCONNECT;
> +		break;
> +	default:
> +		efc_log_debug(efct, "Unknown PCI error state:0x%x\n",
> +			       state);
> +		efct_device_prep_for_reset(efct, pdev);
> +		rc = PCI_ERS_RESULT_NEED_RESET;
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +static pci_ers_result_t
> +efct_pci_io_slot_reset(struct pci_dev *pdev)
> +{
> +	int rc;
> +	struct efct *efct = pci_get_drvdata(pdev);
> +
> +	rc = pci_enable_device_mem(pdev);
> +	if (rc) {
> +		efc_log_err(efct,
> +			     "failed to re-enable PCI device after reset.\n");
> +		return PCI_ERS_RESULT_DISCONNECT;
> +	}
> +
> +	/*
> +	 * As the new kernel behavior of pci_restore_state() API call clears
> +	 * device saved_state flag, need to save the restored state again.
> +	 */
> +
> +	pci_save_state(pdev);
> +
> +	pci_set_master(pdev);
> +
> +	rc = efct_setup_msix(efct, efct->n_msix_vec);
> +	if (rc)
> +		efc_log_err(efct, "rc %d returned, IRQ allocation failed\n",
> +			    rc);
> +
> +	/* Perform device reset */
> +	efct_device_detach(efct);
> +	/* Bring device to online*/
> +	efct_device_attach(efct);
> +
> +	return PCI_ERS_RESULT_RECOVERED;
> +}
> +
> +static void
> +efct_pci_io_resume(struct pci_dev *pdev)
> +{
> +	struct efct *efct = pci_get_drvdata(pdev);
> +
> +	/* Perform device reset */
> +	efct_device_detach(efct);
> +	/* Bring device to online*/
> +	efct_device_attach(efct);
> +}
> +
> +MODULE_DEVICE_TABLE(pci, efct_pci_table);
> +
> +static struct pci_error_handlers efct_pci_err_handler = {
> +	.error_detected = efct_pci_io_error_detected,
> +	.slot_reset = efct_pci_io_slot_reset,
> +	.resume = efct_pci_io_resume,
> +};
> +
> +static struct pci_driver efct_pci_driver = {
> +	.name		= EFCT_DRIVER_NAME,
> +	.id_table	= efct_pci_table,
> +	.probe		= efct_pci_probe,
> +	.remove		= efct_pci_remove,
> +	.err_handler	= &efct_pci_err_handler,
> +};
> +
> +static
> +int __init efct_init(void)
> +{
> +	int	rc = -ENODEV;
> +
> +	rc = efct_device_init();
> +	if (rc) {
> +		pr_err("efct_device_init failed rc=%d\n", rc);
> +		return -ENOMEM;
> +	}
> +
> +	rc = pci_register_driver(&efct_pci_driver);
> +	if (rc)
> +		goto l1;
> +
> +	return rc;
> +
> +l1:
> +	efct_device_shutdown();
> +	return rc;
> +}
> +
> +static void __exit efct_exit(void)
> +{
> +	pci_unregister_driver(&efct_pci_driver);
> +	efct_device_shutdown();
> +}
> +
> +module_init(efct_init);
> +module_exit(efct_exit);
> +MODULE_VERSION(EFCT_DRIVER_VERSION);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Broadcom");
> diff --git a/drivers/scsi/elx/efct/efct_driver.h b/drivers/scsi/elx/efct/efct_driver.h
> new file mode 100644
> index 000000000000..07ca0b182d90
> --- /dev/null
> +++ b/drivers/scsi/elx/efct/efct_driver.h
> @@ -0,0 +1,142 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#if !defined(__EFCT_DRIVER_H__)
> +#define __EFCT_DRIVER_H__
> +
> +/***************************************************************************
> + * OS specific includes
> + */
> +#include <stdarg.h>
> +#include <linux/version.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/interrupt.h>
> +#include <asm-generic/ioctl.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/pci.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/bitmap.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <asm/byteorder.h>
> +#include <linux/timer.h>
> +#include <linux/delay.h>
> +#include <linux/fs.h>
> +#include <linux/uaccess.h>
> +#include <linux/sched.h>
> +#include <asm/current.h>
> +#include <asm/cacheflush.h>
> +#include <linux/pagemap.h>
> +#include <linux/kthread.h>
> +#include <linux/proc_fs.h>
> +#include <linux/seq_file.h>
> +#include <linux/random.h>
> +#include <linux/sched.h>
> +#include <linux/jiffies.h>
> +#include <linux/ctype.h>
> +#include <linux/debugfs.h>
> +#include <linux/firmware.h>
> +#include <linux/sched/signal.h>
> +#include "../include/efc_common.h"
> +
> +#define EFCT_DRIVER_NAME			"efct"
> +#define EFCT_DRIVER_VERSION			"1.0.0.0"
> +
> +/* EFCT_OS_MAX_ISR_TIME_MSEC -
> + * maximum time driver code should spend in an interrupt
> + * or kernel thread context without yielding
> + */
> +#define EFCT_OS_MAX_ISR_TIME_MSEC		1000
> +
> +#define EFCT_FC_MAX_SGL				64
> +#define EFCT_FC_DIF_SEED			0
> +
> +/* Timeouts */
> +#define EFCT_FC_ELS_SEND_DEFAULT_TIMEOUT	0
> +#define EFCT_FC_ELS_DEFAULT_RETRIES		3
> +#define EFCT_FC_FLOGI_TIMEOUT_SEC		5
> +#define EFCT_FC_DOMAIN_SHUTDOWN_TIMEOUT_USEC    30000000 /* 30 seconds */
> +
> +/* Watermark */
> +#define EFCT_WATERMARK_HIGH_PCT			90
> +#define EFCT_WATERMARK_LOW_PCT			80
> +#define EFCT_IO_WATERMARK_PER_INITIATOR		8
> +
> +#include "../libefc/efclib.h"
> +#include "efct_hw.h"
> +#include "efct_io.h"
> +#include "efct_xport.h"
> +
> +#define EFCT_PCI_MAX_REGS			6
> +#define MAX_PCI_INTERRUPTS			16
> +
> +struct efct_intr_context {
> +	struct efct		*efct;
> +	u32			index;
> +};
> +
> +struct efct {
> +	struct pci_dev			*pcidev;
> +	void __iomem			*reg[EFCT_PCI_MAX_REGS];
> +
> +	u32				n_msix_vec;
> +	struct efct_intr_context	intr_context[MAX_PCI_INTERRUPTS];
> +	u32				numa_node;
> +
> +	char				name[EFC_NAME_LENGTH];
> +	bool				attached;
> +	struct efct_scsi_tgt		tgt_efct;
> +	struct efct_xport		*xport;
> +	struct efc			*efcport;
> +	struct Scsi_Host		*shost;
> +	int				logmask;
> +	u32				max_isr_time_msec;
> +
> +	const char			*desc;
> +	u32				instance_index;
> +
> +	const char			*model;
> +
> +	struct efct_hw			hw;
> +
> +	u32				num_vports;
> +	u32				rq_selection_policy;
> +	char				*filter_def;
> +
> +	bool				soft_wwn_enable;
> +
> +	/*
> +	 * Target IO timer value:
> +	 * Zero: target command timeout disabled.
> +	 * Non-zero: Timeout value, in seconds, for target commands
> +	 */
> +	u32				target_io_timer_sec;
> +
> +	int				speed;
> +	int				topology;
> +
> +	u8				efct_req_fw_upgrade;
> +	u16				sw_feature_cap;
> +	struct dentry			*sess_debugfs_dir;
> +};
> +
> +#define FW_WRITE_BUFSIZE		(64 * 1024)
> +
> +struct efct_fw_write_result {
> +	struct completion done;
> +	int status;
> +	u32 actual_xfer;
> +	u32 change_status;
> +};
> +
> +#define MAX_EFCT_DEVICES		64
> +extern struct efct			*efct_devices[MAX_EFCT_DEVICES];
> +
> +#endif /* __EFCT_DRIVER_H__ */
> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
> new file mode 100644
> index 000000000000..21fcaf7b3d2b
> --- /dev/null
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -0,0 +1,1116 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include "efct_driver.h"
> +#include "efct_hw.h"
> +
> +static enum efct_hw_rtn
> +efct_hw_link_event_init(struct efct_hw *hw)
> +{
> +	hw->link.status = SLI_LINK_STATUS_MAX;
> +	hw->link.topology = SLI_LINK_TOPO_NONE;
> +	hw->link.medium = SLI_LINK_MEDIUM_MAX;
> +	hw->link.speed = 0;
> +	hw->link.loop_map = NULL;
> +	hw->link.fc_id = U32_MAX;
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +
> +static enum efct_hw_rtn
> +efct_hw_read_max_dump_size(struct efct_hw *hw)
> +{
> +	u8	buf[SLI4_BMBX_SIZE];
> +	struct efct *efct = hw->os;
> +	int	rc = EFCT_HW_RTN_SUCCESS;
> +	struct sli4_rsp_cmn_set_dump_location *rsp;
> +
> +	/* attempt to detemine the dump size for function 0 only. */
> +	if (PCI_FUNC(efct->pcidev->devfn) != 0)
> +		return rc;
> +
> +	rc = sli_cmd_common_set_dump_location(&hw->sli, buf, SLI4_BMBX_SIZE, 1,
> +					     0,	NULL, 0);
> +	if (rc)
> +		return rc;
> +
> +	rsp = (struct sli4_rsp_cmn_set_dump_location *)
> +	      (buf + offsetof(struct sli4_cmd_sli_config, payload.embed));
> +
> +	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
> +	if (rc != EFCT_HW_RTN_SUCCESS) {
> +		efc_log_test(hw->os, "set dump location cmd failed\n");
> +		return rc;
> +	}
> +	hw->dump_size =	(le32_to_cpu(rsp->buffer_length_dword) &
> +			 SLI4_CMN_SET_DUMP_BUFFER_LEN);
> +	efc_log_debug(hw->os, "Dump size %x\n",	hw->dump_size);
> +
> +	return rc;
> +}
> +
> +static int
> +__efct_read_topology_cb(struct efct_hw *hw, int status,
> +			u8 *mqe, void *arg)
> +{
> +	struct sli4_cmd_read_topology *read_topo =
> +				(struct sli4_cmd_read_topology *)mqe;
> +	u8 speed;
> +	struct efc_domain_record drec = {0};
> +	struct efct *efct = hw->os;
> +
> +	if (status || le16_to_cpu(read_topo->hdr.status)) {
> +		efc_log_debug(hw->os, "bad status cqe=%#x mqe=%#x\n",
> +			       status,
> +			       le16_to_cpu(read_topo->hdr.status));
> +		kfree(mqe);
> +		return EFC_FAIL;
> +	}
> +
> +	switch (le32_to_cpu(read_topo->dw2_attentype) &
> +		SLI4_READTOPO_ATTEN_TYPE) {
> +	case SLI4_READ_TOPOLOGY_LINK_UP:
> +		hw->link.status = SLI_LINK_STATUS_UP;
> +		break;
> +	case SLI4_READ_TOPOLOGY_LINK_DOWN:
> +		hw->link.status = SLI_LINK_STATUS_DOWN;
> +		break;
> +	case SLI4_READ_TOPOLOGY_LINK_NO_ALPA:
> +		hw->link.status = SLI_LINK_STATUS_NO_ALPA;
> +		break;
> +	default:
> +		hw->link.status = SLI_LINK_STATUS_MAX;
> +		break;
> +	}
> +
> +	switch (read_topo->topology) {
> +	case SLI4_READ_TOPOLOGY_NPORT:
> +		hw->link.topology = SLI_LINK_TOPO_NPORT;
> +		break;
> +	case SLI4_READ_TOPOLOGY_FC_AL:
> +		hw->link.topology = SLI_LINK_TOPO_LOOP;
> +		if (hw->link.status == SLI_LINK_STATUS_UP)
> +			hw->link.loop_map = hw->loop_map.virt;
> +		hw->link.fc_id = read_topo->acquired_al_pa;
> +		break;
> +	default:
> +		hw->link.topology = SLI_LINK_TOPO_MAX;
> +		break;
> +	}
> +
> +	hw->link.medium = SLI_LINK_MEDIUM_FC;
> +
> +	speed = (le32_to_cpu(read_topo->currlink_state) &
> +		 SLI4_READTOPO_LINKSTATE_SPEED) >> 8;
> +	switch (speed) {
> +	case SLI4_READ_TOPOLOGY_SPEED_1G:
> +		hw->link.speed =  1 * 1000;
> +		break;
> +	case SLI4_READ_TOPOLOGY_SPEED_2G:
> +		hw->link.speed =  2 * 1000;
> +		break;
> +	case SLI4_READ_TOPOLOGY_SPEED_4G:
> +		hw->link.speed =  4 * 1000;
> +		break;
> +	case SLI4_READ_TOPOLOGY_SPEED_8G:
> +		hw->link.speed =  8 * 1000;
> +		break;
> +	case SLI4_READ_TOPOLOGY_SPEED_16G:
> +		hw->link.speed = 16 * 1000;
> +		hw->link.loop_map = NULL;
> +		break;
> +	case SLI4_READ_TOPOLOGY_SPEED_32G:
> +		hw->link.speed = 32 * 1000;
> +		hw->link.loop_map = NULL;
> +		break;
> +	}
> +
> +	kfree(mqe);
> +
> +	drec.speed = hw->link.speed;
> +	drec.fc_id = hw->link.fc_id;
> +	drec.is_nport = true;
> +	efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_FOUND, &drec);
> +
> +	return EFC_SUCCESS;
> +}
> +
> +/* Callback function for the SLI link events */
> +static int
> +efct_hw_cb_link(void *ctx, void *e)
> +{
> +	struct efct_hw	*hw = ctx;
> +	struct sli4_link_event *event = e;
> +	struct efc_domain	*d = NULL;
> +	int		rc = EFCT_HW_RTN_ERROR;
> +	struct efct	*efct = hw->os;
> +	struct efc_dma *dma;
> +
> +	efct_hw_link_event_init(hw);
> +
> +	switch (event->status) {
> +	case SLI_LINK_STATUS_UP:
> +
> +		hw->link = *event;
> +		efct->efcport->link_status = EFC_LINK_STATUS_UP;
> +
> +		if (event->topology == SLI_LINK_TOPO_NPORT) {
> +			struct efc_domain_record drec = {0};
> +
> +			efc_log_info(hw->os, "Link Up, NPORT, speed is %d\n",
> +				      event->speed);
> +			drec.speed = event->speed;
> +			drec.fc_id = event->fc_id;
> +			drec.is_nport = true;
> +			efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_FOUND,
> +				      &drec);
> +		} else if (event->topology == SLI_LINK_TOPO_LOOP) {
> +			u8	*buf = NULL;
> +
> +			efc_log_info(hw->os, "Link Up, LOOP, speed is %d\n",
> +				      event->speed);
> +			dma = &hw->loop_map;
> +			dma->size = SLI4_MIN_LOOP_MAP_BYTES;
> +			dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
> +						       dma->size, &dma->phys,
> +						       GFP_DMA);
> +			if (!dma->virt)
> +				efc_log_err(hw->os, "efct_dma_alloc_fail\n");
> +
> +			buf = kmalloc(SLI4_BMBX_SIZE, GFP_ATOMIC);
> +			if (!buf)
> +				break;
> +
> +			if (!sli_cmd_read_topology(&hw->sli, buf,
> +						  SLI4_BMBX_SIZE,
> +						       &hw->loop_map)) {
> +				rc = efct_hw_command(hw, buf, EFCT_CMD_NOWAIT,
> +						     __efct_read_topology_cb,
> +						     NULL);
> +			}
> +

Not sure if this is a good idea; we'll have to allocate extra memory 
whenever the loop topology changes.
Which typically happens when there had been a failure somewhere, and 
chances are that it'll affect our root fs, making memory allocation 
something we really need to look at.
Can't we pre-allocate a buffer here somewhere in the global 
initialisation so that we don't have to allocate it every time?

> +			if (rc != EFCT_HW_RTN_SUCCESS) {
> +				efc_log_test(hw->os, "READ_TOPOLOGY failed\n");
> +				kfree(buf);
> +			}
> +		} else {
> +			efc_log_info(hw->os, "%s(%#x), speed is %d\n",
> +				      "Link Up, unsupported topology ",
> +				     event->topology, event->speed);
> +		}
> +		break;
> +	case SLI_LINK_STATUS_DOWN:
> +		efc_log_info(hw->os, "Link down\n");
> +
> +		hw->link.status = event->status;
> +		efct->efcport->link_status = EFC_LINK_STATUS_DOWN;
> +
> +		d = hw->domain;
> +		if (d)
> +			efc_domain_cb(efct->efcport, EFC_HW_DOMAIN_LOST, d);
> +		break;
> +	default:
> +		efc_log_test(hw->os, "unhandled link status %#x\n",
> +			      event->status);
> +		break;
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev)
> +{
> +	u32 i, max_sgl;
> +
> +	if (hw->hw_setup_called)
> +		return EFCT_HW_RTN_SUCCESS;
> +
> +	/*
> +	 * efct_hw_init() relies on NULL pointers indicating that a structure
> +	 * needs allocation. If a structure is non-NULL, efct_hw_init() won't
> +	 * free/realloc that memory
> +	 */
> +	memset(hw, 0, sizeof(struct efct_hw));
> +
> +	hw->hw_setup_called = true;
> +
> +	hw->os = os;
> +
> +	spin_lock_init(&hw->cmd_lock);
> +	INIT_LIST_HEAD(&hw->cmd_head);
> +	INIT_LIST_HEAD(&hw->cmd_pending);
> +	hw->cmd_head_count = 0;
> +
> +	spin_lock_init(&hw->io_lock);
> +	spin_lock_init(&hw->io_abort_lock);
> +
> +	atomic_set(&hw->io_alloc_failed_count, 0);
> +
> +	hw->config.speed = FC_LINK_SPEED_AUTO_16_8_4;
> +	if (sli_setup(&hw->sli, hw->os, pdev, ((struct efct *)os)->reg)) {
> +		efc_log_err(hw->os, "SLI setup failed\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	efct_hw_link_event_init(hw);
> +
> +	sli_callback(&hw->sli, SLI4_CB_LINK, efct_hw_cb_link, hw);
> +
> +	/*
> +	 * Set all the queue sizes to the maximum allowed.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(hw->num_qentries); i++)
> +		hw->num_qentries[i] = hw->sli.qinfo.max_qentries[i];
> +	/*
> +	 * Adjust the the size of the WQs so that the CQ is twice as
> +	 * big as the WQ to allow for 2 completions per IO. This allows us to
> +	 * handle multi-phase as well as aborts.
> +	 */
> +	hw->num_qentries[SLI_QTYPE_WQ] = hw->num_qentries[SLI_QTYPE_CQ] / 2;
> +
> +	/*
> +	 * The RQ assignment for RQ pair mode.
> +	 */
> +	hw->config.rq_default_buffer_size = EFCT_HW_RQ_SIZE_PAYLOAD;
> +	hw->config.n_io = hw->sli.extent[SLI_RSRC_XRI].size;
> +	hw->config.n_eq = EFCT_HW_DEF_NUM_EQ;
> +
> +	max_sgl = sli_get_max_sgl(&hw->sli) - SLI4_SGE_MAX_RESERVED;
> +	max_sgl = (max_sgl > EFCT_FC_MAX_SGL) ? EFCT_FC_MAX_SGL : max_sgl;
> +	hw->config.n_sgl = max_sgl;
> +
> +	(void)efct_hw_read_max_dump_size(hw);
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +
> +static void
> +efct_logfcfi(struct efct_hw *hw, u32 j, u32 i, u32 id)
> +{
> +	efc_log_info(hw->os,
> +		      "REG_FCFI: filter[%d] %08X -> RQ[%d] id=%d\n",
> +		     j, hw->config.filter_def[j], i, id);
> +}
> +
> +static inline void
> +efct_hw_init_free_io(struct efct_hw_io *io)
> +{
> +	/*
> +	 * Set io->done to NULL, to avoid any callbacks, should
> +	 * a completion be received for one of these IOs
> +	 */
> +	io->done = NULL;
> +	io->abort_done = NULL;
> +	io->status_saved = false;
> +	io->abort_in_progress = false;
> +	io->rnode = NULL;
> +	io->type = 0xFFFF;
> +	io->wq = NULL;
> +	io->ul_io = NULL;
> +	io->tgt_wqe_timeout = 0;
> +}
> +
> +static u8 efct_hw_iotype_is_originator(u16 io_type)
> +{
> +	switch (io_type) {
> +	case EFCT_HW_FC_CT:
> +	case EFCT_HW_ELS_REQ:
> +		return 1;
> +	default:
> +		return EFC_SUCCESS;
> +	}
> +}
> +
> +static void
> +efct_hw_io_restore_sgl(struct efct_hw *hw, struct efct_hw_io *io)
> +{
> +	/* Restore the default */
> +	io->sgl = &io->def_sgl;
> +	io->sgl_count = io->def_sgl_count;
> +
> +	/* Clear the overflow SGL */
> +	io->ovfl_sgl = NULL;
> +	io->ovfl_sgl_count = 0;
> +	io->ovfl_lsp = NULL;
> +}
> +
> +static void
> +efct_hw_wq_process_io(void *arg, u8 *cqe, int status)
> +{
> +	struct efct_hw_io *io = arg;
> +	struct efct_hw *hw = io->hw;
> +	struct sli4_fc_wcqe *wcqe = (void *)cqe;
> +	u32	len = 0;
> +	u32 ext = 0;
> +
> +	/* clear xbusy flag if WCQE[XB] is clear */
> +	if (io->xbusy && (wcqe->flags & SLI4_WCQE_XB) == 0)
> +		io->xbusy = false;
> +
> +	/* get extended CQE status */
> +	switch (io->type) {
> +	case EFCT_HW_BLS_ACC:
> +	case EFCT_HW_BLS_ACC_SID:
> +		break;
> +	case EFCT_HW_ELS_REQ:
> +		sli_fc_els_did(&hw->sli, cqe, &ext);
> +		len = sli_fc_response_length(&hw->sli, cqe);
> +		break;
> +	case EFCT_HW_ELS_RSP:
> +	case EFCT_HW_ELS_RSP_SID:
> +	case EFCT_HW_FC_CT_RSP:
> +		break;
> +	case EFCT_HW_FC_CT:
> +		len = sli_fc_response_length(&hw->sli, cqe);
> +		break;
> +	case EFCT_HW_IO_TARGET_WRITE:
> +		len = sli_fc_io_length(&hw->sli, cqe);
> +		break;
> +	case EFCT_HW_IO_TARGET_READ:
> +		len = sli_fc_io_length(&hw->sli, cqe);
> +		break;
> +	case EFCT_HW_IO_TARGET_RSP:
> +		break;
> +	case EFCT_HW_IO_DNRX_REQUEUE:
> +		/* release the count for re-posting the buffer */
> +		/* efct_hw_io_free(hw, io); */
> +		break;
> +	default:
> +		efc_log_test(hw->os, "unhandled io type %#x for XRI 0x%x\n",
> +			      io->type, io->indicator);
> +		break;
> +	}
> +	if (status) {
> +		ext = sli_fc_ext_status(&hw->sli, cqe);
> +		/*
> +		 * If we're not an originator IO, and XB is set, then issue
> +		 * abort for the IO from within the HW
> +		 */
> +		if ((!efct_hw_iotype_is_originator(io->type)) &&
> +		    wcqe->flags & SLI4_WCQE_XB) {
> +			enum efct_hw_rtn rc;
> +
> +			efc_log_debug(hw->os, "aborting xri=%#x tag=%#x\n",
> +				       io->indicator, io->reqtag);
> +
> +			/*
> +			 * Because targets may send a response when the IO
> +			 * completes using the same XRI, we must wait for the
> +			 * XRI_ABORTED CQE to issue the IO callback
> +			 */
> +			rc = efct_hw_io_abort(hw, io, false, NULL, NULL);
> +			if (rc == EFCT_HW_RTN_SUCCESS) {
> +				/*
> +				 * latch status to return after abort is
> +				 * complete
> +				 */
> +				io->status_saved = true;
> +				io->saved_status = status;
> +				io->saved_ext = ext;
> +				io->saved_len = len;
> +				goto exit_efct_hw_wq_process_io;
> +			} else if (rc == EFCT_HW_RTN_IO_ABORT_IN_PROGRESS) {
> +				/*
> +				 * Already being aborted by someone else (ABTS
> +				 * perhaps). Just fall thru and return original
> +				 * error.
> +				 */
> +				efc_log_debug(hw->os, "%s%#x tag=%#x\n",
> +					       "abort in progress xri=",
> +					      io->indicator, io->reqtag);
> +
> +			} else {
> +				/* Failed to abort for some other reason, log
> +				 * error
> +				 */
> +				efc_log_test(hw->os, "%s%#x tag=%#x rc=%d\n",
> +					      "Failed to abort xri=",
> +					     io->indicator, io->reqtag, rc);
> +			}
> +		}
> +	}
> +
> +	if (io->done) {
> +		efct_hw_done_t done = io->done;
> +		void *arg = io->arg;
> +
> +		io->done = NULL;
> +
> +		if (io->status_saved) {
> +			/* use latched status if exists */
> +			status = io->saved_status;
> +			len = io->saved_len;
> +			ext = io->saved_ext;
> +			io->status_saved = false;
> +		}
> +
> +		/* Restore default SGL */
> +		efct_hw_io_restore_sgl(hw, io);
> +		done(io, io->rnode, len, status, ext, arg);
> +	}
> +
> +exit_efct_hw_wq_process_io:
> +	return;
> +}
> +
> +/* Initialize the pool of HW IO objects */
> +static enum efct_hw_rtn
> +efct_hw_setup_io(struct efct_hw *hw)
> +{
> +	u32	i = 0;
> +	struct efct_hw_io	*io = NULL;
> +	uintptr_t	xfer_virt = 0;
> +	uintptr_t	xfer_phys = 0;
> +	u32	index;
> +	bool new_alloc = true;
> +	struct efc_dma *dma;
> +	struct efct *efct = hw->os;
> +
> +	if (!hw->io) {
> +		hw->io = kmalloc_array(hw->config.n_io, sizeof(io),
> +				 GFP_KERNEL);
> +
> +		if (!hw->io)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		memset(hw->io, 0, hw->config.n_io * sizeof(io));
> +
> +		for (i = 0; i < hw->config.n_io; i++) {
> +			hw->io[i] = kmalloc(sizeof(*io), GFP_KERNEL);
> +			if (!hw->io[i])
> +				goto error;
> +
> +			memset(hw->io[i], 0, sizeof(struct efct_hw_io));
> +		}
> +
> +		/* Create WQE buffs for IO */
> +		hw->wqe_buffs = kmalloc((hw->config.n_io *
> +					     hw->sli.wqe_size),
> +					     GFP_ATOMIC);
> +		if (!hw->wqe_buffs) {
> +			kfree(hw->io);
> +			return EFCT_HW_RTN_NO_MEMORY;
> +		}
> +		memset(hw->wqe_buffs, 0, (hw->config.n_io *
> +					hw->sli.wqe_size));
> +
> +	} else {
> +		/* re-use existing IOs, including SGLs */
> +		new_alloc = false;
> +	}
> +
> +	if (new_alloc) {
> +		dma = &hw->xfer_rdy;
> +		dma->size = sizeof(struct fcp_txrdy) * hw->config.n_io;
> +		dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
> +					       dma->size, &dma->phys, GFP_DMA);
> +		if (!dma->virt)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +	xfer_virt = (uintptr_t)hw->xfer_rdy.virt;
> +	xfer_phys = hw->xfer_rdy.phys;
> +
> +	for (i = 0; i < hw->config.n_io; i++) {
> +		struct hw_wq_callback *wqcb;
> +
> +		io = hw->io[i];
> +
> +		/* initialize IO fields */
> +		io->hw = hw;
> +
> +		/* Assign a WQE buff */
> +		io->wqe.wqebuf = &hw->wqe_buffs[i * hw->sli.wqe_size];
> +
> +		/* Allocate the request tag for this IO */
> +		wqcb = efct_hw_reqtag_alloc(hw, efct_hw_wq_process_io, io);
> +		if (!wqcb) {
> +			efc_log_err(hw->os, "can't allocate request tag\n");
> +			return EFCT_HW_RTN_NO_RESOURCES;
> +		}
> +		io->reqtag = wqcb->instance_index;
> +
> +		/* Now for the fields that are initialized on each free */
> +		efct_hw_init_free_io(io);
> +
> +		/* The XB flag isn't cleared on IO free, so init to zero */
> +		io->xbusy = 0;
> +
> +		if (sli_resource_alloc(&hw->sli, SLI_RSRC_XRI,
> +				       &io->indicator, &index)) {
> +			efc_log_err(hw->os,
> +				     "sli_resource_alloc failed @ %d\n", i);
> +			return EFCT_HW_RTN_NO_MEMORY;
> +		}
> +		if (new_alloc) {
> +			dma = &io->def_sgl;
> +			dma->size = hw->config.n_sgl *
> +					sizeof(struct sli4_sge);
> +			dma->virt = dma_alloc_coherent(&efct->pcidev->dev,
> +						       dma->size, &dma->phys,
> +						       GFP_DMA);
> +			if (!dma->virt) {
> +				efc_log_err(hw->os, "dma_alloc fail %d\n", i);
> +				memset(&io->def_sgl, 0,
> +				       sizeof(struct efc_dma));
> +				return EFCT_HW_RTN_NO_MEMORY;
> +			}
> +		}
> +		io->def_sgl_count = hw->config.n_sgl;
> +		io->sgl = &io->def_sgl;
> +		io->sgl_count = io->def_sgl_count;
> +
> +		if (hw->xfer_rdy.size) {
> +			io->xfer_rdy.virt = (void *)xfer_virt;
> +			io->xfer_rdy.phys = xfer_phys;
> +			io->xfer_rdy.size = sizeof(struct fcp_txrdy);
> +
> +			xfer_virt += sizeof(struct fcp_txrdy);
> +			xfer_phys += sizeof(struct fcp_txrdy);
> +		}
> +	}
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +error:
> +	for (i = 0; i < hw->config.n_io && hw->io[i]; i++) {
> +		kfree(hw->io[i]);
> +		hw->io[i] = NULL;
> +	}
> +
> +	kfree(hw->io);
> +	hw->io = NULL;
> +
> +	return EFCT_HW_RTN_NO_MEMORY;
> +}
> +
> +static enum efct_hw_rtn
> +efct_hw_init_io(struct efct_hw *hw)
> +{
> +	u32	i = 0, io_index = 0;
> +	bool prereg = false;
> +	struct efct_hw_io	*io = NULL;
> +	u8		cmd[SLI4_BMBX_SIZE];
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u32	nremaining;
> +	u32	n = 0;
> +	u32	sgls_per_request = 256;
> +	struct efc_dma	**sgls = NULL;
> +	struct efc_dma	reqbuf;
> +	struct efct *efct = hw->os;
> +
> +	prereg = hw->sli.sgl_pre_registered;
> +
> +	memset(&reqbuf, 0, sizeof(struct efc_dma));
> +	if (prereg) {
> +		sgls = kmalloc_array(sgls_per_request, sizeof(*sgls),
> +				     GFP_ATOMIC);
> +		if (!sgls)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		reqbuf.size = 32 + sgls_per_request * 16;
> +		reqbuf.virt = dma_alloc_coherent(&efct->pcidev->dev,
> +						 reqbuf.size, &reqbuf.phys,
> +						 GFP_DMA);
> +		if (!reqbuf.virt) {
> +			efc_log_err(hw->os, "dma_alloc reqbuf failed\n");
> +			kfree(sgls);
> +			return EFCT_HW_RTN_NO_MEMORY;
> +		}
> +	}
> +
> +	for (nremaining = hw->config.n_io; nremaining; nremaining -= n) {
> +		if (prereg) {
> +			/* Copy address of SGL's into local sgls[] array, break
> +			 * out if the xri is not contiguous.
> +			 */
> +			u32 min = (sgls_per_request < nremaining)
> +					? sgls_per_request : nremaining;
> +			for (n = 0; n < min; n++) {
> +				/* Check that we have contiguous xri values */
> +				if (n > 0) {
> +					if (hw->io[io_index + n]->indicator !=
> +					    hw->io[io_index + n - 1]->indicator
> +					    + 1)
> +						break;
> +				}
> +				sgls[n] = hw->io[io_index + n]->sgl;
> +			}
> +
> +			if (!sli_cmd_post_sgl_pages(&hw->sli, cmd,
> +						   sizeof(cmd),
> +						hw->io[io_index]->indicator,
> +						n, sgls, NULL, &reqbuf)) {
> +				if (efct_hw_command(hw, cmd, EFCT_CMD_POLL,
> +						    NULL, NULL)) {
> +					rc = EFCT_HW_RTN_ERROR;
> +					efc_log_err(hw->os,
> +						     "SGL post failed\n");
> +					break;
> +				}
> +			}
> +		} else {
> +			n = nremaining;
> +		}
> +
> +		/* Add to tail if successful */
> +		for (i = 0; i < n; i++, io_index++) {
> +			io = hw->io[io_index];
> +			io->state = EFCT_HW_IO_STATE_FREE;
> +			INIT_LIST_HEAD(&io->list_entry);
> +			list_add_tail(&io->list_entry, &hw->io_free);
> +		}
> +	}
> +
> +	if (prereg) {
> +		dma_free_coherent(&efct->pcidev->dev,
> +				  reqbuf.size, reqbuf.virt, reqbuf.phys);
> +		memset(&reqbuf, 0, sizeof(struct efc_dma));
> +		kfree(sgls);
> +	}
> +
> +	return rc;
> +}
> +
> +static enum efct_hw_rtn
> +efct_hw_config_set_fdt_xfer_hint(struct efct_hw *hw, u32 fdt_xfer_hint)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u8 buf[SLI4_BMBX_SIZE];
> +	struct sli4_rqst_cmn_set_features_set_fdt_xfer_hint param;
> +
> +	memset(&param, 0, sizeof(param));
> +	param.fdt_xfer_hint = cpu_to_le32(fdt_xfer_hint);
> +	/* build the set_features command */
> +	sli_cmd_common_set_features(&hw->sli, buf, SLI4_BMBX_SIZE,
> +				    SLI4_SET_FEATURES_SET_FTD_XFER_HINT,
> +				    sizeof(param),
> +				    &param);
> +
> +	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
> +	if (rc)
> +		efc_log_warn(hw->os, "set FDT hint %d failed: %d\n",
> +			      fdt_xfer_hint, rc);
> +	else
> +		efc_log_info(hw->os, "Set FTD transfer hint to %d\n",
> +			      le32_to_cpu(param.fdt_xfer_hint));
> +
> +	return rc;
> +}
> +
> +static int
> +efct_hw_config_rq(struct efct_hw *hw)
> +{
> +	u32 min_rq_count, i, rc;
> +	struct sli4_cmd_rq_cfg rq_cfg[SLI4_CMD_REG_FCFI_NUM_RQ_CFG];
> +	u8 buf[SLI4_BMBX_SIZE];
> +
> +	efc_log_info(hw->os, "using REG_FCFI standard\n");
> +
> +	/*
> +	 * Set the filter match/mask values from hw's
> +	 * filter_def values
> +	 */
> +	for (i = 0; i < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; i++) {
> +		rq_cfg[i].rq_id = cpu_to_le16(0xffff);
> +		rq_cfg[i].r_ctl_mask = (u8)hw->config.filter_def[i];
> +		rq_cfg[i].r_ctl_match = (u8)(hw->config.filter_def[i] >> 8);
> +		rq_cfg[i].type_mask = (u8)(hw->config.filter_def[i] >> 16);
> +		rq_cfg[i].type_match = (u8)(hw->config.filter_def[i] >> 24);
> +	}
> +
> +	/*
> +	 * Update the rq_id's of the FCF configuration
> +	 * (don't update more than the number of rq_cfg
> +	 * elements)
> +	 */
> +	min_rq_count = (hw->hw_rq_count < SLI4_CMD_REG_FCFI_NUM_RQ_CFG)	?
> +			hw->hw_rq_count : SLI4_CMD_REG_FCFI_NUM_RQ_CFG;
> +	for (i = 0; i < min_rq_count; i++) {
> +		struct hw_rq *rq = hw->hw_rq[i];
> +		u32 j;
> +
> +		for (j = 0; j < SLI4_CMD_REG_FCFI_NUM_RQ_CFG; j++) {
> +			u32 mask = (rq->filter_mask != 0) ?
> +				rq->filter_mask : 1;
> +
> +			if (!(mask & (1U << j)))
> +				continue;
> +
> +			rq_cfg[j].rq_id = cpu_to_le16(rq->hdr->id);
> +			efct_logfcfi(hw, j, i, rq->hdr->id);
> +		}
> +	}
> +
> +	rc = EFCT_HW_RTN_ERROR;
> +	if (!sli_cmd_reg_fcfi(&hw->sli, buf,
> +				SLI4_BMBX_SIZE, 0,
> +				rq_cfg)) {
> +		rc = efct_hw_command(hw, buf, EFCT_CMD_POLL,
> +				NULL, NULL);
> +	}
> +
> +	if (rc != EFCT_HW_RTN_SUCCESS) {
> +		efc_log_err(hw->os,
> +				"FCFI registration failed\n");
> +		return rc;
> +	}
> +	hw->fcf_indicator =
> +		le16_to_cpu(((struct sli4_cmd_reg_fcfi *)buf)->fcfi);
> +
> +	return rc;
> +}
> +
> +static void
> +efct_hw_queue_hash_add(struct efct_queue_hash *hash,
> +		       u16 id, u16 index)
> +{
> +	u32	hash_index = id & (EFCT_HW_Q_HASH_SIZE - 1);
> +
> +	/*
> +	 * Since the hash is always bigger than the number of queues, then we
> +	 * never have to worry about an infinite loop.
> +	 */
> +	while (hash[hash_index].in_use)
> +		hash_index = (hash_index + 1) & (EFCT_HW_Q_HASH_SIZE - 1);
> +
> +	/* not used, claim the entry */
> +	hash[hash_index].id = id;
> +	hash[hash_index].in_use = true;
> +	hash[hash_index].index = index;
> +}
> +
> +/* enable sli port health check */
> +static enum efct_hw_rtn
> +efct_hw_config_sli_port_health_check(struct efct_hw *hw, u8 query,
> +				     u8 enable)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	u8 buf[SLI4_BMBX_SIZE];
> +	struct sli4_rqst_cmn_set_features_health_check param;
> +	u32	health_check_flag = 0;
> +
> +	memset(&param, 0, sizeof(param));
> +
> +	if (enable)
> +		health_check_flag |= SLI4_RQ_HEALTH_CHECK_ENABLE;
> +
> +	if (query)
> +		health_check_flag |= SLI4_RQ_HEALTH_CHECK_QUERY;
> +
> +	param.health_check_dword = cpu_to_le32(health_check_flag);
> +
> +	/* build the set_features command */
> +	sli_cmd_common_set_features(&hw->sli, buf, SLI4_BMBX_SIZE,
> +				    SLI4_SET_FEATURES_SLI_PORT_HEALTH_CHECK,
> +				    sizeof(param),
> +				    &param);
> +
> +	rc = efct_hw_command(hw, buf, EFCT_CMD_POLL, NULL, NULL);
> +	if (rc)
> +		efc_log_err(hw->os, "efct_hw_command returns %d\n", rc);
> +	else
> +		efc_log_test(hw->os, "SLI Port Health Check is enabled\n");
> +
> +	return rc;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_init(struct efct_hw *hw)
> +{
> +	enum efct_hw_rtn rc;
> +	u32 i = 0;
> +	u32 max_rpi;
> +	int rem_count;
> +	unsigned long flags = 0;
> +	struct efct_hw_io *temp;
> +	struct sli4 *sli = &hw->sli;
> +	struct hw_rq *rq;
> +
> +	/*
> +	 * Make sure the command lists are empty. If this is start-of-day,
> +	 * they'll be empty since they were just initialized in efct_hw_setup.
> +	 * If we've just gone through a reset, the command and command pending
> +	 * lists should have been cleaned up as part of the reset
> +	 * (efct_hw_reset()).
> +	 */
> +	spin_lock_irqsave(&hw->cmd_lock, flags);
> +	if (!list_empty(&hw->cmd_head)) {
> +		efc_log_err(hw->os, "command found on cmd list\n");
> +		spin_unlock_irqrestore(&hw->cmd_lock, flags);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +	if (!list_empty(&hw->cmd_pending)) {
> +		efc_log_err(hw->os,
> +				"command found on pending list\n");
> +		spin_unlock_irqrestore(&hw->cmd_lock, flags);
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +	spin_unlock_irqrestore(&hw->cmd_lock, flags);
> +
> +	/* Free RQ buffers if prevously allocated */
> +	efct_hw_rx_free(hw);
> +
> +	/*
> +	 * The IO queues must be initialized here for the reset case. The
> +	 * efct_hw_init_io() function will re-add the IOs to the free list.
> +	 * The cmd_head list should be OK since we free all entries in
> +	 * efct_hw_command_cancel() that is called in the efct_hw_reset().
> +	 */
> +
> +	/* If we are in this function due to a reset, there may be stale items
> +	 * on lists that need to be removed.  Clean them up.
> +	 */
> +	rem_count = 0;
> +	if (hw->io_wait_free.next) {
> +		while ((!list_empty(&hw->io_wait_free))) {
> +			rem_count++;
> +			temp = list_first_entry(&hw->io_wait_free,
> +						struct efct_hw_io,
> +						list_entry);
> +			list_del(&temp->list_entry);
> +		}
> +		if (rem_count > 0) {
> +			efc_log_debug(hw->os,
> +				       "rmvd %d items from io_wait_free list\n",
> +				rem_count);
> +		}
> +	}
> +	rem_count = 0;
> +	if (hw->io_inuse.next) {
> +		while ((!list_empty(&hw->io_inuse))) {
> +			rem_count++;
> +			temp = list_first_entry(&hw->io_inuse,
> +						struct efct_hw_io,
> +						list_entry);
> +			list_del(&temp->list_entry);
> +		}
> +		if (rem_count > 0)
> +			efc_log_debug(hw->os,
> +				       "rmvd %d items from io_inuse list\n",
> +				       rem_count);
> +	}
> +	rem_count = 0;
> +	if (hw->io_free.next) {
> +		while ((!list_empty(&hw->io_free))) {
> +			rem_count++;
> +			temp = list_first_entry(&hw->io_free,
> +						struct efct_hw_io,
> +						list_entry);
> +			list_del(&temp->list_entry);
> +		}
> +		if (rem_count > 0)
> +			efc_log_debug(hw->os,
> +				       "rmvd %d items from io_free list\n",
> +				       rem_count);
> +	}
> +
> +	INIT_LIST_HEAD(&hw->io_inuse);
> +	INIT_LIST_HEAD(&hw->io_free);
> +	INIT_LIST_HEAD(&hw->io_wait_free);
> +
> +	/* If MRQ not required, Make sure we dont request feature. */
> +	hw->sli.features &= (~SLI4_REQFEAT_MRQP);
> +
> +	if (sli_init(&hw->sli)) {
> +		efc_log_err(hw->os, "SLI failed to initialize\n");
> +		return EFCT_HW_RTN_ERROR;
> +	}
> +
> +	if (hw->sliport_healthcheck) {
> +		rc = efct_hw_config_sli_port_health_check(hw, 0, 1);
> +		if (rc != EFCT_HW_RTN_SUCCESS) {
> +			efc_log_err(hw->os, "Enable port Health check fail\n");
> +			return rc;
> +		}
> +	}
> +
> +	/*
> +	 * Set FDT transfer hint, only works on Lancer
> +	 */
> +	if (hw->sli.if_type == SLI4_INTF_IF_TYPE_2) {
> +		/*
> +		 * Non-fatal error. In particular, we can disregard failure to
> +		 * set EFCT_HW_FDT_XFER_HINT on devices with legacy firmware
> +		 * that do not support EFCT_HW_FDT_XFER_HINT feature.
> +		 */
> +		efct_hw_config_set_fdt_xfer_hint(hw, EFCT_HW_FDT_XFER_HINT);
> +	}
> +
> +	/* zero the hashes */
> +	memset(hw->cq_hash, 0, sizeof(hw->cq_hash));
> +	efc_log_debug(hw->os, "Max CQs %d, hash size = %d\n",
> +		       EFCT_HW_MAX_NUM_CQ, EFCT_HW_Q_HASH_SIZE);
> +
> +	memset(hw->rq_hash, 0, sizeof(hw->rq_hash));
> +	efc_log_debug(hw->os, "Max RQs %d, hash size = %d\n",
> +		       EFCT_HW_MAX_NUM_RQ, EFCT_HW_Q_HASH_SIZE);
> +
> +	memset(hw->wq_hash, 0, sizeof(hw->wq_hash));
> +	efc_log_debug(hw->os, "Max WQs %d, hash size = %d\n",
> +		       EFCT_HW_MAX_NUM_WQ, EFCT_HW_Q_HASH_SIZE);
> +
> +	rc = efct_hw_init_queues(hw);
> +	if (rc != EFCT_HW_RTN_SUCCESS)
> +		return rc;
> +
> +	/* Allocate and post RQ buffers */
> +	rc = efct_hw_rx_allocate(hw);
> +	if (rc) {
> +		efc_log_err(hw->os, "rx_allocate failed\n");
> +		return rc;
> +	}
> +
> +	rc = efct_hw_rx_post(hw);
> +	if (rc) {
> +		efc_log_err(hw->os, "WARNING - error posting RQ buffers\n");
> +		return rc;
> +	}
> +
> +	max_rpi = sli->extent[SLI_RSRC_RPI].size;
> +	/* Allocate rpi_ref if not previously allocated */
> +	if (!hw->rpi_ref) {
> +		hw->rpi_ref = kmalloc_array(max_rpi, sizeof(*hw->rpi_ref),
> +				      GFP_KERNEL);
> +		if (!hw->rpi_ref)
> +			return EFCT_HW_RTN_NO_MEMORY;
> +
> +		memset(hw->rpi_ref, 0, max_rpi * sizeof(*hw->rpi_ref));
> +	}
> +
> +	for (i = 0; i < max_rpi; i++) {
> +		atomic_set(&hw->rpi_ref[i].rpi_count, 0);
> +		atomic_set(&hw->rpi_ref[i].rpi_attached, 0);
> +	}
> +
> +	rc = efct_hw_config_rq(hw);
> +	if (rc) {
> +		efc_log_err(hw->os, "efct_hw_config_rq failed %d\n", rc);
> +		return rc;
> +	}
> +
> +	/*
> +	 * Allocate the WQ request tag pool, if not previously allocated
> +	 * (the request tag value is 16 bits, thus the pool allocation size
> +	 * of 64k)
> +	 */
> +	hw->wq_reqtag_pool = efct_hw_reqtag_pool_alloc(hw);
> +	if (!hw->wq_reqtag_pool) {
> +		efc_log_err(hw->os, "efct_hw_reqtag_init failed %d\n", rc);
> +		return rc;
> +	}
> +
> +	rc = efct_hw_setup_io(hw);
> +	if (rc) {
> +		efc_log_err(hw->os, "IO allocation failure\n");
> +		return rc;
> +	}
> +
> +	rc = efct_hw_init_io(hw);
> +	if (rc) {
> +		efc_log_err(hw->os, "IO initialization failure\n");
> +		return rc;
> +	}
> +
> +	/*
> +	 * Arming the EQ allows (e.g.) interrupts when CQ completions write EQ
> +	 * entries
> +	 */
> +	for (i = 0; i < hw->eq_count; i++)
> +		sli_queue_arm(&hw->sli, &hw->eq[i], true);
> +
> +	/*
> +	 * Initialize RQ hash
> +	 */
> +	for (i = 0; i < hw->rq_count; i++)
> +		efct_hw_queue_hash_add(hw->rq_hash, hw->rq[i].id, i);
> +
> +	/*
> +	 * Initialize WQ hash
> +	 */
> +	for (i = 0; i < hw->wq_count; i++)
> +		efct_hw_queue_hash_add(hw->wq_hash, hw->wq[i].id, i);
> +
> +	/*
> +	 * Arming the CQ allows (e.g.) MQ completions to write CQ entries
> +	 */
> +	for (i = 0; i < hw->cq_count; i++) {
> +		efct_hw_queue_hash_add(hw->cq_hash, hw->cq[i].id, i);
> +		sli_queue_arm(&hw->sli, &hw->cq[i], true);
> +	}
> +
> +	/* Set RQ process limit*/
> +	for (i = 0; i < hw->hw_rq_count; i++) {
> +		rq = hw->hw_rq[i];
> +		hw->cq[rq->cq->instance].proc_limit = hw->config.n_io / 2;
> +	}
> +
> +	/* record the fact that the queues are functional */
> +	hw->state = EFCT_HW_STATE_ACTIVE;
> +	/*
> +	 * Allocate a HW IOs for send frame.
> +	 */
> +	hw->hw_wq[0]->send_frame_io = efct_hw_io_alloc(hw);
> +	if (!hw->hw_wq[0]->send_frame_io)
> +		efc_log_err(hw->os, "alloc for send_frame_io failed\n");
> +
> +	/* Initialize send frame frame sequence id */
> +	atomic_set(&hw->send_frame_seq_id, 0);
> +
> +	return EFCT_HW_RTN_SUCCESS;
> +}
> +
> +enum efct_hw_rtn
> +efct_hw_parse_filter(struct efct_hw *hw, void *value)
> +{
> +	enum efct_hw_rtn rc = EFCT_HW_RTN_SUCCESS;
> +	char *p = NULL;
> +	char *token;
> +	u32 idx = 0;
> +
> +	for (idx = 0; idx < ARRAY_SIZE(hw->config.filter_def); idx++)
> +		hw->config.filter_def[idx] = 0;
> +
> +	p = kstrdup(value, GFP_KERNEL);
> +	if (!p || !*p) {
> +		efc_log_err(hw->os, "p is NULL\n");
> +		return EFCT_HW_RTN_NO_MEMORY;
> +	}
> +
> +	idx = 0;
> +	while ((token = strsep(&p, ",")) && *token) {
> +		if (kstrtou32(token, 0, &hw->config.filter_def[idx++]))
> +			efc_log_err(hw->os, "kstrtoint failed\n");
> +
> +		if (!p || !*p)
> +			break;
> +
> +		if (idx == ARRAY_SIZE(hw->config.filter_def))
> +			break;
> +	}
> +	kfree(p);
> +
> +	return rc;
> +}
> +
> +u64
> +efct_get_wwnn(struct efct_hw *hw)
> +{
> +	struct sli4 *sli = &hw->sli;
> +	u8 p[8];
> +
> +	memcpy(p, sli->wwnn, sizeof(p));
> +	return get_unaligned_be64(p);
> +}
> +
> +u64
> +efct_get_wwpn(struct efct_hw *hw)
> +{
> +	struct sli4 *sli = &hw->sli;
> +	u8 p[8];
> +
> +	memcpy(p, sli->wwpn, sizeof(p));
> +	return get_unaligned_be64(p);
> +}
> diff --git a/drivers/scsi/elx/efct/efct_hw.h b/drivers/scsi/elx/efct/efct_hw.h
> index b3d4d4bc8d8c..e5839254c730 100644
> --- a/drivers/scsi/elx/efct/efct_hw.h
> +++ b/drivers/scsi/elx/efct/efct_hw.h
> @@ -614,4 +614,19 @@ struct efct_hw_grp_hdr {
>   	u8			revision[32];
>   };
>   
> +static inline int
> +efct_hw_get_link_speed(struct efct_hw *hw) {
> +	return hw->link.speed;
> +}
> +
> +extern enum efct_hw_rtn
> +efct_hw_setup(struct efct_hw *hw, void *os, struct pci_dev *pdev);
> +enum efct_hw_rtn efct_hw_init(struct efct_hw *hw);
> +extern enum efct_hw_rtn
> +efct_hw_parse_filter(struct efct_hw *hw, void *value);
> +extern uint64_t
> +efct_get_wwnn(struct efct_hw *hw);
> +extern uint64_t
> +efct_get_wwpn(struct efct_hw *hw);
> +
>   #endif /* __EFCT_H__ */
> diff --git a/drivers/scsi/elx/efct/efct_xport.c b/drivers/scsi/elx/efct/efct_xport.c
> new file mode 100644
> index 000000000000..b683208d396f
> --- /dev/null
> +++ b/drivers/scsi/elx/efct/efct_xport.c
> @@ -0,0 +1,523 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2019 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include "efct_driver.h"
> +#include "efct_unsol.h"
> +
> +/* Post node event callback argument. */
> +struct efct_xport_post_node_event {
> +	struct completion done;
> +	atomic_t refcnt;
> +	struct efc_node *node;
> +	u32	evt;
> +	void *context;
> +};
> +
> +static struct dentry *efct_debugfs_root;
> +static atomic_t efct_debugfs_count;
> +
> +static struct scsi_host_template efct_template = {
> +	.module			= THIS_MODULE,
> +	.name			= EFCT_DRIVER_NAME,
> +	.supported_mode		= MODE_TARGET,
> +};
> +
> +/* globals */
> +static struct fc_function_template efct_xport_functions;
> +static struct fc_function_template efct_vport_functions;
> +
> +static struct scsi_transport_template *efct_xport_fc_tt;
> +static struct scsi_transport_template *efct_vport_fc_tt;
> +
> +/*
> + * transport object is allocated,
> + * and associated with a device instance
> + */
> +struct efct_xport *
> +efct_xport_alloc(struct efct *efct)
> +{
> +	struct efct_xport *xport;
> +
> +	xport = kmalloc(sizeof(*xport), GFP_KERNEL);
> +	if (!xport)
> +		return xport;
> +
> +	memset(xport, 0, sizeof(*xport));
> +	xport->efct = efct;
> +	return xport;
> +}
> +
> +static int
> +efct_xport_init_debugfs(struct efct *efct)
> +{
> +	/* Setup efct debugfs root directory */
> +	if (!efct_debugfs_root) {
> +		efct_debugfs_root = debugfs_create_dir("efct", NULL);
> +		atomic_set(&efct_debugfs_count, 0);
> +		if (!efct_debugfs_root) {
> +			efc_log_err(efct, "failed to create debugfs entry\n");
> +			goto debugfs_fail;
> +		}
> +	}
> +
> +	/* Create a directory for sessions in root */
> +	if (!efct->sess_debugfs_dir) {
> +		efct->sess_debugfs_dir = debugfs_create_dir("sessions", NULL);
> +		if (!efct->sess_debugfs_dir) {
> +			efc_log_err(efct,
> +				     "failed to create debugfs entry for sessions\n");
> +			goto debugfs_fail;
> +		}
> +		atomic_inc(&efct_debugfs_count);
> +	}
> +
> +	return EFC_SUCCESS;
> +
> +debugfs_fail:
> +	return EFC_FAIL;
> +}
> +
> +static void efct_xport_delete_debugfs(struct efct *efct)
> +{
> +	/* Remove session debugfs directory */
> +	debugfs_remove(efct->sess_debugfs_dir);
> +	efct->sess_debugfs_dir = NULL;
> +	atomic_dec(&efct_debugfs_count);
> +
> +	if (atomic_read(&efct_debugfs_count) == 0) {
> +		/* remove root debugfs directory */
> +		debugfs_remove(efct_debugfs_root);
> +		efct_debugfs_root = NULL;
> +	}
> +}
> +
> +int
> +efct_xport_attach(struct efct_xport *xport)
> +{
> +	struct efct *efct = xport->efct;
> +	int rc;
> +
> +	xport->fcfi.hold_frames = true;
> +	spin_lock_init(&xport->fcfi.pend_frames_lock);
> +	INIT_LIST_HEAD(&xport->fcfi.pend_frames);
> +
> +	rc = efct_hw_setup(&efct->hw, efct, efct->pcidev);
> +	if (rc) {
> +		efc_log_err(efct, "%s: Can't setup hardware\n", efct->desc);
> +		return rc;
> +	}
> +
> +	efct_hw_parse_filter(&efct->hw, (void *)efct->filter_def);
> +
> +	xport->io_pool = efct_io_pool_create(efct, efct->hw.config.n_sgl);
> +	if (!xport->io_pool) {
> +		efc_log_err(efct, "Can't allocate IO pool\n");
> +		return -ENOMEM;
> +	}
> +
> +	return EFC_SUCCESS;
> +}
> +
> +static void
> +efct_xport_link_stats_cb(int status, u32 num_counters,
> +			 struct efct_hw_link_stat_counts *counters, void *arg)
> +{
> +	union efct_xport_stats_u *result = arg;
> +
> +	result->stats.link_stats.link_failure_error_count =
> +		counters[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter;
> +	result->stats.link_stats.loss_of_sync_error_count =
> +		counters[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter;
> +	result->stats.link_stats.primitive_sequence_error_count =
> +		counters[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter;
> +	result->stats.link_stats.invalid_transmission_word_error_count =
> +		counters[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter;
> +	result->stats.link_stats.crc_error_count =
> +		counters[EFCT_HW_LINK_STAT_CRC_COUNT].counter;
> +
> +	complete(&result->stats.done);
> +}
> +
> +static void
> +efct_xport_host_stats_cb(int status, u32 num_counters,
> +			 struct efct_hw_host_stat_counts *counters, void *arg)
> +{
> +	union efct_xport_stats_u *result = arg;
> +
> +	result->stats.host_stats.transmit_kbyte_count =
> +		counters[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter;
> +	result->stats.host_stats.receive_kbyte_count =
> +		counters[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter;
> +	result->stats.host_stats.transmit_frame_count =
> +		counters[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter;
> +	result->stats.host_stats.receive_frame_count =
> +		counters[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter;
> +
> +	complete(&result->stats.done);
> +}
> +
> +static void
> +efct_xport_async_link_stats_cb(int status, u32 num_counters,
> +			       struct efct_hw_link_stat_counts *counters,
> +			       void *arg)
> +{
> +	union efct_xport_stats_u *result = arg;
> +
> +	result->stats.link_stats.link_failure_error_count =
> +		counters[EFCT_HW_LINK_STAT_LINK_FAILURE_COUNT].counter;
> +	result->stats.link_stats.loss_of_sync_error_count =
> +		counters[EFCT_HW_LINK_STAT_LOSS_OF_SYNC_COUNT].counter;
> +	result->stats.link_stats.primitive_sequence_error_count =
> +		counters[EFCT_HW_LINK_STAT_PRIMITIVE_SEQ_COUNT].counter;
> +	result->stats.link_stats.invalid_transmission_word_error_count =
> +		counters[EFCT_HW_LINK_STAT_INVALID_XMIT_WORD_COUNT].counter;
> +	result->stats.link_stats.crc_error_count =
> +		counters[EFCT_HW_LINK_STAT_CRC_COUNT].counter;
> +}
> +
> +static void
> +efct_xport_async_host_stats_cb(int status, u32 num_counters,
> +			       struct efct_hw_host_stat_counts *counters,
> +			       void *arg)
> +{
> +	union efct_xport_stats_u *result = arg;
> +
> +	result->stats.host_stats.transmit_kbyte_count =
> +		counters[EFCT_HW_HOST_STAT_TX_KBYTE_COUNT].counter;
> +	result->stats.host_stats.receive_kbyte_count =
> +		counters[EFCT_HW_HOST_STAT_RX_KBYTE_COUNT].counter;
> +	result->stats.host_stats.transmit_frame_count =
> +		counters[EFCT_HW_HOST_STAT_TX_FRAME_COUNT].counter;
> +	result->stats.host_stats.receive_frame_count =
> +		counters[EFCT_HW_HOST_STAT_RX_FRAME_COUNT].counter;
> +}
> +
> +static void
> +efct_xport_config_stats_timer(struct efct *efct);
> +
> +static void
> +efct_xport_stats_timer_cb(struct timer_list *t)
> +{
> +	struct efct_xport *xport = from_timer(xport, t, stats_timer);
> +	struct efct *efct = xport->efct;
> +
> +	efct_xport_config_stats_timer(efct);
> +}
> +
> +static void
> +efct_xport_config_stats_timer(struct efct *efct)
> +{
> +	u32 timeout = 3 * 1000;
> +	struct efct_xport *xport = NULL;
> +
> +	if (!efct) {
> +		pr_err("%s: failed to locate EFCT device\n", __func__);
> +		return;
> +	}
> +
> +	xport = efct->xport;
> +	efct_hw_get_link_stats(&efct->hw, 0, 0, 0,
> +			       efct_xport_async_link_stats_cb,
> +			       &xport->fc_xport_stats);
> +	efct_hw_get_host_stats(&efct->hw, 0, efct_xport_async_host_stats_cb,
> +			       &xport->fc_xport_stats);
> +
> +	timer_setup(&xport->stats_timer,
> +		    &efct_xport_stats_timer_cb, 0);
> +	mod_timer(&xport->stats_timer,
> +		  jiffies + msecs_to_jiffies(timeout));
> +}
> +
> +int
> +efct_xport_initialize(struct efct_xport *xport)
> +{
> +	struct efct *efct = xport->efct;
> +	int rc = 0;
> +
> +	/* Initialize io lists */
> +	spin_lock_init(&xport->io_pending_lock);
> +	INIT_LIST_HEAD(&xport->io_pending_list);
> +	atomic_set(&xport->io_active_count, 0);
> +	atomic_set(&xport->io_pending_count, 0);
> +	atomic_set(&xport->io_total_free, 0);
> +	atomic_set(&xport->io_total_pending, 0);
> +	atomic_set(&xport->io_alloc_failed_count, 0);
> +	atomic_set(&xport->io_pending_recursing, 0);
> +	rc = efct_hw_init(&efct->hw);
> +	if (rc) {
> +		efc_log_err(efct, "efct_hw_init failure\n");
> +		goto out;
> +	}
> +
> +	rc = efct_scsi_tgt_new_device(efct);
> +	if (rc) {
> +		efc_log_err(efct, "failed to initialize target\n");
> +		goto hw_init_out;
> +	}
> +
> +	rc = efct_scsi_new_device(efct);
> +	if (rc) {
> +		efc_log_err(efct, "failed to initialize initiator\n");
> +		goto tgt_dev_out;
> +	}
> +
> +	/* Get FC link and host statistics perodically*/
> +	efct_xport_config_stats_timer(efct);
> +
> +	efct_xport_init_debugfs(efct);
> +
> +	return rc;
> +
> +tgt_dev_out:
> +	efct_scsi_tgt_del_device(efct);
> +
> +hw_init_out:
> +	efct_hw_teardown(&efct->hw);
> +out:
> +	return rc;
> +}
> +
> +int
> +efct_xport_status(struct efct_xport *xport, enum efct_xport_status cmd,
> +		  union efct_xport_stats_u *result)
> +{
> +	u32 rc = 0;
> +	struct efct *efct = NULL;
> +	union efct_xport_stats_u value;
> +
> +	efct = xport->efct;
> +
> +	switch (cmd) {
> +	case EFCT_XPORT_CONFIG_PORT_STATUS:
> +		if (xport->configured_link_state == 0) {
> +			/*
> +			 * Initial state is offline. configured_link_state is
> +			 * set to online explicitly when port is brought online
> +			 */
> +			xport->configured_link_state = EFCT_XPORT_PORT_OFFLINE;
> +		}
> +		result->value = xport->configured_link_state;
> +		break;
> +
> +	case EFCT_XPORT_PORT_STATUS:
> +		/* Determine port status based on link speed. */
> +		value.value = efct_hw_get_link_speed(&efct->hw);
> +		if (value.value == 0)
> +			result->value = 0;
> +		else
> +			result->value = 1;
> +		rc = 0;
> +		break;
> +
> +	case EFCT_XPORT_LINK_SPEED: {
> +		result->value = efct_hw_get_link_speed(&efct->hw);
> +
> +		break;
> +	}
> +	case EFCT_XPORT_LINK_STATISTICS:
> +		memcpy((void *)result, &efct->xport->fc_xport_stats,
> +		       sizeof(union efct_xport_stats_u));
> +		break;
> +	case EFCT_XPORT_LINK_STAT_RESET: {
> +		/* Create a completion to synchronize the stat reset process. */
> +		init_completion(&result->stats.done);
> +
> +		/* First reset the link stats */
> +		rc = efct_hw_get_link_stats(&efct->hw, 0, 1, 1,
> +					    efct_xport_link_stats_cb, result);
> +
> +		/* Wait for completion to be signaled when the cmd completes */
> +		if (wait_for_completion_interruptible(&result->stats.done)) {
> +			/* Undefined failure */
> +			efc_log_test(efct, "sem wait failed\n");
> +			rc = -ENXIO;
> +			break;
> +		}
> +
> +		/* Next reset the host stats */
> +		rc = efct_hw_get_host_stats(&efct->hw, 1,
> +					    efct_xport_host_stats_cb, result);
> +
> +		/* Wait for completion to be signaled when the cmd completes */
> +		if (wait_for_completion_interruptible(&result->stats.done)) {
> +			/* Undefined failure */
> +			efc_log_test(efct, "sem wait failed\n");
> +			rc = -ENXIO;
> +			break;
> +		}
> +		break;
> +	}
> +	default:
> +		rc = -1;
> +		break;
> +	}
> +
> +	return rc;
> +}
> +
> +int
> +efct_scsi_new_device(struct efct *efct)
> +{
> +	struct Scsi_Host *shost = NULL;
> +	int error = 0;
> +	struct efct_vport *vport = NULL;
> +	union efct_xport_stats_u speed;
> +	u32 supported_speeds = 0;
> +
> +	shost = scsi_host_alloc(&efct_template, sizeof(*vport));
> +	if (!shost) {
> +		efc_log_err(efct, "failed to allocate Scsi_Host struct\n");
> +		return EFC_FAIL;
> +	}
> +
> +	/* save shost to initiator-client context */
> +	efct->shost = shost;
> +
> +	/* save efct information to shost LLD-specific space */
> +	vport = (struct efct_vport *)shost->hostdata;
> +	vport->efct = efct;
> +
> +	/*
> +	 * Set initial can_queue value to the max SCSI IOs. This is the maximum
> +	 * global queue depth (as opposed to the per-LUN queue depth --
> +	 * .cmd_per_lun This may need to be adjusted for I+T mode.
> +	 */
> +	shost->can_queue = efct->hw.config.n_io;
> +	shost->max_cmd_len = 16; /* 16-byte CDBs */
> +	shost->max_id = 0xffff;
> +	shost->max_lun = 0xffffffff;
> +

What happened to multiqueue support?
The original lpfc driver did it, so we should regress for the new driver...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
