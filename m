Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA458ECAAD8
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 08:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiIPIjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Sep 2022 04:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiIPIjX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2022 04:39:23 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EFFA74DD
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 01:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1663317562; x=1694853562;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JhphutqhpcWwjEr2ifRcm6wnemFFKh56Z2vsaTATu0M=;
  b=ek5h0/6+SCAsbWW8dWplxkDu+roSyMYlQTLJdeSUHMyPVLAdTHmpR3pf
   pV/GVnlFX93j9KC8KTeHcFh2ZeB57xxvqNRqbnTLy8jbOfW10B7bRWw6k
   KYi7DrFZgI/iw20GnrRHSzVrc+O1mPWYATIXAvNGZY6z7gGY+d8BuFEgE
   hYPK05wuXL+sDA0MktnmwCJ89meXH4GLeUw7M4VlBPFGvMqxki6pyf6Hg
   /+3Up1mcp9hrac8GW77jn1iSEIBrevEjNlxCwdZ7dy2qx73g4PZ5nMx7Q
   W7UloFMzz2fxTFBXHImCgqObohYifGDic2NB55l8gOJr37Pl5KGlRsrFM
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654531200"; 
   d="scan'208";a="211514360"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Sep 2022 16:39:21 +0800
IronPort-SDR: kfD2vm1XwOVsIzFWZG2QxnXiod+7i6TWShdkTapAFu2373y06QwspliB9iLPrUMSgt8LarTNFa
 GEEhFLqgzRc09ovacDzc3T8om35PK+a2cN+N/t1MsuBT4tFCF2xDujSigrqdyX70zUEuTPytPU
 rF9/S3IHgCA8/2Rz+dJR5MVL1wmRBbGnix/X3oflbM5Ac/9eEsnCD07c2krcZTkru4tCjq8BeN
 6eB2sZyVYMNmqTXqNB2Aqn75XFMAZuiy6YbCXxq14XZblKUQ4gZyRLH0w7hhTcH7+Qrd+3PeIl
 j6Y898Kn82ozoUIfhapuMbF0
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Sep 2022 00:59:32 -0700
IronPort-SDR: /lBpI2rFFYA0zdLpYz7PnzXT1bE8/WBZSfMSc1Kcr/JYCWH/pn5aec5Iy34aKpvtHJf2LVeTyp
 YPf63KFDSKhABaejBmedC4ibmRdkDJqslWqo/fPt7gfJch48Za/NsvEuuR7BY90OZOOx/roJc2
 u6NksebFJyAJxWw8g+L51VySU5izv1L0DXhjr0w5axL4X4iCNvtwbY69TQJfbH0cxJBX27mDwT
 K2pF9sY+NQ2zFblZTQcxgz3e4IFcUu1thLyxP5JmlhgDFYVS9NQfa6vWmw1OBJChkRbmttQRNE
 zgs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Sep 2022 01:39:22 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MTSD93ysNz1RvTp
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 01:39:21 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1663317560; x=1665909561; bh=JhphutqhpcWwjEr2ifRcm6wnemFFKh56Z2v
        saTATu0M=; b=b4KFJDvR8xSZe8MUubNzZxxKAz/w/4GWKc2eRvgko/krwRFDUlK
        bfKD4Ee2xVMHxgz2xemYWOg2iwgoVozQ11dsrWbh/0pgrx1Yj8QtxomiSV6eD3PO
        yZ8VJNiCCSNtmk8bHtLlGsTa4bGjs14uMsycTI4OneKrqF4HNGQIYsMWiRTOaVZv
        BhOkzgSXqhurUXvAFubtV7w07mPvSWVYd/JfecoFE3bu6JvY23+NMPBG9b9+h3aT
        I5edNBJb3gBgUbZjfCAKI6glz7zQRTp3iP9Yv9qVUk/Bux00vO3RCni56574jqDA
        OkJ0Bl1CYcOYxtBUtPgrL5wnyqSL2vemDGA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bM_NW2oyPSfg for <linux-scsi@vger.kernel.org>;
        Fri, 16 Sep 2022 01:39:20 -0700 (PDT)
Received: from [10.225.1.43] (unknown [10.225.1.43])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MTSD53T7rz1RvLy;
        Fri, 16 Sep 2022 01:39:17 -0700 (PDT)
