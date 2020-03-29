Return-Path: <SRS0=O23q=5O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E422DC2D0EE
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Mar 2020 15:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB66620848
	for <linux-scsi@archiver.kernel.org>; Sun, 29 Mar 2020 15:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ALCITEzk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgC2Pfl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Mar 2020 11:35:41 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60793 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgC2Pfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Mar 2020 11:35:40 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200329153535epoutp026ca096c6b52d4f81fd8eda40c22eaeef~A0FXXiV4b0272302723epoutp02P
        for <linux-scsi@vger.kernel.org>; Sun, 29 Mar 2020 15:35:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200329153535epoutp026ca096c6b52d4f81fd8eda40c22eaeef~A0FXXiV4b0272302723epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585496135;
        bh=QfVFy3V+TocdE8wuBSk9yn+H5ODsvQGcuH2qZqFPEP4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ALCITEzkq5kUg9hQqMD+X3G+96mqtFiM2hT9zJ38q4FW6y5ac7bJ1tjc9gSC2+hgy
         V6mUDLT1sF6hrli1TgWGZct7bXgjp1jvUy/tgvd39l93HD5rAtT8n4Hb5ci+kf0D7H
         22QZQEmPbq6SlfYBGZygskWl/Tz9ix4mDLYAGOg0=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200329153535epcas5p2b6f4c1a6fa03705a4a85816d95702a56~A0FWrzTMi0092600926epcas5p2I;
        Sun, 29 Mar 2020 15:35:35 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        19.16.04736.740C08E5; Mon, 30 Mar 2020 00:35:35 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200329153533epcas5p48d684874dee790f42f71cb36cd51953b~A0FVUYXWm1696016960epcas5p49;
        Sun, 29 Mar 2020 15:35:33 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200329153533epsmtrp1cbdda9f314cfaea0f52c5686ebffc1c6~A0FVTc-3F1818818188epsmtrp1K;
        Sun, 29 Mar 2020 15:35:33 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-8e-5e80c0472d8b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3E.8C.04158.540C08E5; Mon, 30 Mar 2020 00:35:33 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200329153530epsmtip2ca8a44bfaa42ef5fc7e692ae7d56a30d~A0FSTyiY31000010000epsmtip2y;
        Sun, 29 Mar 2020 15:35:30 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     =?UTF-8?Q?'Pawe=C5=82_Chmiel'?= <pawel.mikolaj.chmiel@gmail.com>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Cc:     <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <838a17416b4ed59903ae153e09842ac62584616f.camel@gmail.com>
