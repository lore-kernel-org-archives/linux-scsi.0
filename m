Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AD9C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 20:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbiHBU5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 16:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiHBU5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 16:57:53 -0400
X-Greylist: delayed 901 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 Aug 2022 13:57:49 PDT
Received: from matoro.tk (unknown [IPv6:2600:1700:4b10:9d80::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC97B3343A
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 13:57:49 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; bh=5DFPP0n4DmDOwamhT1hD0Oc4C340Dw1o4ps4m/R3rxA=;
 c=relaxed/relaxed; d=matoro.tk;
 h=Subject:Subject:Sender:To:To:Cc:Cc:From:From:Date:Date:MIME-Version:MIME-Version:Content-Type:Content-Type:Content-Transfer-Encoding:Content-Transfer-Encoding:Reply-To:In-Reply-To:In-Reply-To:Message-Id:Message-Id:References:References:Autocrypt:Openpgp;
 i=@matoro.tk; s=20220801; t=1659472053; v=1; x=1659904053;
 b=zf5BFvw83Dby+CW2WHnEYm2qbqqSeXq0y0LQvXNkGqjf1pMR6MuvxQKQjWn9Q+GvqScUbmOd
 HCwewa+SaOh1WDZF3fPSMqY9MYcwxVs7EIQ3ZSL+AalhgsTcR81Yb5Xc9XiPrcDlbqhXe/0vUro
 2oGHWfv8tIw6oWt7WUyndmRL9wXMXXT6T44maLri61pxKcf7JANY7hFXx2EvY4CKoCc1y1DH8vj
 3r5SnpZCz8a76ZdshXiY4eLYRLfaBhnHLGW2kXPJKc5Gd6zGtZoLCNTK9uCLxMBFt6CaognVRIZ
 YiWOle9abp0hq+yLiXnB03NraRkmTgcRE0JIPJBYBFq1KDdIK3kwydq1wxHQmnImkDIoghZdgar
 OhMIyijtXpFknlbpU37ZWEqLwiTvK2Zhb9z01mwPqmlGRR9/xag5sTh7+KgN6VtnqiCY4KR76tQ
 TcndWKXCnbtRqXNV7oobEeAYVHve3f9SIUd24+m2r6WPgrs44ncqCyNWl3Qybh6NnHbH1m8o0T3
 cLnwZgGW9//NVQ6c5NN3dwCEOtzjUyHE/l2dvnbNxvpFb62pMmHBPKH/6lbd8YKq1xxdte8xWcx
 zP4s1TO7fXVarN9eLagb+9FzDqvbort4S8H98Lzd84RIDugeE+NakhLo2+JE/uAbApiTUFcGbXg
 QXwK9W0PqaQ=
Received: by matoro.tk (envelope-sender
 <matoro_mailinglist_kernel@matoro.tk>) with ESMTPS id c6f1c5bb; Tue, 02 Aug
 2022 16:27:33 -0400
MIME-Version: 1.0
Date:   Tue, 02 Aug 2022 16:27:33 -0400
From:   matoro <matoro_mailinglist_kernel@matoro.tk>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
In-Reply-To: <CAK=zhgosaNGejvNq9ANzhuHqwLSxfckfdhLAX_r2y=9DN=oAvA@mail.gmail.com>
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
 <yq1a6dzkcgb.fsf@ca-mkp.ca.oracle.com>
 <CAK=zhgosaNGejvNq9ANzhuHqwLSxfckfdhLAX_r2y=9DN=oAvA@mail.gmail.com>
Message-ID: <13f2f53e87ff7b653c46c3da19ea8115@matoro.tk>
X-Sender: matoro_mailinglist_kernel@matoro.tk
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi folks, sorry for the lateness, unfortunately this is in fact broken 
on BE.  I use mpt3sas on sparc and my drives fail to come up on 5.19, 
bisected to this patchset.  Reverting both of the endian-related 
commits, b4efbec4c2a75b619fae4e8768be379e88c78687 and 
7ab4d2441b952977556672c2fe3f4c2a698cbb37, allows it to boot.  However, 
after booting, I can't load any modules - everything errors with 
"disagrees about version of symbol module_layout".  I have completely 
wiped out kernel sources, the module tree, and the kernel image, 
rebuilding both from scratch with ONLY the revert patch applied, but I 
still can't load any modules.  Presumably it would work with 
CONFIG_MODVERSIONS=n, but these CRC checks are there for a reason and I 
can't tell if it has something to do with the revert or not.

$ modprobe --dump-modversions 
/lib/modules/5.19.0-gentoo-sparc64/kernel/fs/openpromfs/openpromfs.ko  | 
grep "module_layout"
0xa6c23707      module_layout
$ grep "module_layout" /usr/src/linux/Module.symvers
0xa6c23707      module_layout   vmlinux EXPORT_SYMBOL

If you need real hardware access and do not have any on hand, please 
reach out and I can provide temporary access!

Here is the full error on vanilla 5.19:

mpt3sas version 42.100.00.00 loaded
mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem 
(32650280 kB)
mpt2sas_cm0: _base_wait_for_doorbell_not_used: failed due to timeout 
count(5000), doorbell_reg(18000000)!
mpt2sas_cm0: CurrentHostPageSize is 0: Setting default host page size to 
4k
mpt2sas_cm0: MSI-X vectors supported: 1
          no of cores: 64, max_msix_vectors: -1
mpt2sas_cm0:  0 1 1
mpt2sas_cm0: pci_alloc_irq_vectors failed (r=-22) !!!
mpt2sas_cm0: High IOPs queues : disabled
mpt2sas0: IO-APIC enabled: IRQ 4
mpt2sas_cm0: iomem(0x0000084100000000), mapped(0x(____ptrval____)), 
size(16384)
mpt2sas_cm0: ioport(0x0000085100000000), size(256)
mpt2sas_cm0: doorbell is in use (line=6869)
mpt2sas_cm0: _base_get_ioc_facts: handshake failed (r=-14)
mpt2sas_cm0: failure at 
drivers/scsi/mpt3sas/mpt3sas_scsih.c:12336/_scsih_probe()!
mpt2sas_cm1: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem 
(32650280 kB)
mpt2sas_cm1: _base_wait_for_doorbell_not_used: failed due to timeout 
count(5000), doorbell_reg(18000000)!
mpt2sas_cm1: CurrentHostPageSize is 0: Setting default host page size to 
4k
mpt2sas_cm1: MSI-X vectors supported: 1
          no of cores: 64, max_msix_vectors: -1
mpt2sas_cm1:  0 1 1
mpt2sas_cm1: pci_alloc_irq_vectors failed (r=-22) !!!
mpt2sas_cm1: High IOPs queues : disabled
mpt2sas1: IO-APIC enabled: IRQ 5
mpt2sas_cm1: iomem(0x0000084120000000), mapped(0x(____ptrval____)), 
size(16384)
mpt2sas_cm1: ioport(0x0000085100002000), size(256)
mpt2sas_cm1: doorbell is in use (line=6869)
mpt2sas_cm1: _base_get_ioc_facts: handshake failed (r=-14)
mpt2sas_cm1: failure at 
drivers/scsi/mpt3sas/mpt3sas_scsih.c:12336/_scsih_probe()!

-------- Original Message --------
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
Date: 2022-03-09 01:35
 From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>

On Wed, Mar 9, 2022 at 9:26 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> 
> 
> Sreekanth,
> 
> > This series fix (remove) all sparse warnings generated when compiling
> > the mpt3sas driver. All warnings are related to __iomem access and
> > endianness.
> 
> Please review this series and validate the patch 5 modification.

Martin,
This patch set looks good, but before acknowledging this patch set I
just wanted to do some basic testing on a big endian machine.
Currently I don't have a big endian machine, internally I am checking
to get access to big endian machines. Meanwhile if anyone does a basic
testing on any big endian machine then please let me know. I will add
the acknowledgement signature.

Thanks,
Sreekanth

> 
> Thanks!
> 
> --
> Martin K. Petersen      Oracle Linux Engineering
