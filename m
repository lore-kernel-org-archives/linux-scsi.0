Return-Path: <SRS0=SK/U=5F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21628C41621
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 14:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E284920754
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Mar 2020 14:10:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IhtlTgvV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgCTOKS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 10:10:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22263 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726816AbgCTOKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2020 10:10:18 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200320141013epoutp02e592c09fe416321bfb0baa0c21235936~_CHQOGOet0383303833epoutp02Q
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2020 14:10:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200320141013epoutp02e592c09fe416321bfb0baa0c21235936~_CHQOGOet0383303833epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584713413;
        bh=ta6cafN1//44NHljB1NsfpWzBYmOjlwmXOnqma4SokY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=IhtlTgvVOui+qUxpoeZzJalGQ/x0sX91zxDFK/7uJSE32O30waErLjZ3itDbIsmu0
         uITPXKnA5CiIUv13B4D+MyloaW0H9qEvq/K9GqkdYFAbHOuhTwQnFKGiS8bSF/YOJj
         fBLNOXXw/f/vjKuym+FcIlRb9tYVWyMS6X1vrC1A=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200320141012epcas5p4f7a49b1c1a52db5d6503efff94d6c5cc~_CHPl78VQ2565525655epcas5p4a;
        Fri, 20 Mar 2020 14:10:12 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1F.B9.04736.4CEC47E5; Fri, 20 Mar 2020 23:10:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200320141012epcas5p174279dd32274a3295bde48e9ea4a6d02~_CHO6GdVL1827718277epcas5p1Y;
        Fri, 20 Mar 2020 14:10:12 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200320141011epsmtrp256a752f3bc09164040da50b7034571ad~_CHO4-24b0658806588epsmtrp2d;
        Fri, 20 Mar 2020 14:10:11 +0000 (GMT)
X-AuditID: b6c32a4b-acbff70000001280-fc-5e74cec4e062
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        73.22.04158.3CEC47E5; Fri, 20 Mar 2020 23:10:11 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.32]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200320141009epsmtip1f09c333501202d80c22c3aabed578636~_CHM-dkIi0366703667epsmtip1X;
        Fri, 20 Mar 2020 14:10:09 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     =?utf-8?Q?'Pawe=C5=82_Chmiel'?= <pawel.mikolaj.chmiel@gmail.com>
