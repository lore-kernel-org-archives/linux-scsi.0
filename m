Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF66DC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 16:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C40D224DE
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 16:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbhADQuP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:50:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:36158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727783AbhADQuP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 11:50:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E97A8AA35;
        Mon,  4 Jan 2021 16:49:33 +0000 (UTC)
Date:   Mon, 4 Jan 2021 17:49:33 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v5 16/31] elx: libefc: Register discovery objects with
 hardware
Message-ID: <20210104164933.bjbynbg2udypuqzr@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-17-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210103171134.39878-17-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 03, 2021 at 09:11:19AM -0800, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> -Registrations for VFI, VPI and RPI.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v5:
>  EFC_EVT_XXX name changes.
> ---
>  drivers/scsi/elx/libefc/efc_cmds.c | 877 +++++++++++++++++++++++++++++
>  drivers/scsi/elx/libefc/efc_cmds.h |  35 ++
>  2 files changed, 912 insertions(+)
>  create mode 100644 drivers/scsi/elx/libefc/efc_cmds.c
>  create mode 100644 drivers/scsi/elx/libefc/efc_cmds.h
> 
> diff --git a/drivers/scsi/elx/libefc/efc_cmds.c b/drivers/scsi/elx/libefc/efc_cmds.c
> new file mode 100644
> index 000000000000..a1cca840cf63
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_cmds.c
> @@ -0,0 +1,877 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +#include "efclib.h"
> +#include "../libefc_sli/sli4.h"
> +#include "efc_cmds.h"
> +#include "efc_sm.h"
> +
> +static void
> +efc_nport_free_resources(struct efc_nport *nport, int evt, void *data)
> +{
> +	struct efc *efc = nport->efc;
> +
> +	/* Clear the nport attached flag */
> +	nport->attached = false;
> +
> +	/* Free the service parameters buffer */
> +	if (nport->dma.virt) {
> +		dma_free_coherent(&efc->pci->dev, nport->dma.size,
> +				  nport->dma.virt, nport->dma.phys);
> +		memset(&nport->dma, 0, sizeof(struct efc_dma));
> +	}
> +
> +	/* Free the SLI resources */
> +	sli_resource_free(efc->sli, SLI4_RSRC_VPI, nport->indicator);
> +
> +	efc_nport_cb(efc, evt, nport);
> +}
> +
> +static int
> +efc_nport_get_mbox_status(struct efc_nport *nport, u8 *mqe, int status)
> +{
> +	struct efc *efc = nport->efc;
> +	struct sli4_mbox_command_header *hdr =
> +			(struct sli4_mbox_command_header *)mqe;
> +	int rc = 0;

Is there a reason not to use the EFC_SUCCESS/FAIL defines? Anyway, this
local variable could be avoided by just using return directly.

> +
> +	if (status || le16_to_cpu(hdr->status)) {
> +		efc_log_debug(efc, "bad status vpi=%#x st=%x hdr=%x\n",
> +			nport->indicator, status, le16_to_cpu(hdr->status));
> +		rc = -1;

		return EFC_FAIL/-1;

> +	}
> +
> +	return rc;

	return EFC_SUCCESS/0;

Anyway, this pattern with 'rc = foo(); if (rc) {}' is different to the
patches I've seen so far. Usually, the local rc variable is avoided and
the function is directly called in the if condition
statement. Personally, I find the style here simpler to follow but for
consistency sake I rather have one style through out the driver.

> +static int
> +efc_nport_free_unreg_vpi_cb(struct efc *efc, int status, u8 *mqe, void *arg)
> +{
> +	struct efc_nport *nport = arg;
> +	int evt = EFC_EVT_NPORT_FREE_OK;
> +	int rc = 0;

Again the question why not EFC_SUCCESS?

Rest looks good. As the above comments are just nitpicking:

Reviewed-by: Daniel Wagner <dwagner@suse.de>
