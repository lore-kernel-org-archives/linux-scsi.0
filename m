Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF83C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 17:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44F7520708
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 17:36:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vWM7vvZq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgGGRgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 13:36:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63940 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGGRgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 13:36:21 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200707173619epoutp018ddc51c8e5d863cba8647edc42dfb7e9~fiPUIjFOC2279622796epoutp01q
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 17:36:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200707173619epoutp018ddc51c8e5d863cba8647edc42dfb7e9~fiPUIjFOC2279622796epoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594143379;
        bh=oVN+8hpcaaOYT2u2+NieZAFfBcu2WfwX8nv5C+b2IW8=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=vWM7vvZqnQXTMQhg3NiCZtByEKp1qzlmJgn3lb9ccKcEtaSHFsd02b/cyNfuG5qSe
         p6ayP4CTNawd0H/vX5TSRPoz4m67Zdd9jmH9sCSCGrXHuQpBJOX4JrUGb/k1LZSfG8
         ml1WLnbToDbSCUFIhiaBcvEHAJGjTaE1ryhVBLcE=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200707173618epcas5p46313ea9d9d41187133f37a65589a80d0~fiPTvTudj2843128431epcas5p4v;
        Tue,  7 Jul 2020 17:36:18 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.E6.09703.292B40F5; Wed,  8 Jul 2020 02:36:18 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200707173617epcas5p4b3841e04e7b32aa6f6b7cf1c52ce8f0c~fiPS5mlEH2843128431epcas5p4u;
        Tue,  7 Jul 2020 17:36:17 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200707173617epsmtrp21e0f669584588a4605948ac5c959d2da~fiPS47IUl0052600526epsmtrp25;
        Tue,  7 Jul 2020 17:36:17 +0000 (GMT)
X-AuditID: b6c32a4a-4b5ff700000025e7-d9-5f04b292fb8f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.01.08303.192B40F5; Wed,  8 Jul 2020 02:36:17 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200707173616epsmtip22ef24fc11986cb64d526be0991f9732b~fiPRPprv23144331443epsmtip2d;
        Tue,  7 Jul 2020 17:36:15 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Satya Tangirala'" <satyat@google.com>,
        <linux-scsi@vger.kernel.org>, "'Avri Altman'" <avri.altman@wdc.com>
Cc:     "'Barani Muthukumaran'" <bmuthuku@qti.qualcomm.com>,
        "'Kuohong Wang'" <kuohong.wang@mediatek.com>,
        "'Kim Boojin'" <boojin.kim@samsung.com>
