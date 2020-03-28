Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30A9C2D0E5
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 15:35:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79A9A2073B
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 15:35:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kTaPhZun"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgC1Pfe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Mar 2020 11:35:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14548 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgC1Pfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Mar 2020 11:35:33 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200328153530epoutp027dbeb1250c02e25792119924982b3b1b~AgcAbt1jS1821218212epoutp02S
        for <linux-scsi@vger.kernel.org>; Sat, 28 Mar 2020 15:35:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200328153530epoutp027dbeb1250c02e25792119924982b3b1b~AgcAbt1jS1821218212epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585409730;
        bh=xXkS91CFIroc7N2oaXEl9fLdr7tUf9+UutE4IeIiJjE=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=kTaPhZunPQsCM4rmqY22CKktKSkDU0r9LIdFCtBCtl356eDEiCCj6yZRu/uVjCMk5
         zHbmSwo14yIP31EI57vsJTg3wGmv/5wuEweDQEkupsGiO6PximGl2DYiYZfsEBbpDS
         3CoNnKiWpv8mqVtb0oIteFxJBQVGVEBP/an90N7o=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200328153529epcas5p32df5f14a80ca6f26d57289c7edd8f28c~Agb-PCBe01221612216epcas5p3i;
        Sat, 28 Mar 2020 15:35:29 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5D.B7.04778.1CE6F7E5; Sun, 29 Mar 2020 00:35:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200328153528epcas5p4d1a6bc160d439101a3d5f3c43f40b1e2~Agb_XBtCF1572915729epcas5p44;
        Sat, 28 Mar 2020 15:35:28 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200328153528epsmtrp18aa344e9aee5444064d301fbea5fc683~Agb_WJYU43038730387epsmtrp1Q;
        Sat, 28 Mar 2020 15:35:28 +0000 (GMT)
