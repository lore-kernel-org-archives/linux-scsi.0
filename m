Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD1CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 15:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DE95206A4
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 15:18:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="E2qXLywZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgFKPSy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 11:18:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59985 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbgFKPSy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2020 11:18:54 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200611151852epoutp022e2b9d9c0cd9f06e8e74414af28eb79c~Xhl4hWrv81269312693epoutp02f
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2020 15:18:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200611151852epoutp022e2b9d9c0cd9f06e8e74414af28eb79c~Xhl4hWrv81269312693epoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591888732;
        bh=h0Jr8xoU2TPvELPqg4DkGPi4elgZ88JtRpm3jI4sPwQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=E2qXLywZVzIV2fW1SRVFtB8sfs2v4wTUs+C83cFxe4fQV8bMZOIjCHUKh5h+ZPt3S
         JESIWUg9U8ylqBnIVXGEy9vuGVUXYCEFg6Hokbepzg6Ny2SbxkI4oY61u0hooc5HH/
         aU1v9ViSpaq+AvezROTfzehwaVuSG0jwDmdN6YIc=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200611151850epcas5p24e66287669171ac559a61cc700b19d56~Xhl3bd9oW2174021740epcas5p2G;
        Thu, 11 Jun 2020 15:18:50 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.67.09467.A5B42EE5; Fri, 12 Jun 2020 00:18:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200611151850epcas5p2a784c542779d9bc1bdcfca28ea8a6c2a~Xhl2nsFSe1713117131epcas5p2d;
        Thu, 11 Jun 2020 15:18:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200611151850epsmtrp1fec96d9694da2e652f1efbe1d90ef856~Xhl2mz7qk1872718727epsmtrp1v;
        Thu, 11 Jun 2020 15:18:50 +0000 (GMT)
X-AuditID: b6c32a49-a3fff700000024fb-94-5ee24b5a1ab7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D2.DF.08303.95B42EE5; Fri, 12 Jun 2020 00:18:50 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200611151846epsmtip14b4bb6edb355961b9377b5a92da29cb5~Xhlzf0dnn1495414954epsmtip1S;
        Thu, 11 Jun 2020 15:18:46 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        <robh@kernel.org>
Cc:     <krzk@kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <avri.altman@wdc.com>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cang@codeaurora.org>,
        <devicetree@vger.kernel.org>, <kwmad.kim@samsung.com>,
        <linux-kernel@vger.kernel.org>, "'Vinod Koul'" <vkoul@kernel.org>
In-Reply-To: <89b96bd0-a9a3-cdd8-dc67-1f9f49eef264@ti.com>
Subject: RE: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Date:   Thu, 11 Jun 2020 20:48:44 +0530
Message-ID: <001c01d64003$9bca1500$d35e3f00$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQNA14zZ9KpC6NxovY65uGX80LQ4kgIpylB3AdlmWUMBx1WEmQIl7Fhypb7UH7A=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMKsWRmVeSWpSXmKPExsWy7bCmpm6U96M4gxNrTC1e/rzKZvFp/TJW
        i/lHzrFaXHjaw2Zx/vwGdoubW46yWGx6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFv/37GC3
        WLr1JqPFzjsnmB34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4Mq4fESxoFmoYta6+4wNjD/5uhg5OSQETCQOXTjM3MXIxSEk
        sJtR4vafM2wQzidGiQsz5jFCOJ8ZJd7+e88I07J+5TMmiMQuRolZd3ayQDhvGCU2T9/OBlLF
        JqArsWNxG5gtIlAhcXP2b3aQImaBc0wS8z5sYwdJcApYSbzt3gdWJCzgJPF6xR6gsRwcLAKq
        Em+/p4OEeQUsJa4/eskGYQtKnJz5hAXEZhbQlli28DUzxEUKEj+fLmOF2OUnMWvpdnaIGnGJ
        oz97wJ6TEHjBIXFozXGoBheJI3PfMkHYwhKvjm9hh7ClJF72t7GD3CAhkC3Rs8sYIlwjsXTe
        MRYI217iwJU5LCAlzAKaEut36UOs4pPo/f2ECaKTV6KjTQiiWlWi+d1VqE5piYnd3awQJR4S
        fU2iExgVZyH5axaSv2YhuX8Wwq4FjCyrGCVTC4pz01OLTQsM81LL9YoTc4tL89L1kvNzNzGC
        052W5w7Guw8+6B1iZOJgPMQowcGsJMIrKP4wTog3JbGyKrUoP76oNCe1+BCjNAeLkjiv0o8z
        cUIC6YklqdmpqQWpRTBZJg5OqQam9RdPcrwQVpacJqfjY3+z0yDBdPLreQqHnF7mfGHs1U7e
        8PnVPsb5ZUwlry0tnDz0zrzesnrt9C0Xt3vlhc2LMfnv7BRtarIvtU9r/0WHB2ohs6oT1W/m
        uBr++/jpsmfqZZ4tZTE73shps/W91pgyY/2c9uYmD8UNt4V68pXkvoi4da86dccum3XXdVv2
        M8fvf9wYt2ErT/377FMTZ/VelbUsKpwRElsz8cyUN25TK07/EbzbI/Rtj4bsroS9vj1r5k+r
        6vE/84bzv2n1naPpYa5Bcena+w9Miv30T4K5imVtUNfCKx+7GVj3aPheOWL67+1BORG5RIYC
        jqol36y/SOfeW1W+dulJ+w9tTAzxSizFGYmGWsxFxYkAai2nseYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWy7bCSnG6U96M4g3mPGC1e/rzKZvFp/TJW
        i/lHzrFaXHjaw2Zx/vwGdoubW46yWGx6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFv/37GC3
        WLr1JqPFzjsnmB34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4MrYf2wJU8F2wYpJu6azNDCu5eti5OSQEDCRWL/yGVMXIxeH
        kMAORomHt18xQSSkJa5vnMAOYQtLrPz3HMwWEnjFKHGq1Q/EZhPQldixuI0NxBYRqJLoX3Kf
        GWQQs8ANJonrvWtYIBqWMklMXxEBYnMKWEm87d4H1iAs4CTxesUeoGUcHCwCqhJvv6eDhHkF
        LCWuP3rJBmELSpyc+QRsDLOAtkTvw1ZGGHvZwtfMELcpSPx8uowV4gY/iVlLt7ND1IhLHP3Z
        wzyBUXgWklGzkIyahWTULCQtCxhZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525iBEeu
        ltYOxj2rPugdYmTiYDzEKMHBrCTCKyj+ME6INyWxsiq1KD++qDQntfgQozQHi5I479dZC+OE
        BNITS1KzU1MLUotgskwcnFINTJc+KU462sAYnbh/l/GtsrBfe67H14ddkV9SNmX3jpM+y4+1
        P50/WXf6tBkSSz9duBu54SPHv2dRou1cNg97AzUf6qr7bb48+6/j/OwLM5awHc9ln64wWTxs
        Qv5HqxtvgpsfVIcq3nIpLM2+Iqdk8sHuQB9/Xl9IpKfxubMNnWGZ99csa/I6ECzr4vY58oPw
        qf9X4uZHxsrtt1CyvCTH8Opwgs3nl3ui3/N9cIx+7tLm/2aN1yav299n9/76Uf1TZbKr/eSr
        JYJX3L7HFlauPNIUYv/yyCqGF23ZHcdURE86+VxmqjluvTVymYWp/QHlB9bRy3/yRovkHljw
        vHYqi1JjG+cntpolSUe3b5zfVq/EUpyRaKjFXFScCABlCtMASwMAAA==
