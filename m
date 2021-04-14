Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412C9C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 10:39:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBF1661249
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 10:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhDNKjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 06:39:11 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21316 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbhDNKjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 06:39:00 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1618396706; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=fOTyMcMthvPLVw0wXNJDxWLAXktKqo/a8rk1ufXWjymRbYNoqHwlbLnADdEJPDrGvp+XDK2W2rTZJbEFiTV7MzLRTQqh0B4uXaXoOo5C3dtihYMQpFna0IJ3Xwxx7i7qRX1rZkyRPZiPN+ZNN9/Na5BmNyswvKFRYXFU/jVmtNg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1618396706; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=hvW++ziozc2OKrVdvhU2FsdWaJ7v6duKEHDh4SDbAbo=; 
        b=R+x3lTd65FuA7Us9LJCW+oSwOvF5KAtPdqztdY1xe2uJk62kIb/Bv5jd+H2tx3FumpTr474KNZU2jvLCR/Y2O0K48nGcdrlKJ1slQBkvGxwh55/R7i7U5DIrcW/yVIY9v7d6cf+TOOmJcQZ8gvRDvy1ILJ2E/0rlOSEIcgTMJMQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=qubes-os.org;
        spf=pass  smtp.mailfrom=frederic.pierret@qubes-os.org;
        dmarc=pass header.from=<frederic.pierret@qubes-os.org> header.from=<frederic.pierret@qubes-os.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1618396706;
        s=s; d=qubes-os.org; i=frederic.pierret@qubes-os.org;
        h=To:Cc:References:From:Subject:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type;
        bh=hvW++ziozc2OKrVdvhU2FsdWaJ7v6duKEHDh4SDbAbo=;
        b=k07CMKUz0VRFn36uN2rVKiqgF/Fej+s2pbm34TbWJfVhccARsG4evsaUJxyMTm8M
        2T4dso1Po8vM2GO+0XeVAuheZZ+sKaw9f9VSPSMjDKxAWtIH7loOHdLhUwyAKlAPo1n
        SM19mt1oPMQGuzkg7bVDX+JUzD++rr2vviWKvlaQ=
Received: from [10.137.0.21] (92.188.110.153 [92.188.110.153]) by mx.zohomail.com
        with SMTPS id 1618396704342962.9972670398906; Wed, 14 Apr 2021 03:38:24 -0700 (PDT)
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
References: <ce228d78-8651-d958-d1e5-2f82cbb8113d@qubes-os.org>
 <c751b535d69b892fee0af8f43cfcce60@mail.gmail.com>
 <12383f2a-9f7b-ea95-ff52-785b91c1bac8@qubes-os.org>
 <2ef99260-c5ee-f42d-c06e-e37b22ff443d@qubes-os.org>
 <CAL2rwxo9rM+Tcc8_kQ2U9Kxp3mJfFFK0V7ACdrV_4cgZ1YnBVw@mail.gmail.com>
From:   =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= 
        <frederic.pierret@qubes-os.org>
Subject: Re: MegaRaid SAS 9341-8i issue
Message-ID: <6eeb200a-7b72-380f-ead0-22e1ff8e93bd@qubes-os.org>
Date:   Wed, 14 Apr 2021 12:38:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAL2rwxo9rM+Tcc8_kQ2U9Kxp3mJfFFK0V7ACdrV_4cgZ1YnBVw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ny48JBqjV9mX4gtAJpCTkVZyG8kelbMU2"
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ny48JBqjV9mX4gtAJpCTkVZyG8kelbMU2
Content-Type: multipart/mixed; boundary="xIAVcETQIM3JvDO8Fj7OPQ7nypZ0oIdGM";
 protected-headers="v1"
From: =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= <frederic.pierret@qubes-os.org>
To: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
 Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
 Linux SCSI List <linux-scsi@vger.kernel.org>
Message-ID: <6eeb200a-7b72-380f-ead0-22e1ff8e93bd@qubes-os.org>
Subject: Re: MegaRaid SAS 9341-8i issue
References: <ce228d78-8651-d958-d1e5-2f82cbb8113d@qubes-os.org>
 <c751b535d69b892fee0af8f43cfcce60@mail.gmail.com>
 <12383f2a-9f7b-ea95-ff52-785b91c1bac8@qubes-os.org>
 <2ef99260-c5ee-f42d-c06e-e37b22ff443d@qubes-os.org>
 <CAL2rwxo9rM+Tcc8_kQ2U9Kxp3mJfFFK0V7ACdrV_4cgZ1YnBVw@mail.gmail.com>
In-Reply-To: <CAL2rwxo9rM+Tcc8_kQ2U9Kxp3mJfFFK0V7ACdrV_4cgZ1YnBVw@mail.gmail.com>

--xIAVcETQIM3JvDO8Fj7OPQ7nypZ0oIdGM
Content-Type: multipart/mixed;
 boundary="------------D7D1E2EA5AAA155C20E7E2BE"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------D7D1E2EA5AAA155C20E7E2BE
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Sumit,

Le 4/12/21 =C3=A0 2:04 PM, Sumit Saxena a =C3=A9crit=C2=A0:
> On Fri, Apr 9, 2021 at 11:55 AM Fr=C3=A9d=C3=A9ric Pierret
> <frederic.pierret@qubes-os.org> wrote:
>>
>> Hi,
>>
>> Le 3/29/21 =C3=A0 11:02 AM, Fr=C3=A9d=C3=A9ric Pierret a =C3=A9crit :
>>> Hi,
>>> First of all, thank you very much for your answer.
>>>
>>> Le 3/29/21 =C3=A0 8:24 AM, Kashyap Desai a =C3=A9crit :
>>>> Hi -
>>>>
>>>> Can you send us full dmesg logs of each working and non-working case=
=2E ?
>>>
>>> I've attached you the working case of one of the two motherboard, ref=
erenced here as ASUS, and the nonworking case on the third motherboard, r=
eferenced here as ASROCK. In both cases, I've attached you the full dmesg=
 of the same LiveUSB a Fedora 33 with also the full dmesg when I do a rmm=
od and modprobe of megaraid_sas.
>>>
>>>> On 3rd motherboard was it any working combination of kernel, driver =
and FW ?
>>>> OR it never worked on 3rd mother board ?
>>>
>>> Unfortunately, no combination has worked on the ASROCK (third motherb=
oard) (before or after firmware upgrade, multiple kernel versions (5.10.X=
 and 5.11.Y), drivers)
>>>
>>>> Kashyap
>>>>
>>>>> -----Original Message-----
>>>>> From: Fr=C3=A9d=C3=A9ric Pierret [mailto:frederic.pierret@qubes-os.=
org]
>>>>> Sent: Sunday, March 28, 2021 10:26 PM
>>>>> To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
>>>>> shivasharan.srikanteshwara@broadcom.com; jejb@linux.ibm.com;
>>>>> martin.petersen@oracle.com
>>>>> Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
>>>>> Subject: MegaRaid SAS 9341-8i issue
>>>>>
>>>>> Hi,
>>>>>
>>>>> I'm having issue with a MegaRaid 9341-8i card which is properly wor=
king on
>>>>> two motherboards (kernel-5.10.25 and kernel-5.11.10) but not on a t=
hird
>>>>> for
>>>>> which I want it to work. I originally received this card with a fir=
mware
>>>>> from
>>>>> 2018 and I've updated it to the latest from Broadcom website
>>>>> (24.21.0-0148)
>>>>> but in both cases, I've the same issue on the third motherboard:
>>>>>
>>>>> [   14.013135] megaraid_sas 0000:01:00.0: BAR:0x1  BAR's
>>>>> base_addr(phys):0x00000000fe800000  mapped virt_addr:0x(ptrval)
>>>>> [   14.013142] megaraid_sas 0000:01:00.0: FW now in Ready state
>>>>> [   14.013148] megaraid_sas 0000:01:00.0: 63 bit DMA mask and 32 bi=
t
>>>>> consistent mask
>>>>> [   14.013933] megaraid_sas 0000:01:00.0: firmware supports msix   =
     :
>>>>> (96)
>>>>> [   14.014439] megaraid_sas 0000:01:00.0: requested/available msix =
5/5
>>>>> [   14.014445] megaraid_sas 0000:01:00.0: current msix/online cpus =
     :
>>>>> (5/4)
>>>>> [   14.014447] megaraid_sas 0000:01:00.0: RDPQ mode     : (disabled=
)
>>>>> [   14.014453] megaraid_sas 0000:01:00.0: Current firmware supports=

>>>>> maximum commands: 272        LDIO threshold: 237
>>>>> [   14.014631] megaraid_sas 0000:01:00.0: Configured max firmware
>>>>> commands: 271
>>>>> [   14.015377] megaraid_sas 0000:01:00.0: Performance mode :Latency=

>>>>> [   14.015380] megaraid_sas 0000:01:00.0: FW supports sync cache   =
     :
>>>>> Yes
>>>>> [   14.015388] megaraid_sas 0000:01:00.0: megasas_disable_intr_fusi=
on is
>>>>> called outbound_intr_mask:0x40000009
>>>>> [   14.037098] megaraid_sas 0000:01:00.0: Init cmd return status FA=
ILED
>>>>> for
>>>>> SCSI host 2
>>>>> [   14.037762] megaraid_sas 0000:01:00.0: Failed from megasas_init_=
fw 6399
>>>>>
>>>>> Trying to rmmod then modprobe leads to something that looks like st=
uck
>>>>> state or such:
>>>>>
>>>>> [  570.269770] megaraid_sas 0000:01:00.0: BAR:0x1  BAR's
>>>>> base_addr(phys):0x00000000fe800000  mapped
>>>>> virt_addr:0x00000000f42ba0e1 [  570.269775] megaraid_sas 0000:01:00=
=2E0:
>>>>> Waiting for FW to come to ready state [  570.269780] megaraid_sas
>>>>> 0000:01:00.0: FW in FAULT state, Fault code:0x10000 subcode:0x0
>>>>> func:megasas_transition_to_ready [  570.269782] megaraid_sas
>>>>> 0000:01:00.0: System Register set:
>>>>> (***)
>>>>> [  570.269908] megaraid_sas 0000:01:00.0: Failed to transition cont=
roller
>>>>> to
>>>>> ready from megasas_init_fw!
>>>>> [  570.269919] megaraid_sas 0000:01:00.0: Failed from megasas_init_=
fw 639
>>>>>
>>>>> The motherboard which is not working is a recent one: Asrock X570D4=
U-2L2T
>>>>> with a Ryzen 3900XT.
>>>>>
>>>>> I've read a lot of things on internet saying that might be CSM issu=
es or
>>>>> such
>>>>> but no luck with that. On the two working motherboards, it works in=

