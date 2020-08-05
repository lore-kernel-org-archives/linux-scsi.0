Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2455BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E339A2086A
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tPbXIOcX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgHEBc0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:32:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31786 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgHEBcZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:32:25 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200805013222epoutp033b61e54719d63c5f2cd0f05016b023e1~oOy9MCd0n0991109911epoutp039
        for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2020 01:32:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200805013222epoutp033b61e54719d63c5f2cd0f05016b023e1~oOy9MCd0n0991109911epoutp039
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1596591142;
        bh=BxMMCNU8CV2tvW4GBNdlbC2q8N2ORmK3U9uIKUym0ko=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=tPbXIOcXbmXr5i1/LptOOUTjS3CiWCEzXJrezLY6QNOM75pznDWz7OCWy+cdOqlHk
         WFnILhcEaxs+U0H5SE8s8GRGP0e0h23xwr3m2LLgmlu4kERleFy6C4/Nbhn8/ILEQQ
         RzIwq9JX6oXwj3quLESXp+tD2JYNkxU/8rseARhw=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200805013221epcas5p2b1037869cc2c63510c914d58a53348c8~oOy8UgKos1004210042epcas5p2S;
        Wed,  5 Aug 2020 01:32:21 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8F.89.40333.52C0A2F5; Wed,  5 Aug 2020 10:32:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200805013220epcas5p3b76dd3a3ad268af1c7de225b9b6445ad~oOy7YdVHE0394203942epcas5p3J;
        Wed,  5 Aug 2020 01:32:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200805013220epsmtrp153706ba4608450ca81e4cfc89c5877fc~oOy7X0-MD2646026460epsmtrp1b;
        Wed,  5 Aug 2020 01:32:20 +0000 (GMT)
X-AuditID: b6c32a4a-991ff70000019d8d-11-5f2a0c25d8ae
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.C1.08382.42C0A2F5; Wed,  5 Aug 2020 10:32:20 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200805013218epsmtip2e2ed249fe43d3295ea994febed1e0ab5~oOy5R5H461859318593epsmtip2f;
        Wed,  5 Aug 2020 01:32:17 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Randy Dunlap'" <rdunlap@infradead.org>,
        <martin.petersen@oracle.com>
Cc:     <avri.altman@wdc.com>, <linux-scsi@vger.kernel.org>,
        <sfr@canb.auug.org.au>
In-Reply-To: <857eba45-475e-e2ea-86ba-e495794ae74c@infradead.org>
Subject: RE: [PATCH -next] scsi: ufs: Fix 'unmet direct dependencies' config
 warning
Date:   Wed, 5 Aug 2020 07:02:15 +0530
Message-ID: <005b01d66ac8$429b8460$c7d28d20$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHQau07HEhALcTvIF0oVR/q95KlqQHbZGLRASBpbySpHNt2oA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsWy7bCmlq4qj1a8wdw9fBYvf15ls+i+voPN
        Yvnxf0wWb+9MZ7HYuvcquwOrR+ONG2wem1doeXx8eovF4/MmOY/2A91MAaxRXDYpqTmZZalF
        +nYJXBkfJnIXHBWomPn/LmsD40T+LkZODgkBE4lVq08wgdhCArsZJX5tMupi5AKyPzFKfF57
        lhnC+cYo8f/NfTaYjvs/1jNBJPYySkzp3McC0f6GUeLOCi0Qm01AV2LH4jawBhEBL4k/11cz
        gtjMAoESHxacZAaxOQUcJVb1rwGzhQXCJHbvXwpUw8HBIqAiMekxN0iYV8BSYtOlv0wQtqDE
        yZlPWCDGaEssW/iaGeIeBYmfT5exQqxykjjQuwtqlbjE0Z89YA9ICPxll3g9YTMrRIOLxNS2
        fUwQtrDEq+Nb2CFsKYmX/W3sIDdICGRL9OwyhgjXSCydd4wFwraXOHBlDgtICbOApsT6XfoQ
        q/gken8/YYLo5JXoaBOCqFaVaH53FapTWmJidzfUAR4SM7adZJvAqDgLyWOzkDw2C8kDsxCW
        LWBkWcUomVpQnJueWmxaYJSXWq5XnJhbXJqXrpecn7uJEZxotLx2MD588EHvECMTB+MhRgkO
        ZiUR3o+f1eOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8yr9OBMnJJCeWJKanZpakFoEk2Xi4JRq
        YKpSvvPZ/gxLS9tas1MCb+4H/jbZeG+dt9FmXRdHn05Gt8C+XYfT/7oct3ngfPOOffQJkW7r
        nF8/TTYvrL8469a3tSxqKRZroiX134vudxdf/az1mgPfgdLi3nwDy5cHP1V6Jkcfv2qRVr5q
        4SKNvXtWqMyalfSBQVR9f82V4yGCrev4pPT2WpYK2MitVFr4YFvG8fYnpSEzpFU1LJs2Prjj
        +vnDzwPVayJcMgsiJj0UWuMY39sdG+musvhfVo3Drj+VIX86q1bUNu+7ZVJvbnzj5+yp6Ye/
        nfIs3TuF5YCG0raLs5wqlymz9fxk5uw89HWFsXYcn8qJ5tby7PfLyvqDIipYpNu0xBy811bY
        KbEUZyQaajEXFScCADicCAWjAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSvK4Kj1a8wee/HBYvf15ls+i+voPN
        Yvnxf0wWb+9MZ7HYuvcquwOrR+ONG2wem1doeXx8eovF4/MmOY/2A91MAaxRXDYpqTmZZalF
        +nYJXBmP13ewFdziqbhyfDlzA+MUri5GTg4JAROJ+z/WM3UxcnEICexmlOg5uYUNIiEtcX3j
        BHYIW1hi5b/n7BBFr4CKpvSzgiTYBHQldixuA2sQEfCR2PPhNSOIzSwQLPF/5jkWiIbDjBLP
        N15hBklwCjhKrOpfA2RzcAgLhEi8magFYrIIqEhMeswNUsErYCmx6dJfJghbUOLkzCcsECO1
        JXoftjLC2MsWvmaGuE1B4ufTZawQJzhJHOjdBVUjLnH0Zw/zBEbhWUhGzUIyahaSUbOQtCxg
        ZFnFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREcN1qaOxi3r/qgd4iRiYPxEKMEB7OS
        CO/Hz+rxQrwpiZVVqUX58UWlOanFhxilOViUxHlvFC6MExJITyxJzU5NLUgtgskycXBKNTBx
        HxTjPcEYqMRy6qQmv3jHnxfL8pXsHVVq+AJeOLD2N55hmuTI3zrv+O2TSVffMT49vnMDU6mO
        bX5O/qMJ0Qx7dt9xVDzaUi5+XKY9b6X0vruhn9dtXmzJvWxXjb+98dRk/bVRM22Y5lYb+V2u
        +/d0l/Uar5dphQ1n5WJ3LQwonfbf6U+YTFdW0erFM0QmqblG1rxX2R97d+LMrg41WZWZ/uG+
        Ti3nzlaWvpnHOGeD8Mlt5kZM95ZnR+RKzmKZcLDb5c/dL/WvnP5f/8kTInBSa0K49Gphp0wD
        eccj0+t4tj01EWWxXb5wcVH8gQnBhfVncyVk8xMsjbnKo9Vrzb6bRD+V3H7gu/jKiAuMpkos
        xRmJhlrMRcWJAATGX0IKAwAA
