Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BBB9C4727F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 13:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 426242072E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 13:57:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="M/9g6eCA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgI3N5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 09:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730188AbgI3N5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2020 09:57:07 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10242C061755
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2020 06:57:07 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id r24so1676586ljm.3
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2020 06:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1HoX2m3Rup2qjlGoAmjYztWqlB5VRRmFop7sA+4jwyc=;
        b=M/9g6eCAUe043EUtL5sLbjaQJaLLEErLJGVQoYx7r1yTQx0Z9DLfFwFr6Y2eWI5smT
         P0PvuemZvz58cnHLqZXCJ1fT3QV2i7DaW5tSZTAurSvOvaPBaBolTTEZR122vIVuHSTa
         TRv4zvH3qqBbIznQ2T1NIJ86vgMmcUYzqiIbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1HoX2m3Rup2qjlGoAmjYztWqlB5VRRmFop7sA+4jwyc=;
        b=uQJuhW1i2cVnWnPJ2ERuMoJN2x2HQI48181YBhYykHjh47tEH6gwHYR/kEn5yxLnjC
         3PtV8Uy+NpCDdsdOTkw9xZ0N3ztv2zO0kqKySoVVUhjN9XB4zTwy0J1h579cLpgjqSew
         uXg8tY7o1Y+soUbVSoHoQW4UHc3AlXfBVPznNoq4yRmojAF0tpnBdNGm3+jldooDnZ9v
         yEn7U+L8Gooi3eiiHuBdHGXjfxX23C30ANbxqV5KTgzRkiczwTCcDycVWXlfhW3zAVHH
         XJGimh9MOI1LND7dUXbS8JeGWRFnHrLISP6wI2ZlxQ4VESRBa2C7vkOqCjVdmdJihVZt
         X83g==
X-Gm-Message-State: AOAM531bgBBjRvNvy+KHU1IMNJQWr3iivzizkppNZ6Pp3yErHZsod3ga
        T5lK5khGHGNOKFhT9GxnqjNCOB5mfEYmD11OPlGZqw==
X-Google-Smtp-Source: ABdhPJxRgaVEC0Wx5RLIz6F1sq6WGQVKoH82naowANlRoD5CJuZFReynKSvvocDopgiR5f0KtMwfLnzhtXEFNIXU8dQ=
X-Received: by 2002:a2e:a411:: with SMTP id p17mr988159ljn.282.1601474225156;
 Wed, 30 Sep 2020 06:57:05 -0700 (PDT)
MIME-Version: 1.0
References: <CALnajPCsBkOnogZHF30g1XnAs6jLzGTQmsL4RyCA-ReHv=3ANQ@mail.gmail.com>
 <CA+RiK648dzV=sAEV03VrpEmLoxZnHcBHkmUbP0Q3wdBvCQ6YGQ@mail.gmail.com>
 <CALnajPDYZs+gPY8eN7thyYGyWu2j4W1uBN63LDyYwmjJtVb0vA@mail.gmail.com>
 <CALnajPAXKzBCprU0s2i7XMtLaDDYqmUXf+9cRFzw_Z3Wjn14BA@mail.gmail.com>
 <CALnajPBXsXgqWOth+ABF_HgLVPjQSESZ1w-wwmNZnvbaXfgsUQ@mail.gmail.com>
 <CA+RiK64a9Tj3orj6uQ4eNb1o2T--mwcwdsF1n6POLG++6oeQtw@mail.gmail.com>
 <CALnajPCfVfTyQJKt8dvu9qqoEuwqnZNNviKM+tkbYhrPqkyYhQ@mail.gmail.com> <CA+RiK65kPWbTHdKk_3qssEE75ZdihjiY8CMQc_T8f3c92DPDkg@mail.gmail.com>
In-Reply-To: <CA+RiK65kPWbTHdKk_3qssEE75ZdihjiY8CMQc_T8f3c92DPDkg@mail.gmail.com>
From:   Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Date:   Wed, 30 Sep 2020 19:31:05 +0530
Message-ID: <CA+RiK64tVv8xsRwR-UyAUCEWig+QRxzOSKt1_D_cFsSV2MuOLQ@mail.gmail.com>
Subject: Re: Bug 209177 - mpt2sas_cm0: failure at drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
To:     Sundar Nagarajan <sun.nagarajan@gmail.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005719ac05b0884612"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000005719ac05b0884612
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sundar,

