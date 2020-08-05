Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3309C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8C4B20792
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="j/eQ/S8F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgHEBsk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:48:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42007 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgHEBsj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:48:39 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200805014836epoutp03651236e251fc6bc3cfca2dc42e8dc3e2~oPBIvuFMd2436024360epoutp03v
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 01:48:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200805014836epoutp03651236e251fc6bc3cfca2dc42e8dc3e2~oPBIvuFMd2436024360epoutp03v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1596592116;
        bh=quhJBoqrOryoe2FpL93bLWBcYB4IoiWwuOxWLBAsZW8=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=j/eQ/S8F8zaoY/ICkdamoDMlDqGiBR75etnzlu5VP4+g3qzdAECro8ny2KWDx72za
         6I9SFUh/eik2+VnxkBjDuhCpf5JseUllPoJ2r0qNbb2gRmY8B8KTCq5TgLD2dztmFo
         T7Dg7cEDRMjQu+KBy/Q54+8Fk8px2VwPYABKQKNE=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200805014836epcas5p301c5d1f3a0ec8ee9ef38cc868e311d30~oPBILve0z0131301313epcas5p3U;
        Wed,  5 Aug 2020 01:48:36 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.F0.09475.4FF0A2F5; Wed,  5 Aug 2020 10:48:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200805014835epcas5p3b555ea4461ff835b36c90efd1d11989b~oPBH8rKx80131301313epcas5p3T;
        Wed,  5 Aug 2020 01:48:35 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200805014835epsmtrp15ecc93c3ba1548e0e3054b6b03ed93d6~oPBH71Xl20215102151epsmtrp1a;
        Wed,  5 Aug 2020 01:48:35 +0000 (GMT)
X-AuditID: b6c32a4b-39fff70000002503-f0-5f2a0ff4fa61
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.54.08382.3FF0A2F5; Wed,  5 Aug 2020 10:48:35 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200805014834epsmtip242ae9eee6444535434444581d0e9d8bc~oPBGbQwN02601426014epsmtip2S;
        Wed,  5 Aug 2020 01:48:34 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc:     "'Randy Dunlap'" <rdunlap@infradead.org>, <avri.altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <sfr@canb.auug.org.au>
In-Reply-To: <yq1lfitzxgf.fsf@ca-mkp.ca.oracle.com>
Subject: RE: [PATCH -next] scsi: ufs: Fix 'unmet direct dependencies' config
 warning
