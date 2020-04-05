Return-Path: <SRS0=3U4t=5V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1552BC2BA18
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 01:49:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0F982082F
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Apr 2020 01:49:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="st23JvmL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgDEBtF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Apr 2020 21:49:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51761 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgDEBtF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Apr 2020 21:49:05 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200405014900epoutp011a634442a69fecfb56b697f8f03e12f7~CyUqHqfjY2546125461epoutp01E
        for <linux-scsi@vger.kernel.org>; Sun,  5 Apr 2020 01:49:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200405014900epoutp011a634442a69fecfb56b697f8f03e12f7~CyUqHqfjY2546125461epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586051340;
        bh=QuHHLyqI5mlnWKAmpGQxZaOlWKX35casRNTu16k2i9Q=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=st23JvmLfZ5o2Pk7FODZWvBzs1SPgwl7wDuHuB7WrOi0XnsMKWk85OcoYY6or/pfN
         yl46sjDQoHoP2Ldo0Ht7AbuE1s6LGDPGgjYEYxwcVqChGMKuqMSv7+9qDcNd65TMw3
         iI8G65vBn1DnvY8nNFh9Ec6LLENuGNsjml/lF82U=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200405014859epcas5p23d607fab10620f995cc2fcfb8e1fb1d6~CyUotIvGx1573515735epcas5p20;
        Sun,  5 Apr 2020 01:48:59 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.E7.04782.B09398E5; Sun,  5 Apr 2020 10:48:59 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200405014858epcas5p1b1c595090bd46bffee0553c2ce0a293c~CyUnvudph2877728777epcas5p1Y;
        Sun,  5 Apr 2020 01:48:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200405014858epsmtrp27a940d6eefebd4d656bbab74b37f76f0~CyUnu1ymb0899108991epsmtrp2c;
        Sun,  5 Apr 2020 01:48:58 +0000 (GMT)
X-AuditID: b6c32a49-8b3ff700000012ae-c2-5e89390bd906
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B5.45.04024.909398E5; Sun,  5 Apr 2020 10:48:57 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200405014854epsmtip251fc67341e66344a8d8becb9ad53d7a0~CyUkkaGdu2376123761epsmtip2S;
        Sun,  5 Apr 2020 01:48:54 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     =?utf-8?Q?'Pawe=C5=82_Chmiel'?= <pawel.mikolaj.chmiel@gmail.com>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Cc:     <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <58f2996c7dfe70b226c5cafbd94d7b02a314d77a.camel@gmail.com>