X-AuditID: b6c32a4a-33bff700000012aa-55-5e7f6ec1c85f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.86.04024.0CE6F7E5; Sun, 29 Mar 2020 00:35:28 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200328153525epsmtip1915a6f448bb9b6b4b27ef259c4ac617a~Agb7Y5kWE1061810618epsmtip1P;
        Sat, 28 Mar 2020 15:35:25 +0000 (GMT)
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
In-Reply-To: <ac67cfc3736cf50c716b823a59af878d59b7198f.camel@gmail.com>
Subject: RE: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
Date:   Sat, 28 Mar 2020 21:05:23 +0530
Message-ID: <000801d60516$823fd890$86bf89b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKI+vJzlUBp7WIi19k8pRZBKIHK2gKUSzVAA7h3SyUCe2DDm6ax9Wig
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLKsWRmVeSWpSXmKPExsWy7bCmuu7BvPo4g48bFC1e/rzKZvFp/TJW
        i/lHzrFanD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNYfvwfk8WP433MFq17j7Bb
        LN16k9GB1+NyXy+Tx85Zd9k9Nq3qZPPYvKTeo+XkfhaPj09vsXj0bVnF6PF5k5xH+4FupgDO
        KC6blNSczLLUIn27BK6MfWe2MBXssq+4fW8tYwPjXdsuRg4OCQETid23IroYuTiEBHYzSmzZ
        c5oJwvnEKNH59yYzhPONUeLG7G6gDCdYx9rfbVBVexklpi7awAaSEBJ4A1R10hzEZhPQldix
        uI0NpEhEYBajxPJ/v1lAHGaBTiaJNfOnMINUcQq4Sxx+84gVxBYWcJB4uGI/2AoWAVWJLds2
        gdm8ApYSF27OYYOwBSVOznzCAmIzC2hLLFv4mhniJAWJn0+Xgc0REXCTODlnMhtEjbjE0Z89
        YD9ICGxil2g5Op0VosFFYueOt1DNwhKvjm9hh7ClJF72t7FDQiZbomeXMUS4RmLpvGMsELa9
        xIErc1hASpgFNCXW79KHWMUn0fv7CRNEJ69ER5sQRLWqRPO7q1Cd0hITu7uhDvCQ2Lb6AusE
        RsVZSB6bheSxWUgemIWwbAEjyypGydSC4tz01GLTAqO81HK94sTc4tK8dL3k/NxNjOBEp+W1
        g3HZOZ9DjAIcjEo8vCuu1sYJsSaWFVfmHmKU4GBWEuF9GlkTJ8SbklhZlVqUH19UmpNafIhR
        moNFSZx3EuvVGCGB9MSS1OzU1ILUIpgsEwenVAPjmtcbjqZnHnO7lbjg83/O/VF/Z73+2FTu
        0HYqWkTxRM4qpp95S/17bP9nrvKe1uaicXxbWv3zeRPDbrj8SrwduPdH4lWZ1a1bvPXU7HWO
        93/dvpVpi9eyZ54NfmrpszszHjDMe5yetejF613np6VYnS5XLrumt2Yv6zLT64piPHGvYj9m
        L/8apsRSnJFoqMVcVJwIAFqMt/xwAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWy7bCSnO6BvPo4g7sPVC1e/rzKZvFp/TJW
        i/lHzrFanD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNYfvwfk8WP433MFq17j7Bb
        LN16k9GB1+NyXy+Tx85Zd9k9Nq3qZPPYvKTeo+XkfhaPj09vsXj0bVnF6PF5k5xH+4FupgDO
        KC6blNSczLLUIn27BK6MGx/2MBWc1arYeSepgbFJqYuRk0NCwERi7e82pi5GLg4hgd2MEqu2
        32CHSEhLXN84AcoWllj57zmYLSTwilHibr8iiM0moCuxY3EbG0iziMAcRold21aCFTELTGaS
        WHqTH2LqL0aJV/NvsIAkOAXcJQ6/ecQKYgsLOEg8XLGfCcRmEVCV2LJtE5jNK2ApceHmHDYI
        W1Di5MwnLBBDtSV6H7YywtjLFr5mhrhOQeLn02VgM0UE3CROzpnMBlEjLnH0Zw/zBEbhWUhG
        zUIyahaSUbOQtCxgZFnFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREcsVqaOxgvL4k/
        xCjAwajEw6sxsS5OiDWxrLgy9xCjBAezkgjv08iaOCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
        T/OORQoJpCeWpGanphakFsFkmTg4pRoYnXvWy/kfClxuu/NWqczla/c+Fb5c8Ho108+3GkrZ
        NslbL1d+ur/6UpVlneP5OSYvXrS/C74bVZpofu7rJVEdlW8KDz/7vjz3NPq0YTK3/7RFdzgj
        D/QrLWbL3zifrSZjh6ZBneGkOw8nOHZVSydZPDA9vm6WbI/UE72Ps/NP851gmGByX0GXV4ml
        OCPRUIu5qDgRACEO/bnUAgAA
X-CMS-MailID: 20200328153528epcas5p4d1a6bc160d439101a3d5f3c43f40b1e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
        <CGME20200327171423epcas5p485d227f19e45999ad9b42b21d2864e4a@epcas5p4.samsung.com>
        <20200327170638.17670-6-alim.akhtar@samsung.com>
        <ac67cfc3736cf50c716b823a59af878d59b7198f.camel@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Pawel

