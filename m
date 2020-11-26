Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE7AC63697
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 11:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEAE820DD4
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Nov 2020 11:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+MOZr7a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgKZLI2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Nov 2020 06:08:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:43334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgKZLI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Nov 2020 06:08:27 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F06D720DD4;
        Thu, 26 Nov 2020 11:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606388907;
        bh=xbLCeq3DSM++W6DFnu0rSTs3oCF5PlwhHrgqtqEh71g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X+MOZr7ah+Gn9iUshVW9PLaatlI2STUtfsKReYHoNLmGkwgerdL+5SvnV5XDFYta8
         l266UDPPZG7mhvnLYQ0xuLsn7t8dP0YK02NRWsxg8OqsGr3oP86W+4rQPb01pXzftG
         gBsw9kveYFJaGjt3NOxkm7/6vDviL/5zpJuhClFQ=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kiF8S-00DmWZ-PJ; Thu, 26 Nov 2020 11:08:24 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 26 Nov 2020 11:08:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, gregkh@linuxfoundation.org,
        rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] genirq/affinity: Add irq_update_affinity_desc()
In-Reply-To: <80e0a19b-3291-1304-1a5b-0445c49efe31@huawei.com>
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
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <d696d314514a4bd53c85f2da73a23eed@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: john.garry@huawei.com, tglx@linutronix.de, gregkh@linuxfoundation.org, rafael@kernel.org, martin.petersen@oracle.com, jejb@linux.ibm.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,

On 2020-11-26 10:47, John Garry wrote:
> Hi Marc,
> 
>>> Right, I did consider this.
>> 
>> FWIW, I've pushed my hack branch[1]
> 
> Did you miss that reference?

I did:

https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=irq/hacks

> 
>> out with a couple of patches
>> for you to try (the top 3 patches). They allow platform-MSI domains
>> created by devices (mbigen, ICU) to be advertised as shared between
>> devices, so that the low-level driver can handle that in an 
>> appropriate
>> way.
>> 
>> I gave it a go on my D05 and nothing blew up, but I can't really 
>> remove
>> the kernel module, as that's where my disks are... :-/
> 
> You still should be able to enable my favorite
> CONFIG_DEBUG_TEST_DRIVER_REMOVE=y, while the distro still boot. But
> I'll just test if you want.

Ah! Let me try that then. Having been debugging some ugly driver removal
lately, I wish I had known that config option and inflicted it on their
authors...

[...]

>> And while the mbigen port that is connected to the SAS controller
>> doesn't seem to be shared between endpoints, some other ports 
>> definitely
>> are:
>> 
>> # cat /sys/kernel/debug/irq/domains/\\_SB.MBI1
>> name:   \_SB.MBI1
>>   size:   409
>>   mapped: 192
>>   flags:  0x00000003
>> 
>> [...]
>> 
>> I guess that the other 217 lines are connected somewhere.
>> 
> 
> I think that is not the right one. See
> https://github.com/tianocore/edk2-platforms/blob/master/Silicon/Hisilicon/Hi1616/D05AcpiTables/Dsdt/D05Sas.asl#L101
> 

I know, I was just outlining the fact that some of the mbigen
ports are shared between devices, and MBI1 seems to be an example
of that (though my reading of ASL is... primitive).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
