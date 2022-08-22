Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FD8C28D13
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Aug 2022 17:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237305AbiHVRyE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 13:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbiHVRyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 13:54:03 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ECE4505B
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 10:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1661190840; x=1692726840;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HBWs3HYKQQ8NV+g2M2I3ixbN2Ubx6Qxgs4paYaJppEg=;
  b=iMT54erBsg6JKLksC3WvjR3W0wYY/RdEjTq02Dw+glRU5UzkCLt25j5P
   lXbKm3sfLlSSTATB54Y3o/SyweEWI4TK4cb9uYcFppA31z6R6hPhPyhm3
   ocTDbVawWKkNGORVD3yXeV/G+3gLh6lkU/iFy0a6MPL15RDXCj1dVJ+PN
   Trzufp7pJrq9twA6HwVe2Xq6hzm1gRhshcVBl08btdqRMFNG9VEgwcPmr
   O94LZYcdUljDeykxj1jvrFabNLAzuJokZcT+Z/5Y2DO4124voLYROCrZH
   UTejqI3MsG37hqaUzi8izKsLWOLVY2pqa5G5NjcRiD6T04GyEvWIlwM5j
   A==;
X-IronPort-AV: E=Sophos;i="5.93,255,1654531200"; 
   d="scan'208";a="313623858"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Aug 2022 01:53:59 +0800
IronPort-SDR: PGkcSPWkXVfp3/q8VZyCWFG66V9/uK8H+yIVuPc/AsCimz9CkFHoZszJzWWIDF8U6+YQnUOp+X
 brLHZQJLHd+ABnf6TKp4oaa+P3qF+mIkcYZYg5ehY62wttp8TJQilGOpU0Xx+/BaXtAEypkGYI
 ta5o01p4tCuS23v4Km1b9q0hfv/WSF1QN5N7F7DP2rFsOLwEYzEs08SqsUffnJjopBkB9C0fbt
 iDpFHNE7BZ62fwMSRrnM5cVZieLJbLvi60wvBOBeCXXsByOuphp45Cwji5DMdXTb4dw9jhMoZq
 XPpwzr/V0R9JQix4sOsOebwA
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Aug 2022 10:14:40 -0700
IronPort-SDR: io7IHoldMHPohkcsFkMyxwWHous03GtM62JWjMle73RKhgTt+x83O47yaLg7+Bwn8QiWPJAd1b
 hI7WNB4fX7rCI2fpYf9XiAU7K3dswPD9pMwmpZJnBzuNHomeS3WLFX2zor3FPDpKKxoxy0GHcM
 IZHuFYZ1pIjaEcuOTzqEyNJuAW9715wXqfdJqfpGOib53rhhzQ7xZ0ulaVjDCZG62La2rc+ogx
 /+AyKRqaAEZZhqhHLVffypOvSFJzjt0sb0Fz7MQfMNaSh1DDDXgaizVby5V949vXctMne/itUR
 ayM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Aug 2022 10:54:00 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MBKjg1ptgz1Rwnl
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2022 10:53:59 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1661190838; x=1663782839; bh=HBWs3HYKQQ8NV+g2M2I3ixbN2Ubx6Qxgs4p
        aYaJppEg=; b=TSrkkrV2H/y/FWrWarIFLuq93D1eCIRFv8LQ+OQTioA9Kx3e1M2
        YdP2S2XROQNDmqJQY8VIIm8pSFXZYX+6zVQN5g3pn6reozH6aI1fsTRR+zWECYz0
        LQonZPemEXrovp1d4JMlgDiLRlNIIxXlyZEQNV5ZlKwHMcNbYS7dnvZ2ylBlrnYw
        dIAsZHBDx9ekkfgc0WwABHRY/zH0lcmgCB/ojQ4yj+Jx2VY9jpIiG6zNxl3GMUzl
        oMrbA8H7yREvDg29uAsQKTxkvFdinSh8DeDU4qTWGVbsYVaYH17cyAsxbxl4aNUY
        E8qadO7tnmJ125zu8IBrs6HlsGNHzZ95uVQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MrbaeQtl5Dvc for <linux-scsi@vger.kernel.org>;
        Mon, 22 Aug 2022 10:53:58 -0700 (PDT)