Thanks for the logs,
From log, I could see that the HBA queue depth is very high "32455" as
shown below.
[   11.465416] mpt2sas_cm0: hba queue depth(32455), max chains per io(128).

In this patch "https://patchwork.kernel.org/patch/11505139/" driver is
allocating the
DMA-able memory for RDPQ's in sets of 16 reply queues using limitation
of Ventura
series controller.

With 32455 queue depth and above patch, Driver may request a large DMA-able
memory where the kernel may fail to allocate.

To confirm this, Please try by tuning the queue depth to 8000/10000 using t=
he
module parameter "mpt3sas.max_queue_depth=3D10000".

Thanks,
Suganath


On Wed, Sep 30, 2020 at 7:22 PM Suganath Prabu Subramani
<suganath-prabu.subramani@broadcom.com> wrote:
>
> Hi Sundar,
>
> Thanks for the logs,
> From log, i could see that HBA queue depth is very high "32455" as shown =
below.
> [   11.465416] mpt2sas_cm0: hba queue depth(32455), max chains per io(128=
).
>
> In this patch "https://patchwork.kernel.org/patch/11505139/" driver is al=
locating the
> DMA-able memory for RDPQ's in sets of 16 reply queues using limitation of=
 Ventura
> series controller.
>
> With 32455 queue depth and above patch driver may request a large DMA-abl=
e
> memory where kernel may fail to allocate.
>
> To confirm this, Please try by tuning the queue depth to 8000/10000 using=
 the
