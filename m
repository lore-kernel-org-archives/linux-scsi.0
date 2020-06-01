Return-Path: <SRS0=+zlT=7O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82329C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 01:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59FA0207F7
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Jun 2020 01:30:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oPP8PgLY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgFABa6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 May 2020 21:30:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64393 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgFABa6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2020 21:30:58 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200601013054epoutp03699638bd4fb5417c68ceca1df4ede3e8~UR2IXF9TU1984419844epoutp03e
        for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2020 01:30:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200601013054epoutp03699638bd4fb5417c68ceca1df4ede3e8~UR2IXF9TU1984419844epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1590975055;
        bh=JTwM6QCv9nPVaQSrpu86bU9wEvCr6ibtM4h10TLt4uM=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=oPP8PgLYXw5MUmexbW0D09rXUDRhdb4UKCcr1EIG10/1beP3pnykUTMdkJlgBFrRe
         r2wv5l9c2vEBsWN7Lm5mlxTCxP3GcJ/DC+XCN0xX5uh+hbrdUAO4UMRA6sUQVIqNyA
         xlqjutKHyH27XZZo/sdO30Hd832e6zTAD25lKQME=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200601013054epcas5p3e3b771e73d2063448fed84381c2c9c87~UR2Hysudi1677916779epcas5p3A;
        Mon,  1 Jun 2020 01:30:54 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        21.B8.09703.E4A54DE5; Mon,  1 Jun 2020 10:30:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200601013053epcas5p37291890b3a1a3b05f835824f942e1343~UR2G2jgC41677916779epcas5p3-;
        Mon,  1 Jun 2020 01:30:53 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200601013053epsmtrp143ecd481342151a64371a0a0f20965f3~UR2G1FOKS0981709817epsmtrp1e;
        Mon,  1 Jun 2020 01:30:53 +0000 (GMT)
X-AuditID: b6c32a4a-4cbff700000025e7-af-5ed45a4edcf7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.F4.08382.D4A54DE5; Mon,  1 Jun 2020 10:30:53 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200601013050epsmtip16ddfaaa880272854cac9badb2a61012c~UR2D-OdVi2353723537epsmtip1U;
        Mon,  1 Jun 2020 01:30:50 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzk@kernel.org>
Cc:     <robh@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <20200529080546.GB23221@kozik-lap>
Subject: RE: [PATCH v10 10/10] arm64: dts: Add node for ufs exynos7
Date:   Mon, 1 Jun 2020 07:00:48 +0530
Message-ID: <000001d637b4$49ff2ff0$ddfd8fd0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIpylB333LdzxFXBilpc4hv6O2l1ANHKSouAge4CJsBYqHLHqfmR7Iw
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmlq5f1JU4g5vbRSxe/rzKZvFp/TJW
        i/lHzrFanD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNYfvwfk8X/PTvYLZZuvcno
        wONxua+XyWPTqk42j81L6j1aTu5n8fj49BaLR9+WVYwenzfJebQf6GYK4IjisklJzcksSy3S
        t0vgymhpTirYz1Vx7fgOxgbGE5xdjJwcEgImEn//3GXsYuTiEBLYzShx9PxnJgjnE6PEpGmf
        WCGcb4wSz3/1s8C0TLo5lxkisZdR4vzVdywQzhtGiRV3TrOCVLEJ6ErsWNzGBmKLANmbbyxn
        ByliFjjJJHGkr4cJJMEpoC/x6f82sCJhAWeJs8eegTWzCKhIzLv7BayGV8BS4vOrWywQtqDE
        yZlPwGxmAW2JZQtfM0OcpCDx8+kyVohlbhIn/lxjgqgRlzj6swfsVAmBExwSrX/aGSEaXCTa
        d3yF+kdY4tXxLewQtpTEy/42IJsDyM6W6NllDBGukVg67xhUub3EgStzWEBKmAU0Jdbv0odY
        xSfR+/sJE0Qnr0RHmxBEtapE87urUJ3SEhO7u1khbA+JM2suME1gVJyF5LFZSB6bheSBWQjL
        FjCyrGKUTC0ozk1PLTYtMMpLLdcrTswtLs1L10vOz93ECE5qWl47GB8++KB3iJGJg/EQowQH
        s5II72T1S3FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZV+nIkTEkhPLEnNTk0tSC2CyTJxcEo1
        MHk9blaVVxBbkvq180m2TU3+jY3XVtyfX1W4hnvlaeFa/qqdr/7IpP+cekRJjflSZrzhyp2p
        R/eqCgrpbdaS/uCo5FL96+wiGcMp814seL+vdp2oipcl2+drrlcW1E/afKqBf5m7wb1u+c5I
        n1e377BtTny78mHovPv/zG80i0/q3qMlfuZow6lr899bTPOZo2ttLXR/onRwE397MHN2bdek
        M3OMhdkcarcI2ankXF95forfNrWTrCaejYVxcumcBQpO3Vv3Xexzniv4OHlv2ea6lL6mz1NN
        ec9VhMWVb1rC0/z5pPXrXZ9v6tw2/uo/8/2j7DMNJxVNNBhDHTvX3br7csO2KY7G/w/GsBbH
        zVNiKc5INNRiLipOBADHO5102QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWy7bCSnK5v1JU4g1VPBC1e/rzKZvFp/TJW
        i/lHzrFanD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNYfvwfk8X/PTvYLZZuvcno
        wONxua+XyWPTqk42j81L6j1aTu5n8fj49BaLR9+WVYwenzfJebQf6GYK4IjisklJzcksSy3S
        t0vgylj8/RRzwSuOir17JrA3MG5g72Lk5JAQMJGYdHMucxcjF4eQwG5GiVMH5jFBJKQlrm+c
        AFUkLLHy33N2iKJXQEX/N7CCJNgEdCV2LG5jA7FFgOzNN5aDFTELXGaS+LN0LSNEx2NGiXkf
        NrCAVHEK6Et8+r8NrENYwFni7LFnYJNYBFQk5t39AraaV8BS4vOrWywQtqDEyZlPwGxmAW2J
        pzefwtnLFr5mhjhPQeLn02WsEFe4SZz4c40JokZc4ujPHuYJjMKzkIyahWTULCSjZiFpWcDI
        sopRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzhCtTR3MG5f9UHvECMTB+MhRgkOZiUR
        3snql+KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ894oXBgnJJCeWJKanZpakFoEk2Xi4JRqYFo4
        Z2rl7TXZh7Lbn+m2pTVWrDSblZBpcXtn+xb2Ww+dmVcdclxfFM3YXNnGPvHEV6+XceurvmQ8
        nPph18O0X/m5bxd6Wd2pjD5Z4759vmiYoLCsfOEtjo/7k1jC9WZk9pkYRsTtYvu86ygjQ+7i
        BZ3z3+sZlRco/D+0+C/L/I0XrpgKsygknXnVNHU7d9Xb/N+ezgxiQVcVew/9XWttl3YjOV0h
        eFaH+0EzPi0j0W+mFgENCb6N7it9sprr7l4Se3Ax6Fuei/4lXbln1v/4ZCSXWs7yXDFhySy2
        ogSbcy/Zw0UuXovVklL5e2cyt10xw+SCXyrLP6scn2ca1XxY43muUUPT61ccQZpXtq3dpsRS
        nJFoqMVcVJwIAF9Aeww/AwAA