>>>>> legacy/UEFI only. I've also tested the card on a x16 or x8 slots, t=
he same
>>>>> result. I've attempted to build megaraid driver provided from Broad=
com
>>>>> (07.716.01.00-2). Up to a slight adjustment in a log call using old=
er
>>>>> attribute
>>>>> "host_busy", I'm hitting an unrelated issue due to KBUILD_CFLAGS re=
cursion
>>>>> in arch/x86/Makefile.
>>>>>
>>>>> After hours and hours of testing, I'm currently out of ideas. Does =
anyone
>>>>> has
>>>>> an idea or could help me into adding useful debug info in the drive=
r or
>>>>> such?
>>>>>
>>>>> Thank very much in advance,
>>>>> Fr=C3=A9d=C3=A9ric
>>>
>>> Best regards,
>>> Fr=C3=A9d=C3=A9ric
>>
>> Is there something more I could provide and help into troubleshooting =
this issue?
> First time driver load fails due to IOC INIT failure(writeq API is
> used to fire IOC INIT to firmware).
> We have seen writeq does not work on a few platforms.
> Please try if below change fixes your issue:
>=20
> diff --git a/megaraid_sas_fusion.c b/megaraid_sas_fusion.c
> index 432a0bb..24ef592 100644
> --- a/megaraid_sas_fusion.c
> +++ b/megaraid_sas_fusion.c
> @@ -291,7 +293,8 @@ static void
>   megasas_write_64bit_req_desc(struct megasas_instance *instance,
>    union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc)
>   {
> -#if defined(writeq) && defined(CONFIG_64BIT)
> +//#if defined(writeq) && defined(CONFIG_64BIT)
> +#if 0
>    u64 req_data =3D (((u64)le32_to_cpu(req_desc->u.high) << 32) |
>    le32_to_cpu(req_desc->u.low));
>    writeq(req_data, &instance->reg_set->inbound_low_queue_port)
>=20
> Thanks,
> Sumit
>>
>> Best regards,
>> Fr=C3=A9d=C3=A9ric
>>

Thank you for the patch. I've tested your patch on a 5.10.28 kernel but u=
nfortunately it does not change the driver load behavior. I've attached t=
he dmesg. Don't pay attention to the "qubes" tag in kernel, I've just use=
d the same spec for building the test kernel than we do in QubesOS but he=
re it's a standard Fedora kernel config and build for this 5.10.28 + stan=
dard kernel source.

What I can tell is that the card is found at the BIOS POST (the controlle=
r appears and proposes to go into controller).

Are you eventually aware a working 9341-8i on a motherboard X570 chipset?=
 Just thinking if that could be related or not. I've also tried once agai=
n to change PCIe lanes but that's not helping. I've also checked that the=
 current PCIe 4.0 supports PCIe 3.0 according to the manual (https://down=
load.asrock.com/Manual/X570D4U-2L2T.pdf). A last point, I've only filled =
the two NVMe ports with standard NVMe drives (Samsung 970 256G) and I'm n=
ot having any other extension so I would not think it's related to lack o=
f lanes or such?

Best regards,
Fr=C3=A9d=C3=A9ric


--------------D7D1E2EA5AAA155C20E7E2BE
Content-Type: text/x-log; charset=UTF-8;
 name="dmesg_patch.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg_patch.log"

[    0.000000] Linux version 5.10.28-2.fc32.qubes.x86_64 (mockbuild@work-=
qubesos) (gcc (GCC) 10.2.1 20201125 (Red Hat 10.2.1-9), GNU ld version 2.=
34-6.fc32) #1 SMP Tue Apr 13 00:02:05 CEST 2021
[    0.000000] Command line: BOOT_IMAGE=3D/vmlinuz-5.10.28-2.fc32.qubes.x=
86_64 placeholder root=3D/dev/mapper/qubes_dom0-root ro rd.luks.uuid=3Dlu=
ks-da45b295-82dd-4e41-8203-d54b63bc70a5 rd.md.uuid=3D8784b982:f88ef5f7:78=
062a51:ce3439cb rd.lvm.lv=3Dqubes_dom0/root rd.md.uuid=3D0d7098cb:6bc8dd7=
9:c7fb483f:674f5a15 rd.lvm.lv=3Dqubes_dom0/swap plymouth.ignore-serial-co=
nsoles i915.alpha_support=3D1 rd.driver.pre=3Dbtrfs rhgb quiet
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating poi=
nt registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 =
bytes, using 'compacted' format.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009c3ff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000009c400-0x000000000009ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000009bfefff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x0000000009bff000-0x0000000009ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x000000000a000000-0x000000000a1fffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000000a200000-0x000000000a212fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x000000000a213000-0x00000000eb959fff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000eb95a000-0x00000000ecf93fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ecf94000-0x00000000ecfd1fff] ACP=
I data
[    0.000000] BIOS-e820: [mem 0x00000000ecfd2000-0x00000000ed659fff] ACP=
I NVS
[    0.000000] BIOS-e820: [mem 0x00000000ed65a000-0x00000000ee1fefff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ee1ff000-0x00000000eeffffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x00000000ef000000-0x00000000f7ffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fd200000-0x00000000fd2fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fd400000-0x00000000fd5fffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fea00000-0x00000000fea0ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000feb80000-0x00000000fec01fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fec10000-0x00000000fec10fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed40000-0x00000000fed44fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fed80000-0x00000000fed8ffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fedc2000-0x00000000fedcffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000fedd4000-0x00000000fedd5fff] res=
erved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] res=
erved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000100f2fffff] usa=
ble
[    0.000000] BIOS-e820: [mem 0x000000100f300000-0x000000100fffffff] res=
erved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 3.3.0 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./X570D4U=
-2L2T, BIOS P1.30 12/04/2020
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3799.702 MHz processor
[    0.000620] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> re=
served
[    0.000622] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000628] last_pfn =3D 0x100f300 max_arch_pfn =3D 0x400000000
[    0.000631] MTRR default type: uncachable
[    0.000631] MTRR fixed ranges enabled:
[    0.000632]   00000-9FFFF write-back
[    0.000633]   A0000-BFFFF write-through
[    0.000633]   C0000-FFFFF write-protect
[    0.000634] MTRR variable ranges enabled:
[    0.000634]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000635]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000636]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000636]   3 base 0000E0000000 mask FFFFF0000000 write-back
[    0.000637]   4 base 0000ED8F0000 mask FFFFFFFF0000 uncachable
[    0.000637]   5 disabled
[    0.000638]   6 disabled
[    0.000638]   7 disabled
[    0.000638] TOM2: 0000001010000000 aka 65792M
[    0.001223] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- =
WT =20
[    0.001330] e820: update [mem 0xed8f0000-0xed8fffff] usable =3D=3D> re=
served
[    0.001332] e820: update [mem 0xf0000000-0xffffffff] usable =3D=3D> re=
served
[    0.001336] last_pfn =3D 0xef000 max_arch_pfn =3D 0x400000000
[    0.005094] ACPI: Early table checksum verification disabled
[    0.005096] ACPI: RSDP 0x00000000000F05B0 000024 (v02 ALASKA)
[    0.005099] ACPI: XSDT 0x00000000ED640728 0000CC (v01 ALASKA A M I    =
01072009 AMI  01000013)
[    0.005102] ACPI: FACP 0x00000000ECFC2000 000114 (v06 ALASKA A M I    =
01072009 AMI  00010013)
[    0.005106] ACPI: DSDT 0x00000000ECFBB000 00645B (v02 ALASKA A M I    =
01072009 INTL 20120913)
[    0.005108] ACPI: FACS 0x00000000ED63B000 000040
[    0.005110] ACPI: SSDT 0x00000000ECFC9000 008C98 (v02 AMD    AmdTable =
00000002 MSFT 04000000)
[    0.005112] ACPI: SPMI 0x00000000ECFC8000 000041 (v05 ALASKA A M I    =
00000000 AMI. 00000000)
[    0.005114] ACPI: SSDT 0x00000000ECFC4000 003A7A (v01 AMD    AMD AOD  =
00000001 INTL 20120913)
[    0.005116] ACPI: SSDT 0x00000000ECFC3000 000164 (v02 ALASKA CPUSSDT  =
01072009 AMI  01072009)
[    0.005118] ACPI: FIDT 0x00000000ECFBA000 00009C (v01 ALASKA A M I    =
01072009 AMI  00010013)
[    0.005120] ACPI: MCFG 0x00000000ECFB9000 00003C (v01 ALASKA A M I    =
01072009 MSFT 00010013)
[    0.005121] ACPI: AAFT 0x00000000ECFB8000 000068 (v01 ALASKA OEMAAFT  =
01072009 MSFT 00000097)
[    0.005123] ACPI: HPET 0x00000000ECFB7000 000038 (v01 ALASKA A M I    =
01072009 AMI  00000005)
[    0.005125] ACPI: SSDT 0x00000000ECFB6000 000024 (v01 AMD    BIXBY    =
00001000 INTL 20120913)
[    0.005127] ACPI: IVRS 0x00000000ECFB4000 0000D0 (v02 AMD    AmdTable =
00000001 AMD  00000000)
[    0.005129] ACPI: PCCT 0x00000000ECFB3000 00006E (v02 AMD    AmdTable =
00000001 AMD  00000000)
[    0.005131] ACPI: SSDT 0x00000000ECFAD000 005E09 (v02 AMD    AmdTable =
00000001 AMD  00000001)
[    0.005133] ACPI: CRAT 0x00000000ECFAB000 001658 (v01 AMD    AmdTable =
00000001 AMD  00000001)
[    0.005135] ACPI: CDIT 0x00000000ECFAA000 000029 (v01 AMD    AmdTable =
00000001 AMD  00000001)
[    0.005136] ACPI: SSDT 0x00000000ECFA9000 00052C (v01 AMD    QOGIRNOI =
00000001 INTL 20120913)
[    0.005138] ACPI: SSDT 0x00000000ECFA5000 0034A4 (v01 AMD    QOGIRN   =
00000001 INTL 20120913)
[    0.005140] ACPI: WSMT 0x00000000ECFA4000 000028 (v01 ALASKA A M I    =
01072009 AMI  00010013)
[    0.005142] ACPI: APIC 0x00000000ECFA3000 00015E (v03 ALASKA A M I    =
01072009 AMI  00010013)
[    0.005144] ACPI: SSDT 0x00000000ECFA1000 0010AF (v01 AMD    QOGIRC   =
00000001 INTL 20120913)
[    0.005146] ACPI: FPDT 0x00000000ECFA0000 000044 (v01 ALASKA A M I    =
01072009 AMI  01000013)
[    0.005148] ACPI: Reserving FACP table memory at [mem 0xecfc2000-0xecf=
c2113]
[    0.005148] ACPI: Reserving DSDT table memory at [mem 0xecfbb000-0xecf=
c145a]
[    0.005149] ACPI: Reserving FACS table memory at [mem 0xed63b000-0xed6=
3b03f]
[    0.005149] ACPI: Reserving SSDT table memory at [mem 0xecfc9000-0xecf=
d1c97]
[    0.005150] ACPI: Reserving SPMI table memory at [mem 0xecfc8000-0xecf=
c8040]
[    0.005150] ACPI: Reserving SSDT table memory at [mem 0xecfc4000-0xecf=
c7a79]
[    0.005151] ACPI: Reserving SSDT table memory at [mem 0xecfc3000-0xecf=
c3163]
[    0.005151] ACPI: Reserving FIDT table memory at [mem 0xecfba000-0xecf=
ba09b]
[    0.005152] ACPI: Reserving MCFG table memory at [mem 0xecfb9000-0xecf=
b903b]
[    0.005152] ACPI: Reserving AAFT table memory at [mem 0xecfb8000-0xecf=
b8067]
[    0.005153] ACPI: Reserving HPET table memory at [mem 0xecfb7000-0xecf=
b7037]
[    0.005153] ACPI: Reserving SSDT table memory at [mem 0xecfb6000-0xecf=
b6023]
[    0.005154] ACPI: Reserving IVRS table memory at [mem 0xecfb4000-0xecf=
b40cf]
[    0.005154] ACPI: Reserving PCCT table memory at [mem 0xecfb3000-0xecf=
b306d]
[    0.005155] ACPI: Reserving SSDT table memory at [mem 0xecfad000-0xecf=
b2e08]
[    0.005155] ACPI: Reserving CRAT table memory at [mem 0xecfab000-0xecf=
ac657]
[    0.005156] ACPI: Reserving CDIT table memory at [mem 0xecfaa000-0xecf=
aa028]
[    0.005156] ACPI: Reserving SSDT table memory at [mem 0xecfa9000-0xecf=
a952b]
[    0.005157] ACPI: Reserving SSDT table memory at [mem 0xecfa5000-0xecf=
a84a3]
[    0.005157] ACPI: Reserving WSMT table memory at [mem 0xecfa4000-0xecf=
a4027]
[    0.005158] ACPI: Reserving APIC table memory at [mem 0xecfa3000-0xecf=
a315d]
[    0.005158] ACPI: Reserving SSDT table memory at [mem 0xecfa1000-0xecf=
a20ae]
[    0.005159] ACPI: Reserving FPDT table memory at [mem 0xecfa0000-0xecf=
a0043]
[    0.005167] Using GB pages for direct mapping
[    0.005777] RAMDISK: [mem 0x34883000-0x36438fff]
[    0.005785] ACPI: Local APIC address 0xfee00000
[    0.005827] No NUMA configuration found
[    0.005828] Faking a node at [mem 0x0000000000000000-0x000000100f2ffff=
f]
[    0.005835] NODE_DATA(0) allocated [mem 0x100f2d5000-0x100f2fffff]
[    0.082175] Zone ranges:
[    0.082176]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.082178]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.082178]   Normal   [mem 0x0000000100000000-0x000000100f2fffff]
[    0.082179]   Device   empty
[    0.082180] Movable zone start for each node
[    0.082181] Early memory node ranges
[    0.082182]   node   0: [mem 0x0000000000001000-0x000000000009bfff]
[    0.082183]   node   0: [mem 0x0000000000100000-0x0000000009bfefff]
[    0.082183]   node   0: [mem 0x000000000a000000-0x000000000a1fffff]
[    0.082184]   node   0: [mem 0x000000000a213000-0x00000000eb959fff]
[    0.082184]   node   0: [mem 0x00000000ee1ff000-0x00000000eeffffff]
[    0.082185]   node   0: [mem 0x0000000100000000-0x000000100f2fffff]
[    0.082190] Initmem setup node 0 [mem 0x0000000000001000-0x000000100f2=
fffff]
[    0.082191] On node 0 totalpages: 16758242
[    0.082192]   DMA zone: 64 pages used for memmap
[    0.082193]   DMA zone: 21 pages reserved
[    0.082193]   DMA zone: 3995 pages, LIFO batch:0
[    0.082434]   DMA zone: 28773 pages in unavailable ranges
[    0.082434]   DMA32 zone: 15054 pages used for memmap
[    0.082435]   DMA32 zone: 963399 pages, LIFO batch:63
[    0.088962]   DMA32 zone: 15545 pages in unavailable ranges
[    0.088964]   Normal zone: 246732 pages used for memmap
[    0.088965]   Normal zone: 15790848 pages, LIFO batch:63
[    0.192463]   Normal zone: 3328 pages in unavailable ranges
[    0.193895] ACPI: PM-Timer IO Port: 0x808
[    0.193897] ACPI: Local APIC address 0xfee00000
[    0.193904] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.193915] IOAPIC[0]: apic_id 25, version 33, address 0xfec00000, GSI=
 0-23
[    0.193920] IOAPIC[1]: apic_id 26, version 33, address 0xfec01000, GSI=
 24-55
[    0.193921] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.193923] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)=

[    0.193924] ACPI: IRQ0 used by override.
[    0.193924] ACPI: IRQ9 used by override.
[    0.193926] Using ACPI (MADT) for SMP configuration information
[    0.193927] ACPI: HPET id: 0x10228201 base: 0xfed00000
[    0.193931] smpboot: Allowing 32 CPUs, 8 hotplug CPUs
[    0.193955] [mem 0xf8000000-0xfd1fffff] available for PCI devices
[    0.193956] Booting paravirtualized kernel on bare hardware
[    0.193958] clocksource: refined-jiffies: mask: 0xffffffff max_cycles:=
 0xffffffff, max_idle_ns: 1910969940391419 ns
[    0.197767] setup_percpu: NR_CPUS:8192 nr_cpumask_bits:32 nr_cpu_ids:3=
2 nr_node_ids:1
[    0.198549] percpu: Embedded 54 pages/cpu s184320 r8192 d28672 u262144=

[    0.198556] pcpu-alloc: s184320 r8192 d28672 u262144 alloc=3D1*2097152=

[    0.198557] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 [0] 08 09 10 11 12=
 13 14 15=20
[    0.198562] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 [0] 24 25 26 27 28=
 29 30 31=20
[    0.198595] Built 1 zonelists, mobility grouping on.  Total pages: 164=
96371
[    0.198595] Policy zone: Normal
[    0.198597] Kernel command line: BOOT_IMAGE=3D/vmlinuz-5.10.28-2.fc32.=
qubes.x86_64 placeholder root=3D/dev/mapper/qubes_dom0-root ro rd.luks.uu=
id=3Dluks-da45b295-82dd-4e41-8203-d54b63bc70a5 rd.md.uuid=3D8784b982:f88e=
f5f7:78062a51:ce3439cb rd.lvm.lv=3Dqubes_dom0/root rd.md.uuid=3D0d7098cb:=
6bc8dd79:c7fb483f:674f5a15 rd.lvm.lv=3Dqubes_dom0/swap plymouth.ignore-se=
rial-consoles i915.alpha_support=3D1 rd.driver.pre=3Dbtrfs rhgb quiet
[    0.203137] Dentry cache hash table entries: 8388608 (order: 14, 67108=
864 bytes, linear)
[    0.205270] Inode-cache hash table entries: 4194304 (order: 13, 335544=
32 bytes, linear)
[    0.205343] mem auto-init: stack:byref_all(zero), heap alloc:off, heap=
 free:off
[    0.294052] Memory: 65743252K/67032968K available (16393K kernel code,=
 3431K rwdata, 5360K rodata, 3000K init, 4728K bss, 1289456K reserved, 0K=
 cma-reserved)
[    0.294059] random: get_random_u64 called from kmem_cache_open+0x24/0x=
210 with crng_init=3D0
[    0.294154] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D32=
, Nodes=3D1
[    0.294165] ftrace: allocating 49214 entries in 193 pages
[    0.305468] ftrace: allocated 193 pages with 3 groups
[    0.305561] rcu: Hierarchical RCU implementation.
[    0.305562] rcu: 	RCU restricting CPUs from NR_CPUS=3D8192 to nr_cpu_i=
ds=3D32.
[    0.305562] 	Trampoline variant of Tasks RCU enabled.
[    0.305563] 	Rude variant of Tasks RCU enabled.
[    0.305563] 	Tracing variant of Tasks RCU enabled.
[    0.305564] rcu: RCU calculated value of scheduler-enlistment delay is=
 100 jiffies.
[    0.305564] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_i=
ds=3D32
[    0.307979] NR_IRQS: 524544, nr_irqs: 1224, preallocated irqs: 16
[    0.308255] random: crng done (trusting CPU's manufacturer)
[    0.308277] spurious 8259A interrupt: IRQ7.
[    0.315270] Console: colour VGA+ 80x25
[    0.315278] printk: console [tty0] enabled
[    0.315291] ACPI: Core revision 20200925
[    0.315416] clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff=
, max_idle_ns: 133484873504 ns
[    0.315430] APIC: Switch to symmetric I/O mode setup
[    0.316514] Switched APIC routing to physical flat.
[    0.317113] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.321432] clocksource: tsc-early: mask: 0xffffffffffffffff max_cycle=
s: 0x6d8a7b7214e, max_idle_ns: 881590582107 ns
[    0.321434] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 7599.40 BogoMIPS (lpj=3D3799702)
[    0.321435] pid_max: default: 32768 minimum: 301
[    0.321458] LSM: Security Framework initializing
[    0.321461] Yama: becoming mindful.
[    0.321545] Mount-cache hash table entries: 131072 (order: 8, 1048576 =
bytes, linear)
[    0.321620] Mountpoint-cache hash table entries: 131072 (order: 8, 104=
8576 bytes, linear)
[    0.321787] x86/cpu: User Mode Instruction Prevention (UMIP) activated=

[    0.321833] LVT offset 1 assigned for vector 0xf9
[    0.321958] LVT offset 2 assigned for vector 0xf4
[    0.321992] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 512
[    0.321993] Last level dTLB entries: 4KB 2048, 2MB 2048, 4MB 1024, 1GB=
 0
[    0.321994] Spectre V1 : Mitigation: usercopy/swapgs barriers and __us=
er pointer sanitization
[    0.321996] Spectre V2 : Mitigation: Full AMD retpoline
[    0.321996] Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling R=
SB on context switch
[    0.321998] Spectre V2 : mitigation: Enabling conditional Indirect Bra=
nch Prediction Barrier
[    0.321998] Spectre V2 : User space: Mitigation: STIBP via seccomp and=
 prctl
