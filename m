Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 535E3C56201
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 20:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15F9246CD
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Nov 2020 20:38:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="OP/2/6xT";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="7DjjMlzI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgKRUiW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Nov 2020 15:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRUiW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2020 15:38:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1ABC0613D4;
        Wed, 18 Nov 2020 12:38:22 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605731900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T7m4QJtawYIOIZS6hZalfhNOAav/0EAeLSd6wLwAwbA=;
        b=OP/2/6xTQlMznm9w0E+um0tGQGA9rFJAdZfQHTNZ7OOC0lSE100nLoT5hLTj5/9dBoVukH
        3b88NLmkJnS+JBzKz1TeDSXHi4TAEBDBQMGJrvt8wagNzSs1Zbyrmcq87VRcJ2CHCIJQfn
        efmgZ7QKlD62riMxz/qucG3WtwP+Zvdb5tAiuev7rC2PUD77j8QubHZqXHxhrRQZio4aJx
        HzNk2RWVFoEgGqcK7GdJidp7vFiX6TlDUzCOAdYypRzj0Td5TBA5xssV7ze1FcgPyOJiew
        3eSwFFZvLmbY/ZJ0tjKsMuRky3U1NDEbjlqUVk0pj7Na8hjSXgI6eUxNo61KSw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605731900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T7m4QJtawYIOIZS6hZalfhNOAav/0EAeLSd6wLwAwbA=;
        b=7DjjMlzI3nv2TMAeWNK5TnMZWfV2v7GO5EbynbSP1IJURzPpYBaftiXjl318sG9uzefmvd
        AHb7eJfRKAo+rBCg==
To:     John Garry <john.garry@huawei.com>, gregkh@linuxfoundation.org,
        rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
In-Reply-To: <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com>
References: <87ft57r7v3.fsf@nanos.tec.linutronix.de> <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com>
Date:   Wed, 18 Nov 2020 21:38:20 +0100
Message-ID: <874klmqu2r.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

John,

On Wed, Nov 18 2020 at 11:34, John Garry wrote:
>> +/**
>> + * irq_update_affinity_desc - Update affinity management for an interrupt
>> + * @irq:	The interrupt number to update
>> + * @affinity:	Pointer to the affinity descriptor
>> + *
>> + * This interface can be used to configure the affinity management of
>> + * interrupts which have been allocated already.
>> + */
>> +int irq_update_affinity_desc(unsigned int irq,
>> +			     struct irq_affinity_desc *affinity)
>
> Just a note on the return value, in the only current callsite - 
> platform_get_irqs_affinity() - we don't check the return value and 
> propagate the error. This is because we don't want to fail the interrupt 
> init just because of problems updating the affinity mask. So I could 
> print a message to inform the user of error (at the callsite).

Well, not sure about that. During init on a platform which does not have
the issues with reservation mode there failure cases are:

 1) Interrupt does not exist. Definitely a full fail

 2) Interrupt is already started up. Not a good idea on init() and
    a clear fail.

 3) Interrupt has already been switched to managed. Double init is not
    really a good sign either.

>> +	/* Requires the interrupt to be shut down */
>> +	if (irqd_is_started(&desc->irq_data))
>
> We're missing the unlock here, right?

Duh yes.

>> +		return -EBUSY;
>> +
>> +	/* Interrupts which are already managed cannot be modified */
>> +	if (irqd_is_managed(&desc->irq_data))
>
> And here, and I figure that this should be irqd_affinity_is_managed()

More duh :)

I assume you send a fixed variant of this.

Thanks,

        tglx