Cc:     <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <1d128596eeefb414b7b621b0db5ca0697030dbfc.camel@gmail.com>
Subject: RE: [PATCH v3 0/5] exynos-ufs: Add support for UFS HCI
Date:   Fri, 20 Mar 2020 19:40:08 +0530
Message-ID: <007c01d5fec1$45097a90$cf1c6fb0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHwhQl1rFhj6z9XfaQCH7KvMUfWFgG8Fm24AZkWDOaoAcxu4A==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUhTYRTGe++35uo6S08TwkYmalsfFt3AskToQiERGmWhjbxopCa70zKi
        zNLSubE0qIYfleVIWtbSchPLbCZKzcBs2IcYalKGUPZlgtX1Gvnf75z3POc5D7wMrnxNqpgD
        WQZBn6XLUFO+xL3H4WEat8eQvNL4KIz7MNFLcV/qa0mu2u0hue7u2zTX19BOcI7BlyTX46qg
        uIvdDzDO6G2iOFvHFMb97DDjXGGLm+auN/ahTQq+x2zCeKf1Lc076oop/u61E/zpzocE/3n4
        FcGbG+oQP+5YzJ9pNWLbfZJ8o1OFjAO5gn7Fxn2+6Y3NRWR21e4jtR/GUT4a2VmCfBhg10Bh
        /hRegnwZJduM4GrPC0IuviDofv6ekovvCKq9P/6OMdMS5zW93G9BMFnsxaRVSvYjgsqiHRJT
        rAaaaoooiRewcfDb9glJjLNvMTBZQWIfdguMFjhxiQPYGOi8cpmUmGBDwfx7hJZYwa6Hgbr7
        lMz+0HlpiJD3RELtlVFcjhACE8O1pOwVC/23qme8gqB9onQ6GrC3aLCVt5KyIA6GnrZjMgfA
        x44GWmYVjI+1UHLIg1DqipLbx+B61RNC5hhofVFBSCM4Gw71rhWy1TwwTQ5hslIBZ4uU8nQo
        nBrrnVEGwzmjceYAHtzlI7QFLbHOCmadFcw6K4D1v9llRNShRUK2mJkmiGuzo7KEw1pRlynm
        ZKVp9x/KdKDpLxextQk5PNvaEMsgtZ+Cu2FIVpK6XDEvsw0Bg6sXKDRpYrJSkarLOyroD6Xo
        czIEsQ0FM4Q6SFFG9u5Vsmk6g3BQELIF/b9XjPFR5aP5Gq36uFNJew32wPMFqvClvxKXLfSa
        v/J3LKu75iZMdCUuW22/ZC9T5+0a6LNNxeptsXfV44uWB9JJG3rnbDZp/bXrXJWT/sKuZydt
        Na5Be334psFvifNe5xSU3nzf5qmI9MO/xgsJN+NHSiwpIXbVktHoVEWN23Lhzbt+54Y9akJM
        162KwPWi7g8CqCQEbgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWy7bCSnO7hcyVxBnNnWFi8/HmVzeLT+mWs
        FvOPnGO1OH9+A7vFzS1HWSw2Pb7GanF51xw2ixnn9zFZdF/fwWax/Pg/Josfx/uYLVr3HmG3
        WLr1JqMDr8flvl4mj52z7rJ7bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0ePzJjmP9gPdTAGc
        UVw2Kak5mWWpRfp2CVwZC1dNYy2YaVvR96+HsYFxhUEXIweHhICJxM4lRV2MXBxCArsZJaZv
        XszexcgJFJeWuL5xApQtLLHy33N2iKIXjBKHTx4DS7AJ6ErsWNzGBmKLCLhI/F/+hhHEZhZ4
        zSTxd08iRMNJRolv+3aBFXEKuEu8btrJDGILC9hLnFy4gBXEZhFQlej7/xxsKK+ApcSDVdvZ
        IGxBiZMzn7BADNWWeHrzKZy9bOFrZojrFCR+Pl3GCnGEk8S9dfOhjhCXOPqzh3kCo/AsJKNm
        IRk1C8moWUhaFjCyrGKUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI5YLa0djCdOxB9i
        FOBgVOLhtVhZEifEmlhWXJl7iFGCg1lJhFc3vThOiDclsbIqtSg/vqg0J7X4EKM0B4uSOK98
        /rFIIYH0xJLU7NTUgtQimCwTB6dUA6Oei2567eU1uRqnJDKb18tELq5dWy2up3n8rVjA6Rbz
        RVLJf4TjI2VcT83MnRM5ca92fs1n6aweLYXDv/bctlxtufnH1rtGRwLdKuce4ylQvOP5d65R
        T6rJjM1bJyqp+EbOe/e3r78q+U+sjcbx1zeucB89zyzZFGmntP6GSMtPpykWvB4q3UosxRmJ
        hlrMRcWJAMe9qEDUAgAA
X-CMS-MailID: 20200320141012epcas5p174279dd32274a3295bde48e9ea4a6d02
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200319150701epcas5p4bb4365de0a0f4a4a6c7bc533e16d66ec
References: <CGME20200319150701epcas5p4bb4365de0a0f4a4a6c7bc533e16d66ec@epcas5p4.samsung.com>
        <20200319150031.11024-1-alim.akhtar@samsung.com>
        <1d128596eeefb414b7b621b0db5ca0697030dbfc.camel@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Pawel
Thanks for helping in testing.

