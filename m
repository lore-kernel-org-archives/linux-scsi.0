Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03013C64E8A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 16:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7F91206D8
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 16:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pene3+Xy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390661AbgKXQwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 11:52:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390655AbgKXQwC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 11:52:02 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A56A420897;
        Tue, 24 Nov 2020 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606236721;
        bh=a648HmeorfhS0VxtSMa6f3yxZGcx78WEhbal5XI3Fo4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pene3+XyxtTiQ7p27OkLfwV45JnmS08QsI8+QjEAsyfm1aNucoPKWD+r3J0djBLof
         budQnVFedHVesCFVyiNUDY5EQkaSF1R7Y5y4FjOk+ygwiMBFdmpjarEcUSTiwkkpgq
         iBOGDRD+vrCyT29E4uKMO7dIM0z6fEOfHlLlYLc0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khbXr-00DJ6g-LG; Tue, 24 Nov 2020 16:51:59 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 24 Nov 2020 16:51:59 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, gregkh@linuxfoundation.org,
        rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
In-Reply-To: <5a314713-c1ee-2d34-bee1-60beae274742@huawei.com>
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
 <afd97dd4b1e102ac9ad49800821231a4@kernel.org>
 <5a314713-c1ee-2d34-bee1-60beae274742@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <0525a4bcf17a355cd141632d4f3714be@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: john.garry@huawei.com, tglx@linutronix.de, gregkh@linuxfoundation.org, rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-23 15:45, John Garry wrote:

Hi John,

>>> But it looks like there is more to it than that, which I'm worried is
>>> far from non-trivial. For example, just calling irq_dispose_mapping()
>>> for removal and then plaform_get_irq()->acpi_get_irq() second time
>>> fails as it looks like more tidy-up is needed for removal...
>> 
>> Most probably. I could imagine things failing if there is any trace
>> of an existing translation in the ITS or in the platform-MSI layer,
>> for example, or if the interrupt is still active...
> 
> So this looks to be a problem I have. So if I hack the code to skip
> the check in acpi_get_irq() for the irq already being init'ed, I run
> into a use-after-free in the gic-v3-its driver. I may be skipping
> something with this hack, but I'll ask anyway.
> 
> So initially in the msi_prepare method we setup the its dev - this is
> from the mbigen probe. Then when all the irqs are unmapped later for
> end device driver removal, we release this its device in
> its_irq_domain_free(). But I don't see anything to set it up again. Is
> it improper to have released the its device in this scenario?
> Commenting out the release makes things "good" again.

Huh, that's ugly. The issue is that the device that deals with the
interrupts isn't the device that the ITS knows about (there isn't a
1:1 mapping between mbigen and the endpoint).

The mbigen is responsible for the creation of the corresponding
irqdomain, and and crucially for the "prepare" phase, which results
in storing the its_dev pointer in info->scratchpad[0].

As we free all the interrupts associated with the endpoint, we
free the its_dev (nothing else needs it at this point). On the
next allocation, we reuse the damn its_dev pointer, and we're SOL.
This is wrong, because we haven't removed the mbigen, only the
device *connected* to the mbigen. And since the mbigen can be shared
across endpoints, we can't reliably tear it down at all. Boo.

The only thing to do is to convey that by marking the its_dev as
shared so that it isn't deleted when no LPIs are being used. After
all, it isn't like the mbigen is going anywhere.

It is just that passing that information down isn't a simple affair,
as msi_alloc_info_t isn't a generic type... Let me have a think.

         M.
-- 
Jazz is not dead. It just smells funny...
