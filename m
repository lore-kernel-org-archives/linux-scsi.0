Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF479C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5C0E61008
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Apr 2021 06:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbhDIG0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 02:26:09 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21336 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbhDIG0I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 02:26:08 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617949544; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=b6SMojvPRI7XoRZjWcYw3D3LOgARvgnP+3cId00+tZXvfKkzw2uz3mZ3lwiUl6FK0r9aJHrOKpvD/GxonKj22FqWzl/xbiRmP3tUSIM7tiMV82hKQGVS//Oer0zEwykeWai1zjy4rbNIcAWn1OZUvZwZzhYwFWrWXvhxPDEvUpg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1617949544; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=zLwAeaoBZx+JsPOh/lD23y12WMptgg4KhVMAyO6D/9s=; 
        b=MHpIV4cusg/oA9WKiRJShoSd4rMwmScNNK8MaK2Ly+K4MRlAl1A/IymwD7MXe78FXcI3RbAdchQMCVozakHpGEgdWm27lU+So89zvXRrLHAGjao345kMztRJiSJ2We6ZJ/HUYaw7s5vOpfd0mlnulzxfYwPjhwur7DfARosM/CY=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=qubes-os.org;
        spf=pass  smtp.mailfrom=frederic.pierret@qubes-os.org;
        dmarc=pass header.from=<frederic.pierret@qubes-os.org> header.from=<frederic.pierret@qubes-os.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617949544;
        s=s; d=qubes-os.org; i=frederic.pierret@qubes-os.org;
        h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type;
        bh=zLwAeaoBZx+JsPOh/lD23y12WMptgg4KhVMAyO6D/9s=;
        b=UnRLytDDHgas+GEEb8VZxWieRjeLHFkN6VQaz/BfHfFDLgyC5ZCUSIPWOfKb6oNJ
        xbQTYUIDI6xcJZM7eAz035Ys9cOLYejkb6gR4sqOtvqgRENUklAy/0Hz0ZuowSDh4+O
        4OL1TpfG16xsiNBWUWO3lTNrwSiHKUd305vbtM6s=
Received: from [10.137.0.21] (92.188.110.153 [92.188.110.153]) by mx.zohomail.com
        with SMTPS id 1617949542067846.5336179209636; Thu, 8 Apr 2021 23:25:42 -0700 (PDT)
Subject: Re: MegaRaid SAS 9341-8i issue
From:   =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= 
        <frederic.pierret@qubes-os.org>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        linux-scsi@vger.kernel.org
References: <ce228d78-8651-d958-d1e5-2f82cbb8113d@qubes-os.org>
 <c751b535d69b892fee0af8f43cfcce60@mail.gmail.com>
 <12383f2a-9f7b-ea95-ff52-785b91c1bac8@qubes-os.org>
Message-ID: <2ef99260-c5ee-f42d-c06e-e37b22ff443d@qubes-os.org>
Date:   Fri, 9 Apr 2021 08:25:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <12383f2a-9f7b-ea95-ff52-785b91c1bac8@qubes-os.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gXXNPdSzYENCs07UJSk2midAHfCh4YWzN"
X-Zoho-Virus-Status: 1
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gXXNPdSzYENCs07UJSk2midAHfCh4YWzN
Content-Type: multipart/mixed; boundary="GPsHahkmFb3qdWA0RqVSN8gldmDpsJe1k";
 protected-headers="v1"
From: =?UTF-8?B?RnLDqWTDqXJpYyBQaWVycmV0?= <frederic.pierret@qubes-os.org>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>,
 jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
 linux-scsi@vger.kernel.org
Message-ID: <2ef99260-c5ee-f42d-c06e-e37b22ff443d@qubes-os.org>
Subject: Re: MegaRaid SAS 9341-8i issue
References: <ce228d78-8651-d958-d1e5-2f82cbb8113d@qubes-os.org>
 <c751b535d69b892fee0af8f43cfcce60@mail.gmail.com>
 <12383f2a-9f7b-ea95-ff52-785b91c1bac8@qubes-os.org>
In-Reply-To: <12383f2a-9f7b-ea95-ff52-785b91c1bac8@qubes-os.org>

--GPsHahkmFb3qdWA0RqVSN8gldmDpsJe1k
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

