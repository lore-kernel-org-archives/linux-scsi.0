Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9341C2D0C4
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 10:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85ACB2073D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 10:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfLJKpb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 05:45:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:42906 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727116AbfLJKpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Dec 2019 05:45:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B543AF23;
        Tue, 10 Dec 2019 10:45:28 +0000 (UTC)
Message-ID: <5ff7962a50719d79a3262bcb290bc93b3a8e3058.camel@suse.de>
Subject: Re: [PATCH 4/4] qla2xxx: Micro-optimize
 qla2x00_configure_local_loop()
From:   Martin Wilck <mwilck@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
Cc:     linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Date:   Tue, 10 Dec 2019 11:46:17 +0100
In-Reply-To: <20191209180223.194959-5-bvanassche@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
         <20191209180223.194959-5-bvanassche@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart,

On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
> Instead of changing endianness in-place and copying the data in two
> steps,
> do this in one step. This patch makes is a preparation step for
> fixing the
> endianness warnings reported by 'sparse' for the qla2xxx driver.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  | 2 +-
>  drivers/scsi/qla2xxx/qla_init.c | 9 ++++-----
>  2 files changed, 5 insertions(+), 6 deletions(-)

I suppose you're aware that this patch conflicts with Roman's pending
patch "scsi: qla2xxx: Don't defer relogin unconditonally".

> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 6c28f38f8021..ddd8bf7997a8 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5047,13 +5047,12 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
>  			rval = qla24xx_get_port_login_templ(vha,
>  			    ha->init_cb_dma, (void *)ha->init_cb, sz);
>  			if (rval == QLA_SUCCESS) {
> +				__be32 *q = &ha->plogi_els_payld.data[0];
> +
>  				bp = (uint32_t *)ha->init_cb;
> -				for (i = 0; i < sz/4 ; i++, bp++)
> -					*bp = cpu_to_be32(*bp);
> +				for (i = 0; i < sz/4 ; i++, bp++, q++)
> +					*q = cpu_to_be32(*bp);
>  
> -				memcpy(&ha->plogi_els_payld.data,
> -				    (void *)ha->init_cb,
> -				    sizeof(ha->plogi_els_payld.data));
>  				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
>  			} else {
>  				ql_dbg(ql_dbg_init, vha, 0x00d1,

A side effect of this patch would be that after return from
qla2x00_configure_local_loop(), the byte ordering in ha->init_cb
remains in CPU byte ordering, whereas before your patch, it would have
been converted to be32. I'm uncertain if that would matter later on.

The following is not a problems with your patch, but what's really
weird is that in qla24xx_get_port_login_templ() (which is only called
from here), the buffer is converted from le32 to CPU endianness, and
then here, in a second step, from CPU to be32. I'm wondering which byte
order this buffer is supposed to have, and whether that's different
depending on which mode the controller is operating in (the be32
conversion seems to be applied in N2N mode only). Moreover, looking at
the definition of init_cb_t in qla_def.h, this data structure actually
has mixed endianness, making me doubt that changing the endianness of
the whole buffer makes sense at all. Or is ha->init_cb simply being
abused in this part of the code?

I guess only Himanshu or Quinn can tell.

Martin


