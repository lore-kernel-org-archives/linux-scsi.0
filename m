Return-Path: <SRS0=4YdN=D5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66576C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 02:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266792245F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Oct 2020 02:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895029AbgJVCYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 22:24:55 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:46046 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895026AbgJVCYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 22:24:55 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id C397122444;
        Wed, 21 Oct 2020 22:24:51 -0400 (EDT)
Date:   Thu, 22 Oct 2020 13:25:00 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Xianting Tian <tian.xianting@h3c.com>
cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: use spin_lock() in hard IRQ
In-Reply-To: <20201021064502.35469-1-tian.xianting@h3c.com>
Message-ID: <alpine.LNX.2.23.453.2010221312460.6@nippy.intranet>
References: <20201021064502.35469-1-tian.xianting@h3c.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Oct 2020, Xianting Tian wrote:

> Since we already in hard IRQ context when running megasas_isr(),

On m68k, hard irq context does not mean interrupts are disabled. Are there 
no other architectures in that category?

> so use spin_lock() is enough, which is faster than spin_lock_irqsave().
> 

Is that measurable?

> Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 2b7e7b5f3..bd186254d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3977,15 +3977,14 @@ static irqreturn_t megasas_isr(int irq, void *devp)
>  {
>  	struct megasas_irq_context *irq_context = devp;
>  	struct megasas_instance *instance = irq_context->instance;
> -	unsigned long flags;
>  	irqreturn_t rc;
>  
>  	if (atomic_read(&instance->fw_reset_no_pci_access))
>  		return IRQ_HANDLED;
>  
> -	spin_lock_irqsave(&instance->hba_lock, flags);
> +	spin_lock(&instance->hba_lock);
>  	rc = megasas_deplete_reply_queue(instance, DID_OK);
> -	spin_unlock_irqrestore(&instance->hba_lock, flags);
> +	spin_unlock(&instance->hba_lock);
>  
>  	return rc;
>  }
> 