X-CMS-MailID: 20200611151850epcas5p2a784c542779d9bc1bdcfca28ea8a6c2a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013223epcas5p2be85fa8803326b49a905fb7225992cad
References: <CGME20200528013223epcas5p2be85fa8803326b49a905fb7225992cad@epcas5p2.samsung.com>
        <20200528011658.71590-1-alim.akhtar@samsung.com>
        <159114947915.26776.12485309894552696104.b4-ty@oracle.com>
        <013a01d63d3e$ecf404d0$c6dc0e70$@samsung.com>
        <89b96bd0-a9a3-cdd8-dc67-1f9f49eef264@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kishon

> -----Original Message-----
> From: Kishon Vijay Abraham I <kishon=40ti.com>
> Sent: 08 June 2020 08:23
> To: Alim Akhtar <alim.akhtar=40samsung.com>; 'Martin K. Petersen'
> <martin.petersen=40oracle.com>; robh=40kernel.org
> Cc: krzk=40kernel.org; linux-samsung-soc=40vger.kernel.org;
> avri.altman=40wdc.com; stanley.chu=40mediatek.com; linux-scsi=40vger.kern=
el.org;
> linux-arm-kernel=40lists.infradead.org; cang=40codeaurora.org;
> devicetree=40vger.kernel.org; kwmad.kim=40samsung.com; linux-
> kernel=40vger.kernel.org; 'Vinod Koul' <vkoul=40kernel.org>
> Subject: Re: =5BPATCH v10 00/10=5D exynos-ufs: Add support for UFS HCI
>=20
> Hi Alim,
>=20
> On 6/8/2020 8:15 AM, Alim Akhtar wrote:
> >
> >
> >> -----Original Message-----
> >> From: Martin K. Petersen <martin.petersen=40oracle.com>
> >> Sent: 03 June 2020 08:02
> >> To: robh=40kernel.org; Alim Akhtar <alim.akhtar=40samsung.com>
> >> Cc: Martin K . Petersen <martin.petersen=40oracle.com>;
> >> krzk=40kernel.org;
> > linux-
> >> samsung-soc=40vger.kernel.org; avri.altman=40wdc.com;
> >> stanley.chu=40mediatek.com; linux-scsi=40vger.kernel.org; linux-arm-
> >> kernel=40lists.infradead.org; cang=40codeaurora.org;
> > devicetree=40vger.kernel.org;
> >> kwmad.kim=40samsung.com; linux-kernel=40vger.kernel.org
> >> Subject: Re: =5BPATCH v10 00/10=5D exynos-ufs: Add support for UFS HCI
> >>
> >> On Thu, 28 May 2020 06:46:48 +0530, Alim Akhtar wrote:
> >>
> >>> This patch-set introduces UFS (Universal Flash Storage) host
> >>> controller support for Samsung family SoC. Mostly, it consists of
> >>> UFS PHY and host specific driver.
> >>> =5B...=5D
> >>
> >> Applied =5B1,2,3,4,5,9=5D to 5.9/scsi-queue. The series won't show up =
in
> >> my
> > public
> >> tree until shortly after -rc1 is released.
> >>
> > Thanks Martin,
> > Hi Rob and Kishon/Vinod
> > Can you please pickup dt-bindings and PHY driver respectively?
>=20
> You might have CC'ed me only for the PHY patch. I don't have the dt-bindi=
ngs in
> my inbox. Care to re-send what's missing again? This will be merged after=
 -rc1 is
> tagged.
>=20
Sure, will re-send this series.=20

> Thanks
> Kishon
>=20
> >
> >> Thanks=21
> >>
> >> --
> >> Martin K. Petersen	Oracle Linux Engineering
> >