[    0.321999] Speculative Store Bypass: Mitigation: Speculative Store By=
pass disabled via prctl and seccomp
[    0.322152] Freeing SMP alternatives memory: 44K
[    0.425493] smpboot: CPU0: AMD Ryzen 9 3900XT 12-Core Processor (famil=
y: 0x17, model: 0x71, stepping: 0x0)
[    0.425593] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
[    0.425596] ... version:                0
[    0.425597] ... bit width:              48
[    0.425597] ... generic registers:      6
[    0.425597] ... value mask:             0000ffffffffffff
[    0.425598] ... max period:             00007fffffffffff
[    0.425598] ... fixed-purpose events:   0
[    0.425598] ... event mask:             000000000000003f
[    0.425639] rcu: Hierarchical SRCU implementation.
[    0.425866] NMI watchdog: Enabled. Permanently consumes one hw-PMU cou=
nter.
[    0.426014] smp: Bringing up secondary CPUs ...
[    0.426058] x86: Booting SMP configuration:
[    0.426059] .... node  #0, CPUs:        #1
[    0.008269] __common_interrupt: 1.55 No irq handler for vector
[    0.427483]   #2
[    0.008269] __common_interrupt: 2.55 No irq handler for vector
[    0.428478]   #3
[    0.008269] __common_interrupt: 3.55 No irq handler for vector
[    0.430456]   #4
[    0.008269] __common_interrupt: 4.55 No irq handler for vector
[    0.431477]   #5
[    0.008269] __common_interrupt: 5.55 No irq handler for vector
[    0.432479]   #6
[    0.008269] __common_interrupt: 6.55 No irq handler for vector
[    0.434456]   #7
[    0.008269] __common_interrupt: 7.55 No irq handler for vector
[    0.435479]   #8
[    0.008269] __common_interrupt: 8.55 No irq handler for vector
[    0.436481]   #9
[    0.008269] __common_interrupt: 9.55 No irq handler for vector
[    0.438473]  #10
[    0.008269] __common_interrupt: 10.55 No irq handler for vector
[    0.439479]  #11 #12 #13 #14 #15 #16 #17 #18 #19 #20 #21 #22 #23
[    0.455455] smp: Brought up 1 node, 24 CPUs
[    0.455455] smpboot: Max logical packages: 2
[    0.455456] smpboot: Total of 24 processors activated (182385.69 BogoM=
IPS)
[    0.458867] devtmpfs: initialized
[    0.458867] x86/mm: Memory block size: 2048MB
[    0.458867] PM: Registering ACPI NVS region [mem 0x0a200000-0x0a212fff=
] (77824 bytes)
[    0.458867] PM: Registering ACPI NVS region [mem 0xecfd2000-0xed659fff=
] (6848512 bytes)
[    0.458867] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xfffff=
fff, max_idle_ns: 1911260446275000 ns
[    0.458867] futex hash table entries: 8192 (order: 7, 524288 bytes, li=
near)
[    0.458867] pinctrl core: initialized pinctrl subsystem
[    0.458867] PM: RTC time: 09:00:12, date: 2021-04-14
[    0.458867] NET: Registered protocol family 16
[    0.458931] DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic allo=
cations
[    0.458936] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for ato=
mic allocations
[    0.458940] DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for a=
tomic allocations
[    0.458947] audit: initializing netlink subsys (disabled)
[    0.459443] audit: type=3D2000 audit(1618390812.144:1): state=3Dinitia=
lized audit_enabled=3D0 res=3D1
[    0.459496] thermal_sys: Registered thermal governor 'fair_share'
[    0.459497] thermal_sys: Registered thermal governor 'bang_bang'
[    0.459497] thermal_sys: Registered thermal governor 'step_wise'
[    0.459498] thermal_sys: Registered thermal governor 'user_space'
[    0.459508] cpuidle: using governor menu
[    0.459508] Detected 1 PCC Subspaces
[    0.459508] Registering PCC driver as Mailbox controller
[    0.459529] ACPI: bus type PCI registered
[    0.459603] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf00000=
00-0xf7ffffff] (base 0xf0000000)
[    0.459605] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E=
820
[    0.459616] PCI: Using configuration type 1 for base access
[    0.460064] mtrr: your CPUs had inconsistent variable MTRR settings
[    0.460064] mtrr: probably your BIOS does not setup all CPUs.
[    0.460065] mtrr: corrected configuration.
[    0.461475] Kprobes globally optimized
[    0.461486] HugeTLB registered 1.00 GiB page size, pre-allocated 0 pag=
es
[    0.461486] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pag=
es
[    0.535521] cryptd: max_cpu_qlen set to 1000
[    0.537483] alg: No test for 842 (842-generic)
[    0.537483] alg: No test for 842 (842-scomp)
[    0.539485] raid6: skip pq benchmark and using algorithm avx2x4
[    0.539487] raid6: using avx2x2 recovery algorithm
[    0.539544] ACPI: Added _OSI(Module Device)
[    0.539545] ACPI: Added _OSI(Processor Device)
[    0.539545] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.539546] ACPI: Added _OSI(Processor Aggregator Device)
[    0.539547] ACPI: Added _OSI(Linux-Dell-Video)
[    0.539547] ACPI: Added _OSI(Linux-Lenovo-NV-HDMI-Audio)
[    0.539548] ACPI: Added _OSI(Linux-HPI-Hybrid-Graphics)
[    0.545626] ACPI: 9 ACPI AML tables successfully acquired and loaded
[    0.546474] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.549784] ACPI: Interpreter enabled
[    0.549792] ACPI: (supports S0 S5)
[    0.549793] ACPI: Using IOAPIC for interrupt routing
[    0.549961] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.550172] ACPI: Enabled 2 GPEs in block 00 to 1F
[    0.555691] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.555695] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cl=
ockPM Segments MSI EDR HPX-Type3]
[    0.555776] acpi PNP0A08:00: _OSC: platform does not support [LTR DPC]=

[    0.555855] acpi PNP0A08:00: _OSC: OS now controls [PME AER PCIeCapabi=
lity]
[    0.555862] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000=
 [bus 00-7f] only partially covers this bridge
[    0.555974] PCI host bridge to bus 0000:00
[    0.555975] pci_bus 0000:00: root bus resource [io  0x0000-0x03af wind=
ow]
[    0.555976] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7 wind=
ow]
[    0.555977] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df wind=
ow]
[    0.555977] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff wind=
ow]
[    0.555978] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bf=
fff window]
[    0.555979] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000df=
fff window]
[    0.555979] pci_bus 0000:00: root bus resource [mem 0xf0000000-0xfcfff=
fff window]
[    0.555980] pci_bus 0000:00: root bus resource [mem 0x1010000000-0x7ff=
fffffff window]
[    0.555981] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.555991] pci 0000:00:00.0: [1022:1480] type 00 class 0x060000
[    0.556072] pci 0000:00:00.2: [1022:1481] type 00 class 0x080600
[    0.556156] pci 0000:00:01.0: [1022:1482] type 00 class 0x060000
[    0.556218] pci 0000:00:01.1: [1022:1483] type 01 class 0x060400
[    0.556243] pci 0000:00:01.1: enabling Extended Tags
[    0.556290] pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
[    0.556389] pci 0000:00:01.2: [1022:1483] type 01 class 0x060400
[    0.556413] pci 0000:00:01.2: enabling Extended Tags
[    0.556460] pci 0000:00:01.2: PME# supported from D0 D3hot D3cold
[    0.556553] pci 0000:00:02.0: [1022:1482] type 00 class 0x060000
[    0.556615] pci 0000:00:03.0: [1022:1482] type 00 class 0x060000
[    0.556678] pci 0000:00:03.1: [1022:1483] type 01 class 0x060400
[    0.556746] pci 0000:00:03.1: PME# supported from D0 D3hot D3cold
[    0.556841] pci 0000:00:04.0: [1022:1482] type 00 class 0x060000
[    0.556906] pci 0000:00:05.0: [1022:1482] type 00 class 0x060000
[    0.556969] pci 0000:00:07.0: [1022:1482] type 00 class 0x060000
[    0.557028] pci 0000:00:07.1: [1022:1484] type 01 class 0x060400
[    0.557051] pci 0000:00:07.1: enabling Extended Tags
[    0.557089] pci 0000:00:07.1: PME# supported from D0 D3hot D3cold
[    0.557173] pci 0000:00:08.0: [1022:1482] type 00 class 0x060000
[    0.557233] pci 0000:00:08.1: [1022:1484] type 01 class 0x060400
[    0.557257] pci 0000:00:08.1: enabling Extended Tags
[    0.557300] pci 0000:00:08.1: PME# supported from D0 D3hot D3cold
[    0.557401] pci 0000:00:14.0: [1022:790b] type 00 class 0x0c0500
[    0.557507] pci 0000:00:14.3: [1022:790e] type 00 class 0x060100
[    0.557617] pci 0000:00:18.0: [1022:1440] type 00 class 0x060000
[    0.557652] pci 0000:00:18.1: [1022:1441] type 00 class 0x060000
[    0.557686] pci 0000:00:18.2: [1022:1442] type 00 class 0x060000
[    0.557719] pci 0000:00:18.3: [1022:1443] type 00 class 0x060000
[    0.557753] pci 0000:00:18.4: [1022:1444] type 00 class 0x060000
[    0.557787] pci 0000:00:18.5: [1022:1445] type 00 class 0x060000
[    0.557821] pci 0000:00:18.6: [1022:1446] type 00 class 0x060000
[    0.557856] pci 0000:00:18.7: [1022:1447] type 00 class 0x060000
[    0.558076] pci 0000:01:00.0: [144d:a808] type 00 class 0x010802
[    0.558094] pci 0000:01:00.0: reg 0x10: [mem 0xfc500000-0xfc503fff 64b=
it]
[    0.558287] pci 0000:00:01.1: PCI bridge to [bus 01]
[    0.558292] pci 0000:00:01.1:   bridge window [mem 0xfc500000-0xfc5fff=
ff]
[    0.558343] pci 0000:20:00.0: [1022:57ad] type 01 class 0x060400
[    0.558398] pci 0000:20:00.0: enabling Extended Tags
[    0.558483] pci 0000:20:00.0: PME# supported from D0 D3hot D3cold
[    0.558582] pci 0000:20:00.0: 63.012 Gb/s available PCIe bandwidth, li=
mited by 16.0 GT/s PCIe x4 link at 0000:00:01.2 (capable of 126.024 Gb/s =
with 16.0 GT/s PCIe x8 link)
[    0.558629] pci 0000:00:01.2: PCI bridge to [bus 20-2c]
[    0.558632] pci 0000:00:01.2:   bridge window [io  0xc000-0xefff]
[    0.558633] pci 0000:00:01.2:   bridge window [mem 0xfa000000-0xfbdfff=
ff]
[    0.558636] pci 0000:00:01.2:   bridge window [mem 0x7fff400000-0x7fff=
cfffff 64bit pref]
[    0.558763] pci 0000:21:01.0: [1022:57a3] type 01 class 0x060400
[    0.558837] pci 0000:21:01.0: enabling Extended Tags
[    0.559073] pci 0000:21:01.0: PME# supported from D0 D3hot D3cold
[    0.559414] pci 0000:21:02.0: [1022:57a3] type 01 class 0x060400
[    0.559484] pci 0000:21:02.0: enabling Extended Tags
[    0.559720] pci 0000:21:02.0: PME# supported from D0 D3hot D3cold
[    0.560099] pci 0000:21:04.0: [1022:57a3] type 01 class 0x060400
[    0.560168] pci 0000:21:04.0: enabling Extended Tags
[    0.560404] pci 0000:21:04.0: PME# supported from D0 D3hot D3cold
[    0.560737] pci 0000:21:05.0: [1022:57a3] type 01 class 0x060400
[    0.560827] pci 0000:21:05.0: enabling Extended Tags
[    0.561064] pci 0000:21:05.0: PME# supported from D0 D3hot D3cold
[    0.561500] pci 0000:21:06.0: [1022:57a3] type 01 class 0x060400
[    0.561569] pci 0000:21:06.0: enabling Extended Tags
[    0.561831] pci 0000:21:06.0: PME# supported from D0 D3hot D3cold
[    0.562263] pci 0000:21:08.0: [1022:57a4] type 01 class 0x060400
[    0.562332] pci 0000:21:08.0: enabling Extended Tags
[    0.562497] pci 0000:21:08.0: PME# supported from D0 D3hot D3cold
[    0.562691] pci 0000:21:09.0: [1022:57a4] type 01 class 0x060400
[    0.562760] pci 0000:21:09.0: enabling Extended Tags
[    0.562933] pci 0000:21:09.0: PME# supported from D0 D3hot D3cold
[    0.563121] pci 0000:21:0a.0: [1022:57a4] type 01 class 0x060400
[    0.563190] pci 0000:21:0a.0: enabling Extended Tags
[    0.563349] pci 0000:21:0a.0: PME# supported from D0 D3hot D3cold
[    0.563537] pci 0000:20:00.0: PCI bridge to [bus 21-2c]
[    0.563543] pci 0000:20:00.0:   bridge window [io  0xc000-0xefff]
[    0.563546] pci 0000:20:00.0:   bridge window [mem 0xfa000000-0xfbdfff=
ff]
[    0.563552] pci 0000:20:00.0:   bridge window [mem 0x7fff400000-0x7fff=
cfffff 64bit pref]
[    0.563793] pci 0000:23:00.0: [144d:a808] type 00 class 0x010802
[    0.563823] pci 0000:23:00.0: reg 0x10: [mem 0xfbd00000-0xfbd03fff 64b=
it]
[    0.564157] pci 0000:21:01.0: PCI bridge to [bus 23]
[    0.564165] pci 0000:21:01.0:   bridge window [mem 0xfbd00000-0xfbdfff=
ff]
[    0.564282] pci 0000:24:00.0: [8086:1563] type 00 class 0x020000
[    0.564313] pci 0000:24:00.0: reg 0x10: [mem 0x7fff800000-0x7fffbfffff=
 64bit pref]
[    0.564358] pci 0000:24:00.0: reg 0x20: [mem 0x7fffc04000-0x7fffc07fff=
 64bit pref]
[    0.564371] pci 0000:24:00.0: reg 0x30: [mem 0xfb280000-0xfb2fffff pre=
f]
[    0.564523] pci 0000:24:00.0: PME# supported from D0 D3hot D3cold
[    0.564585] pci 0000:24:00.0: reg 0x184: [mem 0xfb600000-0xfb603fff 64=
bit]
[    0.564586] pci 0000:24:00.0: VF(n) BAR0 space: [mem 0xfb600000-0xfb6f=
ffff 64bit] (contains BAR0 for 64 VFs)
[    0.564618] pci 0000:24:00.0: reg 0x190: [mem 0xfb500000-0xfb503fff 64=
bit]
[    0.564618] pci 0000:24:00.0: VF(n) BAR3 space: [mem 0xfb500000-0xfb5f=
ffff 64bit] (contains BAR3 for 64 VFs)
[    0.565111] pci 0000:24:00.1: [8086:1563] type 00 class 0x020000
[    0.565142] pci 0000:24:00.1: reg 0x10: [mem 0x7fff400000-0x7fff7fffff=
 64bit pref]
[    0.565187] pci 0000:24:00.1: reg 0x20: [mem 0x7fffc00000-0x7fffc03fff=
 64bit pref]
