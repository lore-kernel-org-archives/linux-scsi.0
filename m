Return-Path: <SRS0=PQdO=6X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DD2C47255
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 00:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFE30218AC
	for <linux-scsi@archiver.kernel.org>; Sat,  9 May 2020 00:36:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="YiTlflKb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgEIAgX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 20:36:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43844 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgEIAgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 20:36:21 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200509003617epoutp0474c14341bb3ca43246ae182b5644a800~NNQ3zXuJz2759627596epoutp04D
        for <linux-scsi@vger.kernel.org>; Sat,  9 May 2020 00:36:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200509003617epoutp0474c14341bb3ca43246ae182b5644a800~NNQ3zXuJz2759627596epoutp04D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1588984577;
        bh=dlOOLufDeg99NYiBMXLuCCLPr1sINIot7eHDqZu/lJc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=YiTlflKbHNgy/NR7HAZmiAAznR1kxCXHN9zD8eSqnfGDZiJSpzdyTYCmQj5Oot6qa
         K5OpI5ZCWGX9pkzLIg1afzepzr/9DUrLSjgYXt90/zV5m/JRx+nkr68DLHoHnRWykD
         48+wpkH/ffMKDbFmNi3LLikr14BHKapwjUeXor0Q=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200509003616epcas5p2b3225e9b3de1025e352c09357cd74b2f~NNQ2tFXFt0795707957epcas5p2q;
        Sat,  9 May 2020 00:36:16 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.BB.23569.00BF5BE5; Sat,  9 May 2020 09:36:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200509003615epcas5p38e36fa225186103d1158bdc16aa0ec0e~NNQ1f7CPs1946519465epcas5p3-;
        Sat,  9 May 2020 00:36:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200509003615epsmtrp26ec80a06ab964cfa41b2048be6f47dd0~NNQ1eyo1q1992219922epsmtrp2s;
        Sat,  9 May 2020 00:36:15 +0000 (GMT)
X-AuditID: b6c32a4a-3c7ff70000005c11-88-5eb5fb003fd2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        16.CC.18461.EFAF5BE5; Sat,  9 May 2020 09:36:14 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200509003611epsmtip1f8a8c89552403ae0a2b5ae3fa4852119~NNQymPHSw2460824608epsmtip1O;
        Sat,  9 May 2020 00:36:11 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Rob Herring'" <robh@kernel.org>
Cc:     <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20200505155611.GA23690@bogus>
Subject: RE: [PATCH v7 06/10] dt-bindings: phy: Document Samsung UFS PHY
 bindings
