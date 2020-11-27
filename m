Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3886FC2D0E4
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 09:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1EDD21D91
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Nov 2020 09:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfQcDybq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgK0J5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Nov 2020 04:57:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgK0J5G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Nov 2020 04:57:06 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFD6021D91;
        Fri, 27 Nov 2020 09:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606471025;
        bh=4GugmYkNqqz/xiT8jEHRtT/irIXf154k+PPE5BeKSBI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WfQcDybqcdPFo5DO6uLw3V+oOZX27NRtuG2/V/m0m5HRPheIQ8d3XZqoXD6MmLNZO
         +xFMjzmE4Zl5JXo527j+3JVGwyCtvTOEzc8eNRoRRc+89hpS1289tX3F0qPwZdYxSA
         lxPJ7X4yfwwX+bBvyPdBx/hc6NsXcApz8YwWWmu8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kiaUx-00E1aU-Is; Fri, 27 Nov 2020 09:57:03 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 27 Nov 2020 09:57:03 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, gregkh@linuxfoundation.org,
        rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
In-Reply-To: <696c04a9-8c13-0fec-08c4-068d4dd5ba67@huawei.com>
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
 <5a588f5d86010602ff9a90e8f057743c@kernel.org>
 <80e0a19b-3291-1304-1a5b-0445c49efe31@huawei.com>
 <d696d314514a4bd53c85f2da73a23eed@kernel.org>
 <e96dd9b0-c3a7-f7fb-0317-2fc2107f405a@huawei.com>
 <696c04a9-8c13-0fec-08c4-068d4dd5ba67@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <34953f2d7b61f37ab1333627dc256975@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: john.garry@huawei.com, tglx@linutronix.de, gregkh@linuxfoundation.org, rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-26 16:52, John Garry wrote:
> Hi Marc,
> 
>>> 
>>> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=irq/hacks
>> 
>> 
>> ok, I'll have a look
> 
> I tried that and it doesn't look to work.
> 
> I find that for the its_msi_prepare() call, its_dev->shared does not
> get set, as MSI_ALLOC_FLAGS_SHARED_DEVICE is not set in info->flags.
> 
> If I understand the code correctly, MSI_ALLOC_FLAGS_SHARED_DEVICE is
> supposed to be set in info->flags in platform_msi_set_desc(), but this
> is called per-msi after its_msi_prepare(), so we don't the flags set
> at the right time. That's how it looks to me...

Meh. I was trying multiple things, and of course commited the worse
possible approach.

I've updated the branch, having verified that we do get the flag in
the ITS now.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