[    0.565200] pci 0000:24:00.1: reg 0x30: [mem 0xfb200000-0xfb27ffff pre=
f]
[    0.565332] pci 0000:24:00.1: PME# supported from D0 D3hot D3cold
[    0.565382] pci 0000:24:00.1: reg 0x184: [mem 0xfb400000-0xfb403fff 64=
bit]
[    0.565383] pci 0000:24:00.1: VF(n) BAR0 space: [mem 0xfb400000-0xfb4f=
ffff 64bit] (contains BAR0 for 64 VFs)
[    0.565414] pci 0000:24:00.1: reg 0x190: [mem 0xfb300000-0xfb303fff 64=
bit]
[    0.565415] pci 0000:24:00.1: VF(n) BAR3 space: [mem 0xfb300000-0xfb3f=
ffff 64bit] (contains BAR3 for 64 VFs)
[    0.565882] pci 0000:21:02.0: PCI bridge to [bus 24-25]
[    0.565891] pci 0000:21:02.0:   bridge window [mem 0xfb200000-0xfb6fff=
ff]
[    0.565896] pci 0000:21:02.0:   bridge window [mem 0x7fff400000-0x7fff=
cfffff 64bit pref]
[    0.566115] pci 0000:26:00.0: [8086:1533] type 00 class 0x020000
[    0.566145] pci 0000:26:00.0: reg 0x10: [mem 0xfbc00000-0xfbc7ffff]
[    0.566178] pci 0000:26:00.0: reg 0x18: [io  0xe000-0xe01f]
[    0.566194] pci 0000:26:00.0: reg 0x1c: [mem 0xfbc80000-0xfbc83fff]
[    0.566376] pci 0000:26:00.0: PME# supported from D0 D3hot D3cold
[    0.567692] pci 0000:21:04.0: PCI bridge to [bus 26]
[    0.567698] pci 0000:21:04.0:   bridge window [io  0xe000-0xefff]
[    0.567701] pci 0000:21:04.0:   bridge window [mem 0xfbc00000-0xfbcfff=
ff]
[    0.567923] pci 0000:27:00.0: [8086:1533] type 00 class 0x020000
[    0.567953] pci 0000:27:00.0: reg 0x10: [mem 0xfbb00000-0xfbb7ffff]
[    0.567985] pci 0000:27:00.0: reg 0x18: [io  0xd000-0xd01f]
[    0.568002] pci 0000:27:00.0: reg 0x1c: [mem 0xfbb80000-0xfbb83fff]
[    0.568182] pci 0000:27:00.0: PME# supported from D0 D3hot D3cold
[    0.568692] pci 0000:21:05.0: PCI bridge to [bus 27]
[    0.568698] pci 0000:21:05.0:   bridge window [io  0xd000-0xdfff]
[    0.568701] pci 0000:21:05.0:   bridge window [mem 0xfbb00000-0xfbbfff=
ff]
[    0.568830] pci 0000:28:00.0: [1a03:1150] type 01 class 0x060400
[    0.568907] pci 0000:28:00.0: enabling Extended Tags
[    0.568997] pci 0000:28:00.0: supports D1 D2
[    0.568997] pci 0000:28:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.569115] pci 0000:21:06.0: PCI bridge to [bus 28-29]
[    0.569121] pci 0000:21:06.0:   bridge window [io  0xc000-0xcfff]
[    0.569124] pci 0000:21:06.0:   bridge window [mem 0xfa000000-0xfb0fff=
ff]
[    0.569178] pci_bus 0000:29: extended config space not accessible
[    0.569198] pci 0000:29:00.0: [1a03:2000] type 00 class 0x030000
[    0.569225] pci 0000:29:00.0: reg 0x10: [mem 0xfa000000-0xfaffffff]
[    0.569239] pci 0000:29:00.0: reg 0x14: [mem 0xfb000000-0xfb01ffff]
[    0.569254] pci 0000:29:00.0: reg 0x18: [io  0xc000-0xc07f]
[    0.569365] pci 0000:29:00.0: supports D1 D2
[    0.569365] pci 0000:29:00.0: PME# supported from D0 D1 D2 D3hot D3col=
d
[    0.569365] pci 0000:28:00.0: PCI bridge to [bus 29]
[    0.569365] pci 0000:28:00.0:   bridge window [io  0xc000-0xcfff]
[    0.569365] pci 0000:28:00.0:   bridge window [mem 0xfa000000-0xfb0fff=
ff]
[    0.569365] pci 0000:2a:00.0: [1022:1485] type 00 class 0x130000
[    0.569365] pci 0000:2a:00.0: enabling Extended Tags
[    0.569365] pci 0000:2a:00.0: 63.012 Gb/s available PCIe bandwidth, li=
mited by 16.0 GT/s PCIe x4 link at 0000:00:01.2 (capable of 252.048 Gb/s =
with 16.0 GT/s PCIe x16 link)
[    0.569365] pci 0000:2a:00.1: [1022:149c] type 00 class 0x0c0330
[    0.569495] pci 0000:2a:00.1: reg 0x10: [mem 0xfb800000-0xfb8fffff 64b=
it]
[    0.570252] pci 0000:2a:00.1: enabling Extended Tags
[    0.570769] pci 0000:2a:00.1: PME# supported from D0 D3hot D3cold
[    0.571100] pci 0000:2a:00.3: [1022:149c] type 00 class 0x0c0330
[    0.571125] pci 0000:2a:00.3: reg 0x10: [mem 0xfb700000-0xfb7fffff 64b=
it]
[    0.571183] pci 0000:2a:00.3: enabling Extended Tags
[    0.571258] pci 0000:2a:00.3: PME# supported from D0 D3hot D3cold
[    0.571377] pci 0000:21:08.0: PCI bridge to [bus 2a]
[    0.571385] pci 0000:21:08.0:   bridge window [mem 0xfb700000-0xfb8fff=
ff]
[    0.571491] pci 0000:2b:00.0: [1022:7901] type 00 class 0x010601
[    0.571560] pci 0000:2b:00.0: reg 0x24: [mem 0xfba00000-0xfba007ff]
[    0.571579] pci 0000:2b:00.0: enabling Extended Tags
[    0.571677] pci 0000:2b:00.0: PME# supported from D3hot D3cold
[    0.571757] pci 0000:2b:00.0: 63.012 Gb/s available PCIe bandwidth, li=
mited by 16.0 GT/s PCIe x4 link at 0000:00:01.2 (capable of 252.048 Gb/s =
with 16.0 GT/s PCIe x16 link)
[    0.571803] pci 0000:21:09.0: PCI bridge to [bus 2b]
[    0.571811] pci 0000:21:09.0:   bridge window [mem 0xfba00000-0xfbafff=
ff]
[    0.571915] pci 0000:2c:00.0: [1022:7901] type 00 class 0x010601
[    0.571984] pci 0000:2c:00.0: reg 0x24: [mem 0xfb900000-0xfb9007ff]
[    0.572003] pci 0000:2c:00.0: enabling Extended Tags
[    0.572100] pci 0000:2c:00.0: PME# supported from D3hot D3cold
[    0.572180] pci 0000:2c:00.0: 63.012 Gb/s available PCIe bandwidth, li=
mited by 16.0 GT/s PCIe x4 link at 0000:00:01.2 (capable of 252.048 Gb/s =
with 16.0 GT/s PCIe x16 link)
[    0.572226] pci 0000:21:0a.0: PCI bridge to [bus 2c]
[    0.572234] pci 0000:21:0a.0:   bridge window [mem 0xfb900000-0xfb9fff=
ff]
[    0.572325] pci 0000:2d:00.0: [1000:005f] type 00 class 0x010400
[    0.572335] pci 0000:2d:00.0: reg 0x10: [io  0xf000-0xf0ff]
[    0.572344] pci 0000:2d:00.0: reg 0x14: [mem 0xfc400000-0xfc40ffff 64b=
it]
[    0.572353] pci 0000:2d:00.0: reg 0x1c: [mem 0xfc300000-0xfc3fffff 64b=
it]
[    0.572364] pci 0000:2d:00.0: reg 0x30: [mem 0xfc200000-0xfc2fffff pre=
f]
[    0.572472] pci 0000:2d:00.0: supports D1 D2
[    0.572535] pci 0000:00:03.1: PCI bridge to [bus 2d]
[    0.572538] pci 0000:00:03.1:   bridge window [io  0xf000-0xffff]
[    0.572539] pci 0000:00:03.1:   bridge window [mem 0xfc200000-0xfc4fff=
ff]
[    0.572576] pci 0000:2e:00.0: [1022:148a] type 00 class 0x130000
[    0.572610] pci 0000:2e:00.0: enabling Extended Tags
[    0.572708] pci 0000:00:07.1: PCI bridge to [bus 2e]
[    0.572752] pci 0000:2f:00.0: [1022:1485] type 00 class 0x130000
[    0.572794] pci 0000:2f:00.0: enabling Extended Tags
[    0.572903] pci 0000:2f:00.1: [1022:1486] type 00 class 0x108000
[    0.572922] pci 0000:2f:00.1: reg 0x18: [mem 0xfc000000-0xfc0fffff]
[    0.572937] pci 0000:2f:00.1: reg 0x24: [mem 0xfc108000-0xfc109fff]
[    0.572946] pci 0000:2f:00.1: enabling Extended Tags
[    0.573043] pci 0000:2f:00.3: [1022:149c] type 00 class 0x0c0330
[    0.573055] pci 0000:2f:00.3: reg 0x10: [mem 0xfbf00000-0xfbffffff 64b=
it]
[    0.573084] pci 0000:2f:00.3: enabling Extended Tags
[    0.573129] pci 0000:2f:00.3: PME# supported from D0 D3hot D3cold
[    0.573195] pci 0000:2f:00.4: [1022:1487] type 00 class 0x040300
[    0.573204] pci 0000:2f:00.4: reg 0x10: [mem 0xfc100000-0xfc107fff]
[    0.573238] pci 0000:2f:00.4: enabling Extended Tags
[    0.573281] pci 0000:2f:00.4: PME# supported from D0 D3hot D3cold
[    0.573351] pci 0000:00:08.1: PCI bridge to [bus 2f]
[    0.573355] pci 0000:00:08.1:   bridge window [mem 0xfbf00000-0xfc1fff=
ff]
[    0.573703] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 5 7 10 11 14 15) *=
0
[    0.573733] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 5 7 10 11 14 15) *=
0
[    0.573758] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 5 7 10 11 14 15) *=
0
[    0.573789] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 5 7 10 11 14 15) *=
0
[    0.573818] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 5 7 10 11 14 15) *=
0
[    0.573841] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 5 7 10 11 14 15) *=
0
[    0.573865] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 5 7 10 11 14 15) *=
0
[    0.573888] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 5 7 10 11 14 15) *=
0
[    0.574445] iommu: Default domain type: Translated=20
[    0.574448] pci 0000:29:00.0: vgaarb: setting as boot VGA device
[    0.574448] pci 0000:29:00.0: vgaarb: VGA device added: decodes=3Dio+m=
em,owns=3Dio+mem,locks=3Dnone
[    0.574448] pci 0000:29:00.0: vgaarb: bridge control possible
[    0.574448] vgaarb: loaded
[    0.574509] SCSI subsystem initialized
[    0.574514] libata version 3.00 loaded.
[    0.574514] ACPI: bus type USB registered
[    0.574514] usbcore: registered new interface driver usbfs
[    0.574514] usbcore: registered new interface driver hub
[    0.574514] usbcore: registered new device driver usb
[    0.574514] pps_core: LinuxPPS API ver. 1 registered
[    0.574514] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolf=
o Giometti <giometti@linux.it>
[    0.574514] PTP clock support registered
[    0.574514] EDAC MC: Ver: 3.0.0
[    0.575528] NetLabel: Initializing
[    0.575529] NetLabel:  domain hash size =3D 128
[    0.575529] NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
[    0.575538] NetLabel:  unlabeled traffic allowed by default
[    0.575540] PCI: Using ACPI for IRQ routing
[    0.578903] PCI: pci_cache_line_size set to 64 bytes
[    0.579995] Expanded resource Reserved due to conflict with PCI Bus 00=
00:00
[    0.579997] e820: reserve RAM buffer [mem 0x0009c400-0x0009ffff]
[    0.579998] e820: reserve RAM buffer [mem 0x09bff000-0x0bffffff]
[    0.579999] e820: reserve RAM buffer [mem 0x0a200000-0x0bffffff]
[    0.579999] e820: reserve RAM buffer [mem 0xeb95a000-0xebffffff]
[    0.580000] e820: reserve RAM buffer [mem 0xef000000-0xefffffff]
[    0.580000] e820: reserve RAM buffer [mem 0x100f300000-0x100fffffff]
[    0.580498] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.580500] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.582477] clocksource: Switched to clocksource tsc-early
[    0.592274] VFS: Disk quotas dquot_6.6.0
[    0.592285] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 by=
tes)
[    0.592320] pnp: PnP ACPI init
[    0.592373] system 00:00: [mem 0xf0000000-0xf7ffffff] has been reserve=
d
[    0.592376] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.592419] system 00:01: [mem 0xfd200000-0xfd2fffff] has been reserve=
d
[    0.592421] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.592441] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.592562] system 00:03: [io  0x0a00-0x0a0f] has been reserved
[    0.592563] system 00:03: [io  0x0a10-0x0a1f] has been reserved
[    0.592564] system 00:03: [io  0x0a20-0x0a2f] has been reserved
[    0.592564] system 00:03: [io  0x0a30-0x0a3f] has been reserved
[    0.592565] system 00:03: [io  0x0a40-0x0a4f] has been reserved
[    0.592566] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.592695] pnp 00:04: [dma 0 disabled]
[    0.592712] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.592832] pnp 00:05: [dma 0 disabled]
[    0.592848] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)=

[    0.592972] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.592973] system 00:06: [io  0x040b] has been reserved
[    0.592974] system 00:06: [io  0x04d6] has been reserved
[    0.592974] system 00:06: [io  0x0c00-0x0c01] has been reserved
[    0.592975] system 00:06: [io  0x0c14] has been reserved
[    0.592976] system 00:06: [io  0x0c50-0x0c51] has been reserved
[    0.592976] system 00:06: [io  0x0c52] has been reserved
[    0.592977] system 00:06: [io  0x0c6c] has been reserved
[    0.592978] system 00:06: [io  0x0c6f] has been reserved
[    0.592978] system 00:06: [io  0x0cd0-0x0cd1] has been reserved
[    0.592979] system 00:06: [io  0x0cd2-0x0cd3] has been reserved
[    0.592980] system 00:06: [io  0x0cd4-0x0cd5] has been reserved
[    0.592980] system 00:06: [io  0x0cd6-0x0cd7] has been reserved
[    0.592981] system 00:06: [io  0x0cd8-0x0cdf] has been reserved
[    0.592982] system 00:06: [io  0x0800-0x089f] has been reserved
[    0.592982] system 00:06: [io  0x0b00-0x0b0f] has been reserved
[    0.592983] system 00:06: [io  0x0b20-0x0b3f] has been reserved
[    0.592984] system 00:06: [io  0x0900-0x090f] has been reserved
[    0.592984] system 00:06: [io  0x0910-0x091f] has been reserved
[    0.592985] system 00:06: [mem 0xfec00000-0xfec00fff] could not be res=
erved
[    0.592986] system 00:06: [mem 0xfec01000-0xfec01fff] could not be res=
erved
[    0.592987] system 00:06: [mem 0xfedc0000-0xfedc0fff] has been reserve=
d
[    0.592988] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserve=
d
[    0.592988] system 00:06: [mem 0xfed80000-0xfed8ffff] could not be res=
erved
[    0.592989] system 00:06: [mem 0xfec10000-0xfec10fff] has been reserve=
d
[    0.592990] system 00:06: [mem 0xff000000-0xffffffff] has been reserve=
d
[    0.592992] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.593237] pnp: PnP ACPI: found 7 devices
[    0.598407] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff,=
 max_idle_ns: 2085701024 ns
[    0.598443] NET: Registered protocol family 2
[    0.598601] tcp_listen_portaddr_hash hash table entries: 32768 (order:=
 7, 524288 bytes, linear)
[    0.598644] TCP established hash table entries: 524288 (order: 10, 419=
4304 bytes, linear)
[    0.599075] TCP bind hash table entries: 65536 (order: 8, 1048576 byte=
s, linear)
[    0.599161] TCP: Hash tables configured (established 524288 bind 65536=
)
[    0.599332] MPTCP token hash table entries: 65536 (order: 8, 1572864 b=
ytes, linear)
[    0.599403] UDP hash table entries: 32768 (order: 8, 1048576 bytes, li=
near)
[    0.599491] UDP-Lite hash table entries: 32768 (order: 8, 1048576 byte=
s, linear)
[    0.599622] NET: Registered protocol family 1
[    0.599625] NET: Registered protocol family 44
[    0.599636] pci 0000:00:01.1: PCI bridge to [bus 01]
[    0.599639] pci 0000:00:01.1:   bridge window [mem 0xfc500000-0xfc5fff=
ff]
[    0.599645] pci 0000:21:01.0: PCI bridge to [bus 23]
[    0.599649] pci 0000:21:01.0:   bridge window [mem 0xfbd00000-0xfbdfff=
ff]
[    0.599658] pci 0000:21:02.0: PCI bridge to [bus 24-25]
[    0.599663] pci 0000:21:02.0:   bridge window [mem 0xfb200000-0xfb6fff=
ff]
[    0.599666] pci 0000:21:02.0:   bridge window [mem 0x7fff400000-0x7fff=
cfffff 64bit pref]
[    0.599672] pci 0000:21:04.0: PCI bridge to [bus 26]
[    0.599675] pci 0000:21:04.0:   bridge window [io  0xe000-0xefff]
[    0.599679] pci 0000:21:04.0:   bridge window [mem 0xfbc00000-0xfbcfff=
ff]
[    0.599688] pci 0000:21:05.0: PCI bridge to [bus 27]
[    0.599690] pci 0000:21:05.0:   bridge window [io  0xd000-0xdfff]
[    0.599694] pci 0000:21:05.0:   bridge window [mem 0xfbb00000-0xfbbfff=
ff]
[    0.599703] pci 0000:28:00.0: PCI bridge to [bus 29]
[    0.599705] pci 0000:28:00.0:   bridge window [io  0xc000-0xcfff]
[    0.599711] pci 0000:28:00.0:   bridge window [mem 0xfa000000-0xfb0fff=
ff]
[    0.599722] pci 0000:21:06.0: PCI bridge to [bus 28-29]
[    0.599724] pci 0000:21:06.0:   bridge window [io  0xc000-0xcfff]
[    0.599729] pci 0000:21:06.0:   bridge window [mem 0xfa000000-0xfb0fff=
ff]
[    0.599737] pci 0000:21:08.0: PCI bridge to [bus 2a]
[    0.599742] pci 0000:21:08.0:   bridge window [mem 0xfb700000-0xfb8fff=
ff]
[    0.599751] pci 0000:21:09.0: PCI bridge to [bus 2b]
[    0.599755] pci 0000:21:09.0:   bridge window [mem 0xfba00000-0xfbafff=
ff]
[    0.599764] pci 0000:21:0a.0: PCI bridge to [bus 2c]
[    0.599768] pci 0000:21:0a.0:   bridge window [mem 0xfb900000-0xfb9fff=
ff]
[    0.599777] pci 0000:20:00.0: PCI bridge to [bus 21-2c]
[    0.599779] pci 0000:20:00.0:   bridge window [io  0xc000-0xefff]
[    0.599783] pci 0000:20:00.0:   bridge window [mem 0xfa000000-0xfbdfff=
ff]
[    0.599787] pci 0000:20:00.0:   bridge window [mem 0x7fff400000-0x7fff=
cfffff 64bit pref]
[    0.599793] pci 0000:00:01.2: PCI bridge to [bus 20-2c]
[    0.599794] pci 0000:00:01.2:   bridge window [io  0xc000-0xefff]
[    0.599796] pci 0000:00:01.2:   bridge window [mem 0xfa000000-0xfbdfff=
ff]
[    0.599799] pci 0000:00:01.2:   bridge window [mem 0x7fff400000-0x7fff=
cfffff 64bit pref]
[    0.599802] pci 0000:00:03.1: PCI bridge to [bus 2d]
[    0.599803] pci 0000:00:03.1:   bridge window [io  0xf000-0xffff]
[    0.599805] pci 0000:00:03.1:   bridge window [mem 0xfc200000-0xfc4fff=
ff]
[    0.599809] pci 0000:00:07.1: PCI bridge to [bus 2e]
[    0.599815] pci 0000:00:08.1: PCI bridge to [bus 2f]
[    0.599818] pci 0000:00:08.1:   bridge window [mem 0xfbf00000-0xfc1fff=
ff]
[    0.599822] pci_bus 0000:00: resource 4 [io  0x0000-0x03af window]
[    0.599823] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7 window]
[    0.599823] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df window]
[    0.599824] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff window]
[    0.599825] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff win=
dow]
[    0.599825] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff win=
dow]
[    0.599826] pci_bus 0000:00: resource 10 [mem 0xf0000000-0xfcffffff wi=
ndow]
[    0.599827] pci_bus 0000:00: resource 11 [mem 0x1010000000-0x7ffffffff=
f window]
[    0.599828] pci_bus 0000:01: resource 1 [mem 0xfc500000-0xfc5fffff]
[    0.599828] pci_bus 0000:20: resource 0 [io  0xc000-0xefff]
[    0.599829] pci_bus 0000:20: resource 1 [mem 0xfa000000-0xfbdfffff]
[    0.599829] pci_bus 0000:20: resource 2 [mem 0x7fff400000-0x7fffcfffff=
 64bit pref]