> module parameter "mpt3sas.max_queue_depth=3D10000".
>
> Thanks,
> Suganath
>
> On Wed, Sep 30, 2020 at 1:34 AM Sundar Nagarajan <sun.nagarajan@gmail.com=
> wrote:
>>
>> Thanks for your suggestions.
>>
>> I downloaded and used stock kernel 5.8.12 from kernel.org.
>> The two patches you pointed at are already applied in 5.8.12 (as you
>> had indicated).
>>
>> The problem still exists.
>> EDITED dmesg below, full dmesg output attached
>> I have also updated my kernel bugzilla report:
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D209177
>>
>>
>> [   10.110816] mpt2sas_cm0: mpt3sas_base_attach
>> [   10.110913] dca service started, version 1.12.1
>> [   10.122668] mpt2sas_cm0: mpt3sas_base_map_resources
>> [   10.140735] usb 2-1.7: New USB device found, idVendor=3D1546,
>> idProduct=3D01a6, bcdDevice=3D 7.03
>> [   10.147693] scsi host2: ahci
>> [   10.163432] usb 2-1.7: New USB device strings: Mfr=3D1, Product=3D2,
>> SerialNumber=3D0
>> [   10.173819] mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED,
>> total mem (197972228 kB)
>> [   10.189366] usb 2-1.7: Product: u-blox 6  -  GPS Receiver
>> [   10.206466] mpt2sas_cm0: _base_get_ioc_facts
>> [   10.219986] usb 2-1.7: Manufacturer: u-blox AG - www.u-blox.com
>> [   10.246805] mpt2sas_cm0: _base_wait_for_iocstate
>> [   10.260177] scsi host3: ahci
>> [   10.271074] scsi host4: ahci
>> [   10.281958] scsi host5: ahci
>> [   10.292565] scsi host6: ahci
>> [   10.299138] usb 2-1.8: new full-speed USB device number 6 using ehci-=
pci
>> [   10.303153] scsi host7: ahci
>> [   10.328158] ata1: SATA max UDMA/133 abar m2048@0xd1700000 port
>> 0xd1700100 irq 53
>> [   10.343989] ata2: SATA max UDMA/133 abar m2048@0xd1700000 port
>> 0xd1700180 irq 53
>> [   10.359546] ata3: SATA max UDMA/133 abar m2048@0xd1700000 port
>> 0xd1700200 irq 53
>> [   10.374807] ata4: SATA max UDMA/133 abar m2048@0xd1700000 port
>> 0xd1700280 irq 53
>> [   10.389813] ata5: SATA max UDMA/133 abar m2048@0xd1700000 port
>> 0xd1700300 irq 53
>> [   10.404635] ata6: SATA max UDMA/133 abar m2048@0xd1700000 port
>> 0xd1700380 irq 53
>> [   10.412371] scsi 0:0:0:0: Direct-Access     SanDisk  Ultra Fit
>>   1.00 PQ: 0 ANSI: 6
>> [   10.433718] usb 2-1.8: New USB device found, idVendor=3D051d,
>> idProduct=3D0003, bcdDevice=3D 1.06
>> [   10.435546] sd 0:0:0:0: Attached scsi generic sg0 type 0
>> [   10.450887] usb 2-1.8: New USB device strings: Mfr=3D1, Product=3D2,
>> SerialNumber=3D3
>> [   10.464152] offset:data
>> [   10.478544] usb 2-1.8: Product: Smart-UPS 2200 FW:UPS 06.3 / MCU 11.0
>> [   10.488004] mpt2sas_cm0: [0x00]:03100200
>> [   10.488004] mpt2sas_cm0: [0x04]:00002300
>> [   10.488005] mpt2sas_cm0: [0x08]:00000000
>> [   10.488005] mpt2sas_cm0: [0x0c]:00000000
>> [   10.488006] mpt2sas_cm0: [0x10]:00000000
>> [   10.488007] mpt2sas_cm0: [0x14]:00010080
>> [   10.488007] mpt2sas_cm0: [0x18]:22137ec7
>> [   10.488008] mpt2sas_cm0: [0x1c]:0001285c
>> [   10.488017] mpt2sas_cm0: [0x20]:14000600
>> [   10.501945] usb 2-1.8: Manufacturer: American Power Conversion
>> [   10.501961] usb 2-1.8: SerialNumber: JS1051006712
>> [   10.513140] mpt2sas_cm0: [0x24]:00000020
>> [   10.513140] mpt2sas_cm0: [0x28]:04000020
>> [   10.513141] mpt2sas_cm0: [0x2c]:00810080
>> [   10.513141] mpt2sas_cm0: [0x30]:007f0003
>> [   10.513142] mpt2sas_cm0: [0x34]:0020ffe0
>> [   10.513154] mpt2sas_cm0: [0x38]:008004b0
>> [   10.513154] mpt2sas_cm0: [0x3c]:00000011
>> [   10.513155] mpt2sas_cm0: [0x40]:00000000
>> [   10.513156] mpt2sas_cm0: CurrentHostPageSize is 0: Setting default
>> host page size to 4k
>> [   10.524350] sd 0:0:0:0: [sda] 30031250 512-byte logical blocks:
>> (15.4 GB/14.3 GiB)
>> [   10.535178] mpt2sas_cm0: CurrentHostPageSize(0)
>> [   10.548205] sd 0:0:0:0: [sda] Write Protect is off
>> [   10.556610] mpt2sas_cm0: hba queue depth(32455), max chains per io(12=
8)
>> [   10.566972] sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
>> [   10.577132] mpt2sas_cm0: request frame size(128), reply frame size(12=
8)
>> [   10.589074] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
>> enabled, doesn't support DPO or FUA
>> [   10.597175] mpt2sas_cm0: msix is supported, vector_count(1)
>> [   10.692084] hid: raw HID events driver (C) Jiri Kosina
>> [   10.692148] igb: Intel(R) Gigabit Ethernet Network Driver - version 5=
.6.0-k
>> [   10.692149] igb: Copyright (c) 2007-2014 Intel Corporation.
>> [   10.705215] mpt2sas_cm0: MSI-X vectors supported: 1
>> [   10.705216] no of cores: 32, max_msix_vectors: -1
>> [   10.705217] mpt2sas_cm0:  0 1
>> [   10.705359] mpt2sas_cm0: High IOPs queues : disabled
>> [   10.757534] ata4: SATA link down (SStatus 0 SControl 300)
>> [   10.761609] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 56
>> [   10.761611] mpt2sas_cm0: iomem(0x00000000d1380000),
>> mapped(0x(____ptrval____)), size(16384)
>> [   10.761613] mpt2sas_cm0: ioport(0x0000000000002000), size(256)
>> [   10.781648] ata1: SATA link down (SStatus 0 SControl 300)
>> [   10.793026] mpt2sas_cm0: _base_get_ioc_facts
>> [   10.804281] ata6: SATA link down (SStatus 0 SControl 300)
>> [   10.817492] mpt2sas_cm0: _base_wait_for_iocstate
>> [   10.821742] usbcore: registered new interface driver usbhid
>> [   10.821743] usbhid: USB HID core driver
>> [   10.829361] ata3: SATA link down (SStatus 0 SControl 300)
>> [   10.906674] offset:data
>> [   10.917639] ata5: SATA link down (SStatus 0 SControl 300)
>> [   10.917791] input: American Megatrends Inc. Virtual Keyboard and
>> Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.0/0003:=
046B:FF10.0001/input/input2
>> [   10.917893] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID
>> v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse]
>> on usb-0000:00:1d.0-1.4/input0
>> [   10.918019] input: American Megatrends Inc. Virtual Keyboard and
>> Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4/2-1.4:1.1/0003:=
046B:FF10.0002/input/input3
>> [   10.918245] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID
>> v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on
>> usb-0000:00:1d.0-1.4/input1
>> [   10.918692] hid-generic 0003:051D:0003.0003: hiddev0,hidraw2: USB
>> HID v1.00 Device [American Power Conversion Smart-UPS 2200 FW:UPS 06.3
>> / MCU 11.0] on usb-0000:00:1d.0-1.8/input0
>> [   10.925117] random: fast init done
>> [   10.929067] mpt2sas_cm0: [0x00]:03100200
>> [   10.939600] ata2: SATA link down (SStatus 0 SControl 300)
>> [   10.951294] mpt2sas_cm0: [0x04]:00002300
>> [   10.984639]  sda: sda1 sda2 sda3
>> [   10.985180] mpt2sas_cm0: [0x08]:00000000
>> [   11.005873] sd 0:0:0:0: [sda] Attached SCSI removable disk
>> [   11.006343] mpt2sas_cm0: [0x0c]:00000000
>> [   11.285853] mpt2sas_cm0: [0x10]:00000000
>> [   11.298311] mpt2sas_cm0: [0x14]:00010080
>> [   11.310617] mpt2sas_cm0: [0x18]:22137ec7
>> [   11.322831] mpt2sas_cm0: [0x1c]:0001285c
>> [   11.334964] mpt2sas_cm0: [0x20]:14000600
>> [   11.347072] mpt2sas_cm0: [0x24]:00000020
>> [   11.359060] mpt2sas_cm0: [0x28]:04000020
>> [   11.370880] mpt2sas_cm0: [0x2c]:00810080
>> [   11.382482] mpt2sas_cm0: [0x30]:007f0003
>> [   11.393927] mpt2sas_cm0: [0x34]:0020ffe0
>> [   11.405226] mpt2sas_cm0: [0x38]:008004b0
>> [   11.416400] mpt2sas_cm0: [0x3c]:00000011
>> [   11.427427] mpt2sas_cm0: [0x40]:00000000
>> [   11.438335] mpt2sas_cm0: CurrentHostPageSize is 0: Setting default
>> host page size to 4k
>> [   11.453888] mpt2sas_cm0: CurrentHostPageSize(0)
>> [   11.465416] mpt2sas_cm0: hba queue depth(32455), max chains per io(12=
8)
>> [   11.479358] mpt2sas_cm0: request frame size(128), reply frame size(12=
8)
>> [   11.493291] mpt2sas_cm0: _base_make_ioc_ready
>> [   11.507135] mpt2sas_cm0: _base_get_port_facts
>> [   11.519349] igb 0000:07:00.0: added PHC on eth0
>> [   11.530468] igb 0000:07:00.0: Intel(R) Gigabit Ethernet Network Conne=
ction
>> [   11.544129] igb 0000:07:00.0: eth0: (PCIe:5.0Gb/s:Width x4) 00:1e:67:=
97:4d:e9
>> [   11.558034] igb 0000:07:00.0: eth0: PBA No: 100000-000
>> [   11.569355] igb 0000:07:00.0: Using MSI-X interrupts. 8 rx
>> queue(s), 8 tx queue(s)
>> [   11.616691] offset:data
>> [   11.624765] mpt2sas_cm0: [0x00]:05070000
>> [   11.634321] mpt2sas_cm0: [0x04]:00000000
>> [   11.643579] mpt2sas_cm0: [0x08]:00000000
>> [   11.652537] mpt2sas_cm0: [0x0c]:00000000
>> [   11.661248] mpt2sas_cm0: [0x10]:00000000
>> [   11.669892] mpt2sas_cm0: [0x14]:00003000
>> [   11.678382] mpt2sas_cm0: [0x18]:00000100
>> [   11.686741] mpt2sas_cm0: _base_allocate_memory_pools
>> [   11.696171] mpt2sas_cm0: scatter gather: sge_in_main_msg(1),
>> sge_per_chain(9), sge_per_io(128), chains_per_io(15)
>> [   11.715890] ------------[ cut here ]------------
>> [   11.725227] WARNING: CPU: 0 PID: 5 at mm/page_alloc.c:4831
>> __alloc_pages_nodemask+0x1ce/0x310
>> [   11.739330] Modules linked in: fjes(-) hid_generic usbhid hid
>> crct10dif_pclmul igb(+) crc32_pclmul ghash_clmulni_intel dca
>> aesni_intel ptp ahci crypto_simd mpt3sas(+) pps_core xhci_pci cryptd
>> mlx4_core(+) raid_class i2c_algo_bit libahci xhci_pci_renesas
>> glue_helper scsi_transport_sas wmi uas usb_storage deflate
>> [   11.791023] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.8.12 #1
>> [   11.803622] Hardware name: ZTSYSTEM CYPRESS11      /S2600CP   ,
>> BIOS SE5C600.86B.02.06.0006.032420170950 03/24/2017
>> [   11.827610] Workqueue: events work_for_cpu_fn
>> [   11.838884] RIP: 0010:__alloc_pages_nodemask+0x1ce/0x310
>> [   11.851367] Code: ff ff ff 65 48 8b 04 25 c0 7b 01 00 48 05 78 08
>> 00 00 41 bd 01 00 00 00 48 89 44 24 08 e9 05 ff ff ff 81 e7 00 20 00
>> 00 75 02 <0f> 0b 45 31 ed eb 95 44 8b 64 24 18 65 8b 05 1f a6 7a 4b 89
>> c0 48
>> [   11.893686] RSP: 0018:ffffc18e000bbc98 EFLAGS: 00010246
>> [   11.906822] RAX: 0000000000000000 RBX: 0000000000000cc0 RCX: 00000000=
00000000
>> [   11.922228] RDX: 0000000000000000 RSI: 000000000000000b RDI: 00000000=
00000000
>> [   11.937510] RBP: 000000000075d000 R08: 000000000075d000 R09: ffffffff=
ffffffff
>> [   11.952755] R10: 0000000000000000 R11: ffff9e6a16c22350 R12: ffffffff=
ffffffff
>> [   11.967942] R13: 0000000000000000 R14: ffff9e5215c34f58 R15: ffff9e52=
163590b0
>> [   11.983165] FS:  0000000000000000(0000) GS:ffff9e521ea00000(0000)
>> knlGS:0000000000000000
>> [   11.999566] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   12.013320] CR2: 000055c7853e9ef0 CR3: 00000003d620a003 CR4: 00000000=
000606f0
>> [   12.028719] Call Trace:
>> [   12.038777]  dma_direct_alloc_pages+0x171/0x2a0
>> [   12.051185]  dma_pool_alloc+0xd0/0x1c0
>> [   12.062585]  base_alloc_rdpq_dma_pool+0x118/0x1d0 [mpt3sas]
>> [   12.076131]  _base_allocate_memory_pools+0x2d6/0x1240 [mpt3sas]
>> [   12.090232]  mpt3sas_base_attach+0x4a4/0x930 [mpt3sas]
>> [   12.103599]  _scsih_probe+0x4e3/0x920 [mpt3sas]
>> [   12.116383]  local_pci_probe+0x42/0x90
>> [   12.128401]  work_for_cpu_fn+0x16/0x20
>> [   12.140466]  process_one_work+0x208/0x400
>> [   12.152910]  worker_thread+0x221/0x3e0
>> [   12.165053]  ? process_one_work+0x400/0x400
>> [   12.177573]  kthread+0x117/0x130
>> [   12.188759]  ? kthread_park+0x90/0x90
>> [   12.200400]  ret_from_fork+0x22/0x30
>> [   12.211748] ---[ end trace 1d2f9a5394100a7e ]---
>> [   12.224134] mpt2sas_cm0: mpt3sas_base_free_resources
>> [   12.237582] mpt2sas_cm0: _base_make_ioc_ready
>> [   12.249253] mpt2sas_cm0: mpt3sas_base_unmap_resources
>> [   12.264417] igb 0000:07:00.1: added PHC on eth1
>> [   12.276024] igb 0000:07:00.1: Intel(R) Gigabit Ethernet Network Conne=
ction
>> [   12.290184] igb 0000:07:00.1: eth1: (PCIe:5.0Gb/s:Width x4) 00:1e:67:=
97:4d:ea
>> [   12.304604] igb 0000:07:00.1: eth1: PBA No: 100000-000
>> [   12.316624] igb 0000:07:00.1: Using MSI-X interrupts. 8 rx
>> queue(s), 8 tx queue(s)
>> [   12.331505] mpt2sas_cm0: _base_release_memory_pools
>> [   12.343209] mpt2sas_cm0: failure at
>> drivers/scsi/mpt3sas/mpt3sas_scsih.c:10791/_scsih_probe()!
>>
>> On Tue, Sep 29, 2020 at 8:00 AM Suganath Prabu Subramani
>> <suganath-prabu.subramani@broadcom.com> wrote:
>> >
>> > Hi Sundar,
>> >
>> > Please check if below two patches are available in the mpt3sas driver
>> > you are using.
>> > If you are seeing issues with these patches applied (Or) If your
>> > driver is already having mentioned patches, provide us driver log with
>> > "mpt3sas.logging_level=3D0x3f8=E2=80=9D.
>> >
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/drivers/scsi/mpt3sas?h=3Dv5.9-rc4&id=3D61e6ba03ea26f0205e535862009ff6ff=
dbf4de0c
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/com=
mit/drivers/scsi/mpt3sas?h=3Dv5.9-rc4&id=3Df56577e8c7d0f3054f97d1f0d1cbe9a4=
d179cc47
>> >
>> > I could see these patches in 5.8.12
>> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/=
drivers/scsi/mpt3sas/mpt3sas_base.c?h=3Dv5.8.12.
>> >
>> > Thanks,
>> > Suganath
>> >
>> >
>> > On Tue, Sep 29, 2020 at 4:18 PM Sundar Nagarajan
>> > <sun.nagarajan@gmail.com> wrote:
>> > >
>> > > Sorry if I am mailing too many people.
>> > > Copying additional people in the hope that someone has the time to g=
uide me on how to report, debug and fix this bug in the 5.8 kernel.
>> > >
>> > > bugzilla.kernel org bug report:
>> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D209177
>> > >
>> > >
>> > >
>> > >
>> > > On Tue, Sep 22, 2020 at 7:08 PM Sundar Nagarajan <sun.nagarajan@gmai=
l.com> wrote:
>> > >>
>> > >> Any guidance on how I should go about trying with the 35.100.00.00 =
driver?
>> > >> In particular:
>> > >>
>> > >> Which patch do I apply?
>> > >> Which kernel version do I apply the patch to?
>> > >>
>> > >> Regards,
>> > >> Sundar
>> > >>
>> > >>
>> > >> On Thu, Sep 10, 2020 at 10:51 PM Sundar Nagarajan <sun.nagarajan@gm=
ail.com> wrote:
>> > >>>
>> > >>> Hi Suganath,
>> > >>>
>> > >>> Thank you for the quick reply.
>> > >>>
>> > >>> I am a bit of a newbie in pllying linux kernel patches etc.
>> > >>>
>> > >>> Would I apply this patch to the stock (5.8.8) kernel.org kernel:
>> > >>> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commi=
t/?h=3D5.10/scsi-queue
>> > >>>
>> > >>> Sundar
>> > >>>
>> > >>>
>> > >>>
>> > >>> On Thu, Sep 10, 2020 at 10:46 PM Suganath Prabu Subramani <suganat=
h-prabu.subramani@broadcom.com> wrote:
>> > >>>>
>> > >>>> Hi Sundar,
>> > >>>>
>> > >>>> Can you please try with the latest driver 35.100.00.00. =3D> "htt=
ps://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/tree/?h=3D5.10/sc=
si-queue"
>> > >>>> This has fixes related to "RDPQ" scsi: mpt3sas: Fix reply queue c=
ount in non RDPQ mode.
>> > >>>> scsi: mpt3sas: Fix memset() in non-RDPQ mode.
>> > >>>>
>> > >>>> Thanks,
>> > >>>> Suganath
>> > >>>>
>> > >>>> On Fri, Sep 11, 2020 at 10:00 AM Sundar Nagarajan <sun.nagarajan@=
gmail.com> wrote:
>> > >>>>>
>> > >>>>> I am new to reporting linux kernel bugs.
>> > >>>>> Apologies if this is sent to you in error.
>> > >>>>> I got your email using: `perl scripts/get_maintainer.pl -f
>> > >>>>> drivers/scsi/mpt3sas/mpt3sas_scsih.c` as indicated in
>> > >>>>> https://www.kernel.org/doc/html/latest/admin-guide/reporting-bug=
s.html
>> > >>>>>
>> > >>>>> bugzilla.kernel org bug report:
>> > >>>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D209177

