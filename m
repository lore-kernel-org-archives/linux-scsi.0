Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E78C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A132C61100
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhJ2NtZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:49:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55252 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhJ2NtY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 09:49:24 -0400
Date:   Fri, 29 Oct 2021 15:46:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1635515213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+vrP1hlcOJgGER9TxXqlDU8mV5Xi9Q5zOOXAiVkeIwU=;
        b=MtuSfyMj6jGlPYwgPsUCaIgyRsFJ7UDDU3UqrfzJIMl3QbTWMbYJ8UB/r87U3f+fsJAA67
        AiXOUBv28RjXW9vkvxnV0TKBtlR/7jzLY5hK33QyC8W+Zln3b0S7ubwURZbx2zLYGNjIpo
        /UOAbpDtNGaYo6thnLd+lQX5LkG8X399mlmrWgutTZJYB1lFBbqhothmgiKlfEuvq8AKnT
        6bE9GXDRi/GqP60H65nG9CxEfuITv53K/7rVyreFDw5viBBytntWGR0pRgUBgCSWIhtb2s
        7IfWtpaZNPBgGbMK6sit+1C9j2lbtDQjLmrEO21QJcs08EXcq/EB291w0gEKBg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1635515213;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+vrP1hlcOJgGER9TxXqlDU8mV5Xi9Q5zOOXAiVkeIwU=;
        b=IDniLm2hrhHGJ3I3UuMjs8Y1cRaQOhD7HgwxRoZdFQQeJ2gkRr1lyh1shUVJPj4oeOdcrI
        BYoA4C1jbeviYUCQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     linux-scsi@vger.kernel.org,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] scsi: be2iscsi: Replace irq_poll with threaded IRQ
 handler.
Message-ID: <20211029134652.mdgt7zcvdskhxq4k@linutronix.de>
References: <20211029074902.4fayed6mcltifgdz@linutronix.de>
 <d5212154-0dd7-58ac-9fc3-25d77fe2a8fa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d5212154-0dd7-58ac-9fc3-25d77fe2a8fa@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-29 14:41:53 [+0100], John Garry wrote:
> > @@ -713,9 +752,22 @@ static irqreturn_t be_isr_msix(int irq, void *dev_id)
> >   	phba = pbe_eq->phba;
> >   	/* disable interrupt till iopoll completes */
> >   	hwi_ring_eq_db(phba, eq->id, 1,	0, 0, 1);
> > -	irq_poll_sched(&pbe_eq->iopoll);
> > -	return IRQ_HANDLED;
> > +	return IRQ_WAKE_THREAD;
> > +}
> > +
> > @@ -819,9 +873,10 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
> >   				goto free_msix_irqs;
> >   			}
> > -			ret = request_irq(pci_irq_vector(pcidev, i),
> > -					  be_isr_msix, 0, phba->msi_name[i],
> > -					  &phwi_context->be_eq[i]);
> > +			ret = request_threaded_irq(pci_irq_vector(pcidev, i),
> > +						   be_isr_msix, be_isr_misx_th,
> > +						   0, phba->msi_name[i],
> > +						   &phwi_context->be_eq[i]);
> 
> Would it be sensible to set ONESHOT flag here? I assume that we don't want
> the hard irq handler firing continuously while we poll completions in the
> threaded handler. That's my understanding of how ONESHOT should or would
> work... they currently seem to manually disable in be_isr_msix() ->
> hwi_ring_eq_db() for the same purpose, I guess.

We could. My understanding of hwi_ring_eq_db() of is that it disables
the interrupt from on HW level. This is needed _already_ in order to
continue to process the request later in softirq without the interrupt
constantly firing.
For the MSI interrupts this could be replaced "easily" and leaving the
primary handler empty. However the non-MSI interrupts may be shared and
here all handlers need the ONESHOT which may not be the case.

> Thanks,
> John

Sebastian