In-Reply-To: <20200706200414.2027450-1-satyat@google.com>
Subject: RE: [PATCH v4 0/3] Inline Encryption Support for UFS
Date:   Tue, 7 Jul 2020 23:06:14 +0530
Message-ID: <000001d65485$1e819280$5b84b780$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH1874sPmdDj7gNy7LZpWNetxx2jQLtEpfPqKW4JqA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsWy7bCmpu6kTSzxBs9/Klm8/HmVzWLllkfM
        Fm9O/mGzaP3/itmi+/oONov+1XfZHNg8Fmwq9Wg5uZ/FY9HUZ4wefVtWMXp83iTn0X6gmymA
        LYrLJiU1J7MstUjfLoEr48e0b2wF2+QqLj95y9zAuESyi5GTQ0LARKL/+Sr2LkYuDiGB3YwS
        D1auZ4NwPjFKHF7zkBnC+cwo8bq1kRGm5eD2k6wQiV2MEgdu9EK1vGGUONjSyApSxSagK7Fj
        cRtQgoNDRKBIYtVOsEnMAhMYJb7dmgE2iVPAUuJuz11mEFtYwFbizYw57CA2i4CKxO8TC8Hi
        vCA1k3qgbEGJkzOfsIDYzALaEssWvmaGuEhB4ufTZawQu6wkrjXGQpSISxz92QO2V0Kgl0Ni
        a9dlJoh6F4nD8/qhbGGJV8e3sEPYUhKf3+0Fu1lCIFuiZ5cxRLhGYum8YywQtr3EgStzWEBK
        mAU0Jdbv0odYxSfR+/sJE0Qnr0RHmxBEtapE87urUJ3SEhO7u1khbA+JM2cmsExgVJyF5K9Z
        SP6aheSBWQjLFjCyrGKUTC0ozk1PLTYtMMpLLdcrTswtLs1L10vOz93ECE5BWl47GB8++KB3
        iJGJg/EQowQHs5IIb682Y7wQb0piZVVqUX58UWlOavEhRmkOFiVxXqUfZ+KEBNITS1KzU1ML
        UotgskwcnFINTM6c9/VDU366hzswsD8Tmyz1pP2Sd6+dlPbSJ6+XXtrBwnnlRErvli0u07WT
        ynVjpIM3l1QcPuT14nOo5FcLoXtf7h7LLu35+Ka1J2Kf5xm5yJTFpcoX1x48eeG5XEJalLXk
        /7wstrbbhmIWAWt2zDPNPJ+0pjj2EWde3Iag79WPulKu93FLHbf6uaTzmoJDubaR0e8M+7dm
        9ceatytHb9rudS03+fjzjmr+r4Vvzsxr/RG0en2moJ285MEv//Wk9xSk5DAJc/x/rMXQEam+
        Y35eeZXftrkeaedDOjRnmgr11U9cW7Tn1YrZOQK+qUvexv66GGCVYvLY3OU7398jRot7vwc5
        35e89fax8/IaJZbijERDLeai4kQAlwgOt7ADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJXnfiJpZ4g9brmhYvf15ls1i55RGz
        xZuTf9gsWv+/Yrbovr6DzaJ/9V02BzaPBZtKPVpO7mfxWDT1GaNH35ZVjB6fN8l5tB/oZgpg
        i+KySUnNySxLLdK3S+DK+PlmJXvBftmKRxcvsjUw/hbvYuTkkBAwkTi4/SRrFyMXh5DADkaJ
        y7OuskMkpCWub5wAZQtLrPz3nB2i6BWjxKqvG1lBEmwCuhI7FrexgdgiAiUSh1/tZAEpYhaY
        xCjxaP5LqI4uRonG7XPAOjgFLCXu9txlBrGFBWwl3syYA7aCRUBF4veJhWBxXpCaST1QtqDE
        yZlPWEBsZgFtiac3n8LZyxa+ZoY4T0Hi59NlQPM5gK6wkrjWGAtRIi5x9GcP8wRG4VlIJs1C
        MmkWkkmzkLQsYGRZxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kRHE9aWjsY96z6oHeI
        kYmD8RCjBAezkghvrzZjvBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHer7MWxgkJpCeWpGanphak
        FsFkmTg4pRqYsl4vjSqrt+KOmOX7o+KtdPuvPYnppRL6TjGSEqvVFrGzZi1IfHTI8MCqzHjn
        Sm1NEfNV9vNeh1ocCOdX0fld5ykz9/9Kizei2jURabu6qtawLs6/v3b10W88n2MCso7Ocl1x
        ZENCQr3w1t0ib0IeK+7cnRJY7RH/pKyZbwr3vuOKN/17liYIKjwLY091+5lrkWG76tK5FoZf
        SYxfDOfOV4vIqmZbWbX5ZAK/h0ak47YFESeLQ6W+sHuJn2mwjZ6/rrz0JOPLdcavJzKcZqpl
        LL69WfyMq86G7raCZ78/3FB5+0fcXuTahazpp0/O/igStbHTaBX/gjdK26494dk9vzjiom7r
        wr7v/2bfCN+qxFKckWioxVxUnAgAKMIqpBYDAAA=
X-CMS-MailID: 20200707173617epcas5p4b3841e04e7b32aa6f6b7cf1c52ce8f0c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200706200432epcas5p1d276cdebadfecc3984de37a80c4b19f2
References: <CGME20200706200432epcas5p1d276cdebadfecc3984de37a80c4b19f2@epcas5p1.samsung.com>
        <20200706200414.2027450-1-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Satya,

