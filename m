Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42341C388F9
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 13:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D27902080A
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Nov 2020 13:26:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FG5PK1zM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731962AbgKWN0p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 08:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:56350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731029AbgKWN0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 08:26:44 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9466A20782;
        Mon, 23 Nov 2020 13:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606138002;
        bh=8TTRPK5WiuKGTuOXJWYuxYVpykJ3HWxVl8s8Ni1hCJA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FG5PK1zMGDQR+u6XxfELRrOhw+wAbSN2MTcm+Q9qWyqU23rKZSRFbf9kQpXkHOUlY
         qkcg4TWeCo5Xqdo9kcZrZkb1CWbhHRJyKmjBZIRK0bX3iIn6eF9Oreinud6z8321Hu
         VhpSh8SqY3179EJuvgVGnzfiy0QldmtPPj+FjQCc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khBrc-00CxET-CA; Mon, 23 Nov 2020 13:26:40 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 23 Nov 2020 13:26:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, gregkh@linuxfoundation.org,
        rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
In-Reply-To: <0edc9a11-0b92-537f-1790-6b4b6de4900d@huawei.com>
References: <87ft57r7v3.fsf@nanos.tec.linutronix.de>
 <78356caa-57a0-b807-fe52-8f12d36c1789@huawei.com>
 <874klmqu2r.fsf@nanos.tec.linutronix.de>
 <b86af904-2288-8b53-7e99-e763b73987d0@huawei.com>
 <87lfexp6am.fsf@nanos.tec.linutronix.de>
 <3acb7fde-eae2-a223-9cfd-f409cc2abba6@huawei.com>
 <873615oy8a.fsf@nanos.tec.linutronix.de>
 <4aab9d3b-6ca6-01c5-f840-459f945c7577@huawei.com>
 <87sg91ik9e.wl-maz@kernel.org>
 <0edc9a11-0b92-537f-1790-6b4b6de4900d@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <afd97dd4b1e102ac9ad49800821231a4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: john.garry@huawei.com, tglx@linutronix.de, gregkh@linuxfoundation.org, rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,

On 2020-11-23 12:54, John Garry wrote:
> Hi Marc,
> 
>>>> Right, but if the driver is removed then the interrupts should be
>>>> deallocated, right?
>>>> 
>>> 
>>> When removing the driver we just call free_irq(), which removes the
>>> handler and disables the interrupt.
>>> 
>>> But about the irq_desc, this is created when the mapping is created 
>>> in
>>> irq_create_fwspec_mapping(), and I don't see this being torn down in
>>> the driver removal, so persistent in that regard.
>> 
>> If the irq_descs are created via the platform_get_irq() calls in
>> platform_get_irqs_affinity(), I'd expect some equivalent helper to
>> tear things down as a result, calling irq_dispose_mapping() behind the
>> scenes.
>> 
> 
> So this looks lacking in the kernel AFAICS...
> 
> So is there a reason for which irq dispose mapping is not a
> requirement for drivers when finished with the irq? because of shared
> interrupts?

For a bunch of reasons: IRQ number used to be created 1:1 with their
physical counterpart, so there wasn't a need to "get rid" of the
associated data structures. Also, people expected their drivers
to be there for the lifetime of the system (believe it or not,
hotplug devices are pretty new!).

Shared interrupts are just another part of the problem (although we
should be able to work out whether there is any action attached to
the descriptor before blowing it away.

> 
>>> So for pci msi I can see that we free the irq_desc in
>>> pci_disable_msi() -> free_msi_irqs() -> msi_domain_free_irqs() ...
>>> 
>>> So what I am missing here?
>> 
>> I'm not sure the paths are strictly equivalent. On the PCI side, we
>> can have something that completely driver agnostic, as it is all
>> architectural. In your case, only the endpoint driver knows about what
>> happens, and needs to free things accordingly.
>> 
>> Finally, there is the issue in your driver that everything is
>> requested using devm_request_irq, which cannot play nicely with an
>> explicit irq_desc teardown. You'll probably need to provide the
>> equivalent devm helpers for your driver to safely be taken down.
>> 
> 
> Yeah, so since we use the devm irq request method, we also need a devm
> dispose release method as we can't dispose the irq mapping in the
> remove() method, prior to the irq_free() in the later devm release
> method.
> 
> But it looks like there is more to it than that, which I'm worried is
> far from non-trivial. For example, just calling irq_dispose_mapping()
> for removal and then plaform_get_irq()->acpi_get_irq() second time
> fails as it looks like more tidy-up is needed for removal...

Most probably. I could imagine things failing if there is any trace
of an existing translation in the ITS or in the platform-MSI layer,
for example, or if the interrupt is still active...

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
