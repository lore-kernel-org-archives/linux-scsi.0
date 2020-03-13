Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B92AC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 08:54:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63A9C20749
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 08:54:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="samc0HL6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCMIy3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 04:54:29 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20798 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgCMIy2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 04:54:28 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200313085426epoutp03d22d31be867d48ba81319b5748a2e894~70SiLDZmo2342223422epoutp03G
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 08:54:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200313085426epoutp03d22d31be867d48ba81319b5748a2e894~70SiLDZmo2342223422epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584089666;
        bh=LPXVTDdbTt7huMtADtSo8l+ydeL+imzhQSnd8zJmjo8=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=samc0HL613KwiyAm9rVJWHNtkH4ME+XUpcIuMdGiPrZ76AabqZt3pDuxRi4SSSW0Y
         DPCIzxEYXRfLF9eC9EVbrLKOKJHLn6rb31SLwnzuCtbdwbaFAQx65hqfb8SHHzPy69
         P/8VL66wXUUakcL+WR03xmC/5ojU3ZtSsf3XJ0T4=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200313085425epcas5p357a0b95b3a178dafd5323ee32c0a4c3d~70Sh0aocf2527125271epcas5p3p;
        Fri, 13 Mar 2020 08:54:25 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.6F.04475.14A4B6E5; Fri, 13 Mar 2020 17:54:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200313085425epcas5p1dbff19e6d7be3e440965863db4f66f05~70ShQTPbi3175031750epcas5p1F;
        Fri, 13 Mar 2020 08:54:25 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200313085425epsmtrp253b5e6240224c856c26c57e95aa26a71~70ShPdsIq1633716337epsmtrp2g;
        Fri, 13 Mar 2020 08:54:25 +0000 (GMT)
X-AuditID: b6c32a4a-413ff7000000117b-1b-5e6b4a414c37
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.7E.04215.04A4B6E5; Fri, 13 Mar 2020 17:54:24 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.32]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200313085423epsmtip184fef818285fa1fd795b40cad5fdea57~70Sfxk_dI1078810788epsmtip1y;
        Fri, 13 Mar 2020 08:54:23 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@gmail.com>
