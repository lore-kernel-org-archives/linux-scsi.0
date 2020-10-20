Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5EFC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42AC9223BF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404811AbgJTHGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 03:06:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:46768 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404793AbgJTHGB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 03:06:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DCE04AD52;
        Tue, 20 Oct 2020 07:06:00 +0000 (UTC)
Subject: Re: [PATCH v4 31/31] elx: efct: Tie into kernel Kconfig and build
 process
To:     James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>
References: <20201012225147.54404-1-james.smart@broadcom.com>
 <20201012225147.54404-32-james.smart@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8d358093-ffd7-e4b3-3340-ff0e0d73ca94@suse.de>
Date:   Tue, 20 Oct 2020 09:06:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201012225147.54404-32-james.smart@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/13/20 12:51 AM, James Smart wrote:
> This final patch ties the efct driver into the kernel Kconfig
> and build linkages in the drivers/scsi directory.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>   drivers/scsi/Kconfig  | 2 ++
>   drivers/scsi/Makefile | 1 +
>   2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 701b61ec76ee..f2d47bf55f97 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -1170,6 +1170,8 @@ config SCSI_LPFC_DEBUG_FS
>   	  This makes debugging information from the lpfc driver
>   	  available via the debugfs filesystem.
>   
> +source "drivers/scsi/elx/Kconfig"
> +
>   config SCSI_SIM710
>   	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
>   	depends on EISA && SCSI
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index c00e3dd57990..844db573283c 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -86,6 +86,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla1280.o
>   obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
>   obj-$(CONFIG_SCSI_QLA_ISCSI)	+= libiscsi.o qla4xxx/
>   obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
> +obj-$(CONFIG_SCSI_EFCT)		+= elx/
>   obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
>   obj-$(CONFIG_SCSI_CHELSIO_FCOE)	+= csiostor/
>   obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
