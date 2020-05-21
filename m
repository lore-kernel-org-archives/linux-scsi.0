Return-Path: <SRS0=cxkO=7D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62966C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 16:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 366392072C
	for <linux-scsi@archiver.kernel.org>; Thu, 21 May 2020 16:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BBlJE/2w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729943AbgEUQto (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 May 2020 12:49:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30730 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728721AbgEUQtn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2020 12:49:43 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200521164941epoutp0175414ab033fd98811131a1c1965987cf~RGSLfNU4H1467214672epoutp01X
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2020 16:49:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200521164941epoutp0175414ab033fd98811131a1c1965987cf~RGSLfNU4H1467214672epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590079781;
        bh=BxuoQ2bDUpnmdDK6AiDLxEreiEN3dox/04SRxbRcCYA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=BBlJE/2wbRifrbbgu/9yBi5y2o731MUTbpdulYmbSYPI/S+sqsVX1ZlYlL9phYsU9
         FC0czf9Ug9FUl8Ft4Na3HBcW8OyS6TYQ4ctjwHM5RyH++5Gr2VPFUdK1stvWK4ofL6
         YK6iOAXEwK2ff1xsJZKlV+A9F0AxQwoQXhbwtuTE=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200521164940epcas5p315923a6e098754aec537394f45aa5b65~RGSKjw7Gf3196531965epcas5p3M;
        Thu, 21 May 2020 16:49:40 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        39.C8.23389.321B6CE5; Fri, 22 May 2020 01:49:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200521164938epcas5p332682bce7ac711559181361ec1868fc5~RGSJdDMoW3194731947epcas5p3Q;
        Thu, 21 May 2020 16:49:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200521164938epsmtrp18f1d4d5ab8ed32dbf03a57f61aade580~RGSJcHLaZ3131231312epsmtrp1v;
        Thu, 21 May 2020 16:49:38 +0000 (GMT)
X-AuditID: b6c32a4b-7adff70000005b5d-37-5ec6b123febc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.6E.25866.221B6CE5; Fri, 22 May 2020 01:49:38 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200521164935epsmtip2385e245437ef260d48f6c6b07e5b015e~RGSGl6sca1862918629epsmtip2x;
        Thu, 21 May 2020 16:49:35 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzk@kernel.org>
Cc:     <robh@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20200519071636.GA6971@kozik-lap>
Subject: RE: [PATCH v9 10/10] arm64: dts: Add node for ufs exynos7
Date:   Thu, 21 May 2020 22:19:33 +0530
Message-ID: <018f01d62f8f$d0b993a0$722cbae0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQDj7nWNOwhaAxvEU9bpCgUI3fQKTQLlQRCoAnN8e0wCOeNtTKparPXQ
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmhq7yxmNxBlPemVu8/HmVzeLT+mWs
        FvOPnGO1OH9+A7vFzS1HWSw2Pb7GanF51xw2ixnn9zFZdF/fwWax/Pg/Jov/e3awWyzdepPR
        gcfjcl8vk8emVZ1sHpuX1Hu0nNzP4vHx6S0Wj74tqxg9Pm+S82g/0M0UwBHFZZOSmpNZllqk
        b5fAlfHz4xSmgn88FauPv2FtYPzP3cXIySEhYCLxYEMncxcjF4eQwG5Gid7Vl5hBEkICnxgl
        li33gkh8ZpRouzqZBabj2oYHrBCJXYwS83rPQLW/YZT49/otO0gVm4CuxI7FbWwgtgiQvfnG
        cnaQImaBk0wSR/p6mEASnAJ6Eh9nvgSzhQWcJN6fmgu2m0VAVaJx3Q9GEJtXwFLi/eu/7BC2
        oMTJmU/AzmAW0JZYtvA1M8RJChI/ny5jhVjmJjHnJUQvs4C4xNGfPWDXSQic4ZA4eOoaVIOL
        xO2m32wQtrDEq+Nb2CFsKYmX/W1ANgeQnS3Rs8sYIlwjsXTeMaj37SUOXJnDAlLCLKApsX6X
        PsQqPone30+YIDp5JTrahCCqVSWa312F6pSWmNjdzQphe0jMbnjPOIFRcRaSx2YheWwWkgdm
        ISxbwMiyilEytaA4Nz212LTAOC+1XK84Mbe4NC9dLzk/dxMjOKlpee9gfPTgg94hRiYOxkOM
        EhzMSiK8C/mPxgnxpiRWVqUW5ccXleakFh9ilOZgURLnfdy4JU5IID2xJDU7NbUgtQgmy8TB
        KdXApN2tk+G0xCugU/B0a/G8a/cVK9nUZ88WYTYP0DjSdCM2y79CPvrhoy9f/ku6Fja901Z4
        f9iG+VbzonfsXX8v1kuoZrfNcdvkPvPXPoHy90vdjh/g19JxKGKqPMAQLV/fc63ylk/uDtPr
        HjaRGaxaWaaLFq2RF2x2DX4e+EGuSi+R6eq5HdVBqyd1LdBuf6Vffu1PfaCE8ZQsjVefTP9K
        i++Qay9ftfMnu85er++PImYdOh3k+DK4W3tdX87H2XzPA2545M9P+J+90farp3LK/L8+V/mW
        uM4w2eP5UDl4/p+30869OvjyW5dKvcCx9fIclkcKdjxwlJuS/VD1xQm1wNqrbafzMoOsFHM4
        JpcpsRRnJBpqMRcVJwIAibESidkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWy7bCSvK7SxmNxBp9Wa1q8/HmVzeLT+mWs
        FvOPnGO1OH9+A7vFzS1HWSw2Pb7GanF51xw2ixnn9zFZdF/fwWax/Pg/Jov/e3awWyzdepPR
        gcfjcl8vk8emVZ1sHpuX1Hu0nNzP4vHx6S0Wj74tqxg9Pm+S82g/0M0UwBHFZZOSmpNZllqk
        b5fAlbF380v2gmNcFRNv7GdrYLzL0cXIySEhYCJxbcMD1i5GLg4hgR2MEmvO/2CDSEhLXN84
        gR3CFpZY+e85O0TRK0aJKZN6WUESbAK6EjsWt4E1iADZm28sBytiFrjMJPFn6VpGiI5HjBJt
        /2cxgVRxCuhJfJz5EswWFnCSeH9qLjOIzSKgKtG47gcjiM0rYCnx/vVfdghbUOLkzCcsIDaz
        gLZE78NWRhh72cLXzBDnKUj8fLqMFeIKN4k5L39A1YhLHP3ZwzyBUXgWklGzkIyahWTULCQt
        CxhZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBEeoltYOxj2rPugdYmTiYDzEKMHB
        rCTCu5D/aJwQb0piZVVqUX58UWlOavEhRmkOFiVx3q+zFsYJCaQnlqRmp6YWpBbBZJk4OKUa
        mPg0o+TshF/VdRiZr/O7NYtnWzK7fkiT6nT5mO+KiXELDKuFvr/qq6/Klj55kEvj3dq8zSLL
        2O4qcp+/cqqv+NXxF49O/WG4V+ojdvRy3ok7NYea54ax8aqsXXLv7q9V3+IKetjv64kkSIbN
        flhU3TKn8N+kLYt2FQnYh86xfBR3ND6r/IHFr2MKzW+vyYupRgo2SXCJqp/sv82yxStymdL5
        w0Zvl3JLxFyYFPDxDQN3yp0Ozl3itysfT1/qt8++x3rnkpTsh4zP5wm0TPlt1XDnh1SZO6O9
        ve+tut+fGFUibTfZ3Dkr9cuN5TXP+tpF0ic2T1Pe7pWs4mNe7FBlaLA7sInv94Fvui2hS6Kv
        KbEUZyQaajEXFScCAIfNOYg/AwAA
X-CMS-MailID: 20200521164938epcas5p332682bce7ac711559181361ec1868fc5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005313epcas5p3eac58d00d9f617b860a3ac607c8413ec
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
        <CGME20200514005313epcas5p3eac58d00d9f617b860a3ac607c8413ec@epcas5p3.samsung.com>
        <20200514003914.26052-11-alim.akhtar@samsung.com>
        <20200519071636.GA6971@kozik-lap>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Krzysztof Kozlowski <krzk=40kernel.org>
> Sent: 19 May 2020 12:47
> To: Alim Akhtar <alim.akhtar=40samsung.com>
> Cc: robh=40kernel.org; devicetree=40vger.kernel.org; linux-scsi=40vger.ke=
rnel.org;
> avri.altman=40wdc.com; martin.petersen=40oracle.com;
> kwmad.kim=40samsung.com; stanley.chu=40mediatek.com;
> cang=40codeaurora.org; linux-samsung-soc=40vger.kernel.org; linux-arm-
> kernel=40lists.infradead.org; linux-kernel=40vger.kernel.org
> Subject: Re: =5BPATCH v9 10/10=5D arm64: dts: Add node for ufs exynos7
>=20
> On Thu, May 14, 2020 at 06:09:14AM +0530, Alim Akhtar wrote:
> > Adding dt node foe UFS and UFS-PHY for exynos7 SoC.
> >
> > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
> > Tested-by: Pawe=C5=82=20Chmiel=20<pawel.mikolaj.chmiel=40gmail.com>=0D=
=0A>=20>=20---=0D=0A>=20>=20=20.../boot/dts/exynos/exynos7-espresso.dts=20=
=20=20=20=20=20=7C=20=204=20++=0D=0A>=20>=20=20arch/arm64/boot/dts/exynos/e=
xynos7.dtsi=20=20=20=20=20=20=20=7C=2043=20++++++++++++++++++-=0D=0A>=20>=
=20=202=20files=20changed,=2045=20insertions(+),=202=20deletions(-)=0D=0A>=
=20=0D=0A>=20I=20will=20pick=20it=20up=20after=20all=20bindings=20get=20Rob=
's=20ack=20(or=20are=20picked=20up=20as=20well).=20=20The=0D=0A>=20second=
=20bindings=20patch=20are=20still=20pending=20on=20that.=0D=0A>=20=0D=0ATha=
nk=20Krzysztof,=0D=0AYes,=20one=20binding=20still=20awaiting=20Rob's=20ack,=
=20I=20have=20addressed=20his=20comment=20in=20this=20v9=20series.=0D=0AHop=
ing=20he=20will=20find=20some=20time=20to=20review=20the=20same.=0D=0A=0D=
=0A>=20Best=20regards,=0D=0A>=20Krzysztof=0D=0A=0D=0A