Cc:     "'robh+dt'" <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'Can Guo'" <cang@codeaurora.org>
In-Reply-To: <20200313082354.GA7381@pi3>
Subject: RE: [PATCH 0/5] exynos-ufs: Add support for UFS HCI
Date:   Fri, 13 Mar 2020 14:24:22 +0530
Message-ID: <000001d5f914$fee17bf0$fca473d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGyab/2qndBw1eIKE6BH5CEKgcUWwGcomJoAWVZZHIDCTLBPahc+/nQ
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+3bOtuNwcZpT33SZDcw0r5l0AtGMLicxKP8ICbFGnuZ1rs1r
        NwVv6dRKIXCUaeYUEU2xUEsyc4q6HOGNiaZ4SdQSMjJEkTgeJf/7ve/zPt/7vPARmKSH70DE
        qJIYjUoRLxeI8Hef3Vw9g0PiIn1Wslyo6vF71OL6iIBabTTwqZfdg3zKbH4jpCwtRpzSjbUK
        qJreLR6V09EtpKrfWtAZET1UXMSj2/STQrq5Ll9AZ/d9xOlf8+M4XdxSh+jfzU50XqeOd4W4
        LgqIYuJjUhiNd+BNUfTA3zqhOv9w2qv+SjwTTdgXICsCyJMwW68TFiARISHfIyhpNiOuWEWQ
        bV7YKdYQ1DQNY7uWbuMonxM6EFQ+syBWkJBLCKa/e7IsID2htSpXUIAIQkqGw48viWwbIz/w
        oGFUxrIVeQyG+upxlm3IADB9rcLZcZx0gbUKgm2LydOQM2VCHB+AvrI5nHvmOBgql3fiOMP6
        vIHPspS8AN9mLDxuxh6M64UYGxPIx0LYbJrkcYZzUFpYgzi2gaXeFiHHDvB7pWM7MpBxUNju
        x7XvQ3V5D85xEHQOP9+OiZFu0Njuza3aD0UbczzOKYZHuRJu2gWyVkZ2nI7wVKfjc0yDcXkN
        e4KO6Pccpt9zmH7PAfr/yyoQXocOMmptgpLR+qtPqJhUL60iQZusUnrdSkxoRtu/yz2kFRkG
        Q7sQSSC5tdjHLjZSwlekaNMTuhAQmFwq9rGNi5SIoxTpdxlN4g1Ncjyj7UKOBC63F5fwRyIk
        pFKRxMQxjJrR7Ko8wsohE12zRZfaU82WxYdHTT2uZTKnGZnrpvOpiMuxFxcOeczUXp1F9Q+i
        98WoOn09ikK7mDbp1sTZ/j8uES/80vrz2qW3B2QZNZ8UP2uVpiTB8LS/snssdfl8YMOEyfnO
        gkSWIesrxcKt7bKV+WGlepU6fyOi/PW4csqpKThozegZ1irHtdEKX3dMo1X8AwQfR/BZAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWy7bCSnK6DV3acwc65VhZLb1VbvPx5lc3i
        0/plrBbzj5xjtTh/fgO7xc0tR1ksuq/vYLNYfvwfk0Xr3iPsFku33mR04PK43NfL5LFz1l12
        j02rOtk8Wk7uZ/H4+PQWi0ffllWMHp83yXm0H+hmCuCI4rJJSc3JLEst0rdL4Mr4/Mqo4Ixc
        xerLT1kaGOeKdzFyckgImEgcOXqNFcQWEtjNKLH8ATdEXFri+sYJ7BC2sMTKf8+BbC6gmheM
        Eu1zN4E1sAnoSuxY3MYGYosIREicvLEerIhZ4BCTxOw316E63jFKdJ07AVbFKaAhcfnkGhYQ
        W1jARuLMxcVANgcHi4CqxLcFHCBhXgFLidb7ZxghbEGJkzOfgJUzC2hLPL35FM5etvA1M8R1
        ChI/ny5jhTjCTeLeo5tMEDXiEkd/9jBPYBSehWTULCSjZiEZNQtJywJGllWMkqkFxbnpucWG
        BUZ5qeV6xYm5xaV56XrJ+bmbGMFxqKW1g/HEifhDjAIcjEo8vAZiWXFCrIllxZW5hxglOJiV
        RHgNRLPjhHhTEiurUovy44tKc1KLDzFKc7AoifPK5x+LFBJITyxJzU5NLUgtgskycXBKNTBm
        ME4PuuvcVl/4feuDeb9fC2955Wjdvv8Ww6PQq+Lc7xgYX0+btjzvu9hilzx5Rh6fm2ePRMp3
        yEvpfs+erajNzVwir7///p7V88tb2K9IiXA0M3922HJ+qlXcP2nVafHqM6bUPlz8QjlNZLXB
        9sVVmy5YPQq7URcXsSthdxejBH9k+O6HlTJKLMUZiYZazEXFiQDuaPtNvwIAAA==
X-CMS-MailID: 20200313085425epcas5p1dbff19e6d7be3e440965863db4f66f05
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200306151019epcas5p11f5fcf849ece9a808396d9aa3a65410d
References: <CGME20200306151019epcas5p11f5fcf849ece9a808396d9aa3a65410d@epcas5p1.samsung.com>
        <20200306150529.3370-1-alim.akhtar@samsung.com>
        <CAGOxZ50_XwsQ68gqGf1=S=WJJ-pc10h2_J8B4zzU7OMbgJna9A@mail.gmail.com>
        <20200313082354.GA7381@pi3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Krzysztof=20