Date:   Wed, 5 Aug 2020 07:18:31 +0530
Message-ID: <005e01d66aca$8826f1c0$9874d540$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHQau07HEhALcTvIF0oVR/q95KlqQHbZGLRASBpbyQBI6qB7QH1XCHsqQQW4xA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsWy7bCmhu4Xfq14gwWzWCxe/rzKZtF9fQeb
        xfLj/5gs3t6ZzmKxde9VdgdWj8YbN9g8Nq/Q8vj49BaLx+dNch7tB7qZAlijuGxSUnMyy1KL
        9O0SuDLurjQpmMdZcetRWAPjEY4uRk4OCQETiZfrv7B3MXJxCAnsZpR4uWgBK4TziVHiwIk3
        zBDON0aJa383sMK0PH01nxnEFhLYyyjRtTgVougNo8SkV02MIAk2AV2JHYvb2EBsEQFziYkT
        jrKA2MwC1RLP77WDNXMKGEvs/T2ZCcQWFgiT2L1/KVgvi4CKxIYl98FsXgFLiUlnn7FC2IIS
        J2c+gZqjLbFs4WtmiIMUJH4+XcYKsctPYvfeuVA14hJHf/aAfSAh0Mgh8ffPDCaIBheJXZfP
        QdnCEq+Ob2GHsKUkXva3AdkcQHa2RM8uY4hwjcTSecdYIGx7iQNX5rCAlDALaEqs36UPsYpP
        ovf3EyaITl6JjjYhiGpVieZ3V6E6pSUmdndDg9BDYsa2k2wTGBVnIXlsFpLHZiF5YBbCsgWM
        LKsYJVMLinPTU4tNC4zzUsv1ihNzi0vz0vWS83M3MYJTjZb3DsZHDz7oHWJk4mA8xCjBwawk
        wvvxs3q8EG9KYmVValF+fFFpTmrxIUZpDhYlcV6lH2fihATSE0tSs1NTC1KLYLJMHJxSDUwX
        VH8u4VHcqsPuL/n3t0V117Ufv+5NFV31zbb+SevZrHV2XxMubPHgEdn0WGPttFPaYsuntRho
        FPzwOM/Jn1rd9PR7aJBmpujp7pk9049ZsnW93+i1zrf86YxljVcWXjFcl1C2K8jgkHnqonmM
        J/f4bFv1haEw+Ezzx2diPTda1t44+V7c5PCUU08mLrWs5X4tsm4Cb8xZfsei04afww+IMDxY
        JfUrfPf0ADsP5vuLHu7Jnvt83uQHzydcKZiUdppRIefrx9XaC/QKqp0rHhSybpKNEvdts3ke
        deu2yl2h18lRDJdl2riX/Gp9tv7Y7NOmMzjMW4TCaqPXzPnxeXFpzQGOFSvfVm08FmP8zb2z
        TomlOCPRUIu5qDgRAIBIeXOkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSvO5nfq14gzk39C1e/rzKZtF9fQeb
        xfLj/5gs3t6ZzmKxde9VdgdWj8YbN9g8Nq/Q8vj49BaLx+dNch7tB7qZAlijuGxSUnMyy1KL
        9O0SuDKWH/7GVDCfveLr619sDYxvWLsYOTkkBEwknr6az9zFyMUhJLCbUeJuz3k2iIS0xPWN
        E9ghbGGJlf+eg9lCAq8YJS7M0AWx2QR0JXYsbgOrFxEwl5g44SgLiM0sUC9xe9saFoihM5gk
        LrY1MoEkOAWMJfb+ngxkc3AIC4RIvJmoBRJmEVCR2LDkPiOIzStgKTHp7DNWCFtQ4uTMJ1Az
        tSV6H7YywtjLFr5mhrhNQeLn02WsEDf4SezeOxeqXlzi6M8e5gmMwrOQjJqFZNQsJKNmIWlZ
        wMiyilEytaA4Nz232LDAMC+1XK84Mbe4NC9dLzk/dxMjOG60NHcwbl/1Qe8QIxMH4yFGCQ5m
        JRHej5/V44V4UxIrq1KL8uOLSnNSiw8xSnOwKInz3ihcGCckkJ5YkpqdmlqQWgSTZeLglGpg
        irt6JU90fukF2V71Ku6vN6Ibjaf6yCTudIs9PWntkixlxStPSmqjm5tCz8ad/PNqw1cXM+Ub
        jWe56rKkAo85aUfG7S3b0vvinL7yYa3Vj9awhykJboswNe7v23NEMSp1WyIXk5Br7q62RzFz
        9cMl0qJqtv5TXDb/uMMitY+aU8vnf990i/VAebCV+uH8JjmPF0ZR7092OjG4N85f75l39/aP
        M+yZEx8eqLk1xcDmtenhjYKR7oqnNjkX7Dk9xTnkk6Tx/JY8oR0qOSYTb3CVTOr/YOLe671t
        2YHu0jeFMU9/VX50v9b3OOudacwd8dM/5t780Mu/+v2Hu1aPr/03CrhuF7iwYeZTw1/VAewZ
        SizFGYmGWsxFxYkAZA2PBwoDAAA=
X-CMS-MailID: 20200805014835epcas5p3b555ea4461ff835b36c90efd1d11989b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d
References: <CGME20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d@epcas5p2.samsung.com>
        <20200721172021.28922-1-alim.akhtar@samsung.com>
        <857eba45-475e-e2ea-86ba-e495794ae74c@infradead.org>
        <005b01d66ac8$429b8460$c7d28d20$@samsung.com>
        <yq1lfitzxgf.fsf@ca-mkp.ca.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen <martin.petersen=40oracle.com>
> Sent: 05 August 2020 07:07
> To: Alim Akhtar <alim.akhtar=40samsung.com>
> Cc: 'Randy Dunlap' <rdunlap=40infradead.org>; martin.petersen=40oracle.co=
m;
> avri.altman=40wdc.com; linux-scsi=40vger.kernel.org; sfr=40canb.auug.org.=
au
> Subject: Re: =5BPATCH -next=5D scsi: ufs: Fix 'unmet direct dependencies'=
 config
> warning
>=20
>=20
> Alim,
>=20
> > I don=E2=80=99t=20see=20this=20patch=20in=20your=20tree,=20let=20me=20k=
now=20if=20I=20need=20to=20-resend=0D=0A>=20>=20this.=0D=0A>=20=0D=0A>=20I=
=20postponed=20the=20Exynos=20update=20to=205.10=20since=20there=20were=20a=
=20few=20zeroday=20warnings=0D=0A>=20and=20it=20looked=20like=20the=205.8=
=20release=20was=20imminent.=0D=0A>=20=0D=0AI=20suppose=20all=20fixes=20whe=
re=20sent=20on=20time=20for=20ufs-exynos=20driver.=20Anyway=20let=20me=20kn=
ow=20in=20case=0D=0AI=20need=20to=20re-send=20any=20patches.=0D=0AThe=20=24=
SUBJECT=20patch=20is=20needed=20to=20fix=20a=20build=20warning.=0D=0AThank=
=20you=21=0D=0A=0D=0A>=20--=0D=0A>=20Martin=20K.=20Petersen=09Oracle=20Linu=
x=20Engineering=0D=0A=0D=0A