[    0.599830] pci_bus 0000:21: resource 0 [io  0xc000-0xefff]
[    0.599831] pci_bus 0000:21: resource 1 [mem 0xfa000000-0xfbdfffff]
[    0.599831] pci_bus 0000:21: resource 2 [mem 0x7fff400000-0x7fffcfffff=
 64bit pref]
[    0.599832] pci_bus 0000:23: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    0.599833] pci_bus 0000:24: resource 1 [mem 0xfb200000-0xfb6fffff]
[    0.599833] pci_bus 0000:24: resource 2 [mem 0x7fff400000-0x7fffcfffff=
 64bit pref]
[    0.599834] pci_bus 0000:26: resource 0 [io  0xe000-0xefff]
[    0.599834] pci_bus 0000:26: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    0.599835] pci_bus 0000:27: resource 0 [io  0xd000-0xdfff]
[    0.599836] pci_bus 0000:27: resource 1 [mem 0xfbb00000-0xfbbfffff]
[    0.599836] pci_bus 0000:28: resource 0 [io  0xc000-0xcfff]
[    0.599837] pci_bus 0000:28: resource 1 [mem 0xfa000000-0xfb0fffff]
[    0.599838] pci_bus 0000:29: resource 0 [io  0xc000-0xcfff]
[    0.599838] pci_bus 0000:29: resource 1 [mem 0xfa000000-0xfb0fffff]
[    0.599839] pci_bus 0000:2a: resource 1 [mem 0xfb700000-0xfb8fffff]
[    0.599840] pci_bus 0000:2b: resource 1 [mem 0xfba00000-0xfbafffff]
[    0.599840] pci_bus 0000:2c: resource 1 [mem 0xfb900000-0xfb9fffff]
[    0.599841] pci_bus 0000:2d: resource 0 [io  0xf000-0xffff]
[    0.599841] pci_bus 0000:2d: resource 1 [mem 0xfc200000-0xfc4fffff]
[    0.599842] pci_bus 0000:2f: resource 1 [mem 0xfbf00000-0xfc1fffff]
[    0.600425] pci 0000:29:00.0: Video device with shadowed ROM at [mem 0=
x000c0000-0x000dffff]
[    0.600695] pci 0000:2d:00.0: [Firmware Bug]: disabling VPD access (ca=
n't determine size of non-standard VPD format)
[    0.600767] PCI: CLS 64 bytes, default 64
[    0.600794] Trying to unpack rootfs image as initramfs...
[    0.871569] Freeing initrd memory: 28376K
[    0.871598] pci 0000:00:00.2: AMD-Vi: IOMMU performance counters suppo=
rted
[    0.871647] pci 0000:00:01.0: Adding to iommu group 0
[    0.871655] pci 0000:00:01.1: Adding to iommu group 1
[    0.871662] pci 0000:00:01.2: Adding to iommu group 2
[    0.871671] pci 0000:00:02.0: Adding to iommu group 3
[    0.871682] pci 0000:00:03.0: Adding to iommu group 4
[    0.871689] pci 0000:00:03.1: Adding to iommu group 5
[    0.871697] pci 0000:00:04.0: Adding to iommu group 6
[    0.871706] pci 0000:00:05.0: Adding to iommu group 7
[    0.871717] pci 0000:00:07.0: Adding to iommu group 8
[    0.871723] pci 0000:00:07.1: Adding to iommu group 9
[    0.871733] pci 0000:00:08.0: Adding to iommu group 10
[    0.871740] pci 0000:00:08.1: Adding to iommu group 11
[    0.871753] pci 0000:00:14.0: Adding to iommu group 12
[    0.871759] pci 0000:00:14.3: Adding to iommu group 12
[    0.871788] pci 0000:00:18.0: Adding to iommu group 13
[    0.871794] pci 0000:00:18.1: Adding to iommu group 13
[    0.871800] pci 0000:00:18.2: Adding to iommu group 13
[    0.871809] pci 0000:00:18.3: Adding to iommu group 13
[    0.871816] pci 0000:00:18.4: Adding to iommu group 13
[    0.871822] pci 0000:00:18.5: Adding to iommu group 13
[    0.871828] pci 0000:00:18.6: Adding to iommu group 13
[    0.871834] pci 0000:00:18.7: Adding to iommu group 13
[    0.871842] pci 0000:01:00.0: Adding to iommu group 14
[    0.871850] pci 0000:20:00.0: Adding to iommu group 15
[    0.871881] pci 0000:21:01.0: Adding to iommu group 16
[    0.871911] pci 0000:21:02.0: Adding to iommu group 17
[    0.871940] pci 0000:21:04.0: Adding to iommu group 18
[    0.871970] pci 0000:21:05.0: Adding to iommu group 19
[    0.872000] pci 0000:21:06.0: Adding to iommu group 20
[    0.872011] pci 0000:21:08.0: Adding to iommu group 21
[    0.872021] pci 0000:21:09.0: Adding to iommu group 22
[    0.872031] pci 0000:21:0a.0: Adding to iommu group 23
[    0.872062] pci 0000:23:00.0: Adding to iommu group 24
[    0.872097] pci 0000:24:00.0: Adding to iommu group 25
[    0.872156] pci 0000:24:00.1: Adding to iommu group 26
[    0.872187] pci 0000:26:00.0: Adding to iommu group 27
[    0.872218] pci 0000:27:00.0: Adding to iommu group 28
[    0.872248] pci 0000:28:00.0: Adding to iommu group 29
[    0.872251] pci 0000:29:00.0: Adding to iommu group 29
[    0.872253] pci 0000:2a:00.0: Adding to iommu group 21
[    0.872256] pci 0000:2a:00.1: Adding to iommu group 21
[    0.872259] pci 0000:2a:00.3: Adding to iommu group 21
[    0.872263] pci 0000:2b:00.0: Adding to iommu group 22
[    0.872266] pci 0000:2c:00.0: Adding to iommu group 23
[    0.872274] pci 0000:2d:00.0: Adding to iommu group 30
[    0.872281] pci 0000:2e:00.0: Adding to iommu group 31
[    0.872289] pci 0000:2f:00.0: Adding to iommu group 32
[    0.872298] pci 0000:2f:00.1: Adding to iommu group 33
[    0.872307] pci 0000:2f:00.3: Adding to iommu group 34
[    0.872315] pci 0000:2f:00.4: Adding to iommu group 35
[    0.876797] pci 0000:00:00.2: AMD-Vi: Found IOMMU cap 0x40
[    0.876799] pci 0000:00:00.2: AMD-Vi: Extended features (0x58f77ef2229=
4ade):
[    0.876800]  PPR X2APIC NX GT IA GA PC GA_vAPIC
[    0.876803] AMD-Vi: Interrupt remapping enabled
[    0.876803] AMD-Vi: Virtual APIC enabled
[    0.876803] AMD-Vi: X2APIC enabled
[    0.876880] AMD-Vi: Lazy IO/TLB flushing enabled
[    0.877621] amd_uncore: 4  amd_df counters detected
[    0.877625] amd_uncore: 6  amd_l3 counters detected
[    0.877882] LVT offset 0 assigned for vector 0x400
[    0.878004] perf: AMD IBS detected (0x000003ff)
[    0.878008] perf/amd_iommu: Detected AMD IOMMU #0 (2 banks, 4 counters=
/bank).
[    0.879379] Initialise system trusted keyrings
[    0.879388] Key type blacklist registered
[    0.879414] workingset: timestamp_bits=3D36 max_order=3D24 bucket_orde=
r=3D0
[    0.880074] zbud: loaded
[    0.880288] integrity: Platform Keyring initialized
[    0.882699] NET: Registered protocol family 38
[    0.882701] xor: automatically using best checksumming function   avx =
     =20
[    0.882701] Key type asymmetric registered
[    0.882702] Asymmetric key parser 'x509' registered
[    0.882706] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 245)
[    0.882733] io scheduler mq-deadline registered
[    0.882734] io scheduler kyber registered
[    0.882746] io scheduler bfq registered
[    0.882898] atomic64_test: passed for x86-64 platform with CX8 and wit=
h SSE
[    0.882982] pcieport 0000:00:01.1: PME: Signaling with IRQ 27
[    0.883022] pcieport 0000:00:01.1: AER: enabled with IRQ 27
[    0.883110] pcieport 0000:00:01.2: PME: Signaling with IRQ 28
[    0.883166] pcieport 0000:00:01.2: AER: enabled with IRQ 28
[    0.883254] pcieport 0000:00:03.1: PME: Signaling with IRQ 29
[    0.883288] pcieport 0000:00:03.1: AER: enabled with IRQ 29
[    0.883429] pcieport 0000:00:07.1: PME: Signaling with IRQ 31
[    0.883462] pcieport 0000:00:07.1: AER: enabled with IRQ 31
[    0.883539] pcieport 0000:00:08.1: PME: Signaling with IRQ 32
[    0.883577] pcieport 0000:00:08.1: AER: enabled with IRQ 32
[    0.885533] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PN=
P0C0C:00/input/input0
[    0.885547] ACPI: Power Button [PWRB]
[    0.885565] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    0.885586] ACPI: Power Button [PWRF]
[    0.885628] Monitor-Mwait will be used to enter C-1 state
[    0.885634] ACPI: \_PR_.C000: Found 2 idle states
[    0.885700] ACPI: \_PR_.C002: Found 2 idle states
[    0.885755] ACPI: \_PR_.C004: Found 2 idle states
[    0.885842] ACPI: \_PR_.C006: Found 2 idle states
[    0.885919] ACPI: \_PR_.C008: Found 2 idle states
[    0.885977] ACPI: \_PR_.C00A: Found 2 idle states
[    0.886064] ACPI: \_PR_.C00C: Found 2 idle states
[    0.886143] ACPI: \_PR_.C00E: Found 2 idle states
[    0.886219] ACPI: \_PR_.C010: Found 2 idle states
[    0.886273] ACPI: \_PR_.C012: Found 2 idle states
[    0.886363] ACPI: \_PR_.C014: Found 2 idle states
[    0.886435] ACPI: \_PR_.C016: Found 2 idle states
[    0.886511] ACPI: \_PR_.C001: Found 2 idle states
[    0.886584] ACPI: \_PR_.C003: Found 2 idle states
[    0.886659] ACPI: \_PR_.C005: Found 2 idle states
[    0.886739] ACPI: \_PR_.C007: Found 2 idle states
[    0.886811] ACPI: \_PR_.C009: Found 2 idle states
[    0.886883] ACPI: \_PR_.C00B: Found 2 idle states
[    0.886937] ACPI: \_PR_.C00D: Found 2 idle states
[    0.887019] ACPI: \_PR_.C00F: Found 2 idle states
[    0.887093] ACPI: \_PR_.C011: Found 2 idle states
[    0.887178] ACPI: \_PR_.C013: Found 2 idle states
[    0.887230] ACPI: \_PR_.C015: Found 2 idle states
[    0.887275] ACPI: \_PR_.C017: Found 2 idle states
[    0.887426] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.887484] 00:04: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200=
) is a 16550A
[    0.888022] 00:05: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115200=
) is a 16550A
[    0.889218] Non-volatile memory driver v1.3
[    0.889233] Linux agpgart interface v0.103
[    0.890804] ahci 0000:2b:00.0: version 3.0
[    0.891083] ahci 0000:2b:00.0: AHCI 0001.0301 32 slots 4 ports 6 Gbps =
0xf impl SATA mode
[    0.891085] ahci 0000:2b:00.0: flags: 64bit ncq sntf ilck pm led clo o=
nly pmp fbs pio slum part=20
[    0.891347] scsi host0: ahci
[    0.891423] scsi host1: ahci
[    0.891481] scsi host2: ahci
[    0.891538] scsi host3: ahci
[    0.891559] ata1: SATA max UDMA/133 abar m2048@0xfba00000 port 0xfba00=
100 irq 43
[    0.891561] ata2: SATA max UDMA/133 abar m2048@0xfba00000 port 0xfba00=
180 irq 44
[    0.891563] ata3: SATA max UDMA/133 abar m2048@0xfba00000 port 0xfba00=
200 irq 45
[    0.891565] ata4: SATA max UDMA/133 abar m2048@0xfba00000 port 0xfba00=
280 irq 46
[    0.891860] ahci 0000:2c:00.0: AHCI 0001.0301 32 slots 4 ports 6 Gbps =
0x33 impl SATA mode
[    0.891861] ahci 0000:2c:00.0: flags: 64bit ncq sntf ilck pm led clo o=
nly pmp fbs pio slum part=20
[    0.892154] scsi host4: ahci
[    0.892205] scsi host5: ahci
[    0.892254] scsi host6: ahci
[    0.892305] scsi host7: ahci
[    0.892353] scsi host8: ahci
[    0.892403] scsi host9: ahci
[    0.892423] ata5: SATA max UDMA/133 abar m2048@0xfb900000 port 0xfb900=
100 irq 59
[    0.892426] ata6: SATA max UDMA/133 abar m2048@0xfb900000 port 0xfb900=
180 irq 60
[    0.892426] ata7: DUMMY
[    0.892426] ata8: DUMMY
[    0.892429] ata9: SATA max UDMA/133 abar m2048@0xfb900000 port 0xfb900=
300 irq 63
[    0.892431] ata10: SATA max UDMA/133 abar m2048@0xfb900000 port 0xfb90=
0380 irq 64
[    0.892511] libphy: Fixed MDIO Bus: probed
[    0.892567] usbcore: registered new interface driver usbserial_generic=

