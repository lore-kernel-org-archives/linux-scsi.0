Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77330C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 05:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09C3D206E2
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 05:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="l7iDo7Sx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgGKFxl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 01:53:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11294 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgGKFxl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 01:53:41 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200711055336epoutp032d4575f1b74e012b2b548bb49b30d263~gnO6frWgm3207232072epoutp03Z
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2020 05:53:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200711055336epoutp032d4575f1b74e012b2b548bb49b30d263~gnO6frWgm3207232072epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594446816;
        bh=aOeyCHsBvTAWvXRJdCLVJ5cVrBDdg9LPkn0qPJ+fpZc=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=l7iDo7Sxn4cuOvIV1voZqe1+2zxn42BHYr+pxtvDoUqKegXYTyGUP6WSFra4x9yXo
         KkMTbqF+LjTVqzhDHbSPbzfuAWaMx260CJTK++ngfDV0IrHaEgr5UsdhQS6IaGHwqA
         +YZJPm1RZxMJeXaItQO4n5GZJhuXIFX+EAQ17Vfg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200711055335epcas2p424198585cbf07ce1b0c2673f835d999d~gnO5M-KMM1298612986epcas2p4o;
        Sat, 11 Jul 2020 05:53:35 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B3fGj2lhbzMqYkY; Sat, 11 Jul
        2020 05:53:33 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        8B.F9.27441.DD3590F5; Sat, 11 Jul 2020 14:53:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200711055332epcas2p104e6a5adcd5ba82a9f8ddba43c147ef5~gnO23gEmf0112501125epcas2p15;
        Sat, 11 Jul 2020 05:53:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200711055332epsmtrp1bd8fbd6305bfdd3f5f6ac4851bd4fbae~gnO22qUKw0148801488epsmtrp16;
        Sat, 11 Jul 2020 05:53:32 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-ee-5f0953ddd449
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.48.08382.CD3590F5; Sat, 11 Jul 2020 14:53:32 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200711055332epsmtip2e09aec7fb41c1e20290236a1bc172b00~gnO2jk2i92005220052epsmtip2m;
        Sat, 11 Jul 2020 05:53:32 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB46401E72E1C0C4B8FEBF6156FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RESEND RFC PATCH v4 2/3] ufs: exynos: introduce command
 history
Date:   Sat, 11 Jul 2020 14:53:32 +0900
Message-ID: <000a01d65747$9c0c3ab0$d424b010$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ3IuC2j48zjcAhrcL1upjrEzI4TgHBLgI6Ae9pZ38AwrMW2KecrGpw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJsWRmVeSWpSXmKPExsWy7bCmme7dYM54gxX3eS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEZVjk5Ga
        mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
        ILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQwMDIFKgyISejoamF
        pWDZLcaKPX1XmRsYW68wdjFyckgImEj0/e8Gsrk4hAR2MEq0ztrPDOF8YpR4sbEHyvnGKNH1
        /yILTMvnVx+YIBJ7GSW23nkM1f+CUWJC52WwKjYBbYlpD3ezgiREBO4zSRzZ+QAowcHBKRAr
        cfdPMEiNsIC/xM4Zr8DqWQRUJXr/tLOD2LwClhI3755hhLAFJU7OfAJWwww0c9nC18wQVyhI
        /Hy6jBXEFhFwk3j57T5UjYjE7M42qJoTHBKdV2QhbBeJ2xe3QMWFJV4d38IOYUtJvOxvg7Lr
        JfZNbQC7WUKgh1Hi6b5/0FAylpj1rJ0R5H5mAU2J9bv0QUwJAWWJI7eg1vJJdBz+yw4R5pXo
        aBOCaFSW+DVpMtQQSYmZN+9AbfKQODVpK9sERsVZSJ6cheTJWUiemYWwdwEjyypGsdSC4tz0
        1GKjAmPk6N7ECE7QWu47GGe8/aB3iJGJg/EQowQHs5IIb7QoZ7wQb0piZVVqUX58UWlOavEh
        RlNgsE9klhJNzgfmiLySeENTIzMzA0tTC1MzIwslcd5iqwtxQgLpiSWp2ampBalFMH1MHJxS
        DUzJNyWz1VOKa+LMZGtvJTxe/9EresGmI7pyKrJ7n9nMmugh8/GntBXXI/aH7utKdLrXCFdw
        qu11N4mqvspwMnmFY1JhoIXv1xnrD/uxWjVeb7lcysJt/fat7fUbko59E8yjw9Y/3VlaH7wl
        fN+k9ydz/y74oh7Pd3VpyBwG5gnydyo8ZFczHk+xmfzQUeqx+gZ5X6PZ3y+9zf2V+OaE66ke
        D14OjzCheYxiX264iM3fPJXtSOyH/uvZDxZmHitafC6i3cRjq/X8SN9rao+7nq/e/tZoq5OX
        mVPpheqpS3eJyYU/eSAr1SOXc82dQ//CpI8NPvl3/PbKf3LjuCGRnfw198+iX9d4l5VJvFXf
        3aDEUpyRaKjFXFScCABe8StGWQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWy7bCSvO6dYM54gz9LtC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEcVlk5Ka
        k1mWWqRvl8CVceD3dpaCU62MFfuu7mJvYNwe38XIySEhYCLx+dUHpi5GLg4hgd2MEr+brjBC
        JCQlTux8DmULS9xvOcIKUfSMUWLGvVksIAk2AW2JaQ93gyVEBN4ySdy5fRlq1GomiR9z+4Ha
        OTg4BWIl7v4JBmkQFvCVuP7lDhOIzSKgKtH7p50dxOYVsJS4efcMI4QtKHFy5hOwBcxAC3of
        tjLC2MsWvmaGuEhB4ufTZawgtoiAm8TLb/eh6kUkZne2MU9gFJqFZNQsJKNmIRk1C0nLAkaW
        VYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwTGppbmDcfuqD3qHGJk4GA8xSnAwK4nw
        RotyxgvxpiRWVqUW5ccXleakFh9ilOZgURLnvVG4ME5IID2xJDU7NbUgtQgmy8TBKdXAxJS9
        3Dcvtbigio35lOGmqeXRpgye4r2TvL6qn4zPbSxZZa6qej14j82/pZUrGkI7z4Q9W3OHYWnm
        vLp5Mj194is/MDWvC5mzit1l362fsQ/0lx/3tootund7KcMXo5ifJ1knXzNWTeLPcln3lPvU
        pN8fDV7uMnr5o9OC52z9xUmFKUyJ/bsfnN5x8klPRztny9fPj97+DriQsfjePlmTVxPSOx5t
        Nn926rJR/cYsCYX+h7waQYwuskGiD3errT/F4K+6Qzt4Qd+Tg9UP3q/Rup4Xcs1x4TlNjsNn
        95tF2C25Z3tohULIvdUKWzx8+V40r4ld8183e+L92NSjG9gbOuY/ZzqbwmAj3ndmiWdvlRJL
        cUaioRZzUXEiAHBLXvE4AwAA
