Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CADC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 14:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20BF2221E5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 14:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbhADOnj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 09:43:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:42740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbhADOnj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 09:43:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A0EE1ACAF;
        Mon,  4 Jan 2021 14:42:57 +0000 (UTC)
Date:   Mon, 4 Jan 2021 15:42:57 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v5 11/31] elx: libefc: SLI and FC PORT state machine
 interfaces
Message-ID: <20210104144257.xooptec22ybkxwsn@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-12-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210103171134.39878-12-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 03, 2021 at 09:11:14AM -0800, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> - SLI and FC port (aka n_port_id) registration, allocation and
>   deallocation.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>

Just one nitpick, rest looks good.

Reviewed-by: Daniel Wagner <dwagner@suse.de>

> ---
>  drivers/scsi/elx/libefc/efc_nport.c | 794 ++++++++++++++++++++++++++++
>  drivers/scsi/elx/libefc/efc_nport.h |  50 ++
>  2 files changed, 844 insertions(+)
>  create mode 100644 drivers/scsi/elx/libefc/efc_nport.c
>  create mode 100644 drivers/scsi/elx/libefc/efc_nport.h
> 
> diff --git a/drivers/scsi/elx/libefc/efc_nport.c b/drivers/scsi/elx/libefc/efc_nport.c
> new file mode 100644
> index 000000000000..fad42cd8a108
> --- /dev/null
> +++ b/drivers/scsi/elx/libefc/efc_nport.c
> @@ -0,0 +1,794 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2021 Broadcom. All Rights Reserved. The term
> + * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> + */
> +
> +/*
> + * NPORT
> + *
> + * Port object for physical port and NPIV ports.
> + */
> +
> +/*
> + * NPORT REFERENCE COUNTING
> + *
> + * A nport reference should be taken when:
> + * - an nport is allocated
> + * - a vport populates associated nport
> + * - a remote node is allocated
> + * - a unsolicited frame is processed
> + * The reference should be dropped when:
> + * - the unsolicited frame processesing is done
> + * - the remote node is removed
> + * - the vport is removed
> + * - the nport is removed
> + */

Thanks for this. It really helps!

> +
> +#include "efc.h"
> +
> +int
> +efc_nport_cb(void *arg, int event, void *data)
> +{
> +	struct efc *efc = arg;
> +	struct efc_nport *nport = data;
> +	unsigned long flags = 0;
> +
> +	efc_log_debug(efc, "nport event: %s\n", efc_sm_event_name(event));
> +
> +	spin_lock_irqsave(&efc->lock, flags);
> +	efc_sm_post_event(&nport->sm, event, NULL);
> +	spin_unlock_irqrestore(&efc->lock, flags);
> +
> +	return EFC_SUCCESS;

No caller tests for the return value which is always success, thus the
function could have no return value.
