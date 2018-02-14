From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 04/13] lpfc: Add push-to-adapter support to sli4
Date: Wed, 14 Feb 2018 10:30:52 +0100
Message-ID: <20180214093052.eywwbg36gjnfirnz@linux-x5ow.site>
References: <20180213193457.21206-1-jsmart2021@gmail.com>
 <20180213193457.21206-5-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53499 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966688AbeBNJaz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Feb 2018 04:30:55 -0500
Content-Disposition: inline
In-Reply-To: <20180213193457.21206-5-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On Tue, Feb 13, 2018 at 11:34:48AM -0800, James Smart wrote:
[...]
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 3bff1f9c5df7..5e03b2c969e5 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -35,6 +35,9 @@
>  #include <scsi/scsi_transport_fc.h>
>  #include <scsi/fc/fc_fs.h>
>  #include <linux/aer.h>
> +#ifdef CONFIG_X86
> +#include <asm/set_memory.h>
> +#endif

Not needed anymore now you've killed set_memory_wc(), isn't it?

[...]

> +	if (q->dpp_enable && q->phba->cfg_enable_dpp) {
> +		/* write to DPP aperture taking advatage of Combined Writes */
> +		tmp = (uint8_t *)wqe;
> +#ifdef CONFIG_64BIT
> +		for (i = 0; i < q->entry_size; i += sizeof(uint64_t))
> +			writeq(*((uint64_t *)(tmp + i)), q->dpp_regaddr + i);
> +#else
> +		for (i = 0; i < q->entry_size; i += sizeof(uint32_t))
> +			writel(*((uint32_t *)(tmp + i)), q->dpp_regaddr + i);
> +#endif
> +	}
> +	/* ensure WQE bcopy and DPP flushed before doorbell write */

Any reason you can't use writeq() on 32 Bit as well? There's a compat version
in linux/io-64-nonatomic-hi-lo.h.

Thanks,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