Le 3/29/21 =C3=A0 11:02 AM, Fr=C3=A9d=C3=A9ric Pierret a =C3=A9crit=C2=A0=
:
> Hi,
> First of all, thank you very much for your answer.
>=20
> Le 3/29/21 =C3=A0 8:24 AM, Kashyap Desai a =C3=A9crit=C2=A0:
>> Hi -
>>
>> Can you send us full dmesg logs of each working and non-working case. =
?
>=20
> I've attached you the working case of one of the two motherboard, refer=
enced here as ASUS, and the nonworking case on the third motherboard, ref=
erenced here as ASROCK. In both cases, I've attached you the full dmesg o=
f the same LiveUSB a Fedora 33 with also the full dmesg when I do a rmmod=
 and modprobe of megaraid_sas.
>=20
>> On 3rd motherboard was it any working combination of kernel, driver an=
d FW ?
>> OR it never worked on 3rd mother board ?
>=20
> Unfortunately, no combination has worked on the ASROCK (third motherboa=
rd) (before or after firmware upgrade, multiple kernel versions (5.10.X a=
nd 5.11.Y), drivers)
>=20
>> Kashyap
>>
>>> -----Original Message-----
>>> From: Fr=C3=A9d=C3=A9ric Pierret [mailto:frederic.pierret@qubes-os.or=
g]
>>> Sent: Sunday, March 28, 2021 10:26 PM
>>> To: kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
>>> shivasharan.srikanteshwara@broadcom.com; jejb@linux.ibm.com;
>>> martin.petersen@oracle.com
>>> Cc: megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org
>>> Subject: MegaRaid SAS 9341-8i issue
>>>
>>> Hi,
>>>
>>> I'm having issue with a MegaRaid 9341-8i card which is properly worki=
ng on
>>> two motherboards (kernel-5.10.25 and kernel-5.11.10) but not on a thi=
rd
>>> for
>>> which I want it to work. I originally received this card with a firmw=
are
>>> from
>>> 2018 and I've updated it to the latest from Broadcom website
>>> (24.21.0-0148)
>>> but in both cases, I've the same issue on the third motherboard:
>>>
>>> [=C2=A0=C2=A0 14.013135] megaraid_sas 0000:01:00.0: BAR:0x1=C2=A0 BAR=
's
>>> base_addr(phys):0x00000000fe800000=C2=A0 mapped virt_addr:0x(ptrval)
>>> [=C2=A0=C2=A0 14.013142] megaraid_sas 0000:01:00.0: FW now in Ready s=
tate
>>> [=C2=A0=C2=A0 14.013148] megaraid_sas 0000:01:00.0: 63 bit DMA mask a=
nd 32 bit
>>> consistent mask
>>> [=C2=A0=C2=A0 14.013933] megaraid_sas 0000:01:00.0: firmware supports=
 msix=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 :
>>> (96)
>>> [=C2=A0=C2=A0 14.014439] megaraid_sas 0000:01:00.0: requested/availab=
le msix 5/5
>>> [=C2=A0=C2=A0 14.014445] megaraid_sas 0000:01:00.0: current msix/onli=
ne cpus=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 :
>>> (5/4)
>>> [=C2=A0=C2=A0 14.014447] megaraid_sas 0000:01:00.0: RDPQ mode=C2=A0=C2=
=A0=C2=A0=C2=A0 : (disabled)
>>> [=C2=A0=C2=A0 14.014453] megaraid_sas 0000:01:00.0: Current firmware =
supports
>>> maximum commands: 272=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 LDIO =
threshold: 237
>>> [=C2=A0=C2=A0 14.014631] megaraid_sas 0000:01:00.0: Configured max fi=
rmware
>>> commands: 271
>>> [=C2=A0=C2=A0 14.015377] megaraid_sas 0000:01:00.0: Performance mode =
:Latency
>>> [=C2=A0=C2=A0 14.015380] megaraid_sas 0000:01:00.0: FW supports sync =
cache=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 :
>>> Yes
>>> [=C2=A0=C2=A0 14.015388] megaraid_sas 0000:01:00.0: megasas_disable_i=
ntr_fusion is
>>> called outbound_intr_mask:0x40000009
>>> [=C2=A0=C2=A0 14.037098] megaraid_sas 0000:01:00.0: Init cmd return s=
tatus FAILED
>>> for
>>> SCSI host 2
>>> [=C2=A0=C2=A0 14.037762] megaraid_sas 0000:01:00.0: Failed from megas=
as_init_fw 6399
>>>
>>> Trying to rmmod then modprobe leads to something that looks like stuc=
k
>>> state or such:
>>>
>>> [=C2=A0 570.269770] megaraid_sas 0000:01:00.0: BAR:0x1=C2=A0 BAR's
>>> base_addr(phys):0x00000000fe800000=C2=A0 mapped
>>> virt_addr:0x00000000f42ba0e1 [=C2=A0 570.269775] megaraid_sas 0000:01=
:00.0:
>>> Waiting for FW to come to ready state [=C2=A0 570.269780] megaraid_sa=
s
>>> 0000:01:00.0: FW in FAULT state, Fault code:0x10000 subcode:0x0
>>> func:megasas_transition_to_ready [=C2=A0 570.269782] megaraid_sas
>>> 0000:01:00.0: System Register set:
>>> (***)
>>> [=C2=A0 570.269908] megaraid_sas 0000:01:00.0: Failed to transition c=
ontroller
>>> to
>>> ready from megasas_init_fw!
>>> [=C2=A0 570.269919] megaraid_sas 0000:01:00.0: Failed from megasas_in=
it_fw 639
>>>
>>> The motherboard which is not working is a recent one: Asrock X570D4U-=
2L2T
>>> with a Ryzen 3900XT.
>>>
>>> I've read a lot of things on internet saying that might be CSM issues=
 or