X-CMS-MailID: 20200711055332epcas2p104e6a5adcd5ba82a9f8ddba43c147ef5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708023156epcas2p416ac7979ed0a0a7a71de1636defb0ec7
References: <cover.1594174981.git.kwmad.kim@samsung.com>
        <CGME20200708023156epcas2p416ac7979ed0a0a7a71de1636defb0ec7@epcas2p4.samsung.com>
        <da700e31d9a8598c247269746aef3c09a92e71e8.1594174981.git.kwmad.kim@samsung.com>
        <SN6PR04MB46401E72E1C0C4B8FEBF6156FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > This includes functions to record contexts of incoming commands in a
> > circular queue. ufshcd.c has already some function tracer calls to get
> > command history but ftrace would be gone when system dies before you
> > get the information, such as panic cases.
> Maybe add one more line explaining how you are handling dump_on_oops
> differently

Even dump_on_oops eventually run by software, that means there is a possibi=
lity
to access system memory. I don=E2=80=99t=20assume=20only=20conditions=20whe=
re=20memory=20accesses=0D=0Awork.=20In=20abnormal=20cases,=20methods=20in=
=20kernel=20doesn't=20work=20and=20you=20just=20need=20to=20dump=0D=0Amemor=
y=20in=20another=20software=20after=20resetting=20system=20with=20keeping=
=20data=20in=20system=20memory.=0D=0ADump_on_oops=20doesn't=20guarantee=20t=
hose=20situations.=0D=0A=0D=0A>=20=0D=0A>=20>=0D=0A>=20>=20This=20patch=20a=
lso=20implements=20callbacks=20compl_xfer_req=20to=20store=20IO=0D=0A>=20>=
=20contexts=20at=20completion=20times.=0D=0A>=20>=0D=0A>=20>=20When=20you=
=20turn=20on=20CONFIG_SCSI_UFS_EXYNOS_CMD_LOG,=20the=20driver=20collects=0D=
=0A>=20>=20the=20information=20from=20incoming=20commands=20in=20the=20circ=
ular=20queue.=0D=0A>=20>=0D=0A>=20>=20Signed-off-by:=20Kiwoong=20Kim=20<kwm=
ad.kim=40samsung.com>=0D=0A>=20>=20---=0D=0A>=20>=20=20drivers/scsi/ufs/Kco=
nfig=20=20=20=20=20=20=20=20=20=20=7C=20=2014=20+++=0D=0A>=20>=20=20drivers=
/scsi/ufs/Makefile=20=20=20=20=20=20=20=20=20=7C=20=20=202=20+-=0D=0A>=20>=
=20=20drivers/scsi/ufs/ufs-exynos-dbg.c=20=7C=20201=0D=0A>=20>=20++++++++++=
++++++++++++++++++++++++++++=0D=0A>=20>=20=20drivers/scsi/ufs/ufs-exynos-if=
.h=20=20=7C=20=2017=20++++=0D=0A>=20>=20=20drivers/scsi/ufs/ufs-exynos.c=20=
=20=20=20=20=7C=20=2037=20+++++++=0D=0A>=20>=20=20drivers/scsi/ufs/ufs-exyn=
os.h=20=20=20=20=20=7C=20=2012=20+++=0D=0A>=20>=20=206=20files=20changed,=
=20282=20insertions(+),=201=20deletion(-)=20=20create=20mode=20100644=0D=0A=
>=20>=20drivers/scsi/ufs/ufs-exynos-dbg.c=20=20create=20mode=20100644=0D=0A=
>=20>=20drivers/scsi/ufs/ufs-exynos-if.h=0D=0A>=20>=0D=0A>=20>=20diff=20--g=
it=20a/drivers/scsi/ufs/Kconfig=20b/drivers/scsi/ufs/Kconfig=20index=0D=0A>=
=20>=208cd9026..ebab446=20100644=0D=0A>=20>=20---=20a/drivers/scsi/ufs/Kcon=
fig=0D=0A>=20>=20+++=20b/drivers/scsi/ufs/Kconfig=0D=0A>=20>=20=40=40=20-17=
2,3=20+172,17=20=40=40=20config=20SCSI_UFS_EXYNOS=0D=0A>=20>=0D=0A>=20>=20=
=20=20=20=20=20=20=20=20=20=20Select=20this=20if=20you=20have=20UFS=20host=
=20controller=20on=20EXYNOS=20chipset.=0D=0A>=20>=20=20=20=20=20=20=20=20=
=20=20=20If=20unsure,=20say=20N.=0D=0A>=20>=20+=0D=0A>=20>=20+config=20SCSI=
_UFS_EXYNOS_CMD_LOG=0D=0A>=20>=20+=20=20=20=20=20=20=20bool=20=22EXYNOS=20s=
pecific=20command=20log=22=0D=0A>=20>=20+=20=20=20=20=20=20=20default=20n=
=0D=0A>=20>=20+=20=20=20=20=20=20=20depends=20on=20SCSI_UFS_EXYNOS=0D=0A>=
=20>=20+=20=20=20=20=20=20=20help=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=
This=20selects=20EXYNOS=20specific=20functions=20to=20get=20and=20even=20pr=
int=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20some=20information=20to=20see=
=20what's=20happening=20at=20both=20command=0D=0A>=20>=20+=20=20=20=20=20=
=20=20=20=20issue=20time=20completion=20time.=0D=0A>=20>=20+=20=20=20=20=20=
=20=20=20=20The=20information=20may=20contain=20gerernal=20things=20as=20we=
ll=20as=0D=0A>=20Typo:=20gerernal=20->=20general=0D=0AGot=20it=0D=0A=0D=0A>=
=20=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20EXYNOS=20specific,=20such=20as=
=20vendor=20specific=20hardware=20contexts.=0D=0A>=20>=20+=0D=0A>=20>=20+=
=20=20=20=20=20=20=20=20=20Select=20this=20if=20you=20want=20to=20get=20and=
=20print=20the=20information.=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20If=
=20unsure,=20say=20N.=0D=0A>=20>=20diff=20--git=20a/drivers/scsi/ufs/Makefi=
le=20b/drivers/scsi/ufs/Makefile=0D=0A>=20>=20index=20f0c5b95..d9e4da7=2010=
0644=0D=0A>=20>=20---=20a/drivers/scsi/ufs/Makefile=0D=0A>=20>=20+++=20b/dr=
ivers/scsi/ufs/Makefile=0D=0A>=20>=20=40=40=20-4,7=20+4,7=20=40=40=20obj-=
=24(CONFIG_SCSI_UFS_DWC_TC_PCI)=20+=3D=20tc-dwc-g210-pci.o=0D=0A>=20>=20ufs=
hcd-dwc.o=20tc-dwc-g210.=0D=0A>=20>=20=20obj-=24(CONFIG_SCSI_UFS_DWC_TC_PLA=
TFORM)=20+=3D=20tc-dwc-g210-pltfrm.o=0D=0A>=20>=20ufshcd-dwc.o=20tc-dwc-g21=
0.o=0D=0A>=20>=20=20obj-=24(CONFIG_SCSI_UFS_CDNS_PLATFORM)=20+=3D=20cdns-pl=
tfrm.o=0D=0A>=20>=20=20obj-=24(CONFIG_SCSI_UFS_QCOM)=20+=3D=20ufs-qcom.o=0D=
=0A>=20>=20-obj-=24(CONFIG_SCSI_UFS_EXYNOS)=20+=3D=20ufs-exynos.o=0D=0A>=20=
>=20+obj-=24(CONFIG_SCSI_UFS_EXYNOS)=20+=3D=20ufs-exynos.o=20ufs-exynos-dbg=
.o=0D=0A>=20If=20the=20key=20functionality=20depends=20on=20SCSI_UFS_EXYNOS=
_CMD_LOG,=20Why=20not=20use=0D=0A>=20it=20for=20make=20as=20well,=20and=20i=
n=20your=20header=20as=20well?=0D=0A>=20=0D=0A>=20>=20=20obj-=24(CONFIG_SCS=
I_UFSHCD)=20+=3D=20ufshcd-core.o=0D=0A>=20>=20=20ufshcd-core-y=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20+=3D=20uf=
shcd.o=20ufs-sysfs.o=0D=0A>=20>=20=20ufshcd-core-=24(CONFIG_SCSI_UFS_BSG)=
=20=20=20=20=20+=3D=20ufs_bsg.o=0D=0A>=20>=20diff=20--git=20a/drivers/scsi/=
ufs/ufs-exynos-dbg.c=0D=0A>=20>=20b/drivers/scsi/ufs/ufs-exynos-=20dbg.c=20=
new=20file=20mode=20100644=20index=0D=0A>=20>=200000000..0663026=0D=0A>=20>=
=20---=20/dev/null=0D=0A>=20>=20+++=20b/drivers/scsi/ufs/ufs-exynos-dbg.c=
=0D=0A>=20>=20=40=40=20-0,0=20+1,201=20=40=40=0D=0A>=20>=20+//=20SPDX-Licen=
se-Identifier:=20GPL-2.0-only=0D=0A>=20>=20+/*=0D=0A>=20>=20+=20*=20UFS=20E=
xynos=20debugging=20functions=0D=0A>=20>=20+=20*=0D=0A>=20>=20+=20*=20Copyr=
ight=20(C)=202020=20Samsung=20Electronics=20Co.,=20Ltd.=0D=0A>=20>=20+=20*=
=20Author:=20Kiwoong=20Kim=20<kwmad.kim=40samsung.com>=0D=0A>=20>=20+=20*=
=0D=0A>=20>=20+=20*/=0D=0A>=20>=20+=23include=20<linux/platform_device.h>=
=0D=0A>=20>=20+=23include=20<linux/module.h>=0D=0A>=20>=20+=23include=20=22=
ufshcd.h=22=0D=0A>=20>=20+=23include=20=22ufs-exynos-if.h=22=0D=0A>=20>=20+=
=0D=0A>=20>=20+=23define=20MAX_CMD_LOGS=20=20=20=2032=0D=0A>=20>=20+=0D=0A>=
=20>=20+struct=20cmd_data=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20unsigned=
=20int=20tag;=0D=0A>=20>=20+=20=20=20=20=20=20=20unsigned=20int=20sct;=0D=
=0A>=20>=20+=20=20=20=20=20=20=20u64=20lba;=0D=0A>=20>=20+=20=20=20=20=20=
=20=20u64=20start_time;=0D=0A>=20>=20+=20=20=20=20=20=20=20u64=20end_time;=
=0D=0A>=20>=20+=20=20=20=20=20=20=20u64=20outstanding_reqs;=0D=0A>=20>=20+=
=20=20=20=20=20=20=20int=20retries;=0D=0A>=20>=20+=20=20=20=20=20=20=20u8=
=20op;=0D=0A>=20>=20+=7D;=0D=0A>=20>=20+=0D=0A>=20>=20+struct=20ufs_cmd_inf=
o=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20u32=20total;=0D=0A>=20>=20+=20=
=20=20=20=20=20=20u32=20last;=0D=0A>=20>=20+=20=20=20=20=20=20=20struct=20c=
md_data=20data=5BMAX_CMD_LOGS=5D;=0D=0A>=20>=20+=20=20=20=20=20=20=20struct=
=20cmd_data=20*pdata=5BMAX_CMD_LOGS=5D;=20=7D;=0D=0A>=20>=20+=0D=0A>=20>=20=
+/*=0D=0A>=20>=20+=20*=20This=20structure=20points=20out=20several=20contex=
ts=20on=20debugging=0D=0A>=20>=20+=20*=20per=20one=20host=20instant.=0D=0A>=
=20>=20+=20*=20Now=20command=20history=20exists=20in=20here=20but=20later=
=20handle=20may=0D=0A>=20>=20+=20*=20contains=20some=20mmio=20base=20addres=
ses=20including=20vendor=20specific=0D=0A>=20>=20+=20*=20regions=20to=20get=
=20hardware=20contexts.=0D=0A>=20>=20+=20*/=0D=0A>=20>=20+struct=20ufs_s_db=
g_mgr=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20struct=20ufs_exynos_handle=
=20*handle;=0D=0A>=20>=20+=20=20=20=20=20=20=20int=20active;=0D=0A>=20>=20+=
=20=20=20=20=20=20=20u64=20first_time;=0D=0A>=20>=20+=20=20=20=20=20=20=20u=
64=20time;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20/*=20cmd=20log=
=20*/=0D=0A>=20>=20+=20=20=20=20=20=20=20struct=20ufs_cmd_info=20cmd_info;=
=0D=0A>=20>=20+=20=20=20=20=20=20=20struct=20cmd_data=20cmd_log;=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20/*=20temp=20buffer=20to=20put=20*/=
=0D=0A>=20>=20+=20=20=20=20=20=20=20spinlock_t=20cmd_lock;=0D=0A>=20>=20+=
=7D;=0D=0A>=20>=20+=0D=0A>=20>=20+static=20void=20ufs_s_print_cmd_log(struc=
t=20ufs_s_dbg_mgr=20*mgr,=20struct=0D=0A>=20>=20+device=0D=0A>=20>=20*dev)=
=0D=0A>=20>=20+=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20struct=20ufs_cmd_info=
=20*cmd_info=20=3D=20&mgr->cmd_info;=0D=0A>=20>=20+=20=20=20=20=20=20=20str=
uct=20cmd_data=20*data=20=3D=20cmd_info->data;=0D=0A>=20>=20+=20=20=20=20=
=20=20=20u32=20i;=0D=0A>=20>=20+=20=20=20=20=20=20=20u32=20last;=0D=0A>=20>=
=20+=20=20=20=20=20=20=20u32=20max=20=3D=20MAX_CMD_LOGS;=0D=0A>=20>=20+=20=
=20=20=20=20=20=20unsigned=20long=20flags;=0D=0A>=20>=20+=20=20=20=20=20=20=
=20u32=20total;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20spin_lock=
_irqsave(&mgr->cmd_lock,=20flags);=0D=0A>=20>=20+=20=20=20=20=20=20=20total=
=20=3D=20cmd_info->total;=0D=0A>=20>=20+=20=20=20=20=20=20=20if=20(cmd_info=
->total=20<=20max)=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20max=20=3D=20cmd_info->total;=0D=0A>=20>=20+=20=20=20=20=20=20=20last=20=
=3D=20(cmd_info->last=20+=20MAX_CMD_LOGS=20-=201)=20%=20MAX_CMD_LOGS;=0D=0A=
>=20>=20+=20=20=20=20=20=20=20spin_unlock_irqrestore(&mgr->cmd_lock,=20flag=
s);=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20dev_err(dev,=20=22:--=
------------------------------------------------=0D=0A>=20-=5Cn=22);=0D=0A>=
=20>=20+=20=20=20=20=20=20=20dev_err(dev,=20=22:=5Ct=5CtSCSI=20CMD(%u)=5Cn=
=22,=20total=20-=201);=0D=0A>=20>=20+=20=20=20=20=20=20=20dev_err(dev,=20=
=22:--------------------------------------------------=0D=0A>=20-=5Cn=22);=
=0D=0A>=20>=20+=20=20=20=20=20=20=20dev_err(dev,=20=22:OP,=20TAG,=20LBA,=20=
SCT,=20RETRIES,=20STIME,=20ETIME,=0D=0A>=20>=20+=20REQS=5Cn=5Cn=22);=0D=0A>=
=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20for=20(i=20=3D=200=20;=20i=20<=
=20max=20;=20i++,=20data++)=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20dev_err(dev,=20=22:=200x%02x,=20%02d,=200x%08llx,=200x%04=
x,=20%d,=0D=0A>=20>=20+=20%llu,=20%llu,=0D=0A>=20>=200x%llx=20%s=22,=0D=0A>=
=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20data->op,=20data->tag,=20data->lba,=20data->sct,=20data-=0D=0A>=20>retri=
es,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20data->start_time,=20data->end_time,=20data-=0D=0A>=20>outstandi=
ng_reqs,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20((last=20=3D=3D=20i)=20?=20=22<--=22=20:=20=22=20=22));=
=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20if=20(last=20=
=3D=3D=20i)=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20dev_err(dev,=20=22=5Cn=22);=0D=0A>=20>=20+=20=20=20=20=
=20=20=20=7D=0D=0A>=20>=20+=7D=0D=0A>=20Since=20you=20cache=20last,=20why=
=20not=20printing=20from=20first=20to=20last=20instead=20of=0D=0A>=20markin=
g=20it?=0D=0AGot=20it=20and=20this=20looks=20that=20because=20it's=20easy=
=20to=20make.=0D=0A=0D=0A>=20=0D=0A>=20=0D=0A>=20>=20+=0D=0A>=20>=20+static=
=20void=20ufs_s_put_cmd_log(struct=20ufs_s_dbg_mgr=20*mgr,=0D=0A>=20>=20+=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20struct=20cmd_data=20*cmd_data)=20=7B=0D=0A>=20>=20+=20=20=20=20=
=20=20=20struct=20ufs_cmd_info=20*cmd_info=20=3D=20&mgr->cmd_info;=0D=0A>=
=20>=20+=20=20=20=20=20=20=20unsigned=20long=20flags;=0D=0A>=20>=20+=20=20=
=20=20=20=20=20struct=20cmd_data=20*pdata;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=
=20=20=20=20=20=20spin_lock_irqsave(&mgr->cmd_lock,=20flags);=0D=0A>=20>=20=
+=20=20=20=20=20=20=20pdata=20=3D=20&cmd_info->data=5Bcmd_info->last=5D;=0D=
=0A>=20>=20+=20=20=20=20=20=20=20++cmd_info->total;=0D=0A>=20>=20+=20=20=20=
=20=20=20=20++cmd_info->last;=0D=0A>=20>=20+=20=20=20=20=20=20=20cmd_info->=
last=20=3D=20cmd_info->last=20%=20MAX_CMD_LOGS;=0D=0A>=20>=20+=20=20=20=20=
=20=20=20spin_unlock_irqrestore(&mgr->cmd_lock,=20flags);=0D=0A>=20>=20+=0D=
=0A>=20>=20+=20=20=20=20=20=20=20pdata->op=20=3D=20cmd_data->op;=0D=0A>=20>=
=20+=20=20=20=20=20=20=20pdata->tag=20=3D=20cmd_data->tag;=0D=0A>=20>=20+=
=20=20=20=20=20=20=20pdata->lba=20=3D=20cmd_data->lba;=0D=0A>=20>=20+=20=20=
=20=20=20=20=20pdata->sct=20=3D=20cmd_data->sct;=0D=0A>=20>=20+=20=20=20=20=
=20=20=20pdata->retries=20=3D=20cmd_data->retries;=0D=0A>=20>=20+=20=20=20=
=20=20=20=20pdata->start_time=20=3D=20cmd_data->start_time;=0D=0A>=20>=20+=
=20=20=20=20=20=20=20pdata->end_time=20=3D=200;=0D=0A>=20>=20+=20=20=20=20=
=20=20=20pdata->outstanding_reqs=20=3D=20cmd_data->outstanding_reqs;=0D=0A>=
=20>=20+=20=20=20=20=20=20=20cmd_info->pdata=5Bcmd_data->tag=5D=20=3D=20pda=
ta;=20=7D=0D=0A>=20>=20+=0D=0A>=20>=20+/*=0D=0A>=20>=20+=20*=20EXTERNAL=20F=
UNCTIONS=0D=0A>=20>=20+=20*=0D=0A>=20>=20+=20*=20There=20are=20two=20classe=
s=20that=20are=20to=20initialize=20data=20structures=20for=0D=0A>=20>=20+de=
bug=0D=0A>=20>=20+=20*=20and=20to=20define=20actual=20behavior.=0D=0A>=20>=
=20+=20*/=0D=0A>=20>=20+void=20exynos_ufs_dump_info(struct=20ufs_exynos_han=
dle=20*handle,=20struct=0D=0A>=20>=20+device=0D=0A>=20>=20*dev)=0D=0A>=20>=
=20+=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20struct=20ufs_s_dbg_mgr=20*mgr=20=
=3D=20(struct=20ufs_s_dbg_mgr=0D=0A>=20>=20+*)handle->private;=0D=0A>=20>=
=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20if=20(mgr->active=20=3D=3D=200)=0D=
=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20goto=20out;=0D=0A>=
=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20mgr->time=20=3D=20cpu_clock(raw=
_smp_processor_id());=0D=0A>=20>=20+=0D=0A>=20>=20+=23ifdef=20CONFIG_SCSI_U=
FS_EXYNOS_CMD_LOG=0D=0A>=20>=20+=20=20=20=20=20=20=20ufs_s_print_cmd_log(mg=
r,=20dev);=20=23endif=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20if=
=20(mgr->first_time=20=3D=3D=200ULL)=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20mgr->first_time=20=3D=20mgr->time;=0D=0A>=20>=20+out:=
=0D=0A>=20>=20+=20=20=20=20=20=20=20return;=0D=0A>=20>=20+=7D=0D=0A>=20>=20=
+=0D=0A>=20>=20+void=20exynos_ufs_cmd_log_start(struct=20ufs_exynos_handle=
=20*handle,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20struct=20ufs_hba=20*hba,=20struct=20=
scsi_cmnd=0D=0A>=20>=20+*cmd)=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20stru=
ct=20ufs_s_dbg_mgr=20*mgr=20=3D=20(struct=20ufs_s_dbg_mgr=20*)handle-=0D=0A=
>=20>private;=0D=0A>=20>=20+=20=20=20=20=20=20=20int=20cpu=20=3D=20raw_smp_=
processor_id();=0D=0A>=20>=20+=20=20=20=20=20=20=20struct=20cmd_data=20*cmd=
_log=20=3D=20&mgr->cmd_log;=20=20=20=20=20=20=20/*=20temp=20buffer=20to=0D=
=0A>=20put=0D=0A>=20>=20*/=0D=0A>=20>=20+=20=20=20=20=20=20=20u64=20lba=20=
=3D=20(cmd->cmnd=5B2=5D=20<<=2024)=20=7C=0D=0A>=20>=20+=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20(cmd->cmnd=5B3=5D=20<<=2016)=20=7C=0D=0A>=20>=20+=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20(cmd->cmnd=5B4=5D=20<<=208)=20=7C=
=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20(cmd->cmnd=5B5=5D=
=20<<=200);=0D=0A>=20Use=20put_unaligned?=0D=0A>=20=0D=0A>=20>=20+=20=20=20=
=20=20=20=20unsigned=20int=20sct=20=3D=20(cmd->cmnd=5B7=5D=20<<=208)=20=7C=
=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20(cmd->cmnd=5B8=5D=
=20<<=200);=0D=0A>=20ditto=0D=0A>=20=0D=0AGot=20it.=0D=0A=0D=0A>=20>=20+=0D=
=0A>=20>=20+=20=20=20=20=20=20=20if=20(mgr->active=20=3D=3D=200)=0D=0A>=20>=
=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20return;=0D=0A>=20>=20+=0D=
=0A>=20>=20+=20=20=20=20=20=20=20cmd_log->start_time=20=3D=20cpu_clock(cpu)=
;=0D=0A>=20>=20+=20=20=20=20=20=20=20cmd_log->op=20=3D=20cmd->cmnd=5B0=5D;=
=0D=0A>=20>=20+=20=20=20=20=20=20=20cmd_log->tag=20=3D=20cmd->request->tag;=
=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20/*=20This=20function=20r=
untime=20is=20protected=20by=20spinlock=20from=20outside=20*/=0D=0A>=20>=20=
+=20=20=20=20=20=20=20cmd_log->outstanding_reqs=20=3D=20hba->outstanding_re=
qs;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20/*=20unmap=20*/=0D=0A=
>=20>=20+=20=20=20=20=20=20=20if=20(cmd->cmnd=5B0=5D=20=21=3D=20UNMAP)=0D=
=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20cmd_log->lba=20=3D=
=20lba;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20cmd_log->sct=20=
=3D=20sct;=0D=0A>=20>=20+=20=20=20=20=20=20=20cmd_log->retries=20=3D=20cmd-=
>allowed;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20ufs_s_put_cmd_l=
og(mgr,=20cmd_log);=20=7D=0D=0A>=20>=20+=0D=0A>=20>=20+void=20exynos_ufs_cm=
d_log_end(struct=20ufs_exynos_handle=20*handle,=0D=0A>=20>=20+=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20struct=
=20ufs_hba=20*hba,=20struct=20scsi_cmnd=0D=0A>=20>=20+*cmd)=20=7B=0D=0A>=20=
>=20+=20=20=20=20=20=20=20struct=20ufs_s_dbg_mgr=20*mgr=20=3D=20(struct=20u=
fs_s_dbg_mgr=20*)handle-=0D=0A>=20>private;=0D=0A>=20>=20+=20=20=20=20=20=
=20=20struct=20ufs_cmd_info=20*cmd_info=20=3D=20&mgr->cmd_info;=0D=0A>=20>=
=20+=20=20=20=20=20=20=20int=20cpu=20=3D=20raw_smp_processor_id();=0D=0A>=
=20>=20+=20=20=20=20=20=20=20int=20tag=20=3D=20cmd->request->tag;=0D=0A>=20=
>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20if=20(mgr->active=20=3D=3D=200)=0D=
=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20return;=0D=0A>=20>=
=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20cmd_info->pdata=5Btag=5D->end_time=
=20=3D=20cpu_clock(cpu);=20=7D=0D=0A>=20>=20+=0D=0A>=20>=20+int=20exynos_uf=
s_init_dbg(struct=20ufs_exynos_handle=20*handle,=20struct=0D=0A>=20>=20+dev=
ice=0D=0A>=20>=20*dev)=0D=0A>=20>=20+=7B=0D=0A>=20>=20+=20=20=20=20=20=20=
=20struct=20ufs_s_dbg_mgr=20*mgr;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=
=20=20=20mgr=20=3D=20devm_kzalloc(dev,=20sizeof(struct=20ufs_s_dbg_mgr),=20=
GFP_KERNEL);=0D=0A>=20>=20+=20=20=20=20=20=20=20if=20(=21mgr)=0D=0A>=20>=20=
+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20return=20-ENOMEM;=0D=0A>=20>=
=20+=20=20=20=20=20=20=20handle->private=20=3D=20(void=20*)mgr;=0D=0A>=20>=
=20+=20=20=20=20=20=20=20mgr->handle=20=3D=20handle;=0D=0A>=20>=20+=20=20=
=20=20=20=20=20mgr->active=20=3D=201;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=
=20=20=20=20=20/*=20cmd=20log=20*/=0D=0A>=20>=20+=20=20=20=20=20=20=20spin_=
lock_init(&mgr->cmd_lock);=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=
=20return=200;=0D=0A>=20>=20+=7D=0D=0A>=20>=20+MODULE_AUTHOR(=22Kiwoong=20K=
im=20<kwmad.kim=40samsung.com>=22);=0D=0A>=20>=20+MODULE_DESCRIPTION(=22Exy=
nos=20UFS=20debug=20information=22);=0D=0A>=20>=20+MODULE_LICENSE(=22GPL=22=
);=20MODULE_VERSION(=220.1=22);=0D=0A>=20>=20diff=20--git=20a/drivers/scsi/=
ufs/ufs-exynos-if.h=0D=0A>=20>=20b/drivers/scsi/ufs/ufs-exynos-if.h=0D=0A>=
=20>=20new=20file=20mode=20100644=0D=0A>=20>=20index=200000000..c746f59=0D=
=0A>=20>=20---=20/dev/null=0D=0A>=20>=20+++=20b/drivers/scsi/ufs/ufs-exynos=
-if.h=0D=0A>=20>=20=40=40=20-0,0=20+1,17=20=40=40=0D=0A>=20>=20+/*=20SPDX-L=
icense-Identifier:=20GPL-2.0-only=20*/=0D=0A>=20>=20+/*=0D=0A>=20>=20+=20*=
=20UFS=20Exynos=20debugging=20functions=0D=0A>=20>=20+=20*=0D=0A>=20>=20+=
=20*=20Copyright=20(C)=202020=20Samsung=20Electronics=20Co.,=20Ltd.=0D=0A>=
=20>=20+=20*=20Author:=20Kiwoong=20Kim=20<kwmad.kim=40samsung.com>=0D=0A>=
=20>=20+=20*=0D=0A>=20>=20+=20*/=0D=0A>=20>=20+=23ifndef=20_UFS_EXYNOS_IF_H=
_=0D=0A>=20>=20+=23define=20_UFS_EXYNOS_IF_H_=0D=0A>=20>=20+=0D=0A>=20>=20+=
/*=20more=20members=20would=20be=20added=20in=20the=20future=20*/=20struct=
=0D=0A>=20>=20+ufs_exynos_handle=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20v=
oid=20*private;=0D=0A>=20>=20+=7D;=0D=0A>=20>=20+=0D=0A>=20>=20+=23endif=20=
/*=20_UFS_EXYNOS_IF_H_=20*/=0D=0A>=20>=20diff=20--git=20a/drivers/scsi/ufs/=
ufs-exynos.c=0D=0A>=20>=20b/drivers/scsi/ufs/ufs-exynos.c=20index=20440f2af=
..8c60f7d=20100644=0D=0A>=20>=20---=20a/drivers/scsi/ufs/ufs-exynos.c=0D=0A=
>=20>=20+++=20b/drivers/scsi/ufs/ufs-exynos.c=0D=0A>=20>=20=40=40=20-700,11=
=20+700,31=20=40=40=20static=20int=20exynos_ufs_post_pwr_mode(struct=0D=0A>=
=20>=20ufs_hba=20*hba,=0D=0A>=20>=20=20=20=20=20=20=20=20=20return=200;=0D=
=0A>=20>=20=20=7D=0D=0A>=20>=0D=0A>=20>=20+=23ifdef=20CONFIG_SCSI_UFS_EXYNO=
S_CMD_LOG=20static=20void=0D=0A>=20>=20+exynos_ufs_cmd_log(struct=20ufs_hba=
=20*hba,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20struct=20scsi_cmnd=20*cmd,=20int=20e=
nter)=0D=0A>=20Maybe=20make=20it=20static=20inline=20in=20you=20header,=20e=
.g.=20ufs-exynos-if.h,=20And=20make=0D=0A>=20it=20empty=20if=20CONFIG_SCSI_=
UFS_EXYNOS_CMD_LOG=20is=20not=20defined?=0D=0A>=20=0D=0A>=20>=20+=7B=0D=0A>=
=20>=20+=20=20=20=20=20=20=20struct=20exynos_ufs=20*ufs=20=3D=20ufshcd_get_=
variant(hba);=0D=0A>=20>=20+=20=20=20=20=20=20=20struct=20ufs_exynos_handle=
=20*handle=20=3D=20&ufs->handle;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=
=20=20=20if=20(enter=20=3D=3D=201)=0D=0A>=20Maybe=20use=20=22start=22=20ins=
tead=20of=20=22enter=22=0D=0A>=20If=20(start)=0D=0A>=20=20=20=20....=0D=0A>=
=20else=0D=0A>=20=20=20=20....=0D=0AGot=20it.=0D=0A=0D=0A>=20=0D=0A>=20>=20=
+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20exynos_ufs_cmd_log_start(hand=
le,=20hba,=20cmd);=0D=0A>=20>=20+=20=20=20=20=20=20=20else=20if=20(enter=20=
=3D=3D=202)=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20exyn=
os_ufs_cmd_log_end(handle,=20hba,=20cmd);=20=7D=20=23endif=0D=0A>=20>=20+=
=0D=0A>=20>=20=20static=20void=20exynos_ufs_specify_nexus_t_xfer_req(struct=
=20ufs_hba=20*hba,=0D=0A>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20int=20tag,=20bool=20op)=20=20=7B=0D=0A>=20>=20=
=20=20=20=20=20=20=20=20struct=20exynos_ufs=20*ufs=20=3D=20ufshcd_get_varia=
nt(hba);=0D=0A>=20>=20=20=20=20=20=20=20=20=20u32=20type;=0D=0A>=20>=20+=23=
ifdef=20CONFIG_SCSI_UFS_EXYNOS_CMD_LOG=0D=0A>=20>=20+=20=20=20=20=20=20=20s=
truct=20scsi_cmnd=20*cmd=20=3D=20hba->lrb=5Btag=5D.cmd;=0D=0A>=20>=20+=0D=
=0A>=20>=20+=20=20=20=20=20=20=20if=20(op)=0D=0A>=20>=20+=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20exynos_ufs_cmd_log(hba,=20cmd,=201);=20=23endif=
=0D=0A>=20>=0D=0A>=20>=20=20=20=20=20=20=20=20=20type=20=3D=20=20hci_readl(=
ufs,=20HCI_UTRL_NEXUS_TYPE);=0D=0A>=20>=0D=0A>=20>=20=40=40=20-714,6=20+734=
,16=20=40=40=20static=20void=0D=0A>=20>=20exynos_ufs_specify_nexus_t_xfer_r=
eq(struct=20ufs_hba=20*hba,=0D=0A>=20>=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20hci_writel(ufs,=20type=20&=20=7E(1=20<<=20tag),=0D=0A>=20>=
=20HCI_UTRL_NEXUS_TYPE);=20=20=7D=0D=0A>=20>=0D=0A>=20>=20+static=20void=20=
exynos_ufs_compl_xfer_req(struct=20ufs_hba=20*hba,=20int=20tag,=0D=0A>=20>=
=20+bool=20op)=20=7B=20=23ifdef=20CONFIG_SCSI_UFS_EXYNOS_CMD_LOG=0D=0A>=20>=
=20+=20=20=20=20=20=20=20struct=20scsi_cmnd=20*cmd=20=3D=20hba->lrb=5Btag=
=5D.cmd;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20if=20(op)=0D=0A>=
=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20exynos_ufs_cmd_log(hba=
,=20cmd,=202);=20=23endif=20=7D=0D=0A>=20>=20+=0D=0A>=20>=20=20static=20voi=
d=20exynos_ufs_specify_nexus_t_tm_req(struct=20ufs_hba=20*hba,=0D=0A>=20>=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20int=
=20tag,=20u8=20func)=20=20=7B=0D=0A>=20>=20=40=40=20-1008,6=20+1038,12=20=
=40=40=20static=20int=20exynos_ufs_init(struct=20ufs_hba=20*hba)=0D=0A>=20>=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20goto=20out;=0D=0A>=20>=
=20=20=20=20=20=20=20=20=20exynos_ufs_specify_phy_time_attr(ufs);=0D=0A>=20=
>=20=20=20=20=20=20=20=20=20exynos_ufs_config_smu(ufs);=0D=0A>=20>=20+=0D=
=0A>=20>=20+=20=20=20=20=20=20=20/*=20init=20dbg=20*/=0D=0A>=20>=20+=20=20=
=20=20=20=20=20ret=20=3D=20exynos_ufs_init_dbg(&ufs->handle,=20dev);=0D=0A>=
=20>=20+=20=20=20=20=20=20=20if=20(ret)=0D=0A>=20>=20+=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20return=20ret;=0D=0A>=20>=20+=20=20=20=20=20=20=20sp=
in_lock_init(&ufs->dbg_lock);=0D=0A>=20>=20=20=20=20=20=20=20=20=20return=
=200;=0D=0A>=20>=0D=0A>=20>=20=20phy_off:=0D=0A>=20>=20=40=40=20-1217,6=20+=
1253,7=20=40=40=20static=20struct=20ufs_hba_variant_ops=0D=0A>=20>=20ufs_hb=
a_exynos_ops=20=3D=20=7B=0D=0A>=20>=20=20=20=20=20=20=20=20=20.link_startup=
_notify=20=20=20=20=20=20=20=20=20=20=20=20=3D=20exynos_ufs_link_startup_no=
tify,=0D=0A>=20>=20=20=20=20=20=20=20=20=20.pwr_change_notify=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=3D=20exynos_ufs_pwr_change_notify,=0D=0A>=20=
>=20=20=20=20=20=20=20=20=20.setup_xfer_req=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=3D=20exynos_ufs_specify_nexus_t_xfer_req,=0D=0A>=20>=
=20+=20=20=20=20=20=20=20.compl_xfer_req=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=3D=20exynos_ufs_compl_xfer_req,=0D=0A>=20>=20=20=20=20=
=20=20=20=20=20.setup_task_mgmt=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=3D=20exynos_ufs_specify_nexus_t_tm_req,=0D=0A>=20>=20=20=20=20=20=20=
=20=20=20.hibern8_notify=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=3D=20exynos_ufs_hibern8_notify,=0D=0A>=20>=20=20=20=20=20=20=20=20=20.susp=
end=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=3D=20exynos_ufs_suspend,=0D=0A>=20>=20diff=20--git=20a/drivers/scsi/ufs/uf=
s-exynos.h=0D=0A>=20>=20b/drivers/scsi/ufs/ufs-exynos.h=20index=2076d6e39..=
c947fd8=20100644=0D=0A>=20>=20---=20a/drivers/scsi/ufs/ufs-exynos.h=0D=0A>=
=20>=20+++=20b/drivers/scsi/ufs/ufs-exynos.h=0D=0A>=20>=20=40=40=20-8,6=20+=
8,7=20=40=40=0D=0A>=20>=0D=0A>=20>=20=20=23ifndef=20_UFS_EXYNOS_H_=0D=0A>=
=20>=20=20=23define=20_UFS_EXYNOS_H_=0D=0A>=20>=20+=23include=20=22ufs-exyn=
os-if.h=22=0D=0A>=20>=0D=0A>=20>=20=20/*=0D=0A>=20>=20=20=20*=20UNIPRO=20re=
gisters=0D=0A>=20>=20=40=40=20-212,6=20+213,10=20=40=40=20struct=20exynos_u=
fs=20=7B=0D=0A>=20>=20=20=23define=20EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL=20=
=20=20=20BIT(2)=0D=0A>=20>=20=20=23define=20EXYNOS_UFS_OPT_BROKEN_RX_SEL_ID=
X=20=20=20=20=20=20=20BIT(3)=0D=0A>=20>=20=20=23define=20EXYNOS_UFS_OPT_USE=
_SW_HIBERN8_TIMER=20=20=20=20BIT(4)=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=
=20=20=20=20struct=20ufs_exynos_handle=20handle;=0D=0A>=20>=20+=20=20=20=20=
=20=20=20spinlock_t=20dbg_lock;=0D=0A>=20>=20+=20=20=20=20=20=20=20int=20un=
der_dump;=0D=0A>=20>=20=20=7D;=0D=0A>=20>=0D=0A>=20>=20=20=23define=20for_e=
ach_ufs_rx_lane(ufs,=20i)=20=5C=20=40=40=20-284,4=20+289,11=20=40=40=20stru=
ct=0D=0A>=20>=20exynos_ufs_uic_attr=20exynos7_uic_attr=20=3D=20=7B=0D=0A>=
=20>=20=20=20=20=20=20=20=20=20.rx_hs_g3_prep_sync_len_cap=20=20=20=20=20=
=3D=20PREP_LEN(0xf),=0D=0A>=20>=20=20=20=20=20=20=20=20=20.pa_dbg_option_su=
ite=20=20=20=20=20=20=20=20=20=20=20=20=3D=200x30103,=0D=0A>=20>=20=20=7D;=
=0D=0A>=20>=20+=0D=0A>=20>=20+/*=20public=20function=20declarations=20*/=0D=
=0A>=20>=20+void=20exynos_ufs_cmd_log_start(struct=20ufs_exynos_handle=20*h=
andle,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20struct=20ufs_hba=20*hba,=20struct=20scsi_c=
mnd=0D=0A>=20>=20+*cmd);=20void=20exynos_ufs_cmd_log_end(struct=20ufs_exyno=
s_handle=20*handle,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20struct=20ufs_hba=20*hba,=20struct=
=20scsi_cmnd=0D=0A>=20>=20+*cmd);=20int=20exynos_ufs_init_dbg(struct=20ufs_=
exynos_handle=20*handle,=0D=0A>=20>=20+struct=20device=0D=0A>=20>=20*dev);=
=0D=0A>=20>=20=20=23endif=20/*=20_UFS_EXYNOS_H_=20*/=0D=0A>=20>=20--=0D=0A>=
=20>=202.7.4=0D=0A=0D=0A=0D=0A=0D=0AThanks.=0D=0AKiwoong=20Kim=0D=0A=0D=0A