> -----Original Message-----
> From: Pawe=C5=82=20Chmiel=20<pawel.mikolaj.chmiel=40gmail.com>=0D=0A>=20S=
ent:=2028=20March=202020=2019:00=0D=0A>=20To:=20Alim=20Akhtar=20<alim.akhta=
r=40samsung.com>;=20robh+dt=40kernel.org;=0D=0A>=20devicetree=40vger.kernel=
.org;=20linux-scsi=40vger.kernel.org=0D=0A>=20Cc:=20krzk=40kernel.org;=20av=
ri.altman=40wdc.com;=20martin.petersen=40oracle.com;=0D=0A>=20kwmad.kim=40s=
amsung.com;=20stanley.chu=40mediatek.com;=0D=0A>=20cang=40codeaurora.org;=
=20linux-samsung-soc=40vger.kernel.org;=20linux-arm-=0D=0A>=20kernel=40list=
s.infradead.org;=20linux-kernel=40vger.kernel.org=0D=0A>=20Subject:=20Re:=
=20=5BPATCH=20v4=205/5=5D=20arm64:=20dts:=20Add=20node=20for=20ufs=20exynos=
7=0D=0A>=20=0D=0A>=20On=20Fri,=202020-03-27=20at=2022:36=20+0530,=20Alim=20=
Akhtar=20wrote:=0D=0A>=20>=20Adding=20dt=20node=20foe=20UFS=20and=20UFS-PHY=
=20for=20exynos7=20SoC.=0D=0A>=20>=0D=0A>=20>=20Signed-off-by:=20Alim=20Akh=
tar=20<alim.akhtar=40samsung.com>=0D=0A>=20>=20---=0D=0A>=20>=20=20.../boot=
/dts/exynos/exynos7-espresso.dts=20=20=20=20=20=20=7C=2016=20+++++++=0D=0A>=
=20>=20=20arch/arm64/boot/dts/exynos/exynos7.dtsi=20=20=20=20=20=20=20=7C=
=2043=20++++++++++++++++++-=0D=0A>=20>=20=202=20files=20changed,=2057=20ins=
ertions(+),=202=20deletions(-)=0D=0A>=20>=0D=0A>=20>=20diff=20--git=20a/arc=
h/arm64/boot/dts/exynos/exynos7-espresso.dts=0D=0A>=20>=20b/arch/arm64/boot=
/dts/exynos/exynos7-espresso.dts=0D=0A>=20>=20index=207af288fa9475..b59a0a3=
2620a=20100644=0D=0A>=20>=20---=20a/arch/arm64/boot/dts/exynos/exynos7-espr=
esso.dts=0D=0A>=20>=20+++=20b/arch/arm64/boot/dts/exynos/exynos7-espresso.d=
ts=0D=0A>=20>=20=40=40=20-406,6=20+406,22=20=40=40=0D=0A>=20>=20=20=09=7D;=
=0D=0A>=20>=20=20=7D;=0D=0A>=20>=0D=0A>=20>=20+&ufs=20=7B=0D=0A>=20>=20+=09=
status=20=3D=20=22okay=22;=0D=0A>=20>=20+=09pinctrl-names=20=3D=20=22defaul=
t=22;=0D=0A>=20>=20+=09pinctrl-0=20=3D=20<&ufs_rst_n=20&ufs_refclk_out>;=0D=
=0A>=20>=20+=09ufs,pwr-attr-mode=20=3D=20=22FAST=22;=0D=0A>=20>=20+=09ufs,p=
wr-attr-lane=20=3D=20<2>;=0D=0A>=20>=20+=09ufs,pwr-attr-gear=20=3D=20<2>;=
=0D=0A>=20>=20+=09ufs,pwr-attr-hs-series=20=3D=20=22HS_rate_b=22;=0D=0A>=20=
>=20+=09ufs-rx-adv-fine-gran-sup_en=20=3D=20<1>;=0D=0A>=20>=20+=09ufs-rx-ad=
v-fine-gran-step=20=3D=20<3>;=0D=0A>=20>=20+=09ufs-rx-adv-min-activate-time=
-cap=20=3D=20<9>;=0D=0A>=20>=20+=09ufs-pa-granularity=20=3D=20<6>;=0D=0A>=
=20>=20+=09ufs-pa-tacctivate=20=3D=20<3>;=0D=0A>=20>=20+=09ufs-pa-hibern8ti=
me=20=3D=20<20>;=0D=0A>=20>=20+=7D;=0D=0A>=20>=20+=0D=0A>=20>=20=20&usbdrd_=
phy=20=7B=0D=0A>=20>=20=20=09vbus-supply=20=3D=20<&usb30_vbus_reg>;=0D=0A>=
=20>=20=20=09vbus-boost-supply=20=3D=20<&usb3drd_boost_5v>;=20diff=20--git=
=0D=0A>=20>=20a/arch/arm64/boot/dts/exynos/exynos7.dtsi=0D=0A>=20>=20b/arch=
/arm64/boot/dts/exynos/exynos7.dtsi=0D=0A>=20>=20index=205558045637ac..9d16=
c90edd07=20100644=0D=0A>=20>=20---=20a/arch/arm64/boot/dts/exynos/exynos7.d=
tsi=0D=0A>=20>=20+++=20b/arch/arm64/boot/dts/exynos/exynos7.dtsi=0D=0A>=20>=
=20=40=40=20-220,9=20+220,14=20=40=40=0D=0A>=20>=20=20=09=09=09=23clock-cel=
ls=20=3D=20<1>;=0D=0A>=20>=20=20=09=09=09clocks=20=3D=20<&fin_pll>,=20<&clo=
ck_top1=0D=0A>=20DOUT_ACLK_FSYS1_200>,=0D=0A>=20>=20=20=09=09=09=09=20<&clo=
ck_top1=20DOUT_SCLK_MMC0>,=0D=0A>=20>=20-=09=09=09=09=20<&clock_top1=20DOUT=
_SCLK_MMC1>;=0D=0A>=20>=20+=09=09=09=09=20<&clock_top1=20DOUT_SCLK_MMC1>,=
=0D=0A>=20>=20+=09=09=09=09=20<&clock_top1=20DOUT_SCLK_UFSUNIPRO20>,=0D=0A>=
=20>=20+=09=09=09=09=20<&clock_top1=20DOUT_SCLK_PHY_FSYS1>,=0D=0A>=20>=20+=
=09=09=09=09=20<&clock_top1=20DOUT_SCLK_PHY_FSYS1_26M>;=0D=0A>=20>=20=20=09=
=09=09clock-names=20=3D=20=22fin_pll=22,=20=22dout_aclk_fsys1_200=22,=0D=0A=
>=20>=20-=09=09=09=09=20=20=20=20=20=20=22dout_sclk_mmc0=22,=20=22dout_sclk=
_mmc1=22;=0D=0A>=20>=20+=09=09=09=09=20=20=20=20=20=20=22dout_sclk_mmc0=22,=
=20=22dout_sclk_mmc1=22,=0D=0A>=20>=20+=09=09=09=09=20=20=20=20=20=20=22dou=
t_sclk_ufsunipro20=22,=0D=0A>=20=22dout_sclk_phy_fsys1=22,=0D=0A>=20>=20+=
=09=09=09=09=20=20=20=20=20=20=22dout_sclk_phy_fsys1_26m=22;=0D=0A>=20>=20=
=20=09=09=7D;=0D=0A>=20>=0D=0A>=20>=20=20=09=09serial_0:=20serial=401363000=
0=20=7B=0D=0A>=20>=20=40=40=20-601,6=20+606,40=20=40=40=0D=0A>=20>=20=20=09=
=09=09=7D;=0D=0A>=20>=20=20=09=09=7D;=0D=0A>=20>=0D=0A>=20>=20+=09=09ufs:=
=20ufs=4015570000=20=7B=0D=0A>=20>=20+=09=09=09compatible=20=3D=20=22samsun=
g,exynos7-ufs=22;=0D=0A>=20>=20+=09=09=09=23address-cells=20=3D=20<1>;=0D=
=0A>=20>=20+=09=09=09=23size-cells=20=3D=20<1>;=0D=0A>=20>=20+=09=09=09rang=
es;=0D=0A>=20>=20+=09=09=09reg=20=3D=20<0x15570000=200x100>,=20=20/*=200:=
=20HCI=20standard=20*/=0D=0A>=20>=20+=09=09=09=09<0x15570100=200x100>,=20=
=20/*=201:=20Vendor=20specificed=0D=0A>=20*/=0D=0A>=20>=20+=09=09=09=09<0x1=
5571000=200x200>,=20=20/*=202:=20UNIPRO=20*/=0D=0A>=20>=20+=09=09=09=09<0x1=
5572000=200x300>;=20=20/*=203:=20UFS=20protector=20*/=0D=0A>=20>=20+=09=09=
=09reg-names=20=3D=20=22hci=22,=20=22vs_hci=22,=20=22unipro=22,=20=22ufsp=
=22;=0D=0A>=20>=20+=09=09=09interrupts=20=3D=20<GIC_SPI=20200=20IRQ_TYPE_LE=
VEL_HIGH>;=0D=0A>=20>=20+=09=09=09clocks=20=3D=20<&clock_fsys1=20ACLK_UFS20=
_LINK>,=0D=0A>=20>=20+=09=09=09=09<&clock_fsys1=20SCLK_UFSUNIPRO20_USER>;=
=0D=0A>=20>=20+=09=09=09clock-names=20=3D=20=22core_clk=22,=20=22sclk_unipr=
o_main=22;=0D=0A>=20>=20+=09=09=09freq-table-hz=20=3D=20<0=200>,=20<0=200>;=
=0D=0A>=20>=20+=09=09=09pclk-freq-avail-range=20=3D=20<70000000=20133000000=
>;=0D=0A>=20>=20+=09=09=09ufs,pwr-local-l2-timer=20=3D=20<8000=2028000=2020=
000>;=0D=0A>=20>=20+=09=09=09ufs,pwr-remote-l2-timer=20=3D=20<12000=2032000=
=2016000>;=0D=0A>=20>=20+=09=09=09phys=20=3D=20<&ufs_phy>;=0D=0A>=20>=20+=
=09=09=09phy-names=20=3D=20=22ufs-phy=22;=0D=0A>=20>=20+=09=09=09status=20=
=3D=20=22disabled=22;=0D=0A>=20>=20+=09=09=7D;=0D=0A>=20>=20+=0D=0A>=20>=20=
+=09=09ufs_phy:=20ufs-phy=400x15571800=20=7B=0D=0A>=20>=20+=09=09=09compati=
ble=20=3D=20=22samsung,exynos7-ufs-phy=22;=0D=0A>=20>=20+=09=09=09reg=20=3D=
=20<0x15571800=200x240>;=0D=0A>=20>=20+=09=09=09reg-names=20=3D=20=22phy-pm=
a=22;=0D=0A>=20>=20+=09=09=09samsung,pmu-syscon=20=3D=20<&pmu_system_contro=
ller>;=0D=0A>=20>=20+=09=09=09=23phy-cells=20=3D=20<0>;=0D=0A>=20>=20+=09=
=09=09clocks=20=3D=20<&clock_fsys1=20MOUT_FSYS1_PHYCLK_SEL1>,=0D=0A>=20>=20=
+=09=09=09=09<&clock_top1=20CLK_SCLK_PHY_FSYS1_26M>;=0D=0A>=20>=20+=09=09=
=09clock-names=20=3D=20=22ref_clk_parent=22,=20=22ref_clk=22;=0D=0A>=20Hi=
=0D=0A>=20Is=20this=20correct=20(aren't=20child=20and=20parent=20clock=20sw=
apped)?=0D=0A>=20This=20will=20set=20MOUT_FSYS1_PHYCLK_SEL1=20to=20be=20par=
ent=20clock=20of=0D=0A>=20CLK_SCLK_PHY_FSYS1_26M.=0D=0A=0D=0ALooks=20like=
=20in=20one=20of=20my=20rebase=20it=20got=20swap,=20will=20correct=20it.=20=
=20Thanks=20for=20pointing=20out.=0D=0A=0D=0A>=20I've=20tested=20this=20on=
=20Exynos7420=20(which=20looks=20like=20can=20use=20the=20same=20clock=20dr=
iver=20as=0D=0A>=20exynos7)=20and=20after=20adding=20some=20debug=20code=20=
(because=20currently=20we're=20not=0D=0A>=20handling=20result=20of=20samsun=
g_ufs_phy_clks_init)=20i=20got=0D=0A>=20=0D=0A>=20samsung-ufs-phy=201557180=
0.ufs-phy:=20clk_set_parent=20result:=20-22=0D=0A>=20=0D=0AI=20will=20check=
=20if=20I=20overlooked=20this=20error.=0D=0A>=20On=20vendor=20sources=20for=
=20this=20device,=20driver=20was=20setting=20CLK_SCLK_PHY_FSYS1_26M=0D=0A>=
=20to=20be=20parent=20of=20MOUT_FSYS1_PHYCLK_SEL1,=20and=20then=20it=20did=
=20run=20without=20error.=0D=0A>=20=0D=0A>=20samsung-ufs-phy=2015571800.ufs=
-phy:=20clk_set_parent=20result:=200=0D=0A>=20=0D=0AWith=20this=20change,=
=20does=20linkup=20worked=20for=20you?=0D=0A=0D=0A>=20Also=20looking=20at=
=20clk-exynos7=20driver=20seems=20to=20confirm=20this.=0D=0A>=20=0D=0A>=20>=
=20+=09=09=7D;=0D=0A>=20>=20+=0D=0A>=20>=20=20=09=09usbdrd_phy:=20phy=40155=
00000=20=7B=0D=0A>=20>=20=20=09=09=09compatible=20=3D=20=22samsung,exynos7-=
usbdrd-phy=22;=0D=0A>=20>=20=20=09=09=09reg=20=3D=20<0x15500000=200x100>;=
=0D=0A=0D=0A=0D=0A