> -----Original Message-----
> From: Pawe=C5=82=20Chmiel=20<pawel.mikolaj.chmiel=40gmail.com>=0D=0A>=20S=
ent:=2020=20March=202020=2001:12=0D=0A>=20To:=20Alim=20Akhtar=20<alim.akhta=
r=40samsung.com>=0D=0A>=20Cc:=20krzk=40kernel.org;=20avri.altman=40wdc.com;=
=20martin.petersen=40oracle.com;=0D=0A>=20kwmad.kim=40samsung.com;=20stanle=
y.chu=40mediatek.com;=0D=0A>=20cang=40codeaurora.org;=20linux-samsung-soc=
=40vger.kernel.org;=20linux-arm-=0D=0A>=20kernel=40lists.infradead.org;=20l=
inux-kernel=40vger.kernel.org;=20robh+dt=40kernel.org;=0D=0A>=20devicetree=
=40vger.kernel.org;=20linux-scsi=40vger.kernel.org=0D=0A>=20Subject:=20Re:=
=20=5BPATCH=20v3=200/5=5D=20exynos-ufs:=20Add=20support=20for=20UFS=20HCI=
=0D=0A>=20=0D=0A>=20On=20Thu,=202020-03-19=20at=2020:30=20+0530,=20Alim=20A=
khtar=20wrote:=0D=0A>=20>=20This=20patch-set=20introduces=20UFS=20(Universa=
l=20Flash=20Storage)=20host=0D=0A>=20>=20controller=20support=20for=20Samsu=
ng=20family=20SoC.=20Mostly,=20it=20consists=20of=20UFS=20PHY=20and=0D=0A>=
=20host=20specific=20driver.=0D=0A>=20>=0D=0A>=20>=20-=20Changes=20since=20=
v2:=0D=0A>=20>=20*=20fixed=20build=20warning=20by=20kbuild=20test=20robot=
=0D=0A>=20>=20*=20Added=20Reported-by=20tags=0D=0A>=20>=0D=0A>=20>=20-=20Ch=
anges=20since=20v1:=0D=0A>=20>=20*=20fixed=20make=20dt_binding_check=20erro=
r=20as=20pointed=20by=20Rob=0D=0A>=20>=20*=20Addressed=20Krzysztof's=20revi=
ew=20comments=0D=0A>=20>=20*=20Added=20Reviewed-by=20tags=0D=0A>=20>=0D=0A>=
=20>=0D=0A>=20>=20patch=201/5:=20define=20devicetree=20bindings=20for=20UFS=
=20PHY=20patch=202/5:=20Adds=20UFS=0D=0A>=20>=20PHY=20driver=20patch=203/5:=
=20define=20devicetree=20bindings=20for=20UFS=20HCI=20patch=0D=0A>=20>=204/=
5:=20Adds=20Samsung=20UFS=20HCI=20driver=20patch=205/5:=20Enabled=20UFS=20o=
n=20exynos7=0D=0A>=20>=20platform=0D=0A>=20Hi=0D=0A>=20Is=20this=20compatib=
le=20with=20Exynos7420?=20Looking=20at=20u-boot=20source=20code,=20there=20=
is=0D=0A>=20Espresso7420=20-=20isn't=20it=20the=20same=20device?=20Also=20t=
his=20driver=20looks=20very=20similar=20to=20the=0D=0A>=20one=20from=20vend=
or=20kernel=20sources=20(for=20my=20device).=0D=0A>=20=0D=0AExynos7=20and=
=20Exynos7420=20are=20compatible=20and=20belong=20to=20same=20Exynos=20SoC=
=20series=20(but=20there=20are=20some=20fine=20differences)=0D=0A=0D=0A>=20=
I=20did=20tried=20to=20run=20this=20on=20my=20Exynos7420=20based=20device=
=20(Samsung=20S6=20Edge=0D=0A>=20phone)=20with=205.6-rc6,=20to=20get=20any=
=20storage=20working=20(since=20it=20doesn't=20have=20sdcard=0D=0A>=20slot)=
.=0D=0A>=20=0D=0AI=20think=20this=20should=20work=20on=20S6=20Edge,=20but=
=20not=20entirely=20sure,=20as=20I=20am=20not=20aware=20of=20the=20S6=20H/W=
=20schematic,=20specially=20PMIC=20connection.=0D=0A=0D=0A>=20At=20first=20=
i=20got=20error=20in=20exynos_ufs_config_smu.=20Looking=20at=20vendor=20sou=
rces,=20on=20my=0D=0A>=20device=20only=20secureos=20is=20able=20to=20write=
=20to=20those=20registers=20so=20i=20fixed=20it=20by=20using=20smc=0D=0A>=
=20calls=20and=20driver=20probes=20fine.=20Will=20this=20be=20also=20suppor=
ted=20by=20driver=20(maybe=20in=0D=0A>=20future)?=0D=0A>=20=0D=0A>=20But=20=
now=20got=20another=20error=0D=0A>=20=5B=20=20=20=201.610464=5D=20exynos-uf=
shc=2015570000.ufs:=20ufshcd_intr:=20Unhandled=0D=0A>=20interrupt=200x00000=
000=0D=0A>=20=5B=20=20=20=201.610629=5D=20host_regs:=2000000000:=200383ff0f=
=2000000000=2000000200=2000000000=0D=0A>=20=5B=20=20=20=201.610747=5D=20hos=
t_regs:=2000000010:=2000000101=2000007fce=2000000000=2000000000=0D=0A>=20=
=5B=20=20=20=201.610863=5D=20host_regs:=2000000020:=2000000000=2000030e75=
=2000000000=2000000000=0D=0A>=20=5B=20=20=20=201.614727=5D=20host_regs:=200=
0000030:=200000000f=2000000000=2000000000=2000000000=0D=0A>=20=5B=20=20=20=
=201.621061=5D=20host_regs:=2000000040:=2000000000=2000000000=2000000000=20=
00000000=0D=0A>=20=5B=20=20=20=201.627396=5D=20host_regs:=2000000050:=20f8c=
37000=2000000000=2000000001=2000000000=0D=0A>=20=5B=20=20=20=201.633730=5D=
=20host_regs:=2000000060:=2000000001=2000000000=2000000000=2000000000=0D=0A=
>=20=5B=20=20=20=201.640065=5D=20host_regs:=2000000070:=20f9644000=20000000=
00=2000000000=2000000000=0D=0A>=20=5B=20=20=20=201.646400=5D=20host_regs:=
=2000000080:=2000000001=2000000000=2000000000=2000000000=0D=0A>=20=5B=20=20=
=20=201.652734=5D=20host_regs:=2000000090:=2000000002=2095290000=2000000000=
=2000000000=0D=0A>=20=5B=20=20=20=201.747649=5D=20exynos-ufshc=2015570000.u=
fs:=20ufshcd_intr:=20Unhandled=0D=0A>=20interrupt=200x00000000=0D=0A>=20=5B=
=20=20=20=201.747807=5D=20host_regs:=2000000000:=200383ff0f=2000000000=2000=
000200=2000000000=0D=0A>=20=5B=20=20=20=201.747924=5D=20host_regs:=20000000=
10:=2000000101=2000007fce=2000000000=2000000000=0D=0A>=20=5B=20=20=20=201.7=
48041=5D=20host_regs:=2000000020:=2000000000=2000030e75=2000000000=20000000=
00=0D=0A>=20=5B=20=20=20=201.751909=5D=20host_regs:=2000000030:=200000000f=
=2000000000=2000000000=2000000000=0D=0A>=20=5B=20=20=20=201.758244=5D=20hos=
t_regs:=2000000040:=2000000000=2000000000=2000000000=2000000000=0D=0A>=20=
=5B=20=20=20=201.764578=5D=20host_regs:=2000000050:=20f8c37000=2000000000=
=2000000001=2000000000=0D=0A>=20=5B=20=20=20=201.770913=5D=20host_regs:=200=
0000060:=2000000001=2000000000=2000000000=2000000000=0D=0A>=20=5B=20=20=20=
=201.777248=5D=20host_regs:=2000000070:=20f9644000=2000000000=2000000000=20=
00000000=0D=0A>=20=5B=20=20=20=201.783582=5D=20host_regs:=2000000080:=20000=
00001=2000000000=2000000000=2000000000=0D=0A>=20=5B=20=20=20=201.789917=5D=
=20host_regs:=2000000090:=2000000002=2095290000=2000000000=2000000000=0D=0A=
>=20=5B=20=20=20=201.884841=5D=20exynos-ufshc=2015570000.ufs:=20ufshcd_intr=
:=20Unhandled=0D=0A>=20interrupt=200x00000000=0D=0A>=20=5B=20=20=20=201.884=
999=5D=20host_regs:=2000000000:=200383ff0f=2000000000=2000000200=2000000000=
=0D=0A>=20=5B=20=20=20=201.885116=5D=20host_regs:=2000000010:=2000000101=20=
00007fce=2000000000=2000000000=0D=0A>=20=5B=20=20=20=201.885233=5D=20host_r=
egs:=2000000020:=2000000000=2000030e75=2000000000=2000000000=0D=0A>=20=5B=
=20=20=20=201.889100=5D=20host_regs:=2000000030:=200000000f=2000000000=2000=
000000=2000000000=0D=0A>=20=5B=20=20=20=201.895435=5D=20host_regs:=20000000=
40:=2000000000=2000000000=2000000000=2000000000=0D=0A>=20=5B=20=20=20=201.9=
01770=5D=20host_regs:=2000000050:=20f8c37000=2000000000=2000000001=20000000=
00=0D=0A>=20=5B=20=20=20=201.908104=5D=20host_regs:=2000000060:=2000000001=
=2000000000=2000000000=2000000000=0D=0A>=20=5B=20=20=20=201.914439=5D=20hos=
t_regs:=2000000070:=20f9644000=2000000000=2000000000=2000000000=0D=0A>=20=
=5B=20=20=20=201.920773=5D=20host_regs:=2000000080:=2000000001=2000000000=
=2000000000=2000000000=0D=0A>=20=5B=20=20=20=201.927108=5D=20host_regs:=200=
0000090:=2000000002=2095290000=2000000000=2000000000=0D=0A>=20=5B=20=20=20=
=202.998155=5D=20exynos-ufshc=2015570000.ufs:=20ufshcd_query_flag:=20Sendin=
g=0D=0A>=20flag=20query=20for=20idn=201=20failed,=20err=20=3D=20-11=0D=0A>=
=20=5B=20=20=20=204.502138=5D=20exynos-ufshc=2015570000.ufs:=20ufshcd_query=
_flag:=20Sending=0D=0A>=20flag=20query=20for=20idn=201=20failed,=20err=20=
=3D=20-11=0D=0A>=20=5B=20=20=20=206.006137=5D=20exynos-ufshc=2015570000.ufs=
:=20ufshcd_query_flag:=20Sending=0D=0A>=20flag=20query=20for=20idn=201=20fa=
iled,=20err=20=3D=20-11=0D=0A>=20=5B=20=20=20=206.006311=5D=20exynos-ufshc=
=2015570000.ufs:=20ufshcd_query_flag_retry:=0D=0A>=20query=20attribute,=20o=
pcode=205,=20idn=201,=20failed=20with=20error=20-11=20after=203=20retires=
=0D=0A>=20=5B=20=20=20=206.006545=5D=20exynos-ufshc=2015570000.ufs:=20ufshc=
d_complete_dev_init=0D=0A>=20reading=20fDeviceInit=20flag=20failed=20with=
=20error=20-11=0D=0A>=20=0D=0A>=20Do=20You=20have=20any=20idea=20what=20cou=
ld=20be=20wrong?=0D=0A>=20=0D=0ATo=20me,=20It=20looks=20like=20UFS=20device=
=20is=20not=20powered=20ON=20or=20properly=20Reseted,=20I=20have=20seen=20t=
his=20kind=20of=20issues=20in=20past=20and=20=0D=0AAFAIR,=20fix=20was=20to=
=20keep=20the=20PMIC=20rail=20which=20was=20hook=20to=20device=20RESET_N=20=
always-on.=0D=0A=0D=0A>=20Thanks=20=0D=0A>=20>=0D=0A>=20>=20Note:=20This=20=
series=20is=20based=20on=20Linux-5.6-rc6=20(commit:=20fb33c6510d55)=0D=0A>=
=20>=0D=0A>=20>=0D=0A>=20>=20Alim=20Akhtar=20(5):=0D=0A>=20>=20=20=20dt-bin=
dings:=20phy:=20Document=20Samsung=20UFS=20PHY=20bindings=0D=0A>=20>=20=20=
=20phy:=20samsung-ufs:=20add=20UFS=20PHY=20driver=20for=20samsung=20SoC=0D=
=0A>=20>=20=20=20Documentation:=20devicetree:=20ufs:=20Add=20DT=20bindings=
=20for=20exynos=20UFS=20host=0D=0A>=20>=20=20=20=20=20controller=0D=0A>=20>=
=20=20=20scsi:=20ufs-exynos:=20add=20UFS=20host=20support=20for=20Exynos=20=
SoCs=0D=0A>=20>=20=20=20arm64:=20dts:=20Add=20node=20for=20ufs=20exynos7=0D=
=0A>=20>=0D=0A>=20>=20=20.../bindings/phy/samsung,ufs-phy.yaml=20=20=20=20=
=20=20=20=20=20=7C=20=20=2062=20+=0D=0A>=20>=20=20.../devicetree/bindings/u=
fs/ufs-exynos.txt=20=20=20=20=7C=20=20104=20++=0D=0A>=20>=20=20.../boot/dts=
/exynos/exynos7-espresso.dts=20=20=20=20=20=20=7C=20=20=2016=20+=0D=0A>=20>=
=20=20arch/arm64/boot/dts/exynos/exynos7.dtsi=20=20=20=20=20=20=20=7C=20=20=
=2044=20+-=0D=0A>=20>=20=20drivers/phy/samsung/Kconfig=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=7C=20=20=20=209=20+=0D=0A>=20>=20=20dr=
ivers/phy/samsung/Makefile=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=7C=20=20=20=201=20+=0D=0A>=20>=20=20drivers/phy/samsung/phy-exynos7-=
ufs.h=20=20=20=20=20=20=20=20=20=7C=20=20=2085=20+=0D=0A>=20>=20=20drivers/=
phy/samsung/phy-samsung-ufs.c=20=20=20=20=20=20=20=20=20=7C=20=20311=20++++=
=0D=0A>=20>=20=20drivers/phy/samsung/phy-samsung-ufs.h=20=20=20=20=20=20=20=
=20=20=7C=20=20100=20++=0D=0A>=20>=20=20drivers/scsi/ufs/Kconfig=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=7C=20=20=2012=20+=
=0D=0A>=20>=20=20drivers/scsi/ufs/Makefile=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=7C=20=20=20=201=20+=0D=0A>=20>=20=20drivers/=
scsi/ufs/ufs-exynos.c=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=7C=
=201399=20+++++++++++++++++=0D=0A>=20>=20=20drivers/scsi/ufs/ufs-exynos.h=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=7C=20=20268=20++++=0D=
=0A>=20>=20=20drivers/scsi/ufs/unipro.h=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=7C=20=20=2041=20+=0D=0A>=20>=20=20include/linux=
/phy/phy-samsung-ufs.h=20=20=20=20=20=20=20=20=20=20=20=7C=20=20=2070=20+=
=0D=0A>=20>=20=2015=20files=20changed,=202521=20insertions(+),=202=20deleti=
ons(-)=20=20create=20mode=0D=0A>=20>=20100644=20Documentation/devicetree/bi=
ndings/phy/samsung,ufs-phy.yaml=0D=0A>=20>=20=20create=20mode=20100644=0D=
=0A>=20>=20Documentation/devicetree/bindings/ufs/ufs-exynos.txt=0D=0A>=20>=
=20=20create=20mode=20100644=20drivers/phy/samsung/phy-exynos7-ufs.h=0D=0A>=
=20>=20=20create=20mode=20100644=20drivers/phy/samsung/phy-samsung-ufs.c=0D=
=0A>=20>=20=20create=20mode=20100644=20drivers/phy/samsung/phy-samsung-ufs.=
h=0D=0A>=20>=20=20create=20mode=20100644=20drivers/scsi/ufs/ufs-exynos.c=20=
=20create=20mode=20100644=0D=0A>=20>=20drivers/scsi/ufs/ufs-exynos.h=20=20c=
reate=20mode=20100644=0D=0A>=20>=20include/linux/phy/phy-samsung-ufs.h=0D=
=0A>=20>=0D=0A=0D=0A=0D=0A