Subject: RE: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
Date:   Sun, 29 Mar 2020 21:05:28 +0530
Message-ID: <002e01d605df$af658440$0e308cc0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKI+vJzlUBp7WIi19k8pRZBKIHK2gKUSzVAA7h3SyUCe2DDmwIWY0ZDAq0rcFCmjWWzAA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsWy7bCmhq77gYY4g8YTrBYvf15ls/i0fhmr
        xfwj51gtzp/fwG5xc8tRFotNj6+xWlzeNYfNYsb5fUwW3dd3sFksP/6PyeLH8T5mi9a9R9gt
        lm69yejA63G5r5fJY+esu+wem1Z1snlsXlLv0XJyP4vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBn
        FJdNSmpOZllqkb5dAlfGonWLWQuuxFdMuLWGuYGxN7aLkZNDQsBEYsqvHSxdjFwcQgK7GSWm
        TLwA5XxilDjZvpsNwvnGKPF39iR2mJa/UzdCJfYySmw99QzKecMo0bBoGgtIFZuArsSOxW1g
        CRGBWYwSy//9BhvMLNDJJLFm/hRmkCpOAXeJGY0HweYKCzhIPFyxnwnEZhFQlWi/0MUGYvMK
        WEp83b6PHcIWlDg58wnYBmYBbYllC18zQ9ykIPHz6TJWEFtEIEzi0Y897BA14hJHf/YwgyyW
        ENjELrHg8UyoJ1wkZq1ZBtUsLPHq+BaouJTEy/42IJsDyM6W6NllDBGukVg67xgLhG0vceDK
        HBaQEmYBTYn1u/QhVvFJ9P5+wgTRySvR0SYEUa0q0fzuKlSntMTE7m5WCNtDYtvqC6wTGBVn
        IXlsFpLHZiF5YBbCsgWMLKsYJVMLinPTU4tNC4zzUsv1ihNzi0vz0vWS83M3MYKTnZb3DsZN
        53wOMQpwMCrx8H7Y3hAnxJpYVlyZe4hRgoNZSYSXzR8oxJuSWFmVWpQfX1Sak1p8iFGag0VJ
        nHcS69UYIYH0xJLU7NTUgtQimCwTB6dUA2NCcMx9C4l1V5qznVdFHbqr1jvvft3PSjvD5hvT
        7739s8/81A/7FSU19+b+WXzpbWl0VZxcfUKVU5h6il9S4Vcj7Wjuw+l6fp2/g3becBDwrrSw
        PLNwwobJSeqWZVOCnkb9v+3beb/KMcjNni//a3L6Nu9NZzgfzXwnHGkfNU94VdO2NYZXOpRY
        ijMSDbWYi4oTAYeLUJRyAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsWy7bCSvK7rgYY4g38T1S1e/rzKZvFp/TJW
        i/lHzrFanD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNYfvwfk8WP433MFq17j7Bb
        LN16k9GB1+NyXy+Tx85Zd9k9Nq3qZPPYvKTeo+XkfhaPj09vsXj0bVnF6PF5k5xH+4FupgDO
        KC6blNSczLLUIn27BK6MczNmMxdMta9oan7M2sC4zbCLkZNDQsBE4u/UjWxdjFwcQgK7GSV+
        vNnBCpGQlri+cQI7hC0ssfLfc3aIoleMErtXHgYrYhPQldixuA2sW0RgDqPErm0rwTqYBSYz
        SSy9yQ/R8ZhJ4vD5E8wgCU4Bd4kZjQfBioQFHCQertjPBGKzCKhKtF/oYgOxeQUsJb5u38cO
        YQtKnJz5hAViqLZE78NWRhh72cLXzBDnKUj8fLoM7CIRgTCJRz/2QB0hLnH0Zw/zBEbhWUhG
        zUIyahaSUbOQtCxgZFnFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREctVpaOxhPnIg/
        xCjAwajEw/the0OcEGtiWXFl7iFGCQ5mJRFeNn+gEG9KYmVValF+fFFpTmrxIUZpDhYlcV75
        /GORQgLpiSWp2ampBalFMFkmDk6pBkbtJ9nzdr0rkXx/waTw+2npK2+WzGwSiLX88OX/BNNm
        Xk6HyMkG531t7b7tFd13mqV7VsrRbfHXJ/Blbi6dfeTmLF0DgcmFdVLtTzezzcjjP3haVKiw
        OMwmpfTaBY7Lko1br2yJv5IivGHCOm//Z/e4ZbIeXbRc5v/WfM0tzh8h6XG5N/cF38hSYinO
        SDTUYi4qTgQAdMjxrNYCAAA=
X-CMS-MailID: 20200329153533epcas5p48d684874dee790f42f71cb36cd51953b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
        <CGME20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a@epcas5p4.samsung.com>
        <20200327170638.17670-6-alim.akhtar@samsung.com>
        <ac67cfc3736cf50c716b823a59af878d59b7198f.camel@gmail.com>
        <000801d60516$823fd890$86bf89b0$@samsung.com>
        <838a17416b4ed59903ae153e09842ac62584616f.camel@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Pawel