>>> such
>>> but no luck with that. On the two working motherboards, it works in
>>> legacy/UEFI only. I've also tested the card on a x16 or x8 slots, the=
 same
>>> result. I've attempted to build megaraid driver provided from Broadco=
m
>>> (07.716.01.00-2). Up to a slight adjustment in a log call using older=

>>> attribute
>>> "host_busy", I'm hitting an unrelated issue due to KBUILD_CFLAGS recu=
rsion
>>> in arch/x86/Makefile.
>>>
>>> After hours and hours of testing, I'm currently out of ideas. Does an=
yone
>>> has
>>> an idea or could help me into adding useful debug info in the driver =
or
>>> such?
>>>
>>> Thank very much in advance,
>>> Fr=C3=A9d=C3=A9ric
>=20
> Best regards,
> Fr=C3=A9d=C3=A9ric

Is there something more I could provide and help into troubleshooting thi=
s issue?

Best regards,
Fr=C3=A9d=C3=A9ric


--GPsHahkmFb3qdWA0RqVSN8gldmDpsJe1k--

--gXXNPdSzYENCs07UJSk2midAHfCh4YWzN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn6ZLkvlecGvyjiymSEAQtc3FduIFAmBv82IACgkQSEAQtc3F
duKWQw/8Ckwcyw5LE5nNm3e3weKkDBoXIkpsvpL4OQchN9Zlo2lx+Wn/pDes36ul
JGsXHhx2xniyynKVqt3UuMU6qXN3oSg6KTcFB4GcCyyFY89G8UZrLmyGR56kDLpf
pj6CvpIwcCBFOmx6DhX1Jksx3W6YWlIB59CeWFw9OTZ0XGm8CKb+p3i1LgthxT3w
Dlty48YaP+ioyiUG6XjK6+CrZN+UHJEF698xzxiDw02PEk5PYLwk2oo2HQ3LIxQ7
ShWy5iHmnOl6iJgk0H5/iFzMwhiPleP58CZPW+MzbMw+xG4aBoXpK8Oks3itTO9k
qeyYU4T7aqInynPiRM7TMF6inXsaOzvz2vAwS7DLF7S0WQ+W1EDgcPgnIIxFBS66
bewHa/r3W27u19HeiEvItXPdZb/NAvhziTGeIn5CNpQqey5TP4axicBpiBATP5K+
nN2S1gZWGgI/OhjWtA74xN8X/FTuqtWtdCPyZ5kwt5t8EzCdFUMEfVSB9FfyKpsv
gERXnvgSB5HF14ExP63Es40DYpqlwL1Ef65tfRpEZgs95HHtenmuXv5pL9eKJRww
G7y5nFqoQblRdT18W52VfXJqrcN6I2EufXIjusduTB+btLiP88JSv1i8+ri509uf
gs+sJH5Ev15+czL4EAGLsqGHBpcoyolzdnJDUY1zMLpI5jgKwY0=
=iNJd
-----END PGP SIGNATURE-----

--gXXNPdSzYENCs07UJSk2midAHfCh4YWzN--