Subject: RE: [PATCH v4 5/5] arm64: dts: Add node for ufs exynos7
Date:   Sun, 5 Apr 2020 07:18:52 +0530
Message-ID: <000001d60aec$5ef39670$1cdac350$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKI+vJzlUBp7WIi19k8pRZBKIHK2gKUSzVAA7h3SyUCe2DDmwIWY0ZDAq0rcFAB9QhIPQKG0ufBAwBREpECkZKiVQH+4tvspjcbxFA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTcRTudx/b3Wp2W4tOC8qGlg98REVX6GEgeQupiJAM0YZeNHQqu2kZ
        RpJazalpZdmyzHwkqzTWsmW+MOcjSis1HxQqKplG+CCbBD22a+R/33fO951zvh8/CpcPkkrq
        RNxJThunjlWJpET1S3c3r6V+ujDfllcS5st8j4iZqSonmaLmDpLp7HwsZvrNVoIxjXwgma6a
        QhFT0FmPMfpei4i53/oLY2ytOTiTUdcsZsqe9iN/GduVk42xzw2fxKzJqBOxT0rPsentDQQ7
        PTZAsDlmI2JnTevYi4167JDkmHRHJBd7IonT+uw6Lo3+2BeZcEOHTs9MZqJU1JaBMpGEAnor
        XLVeJjKRlJLTLxDYfkzhAplBcNE2IRLIHIJ716uwf5bR93WY0KhD8K54hBTIVwTnp8yOwSLa
        CywlFxx2BW1AkNaW6rDgtA6Dh0XXcLtKQgfC97k3jrkraX8Yrmj4iymKoF2ge26fvSyj/WDY
        bMQEvALab44SdozTnlBePIkLJznD/Fg5accKOgmaS54hQbMarPNZjkBAm8SQNV5DCIYAGKjW
        LTzBSphoNYsFrITZb3Ui+w1Ax0BWzRahnAJld1oWrLuhsbuQsEtw2h2qanyEVU6Q/XMUE5wy
        uHRBLqhdIe1bz4JzLeTp9aSAWah+8JbMRRsMi4IZFgUzLApg+L/sLiKMaA2XwGuiOH5bwuY4
        7pQ3r9bwiXFR3hHxGhNyfDuPfRZk6AhqQjSFVMtkTP6lMDmpTuKTNU0IKFylkO0pyAiTyyLV
        yWc4bXy4NjGW45vQWopQrZZdIXtC5XSU+iQXw3EJnPZfF6MkylREDqbtdd6e73rQavUsTHa3
        tOQdCPitKHavlLt18wMDy/dXtzdpsqOTpj8k3pr6WlsZrAgbLDm6ri/4dm6OMlfqwy8JHQlp
        O1LmVBESXhCRst6Wz4WOdRrTnV7XbyjfWVuITykt0S6PZLDxbKDS0v855PCQ77hNP1Qa5D/c
        u2nVoIrgo9WbPXAtr/4D18/30HIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWy7bCSvC6XZWecwTkbi5c/r7JZfFq/jNVi
        /pFzrBbnz29gt7i55SiLxabH11gtLu+aw2Yx4/w+Jovu6zvYLJYf/8dk8eN4H7NF694j7BZL
        t95kdOD1uNzXy+Sxc9Zddo9NqzrZPDYvqfdoObmfxePj01ssHn1bVjF6fN4k59F+oJspgDOK
        yyYlNSezLLVI3y6BK2PWhhcsBbNjKl7cf8LUwPjPvYuRk0NCwETiyaW9TF2MXBxCArsZJbb3
        b2eDSEhLXN84gR3CFpZY+e85O0TRK0aJezcugBWxCehK7FjcxgaSEBGYwyix5GsLE0iCWWAy
        k8TSm/wQHR9YJM52rgUbxSngLvH121mwImEBB4mHK/YD2RwcLAIqEle+eYKEeQUsJR5uWcUE
        YQtKnJz5hAViprbE05tP4exlC18zQ1ynIPHz6TJWEFtEoEziyOLtjBA14hJHf/YwT2AUnoVk
        1Cwko2YhGTULScsCRpZVjJKpBcW56bnFhgWGeanlesWJucWleel6yfm5mxjBEauluYPx8pL4
        Q4wCHIxKPLwWUzvihFgTy4orcw8xSnAwK4nwOs5ojRPiTUmsrEotyo8vKs1JLT7EKM3BoiTO
        +zTvWKSQQHpiSWp2ampBahFMlomDU6qBUdDlz5et3WFylxb9bv7+7LS3Z02deN+Tzhff53W+
        O7/d84SvGaeMa9STeg457nKWZfw1i+Y9/lzh/dr66LQLYdWeex59jqmqLHG8U+/m91D3f8vl
        O/wVDr/PufLFZTnteGViYPTyQAwn2925Rm8CJU7u2BW17OuCdSpr33vt/csjbSnSF35FRYml
        OCPRUIu5qDgRAEdZSOTUAgAA
X-CMS-MailID: 20200405014858epcas5p1b1c595090bd46bffee0553c2ce0a293c
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
        <002e01d605df$af658440$0e308cc0$@samsung.com>
        <1182150aff8140a82af17979a09c81676c719e2f.camel@gmail.com>
        <000001d60aad$05e7b6e0$11b724a0$@samsung.com>
        <17aa7c13a0f5a183158829e9b9af85537a740846.camel@gmail.com>
        <58f2996c7dfe70b226c5cafbd94d7b02a314d77a.camel@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Pawel,