Date:   Sat, 9 May 2020 06:06:10 +0530
Message-ID: <006801d62599$d8761690$896243b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQINaKJiJYqhfY8pF8dQGQjTbFgO/QHYsHSaAmfiCw4BzArg0Kf//KSQ
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsWy7bCmli7D761xBrPOClq8/HmVzeLT+mWs
        FvOPnGO1OH9+A7vFzS1HWSw2Pb7GanF51xw2ixnn9zFZdF/fwWax/Pg/Jov/e3awWyzdepPR
        gcfjcl8vk8emVZ1sHpuX1Hu0nNzP4vHx6S0Wj74tqxg9Pm+S82g/0M0UwBHFZZOSmpNZllqk
        b5fAlXGm8QVLwV2jiteNJ9kbGG8ZdDFyckgImEgc/jufrYuRi0NIYDejxK3FqxhBEkICnxgl
        zu7wgUh8Y5T41zmDCaajdc8+JojEXkaJP3seskI4bxglJrRvZgapYhPQldixuI0NxBYRUJVo
        mvWABaSIWeA4k8TjjltgozgFtCWaL25gAbGFBYIlvkyZDNbAIqAi8fPjGbBBvAKWEk9fb2GD
        sAUlTs58AlbPDNS7bOFrZoiTFCR+Pl0GdAUH0DI3ifZmY4gScYmjP3uYQfZKCFzgkNg+6QQL
        RL2LxN2PN6HeEZZ4dXwLO4QtJfH53V42kDkSAtkSPbuMIcI1EkvnHYNqtZc4cGUOC0gJs4Cm
        xPpd+hCr+CR6fz9hgujklehoE4KoVpVofncVqlNaYmJ3NytEiYfE0k6nCYyKs5C8NQvJW7OQ
        3D8LYdcCRpZVjJKpBcW56anFpgVGeanlesWJucWleel6yfm5mxjBCU3Lawfjwwcf9A4xMnEw
        HmKU4GBWEuGdWLElTog3JbGyKrUoP76oNCe1+BCjNAeLkjhvUiNQSiA9sSQ1OzW1ILUIJsvE
        wSnVwDQt5XOwu7l5KPfaALeH36ovbT3SYGQuqD3lzgpdWbmy5k11wik8vUUTLx1V77qy/MaL
        bwV8DO+nPzym8eLS98f3TKP+/Z/NGFho94dx+rLCbRc9U56bv3iS9nzvZ645eR9Z4tZ1nj7x
        /dHDkGWCOub3JhzZPNs9IOTNguiqBa9W9ZjPjT1wW9j4/r0rf/WiDIMkz3rpzv79Sc2c4UwE
        09/KxJ4Pyt6FoqsnLJjT9mH1g08mbGYvRLeX2rwVf18bGle2Pn1LwVyP0v1TdZdFdgcq1xy9
        fmni7qke9dvm/hadb8v/xn27Ud8540knYm9f3dr2+OoRfq41caUxWu47Ms6Vza89G9W3YM7T
        xokqxvNfKrEUZyQaajEXFScCAEjSJGjXAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWy7bCSnO6/X1vjDHrf21i8/HmVzeLT+mWs
        FvOPnGO1OH9+A7vFzS1HWSw2Pb7GanF51xw2ixnn9zFZdF/fwWax/Pg/Jov/e3awWyzdepPR
        gcfjcl8vk8emVZ1sHpuX1Hu0nNzP4vHx6S0Wj74tqxg9Pm+S82g/0M0UwBHFZZOSmpNZllqk
        b5fAlfFxy2XGglVKFZf+/2RqYNwg1cXIySEhYCLRumcfE4gtJLCbUWLPLhmIuLTE9Y0T2CFs
        YYmV/54D2VxANa8YJWbM+MMKkmAT0JXYsbiNDcQWEVCVaJr1gAWkiFngMpPEkTcv2CA67jFK
        7Oj8AraCU0BbovniBhYQW1ggUOJ2/wNGEJtFQEXi58czzCA2r4ClxNPXW9ggbEGJkzOfgNUz
        A/X2PmxlhLGXLXzNDHGegsTPp8uALuIAusJNor3ZGKJEXOLozx7mCYzCs5BMmoVk0iwkk2Yh
        aVnAyLKKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4OrU0dzBuX/VB7xAjEwfjIUYJ
        DmYlEd6JFVvihHhTEiurUovy44tKc1KLDzFKc7AoifPeKFwYJySQnliSmp2aWpBaBJNl4uCU
        amAyLT9msSQ/wvbRE55D4QJH5gnpzdONb548vVhMZCLX/DPcK7sy7795w6d1O8ZP9EUUW4LW
        w3XF8w79XH3YJdXP8ss9/WYT7pVeN9v/yD5oCeNIv2Dak77JrPDvl55k01/lThUii+bsmMDK
        wb0mbfdGDjdR9+jV+nLz3xvs3GkftXFZUuBePvOJipudGV99tFiZqdvoFaZk7Xr7KHNIWaTZ
        fQc26/R1Of2L9a4sMZszu2QGy7U85qPLf/WXX1E8eXLC4cVvN5ZvWbul9fLDmTfu7pANbXm2
        futaPeXg5ynNOhcFWT/7X2H9I+Fz50wE7/ssvyPd7fVy1cpJF69uPs2pt4U/KPCNmUCd6aSp
        y12VWIozEg21mIuKEwEjBPjwPQMAAA==
X-CMS-MailID: 20200509003615epcas5p38e36fa225186103d1158bdc16aa0ec0e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200426174215epcas5p3e87abccf47976f6318eb470efef9db39
References: <20200426173024.63069-1-alim.akhtar@samsung.com>
        <CGME20200426174215epcas5p3e87abccf47976f6318eb470efef9db39@epcas5p3.samsung.com>
        <20200426173024.63069-7-alim.akhtar@samsung.com>
        <20200505155611.GA23690@bogus>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rob

