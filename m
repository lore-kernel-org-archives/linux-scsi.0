Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA624C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9471222482
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbhADRGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:06:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:47638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhADRGM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 12:06:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2FE71AD29;
        Mon,  4 Jan 2021 17:05:31 +0000 (UTC)
Date:   Mon, 4 Jan 2021 18:05:30 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v5 18/31] elx: efct: Driver initialization routines
Message-ID: <20210104170530.6hz7kze35iddtju2@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-19-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210103171134.39878-19-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 03, 2021 at 09:11:21AM -0800, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Emulex FC Target driver init, attach and hardware setup routines.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

> ---
>  drivers/scsi/elx/efct/efct_driver.c |  793 ++++++++++++++++++
>  drivers/scsi/elx/efct/efct_driver.h |  109 +++
>  drivers/scsi/elx/efct/efct_hw.c     | 1158 +++++++++++++++++++++++++++
>  drivers/scsi/elx/efct/efct_hw.h     |   15 +
>  drivers/scsi/elx/efct/efct_xport.c  |  519 ++++++++++++
>  drivers/scsi/elx/efct/efct_xport.h  |  186 +++++
>  6 files changed, 2780 insertions(+)
>  create mode 100644 drivers/scsi/elx/efct/efct_driver.c
>  create mode 100644 drivers/scsi/elx/efct/efct_driver.h
>  create mode 100644 drivers/scsi/elx/efct/efct_hw.c
>  create mode 100644 drivers/scsi/elx/efct/efct_xport.c
>  create mode 100644 drivers/scsi/elx/efct/efct_xport.h
> 
> diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
> new file mode 100644
> index 000000000000..77aeb86f959f
> --- /dev/null
> +++ b/drivers/scsi/elx/efct/efct_driver.c
> @@ -0,0 +1,793 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include "efct_driver.h"
> +
> +#include "efct_hw.h"
> +#include "efct_unsol.h"
> +#include "efct_scsi.h"
> +
> +LIST_HEAD(efct_devices);
> +
> +static int logmask;
> +module_param(logmask, int, 0444);
> +MODULE_PARM_DESC(logmask, "logging bitmask (default 0)");
> +
> +static struct libefc_function_template efct_libefc_templ = {
> +	.issue_mbox_rqst = efct_issue_mbox_rqst,
> +	.send_els = efct_els_hw_srrs_send,
> +	.send_bls = efct_efc_bls_send,
> +
> +	.new_nport = efct_scsi_tgt_new_nport,
> +	.del_nport = efct_scsi_tgt_del_nport,
> +	.scsi_new_node = efct_scsi_new_initiator,
> +	.scsi_del_node = efct_scsi_del_initiator,
> +	.hw_seq_free = efct_efc_hw_sequence_free,
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
> +
> +	efct = kzalloc_node(sizeof(*efct), GFP_KERNEL, nid);
> +	if (!efct)
> +		return efct;
> +
> +	INIT_LIST_HEAD(&efct->list_entry);
> +	list_add_tail(&efct->list_entry, &efct_devices);
> +
> +	return efct;
> +}
> +
> +static void
> +efct_teardown_msix(struct efct *efct)
> +{
> +	u32 i;
> +
> +	for (i = 0; i < efct->n_msix_vec; i++) {
> +		free_irq(pci_irq_vector(efct->pci, i),
> +			 &efct->intr_context[i]);
> +	}
> +
> +	pci_free_irq_vectors(efct->pci);
> +}
> +
> +static int
> +efct_efclib_config(struct efct *efct, struct libefc_function_template *tt)
> +{
> +	struct efc *efc;
> +	struct sli4 *sli;
> +	int rc = EFC_SUCCESS;
> +
> +	efc = kzalloc(sizeof(*efc), GFP_KERNEL);
> +	if (!efc)
> +		return EFC_FAIL;
> +
> +	efct->efcport = efc;
> +
> +	memcpy(&efc->tt, tt, sizeof(*tt));
> +	efc->base = efct;
> +	efc->pci = efct->pci;
> +
> +	efc->def_wwnn = efct_get_wwnn(&efct->hw);
> +	efc->def_wwpn = efct_get_wwpn(&efct->hw);
> +	efc->enable_tgt = 1;
> +	efc->log_level = EFC_LOG_LIB;
> +
> +	sli = &efct->hw.sli;
> +	efc->max_xfer_size = sli->sge_supported_length *
> +			     sli_get_max_sgl(&efct->hw.sli);
> +	efc->sli = sli;
> +	efc->fcfi = efct->hw.fcf_indicator;
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

rc = EFC_SUCCESS

There are some more of those in this patch, where 0/-1 is used instead
of the EFC_ defines.