X-CMS-MailID: 20200805013220epcas5p3b76dd3a3ad268af1c7de225b9b6445ad
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d
References: <CGME20200721174310epcas5p2a448e38c6e4d5e36e9f0417f5ddced6d@epcas5p2.samsung.com>
        <20200721172021.28922-1-alim.akhtar@samsung.com>
        <857eba45-475e-e2ea-86ba-e495794ae74c@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

> On 7/21/20 10:20 AM, Alim Akhtar wrote:
> > With =21CONFIG_OF and SCSI_UFS_EXYNOS selected, the below warning is
> > given:
> >
> > WARNING: unmet direct dependencies detected for PHY_SAMSUNG_UFS
> >   Depends on =5Bn=5D: OF =5B=3Dn=5D && (ARCH_EXYNOS =7C=7C COMPILE_TEST=
 =5B=3Dy=5D)
> >   Selected by =5By=5D:
> >   - SCSI_UFS_EXYNOS =5B=3Dy=5D && SCSI_LOWLEVEL =5B=3Dy=5D && SCSI =5B=
=3Dy=5D &&
> > SCSI_UFSHCD_PLATFORM =5B=3Dy=5D && (ARCH_EXYNOS =7C=7C COMPILE_TEST =5B=
=3Dy=5D)
> >
> > Fix it by removing PHY_SAMSUNG_UFS dependency.
> >
> > Reported-by: Randy Dunlap <rdunlap=40infradead.org>
> > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
>=20
> Looks good. Thanks.
>=20
> Acked-by: Randy Dunlap <rdunlap=40infradead.org>
>=20
I don=E2=80=99t=20see=20this=20patch=20in=20your=20tree,=20let=20me=20know=
=20if=20I=20need=20to=20-resend=20this.=0D=0AThanks=21=0D=0A=0D=0A>=20>=20-=
--=0D=0A>=20>=20=20drivers/scsi/ufs/Kconfig=20=7C=201=20-=0D=0A>=20>=20=201=
=20file=20changed,=201=20deletion(-)=0D=0A>=20>=0D=0A>=20>=20diff=20--git=
=20a/drivers/scsi/ufs/Kconfig=20b/drivers/scsi/ufs/Kconfig=20index=0D=0A>=
=20>=2046a4542f37eb..590768758fc6=20100644=0D=0A>=20>=20---=20a/drivers/scs=
i/ufs/Kconfig=0D=0A>=20>=20+++=20b/drivers/scsi/ufs/Kconfig=0D=0A>=20>=20=
=40=40=20-164,7=20+164,6=20=40=40=20config=20SCSI_UFS_BSG=20=20config=20SCS=
I_UFS_EXYNOS=0D=0A>=20>=20=20=09tristate=20=22EXYNOS=20specific=20hooks=20t=
o=20UFS=20controller=20platform=20driver=22=0D=0A>=20>=20=20=09depends=20on=
=20SCSI_UFSHCD_PLATFORM=20&&=20(ARCH_EXYNOS=20=7C=7C=0D=0A>=20COMPILE_TEST)=
=0D=0A>=20>=20-=09select=20PHY_SAMSUNG_UFS=0D=0A>=20>=20=20=09help=0D=0A>=
=20>=20=20=09=20=20This=20selects=20the=20EXYNOS=20specific=20additions=20t=
o=20UFSHCD=20platform=20driver.=0D=0A>=20>=20=20=09=20=20UFS=20host=20on=20=
EXYNOS=20includes=20HCI=20and=20UNIPRO=20layer,=20and=20associates=0D=0A>=
=20>=20with=0D=0A>=20>=0D=0A>=20>=20base-commit:=20ab8be66e724ecf4bffb2895c=
9c91bbd44fa687c7=0D=0A>=20>=0D=0A>=20=0D=0A>=20=0D=0A>=20--=0D=0A>=20=7ERan=
dy=0D=0A=0D=0A