> -----Original Message-----
> From: Pawe=C5=82=20Chmiel=20<pawel.mikolaj.chmiel=40gmail.com>=0D=0A>=20S=
ent:=2028=20March=202020=2023:17=0D=0A>=20To:=20Alim=20Akhtar=20<alim.akhta=
r=40samsung.com>;=20robh+dt=40kernel.org;=0D=0A>=20devicetree=40vger.kernel=
.org;=20linux-scsi=40vger.kernel.org=0D=0A>=20Cc:=20krzk=40kernel.org;=20av=
ri.altman=40wdc.com;=20martin.petersen=40oracle.com;=0D=0A>=20kwmad.kim=40s=
amsung.com;=20stanley.chu=40mediatek.com;=0D=0A>=20cang=40codeaurora.org;=
=20linux-samsung-soc=40vger.kernel.org;=20linux-arm-=0D=0A>=20kernel=40list=
s.infradead.org;=20linux-kernel=40vger.kernel.org=0D=0A>=20Subject:=20Re:=
=20=5BPATCH=20v4=205/5=5D=20arm64:=20dts:=20Add=20node=20for=20ufs=20exynos=
7=0D=0A>=20=0D=0A>=20On=20Sat,=202020-03-28=20at=2021:05=20+0530,=20Alim=20=
Akhtar=20wrote:=0D=0A>=20>=20Hi=20Pawel=0D=0A>=20>=0D=0A>=20>=20>=20-----Or=
iginal=20Message-----=0D=0A>=20>=20>=20From:=20Pawe=C5=82=20Chmiel=20<pawel=
.mikolaj.chmiel=40gmail.com>=0D=0A>=20>=20>=20Sent:=2028=20March=202020=201=
9:00=0D=0A>=20>=20>=20To:=20Alim=20Akhtar=20<alim.akhtar=40samsung.com>;=20=
robh+dt=40kernel.org;=0D=0A>=20>=20>=20devicetree=40vger.kernel.org;=20linu=
x-scsi=40vger.kernel.org=0D=0A>=20>=20>=20Cc:=20krzk=40kernel.org;=20avri.a=
ltman=40wdc.com;=0D=0A>=20>=20>=20martin.petersen=40oracle.com;=20kwmad.kim=
=40samsung.com;=0D=0A>=20>=20>=20stanley.chu=40mediatek.com;=20cang=40codea=
urora.org;=0D=0A>=20>=20>=20linux-samsung-soc=40vger.kernel.org;=20linux-ar=
m-=0D=0A>=20>=20>=20kernel=40lists.infradead.org;=20linux-kernel=40vger.ker=
nel.org=0D=0A>=20>=20>=20Subject:=20Re:=20=5BPATCH=20v4=205/5=5D=20arm64:=
=20dts:=20Add=20node=20for=20ufs=20exynos7=0D=0A>=20>=20>=0D=0A>=20>=20>=20=
On=20Fri,=202020-03-27=20at=2022:36=20+0530,=20Alim=20Akhtar=20wrote:=0D=0A=
>=20>=20>=20>=20Adding=20dt=20node=20foe=20UFS=20and=20UFS-PHY=20for=20exyn=
os7=20SoC.=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20Signed-off-by:=20Alim=20=
Akhtar=20<alim.akhtar=40samsung.com>=0D=0A>=20>=20>=20>=20---=0D=0A>=20>=20=
>=20>=20=20.../boot/dts/exynos/exynos7-espresso.dts=20=20=20=20=20=20=7C=20=
16=20+++++++=0D=0A>=20>=20>=20>=20=20arch/arm64/boot/dts/exynos/exynos7.dts=
i=20=20=20=20=20=20=20=7C=2043=20++++++++++++++++++-=0D=0A>=20>=20>=20>=20=
=202=20files=20changed,=2057=20insertions(+),=202=20deletions(-)=0D=0A>=20>=
=20>=20>=0D=0A>=20>=20>=20>=20diff=20--git=20a/arch/arm64/boot/dts/exynos/e=
xynos7-espresso.dts=0D=0A>=20>=20>=20>=20b/arch/arm64/boot/dts/exynos/exyno=
s7-espresso.dts=0D=0A>=20>=20>=20>=20index=207af288fa9475..b59a0a32620a=201=
00644=0D=0A>=20>=20>=20>=20---=20a/arch/arm64/boot/dts/exynos/exynos7-espre=
sso.dts=0D=0A>=20>=20>=20>=20+++=20b/arch/arm64/boot/dts/exynos/exynos7-esp=
resso.dts=0D=0A>=20>=20>=20>=20=40=40=20-406,6=20+406,22=20=40=40=0D=0A>=20=
>=20>=20>=20=20=09=7D;=0D=0A>=20>=20>=20>=20=20=7D;=0D=0A>=20>=20>=20>=0D=
=0A>=20>=20>=20>=20+&ufs=20=7B=0D=0A>=20>=20>=20>=20+=09status=20=3D=20=22o=
kay=22;=0D=0A>=20>=20>=20>=20+=09pinctrl-names=20=3D=20=22default=22;=0D=0A=
>=20>=20>=20>=20+=09pinctrl-0=20=3D=20<&ufs_rst_n=20&ufs_refclk_out>;=0D=0A=
>=20>=20>=20>=20+=09ufs,pwr-attr-mode=20=3D=20=22FAST=22;=0D=0A>=20>=20>=20=
>=20+=09ufs,pwr-attr-lane=20=3D=20<2>;=0D=0A>=20>=20>=20>=20+=09ufs,pwr-att=
r-gear=20=3D=20<2>;=0D=0A>=20>=20>=20>=20+=09ufs,pwr-attr-hs-series=20=3D=
=20=22HS_rate_b=22;=0D=0A>=20>=20>=20>=20+=09ufs-rx-adv-fine-gran-sup_en=20=
=3D=20<1>;=0D=0A>=20>=20>=20>=20+=09ufs-rx-adv-fine-gran-step=20=3D=20<3>;=
=0D=0A>=20>=20>=20>=20+=09ufs-rx-adv-min-activate-time-cap=20=3D=20<9>;=0D=
=0A>=20>=20>=20>=20+=09ufs-pa-granularity=20=3D=20<6>;=0D=0A>=20>=20>=20>=
=20+=09ufs-pa-tacctivate=20=3D=20<3>;=0D=0A>=20>=20>=20>=20+=09ufs-pa-hiber=
n8time=20=3D=20<20>;=0D=0A>=20>=20>=20>=20+=7D;=0D=0A>=20>=20>=20>=20+=0D=
=0A>=20>=20>=20>=20=20&usbdrd_phy=20=7B=0D=0A>=20>=20>=20>=20=20=09vbus-sup=
ply=20=3D=20<&usb30_vbus_reg>;=0D=0A>=20>=20>=20>=20=20=09vbus-boost-supply=
=20=3D=20<&usb3drd_boost_5v>;=20diff=20--git=0D=0A>=20>=20>=20>=20a/arch/ar=
m64/boot/dts/exynos/exynos7.dtsi=0D=0A>=20>=20>=20>=20b/arch/arm64/boot/dts=
/exynos/exynos7.dtsi=0D=0A>=20>=20>=20>=20index=205558045637ac..9d16c90edd0=
7=20100644=0D=0A>=20>=20>=20>=20---=20a/arch/arm64/boot/dts/exynos/exynos7.=
dtsi=0D=0A>=20>=20>=20>=20+++=20b/arch/arm64/boot/dts/exynos/exynos7.dtsi=
=0D=0A>=20>=20>=20>=20=40=40=20-220,9=20+220,14=20=40=40=0D=0A>=20>=20>=20>=
=20=20=09=09=09=23clock-cells=20=3D=20<1>;=0D=0A>=20>=20>=20>=20=20=09=09=
=09clocks=20=3D=20<&fin_pll>,=20<&clock_top1=0D=0A>=20>=20>=20DOUT_ACLK_FSY=
S1_200>,=0D=0A>=20>=20>=20>=20=20=09=09=09=09=20<&clock_top1=20DOUT_SCLK_MM=
C0>,=0D=0A>=20>=20>=20>=20-=09=09=09=09=20<&clock_top1=20DOUT_SCLK_MMC1>;=
=0D=0A>=20>=20>=20>=20+=09=09=09=09=20<&clock_top1=20DOUT_SCLK_MMC1>,=0D=0A=
>=20>=20>=20>=20+=09=09=09=09=20<&clock_top1=20DOUT_SCLK_UFSUNIPRO20>,=0D=
=0A>=20>=20>=20>=20+=09=09=09=09=20<&clock_top1=20DOUT_SCLK_PHY_FSYS1>,=0D=
=0A>=20>=20>=20>=20+=09=09=09=09=20<&clock_top1=20DOUT_SCLK_PHY_FSYS1_26M>;=
=0D=0A>=20>=20>=20>=20=20=09=09=09clock-names=20=3D=20=22fin_pll=22,=20=22d=
out_aclk_fsys1_200=22,=0D=0A>=20>=20>=20>=20-=09=09=09=09=20=20=20=20=20=20=
=22dout_sclk_mmc0=22,=20=22dout_sclk_mmc1=22;=0D=0A>=20>=20>=20>=20+=09=09=
=09=09=20=20=20=20=20=20=22dout_sclk_mmc0=22,=20=22dout_sclk_mmc1=22,=0D=0A=
>=20>=20>=20>=20+=09=09=09=09=20=20=20=20=20=20=22dout_sclk_ufsunipro20=22,=
=0D=0A>=20>=20>=20=22dout_sclk_phy_fsys1=22,=0D=0A>=20>=20>=20>=20+=09=09=
=09=09=20=20=20=20=20=20=22dout_sclk_phy_fsys1_26m=22;=0D=0A>=20>=20>=20>=
=20=20=09=09=7D;=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20=20=09=09serial_0:=
=20serial=4013630000=20=7B=0D=0A>=20>=20>=20>=20=40=40=20-601,6=20+606,40=
=20=40=40=0D=0A>=20>=20>=20>=20=20=09=09=09=7D;=0D=0A>=20>=20>=20>=20=20=09=
=09=7D;=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20+=09=09ufs:=20ufs=401557000=
0=20=7B=0D=0A>=20>=20>=20>=20+=09=09=09compatible=20=3D=20=22samsung,exynos=
7-ufs=22;=0D=0A>=20>=20>=20>=20+=09=09=09=23address-cells=20=3D=20<1>;=0D=
=0A>=20>=20>=20>=20+=09=09=09=23size-cells=20=3D=20<1>;=0D=0A>=20>=20>=20>=
=20+=09=09=09ranges;=0D=0A>=20>=20>=20>=20+=09=09=09reg=20=3D=20<0x15570000=
=200x100>,=20=20/*=200:=20HCI=20standard=20*/=0D=0A>=20>=20>=20>=20+=09=09=
=09=09<0x15570100=200x100>,=20=20/*=201:=20Vendor=20specificed=0D=0A>=20>=
=20>=20*/=0D=0A>=20>=20>=20>=20+=09=09=09=09<0x15571000=200x200>,=20=20/*=
=202:=20UNIPRO=20*/=0D=0A>=20>=20>=20>=20+=09=09=09=09<0x15572000=200x300>;=
=20=20/*=203:=20UFS=20protector=20*/=0D=0A>=20>=20>=20>=20+=09=09=09reg-nam=
es=20=3D=20=22hci=22,=20=22vs_hci=22,=20=22unipro=22,=20=22ufsp=22;=0D=0A>=
=20>=20>=20>=20+=09=09=09interrupts=20=3D=20<GIC_SPI=20200=20IRQ_TYPE_LEVEL=
_HIGH>;=0D=0A>=20>=20>=20>=20+=09=09=09clocks=20=3D=20<&clock_fsys1=20ACLK_=
UFS20_LINK>,=0D=0A>=20>=20>=20>=20+=09=09=09=09<&clock_fsys1=20SCLK_UFSUNIP=
RO20_USER>;=0D=0A>=20>=20>=20>=20+=09=09=09clock-names=20=3D=20=22core_clk=
=22,=20=22sclk_unipro_main=22;=0D=0A>=20>=20>=20>=20+=09=09=09freq-table-hz=
=20=3D=20<0=200>,=20<0=200>;=0D=0A>=20>=20>=20>=20+=09=09=09pclk-freq-avail=
-range=20=3D=20<70000000=20133000000>;=0D=0A>=20>=20>=20>=20+=09=09=09ufs,p=
wr-local-l2-timer=20=3D=20<8000=2028000=2020000>;=0D=0A>=20>=20>=20>=20+=09=
=09=09ufs,pwr-remote-l2-timer=20=3D=20<12000=2032000=2016000>;=0D=0A>=20>=
=20>=20>=20+=09=09=09phys=20=3D=20<&ufs_phy>;=0D=0A>=20>=20>=20>=20+=09=09=
=09phy-names=20=3D=20=22ufs-phy=22;=0D=0A>=20>=20>=20>=20+=09=09=09status=
=20=3D=20=22disabled=22;=0D=0A>=20>=20>=20>=20+=09=09=7D;=0D=0A>=20>=20>=20=
>=20+=0D=0A>=20>=20>=20>=20+=09=09ufs_phy:=20ufs-phy=400x15571800=20=7B=0D=
=0A>=20>=20>=20>=20+=09=09=09compatible=20=3D=20=22samsung,exynos7-ufs-phy=
=22;=0D=0A>=20>=20>=20>=20+=09=09=09reg=20=3D=20<0x15571800=200x240>;=0D=0A=
>=20>=20>=20>=20+=09=09=09reg-names=20=3D=20=22phy-pma=22;=0D=0A>=20>=20>=
=20>=20+=09=09=09samsung,pmu-syscon=20=3D=20<&pmu_system_controller>;=0D=0A=
>=20>=20>=20>=20+=09=09=09=23phy-cells=20=3D=20<0>;=0D=0A>=20>=20>=20>=20+=
=09=09=09clocks=20=3D=20<&clock_fsys1=20MOUT_FSYS1_PHYCLK_SEL1>,=0D=0A>=20>=
=20>=20>=20+=09=09=09=09<&clock_top1=20CLK_SCLK_PHY_FSYS1_26M>;=0D=0A>=20>=
=20>=20>=20+=09=09=09clock-names=20=3D=20=22ref_clk_parent=22,=20=22ref_clk=
=22;=0D=0A>=20>=20>=20Hi=0D=0A>=20>=20>=20Is=20this=20correct=20(aren't=20c=
hild=20and=20parent=20clock=20swapped)?=0D=0A>=20>=20>=20This=20will=20set=
=20MOUT_FSYS1_PHYCLK_SEL1=20to=20be=20parent=20clock=20of=0D=0A>=20>=20>=20=
CLK_SCLK_PHY_FSYS1_26M.=0D=0A>=20>=0D=0A>=20>=20Looks=20like=20in=20one=20o=
f=20my=20rebase=20it=20got=20swap,=20will=20correct=20it.=20=20Thanks=20for=
=20pointing=0D=0A>=20out.=0D=0A>=20>=0D=0A>=20>=20>=20I've=20tested=20this=
=20on=20Exynos7420=20(which=20looks=20like=20can=20use=20the=20same=0D=0A>=
=20>=20>=20clock=20driver=20as=0D=0A>=20>=20>=20exynos7)=20and=20after=20ad=
ding=20some=20debug=20code=20(because=20currently=20we're=0D=0A>=20>=20>=20=
not=20handling=20result=20of=20samsung_ufs_phy_clks_init)=20i=20got=0D=0A>=
=20>=20>=0D=0A>=20>=20>=20samsung-ufs-phy=2015571800.ufs-phy:=20clk_set_par=
ent=20result:=20-22=0D=0A>=20>=20>=0D=0A>=20>=20I=20will=20check=20if=20I=
=20overlooked=20this=20error.=0D=0A>=20>=20>=20On=20vendor=20sources=20for=
=20this=20device,=20driver=20was=20setting=0D=0A>=20>=20>=20CLK_SCLK_PHY_FS=
YS1_26M=20to=20be=20parent=20of=20MOUT_FSYS1_PHYCLK_SEL1,=0D=0A>=20and=20th=
en=20it=20did=20run=20without=20error.=0D=0A>=20>=20>=0D=0A>=20>=20>=20sams=
ung-ufs-phy=2015571800.ufs-phy:=20clk_set_parent=20result:=200=0D=0A>=20>=
=20>=0D=0A>=20>=20With=20this=20change,=20does=20linkup=20worked=20for=20yo=
u?=0D=0A>=20Hi=0D=0A>=20Sadly=20not=20yet,=20so=20someone=20needs=20to=20ch=
eck=20it=20on=20different=20hw.=0D=0A>=20=0D=0A>=20I've=20added=20some=20de=
bug=20code=20to=20ufshcd=20and=20it=20looks=20like=20it=20fails=20(in=20my=
=0D=0A>=20case)=20at=20ufshcd_dme_link_startup=20which=20returns=201=20(bec=
ause=0D=0A>=20ufshcd_wait_for_uic_cmd=20returns=201).=20The=20same=20for=20=
second=20retry=20and=20at=20third=0D=0A>=20retry=20it's=20getting=20-110=20=
from=20ufshcd_wait_for_uic_cmd.=0D=0A>=20=0D=0AMostly=20device=20is=20not=
=20responding=20to=20any=20UIC=20commands.=0D=0A=0D=0A>=20Need=20to=20check=
:=0D=0A>=20-=20in=20vendor=20there=20was=2010=20clocks=20used=20by=20ufs/uf=
s-phy=20(where=20this=20driver=20uses=204)=0D=0A>=20-=20if=20calibration=20=
is=20the=20same=20in=20this=20driver=20vs=20vendor=0D=0A>=20=0D=0AAll=20clo=
cks=20are=20not=20mandatory,=20what=20I=20have=20mentioned=20is=20only=20UF=
S=20HCI=20core=20clock,=20unipro=20clock=20and=20MPHY=20clocks.=0D=0A=0D=0A=
>=20Maybe=20it's=20because=20of=20missing=20EXYNOS=20FMP=20Driver=20(my=20d=
evice=20has=0D=0A>=20secureos)=20and/or=20some=20missing=20smc=20calls=20(l=
ike=20in=20case=20of=20smu=20config)?=0D=0AFMP=20will=20come=20into=20pictu=
re=20a=20little=20later,=20it=20does=20not=20affect=20_link_startup=20thoug=
h.=0D=0ASMU=20does=20matter,=20so=20make=20sure=20SMU=20is=20by=20passed=20=
initially.=0D=0A=0D=0AAnother=20think=20that=20comes=20into=20my=20mind=20i=
s,=20if=20possible=20just=20disabled=20PMIC=20(intension=20is=20to=20keep=
=20all=20the=20rails=20__always_on__)=0D=0AThe=20reason=20is=20sometime=20U=
FS_RST_N=20which=20is=20hooked=20to=20RESET_N=20of=20the=20UFS=20device=20i=
s=20also=20controlled=20via=20one=20of=20the=20PMIC=20LDO.=0D=0A(In=20your=
=20case=20I=20don't=20know=20which=20LDO,=20so=20keep=20all=20the=20rails=
=20always=20ON).=0D=0AAlso=20cross=20check=20if=20you=20have=20these=20gpio=
s=20configured=20properly.=0D=0Apinctrl-0=20=3D=20<&ufs_rst_n=20&ufs_refclk=
_out>;=0D=0AGive=20it=20a=20try.=0D=0A=0D=0A=0D=0A>=20>=0D=0A>=20>=20>=20Al=
so=20looking=20at=20clk-exynos7=20driver=20seems=20to=20confirm=20this.=0D=
=0A>=20>=20>=0D=0A>=20>=20>=20>=20+=09=09=7D;=0D=0A>=20>=20>=20>=20+=0D=0A>=
=20>=20>=20>=20=20=09=09usbdrd_phy:=20phy=4015500000=20=7B=0D=0A>=20>=20>=
=20>=20=20=09=09=09compatible=20=3D=20=22samsung,exynos7-usbdrd-phy=22;=0D=
=0A>=20>=20>=20>=20=20=09=09=09reg=20=3D=20<0x15500000=200x100>;=0D=0A>=20>=
=0D=0A>=20>=0D=0A=0D=0A=0D=0A
