Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49246C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 23:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiHBXgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 19:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiHBXgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 19:36:10 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FBEDF4D
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 16:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1659483369; x=1691019369;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=N8wMYVdLrWmKyU/6iiST3jSGdiVrToaUwR5oSxGgUoI=;
  b=mbC2oq9xWcG4O6IKJeWMwd5BSCyqNM5bi1DFmX5dyCug5jsaN2GqwO6g
   IPnXyMb/Z8MWa3LlHUrNCgA98JW4aD0eac/VhcteCWokAYtRmFPdLepRX
   8s9CH17dvTjZASH7xT7zbaCaXwO5YjSFOQcIC+ZmDphog4ISffFoszDln
   S+fl40+lo397mb81BuAkxFK3hJcZwBwBR7Q1wcfixH1vOfUeibfQ+016p
   9+O+z3wXuWYSZGVCDot/HPkewA0ABb4TmfdvV0IP/3XESIB1F6LZPDumB
   F9eNqlyvhULgcgetloWnUkoNDBM00JLrn7/2hoseZ8HGmVkNJkcWheV5H
   g==;
X-IronPort-AV: E=Sophos;i="5.93,212,1654531200"; 
   d="scan'208";a="212617222"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Aug 2022 07:36:08 +0800
IronPort-SDR: 1J6n9QXl4zD09Z+n/5w/sALTfrSo3jOEI33jMASMKtDFuk1z4P4q9zGBykBJLtwbRZzNc1WPgA
 LgnNWMa6pVTjRuFvmucl0QJW8yrwjdbOrzvl0oHB0ANh1G4jM85Amjd3UnMNS0HzCJIVJGggvC
 s7/8fJkFfoeu3yUp4e7UljxaCruC0LJcC/aOn+iuTTculgBSwF5J6a3kY8w6jdhTkHPg75B2E3
 gkIQfXyDq0qJKaV5bvK7F/jVnrC+eL0M6/ylCrOJVanXtEqaKJ4MMuFBoDFcan6AGXihFkC5Gb
 jwTTm8GfYq4xHK08NV6F27FC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Aug 2022 15:52:05 -0700
IronPort-SDR: ZT2WJhhBv8KNbiuSn+CiwiQqgUIqyvpNp6R/NeIHAfImdAYoqxCZzLo4VlMYT2yv/vnOJhH8A9
 0uatIuq+FkEDW/u5SjgM6WjfK6rFipON36UM1M0z+wdC7nWFLiRw6C8irOAlWQ9idgrabZD6bv
 avphW+mUKR0KK8HG+qLndHlWNioo3tEH/3cLY/4X1WTqqk4oZBNJBGKPc+rHOdu+bzTo6FWgvJ
 8sjhq9F6LBjaxbL+OBpCIycm9uspC+DV74vhAOxoDC3gpyZD3LHOgBljap3vu10ljvljLaN3BX
 L+8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Aug 2022 16:36:09 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LyBFh362vz1Rwnx
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 16:36:08 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1659483366; x=1662075367; bh=N8wMYVdLrWmKyU/6iiST3jSGdiVrToaUwR5
        oSxGgUoI=; b=GQWLk8cF9274bPnl/xIVHxwqoV5OOiwLcp9VkWEy0eX75KoPvP8
        SCXJThE/bbQkE/0TVe8tpZI/kw6BmKQry90kdqLIK8C0T81QxrIXL2q+/aUjMtdM
        NKn/hlUnVXUcRvcgcfyNHdFKAq2kqRDZ7I69C3TgSEeOQVgt6qiVNQ6lIpkCubzN
        43ud1YcF9irmsO7XmccTpnNhKxH24PrMQpqnJCwNpsAgpNwkCZd4mffb1de+ZTwM
        pB5tWKMva2G0eQB2RX91qbAWVkoBPAd+nqTEoQsbagV2xXjztyJ6GgkjpajRH45J
        XQQwQ84dyJWkUYES68VnWc0Ohm0Uw5vhfNA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DskHe5qycA9G for <linux-scsi@vger.kernel.org>;
        Tue,  2 Aug 2022 16:36:06 -0700 (PDT)
Received: from [10.225.163.22] (unknown [10.225.163.22])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LyBFd5vJ3z1RtVk;
        Tue,  2 Aug 2022 16:36:05 -0700 (PDT)
Message-ID: <fdb96df5-a9a2-673a-6f4c-bef2f14c23cc@opensource.wdc.com>
Date:   Wed, 3 Aug 2022 08:36:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
Content-Language: en-US
To:     matoro <matoro_mailinglist_kernel@matoro.tk>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
 <yq1a6dzkcgb.fsf@ca-mkp.ca.oracle.com>
 <CAK=zhgosaNGejvNq9ANzhuHqwLSxfckfdhLAX_r2y=9DN=oAvA@mail.gmail.com>
 <13f2f53e87ff7b653c46c3da19ea8115@matoro.tk>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <13f2f53e87ff7b653c46c3da19ea8115@matoro.tk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/3/22 05:27, matoro wrote:
> Hi folks, sorry for the lateness, unfortunately this is in fact broken 
> on BE.  I use mpt3sas on sparc and my drives fail to come up on 5.19, 
> bisected to this patchset.  Reverting both of the endian-related 
> commits, b4efbec4c2a75b619fae4e8768be379e88c78687 and 
> 7ab4d2441b952977556672c2fe3f4c2a698cbb37, allows it to boot.  However, 
> after booting, I can't load any modules - everything errors with 
> "disagrees about version of symbol module_layout".  I have completely 
> wiped out kernel sources, the module tree, and the kernel image, 
> rebuilding both from scratch with ONLY the revert patch applied, but I 
> still can't load any modules.  Presumably it would work with 
> CONFIG_MODVERSIONS=n, but these CRC checks are there for a reason and I 
> can't tell if it has something to do with the revert or not.

For b4efbec4c2a75b619fae4e8768be379e88c78687, removing the cpu_to_le32()
call results in the bytes actually being reversed by writel()/readl() for
your BE machine. So it looks like the values that need to be written to
the HBA have to be in CPU endian, not le32. Should be easy to fix.
And for 7ab4d2441b952977556672c2fe3f4c2a698cbb37, this looks like the same
problem.

I will be traveling and busy this week, but I can have a look at a fix
next Monday. If the Broadcom folks can send a fix faster than that, that
is of course welcome :)

> 
> $ modprobe --dump-modversions 
> /lib/modules/5.19.0-gentoo-sparc64/kernel/fs/openpromfs/openpromfs.ko  | 
> grep "module_layout"
> 0xa6c23707      module_layout
> $ grep "module_layout" /usr/src/linux/Module.symvers
> 0xa6c23707      module_layout   vmlinux EXPORT_SYMBOL
> 
> If you need real hardware access and do not have any on hand, please 
> reach out and I can provide temporary access!
> 
> Here is the full error on vanilla 5.19:
> 
> mpt3sas version 42.100.00.00 loaded
> mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem 
> (32650280 kB)
> mpt2sas_cm0: _base_wait_for_doorbell_not_used: failed due to timeout 
> count(5000), doorbell_reg(18000000)!
> mpt2sas_cm0: CurrentHostPageSize is 0: Setting default host page size to 
> 4k
> mpt2sas_cm0: MSI-X vectors supported: 1
>           no of cores: 64, max_msix_vectors: -1
> mpt2sas_cm0:  0 1 1
> mpt2sas_cm0: pci_alloc_irq_vectors failed (r=-22) !!!
> mpt2sas_cm0: High IOPs queues : disabled
> mpt2sas0: IO-APIC enabled: IRQ 4
> mpt2sas_cm0: iomem(0x0000084100000000), mapped(0x(____ptrval____)), 
> size(16384)
> mpt2sas_cm0: ioport(0x0000085100000000), size(256)
> mpt2sas_cm0: doorbell is in use (line=6869)
> mpt2sas_cm0: _base_get_ioc_facts: handshake failed (r=-14)
> mpt2sas_cm0: failure at 
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:12336/_scsih_probe()!
> mpt2sas_cm1: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem 
> (32650280 kB)
> mpt2sas_cm1: _base_wait_for_doorbell_not_used: failed due to timeout 
> count(5000), doorbell_reg(18000000)!
> mpt2sas_cm1: CurrentHostPageSize is 0: Setting default host page size to 
> 4k
> mpt2sas_cm1: MSI-X vectors supported: 1
>           no of cores: 64, max_msix_vectors: -1
> mpt2sas_cm1:  0 1 1
> mpt2sas_cm1: pci_alloc_irq_vectors failed (r=-22) !!!
> mpt2sas_cm1: High IOPs queues : disabled
> mpt2sas1: IO-APIC enabled: IRQ 5
> mpt2sas_cm1: iomem(0x0000084120000000), mapped(0x(____ptrval____)), 
> size(16384)
> mpt2sas_cm1: ioport(0x0000085100002000), size(256)
> mpt2sas_cm1: doorbell is in use (line=6869)
> mpt2sas_cm1: _base_get_ioc_facts: handshake failed (r=-14)
> mpt2sas_cm1: failure at 
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:12336/_scsih_probe()!
> 
> -------- Original Message --------
> Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
> Date: 2022-03-09 01:35
>  From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> To: "Martin K. Petersen" <martin.petersen@oracle.com>
> 
> On Wed, Mar 9, 2022 at 9:26 AM Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
>>
>>
>> Sreekanth,
>>
>>> This series fix (remove) all sparse warnings generated when compiling
>>> the mpt3sas driver. All warnings are related to __iomem access and
>>> endianness.
>>
>> Please review this series and validate the patch 5 modification.
> 
> Martin,
> This patch set looks good, but before acknowledging this patch set I
> just wanted to do some basic testing on a big endian machine.
> Currently I don't have a big endian machine, internally I am checking
> to get access to big endian machines. Meanwhile if anyone does a basic
> testing on any big endian machine then please let me know. I will add
> the acknowledgement signature.
> 
> Thanks,
> Sreekanth
> 
>>
>> Thanks!
>>
>> --
>> Martin K. Petersen      Oracle Linux Engineering


-- 
Damien Le Moal
Western Digital Research
