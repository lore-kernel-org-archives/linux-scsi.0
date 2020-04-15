Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63769C2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D9E720737
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370014AbgDOMlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:41:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:57624 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S369999AbgDOMll (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 08:41:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3ACD4AE35;
        Wed, 15 Apr 2020 12:41:23 +0000 (UTC)
Subject: Re: [PATCH v3 09/31] elx: libefc: Emulex FC discovery library APIs
 and definitions
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-10-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0b1feda2-b778-8495-807a-85e74aacffaa@suse.de>
Date:   Wed, 15 Apr 2020 14:41:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-10-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> - SLI/Local FC port objects
> - efc_domain_s: FC domain (aka fabric) objects
> - efc_node_s: FC node (aka remote ports) objects
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Removed Sparse Vector APIs and structures.
> ---
>   drivers/scsi/elx/libefc/efc.h     |  72 +++++
>   drivers/scsi/elx/libefc/efc_lib.c |  41 +++
>   drivers/scsi/elx/libefc/efclib.h  | 640 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 753 insertions(+)
>   create mode 100644 drivers/scsi/elx/libefc/efc.h
>   create mode 100644 drivers/scsi/elx/libefc/efc_lib.c
>   create mode 100644 drivers/scsi/elx/libefc/efclib.h
> 
[ .. ]
> +#define EFC_LOG_LIB		0x01
> +#define EFC_LOG_NODE		0x02
> +#define EFC_LOG_PORT		0x04
> +#define EFC_LOG_DOMAIN		0x08
> +#define EFC_LOG_ELS		0x10
> +#define EFC_LOG_DOMAIN_SM	0x20
> +#define EFC_LOG_SM		0x40
> +
> +/* efc library port structure */
> +struct efc {
> +	void			*base;
> +	struct pci_dev		*pcidev;
> +	u64			req_wwpn;
> +	u64			req_wwnn;
> +
> +	u64			def_wwpn;
> +	u64			def_wwnn;
> +	u64			max_xfer_size;
> +	u32			nodes_count;
> +	mempool_t		*node_pool;
> +	struct dma_pool		*node_dma_pool;
> +
> +	u32			link_status;
> +

Maybe move 'nodes_count' after 'node_dma_pool' for better alignment?

But just a minor nit.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