[    0.892569] usbserial: USB Serial support registered for generic
[    0.892578] i8042: PNP: No PS/2 controller found.
[    0.892593] mousedev: PS/2 mouse device common for all mice
[    0.892646] rtc_cmos 00:02: RTC can wake from S4
[    0.892786] rtc_cmos 00:02: registered as rtc0
[    0.892839] rtc_cmos 00:02: setting system clock to 2021-04-14T09:00:1=
2 UTC (1618390812)
[    0.892846] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvr=
am, hpet irqs
[    0.892865] device-mapper: uevent: version 1.0.3
[    0.892892] device-mapper: ioctl: 4.43.0-ioctl (2020-10-01) initialise=
d: dm-devel@redhat.com
[    0.892976] hid: raw HID events driver (C) Jiri Kosina
[    0.892991] usbcore: registered new interface driver usbhid
[    0.892991] usbhid: USB HID core driver
[    0.893031] drop_monitor: Initializing network drop monitor service
[    0.893074] Initializing XFRM netlink socket
[    0.893130] NET: Registered protocol family 10
[    0.894644] Segment Routing with IPv6
[    0.894644] RPL Segment Routing with IPv6
[    0.894654] mip6: Mobile IPv6
[    0.894655] NET: Registered protocol family 17
[    0.895531] microcode: CPU0: patch_level=3D0x08701021
[    0.895536] microcode: CPU1: patch_level=3D0x08701021
[    0.895542] microcode: CPU2: patch_level=3D0x08701021
[    0.895548] microcode: CPU3: patch_level=3D0x08701021
[    0.895554] microcode: CPU4: patch_level=3D0x08701021
[    0.895560] microcode: CPU5: patch_level=3D0x08701021
[    0.895563] microcode: CPU6: patch_level=3D0x08701021
[    0.895569] microcode: CPU7: patch_level=3D0x08701021
[    0.895574] microcode: CPU8: patch_level=3D0x08701021
[    0.895581] microcode: CPU9: patch_level=3D0x08701021
[    0.895586] microcode: CPU10: patch_level=3D0x08701021
[    0.895591] microcode: CPU11: patch_level=3D0x08701021
[    0.895597] microcode: CPU12: patch_level=3D0x08701021
[    0.895602] microcode: CPU13: patch_level=3D0x08701021
[    0.895607] microcode: CPU14: patch_level=3D0x08701021
[    0.895612] microcode: CPU15: patch_level=3D0x08701021
[    0.895617] microcode: CPU16: patch_level=3D0x08701021
[    0.895622] microcode: CPU17: patch_level=3D0x08701021
[    0.895627] microcode: CPU18: patch_level=3D0x08701021
[    0.895632] microcode: CPU19: patch_level=3D0x08701021
[    0.895636] microcode: CPU20: patch_level=3D0x08701021
[    0.895641] microcode: CPU21: patch_level=3D0x08701021
[    0.895643] microcode: CPU22: patch_level=3D0x08701021
[    0.895647] microcode: CPU23: patch_level=3D0x08701021
[    0.895649] microcode: Microcode Update Driver: v2.2.
[    0.895852] resctrl: L3 allocation detected
[    0.895852] resctrl: L3DATA allocation detected
[    0.895853] resctrl: L3CODE allocation detected
[    0.895853] resctrl: MB allocation detected
[    0.895853] resctrl: L3 monitoring detected
[    0.895855] IPI shorthand broadcast: enabled
[    0.895859] AVX2 version of gcm_enc/dec engaged.
[    0.895859] AES CTR mode by8 optimization enabled
[    0.903035] sched_clock: Marking stable (895760132, 7269720)->(1059742=
456, -156712604)
[    0.903162] registered taskstats version 1
[    0.903173] Loading compiled-in X.509 certificates
[    0.903571] Loaded X.509 cert 'Build time autogenerated kernel key: f2=
66bdb82dffdd59a898acc7eaad42bca7acfd79'
[    0.903590] zswap: loaded using pool lzo/zbud
[    0.903733] Key type ._fscrypt registered
[    0.903734] Key type .fscrypt registered
[    0.903734] Key type fscrypt-provisioning registered
[    0.903838] Btrfs loaded, crc32c=3Dcrc32c-generic
[    0.904900] Key type encrypted registered
[    0.904904] ima: No TPM chip found, activating TPM-bypass!
[    0.904908] ima: Allocated hash algorithm: sha256
[    0.904915] ima: No architecture policies found
[    0.904920] evm: Initialising EVM extended attributes:
[    0.904920] evm: security.selinux
[    0.904920] evm: security.apparmor
[    0.904921] evm: security.ima
[    0.904921] evm: security.capability
[    0.904921] evm: HMAC attrs: 0x1
[    0.905119] PM:   Magic number: 1:952:19
[    0.905198] RAS: Correctable Errors collector initialized.
[    1.362455] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.362458] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.362482] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.362487] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.362507] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.362532] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.363454] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.363478] ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.363512] ata2.00: NCQ Send/Recv Log not supported
[    1.363513] ata2.00: ATA-9: ST2000VN004-2E4164, SC60, max UDMA/133
[    1.363514] ata2.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32=
), AA
[    1.363530] ata4.00: NCQ Send/Recv Log not supported
[    1.363532] ata4.00: ATA-9: ST2000VN004-2E4164, SC60, max UDMA/133
[    1.363533] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32=
), AA
[    1.363541] ata10.00: NCQ Send/Recv Log not supported
[    1.363542] ata10.00: ATA-9: ST2000VN004-2E4164, SC60, max UDMA/133
[    1.363543] ata10.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 3=
2), AA
[    1.363553] ata5.00: NCQ Send/Recv Log not supported
[    1.363554] ata5.00: ATA-9: ST2000VN004-2E4164, SC60, max UDMA/133
[    1.363555] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32=
), AA
[    1.363559] ata3.00: NCQ Send/Recv Log not supported
[    1.363560] ata3.00: ATA-9: ST2000VN004-2E4164, SC60, max UDMA/133
[    1.363561] ata3.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32=
), AA
[    1.363590] ata1.00: NCQ Send/Recv Log not supported
[    1.363591] ata1.00: ATA-9: ST2000VN004-2E4164, SC60, max UDMA/133
[    1.363592] ata1.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32=
), AA
[    1.364510] ata6.00: NCQ Send/Recv Log not supported
[    1.364511] ata6.00: ATA-9: ST2000VN004-2E4164, SC60, max UDMA/133
[    1.364512] ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32=
), AA
[    1.364536] ata9.00: NCQ Send/Recv Log not supported
[    1.364537] ata9.00: ATA-9: ST2000VN004-2E4164, SC60, max UDMA/133
[    1.364537] ata9.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 32=
), AA
[    1.364864] ata2.00: NCQ Send/Recv Log not supported
[    1.364865] ata2.00: configured for UDMA/133
[    1.364875] ata4.00: NCQ Send/Recv Log not supported
[    1.364877] ata4.00: configured for UDMA/133
[    1.364881] ata10.00: NCQ Send/Recv Log not supported
[    1.364883] ata10.00: configured for UDMA/133
[    1.364911] ata3.00: NCQ Send/Recv Log not supported
[    1.364912] ata3.00: configured for UDMA/133
[    1.364916] ata5.00: NCQ Send/Recv Log not supported
[    1.364917] ata5.00: configured for UDMA/133
[    1.364923] ata1.00: NCQ Send/Recv Log not supported
[    1.364924] ata1.00: configured for UDMA/133
[    1.364999] scsi 0:0:0:0: Direct-Access     ATA      ST2000VN004-2E41 =
SC60 PQ: 0 ANSI: 5
[    1.365075] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.365084] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[    1.365085] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.365089] sd 0:0:0:0: [sda] Write Protect is off
[    1.365089] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.365096] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.365136] scsi 1:0:0:0: Direct-Access     ATA      ST2000VN004-2E41 =
SC60 PQ: 0 ANSI: 5
[    1.365193] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.365203] sd 1:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[    1.365203] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    1.365207] sd 1:0:0:0: [sdb] Write Protect is off
[    1.365208] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.365215] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.365264] scsi 2:0:0:0: Direct-Access     ATA      ST2000VN004-2E41 =
SC60 PQ: 0 ANSI: 5
[    1.365319] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    1.365335] sd 2:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[    1.365336] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    1.365340] sd 2:0:0:0: [sdc] Write Protect is off
[    1.365341] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.365350] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.365408] scsi 3:0:0:0: Direct-Access     ATA      ST2000VN004-2E41 =
SC60 PQ: 0 ANSI: 5
[    1.365473] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    1.365480] sd 3:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[    1.365481] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    1.365484] sd 3:0:0:0: [sdd] Write Protect is off
[    1.365484] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.365490] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.365538] scsi 4:0:0:0: Direct-Access     ATA      ST2000VN004-2E41 =
SC60 PQ: 0 ANSI: 5
[    1.365593] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    1.365602] sd 4:0:0:0: [sde] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[    1.365602] sd 4:0:0:0: [sde] 4096-byte physical blocks
[    1.365605] sd 4:0:0:0: [sde] Write Protect is off
[    1.365606] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    1.365610] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.365854] ata6.00: NCQ Send/Recv Log not supported
[    1.365856] ata6.00: configured for UDMA/133
[    1.365893] ata9.00: NCQ Send/Recv Log not supported
[    1.365895] ata9.00: configured for UDMA/133
[    1.365929] scsi 5:0:0:0: Direct-Access     ATA      ST2000VN004-2E41 =
SC60 PQ: 0 ANSI: 5
[    1.366004] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    1.366012] sd 5:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[    1.366013] sd 5:0:0:0: [sdf] 4096-byte physical blocks
[    1.366017] sd 5:0:0:0: [sdf] Write Protect is off
[    1.366018] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    1.366023] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.366080] scsi 8:0:0:0: Direct-Access     ATA      ST2000VN004-2E41 =
SC60 PQ: 0 ANSI: 5
[    1.366148] sd 8:0:0:0: Attached scsi generic sg6 type 0
[    1.366150] sd 8:0:0:0: [sdg] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[    1.366150] sd 8:0:0:0: [sdg] 4096-byte physical blocks
[    1.366153] sd 8:0:0:0: [sdg] Write Protect is off
[    1.366154] sd 8:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    1.366159] sd 8:0:0:0: [sdg] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.366205] scsi 9:0:0:0: Direct-Access     ATA      ST2000VN004-2E41 =
SC60 PQ: 0 ANSI: 5
[    1.366260] sd 9:0:0:0: Attached scsi generic sg7 type 0
[    1.366272] sd 9:0:0:0: [sdh] 3907029168 512-byte logical blocks: (2.0=
0 TB/1.82 TiB)
[    1.366273] sd 9:0:0:0: [sdh] 4096-byte physical blocks
[    1.366277] sd 9:0:0:0: [sdh] Write Protect is off
[    1.366278] sd 9:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    1.366283] sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enable=
d, doesn't support DPO or FUA
[    1.397318] sd 5:0:0:0: [sdf] Attached SCSI disk
[    1.397701] sd 9:0:0:0: [sdh] Attached SCSI disk
[    1.406330] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.421914] sd 3:0:0:0: [sdd] Attached SCSI disk
[    1.421973] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.429605] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.431393] sd 4:0:0:0: [sde] Attached SCSI disk
[    1.434254] sd 8:0:0:0: [sdg] Attached SCSI disk
[    1.436062] Freeing unused decrypted memory: 2036K
[    1.436445] Freeing unused kernel image (initmem) memory: 3000K
[    1.443441] Write protecting the kernel read-only data: 24576k
[    1.443913] Freeing unused kernel image (text/rodata gap) memory: 2036=
K
[    1.444105] Freeing unused kernel image (rodata/data gap) memory: 784K=

[    1.444109] rodata_test: all tests were successful
[    1.444114] Run /init as init process
[    1.444115]   with arguments:
[    1.444115]     /init
[    1.444115]     placeholder
[    1.444116]     rhgb
[    1.444116]   with environment:
[    1.444117]     HOME=3D/
[    1.444117]     TERM=3Dlinux
[    1.444118]     BOOT_IMAGE=3D/vmlinuz-5.10.28-2.fc32.qubes.x86_64
[    1.449446] systemd[1]: systemd v245.9-1.fc32 running in system mode. =
(+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETU=
P +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -ID=
N +PCRE2 default-hierarchy=3Dunified)
[    1.461469] systemd[1]: Detected architecture x86-64.
[    1.461471] systemd[1]: Running in initial RAM disk.
[    1.461479] systemd[1]: Set hostname to <dom0>.
[    1.490262] systemd[1]: Created slice system-systemd\x2dcryptsetup.sli=
ce.
[    1.490293] systemd[1]: Reached target Local File Systems.
[    1.490301] systemd[1]: Reached target Slices.
[    1.490307] systemd[1]: Reached target Swap.
[    1.490313] systemd[1]: Reached target Timers.
[    1.490372] systemd[1]: Listening on Journal Audit Socket.
[    1.490409] systemd[1]: Listening on Journal Socket (/dev/log).
[    1.490446] systemd[1]: Listening on Journal Socket.
[    1.490480] systemd[1]: Listening on udev Control Socket.
[    1.490501] systemd[1]: Listening on udev Kernel Socket.
[    1.490507] systemd[1]: Reached target Sockets.
[    1.490857] systemd[1]: Starting Create list of static device nodes fo=
r the current kernel...
[    1.491701] systemd[1]: Starting Journal Service...
[    1.492099] systemd[1]: Starting Load Kernel Modules...
[    1.492486] systemd[1]: Starting Setup Virtual Console...
[    1.492721] systemd[1]: Finished Create list of static device nodes fo=
r the current kernel.
[    1.493188] systemd[1]: Starting Create Static Device Nodes in /dev...=

[    1.495976] systemd[1]: Finished Create Static Device Nodes in /dev.
[    1.534297] systemd[1]: Started Journal Service.
[    1.534347] audit: type=3D1130 audit(1618390813.139:2): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dsystemd-journald comm=3D=
"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=
=3D? res=3Dsuccess'
[    1.538273] audit: type=3D1130 audit(1618390813.143:3): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dsystemd-tmpfiles-setup=
 comm=3D"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? =
terminal=3D? res=3Dsuccess'
[    1.567596] audit: type=3D1130 audit(1618390813.173:4): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dsystemd-vconsole-setup=
 comm=3D"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? =
terminal=3D? res=3Dsuccess'
[    1.667827] audit: type=3D1130 audit(1618390813.273:5): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Ddracut-cmdline comm=3D=
"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=
=3D? res=3Dsuccess'
[    1.681238] audit: type=3D1130 audit(1618390813.286:6): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Ddracut-pre-udev comm=3D=
"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=
=3D? res=3Dsuccess'
[    1.681421] audit: type=3D1334 audit(1618390813.286:7): prog-id=3D6 op=
=3DLOAD
[    1.681467] audit: type=3D1334 audit(1618390813.287:8): prog-id=3D7 op=
=3DLOAD
[    1.698516] audit: type=3D1130 audit(1618390813.304:9): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dsystemd-udevd comm=3D"=
systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D=
? res=3Dsuccess'
[    1.726931] audit: type=3D1130 audit(1618390813.332:10): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dsystemd-modules-load c=
omm=3D"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? te=
rminal=3D? res=3Dsuccess'
[    1.810627] nvme nvme0: pci function 0000:01:00.0
[    1.810689] nvme nvme1: pci function 0000:23:00.0
[    1.817886] nvme nvme0: missing or invalid SUBNQN field.
[    1.817940] nvme nvme0: Shutdown timeout set to 8 seconds
[    1.818694] xhci_hcd 0000:2a:00.1: xHCI Host Controller
[    1.818729] xhci_hcd 0000:2a:00.1: new USB bus registered, assigned bu=
s number 1
[    1.818889] xhci_hcd 0000:2a:00.1: hcc params 0x0278ffe5 hci version 0=
x110 quirks 0x0000000000000410
[    1.818946] nvme nvme1: missing or invalid SUBNQN field.
[    1.818961] nvme nvme1: Shutdown timeout set to 8 seconds
[    1.819361] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002, bcdDevice=3D 5.10
[    1.819362] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.819363] usb usb1: Product: xHCI Host Controller
[    1.819364] usb usb1: Manufacturer: Linux 5.10.28-2.fc32.qubes.x86_64 =
xhci-hcd
[    1.819365] usb usb1: SerialNumber: 0000:2a:00.1
[    1.819445] hub 1-0:1.0: USB hub found
[    1.819456] hub 1-0:1.0: 6 ports detected
[    1.819700] xhci_hcd 0000:2a:00.1: xHCI Host Controller
[    1.819739] xhci_hcd 0000:2a:00.1: new USB bus registered, assigned bu=
s number 2
[    1.819740] xhci_hcd 0000:2a:00.1: Host supports USB 3.1 Enhanced Supe=
rSpeed
[    1.819751] usb usb2: We don't know the algorithms for LPM for this ho=
st, disabling LPM.
[    1.819769] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003, bcdDevice=3D 5.10
[    1.819771] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.819772] usb usb2: Product: xHCI Host Controller
[    1.819773] usb usb2: Manufacturer: Linux 5.10.28-2.fc32.qubes.x86_64 =
xhci-hcd
[    1.819773] usb usb2: SerialNumber: 0000:2a:00.1
[    1.819883] hub 2-0:1.0: USB hub found
[    1.819893] hub 2-0:1.0: 4 ports detected
[    1.820210] xhci_hcd 0000:2a:00.3: xHCI Host Controller
[    1.820249] xhci_hcd 0000:2a:00.3: new USB bus registered, assigned bu=
s number 3
[    1.820399] xhci_hcd 0000:2a:00.3: hcc params 0x0278ffe5 hci version 0=
x110 quirks 0x0000000000000410
[    1.820735] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002, bcdDevice=3D 5.10
[    1.820736] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.820737] usb usb3: Product: xHCI Host Controller
[    1.820737] usb usb3: Manufacturer: Linux 5.10.28-2.fc32.qubes.x86_64 =
xhci-hcd
[    1.820738] usb usb3: SerialNumber: 0000:2a:00.3
[    1.820795] hub 3-0:1.0: USB hub found
[    1.820808] hub 3-0:1.0: 6 ports detected
[    1.821010] xhci_hcd 0000:2a:00.3: xHCI Host Controller
[    1.821036] xhci_hcd 0000:2a:00.3: new USB bus registered, assigned bu=
s number 4
[    1.821037] xhci_hcd 0000:2a:00.3: Host supports USB 3.1 Enhanced Supe=
rSpeed
[    1.821054] usb usb4: We don't know the algorithms for LPM for this ho=
st, disabling LPM.
[    1.821066] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003, bcdDevice=3D 5.10
[    1.821067] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.821067] usb usb4: Product: xHCI Host Controller
[    1.821068] usb usb4: Manufacturer: Linux 5.10.28-2.fc32.qubes.x86_64 =
xhci-hcd
[    1.821068] usb usb4: SerialNumber: 0000:2a:00.3
[    1.821177] hub 4-0:1.0: USB hub found
[    1.821190] hub 4-0:1.0: 4 ports detected
[    1.821245] usb: port power management may be unreliable
[    1.821376] xhci_hcd 0000:2f:00.3: xHCI Host Controller
[    1.821408] xhci_hcd 0000:2f:00.3: new USB bus registered, assigned bu=
s number 5
[    1.821517] xhci_hcd 0000:2f:00.3: hcc params 0x0278ffe5 hci version 0=
x110 quirks 0x0000000000000410
[    1.821818] usb usb5: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002, bcdDevice=3D 5.10
[    1.821819] usb usb5: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.821820] usb usb5: Product: xHCI Host Controller
[    1.821820] usb usb5: Manufacturer: Linux 5.10.28-2.fc32.qubes.x86_64 =
xhci-hcd
[    1.821821] usb usb5: SerialNumber: 0000:2f:00.3
[    1.821879] hub 5-0:1.0: USB hub found
[    1.821885] hub 5-0:1.0: 4 ports detected
[    1.822026] xhci_hcd 0000:2f:00.3: xHCI Host Controller
[    1.822043] xhci_hcd 0000:2f:00.3: new USB bus registered, assigned bu=
s number 6
[    1.822045] xhci_hcd 0000:2f:00.3: Host supports USB 3.1 Enhanced Supe=
rSpeed
[    1.822054] usb usb6: We don't know the algorithms for LPM for this ho=
st, disabling LPM.
[    1.822065] usb usb6: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003, bcdDevice=3D 5.10
[    1.822066] usb usb6: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    1.822067] usb usb6: Product: xHCI Host Controller
[    1.822067] usb usb6: Manufacturer: Linux 5.10.28-2.fc32.qubes.x86_64 =
xhci-hcd
[    1.822068] usb usb6: SerialNumber: 0000:2f:00.3
[    1.822109] hub 6-0:1.0: USB hub found
[    1.822114] hub 6-0:1.0: 4 ports detected
[    1.824062] ccp 0000:2f:00.1: ccp: unable to access the device: you mi=
ght be running a broken BIOS.
[    1.828409] ast 0000:29:00.0: [drm] Using P2A bridge for configuration=