X-CMS-MailID: 20200601013053epcas5p37291890b3a1a3b05f835824f942e1343
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013245epcas5p37851891649512882c7b1ffb5f903c506
References: <20200528011658.71590-1-alim.akhtar@samsung.com>
        <CGME20200528013245epcas5p37851891649512882c7b1ffb5f903c506@epcas5p3.samsung.com>
        <20200528011658.71590-11-alim.akhtar@samsung.com>
        <20200529080546.GB23221@kozik-lap>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Krzysztof Kozlowski <krzk=40kernel.org>
> Sent: 29 May 2020 13:36
> To: Alim Akhtar <alim.akhtar=40samsung.com>
> Cc: robh=40kernel.org; devicetree=40vger.kernel.org; linux-scsi=40vger.ke=
rnel.org;
> avri.altman=40wdc.com; martin.petersen=40oracle.com;
> kwmad.kim=40samsung.com; stanley.chu=40mediatek.com;
> cang=40codeaurora.org; linux-samsung-soc=40vger.kernel.org; linux-arm-
> kernel=40lists.infradead.org; linux-kernel=40vger.kernel.org
> Subject: Re: =5BPATCH v10 10/10=5D arm64: dts: Add node for ufs exynos7
>=20
> On Thu, May 28, 2020 at 06:46:58AM +0530, Alim Akhtar wrote:
> > Adding dt node foe UFS and UFS-PHY for exynos7 SoC.
> >
> > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
> > Tested-by: Pawe=C5=82=20Chmiel=20<pawel.mikolaj.chmiel=40gmail.com>=0D=
=0A>=20>=20---=0D=0A>=20>=20=20.../boot/dts/exynos/exynos7-espresso.dts=20=
=20=20=20=20=20=7C=20=204=20++=0D=0A>=20>=20=20arch/arm64/boot/dts/exynos/e=
xynos7.dtsi=20=20=20=20=20=20=20=7C=2043=20++++++++++++++++++-=0D=0A>=20=0D=
=0A>=20Thanks,=20applied=20to=20next/dt-late.=20It=20might=20miss=20this=20=
merge=20window=20and=20in=20such=0D=0A>=20case=20I=20will=20keep=20it=20for=
=20v5.9=20cycle.=0D=0AThanks=20Krzysztof.=0D=0A>=20=0D=0A>=20Best=20regards=
,=0D=0A>=20Krzysztof=0D=0A=0D=0A=0D=0A