--0000000000005719ac05b0884612
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iUkiVw86iw1/yBRkUHjZV+F5nigRTD1p16yuvarGtyB6rg4jKzna5QV4nk8+hvH80mioAJQGVzts
8xzpVqdUE0XKNyTxbKeog4Szn+7BAgMBAAGjggHcMIIB2DAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsG
AQUFBwEBBIGRMIGOME0GCCsGAQUFBzAChkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc3BlcnNvbmFsc2lnbjJzaGEyZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29j
c3AyLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisG
AQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3Np
dG9yeS8wCQYDVR0TBAIwADBEBgNVHR8EPTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24u
Y29tL2dzcGVyc29uYWxzaWduMnNoYTJnMy5jcmwwMAYDVR0RBCkwJ4Elc3VnYW5hdGgtcHJhYnUu
c3VicmFtYW5pQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBRp
coJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU/c23ZwEKsymUWmWA1y8P9Rg3/S4wDQYJKoZI
hvcNAQELBQADggEBALOKJyKtCFXYqEKp/a6z7VfKi9uLkcftrcrYXqV3K6PB8j7qnYb37eV1DCBs
+gdZLkbSE0oBBzV/dqmsngPjBwkLSigxsRg1K44sgdBpolmGw/gESFR8P2tXB0l+UEEq4kzhz6sM
bCYKYpNz68rpFqaHpBXisSwGMZwPHsfyh2Stv/1cNBG6dGpoUgZcoFjXT7Akx1Tz11FUkRjNsUAc
DAYA3uHCdaZTnVbSESs1pk+HAhlZhqrDYXWCG6ya+SIG51Q4PHS6jfst/6xnaSFPhWhIv2hSB2NA
vWzrcXMq9IfE5HFZXqzOWMP/gUOKk155U6EuRQzVcCpabG8ROpPND3sxggJvMIICawIBATBtMF0x
CzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQDEypHbG9iYWxT
aWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDE84Ya9bsUMoMZ6qKjANBglghkgB
ZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgKsnNyVpRLMh4RSyyPofRiD7wtWTtwDwTg3IBwv0X
HZUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjAwOTMwMTM1NzA1
WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJYIZIAWUDBAEC
MAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqG
SIb3DQEBAQUABIIBAEG7ZYja5GMvuctFM6TyJpSSB4o55FxoOVWGRzjce1gYq5q7/5pHd9Oh7mkx
dNO1WAaYfCiSrZSdAofCcqkNY4WUg/AaOqWESkNG5g+PcjTfq4t83YskiIveDDJ34T7S7Ir68tn/
KvpsE2vaHNNzs6/MEEnYTDGLaAFcClz41OMoG86LEn0hWIiSz8S38yAGMHkPjFaM5/d6SBv3bo20
kwVpL/MIc0EmjpvCWcWL2bCbENyEQoXp2+dvAXMmCdY0agLXJtSz5Id1wabffSqbKZ5Gg7ejIIX8
FeCeyVxuyBc8ymJ7yVPE0KxGp3Mo4O9YzD/e4KJgH4DgmiI3C46itVA=
--0000000000005719ac05b0884612--
