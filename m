Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E00CC56202
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 18:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC212206CA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 18:35:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BbS5r5w/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbgKYSfb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 13:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:55482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730573AbgKYSfb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Nov 2020 13:35:31 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 031D320656;
        Wed, 25 Nov 2020 18:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606329330;
        bh=AvwWwggQsctiBxuGyQhxWW/Gg89PzWN5YvEkAcjKnPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BbS5r5w/5AdJxK2nGzWZbj+h+cMTl3LQatMhpWdGvcfCkX287ju/Eea0vwchg5XGq
         erq9I5EhlZIDvLorSeLbPwa+lDbWMP5Mvg8c8WRHf9l6QzUDT/UNb2o05SzLZNkbeg
         2n8ImiQmdkjqHKRM5eNGPCNE+DA8UzLQ//dY9TPg=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1khzdX-00DbNV-O1; Wed, 25 Nov 2020 18:35:27 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Nov 2020 18:35:27 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, gregkh@linuxfoundation.org,
        rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
In-Reply-To: <702e1729-9a4b-b16f-6a58-33172b1a3220@huawei.com>
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
 <0525a4bcf17a355cd141632d4f3714be@kernel.org>
 <702e1729-9a4b-b16f-6a58-33172b1a3220@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <5a588f5d86010602ff9a90e8f057743c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: john.garry@huawei.com, tglx@linutronix.de, gregkh@linuxfoundation.org, rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-24 17:38, John Garry wrote:
> Hi Marc,
> 
>>> So initially in the msi_prepare method we setup the its dev - this is
>>> from the mbigen probe. Then when all the irqs are unmapped later for
>>> end device driver removal, we release this its device in
>>> its_irq_domain_free(). But I don't see anything to set it up again. 
>>> Is
>>> it improper to have released the its device in this scenario?
>>> Commenting out the release makes things "good" again.
>> 
>> Huh, that's ugly. The issue is that the device that deals with the
>> interrupts isn't the device that the ITS knows about (there isn't a
>> 1:1 mapping between mbigen and the endpoint).
>> 
>> The mbigen is responsible for the creation of the corresponding
>> irqdomain, and and crucially for the "prepare" phase, which results
>> in storing the its_dev pointer in info->scratchpad[0].
>> 
>> As we free all the interrupts associated with the endpoint, we
>> free the its_dev (nothing else needs it at this point). On the
>> next allocation, we reuse the damn its_dev pointer, and we're SOL.
>> This is wrong, because we haven't removed the mbigen, only the
>> device *connected* to the mbigen. And since the mbigen can be shared
>> across endpoints, we can't reliably tear it down at all. Boo.
>> 
>> The only thing to do is to convey that by marking the its_dev as
>> shared so that it isn't deleted when no LPIs are being used. After
>> all, it isn't like the mbigen is going anywhere.
> 
> Right, I did consider this.

FWIW, I've pushed my hack branch[1] out with a couple of patches
for you to try (the top 3 patches). They allow platform-MSI domains
created by devices (mbigen, ICU) to be advertised as shared between
devices, so that the low-level driver can handle that in an appropriate
way.

I gave it a go on my D05 and nothing blew up, but I can't really remove
the kernel module, as that's where my disks are... :-/
Please let me know if that helps.

>> It is just that passing that information down isn't a simple affair,
>> as msi_alloc_info_t isn't a generic type... Let me have a think.
> 
> I think that there is a way to circumvent the problem, which you might
> call hacky, but OTOH, not sure if there's much point changing mbigen
> or related infrastructure at this stage.

Bah, it's a simple change, and there is now more than the mbigen using
the same API...

> 
> Anyway, so we have 128 irqs in total for the mbigen domain, but the
> driver only is interesting in something like irq indexes 1,2,72-81,
> and 96-112. So we can just dispose the mappings for irq index 0-112 at
> removal stage, thereby keeping the its device around. We do still call
> platform_irq_count(), which sets up all 128 mappings, so maybe we
> should be unmapping all of these - this would be the contentious part.
> But maybe not, as the device driver is only interested in that subset,
> and has no business unmapping the rest.

I don't think the driver should mess with interrupts it doesn't own.
And while the mbigen port that is connected to the SAS controller
doesn't seem to be shared between endpoints, some other ports definitely
are:

# cat /sys/kernel/debug/irq/domains/\\_SB.MBI1
name:   \_SB.MBI1
  size:   409
  mapped: 192
  flags:  0x00000003

[...]

I guess that the other 217 lines are connected somewhere.

> With that change, the platform.c API would work a bit more like the
> pci msi code equivalent, where we request a min and max number of
> vectors. In fact, that platform.c change needs to be made anyway as
> platform_get_irqs_affinity() is broken currently for when nr_cpus <
> #hw queues.
> 
> Thoughts?

I'm happy to look at some code! ;-)

         M.
-- 
Jazz is not dead. It just smells funny...