Message-ID: <60543841-8173-e41c-2d55-f0f3bd2b2c7c@opensource.wdc.com>
Date:   Fri, 16 Sep 2022 09:39:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
To:     matoro <matoro_mailinglist_kernel@matoro.tk>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
 <yq1a6dzkcgb.fsf@ca-mkp.ca.oracle.com>
 <CAK=zhgosaNGejvNq9ANzhuHqwLSxfckfdhLAX_r2y=9DN=oAvA@mail.gmail.com>
 <13f2f53e87ff7b653c46c3da19ea8115@matoro.tk>
 <fdb96df5-a9a2-673a-6f4c-bef2f14c23cc@opensource.wdc.com>
 <840410bd27c152079ea4cd483d58f416@matoro.tk>
 <6f7eb148-0506-a0de-3931-962b68d70fad@opensource.wdc.com>
 <03a8ae3e5179a817c551b80d3dfc41a3@matoro.tk>
 <fed3347f-6649-1a7d-f354-f3c7cd206050@opensource.wdc.com>
 <7e26f8493fbd321e010930f2b636859c@matoro.tk>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <7e26f8493fbd321e010930f2b636859c@matoro.tk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/09/15 16:55, matoro wrote:
> Hi Damien, apologies for continuing to bother.  Did you get a chance to 
> put together a quick fix for this to test?

Not yet. Have been super busy with Plumbers & travel and other stuff. This is
still at the top of my to do list. Will try to send you something to test today.