> -----Original Message-----
> From: Rob Herring <robh=40kernel.org>
> Sent: 05 May 2020 21:26
> To: Alim Akhtar <alim.akhtar=40samsung.com>
> Cc: devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org; krzk=40ke=
rnel.org;
> avri.altman=40wdc.com; martin.petersen=40oracle.com;
> kwmad.kim=40samsung.com; stanley.chu=40mediatek.com;
> cang=40codeaurora.org; linux-samsung-soc=40vger.kernel.org; linux-arm-
> kernel=40lists.infradead.org; linux-kernel=40vger.kernel.org
> Subject: Re: =5BPATCH v7 06/10=5D dt-bindings: phy: Document Samsung UFS =
PHY
> bindings
>=20
> On Sun, Apr 26, 2020 at 11:00:20PM +0530, Alim Akhtar wrote:
> > This patch documents Samsung UFS PHY device tree bindings
> >
> > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
> > Tested-by: Pawe=C5=82=20Chmiel=20<pawel.mikolaj.chmiel=40gmail.com>=0D=
=0A>=20>=20---=0D=0A>=20>=20=20.../bindings/phy/samsung,ufs-phy.yaml=20=20=
=20=20=20=20=20=20=20=7C=2074=20+++++++++++++++++++=0D=0A>=20>=20=201=20fil=
e=20changed,=2074=20insertions(+)=0D=0A>=20>=20=20create=20mode=20100644=0D=
=0A>=20>=20Documentation/devicetree/bindings/phy/samsung,ufs-phy.yaml=0D=0A=
>=20>=0D=0A>=20>=20diff=20--git=0D=0A>=20>=20a/Documentation/devicetree/bin=
dings/phy/samsung,ufs-phy.yaml=0D=0A>=20>=20b/Documentation/devicetree/bind=
ings/phy/samsung,ufs-phy.yaml=0D=0A>=20>=20new=20file=20mode=20100644=0D=0A=
>=20>=20index=20000000000000..352d5dda320d=0D=0A>=20>=20---=20/dev/null=0D=
=0A>=20>=20+++=20b/Documentation/devicetree/bindings/phy/samsung,ufs-phy.ya=
ml=0D=0A>=20>=20=40=40=20-0,0=20+1,74=20=40=40=0D=0A>=20>=20+=23=20SPDX-Lic=
ense-Identifier:=20GPL-2.0-only=20OR=20BSD-2-Clause=20%YAML=201.2=0D=0A>=20=
>=20+---=0D=0A>=20>=20+=24id:=0D=0A>=20>=20+https://protect2.fireeye.com/ur=
l?k=3D5c35df0a-01ffeabd-5c345445-0cc47a3=0D=0A>=20>=20+003e8-=0D=0A>=20aa6c=
980dab2ba33a&q=3D1&u=3Dhttp%3A%2F%2Fdevicetree.org%2Fschemas%2F=0D=0A>=20>=
=20+phy%2Fsamsung%2Cufs-phy.yaml%23=0D=0A>=20>=20+=24schema:=0D=0A>=20>=20+=
https://protect2.fireeye.com/url?k=3D9734fc5e-cafec9e9-97357711-0cc47a3=0D=
=0A>=20>=20+003e8-=0D=0A>=2079d176b992774339&q=3D1&u=3Dhttp%3A%2F%2Fdevicet=
ree.org%2Fmeta-schem=0D=0A>=20>=20+as%2Fcore.yaml%23=0D=0A>=20>=20+=0D=0A>=
=20>=20+title:=20Samsung=20SoC=20series=20UFS=20PHY=20Device=20Tree=20Bindi=
ngs=0D=0A>=20>=20+=0D=0A>=20>=20+maintainers:=0D=0A>=20>=20+=20=20-=20Alim=
=20Akhtar=20<alim.akhtar=40samsung.com>=0D=0A>=20>=20+=0D=0A>=20>=20+proper=
ties:=0D=0A>=20>=20+=20=20=22=23phy-cells=22:=0D=0A>=20>=20+=20=20=20=20con=
st:=200=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20compatible:=0D=0A>=20>=20+=20=20=
=20=20enum:=0D=0A>=20>=20+=20=20=20=20=20=20-=20samsung,exynos7-ufs-phy=0D=
=0A>=20>=20+=0D=0A>=20>=20+=20=20reg:=0D=0A>=20>=20+=20=20=20=20maxItems:=
=201=0D=0A>=20>=20+=20=20=20=20description:=20PHY=20base=20register=20addre=
ss=0D=0A>=20=0D=0A>=20Can=20drop=20the=20description.=20Doesn't=20add=20any=
thing=20special.=0D=0A>=20=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20reg-names:=0D=
=0A>=20>=20+=20=20=20=20items:=0D=0A>=20>=20+=20=20=20=20=20=20-=20const:=
=20phy-pma=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20clocks:=0D=0A>=20>=20+=20=20=
=20=20items:=0D=0A>=20>=20+=20=20=20=20=20=20-=20description:=20PLL=20refer=
ence=20clock=0D=0A>=20>=20+=20=20=20=20=20=20-=20description:=20symbol=20cl=
ock=20for=20input=20symbol=20(=20rx0-ch0=20symbol=20clock)=0D=0A>=20>=20+=
=20=20=20=20=20=20-=20description:=20symbol=20clock=20for=20input=20symbol=
=20(=20rx1-ch1=20symbol=20clock)=0D=0A>=20>=20+=20=20=20=20=20=20-=20descri=
ption:=20symbol=20clock=20for=20output=20symbol=20(=20tx0=20symbol=0D=0A>=
=20>=20+=20clock)=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20clock-names:=0D=0A>=20=
>=20+=20=20=20=20items:=0D=0A>=20>=20+=20=20=20=20=20=20-=20const:=20ref_cl=
k=0D=0A>=20>=20+=20=20=20=20=20=20-=20const:=20rx1_symbol_clk=0D=0A>=20>=20=
+=20=20=20=20=20=20-=20const:=20rx0_symbol_clk=0D=0A>=20>=20+=20=20=20=20=
=20=20-=20const:=20tx0_symbol_clk=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20samsun=
g,pmu-syscon:=0D=0A>=20>=20+=20=20=20=20=24ref:=20'/schemas/types.yaml=23/d=
efinitions/phandle'=0D=0A>=20>=20+=20=20=20=20description:=20phandle=20for=
=20PMU=20system=20controller=20interface,=20used=20to=0D=0A>=20>=20+=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20control=20pmu=20registers=20bi=
ts=20for=20ufs=20m-phy=0D=0A>=20>=20+=0D=0A>=20>=20+required:=0D=0A>=20>=20=
+=20=20-=20=22=23phy-cells=22=0D=0A>=20>=20+=20=20-=20compatible=0D=0A>=20>=
=20+=20=20-=20reg=0D=0A>=20>=20+=20=20-=20reg-names=0D=0A>=20>=20+=20=20-=
=20clocks=0D=0A>=20>=20+=20=20-=20clock-names=0D=0A>=20>=20+=20=20-=20samsu=
ng,pmu-syscon=0D=0A>=20=0D=0A>=20Add:=0D=0A>=20=0D=0A>=20additionalProperti=
es:=20false=0D=0A>=20=0D=0A>=20With=20that,=0D=0A>=20=0D=0AWill=20update=20=
the=20documentation=20as=20per=20your=20suggestion=0D=0A=0D=0A>=20Reviewed-=
by:=20Rob=20Herring=20<robh=40kernel.org>=0D=0A>=0D=0AThanks=20for=20review=
=20comments.=20After=20fixing,=20will=20add=20your=20review=20tag.=0D=0A=20=
=0D=0A>=20>=20+=0D=0A>=20>=20+examples:=0D=0A>=20>=20+=20=20-=20=7C=0D=0A>=
=20>=20+=20=20=20=20=23include=20<dt-bindings/clock/exynos7-clk.h>=0D=0A>=
=20>=20+=0D=0A>=20>=20+=20=20=20=20ufs_phy:=20ufs-phy=4015571800=20=7B=0D=
=0A>=20>=20+=20=20=20=20=20=20=20=20compatible=20=3D=20=22samsung,exynos7-u=
fs-phy=22;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20reg=20=3D=20<0x15571800=20=
0x240>;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20reg-names=20=3D=20=22phy-pma=
=22;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20samsung,pmu-syscon=20=3D=20<&pmu=
_system_controller>;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=23phy-cells=20=
=3D=20<0>;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20clocks=20=3D=20<&clock_fsy=
s1=20SCLK_COMBO_PHY_EMBEDDED_26M>,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20<&clock_fsys1=20PHYCLK_UFS20_RX1_SYMBOL_USER>,=
=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20<&clock_f=
sys1=20PHYCLK_UFS20_RX0_SYMBOL_USER>,=0D=0A>=20>=20+=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20<&clock_fsys1=20PHYCLK_UFS20_TX0_SYMBOL_USER>=
;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20clock-names=20=3D=20=22ref_clk=22,=
=20=22rx1_symbol_clk=22,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=22rx0_symbol_clk=22,=20=22tx0_symbol_clk=22;=
=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=7D;=0D=0A>=20>=20+...=0D=0A>=20>=
=20--=0D=0A>=20>=202.17.1=0D=0A>=20>=0D=0A=0D=0A
