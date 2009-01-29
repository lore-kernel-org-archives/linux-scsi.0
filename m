From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] scsi: replace uses of __constant_{endian}
Date: Thu, 29 Jan 2009 15:09:26 -0800
Message-ID: <20090129230926.GB37589@plap4-2.local>
References: <1233265895.5594.3.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:57474 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbZA2XJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2009 18:09:30 -0500
Content-Disposition: inline
In-Reply-To: <1233265895.5594.3.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 29 Jan 2009, Harvey Harrison wrote:

> The base versions handle constant folding now.  Almost entirely
> in qla2xxx/qla4xxx.

Do the same semantics apply to htonl()?  As, I'd rather see the
changes from __constant_htonl() -> cpu_to_be32() be __constant_htonl()
-> htonl():

...
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
> index 34760f8..21a8fe8 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -331,7 +331,7 @@ qla25xx_copy_fce(struct qla_hw_data *ha, void *ptr, uint32_t **last_chain)
>                 return ptr;
> 
>         *last_chain = &fcec->type;
> -       fcec->type = __constant_htonl(DUMP_CHAIN_FCE);
> +       fcec->type = cpu_to_be32(DUMP_CHAIN_FCE);
>         fcec->chain_size = htonl(sizeof(struct qla2xxx_fce_chain) +
>             fce_calc_size(ha->fce_bufs));
>         fcec->size = htonl(fce_calc_size(ha->fce_bufs));

	...
	fcec->type = htonl(DUMP_CHAIN_FCE);
	fcec->chain_size = htonl(sizeof(struct qla2xxx_fce_chain) +
	    fce_calc_size(ha->fce_bufs));

As it lends itself to a greater level of consistency with the other
assignments in the code regions...

--
av