> 
> -------- Original Message --------
> Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
> Date: 2022-08-22 13:53
>  From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> To: matoro <matoro_mailinglist_kernel@matoro.tk>
> 
> On 2022/08/22 10:51, matoro wrote:
>> Hi Damien, were you able to put together a fix to test?  We're up to
>> 5.19.3 now and 5.18 was just marked EOL, so I want to make sure this
>> doesn't drop off the radar.
> 
> No, sorry, I have been busy as I am traveling. Flying back home this 
> week, so
> likely will have more time next week.
> 
>>
>> -------- Original Message --------
>> Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
>> Date: 2022-08-11 15:17
>>  From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> To: matoro <matoro_mailinglist_kernel@matoro.tk>
>>
>> On 2022/08/11 12:05, matoro wrote:
>>> Just a small update, the module stuff turned out to be a separate,
>>> unrelated regression.  I bisected that one also (applying these 
>>> reverts
>>> each time to allow me to boot) and reported it to Masahiro, who put in
>>> a
>>> fix for it here:
>>> https://lore.kernel.org/all/20220809141117.641543-1-masahiroy@kernel.org/
>>> .  So you can ignore that stuff.  Are these two commits still planned
>>> to
>>> be reverted?
>>
>> Revert should be a last resort (I really want to get rid of all these
>> sparse
>> warnings !). Let me first try to generate a fix for you to test.
>>
>>>
>>> -------- Original Message --------
>>> Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
>>> Date: 2022-08-02 19:36
>>>  From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>> To: matoro <matoro_mailinglist_kernel@matoro.tk>, Sreekanth Reddy
>>> <sreekanth.reddy@broadcom.com>
>>>
>>> On 8/3/22 05:27, matoro wrote:
>>>> Hi folks, sorry for the lateness, unfortunately this is in fact 
>>>> broken
>>>> on BE.  I use mpt3sas on sparc and my drives fail to come up on 5.19,
>>>> bisected to this patchset.  Reverting both of the endian-related
>>>> commits, b4efbec4c2a75b619fae4e8768be379e88c78687 and
>>>> 7ab4d2441b952977556672c2fe3f4c2a698cbb37, allows it to boot.  
>>>> However,
>>>> after booting, I can't load any modules - everything errors with
>>>> "disagrees about version of symbol module_layout".  I have completely
>>>> wiped out kernel sources, the module tree, and the kernel image,
>>>> rebuilding both from scratch with ONLY the revert patch applied, but 
>>>> I
>>>> still can't load any modules.  Presumably it would work with
>>>> CONFIG_MODVERSIONS=n, but these CRC checks are there for a reason and
>>>> I
>>>> can't tell if it has something to do with the revert or not.
>>>
>>> For b4efbec4c2a75b619fae4e8768be379e88c78687, removing the
>>> cpu_to_le32()
>>> call results in the bytes actually being reversed by writel()/readl()
>>> for
>>> your BE machine. So it looks like the values that need to be written 
>>> to
>>> the HBA have to be in CPU endian, not le32. Should be easy to fix.
>>> And for 7ab4d2441b952977556672c2fe3f4c2a698cbb37, this looks like the
>>> same
>>> problem.
>>>
>>> I will be traveling and busy this week, but I can have a look at a fix
>>> next Monday. If the Broadcom folks can send a fix faster than that,
>>> that
>>> is of course welcome :)
>>>
>>>>
>>>> $ modprobe --dump-modversions
>>>> /lib/modules/5.19.0-gentoo-sparc64/kernel/fs/openpromfs/openpromfs.ko
>>>> |
>>>> grep "module_layout"
>>>> 0xa6c23707      module_layout
>>>> $ grep "module_layout" /usr/src/linux/Module.symvers
>>>> 0xa6c23707      module_layout   vmlinux EXPORT_SYMBOL
>>>>
>>>> If you need real hardware access and do not have any on hand, please
>>>> reach out and I can provide temporary access!
>>>>
>>>> Here is the full error on vanilla 5.19:
>>>>
>>>> mpt3sas version 42.100.00.00 loaded
>>>> mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem
>>>> (32650280 kB)
>>>> mpt2sas_cm0: _base_wait_for_doorbell_not_used: failed due to timeout
>>>> count(5000), doorbell_reg(18000000)!
>>>> mpt2sas_cm0: CurrentHostPageSize is 0: Setting default host page size
>>>> to
>>>> 4k
>>>> mpt2sas_cm0: MSI-X vectors supported: 1
>>>>           no of cores: 64, max_msix_vectors: -1
>>>> mpt2sas_cm0:  0 1 1
>>>> mpt2sas_cm0: pci_alloc_irq_vectors failed (r=-22) !!!
>>>> mpt2sas_cm0: High IOPs queues : disabled
>>>> mpt2sas0: IO-APIC enabled: IRQ 4
>>>> mpt2sas_cm0: iomem(0x0000084100000000), mapped(0x(____ptrval____)),
>>>> size(16384)
>>>> mpt2sas_cm0: ioport(0x0000085100000000), size(256)
>>>> mpt2sas_cm0: doorbell is in use (line=6869)
>>>> mpt2sas_cm0: _base_get_ioc_facts: handshake failed (r=-14)
>>>> mpt2sas_cm0: failure at
>>>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:12336/_scsih_probe()!
>>>> mpt2sas_cm1: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem
>>>> (32650280 kB)
>>>> mpt2sas_cm1: _base_wait_for_doorbell_not_used: failed due to timeout
>>>> count(5000), doorbell_reg(18000000)!
>>>> mpt2sas_cm1: CurrentHostPageSize is 0: Setting default host page size
>>>> to
>>>> 4k
>>>> mpt2sas_cm1: MSI-X vectors supported: 1
>>>>           no of cores: 64, max_msix_vectors: -1
>>>> mpt2sas_cm1:  0 1 1
>>>> mpt2sas_cm1: pci_alloc_irq_vectors failed (r=-22) !!!
>>>> mpt2sas_cm1: High IOPs queues : disabled
>>>> mpt2sas1: IO-APIC enabled: IRQ 5
>>>> mpt2sas_cm1: iomem(0x0000084120000000), mapped(0x(____ptrval____)),
>>>> size(16384)
>>>> mpt2sas_cm1: ioport(0x0000085100002000), size(256)
>>>> mpt2sas_cm1: doorbell is in use (line=6869)
>>>> mpt2sas_cm1: _base_get_ioc_facts: handshake failed (r=-14)
>>>> mpt2sas_cm1: failure at
>>>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:12336/_scsih_probe()!
>>>>
>>>> -------- Original Message --------
>>>> Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
>>>> Date: 2022-03-09 01:35
>>>>  From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
>>>> To: "Martin K. Petersen" <martin.petersen@oracle.com>
>>>>
>>>> On Wed, Mar 9, 2022 at 9:26 AM Martin K. Petersen
>>>> <martin.petersen@oracle.com> wrote:
>>>>>
>>>>>
>>>>> Sreekanth,
>>>>>
>>>>>> This series fix (remove) all sparse warnings generated when
>>>>>> compiling
>>>>>> the mpt3sas driver. All warnings are related to __iomem access and
>>>>>> endianness.
>>>>>
>>>>> Please review this series and validate the patch 5 modification.
>>>>
>>>> Martin,
>>>> This patch set looks good, but before acknowledging this patch set I
>>>> just wanted to do some basic testing on a big endian machine.
>>>> Currently I don't have a big endian machine, internally I am checking
>>>> to get access to big endian machines. Meanwhile if anyone does a 
>>>> basic
>>>> testing on any big endian machine then please let me know. I will add
>>>> the acknowledgement signature.
>>>>
>>>> Thanks,
>>>> Sreekanth
>>>>
>>>>>
>>>>> Thanks!
>>>>>
>>>>> --
>>>>> Martin K. Petersen      Oracle Linux Engineering
>>>
>>
> 

-- 
Damien Le Moal
Western Digital Research