Received: from [10.111.64.29] (c02drav6md6t.sdcorp.global.sandisk.com [10.111.64.29])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MBKjd6llNz1RtVk;
        Mon, 22 Aug 2022 10:53:57 -0700 (PDT)
Message-ID: <fed3347f-6649-1a7d-f354-f3c7cd206050@opensource.wdc.com>
Date:   Mon, 22 Aug 2022 10:53:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
Content-Language: en-US
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
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <03a8ae3e5179a817c551b80d3dfc41a3@matoro.tk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/08/22 10:51, matoro wrote:
> Hi Damien, were you able to put together a fix to test?  We're up to 
> 5.19.3 now and 5.18 was just marked EOL, so I want to make sure this 
> doesn't drop off the radar.

No, sorry, I have been busy as I am traveling. Flying back home this week, so
likely will have more time next week.

> 
> -------- Original Message --------
> Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
> Date: 2022-08-11 15:17
>  From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> To: matoro <matoro_mailinglist_kernel@matoro.tk>
> 
> On 2022/08/11 12:05, matoro wrote:
>> Just a small update, the module stuff turned out to be a separate,
>> unrelated regression.  I bisected that one also (applying these reverts
>> each time to allow me to boot) and reported it to Masahiro, who put in 
>> a
>> fix for it here:
>> https://lore.kernel.org/all/20220809141117.641543-1-masahiroy@kernel.org/
>> .  So you can ignore that stuff.  Are these two commits still planned 
>> to
>> be reverted?
> 
> Revert should be a last resort (I really want to get rid of all these 
> sparse
> warnings !). Let me first try to generate a fix for you to test.
> 
>>
>> -------- Original Message --------
>> Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
>> Date: 2022-08-02 19:36
>>  From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> To: matoro <matoro_mailinglist_kernel@matoro.tk>, Sreekanth Reddy
>> <sreekanth.reddy@broadcom.com>
>>
>> On 8/3/22 05:27, matoro wrote:
>>> Hi folks, sorry for the lateness, unfortunately this is in fact broken
>>> on BE.  I use mpt3sas on sparc and my drives fail to come up on 5.19,
>>> bisected to this patchset.  Reverting both of the endian-related
>>> commits, b4efbec4c2a75b619fae4e8768be379e88c78687 and
>>> 7ab4d2441b952977556672c2fe3f4c2a698cbb37, allows it to boot.  However,
>>> after booting, I can't load any modules - everything errors with
>>> "disagrees about version of symbol module_layout".  I have completely
>>> wiped out kernel sources, the module tree, and the kernel image,
>>> rebuilding both from scratch with ONLY the revert patch applied, but I
>>> still can't load any modules.  Presumably it would work with
>>> CONFIG_MODVERSIONS=n, but these CRC checks are there for a reason and 
>>> I
>>> can't tell if it has something to do with the revert or not.
>>
>> For b4efbec4c2a75b619fae4e8768be379e88c78687, removing the 
>> cpu_to_le32()
>> call results in the bytes actually being reversed by writel()/readl()
>> for
>> your BE machine. So it looks like the values that need to be written to
>> the HBA have to be in CPU endian, not le32. Should be easy to fix.
>> And for 7ab4d2441b952977556672c2fe3f4c2a698cbb37, this looks like the
>> same
>> problem.
>>
>> I will be traveling and busy this week, but I can have a look at a fix
>> next Monday. If the Broadcom folks can send a fix faster than that, 
>> that
>> is of course welcome :)
>>
>>>
>>> $ modprobe --dump-modversions
>>> /lib/modules/5.19.0-gentoo-sparc64/kernel/fs/openpromfs/openpromfs.ko
>>> |
>>> grep "module_layout"
>>> 0xa6c23707      module_layout
>>> $ grep "module_layout" /usr/src/linux/Module.symvers
>>> 0xa6c23707      module_layout   vmlinux EXPORT_SYMBOL
>>>
>>> If you need real hardware access and do not have any on hand, please
>>> reach out and I can provide temporary access!
>>>
>>> Here is the full error on vanilla 5.19:
>>>
>>> mpt3sas version 42.100.00.00 loaded
>>> mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem
>>> (32650280 kB)
>>> mpt2sas_cm0: _base_wait_for_doorbell_not_used: failed due to timeout
>>> count(5000), doorbell_reg(18000000)!
>>> mpt2sas_cm0: CurrentHostPageSize is 0: Setting default host page size
>>> to
>>> 4k
>>> mpt2sas_cm0: MSI-X vectors supported: 1
>>>           no of cores: 64, max_msix_vectors: -1
>>> mpt2sas_cm0:  0 1 1
>>> mpt2sas_cm0: pci_alloc_irq_vectors failed (r=-22) !!!
>>> mpt2sas_cm0: High IOPs queues : disabled
>>> mpt2sas0: IO-APIC enabled: IRQ 4
>>> mpt2sas_cm0: iomem(0x0000084100000000), mapped(0x(____ptrval____)),
>>> size(16384)
>>> mpt2sas_cm0: ioport(0x0000085100000000), size(256)
>>> mpt2sas_cm0: doorbell is in use (line=6869)
>>> mpt2sas_cm0: _base_get_ioc_facts: handshake failed (r=-14)
>>> mpt2sas_cm0: failure at
>>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:12336/_scsih_probe()!
>>> mpt2sas_cm1: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem
>>> (32650280 kB)
>>> mpt2sas_cm1: _base_wait_for_doorbell_not_used: failed due to timeout
>>> count(5000), doorbell_reg(18000000)!
>>> mpt2sas_cm1: CurrentHostPageSize is 0: Setting default host page size
>>> to
>>> 4k
>>> mpt2sas_cm1: MSI-X vectors supported: 1
>>>           no of cores: 64, max_msix_vectors: -1
>>> mpt2sas_cm1:  0 1 1
>>> mpt2sas_cm1: pci_alloc_irq_vectors failed (r=-22) !!!
>>> mpt2sas_cm1: High IOPs queues : disabled
>>> mpt2sas1: IO-APIC enabled: IRQ 5
>>> mpt2sas_cm1: iomem(0x0000084120000000), mapped(0x(____ptrval____)),
>>> size(16384)
>>> mpt2sas_cm1: ioport(0x0000085100002000), size(256)
>>> mpt2sas_cm1: doorbell is in use (line=6869)
>>> mpt2sas_cm1: _base_get_ioc_facts: handshake failed (r=-14)
>>> mpt2sas_cm1: failure at
>>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:12336/_scsih_probe()!
>>>
>>> -------- Original Message --------
>>> Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
>>> Date: 2022-03-09 01:35
>>>  From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
>>> To: "Martin K. Petersen" <martin.petersen@oracle.com>
>>>
>>> On Wed, Mar 9, 2022 at 9:26 AM Martin K. Petersen
>>> <martin.petersen@oracle.com> wrote:
>>>>
>>>>
>>>> Sreekanth,
>>>>
>>>>> This series fix (remove) all sparse warnings generated when 
>>>>> compiling
>>>>> the mpt3sas driver. All warnings are related to __iomem access and
>>>>> endianness.
>>>>
>>>> Please review this series and validate the patch 5 modification.
>>>
>>> Martin,
>>> This patch set looks good, but before acknowledging this patch set I
>>> just wanted to do some basic testing on a big endian machine.
>>> Currently I don't have a big endian machine, internally I am checking
>>> to get access to big endian machines. Meanwhile if anyone does a basic
>>> testing on any big endian machine then please let me know. I will add
>>> the acknowledgement signature.
>>>
>>> Thanks,
>>> Sreekanth
>>>
>>>>
>>>> Thanks!
>>>>
>>>> --
>>>> Martin K. Petersen      Oracle Linux Engineering
>>
> 


-- 
Damien Le Moal
Western Digital Research