[    1.828413] ast 0000:29:00.0: [drm] AST 2500 detected
[    1.828422] ast 0000:29:00.0: [drm] Analog VGA only
[    1.828430] ast 0000:29:00.0: [drm] dram MCLK=3D800 Mhz type=3D7 bus_w=
idth=3D16
[    1.828476] [TTM] Zone  kernel: Available graphics memory: 32922854 Ki=
B
[    1.828477] [TTM] Zone   dma32: Available graphics memory: 2097152 KiB=

[    1.828477] [TTM] Initializing pool allocator
[    1.828480] [TTM] Initializing DMA pool allocator
[    1.828826] [drm] Initialized ast 0.1.0 20120228 for 0000:29:00.0 on m=
inor 0
[    1.835464] fbcon: astdrmfb (fb0) is primary device
[    1.886659] nvme nvme0: 32/0/0 default/read/poll queues
[    1.905925]  nvme0n1: p1 p2
[    2.008779] nvme nvme1: 32/0/0 default/read/poll queues
[    2.027715] tsc: Refined TSC clocksource calibration: 3799.204 MHz
[    2.027725] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x6=
d86cf33486, max_idle_ns: 881590412336 ns
[    2.032344] clocksource: Switched to clocksource tsc
[    2.033474] Console: switching to colour frame buffer device 128x48
[    2.035113] ast 0000:29:00.0: [drm] fb0: astdrmfb frame buffer device
[    2.035234]  nvme1n1: p1 p2
[    2.080711] md/raid1:md127: active with 2 out of 2 mirrors
[    2.080918] md/raid1:md126: active with 2 out of 2 mirrors
[    2.082739] md127: detected capacity change from 0 to 248849104896
[    2.084572] md126: detected capacity change from 0 to 1071644672
[    2.204484] usb 4-1: new SuperSpeed Gen 1 USB device number 2 using xh=
ci_hcd
[    2.216990] usb 4-1: New USB device found, idVendor=3D152d, idProduct=3D=
0567, bcdDevice=3D 2.05
[    2.216992] usb 4-1: New USB device strings: Mfr=3D10, Product=3D11, S=
erialNumber=3D5
[    2.216992] usb 4-1: Product: USB to ATA/ATAPI Bridge
[    2.216993] usb 4-1: Manufacturer: JMicron
[    2.216994] usb 4-1: SerialNumber: 152D00539000
[    2.219724] usb-storage 4-1:1.0: USB Mass Storage device detected
[    2.219800] usb-storage 4-1:1.0: Quirks match for vid 152d pid 0567: 5=
000000
[    2.219817] scsi host10: usb-storage 4-1:1.0
[    2.219862] usbcore: registered new interface driver usb-storage
[    2.220838] usbcore: registered new interface driver uas
[    2.330444] usb 3-5: new high-speed USB device number 2 using xhci_hcd=

[    2.465919] usb 3-5: New USB device found, idVendor=3D046b, idProduct=3D=
ff01, bcdDevice=3D 1.00
[    2.465921] usb 3-5: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D3
[    2.465922] usb 3-5: Product: Virtual Hub
[    2.465923] usb 3-5: Manufacturer: American Megatrends Inc.
[    2.465923] usb 3-5: SerialNumber: serial
[    2.526069] hub 3-5:1.0: USB hub found
[    2.526415] hub 3-5:1.0: 5 ports detected
[    2.811458] usb 3-5.1: new high-speed USB device number 3 using xhci_h=
cd
[    2.900377] usb 3-5.1: New USB device found, idVendor=3D046b, idProduc=
t=3Dff20, bcdDevice=3D 1.00
[    2.900379] usb 3-5.1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[    2.900380] usb 3-5.1: Product: Virtual Cdrom Device
[    2.900381] usb 3-5.1: Manufacturer: American Megatrends Inc.
[    2.900382] usb 3-5.1: SerialNumber: AAAABBBBCCCC1
[    2.901496] usb-storage 3-5.1:1.0: USB Mass Storage device detected
[    2.901628] scsi host11: usb-storage 3-5.1:1.0
[    2.975880] usb 3-5.3: new high-speed USB device number 4 using xhci_h=
cd
[    3.068399] usb 3-5.3: New USB device found, idVendor=3D046b, idProduc=
t=3Dffb0, bcdDevice=3D 1.00
[    3.068402] usb 3-5.3: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[    3.068403] usb 3-5.3: Product: Virtual Ethernet
[    3.068403] usb 3-5.3: Manufacturer: American Megatrends Inc.
[    3.068404] usb 3-5.3: SerialNumber: 1234567890
[    3.178445] usb 3-5.4: new low-speed USB device number 5 using xhci_hc=
d
[    3.228009] scsi 10:0:0:0: Direct-Access     ST2000DM 006-2DM164      =
 0125 PQ: 0 ANSI: 6
[    3.228233] scsi 10:0:0:1: Direct-Access     ST2000DM 006-2DM164      =
 0125 PQ: 0 ANSI: 6
[    3.228418] scsi 10:0:0:2: Direct-Access     ST2000DM 006-2DM164      =
 0125 PQ: 0 ANSI: 6
[    3.228611] scsi 10:0:0:3: Direct-Access     ST2000DM 006-2DM164      =
 0125 PQ: 0 ANSI: 6
[    3.228785] scsi 10:0:0:4: Direct-Access     ST2000DM 006-2DM164      =
 0125 PQ: 0 ANSI: 6
[    3.228949] scsi 10:0:0:5: Direct-Access     WDC WD20 EZRX-00D8PB0    =
 0125 PQ: 0 ANSI: 6
[    3.229111] scsi 10:0:0:6: Direct-Access     TOSHIBA  MG08ACA16TE     =
 0125 PQ: 0 ANSI: 6
[    3.229273] scsi 10:0:0:7: Direct-Access     ST16000N M001G-2KK103    =
 0125 PQ: 0 ANSI: 6
[    3.229384] sd 10:0:0:0: Attached scsi generic sg8 type 0
[    3.229447] sd 10:0:0:1: Attached scsi generic sg9 type 0
[    3.229533] sd 10:0:0:2: Attached scsi generic sg10 type 0
[    3.229547] sd 10:0:0:0: [sdi] 3907029168 512-byte logical blocks: (2.=
00 TB/1.82 TiB)
[    3.229607] sd 10:0:0:3: Attached scsi generic sg11 type 0
[    3.229675] sd 10:0:0:4: Attached scsi generic sg12 type 0
[    3.229738] sd 10:0:0:1: [sdj] 3907029168 512-byte logical blocks: (2.=
00 TB/1.82 TiB)
[    3.229758] sd 10:0:0:5: Attached scsi generic sg13 type 0
[    3.229857] sd 10:0:0:6: Attached scsi generic sg14 type 0
[    3.229956] sd 10:0:0:7: Attached scsi generic sg15 type 0
[    3.230077] sd 10:0:0:1: [sdj] Write Protect is off
[    3.230079] sd 10:0:0:1: [sdj] Mode Sense: 67 00 10 08
[    3.230586] sd 10:0:0:2: [sdk] 3907029168 512-byte logical blocks: (2.=
00 TB/1.82 TiB)
[    3.231209] sd 10:0:0:0: [sdi] Write Protect is off
[    3.231211] sd 10:0:0:0: [sdi] Mode Sense: 67 00 10 08
[    3.231369] sd 10:0:0:1: [sdj] No Caching mode page found
[    3.231371] sd 10:0:0:1: [sdj] Assuming drive cache: write through
[    3.231505] sd 10:0:0:0: [sdi] No Caching mode page found
[    3.231507] sd 10:0:0:0: [sdi] Assuming drive cache: write through
[    3.231643] sd 10:0:0:2: [sdk] Write Protect is off
[    3.231645] sd 10:0:0:2: [sdk] Mode Sense: 67 00 10 08
[    3.231780] sd 10:0:0:2: [sdk] No Caching mode page found
[    3.231781] sd 10:0:0:2: [sdk] Assuming drive cache: write through
[    3.231981] sd 10:0:0:3: [sdl] 3907029168 512-byte logical blocks: (2.=
00 TB/1.82 TiB)
[    3.232116] sd 10:0:0:3: [sdl] Write Protect is off
[    3.232117] sd 10:0:0:3: [sdl] Mode Sense: 67 00 10 08
[    3.232252] sd 10:0:0:3: [sdl] No Caching mode page found
[    3.232253] sd 10:0:0:3: [sdl] Assuming drive cache: write through
[    3.232455] sd 10:0:0:4: [sdm] 3907029168 512-byte logical blocks: (2.=
00 TB/1.82 TiB)
[    3.232587] sd 10:0:0:4: [sdm] Write Protect is off
[    3.232588] sd 10:0:0:4: [sdm] Mode Sense: 67 00 10 08
[    3.233327] sd 10:0:0:4: [sdm] No Caching mode page found
[    3.233328] sd 10:0:0:4: [sdm] Assuming drive cache: write through
[    3.233512] sd 10:0:0:5: [sdn] 3907029168 512-byte logical blocks: (2.=
00 TB/1.82 TiB)
[    3.233710] sd 10:0:0:6: [sdo] Very big device. Trying to use READ CAP=
ACITY(16).
[    3.233843] sd 10:0:0:5: [sdn] Write Protect is off
[    3.233845] sd 10:0:0:5: [sdn] Mode Sense: 67 00 10 08
[    3.234039] sd 10:0:0:7: [sdp] Very big device. Trying to use READ CAP=
ACITY(16).
[    3.234157] sd 10:0:0:6: [sdo] 31251759104 512-byte logical blocks: (1=
6.0 TB/14.6 TiB)
[    3.234158] sd 10:0:0:6: [sdo] 4096-byte physical blocks
[    3.234283] sd 10:0:0:5: [sdn] No Caching mode page found
[    3.234285] sd 10:0:0:5: [sdn] Assuming drive cache: write through
[    3.234402] sd 10:0:0:7: [sdp] 31251759104 512-byte logical blocks: (1=
6.0 TB/14.6 TiB)
[    3.234403] sd 10:0:0:7: [sdp] 4096-byte physical blocks
[    3.234529] sd 10:0:0:6: [sdo] Write Protect is off
[    3.234531] sd 10:0:0:6: [sdo] Mode Sense: 67 00 10 08
[    3.234658] sd 10:0:0:7: [sdp] Write Protect is off
[    3.234658] sd 10:0:0:7: [sdp] Mode Sense: 67 00 10 08
[    3.234786] sd 10:0:0:6: [sdo] No Caching mode page found
[    3.234787] sd 10:0:0:6: [sdo] Assuming drive cache: write through
[    3.234911] sd 10:0:0:7: [sdp] No Caching mode page found
[    3.234911] sd 10:0:0:7: [sdp] Assuming drive cache: write through
[    3.240884]  sdi:
[    3.241213]  sdk:
[    3.241741] sd 10:0:0:0: [sdi] Attached SCSI disk
[    3.242130] sd 10:0:0:2: [sdk] Attached SCSI disk
[    3.242876]  sdj:
[    3.243212]  sdm:
[    3.243825] sd 10:0:0:4: [sdm] Attached SCSI disk
[    3.244279] sd 10:0:0:1: [sdj] Attached SCSI disk
[    3.296301] usb 3-5.4: New USB device found, idVendor=3D046b, idProduc=
t=3Dff10, bcdDevice=3D 1.00
[    3.296303] usb 3-5.4: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[    3.296304] usb 3-5.4: Product: Virtual Keyboard and Mouse
[    3.296305] usb 3-5.4: Manufacturer: American Megatrends Inc.
[    3.402944] input: American Megatrends Inc. Virtual Keyboard and Mouse=
 as /devices/pci0000:00/0000:00:01.2/0000:20:00.0/0000:21:08.0/0000:2a:00=
=2E3/usb3/3-5/3-5.4/3-5.4:1.0/0003:046B:FF10.0001/input/input2
[    3.403063] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1=
=2E10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on u=
sb-0000:2a:00.3-5.4/input0
[    3.419064] input: American Megatrends Inc. Virtual Keyboard and Mouse=
 as /devices/pci0000:00/0000:00:01.2/0000:20:00.0/0000:21:08.0/0000:2a:00=
=2E3/usb3/3-5/3-5.4/3-5.4:1.1/0003:046B:FF10.0002/input/input3
[    3.419185] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1=
=2E10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-=
0000:2a:00.3-5.4/input1
[    3.438623]  sdl:
[    3.439358] sd 10:0:0:3: [sdl] Attached SCSI disk
[    3.445796]  sdn:
[    3.693642] sd 10:0:0:5: [sdn] Attached SCSI disk
[    3.696230] sd 10:0:0:7: [sdp] Attached SCSI disk
[    3.715966] sd 10:0:0:6: [sdo] Attached SCSI disk
[    3.942686] scsi 11:0:0:0: CD-ROM            AMI      Virtual CDROM0  =
 1.00 PQ: 0 ANSI: 0 CCS
[    3.953071] sr 11:0:0:0: [sr0] scsi-1 drive
[    3.953072] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.961847] sr 11:0:0:0: Attached scsi CD-ROM sr0
[    3.961911] sr 11:0:0:0: Attached scsi generic sg16 type 5
[    9.691934] kauditd_printk_skb: 15 callbacks suppressed
[    9.691935] audit: type=3D1130 audit(1618390821.298:26): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dsystemd-cryptsetup@luk=
s\x2dda45b295\x2d82dd\x2d4e41\x2d8203\x2dd54b63bc70a5 comm=3D"systemd" ex=
e=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=3D? res=3Ds=
uccess'
[   10.801723] audit: type=3D1130 audit(1618390822.408:27): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Ddracut-initqueue comm=3D=
"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=
=3D? res=3Dsuccess'
[   10.807959] audit: type=3D1130 audit(1618390822.414:28): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Ddracut-pre-mount comm=3D=
"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? terminal=
=3D? res=3Dsuccess'
[   10.825680] audit: type=3D1130 audit(1618390822.432:29): pid=3D1 uid=3D=
0 auid=3D4294967295 ses=3D4294967295 msg=3D'unit=3Dsystemd-fsck-root comm=
=3D"systemd" exe=3D"/usr/lib/systemd/systemd" hostname=3D? addr=3D? termi=
nal=3D? res=3Dsuccess'
[   10.830028] EXT4-fs (dm-4): mounted filesystem with ordered data mode.=
 Opts: (null)
[   10.843684] audit: type=3D1334 audit(1618390822.450:30): prog-id=3D10 =
op=3DUNLOAD
[   10.843686] audit: type=3D1334 audit(1618390822.450:31): prog-id=3D9 o=
p=3DUNLOAD
[   10.843687] audit: type=3D1334 audit(1618390822.450:32): prog-id=3D8 o=
p=3DUNLOAD
[   10.845026] audit: type=3D1334 audit(1618390822.451:33): prog-id=3D12 =
op=3DUNLOAD
[   10.845153] audit: type=3D1334 audit(1618390822.451:34): prog-id=3D11 =
op=3DUNLOAD
[   10.922369] audit: type=3D1334 audit(1618390822.528:35): prog-id=3D13 =
op=3DLOAD
[   11.074572] systemd-journald[378]: Received SIGTERM from PID 1 (system=
d).
[   11.140204] systemd[1]: systemd v245.9-1.fc32 running in system mode. =
(+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETU=
P +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -ID=
N +PCRE2 default-hierarchy=3Dunified)
[   11.151537] systemd[1]: Detected architecture x86-64.
[   11.152020] systemd[1]: Set hostname to <dom0>.
[   11.299559] systemd[1]: initrd-switch-root.service: Succeeded.
[   11.299628] systemd[1]: Stopped Switch Root.
[   11.299783] systemd[1]: systemd-journald.service: Scheduled restart jo=
b, restart counter is at 1.
[   11.299890] systemd[1]: Created slice system-getty.slice.
[   11.300111] systemd[1]: Created slice system-modprobe.slice.
[   11.300432] systemd[1]: Created slice system-qubes\x2dvm.slice.
[   11.300538] systemd[1]: Created slice system-systemd\x2dfsck.slice.
[   11.300836] systemd[1]: Created slice User and Session Slice.
[   11.305928] systemd[1]: Condition check resulted in Dispatch Password =
Requests to Console Directory Watch being skipped.
[   11.305978] systemd[1]: Started Forward Password Requests to Wall Dire=
ctory Watch.
[   11.306122] systemd[1]: Set up automount Arbitrary Executable File For=
mats File System Automount Point.
[   11.308878] systemd[1]: Reached target Block Device Preparation for /d=
ev/mapper/luks-da45b295-82dd-4e41-8203-d54b63bc70a5.
[   11.308954] systemd[1]: Reached target Login Prompts.
[   11.308964] systemd[1]: Stopped target Switch Root.
[   11.308971] systemd[1]: Stopped target Initrd File Systems.
[   11.308977] systemd[1]: Stopped target Initrd Root File System.
[   11.309014] systemd[1]: Reached target Paths.
[   11.309047] systemd[1]: Reached target Remote Encrypted Volumes.
[   11.309080] systemd[1]: Reached target Remote File Systems.
[   11.309112] systemd[1]: Reached target Slices.
[   11.309170] systemd[1]: Listening on Device-mapper event daemon FIFOs.=

