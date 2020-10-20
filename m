Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7921C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E305223C6
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404800AbgJTHFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 03:05:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:46520 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404797AbgJTHFb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 03:05:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D619EAC4C;
        Tue, 20 Oct 2020 07:05:29 +0000 (UTC)
Subject: Re: [PATCH v4 30/31] elx: efct: Add Makefile and Kconfig for efct
 driver
To:     James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
 <20201012225147.54404-31-james.smart@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7041fb82-dc83-48b6-a8f0-cf1026c312ab@suse.de>
Date:   Tue, 20 Oct 2020 09:05:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201012225147.54404-31-james.smart@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/20 12:51 AM, James Smart wrote:
> This patch completes the efct driver population.
> 
> This patch adds driver definitions for:
> Adds the efct driver Kconfig and Makefiles
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> 
> ---
> v4:
>    Makefile change, new files added
> ---
>   drivers/scsi/elx/Kconfig  |  9 +++++++++
>   drivers/scsi/elx/Makefile | 18 ++++++++++++++++++
>   2 files changed, 27 insertions(+)
>   create mode 100644 drivers/scsi/elx/Kconfig
>   create mode 100644 drivers/scsi/elx/Makefile
> 
> diff --git a/drivers/scsi/elx/Kconfig b/drivers/scsi/elx/Kconfig
> new file mode 100644
> index 000000000000..831daea7a951
> --- /dev/null
> +++ b/drivers/scsi/elx/Kconfig
> @@ -0,0 +1,9 @@
> +config SCSI_EFCT
> +	tristate "Emulex Fibre Channel Target"
> +	depends on PCI && SCSI
> +	depends on TARGET_CORE
> +	depends on SCSI_FC_ATTRS
> +	select CRC_T10DIF
> +	help
> +	  The efct driver provides enhanced SCSI Target Mode
> +	  support for specific SLI-4 adapters.
> diff --git a/drivers/scsi/elx/Makefile b/drivers/scsi/elx/Makefile
> new file mode 100644
> index 000000000000..47d3b1e3c3fb
> --- /dev/null
> +++ b/drivers/scsi/elx/Makefile
> @@ -0,0 +1,18 @@
> +#// SPDX-License-Identifier: GPL-2.0
> +#/*
> +# * Copyright (C) 2020 Broadcom. All Rights Reserved. The term
> +# * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.
> +# */
> +
> +
> +obj-$(CONFIG_SCSI_EFCT) := efct.o
> +
> +efct-objs := efct/efct_driver.o efct/efct_io.o efct/efct_scsi.o \
> +	     efct/efct_xport.o efct/efct_hw.o efct/efct_hw_queues.o \
> +	     efct/efct_lio.o efct/efct_unsol.o
> +
> +efct-objs += libefc/efc_cmds.o libefc/efc_domain.o libefc/efc_fabric.o \
> +	     libefc/efc_node.o libefc/efc_nport.o libefc/efc_device.o \
> +	     libefc/efc_lib.o libefc/efc_sm.o libefc/efc_els.o
> +
> +efct-objs += libefc_sli/sli4.o
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