> -----Original Message-----
> From: Pawe=C5=82=20Chmiel=20<pawel.mikolaj.chmiel=40gmail.com>=0D=0A>=20S=
ent:=2005=20April=202020=2001:56=0D=0A>=20To:=20Alim=20Akhtar=20<alim.akhta=
r=40samsung.com>;=20robh+dt=40kernel.org;=0D=0A>=20devicetree=40vger.kernel=
.org;=20linux-scsi=40vger.kernel.org=0D=0A>=20Cc:=20krzk=40kernel.org;=20av=
ri.altman=40wdc.com;=20martin.petersen=40oracle.com;=0D=0A>=20kwmad.kim=40s=
amsung.com;=20stanley.chu=40mediatek.com;=0D=0A>=20cang=40codeaurora.org;=
=20linux-samsung-soc=40vger.kernel.org;=20linux-arm-=0D=0A>=20kernel=40list=
s.infradead.org;=20linux-kernel=40vger.kernel.org=0D=0A>=20Subject:=20Re:=
=20=5BPATCH=20v4=205/5=5D=20arm64:=20dts:=20Add=20node=20for=20ufs=20exynos=
7=0D=0A>=20=0D=0A>=20On=20Sat,=202020-04-04=20at=2021:33=20+0200,=20Pawe=C5=
=82=20Chmiel=20wrote:=0D=0A>=20>=20On=20Sat,=202020-04-04=20at=2023:45=20+0=
530,=20Alim=20Akhtar=20wrote:=0D=0A>=20>=20Hi=20Alim,=0D=0A>=20>=20>=20Hi=
=20Pawel,=0D=0A>=20>=20>=0D=0A>=20>=20>=20>=20-----Original=20Message-----=
=0D=0A>=20>=20>=20>=20From:=20Pawe=C5=82=20Chmiel=20<pawel.mikolaj.chmiel=
=40gmail.com>=0D=0A>=20>=20>=20>=20Sent:=2003=20April=202020=2022:22=0D=0A>=
=20>=20>=20>=20To:=20Alim=20Akhtar=20<alim.akhtar=40samsung.com>;=20robh+dt=
=40kernel.org;=0D=0A>=20>=20>=20>=20devicetree=40vger.kernel.org;=20linux-s=
csi=40vger.kernel.org=0D=0A>=20>=20>=20>=20Cc:=20krzk=40kernel.org;=20avri.=
altman=40wdc.com;=0D=0A>=20>=20>=20>=20martin.petersen=40oracle.com;=20kwma=
d.kim=40samsung.com;=0D=0A>=20>=20>=20>=20stanley.chu=40mediatek.com;=20can=
g=40codeaurora.org;=0D=0A>=20>=20>=20>=20linux-samsung-soc=40vger.kernel.or=
g;=20linux-arm-=0D=0A>=20>=20>=20>=20kernel=40lists.infradead.org;=20linux-=
kernel=40vger.kernel.org=0D=0A>=20>=20>=20>=20Subject:=20Re:=20=5BPATCH=20v=
4=205/5=5D=20arm64:=20dts:=20Add=20node=20for=20ufs=20exynos7=0D=0A>=20>=20=
>=20>=0D=0A>=20>=20>=20>=20Hi=20Alim=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=
=20Looking=20at=20vendor=20sources,=20my=20device=20is=20using=20the=20same=
=20gpios=20for=0D=0A>=20>=20>=20>=20urfs_rst_n=20and=20ufs_refclk_out=20lik=
e=20Espresso=20(with=20one=20difference=20-=0D=0A>=20>=20>=20>=20ufs_rst_n=
=20shouldn't=20be=20pulled=20up).=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20A=
bout=20regulators=20(it=20would=20be=20easier=20if=20dts=20would=20have=20a=
ll=20regulators).=0D=0A>=20>=20>=20>=20It's=20also=20using=20s2mps15=20as=
=20Espresso,=20but=20it=20vendor=20dts=20had=20only=208=0D=0A>=20>=20>=20>=
=20(of=0D=0A>=20>=20>=20>=2010=20possible=20bucks,=20one=20missing=20was=20=
for=20UFS)=20and=2014=20ldos=20(of=2027=0D=0A>=20>=20>=20>=20possible),=20w=
here=20almost=20all=20rails=20are=20connected=20to=20something.=0D=0A>=20>=
=20>=20>=0D=0A>=20>=20>=20>=20I'm=20wondering=20how=20it's=20working=20on=
=20Espresso,=20because=20when=20adding=0D=0A>=20>=20>=20>=20correct=20regul=
ators=20for=20ufs=20(vccq=20=3D=20buck10=20from=20s2mps15,=20always=0D=0A>=
=20>=20>=20>=20enabled=20for=20testing=20plus=20vccq2=20and=20vccq=20=3D=20=
two=20regulators=20enabled=0D=0A>=20>=20>=20>=20by=20one=20gpio,=20enabled=
=20at=20boot=20by=20firmware),=20ufs=20wasn't=20still=0D=0A>=20>=20>=20>=20=
working=20because=20it=20was=20then=20failing=20at=20defer=20probe=20(s2mps=
15=20was=0D=0A>=20>=20>=20>=20probed=20after=20ufs)=0D=0A>=20>=20>=20>=0D=
=0A>=20>=20>=20>=20=5B=20=20=20=200.962482=5D=20exynos-ufshc=2015570000.ufs=
:=20ufshcd_get_vreg:=20vccq=20get=0D=0A>=20>=20>=20>=20failed,=20err=3D-517=
=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20As=20I=20said,=20this=20is=20very=20sp=
ecific=20to=20the=20board,=20on=20Espresso=20we=20have=20LDO12=0D=0A>=20con=
nected=20to=20UFS_RESETn.=0D=0A>=20>=20>=20Either=20make=20all=20of=20them=
=20as=20always-on,=20or=20just=20disabled=20s2mps15=0D=0A>=20>=20>=20(defau=
lt=20voltage=20supply=20should=20be=20ok,=20unless=20bootloader=20on=20your=
=0D=0A>=20>=20>=20board=20does=20have=20messed=20too=20much=20with=20PMIC)=
=0D=0A>=20>=20>=0D=0A>=20>=20>=20>=20After=20that=20boot=20would=20just=20s=
top/hang.=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20>=20After=20making=20a=20=22d=
irty=20fix=22=20by=20making=20s2mps15=20regulator=20driver=20use=0D=0A>=20>=
=20>=20>=20subsys_initcall=20(like=20in=20vendor=20sources)=20and=20ufs=20l=
ate_initcall=20(to=0D=0A>=20>=20>=20>=20give=20it=20more=20time=20to=20setu=
p=20and=20get=20it=20working=20and=20solve=20it=20later),=0D=0A>=20>=20>=20=
>=20i=20had=20to=20mark=20following=20clocks=20as=20CLK_IGNORE_UNUSED=20to=
=20be=20able=20to=0D=0A>=20>=20>=20>=20bring=20link=20up=20(it=20replicates=
=20setting=20done=20by=20vendor=20kernel,=20which=0D=0A>=20>=20>=20>=20enab=
les=20them=20on=20boot):=0D=0A>=20>=20>=20>=20-=20=22phyclk_ufs20_rx1_symbo=
l_user=22=0D=0A>=20>=20>=20>=20-=20=22phyclk_ufs20_rx0_symbol_user=22=0D=0A=
>=20>=20>=20>=20-=20=22phyclk_ufs20_tx0_symbol_user=22=0D=0A>=20>=20>=20>=
=0D=0A>=20>=20>=20Coming=20to=20these=20clocks,=20all=20these=20are=20suppl=
ied=20by=20default,=20my=20best=0D=0A>=20>=20>=20guess=20is=20since=20you=
=20are=20using=20an=20actual=20product=20(S6=20edge),=20they=20might=20have=
=0D=0A>=20optimized=20for=20power=20saving=20And=20most=20likely=20all=20cl=
ock=20might=20be=20=20gated=20initially.=20In=0D=0A>=20my=20case=20all=20ar=
e=20set=20to=20default.=0D=0A>=20>=20>=20I=20have=20attached=20a=20small=20=
change=20in=20the=20exynos7=20dts=20and=20phy=20driver=20clock=0D=0A>=20han=
dling,=20please=20try=20this=20attached=20patch=20and=20let=20me=20know=20i=
f=20this=20helps=20in=20removing=0D=0A>=20some=20of=20your=20hacks.=0D=0A>=
=20>=20>=20In=20the=20later=20SoCs=20these=20clocks=20are=20not=20in=20this=
=20form,=20so=20I=20didn't=20included=20in=20my=0D=0A>=20current=20patch=20=
set,=20If=20this=20works=20for=20your,=20will=20add=20as=20an=20optional=20=
for=0D=0A>=20exynos7/7420.=0D=0A>=20>=20>=20I=20also=20assume=20you=20are=
=20using=20clk-exynos7.c=20and=20my=20posted=20ufs=20driver.=0D=0A>=20>=20Y=
es,=20i'm=20using=20clk-exynos7=20(and=20other=20exynos7=20drivers/dts/etc)=
.=0D=0A>=20>=20It=20would=20be=20great=20if=20someone=20could=20say=20how=
=20exynos7=20and=20exynos7420=20are=0D=0A>=20>=20similar.=20For=20now=20it=
=20looks=20like=20that=20only=20difference=20is=20that=20exynos7=0D=0A>=20>=
=20has=20only=204=20cores=20(a57)=20where=207420=20has=204xa53=20+=204xa57.=
=0D=0A>=20>=20It=20would=20be=20very=20valuable=20information=20for=20me=20=
so=20i=20could=20know=20how=20much=0D=0A>=20>=20i=20could=20reuse=20my=20de=
vice.=0D=0A>=20>=20>=20>=20Now=20it's=20able=20to=20bring=20both=20device=
=20and=20link,=20but=20it=20fails=20at=0D=0A>=20>=20>=20>=20ufshcd_uic_chan=
ge_pwr_mode.=0D=0A>=20>=20>=20>=0D=0A>=20>=20>=20Can=20you=20please=20use=
=20the=20exact=20ufs=20and=20ufs-phy=20device=20node=20as=20in=20my=20patch=
?=0D=0A>=20>=20With=20Your=20patch=20+=20removed=20my=20changes=20to=20cloc=
ks=20(removed=20fix=20for=20wrong=0D=0A>=20>=20clock=20order=20in=20dts=20+=
=20removed=20CLK_IGNORE_UNUSED=20from=20symbol=20clocks=20in=0D=0A>=20>=20c=
lk-exynos7)=20it's=20finally=20able=20to=20detect=20my=20UFS=20device=21=21=
=0D=0A>=20>=0D=0A=0D=0AWow,=20great=20to=20know=20that=20UFS=20device=20sta=
rted=20working=20for=20you=20on=20S6.=0D=0A=0D=0A>=20>=20(but=20of=20fails=
=20later...with=20constant=20error=20spam=20in=20kernel=20log).=0D=0A>=20>=
=0D=0A>=20>=20=5B=20=20=20=201.383481=5D=20exynos-ufshc=2015570000.ufs:=20u=
fshcd_populate_vreg:=20Unable=0D=0A>=20>=20to=20find=20vdd-hba-supply=20reg=
ulator,=20assuming=20enabled=0D=0A>=20>=20=5B=20=20=20=201.390060=5D=20exyn=
os-ufshc=2015570000.ufs:=20ufshcd_populate_vreg:=20unable=0D=0A>=20>=20to=
=20find=20vcc-max-microamp=0D=0A>=20>=20=5B=20=20=20=201.398465=5D=20exynos=
-ufshc=2015570000.ufs:=20ufshcd_populate_vreg:=20unable=0D=0A>=20>=20to=20f=
ind=20vccq-max-microamp=0D=0A>=20>=20=5B=20=20=20=201.406968=5D=20exynos-uf=
shc=2015570000.ufs:=20ufshcd_populate_vreg:=20unable=0D=0A>=20>=20to=20find=
=20vccq2-max-microamp=0D=0A>=20>=20=5B=20=20=20=201.415569=5D=20exynos-ufsh=
c=2015570000.ufs:=20ufshcd_init_clocks:=20clk:=0D=0A>=20>=20core_clk,=20rat=
e:=20100000000=0D=0A>=20>=20=5B=20=20=20=201.423715=5D=20exynos-ufshc=20155=
70000.ufs:=20ufshcd_init_clocks:=20clk:=0D=0A>=20>=20sclk_unipro_main,=20ra=
te:=20167000000=0D=0A>=20>=20=5B=20=20=20=201.432569=5D=20exynos-ufshc=2015=
570000.ufs:=20__ufshcd_setup_clocks:=20clk:=0D=0A>=20>=20core_clk=20enabled=
=0D=0A>=20>=20=5B=20=20=20=201.440205=5D=20exynos-ufshc=2015570000.ufs:=20_=
_ufshcd_setup_clocks:=20clk:=0D=0A>=20>=20sclk_unipro_main=20enabled=0D=0A>=
=20>=20=5B=20=20=20=201.449613=5D=20scsi=20host0:=20ufshcd=0D=0A>=20>=20=5B=
=20=20=20=201.452179=5D=20samsung-ufs-phy=2015571800.ufs-phy:=20MPHY=20ref_=
clk_rate=20=3D=0D=0A>=20>=2026000000=0D=0A>=20>=20=5B=20=20=20=201.458448=
=5D=20samsung-ufs-phy=2015571800.ufs-phy:=20MPHY=0D=0A>=20>=20ref_parent_cl=
k_rate=20=3D=2026000000=0D=0A>=20>=20=5B=20=20=20=201.487288=5D=20exynos-uf=
shc=2015570000.ufs:=20ufshcd_print_pwr_info:=5BRX,=0D=0A>=20>=20TX=5D:=20ge=
ar=3D=5B1,=201=5D,=20lane=5B1,=201=5D,=20pwr=5BSLOWAUTO_MODE,=20SLOWAUTO_MO=
DE=5D,=0D=0A>=20rate=0D=0A>=20>=20=3D=0D=0A>=20>=200=0D=0A>=20>=20=5B=20=20=
=20=202.025569=5D=20exynos-ufshc=2015570000.ufs:=20dme-set:=20attr-id=200xd=
041=20val=0D=0A>=20>=200x1fff=20error=20code=201=0D=0A>=20>=20=5B=20=20=20=
=202.025715=5D=20exynos-ufshc=2015570000.ufs:=20dme-set:=20attr-id=200xd041=
=20val=0D=0A>=20>=200x1fff=20failed=200=20retries=0D=0A>=20>=20=5B=20=20=20=
=202.025880=5D=20exynos-ufshc=2015570000.ufs:=20dme-set:=20attr-id=200xd042=
=20val=0D=0A>=20>=200xffff=20error=20code=201=0D=0A>=20>=20=5B=20=20=20=202=
.027354=5D=20exynos-ufshc=2015570000.ufs:=20dme-set:=20attr-id=200xd042=20v=
al=0D=0A>=20>=200xffff=20failed=200=20retries=0D=0A>=20>=20=5B=20=20=20=202=
.035583=5D=20exynos-ufshc=2015570000.ufs:=20dme-set:=20attr-id=200xd043=20v=
al=0D=0A>=20>=200x7fff=20error=20code=201=0D=0A>=20>=20=5B=20=20=20=202.043=
465=5D=20exynos-ufshc=2015570000.ufs:=20dme-set:=20attr-id=200xd043=20val=
=0D=0A>=20>=200x7fff=20failed=200=20retries=0D=0A>=20>=20=5B=20=20=20=202.0=
54049=5D=20exynos-ufshc=2015570000.ufs:=20Power=20mode=20change=200=20:=20F=
ast=0D=0A>=20>=20series_B=20G_2=20L_2=0D=0A>=20>=20=5B=20=20=20=202.059261=
=5D=20exynos-ufshc=2015570000.ufs:=20ufshcd_print_pwr_info:=5BRX,=0D=0A>=20=
>=20TX=5D:=20gear=3D=5B2,=202=5D,=20lane=5B2,=202=5D,=20pwr=5BFAST=20MODE,=
=20FAST=20MODE=5D,=20rate=20=3D=202=0D=0A>=20>=20=5B=20=20=20=202.071307=5D=
=20exynos-ufshc=2015570000.ufs:=20ufshcd_init_icc_levels:=0D=0A>=20>=20sett=
ing=20icc_level=200x0=0D=0A>=20>=20=5B=20=20=20=202.081624=5D=20exynos-ufsh=
c=2015570000.ufs:=20ufshcd_set_queue_depth:=0D=0A>=20>=20activate=20tcq=20w=
ith=20queue=20depth=201=0D=0A>=20>=20=5B=20=20=20=202.087576=5D=20scsi=200:=
0:0:49488:=20scsi_add_lun:=20correcting=20incorrect=0D=0A>=20>=20peripheral=
=20device=20type=200x0=20for=20W-LUN=200x=20=20=20=20=20=20=20=20=20=20=20=
=20c150hN=0D=0A>=20>=20=5B=20=20=20=202.098400=5D=20scsi=200:0:0:49488:=20W=
ell-known=20LUN=20=20=20=20SAMSUNG=20=20KLUBG4G1BD-=0D=0A>=20>=20E0B1=20=20=
0200=20PQ:=200=20ANSI:=206=0D=0A>=20>=20=5B=20=20=20=202.107585=5D=20exynos=
-ufshc=2015570000.ufs:=20ufshcd_set_queue_depth:=0D=0A>=20>=20activate=20tc=
q=20with=20queue=20depth=2016=0D=0A>=20>=20=5B=20=20=20=202.115588=5D=20scs=
i=200:0:0:49476:=20scsi_add_lun:=20correcting=20incorrect=0D=0A>=20>=20peri=
pheral=20device=20type=200x0=20for=20W-LUN=200x=20=20=20=20=20=20=20=20=20=
=20=20=20c144hN=0D=0A>=20>=20=5B=20=20=20=202.126519=5D=20scsi=200:0:0:4947=
6:=20Well-known=20LUN=20=20=20=20SAMSUNG=20=20KLUBG4G1BD-=0D=0A>=20>=20E0B1=
=20=200200=20PQ:=200=20ANSI:=206=0D=0A>=20>=20=5B=20=20=20=202.135534=5D=20=
exynos-ufshc=2015570000.ufs:=20ufshcd_set_queue_depth:=0D=0A>=20>=20activat=
e=20tcq=20with=20queue=20depth=201=0D=0A>=20>=20=5B=20=20=20=202.143612=5D=
=20scsi=200:0:0:49456:=20scsi_add_lun:=20correcting=20incorrect=0D=0A>=20>=
=20peripheral=20device=20type=200x0=20for=20W-LUN=200x=20=20=20=20=20=20=20=
=20=20=20=20=20c130hN=0D=0A>=20>=20=5B=20=20=20=202.154543=5D=20scsi=200:0:=
0:49456:=20Well-known=20LUN=20=20=20=20SAMSUNG=20=20KLUBG4G1BD-=0D=0A>=20>=
=20E0B1=20=200200=20PQ:=200=20ANSI:=206=0D=0A>=20>=20=5B=20=20=20=202.16359=
7=5D=20exynos-ufshc=2015570000.ufs:=20ufshcd_set_queue_depth:=0D=0A>=20>=20=
activate=20tcq=20with=20queue=20depth=2016=0D=0A>=20>=20=5B=20=20=20=202.17=
1721=5D=20scsi=200:0:0:0:=20Direct-Access=20=20=20=20=20SAMSUNG=20=20KLUBG4=
G1BD-=0D=0A>=20>=20E0B1=20=200200=20PQ:=200=20ANSI:=206=0D=0A>=20>=20=5B=20=
=20=20=202.180352=5D=20exynos-ufshc=2015570000.ufs:=20OCS=20error=20from=20=
controller=20=3D=207=0D=0A>=20>=20for=20tag=200=0D=0A>=20>=20=5B=20=20=20=
=202.186921=5D=20host_regs:=2000000000:=200383ff0f=2000000000=2000000200=20=
00000000=0D=0A>=20>=20=5B=20=20=20=202.193230=5D=20host_regs:=2000000010:=
=2000000101=2000007fce=2000000c96=2000000000=0D=0A>=20>=20=5B=20=20=20=202.=
199565=5D=20host_regs:=2000000020:=2000000000=2000030e75=2000000000=2000000=
000=0D=0A>=20>=20=5B=20=20=20=202.205899=5D=20host_regs:=2000000030:=200000=
010f=2000000000=2080000010=2000000000=0D=0A>=20>=20=5B=20=20=20=202.212234=
=5D=20host_regs:=2000000040:=2000000000=2000000000=2000000000=2000000000=0D=
=0A>=20>=20=5B=20=20=20=202.218568=5D=20host_regs:=2000000050:=20f8d64000=
=2000000000=2000000000=2000000000=0D=0A>=20>=20=5B=20=20=20=202.224903=5D=
=20host_regs:=2000000060:=2000000001=2000000000=2000000000=2000000000=0D=0A=
>=20>=20=5B=20=20=20=202.231237=5D=20host_regs:=2000000070:=20f8da2000=2000=
000000=2000000000=2000000000=0D=0A>=20>=20=5B=20=20=20=202.237572=5D=20host=
_regs:=2000000080:=2000000001=2000000000=2000000000=2000000000=0D=0A>=20>=
=20=5B=20=20=20=202.243907=5D=20host_regs:=2000000090:=2000000002=209519000=
0=2000000000=2000000000=0D=0A>=20>=20=5B=20=20=20=202.250242=5D=20exynos-uf=
shc=2015570000.ufs:=20hba->ufs_version=20=3D=200x200,=0D=0A>=20>=20hba->cap=
abilities=20=3D=200x383ff0f=0D=0A>=20>=0D=0A>=20>=20Full=20bootlog=0D=0A>=
=20>=20https://protect2.fireeye.com/url?k=3Dedbae146-b069b8f8-edbb6a09-0cc4=
7a31=0D=0A>=20>=20ba82-=0D=0A>=208b13b1e4caed34d7&q=3D1&u=3Dhttps%3A%2F%2Fg=
ist.github.com%2FPabloPL%2F=0D=0A>=20>=200bcb24492f4ab6e9703c2a4ea20ceb18=
=20kernel=20source:=0D=0A>=20>=20https://protect2.fireeye.com/url?k=3D75038=
dec-28d0d452-750206a3-0cc47a31=0D=0A>=20>=20ba82-=0D=0A>=204c366bec6fc01e64=
&q=3D1&u=3Dhttps%3A%2F%2Fgithub.com%2FPabloPL%2Flinux=0D=0A>=20>=20%2Ftree%=
2Fufs-mainline=20dts=20file:=20exynos7-zeroflt.dts=20(it=20should=20be=0D=
=0A>=20>=20zerolt,=20but=20will=20be=20fixed/changed=20later).=0D=0A>=20=0D=
=0A>=20Actually,=20after=20waiting=20enough=20time=20(about=2015=20or=20eve=
n=20more=20sec=20of=20that=20error=0D=0A>=20=22spam=22),=20was=20able=20to=
=20mount=20partitions=20and=20manipulate=20files=20there.=0D=0A>=20=0D=0AYo=
u=20need=20below=20patch=20and=20=20a=20change=20in=20the=20ufs=20driver:=
=0D=0Ahttps://www.spinics.net/lists/linux-scsi/msg138501.html=0D=0A=0D=0AAn=
d=0D=0A=0D=0Adiff=20--git=20a/drivers/scsi/ufs/ufs-exynos.c=20b/drivers/scs=
i/ufs/ufs-exynos.c=0D=0Aindex=20ce2c3d674e4b..c6332deff03a=20100644=0D=0A--=
-=20a/drivers/scsi/ufs/ufs-exynos.c=0D=0A+++=20b/drivers/scsi/ufs/ufs-exyno=
s.c=0D=0A=40=40=20-1359,7=20+1359,8=20=40=40=20struct=20exynos_ufs_drv_data=
=20exynos_ufs_drvs=20=3D=20=7B=0D=0A=20=20=20=20=20=20=20=20.quirks=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=3D=20UFSHCD_QUIRK_PRDT_BYTE_G=
RAN=20=7C=0D=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR=
=20=7C=0D=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20UFSHCI_QUIRK_BROKEN_HCE=20=7C=0D=0A-=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR,=0D=0A+=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR=20=7C=0D=0A+=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR,=0D=0A=20=20=20=20=20=20=20=
=20.opts=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=3D=20EXYN=
OS_UFS_OPT_HAS_APB_CLK_CTRL=20=7C=0D=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20EXYNOS_UF=
S_OPT_BROKEN_AUTO_CLK_CTRL=20=7C=0D=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20EXYNOS_UF=
S_OPT_BROKEN_RX_SEL_IDX,=0D=0A=0D=0A>=20So=20for=20me=20the=20only=20issue=
=20to=20solve=20are=20defered=20probe=20when=20regulators=20are=20not=20yet=
=0D=0A>=20found=20(for=20example=20when=20pmic=20is=20probed=20after=20ufs)=
=20and=20not=20sure=20what=20about=20that=0D=0A>=20errors=20(despite=20work=
ing=20ufs).=0D=0A>=20=0D=0AThe=20error=20will=20go=20away=20with=20the=20ab=
ove=20changes,=20about=20regulators,=20you=20need=20to=20figure=20it=20out,=
=20as=20I=20am=20not=20aware=20of=20Galaxy=20S6=20PMIC=20schemes.=0D=0AI=20=
also=20seek=20your=20Tested-by=20tag=20on=20these=20patches=20.=0D=0A=0D=0A=
>=20Thanks=20for=20all=0D=0A=0D=0AThanks=20for=20helping=20in=20testing.=0D=
=0A>=20>=0D=0A>=20>=20Thanks=0D=0A=0D=0A=0D=0A