[   11.310131] systemd[1]: Listening on Process Core Dump Socket.
[   11.314433] systemd[1]: Listening on initctl Compatibility Named Pipe.=

[   11.314551] systemd[1]: Listening on udev Control Socket.
[   11.318973] systemd[1]: Listening on udev Kernel Socket.
[   11.319152] systemd[1]: Listening on User Database Manager Socket.
[   11.325892] systemd[1]: Activating swap /dev/mapper/qubes_dom0-swap...=

[   11.331893] systemd[1]: Mounting Huge Pages File System...
[   11.337601] systemd[1]: Mounting POSIX Message Queue File System...
[   11.343101] systemd[1]: Condition check resulted in Mount /proc/xen fi=
les being skipped.
[   11.343589] systemd[1]: Mounting Kernel Debug File System...
[   11.348804] systemd[1]: Mounting Kernel Trace File System...
[   11.353691] systemd[1]: Starting Create list of static device nodes fo=
r the current kernel...
[   11.360660] systemd[1]: Starting Monitoring of LVM2 mirrors, snapshots=
 etc. using dmeventd or progress polling...
[   11.363470] systemd[1]: Condition check resulted in Load Kernel Module=
 configfs being skipped.
[   11.363904] systemd[1]: Mounting Kernel Configuration File System...
[   11.369473] systemd[1]: Condition check resulted in Load Kernel Module=
 drm being skipped.
[   11.369953] systemd[1]: Starting Load Kernel Module fuse...
[   11.372086] systemd[1]: plymouth-switch-root.service: Succeeded.
[   11.372159] systemd[1]: Stopped Plymouth switch root service.
[   11.375616] systemd[1]: Condition check resulted in Set Up Additional =
Binary Formats being skipped.
[   11.375639] systemd[1]: Stopped Journal Service.
[   11.377935] systemd[1]: Starting Journal Service...
[   11.379746] systemd[1]: Starting Load Kernel Modules...
[   11.379932] fuse: init (API version 7.32)
[   11.380479] systemd[1]: Starting Remount Root and Kernel File Systems.=
=2E.
[   11.381020] systemd[1]: Starting Repartition Root Disk...
[   11.381561] systemd[1]: Starting udev Coldplug all Devices...
[   11.382331] systemd[1]: sysroot.mount: Succeeded.
[   11.382559] systemd[1]: Mounted Huge Pages File System.
[   11.382642] systemd[1]: Mounted POSIX Message Queue File System.
[   11.383072] systemd[1]: Mounted Kernel Debug File System.
[   11.383432] systemd[1]: Mounted Kernel Trace File System.
[   11.383593] systemd[1]: Finished Create list of static device nodes fo=
r the current kernel.
[   11.383902] systemd[1]: Mounted Kernel Configuration File System.
[   11.384263] systemd[1]: modprobe@fuse.service: Succeeded.
[   11.384332] systemd[1]: Finished Load Kernel Module fuse.
[   11.385070] systemd[1]: Mounting FUSE Control File System...
[   11.386480] systemd[1]: Mounted FUSE Control File System.
[   11.386749] systemd[1]: Finished Repartition Root Disk.
[   11.401351] systemd[1]: Started Journal Service.
[   11.423456] Adding 4136956k swap on /dev/mapper/qubes_dom0-swap.  Prio=
rity:-2 extents:1 across:4136956k SSFS
[   11.428380] EXT4-fs (dm-4): re-mounted. Opts: discard
[   11.454163] systemd-journald[1246]: Received client request to flush r=
untime journal.
[   11.576645] acpi_cpufreq: overriding BIOS provided _PSD data
[   11.605660] IPMI message handler: version 39.2
[   11.606988] ipmi device interface
[   11.609258] ipmi_si: IPMI System Interface driver
[   11.610050] ipmi_si IPI0001:00: ipmi_platform: probing via ACPI
[   11.610242] dca service started, version 1.12.1
[   11.611196] ipmi_si IPI0001:00: ipmi_platform: [io  0x0ca2] regsize 1 =
spacing 1 irq 0
[   11.613837] ipmi_si: Adding ACPI-specified kcs state machine
[   11.613888] ipmi_si: Trying ACPI-specified kcs state machine at i/o ad=
dress 0xca2, slave address 0x0, irq 0
[   11.616252] igb: Intel(R) Gigabit Ethernet Network Driver
[   11.616253] igb: Copyright (c) 2007-2014 Intel Corporation.
[   11.654309] pps pps0: new PPS source ptp0
[   11.654336] igb 0000:26:00.0: added PHC on eth0
[   11.654337] igb 0000:26:00.0: Intel(R) Gigabit Ethernet Network Connec=
tion
[   11.654338] igb 0000:26:00.0: eth0: (PCIe:2.5Gb/s:Width x1) d0:50:99:d=
f:7a:ed
[   11.654679] igb 0000:26:00.0: eth0: PBA No: 001300-000
[   11.654680] igb 0000:26:00.0: Using MSI-X interrupts. 4 rx queue(s), 4=
 tx queue(s)
[   11.655542] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver
[   11.655544] ixgbe: Copyright (c) 1999-2016 Intel Corporation.
[   11.668961] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, =
revision 0
[   11.668963] piix4_smbus 0000:00:14.0: Using register 0x02 for SMBus po=
rt selection
[   11.669032] piix4_smbus 0000:00:14.0: Auxiliary SMBus Host Controller =
at 0xb20
[   11.670402] megasas: 07.714.04.00-rc1
[   11.670407] input: PC Speaker as /devices/platform/pcspkr/input/input4=

[   11.671020] sp5100_tco: SP5100/SB800 TCO WatchDog Timer Driver
[   11.671081] sp5100-tco sp5100-tco: Using 0xfeb00000 for watchdog MMIO =
address
[   11.671133] sp5100-tco sp5100-tco: initialized. heartbeat=3D60 sec (no=
wayout=3D0)
[   11.671137] megaraid_sas 0000:2d:00.0: BAR:0x1  BAR's base_addr(phys):=
0x00000000fc400000  mapped virt_addr:0x00000000f7dafcd2
[   11.671140] megaraid_sas 0000:2d:00.0: FW now in Ready state
[   11.671141] megaraid_sas 0000:2d:00.0: 63 bit DMA mask and 32 bit cons=
istent mask
[   11.671397] megaraid_sas 0000:2d:00.0: firmware supports msix	: (96)
[   11.672074] megaraid_sas 0000:2d:00.0: requested/available msix 25/25
[   11.672077] megaraid_sas 0000:2d:00.0: current msix/online cpus	: (25/=
24)
[   11.672078] megaraid_sas 0000:2d:00.0: RDPQ mode	: (disabled)
[   11.672081] megaraid_sas 0000:2d:00.0: Current firmware supports maxim=
um commands: 272	 LDIO threshold: 237
[   11.672166] megaraid_sas 0000:2d:00.0: Configured max firmware command=
s: 271
[   11.672520] megaraid_sas 0000:2d:00.0: Performance mode :Latency
[   11.672521] megaraid_sas 0000:2d:00.0: FW supports sync cache	: Yes
[   11.672524] megaraid_sas 0000:2d:00.0: megasas_disable_intr_fusion is =
called outbound_intr_mask:0x40000009
[   11.694502] pps pps1: new PPS source ptp1
[   11.694527] igb 0000:27:00.0: added PHC on eth1
[   11.694528] igb 0000:27:00.0: Intel(R) Gigabit Ethernet Network Connec=
tion
[   11.694530] igb 0000:27:00.0: eth1: (PCIe:2.5Gb/s:Width x1) d0:50:99:d=
f:7a:ec
[   11.694697] igb 0000:27:00.0: eth1: PBA No: 001300-000
[   11.694698] igb 0000:27:00.0: Using MSI-X interrupts. 4 rx queue(s), 4=
 tx queue(s)
[   11.695521] megaraid_sas 0000:2d:00.0: Init cmd return status FAILED f=
or SCSI host 12
[   11.695910] megaraid_sas 0000:2d:00.0: Failed from megasas_init_fw 640=
6
[   11.697033] cdc_ether 3-5.3:2.0 usb0: register 'cdc_ether' at usb-0000=
:2a:00.3-5.3, CDC Ethernet Device, 2e:b3:ba:5f:af:f9
[   11.697055] usbcore: registered new interface driver cdc_ether
[   11.726950] async_tx: api initialized (async)
[   11.728618] RAPL PMU: API unit is 2^-32 Joules, 1 fixed counters, 1638=
40 ms ovfl timer
[   11.728619] RAPL PMU: hw unit of domain package 2^-16 Joules
[   11.754800] md/raid1:md124: active with 2 out of 2 mirrors
[   11.754841] md/raid:md125: device sdg operational as raid disk 2
[   11.754842] md/raid:md125: device sdf operational as raid disk 7
[   11.754842] md/raid:md125: device sdh operational as raid disk 0
[   11.754843] md/raid:md125: device sde operational as raid disk 1
[   11.754843] md/raid:md125: device sdc operational as raid disk 3
[   11.754844] md/raid:md125: device sdd operational as raid disk 5
[   11.754844] md/raid:md125: device sdb operational as raid disk 4
[   11.754845] md/raid:md125: device sda operational as raid disk 6
[   11.755247] md/raid:md125: raid level 6 active with 8 out of 8 devices=
, algorithm 2
[   11.764140] md/raid:md0: device sdm operational as raid disk 2
[   11.764193] md/raid:md0: device sdl operational as raid disk 0
[   11.764201] md/raid:md0: device sdj operational as raid disk 5
[   11.764204] md/raid:md0: device sdn operational as raid disk 1
[   11.764207] md/raid:md0: device sdk operational as raid disk 3
[   11.764212] md/raid:md0: device sdi operational as raid disk 4
[   11.765893] md/raid:md0: raid level 6 active with 6 out of 6 devices, =
algorithm 2
[   11.766217] md124: detected capacity change from 0 to 16000765394944
[   11.768095] md0: detected capacity change from 0 to 8001054310400
[   11.769676]  md0: p1
[   11.772967] kvm: Nested Virtualization enabled
[   11.772973] SVM: kvm: Nested Paging enabled
[   11.772973] SVM: Virtual VMLOAD VMSAVE supported
[   11.772974] SVM: Virtual GIF supported
[   11.780712] md125: detected capacity change from 0 to 12001581465600
[   11.821520] MCE: In-kernel MCE decoding enabled.
[   11.824973] EDAC amd64: F17h_M70h detected (node 0).
[   11.825427] EDAC amd64: Node 0: DRAM ECC disabled.
[   11.832860] igb 0000:26:00.0 enp38s0: renamed from eth0
[   11.874810] igb 0000:27:00.0 enp39s0: renamed from eth1
[   11.901069] cdc_ether 3-5.3:2.0 enp42s0f3u5u3c2: renamed from usb0
[   11.911173] EDAC amd64: F17h_M70h detected (node 0).
[   11.911218] EDAC amd64: Node 0: DRAM ECC disabled.
[   11.925508] snd_hda_intel 0000:2f:00.4: no codecs found!
[   11.977934] EDAC amd64: F17h_M70h detected (node 0).
[   11.977978] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.014888] EDAC amd64: F17h_M70h detected (node 0).
[   12.014931] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.064115] ipmi_si IPI0001:00: IPMI message handler: Found new BMC (m=
an_id: 0x00c1d6, prod_id: 0x0202, dev_id: 0x20)
[   12.090702] EDAC amd64: F17h_M70h detected (node 0).
[   12.090750] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.309094] EDAC amd64: F17h_M70h detected (node 0).
[   12.309143] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.347466] ixgbe 0000:24:00.0: Multiqueue Enabled: Rx Queue count =3D=
 24, Tx Queue count =3D 24 XDP Queue count =3D 0
[   12.371428] EDAC amd64: F17h_M70h detected (node 0).
[   12.371507] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.431929] EDAC amd64: F17h_M70h detected (node 0).
[   12.431975] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.445473] ixgbe 0000:24:00.0: 31.504 Gb/s available PCIe bandwidth (=
8.0 GT/s PCIe x4 link)
[   12.452174] ipmi_si IPI0001:00: IPMI kcs interface initialized
[   12.525892] EDAC amd64: F17h_M70h detected (node 0).
[   12.525950] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.527162] ipmi_ssif: IPMI SSIF Interface driver
[   12.557449] ixgbe 0000:24:00.0: MAC: 4, PHY: 0, PBA No: 000000-000
[   12.557452] ixgbe 0000:24:00.0: d0:50:99:df:7a:ee
[   12.584143] EDAC amd64: F17h_M70h detected (node 0).
[   12.584191] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.660022] EDAC amd64: F17h_M70h detected (node 0).
[   12.660065] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.716480] ixgbe 0000:24:00.0: Intel(R) 10 Gigabit Network Connection=

[   12.716601] libphy: ixgbe-mdio: probed
[   12.729234] EDAC amd64: F17h_M70h detected (node 0).
[   12.729277] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.790149] EDAC amd64: F17h_M70h detected (node 0).
[   12.790196] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.857411] EDAC amd64: F17h_M70h detected (node 0).
[   12.857483] EDAC amd64: Node 0: DRAM ECC disabled.
[   12.921302] EDAC amd64: F17h_M70h detected (node 0).
[   12.921354] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.000300] EDAC amd64: F17h_M70h detected (node 0).
[   13.000352] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.046341] EDAC amd64: F17h_M70h detected (node 0).
[   13.046399] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.110006] EDAC amd64: F17h_M70h detected (node 0).
[   13.110052] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.186885] EDAC amd64: F17h_M70h detected (node 0).
[   13.186934] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.246092] EDAC amd64: F17h_M70h detected (node 0).
[   13.246145] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.310187] EDAC amd64: F17h_M70h detected (node 0).
[   13.310239] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.354916] EDAC amd64: F17h_M70h detected (node 0).
[   13.354960] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.384175] EDAC amd64: F17h_M70h detected (node 0).
[   13.384223] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.403826] ixgbe 0000:24:00.1: Multiqueue Enabled: Rx Queue count =3D=
 24, Tx Queue count =3D 24 XDP Queue count =3D 0
[   13.407970] EDAC amd64: F17h_M70h detected (node 0).
[   13.408012] EDAC amd64: Node 0: DRAM ECC disabled.
[   13.501737] ixgbe 0000:24:00.1: 31.504 Gb/s available PCIe bandwidth (=
8.0 GT/s PCIe x4 link)
[   13.613447] ixgbe 0000:24:00.1: MAC: 4, PHY: 0, PBA No: 000000-000
[   13.613451] ixgbe 0000:24:00.1: d0:50:99:df:7a:ef
[   13.773233] ixgbe 0000:24:00.1: Intel(R) 10 Gigabit Network Connection=

[   13.773311] libphy: ixgbe-mdio: probed
[   13.776618] ixgbe 0000:24:00.1 enp36s0f1: renamed from eth1
[   13.798843] ixgbe 0000:24:00.0 enp36s0f0: renamed from eth0
[   14.939861] kauditd_printk_skb: 71 callbacks suppressed

--------------D7D1E2EA5AAA155C20E7E2BE--

--xIAVcETQIM3JvDO8Fj7OPQ7nypZ0oIdGM--

--Ny48JBqjV9mX4gtAJpCTkVZyG8kelbMU2
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn6ZLkvlecGvyjiymSEAQtc3FduIFAmB2xhoACgkQSEAQtc3F
duIJShAAt/XPltg/vJ+BpMd6CmxzPLHqoxmdq9V8oiRROVEe1MUq2+M3gyFbojhc
zUInI2Gxb3D1KfIDKki6OJx7AbWlBUtvEAV95QUBIh8IJ1GgobNTyJRDTY4w8ddi
CoXD9KSCV//D5umZlpnnVT9QOHsEs7KtbYNRV7RSpPbbpvWxM49vWmCu0By/xRyZ
a3028AM8geI6Vc/R0lVs5f/l8b2z67PoaHOarbS3BX51s5qYcFoFZgDifUIeboQB
kduK7qFM8NYR/uUwt5UGG4ba57devrMvd+i/mIFZXJlDyq81bhMiVAPMrfpg9Qqo
MfQRA+HfrY1+Xhztq96UilFjaJhqzGLpP+yi2JDtCMt8LoRyL0y6YlFJjOyAY+mg
mVpsbrla1UvoCQ+hI7GiBi2ebgeCX6soc2yNiCQC1w0LpoYqXh6uJBj818/2ENFm
2vyYobhajrK70wzRZuVthQzmJkvW5u+Dt8SUFwkF51QyROWnCjfT7yxGCGcug0eB
oNhKluHtuk7pjqbKB/gsaU381RTaLuKswTtwUSnRuduDpd1Y5Wu0aayyKeRMPcL9
gbcjBQWKR69xZyIsE8RaN0zChUSC3Mf71am8SI/eiMmY0Wc7jc0dKRKnOPRO6IeC
ANBKkaTFwu2OXWsRbz+GbXTDx7aMxGA9RcIlaHugM75pClsJykI=
=HvE8
-----END PGP SIGNATURE-----

--Ny48JBqjV9mX4gtAJpCTkVZyG8kelbMU2--