> -----Original Message-----
> From: Satya Tangirala <satyat=40google.com>
> Sent: 07 July 2020 01:34
> To: linux-scsi=40vger.kernel.org; Avri Altman <avri.altman=40wdc.com>; Al=
im
> Akhtar <alim.akhtar=40samsung.com>
> Cc: Barani Muthukumaran <bmuthuku=40qti.qualcomm.com>; Kuohong Wang
> <kuohong.wang=40mediatek.com>; Kim Boojin <boojin.kim=40samsung.com>;
> Satya Tangirala <satyat=40google.com>
> Subject: =5BPATCH v4 0/3=5D Inline Encryption Support for UFS
>=20
> This patch series adds support for inline encryption to UFS using the inl=
ine
> encryption support in the block layer. It follows the JEDEC UFSHCI v2.1
> specification, which defines inline encryption for UFS.
>=20
> This patch series previously went through a number of iterations as part =
of the
> =22Inline Encryption Support=22 patchset (last version was v13:
> https://lkml.kernel.org/r/20200514003727.69001-1-satyat=40google.com).
> This patch series is rebased on v5.8-rc4.
>=20
> Patch 1 introduces the crypto registers and struct definitions defined in=
 the
> UFSHCI v2.1 spec.
>=20
> Patch 2 introduces functions to manipulate the UFS inline encryption hard=
ware
> (again in line with the UFSHCI v2.1 spec) via the block layer keyslot man=
ager.
> Device specific drivers must set the UFSHCD_CAP_CRYPTO in hba->caps befor=
e
> ufshcd_hba_init_crypto is called to opt-in to inline encryption support.
>=20
> Patch 3 wires up ufshcd.c with the UFS crypto API introduced in Patch 2.
>=20
> This patch series has been tested on some Qualcomm chipsets (on the db845=
c,
> sm8150-mtp and sm8250-mtp) using some additional patches at
> https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-
> ebiggers=40kernel.org/
> and on some Mediatek chipsets using the additional patch in
> https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-
> stanley.chu=40mediatek.com/.
> These additional patches are required because these chipsets need certain
> additional behaviour not specified within the UFSHCI v2.1 spec.
>=20
> Thanks a lot to all the folks who tested this out=21
>=20
> Changes v3 =3D> v4:
>  - fix incorrect patch folding
>  - some cleanups from Eric
>=20
> Changes v2 =3D> v3:
>  - introduce ufshcd_prepare_req_desc_hdr_crypto to clean up code slightly
>  - split up ufshcd_hba_init_crypto into ufshcd_hba_init_crypto_capabiliti=
es
>    and ufshcd_init_crypto. The first function is called from
>    ufshcd_hba_capabilities, and only reads crypto capabilities from devic=
e
>    registers and sets up appropriate crypto structures. The second functi=
on
>    is called from ufshcd_init, and actually initializes the inline crypto
>    hardware.
>=20
> Changes v1 =3D> v2
>  - handle OCS_DEVICE_FATAL_ERROR explicitly in ufshcd_transfer_rsp_status
>=20
> Satya Tangirala (3):
>   scsi: ufs: UFS driver v2.1 spec crypto additions
>   scsi: ufs: UFS crypto API
>   scsi: ufs: Add inline encryption support to UFS
>=20
>  drivers/scsi/ufs/Kconfig         =7C   9 ++
>  drivers/scsi/ufs/Makefile        =7C   1 +
>  drivers/scsi/ufs/ufshcd-crypto.c =7C 238 +++++++++++++++++++++++++++++++
> drivers/scsi/ufs/ufshcd-crypto.h =7C  77 ++++++++++
>  drivers/scsi/ufs/ufshcd.c        =7C  49 ++++++-
>  drivers/scsi/ufs/ufshcd.h        =7C  24 ++++
>  drivers/scsi/ufs/ufshci.h        =7C  67 ++++++++-
>  7 files changed, 456 insertions(+), 9 deletions(-)  create mode 100644
> drivers/scsi/ufs/ufshcd-crypto.c  create mode 100644 drivers/scsi/ufs/ufs=
hcd-
> crypto.h
>=20
Looks Good to me.
I don=E2=80=99t=20have=20a=20platform=20to=20test=20this=20series=20though.=
=0D=0AIt=20will=20be=20good=20to=20get=20a=20Tested-by=20tags=20for=20this=
=20series.=0D=0A=0D=0AReviewed-by:=20Alim=20Akhtar=20<alim.akhtar=40samsung=
.com>=0D=0A=0D=0A>=20--=0D=0A>=202.27.0.212.ge8ba1cc988-goog=0D=0A=0D=0A=0D=
=0A