> -----Original Message-----
> From: Krzysztof Kozlowski <krzk=40kernel.org>
> Sent: 13 March 2020 13:54
> To: Alim Akhtar <alim.akhtar=40gmail.com>
> Cc: Alim Akhtar <alim.akhtar=40samsung.com>; robh+dt <robh+dt=40kernel.or=
g>;
> devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org; Avri Altman
> <avri.altman=40wdc.com>; Martin K. Petersen <martin.petersen=40oracle.com=
>;
> Kiwoong Kim <kwmad.kim=40samsung.com>; Stanley Chu
> <stanley.chu=40mediatek.com>; Can Guo <cang=40codeaurora.org>
> Subject: Re: =5BPATCH 0/5=5D exynos-ufs: Add support for UFS HCI
>=20
> On Fri, Mar 13, 2020 at 06:24:17AM +0530, Alim Akhtar wrote:
> > Ping=21=21=21
>=20
> Hi,
>=20
> Please use the get_maintainers script to get list of Cc addresses. The DT=
S patch
> for example misses the samsung-soc mailing list therefore it is not in th=
e
> patchwork. Patches to ARM/ARM64 Samsung SoC tree go from
> patchwork:
> https://patchwork.kernel.org/project/linux-samsung-soc/list/
>=20
Thanks for pointing that out, sure will add relevant CC and mailing lists. =
Request you to have a look on the patches.

> Best regards,
> Krzysztof
>=20
> >
> >
> > On Fri, Mar 6, 2020 at 8:40 PM Alim Akhtar <alim.akhtar=40samsung.com>
> wrote:
> > >
> > > This patch-set introduces UFS (Universal Flash Storage) host
> > > controller support for Samsung family SoC. Mostly, it consists of UFS=
 PHY
> and host specific driver.
> > >
> > > patch 1/5: define devicetree bindings for UFS PHY patch 2/5: Adds
> > > UFS PHY driver patch 3/5: define devicetree bindings for UFS HCI
> > > patch 4/5: Adds Samsung UFS HCI driver patch 5/5: Enabled UFS on
> > > exynos7 platform
> > >
> > > Note: This series is based on Linux-5.6-rc2
> > >       In past there was couple of attempt to upstream this driver, bu=
t
> > >       it didn't went upstream for some or other reason.
> > >
> > > Alim Akhtar (5):
> > >   dt-bindings: phy: Document Samsung UFS PHY bindings
> > >   phy: samsung-ufs: add UFS PHY driver for samsung SoC
> > >   Documentation: devicetree: ufs: Add DT bindings for exynos UFS host
> > >     controller
> > >   scsi: ufs-exynos: add UFS host support for Exynos SoCs
> > >   arm64: dts: Add node for ufs exynos7
> > >
> > >  .../bindings/phy/samsung,ufs-phy.yaml         =7C   60 +
> > >  .../devicetree/bindings/ufs/ufs-exynos.txt    =7C  104 ++
> > >  .../boot/dts/exynos/exynos7-espresso.dts      =7C   16 +
> > >  arch/arm64/boot/dts/exynos/exynos7.dtsi       =7C   56 +-
> > >  drivers/phy/samsung/Kconfig                   =7C    9 +
> > >  drivers/phy/samsung/Makefile                  =7C    1 +
> > >  drivers/phy/samsung/phy-exynos7-ufs.h         =7C   85 +
> > >  drivers/phy/samsung/phy-samsung-ufs.c         =7C  311 ++++
> > >  drivers/phy/samsung/phy-samsung-ufs.h         =7C  100 ++
> > >  drivers/scsi/ufs/Kconfig                      =7C   12 +
> > >  drivers/scsi/ufs/Makefile                     =7C    1 +
> > >  drivers/scsi/ufs/ufs-exynos.c                 =7C 1399 +++++++++++++=
++++
> > >  drivers/scsi/ufs/ufs-exynos.h                 =7C  268 ++++
> > >  drivers/scsi/ufs/unipro.h                     =7C   41 +
> > >  include/linux/phy/phy-samsung-ufs.h           =7C   70 +
> > >  15 files changed, 2531 insertions(+), 2 deletions(-)  create mode
> > > 100644 Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml
> > >  create mode 100644
> > > Documentation/devicetree/bindings/ufs/ufs-exynos.txt
> > >  create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
> > >  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
> > >  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
> > >  create mode 100644 drivers/scsi/ufs/ufs-exynos.c  create mode
> > > 100644 drivers/scsi/ufs/ufs-exynos.h  create mode 100644
> > > include/linux/phy/phy-samsung-ufs.h
> > >
> > > --
> > > 2.17.1
> > >
> >
> >
> > --
> > Regards,
> > Alim

