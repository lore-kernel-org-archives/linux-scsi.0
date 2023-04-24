Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27132C7618E
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Apr 2023 04:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjDXE75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Apr 2023 00:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDXE74 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2023 00:59:56 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465071FD9
        for <linux-scsi@vger.kernel.org>; Sun, 23 Apr 2023 21:59:53 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230424045948epoutp0117e89eadaef39c3f212b9985ec5a4065~YxjRbAdA90349703497epoutp01b
        for <linux-scsi@vger.kernel.org>; Mon, 24 Apr 2023 04:59:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230424045948epoutp0117e89eadaef39c3f212b9985ec5a4065~YxjRbAdA90349703497epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682312389;
        bh=r8vskFTR/8vbMX2Nlv3gLnik44kdnBVA7+JxKUlcJhs=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=LEH7I+FHEh+WGWVm26vogg33Nllprqb2NQCwoiMIYQUS98fcO2GaR5UdO+lxDpMx6
         2Sd79S4V4Zfz3g6fJD6qoYuSPCyU/K19H5kVEuUP+g5wRJdvjy68XThiouJwPlufe/
         Upa9mt9YyqmtHEvrNCY8wiOlogvfPUs4S/Ecr1tU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20230424045948epcas2p47e6f8ee6e986f09bf6b44773c2fdfebe~YxjRH17Af1124811248epcas2p4Q;
        Mon, 24 Apr 2023 04:59:48 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.99]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Q4XxH6cc6z4x9QF; Mon, 24 Apr
        2023 04:59:47 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B1.51.10686.3CC06446; Mon, 24 Apr 2023 13:59:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20230424045947epcas2p3ab053c5db5f3bcc4dfb6d61eba12b68b~YxjQFNR6W1122011220epcas2p3D;
        Mon, 24 Apr 2023 04:59:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230424045947epsmtrp19dcae82bbd75500ca16a8444870f477b~YxjQEd-Sn1647716477epsmtrp11;
        Mon, 24 Apr 2023 04:59:47 +0000 (GMT)
X-AuditID: b6c32a46-c81ff700000029be-12-64460cc30198
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.B5.08279.3CC06446; Mon, 24 Apr 2023 13:59:47 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230424045947epsmtip2fdad611f85efa1050cb3ff7b3429ba80~YxjP7wU5l3217532175epsmtip29;
        Mon, 24 Apr 2023 04:59:47 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <linux-scsi@vger.kernel.org>
In-Reply-To: <DM6PR04MB65758403CC6D31654A98BB43FC669@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v1] ufs: poll pmc until another pa request is
 completed
Date:   Mon, 24 Apr 2023 13:59:47 +0900
Message-ID: <004101d97669$97c787e0$c75697a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJP9gJUoCjR96O/MrSEsAj5GtwPhAHiSdtdAqjpsnYCxZ6HC64SXSeA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsWy7bCmue5hHrcUg7cvTS1e/rzKZtF9fQeb
        A5PH501yHu0HupkCmKKybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1Nt
        lVx8AnTdMnOAxisplCXmlAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCswL9IoTc4tL89L1
        8lJLrAwNDIxMgQoTsjNe///AUvC3oOLmJtcGxuc5XYycHBICJhJrepYydzFycQgJ7GCUWPPu
        IiuE84lR4vHy+VCZb4wSZ1+8A8pwgLU03zGGiO9llPja8pwJwnnJKNHetJYVZC6bgLbEtIe7
        wWwRAXeJf1+vMoPYnAKxEr86njCC2MICgRLfXj5iB7FZBFQlDr2eygRi8wpYShz7PJUdwhaU
        ODnzCQuIzQw0c9nC18wQdytI/Hy6DGq+m0Tr3s2sEDUiErM728CulhA4xS5xZPVFNoirXSQ2
        rBSH6BWWeHV8CzuELSXxsr+NHaIkW2LPQjGIcIXE4mlvWSBsY4lZz9oZQUqYBTQl1u/Sh6hW
        ljhyC+owPomOw3+hhvBKdLQJQTQqS/yaNJkRwpaUmHnzDtROD4k7894wT2BUnIXkxVlIXpyF
        5JVZCHsXMLKsYhRLLSjOTU8tNiowgkd0cn7uJkZwqtNy28E45e0HvUOMTByMhxglOJiVRHg9
        Sp1ShHhTEiurUovy44tKc1KLDzGaAgN9IrOUaHI+MNnmlcQbmlgamJiZGZobmRqYK4nzStue
        TBYSSE8sSc1OTS1ILYLpY+LglGpgalwRLRXRwM+yi2GNsPW6M6YFu0KrNz2Nm/dM/8ePSWf5
        v/OESp+fy+Re/XpGaO3lRypr4720u24mPmUudoi4M3PnkRrdfTIvujcv50pWUXEKTT/qepLF
        pD0xZdMcBhnfu/P+rdzIOfniuY95IszBXpey2G6oXLgTJZP/QoAp+7HvJ/sLF14osf9a8dt8
        b8cnLp+If5sbNJdGGLLMSHwfvmOKxr9Evra9Z4TDUx/dfeSpf/H7cpWIVR1VPfe5Tb8u7djz
        NvUyd1jqt5+qajsnBezXi5H89Kwueafb2bNJLsnWZhOf2Ra4z2wPZggVPGblpqfh3ynzd6OE
        eIrwx/70U9s/vWNadz19EafNtSsTlFiKMxINtZiLihMBfXFZ2/4DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSvO5hHrcUg6trZC1e/rzKZtF9fQeb
        A5PH501yHu0HupkCmKK4bFJSczLLUov07RK4MlqfPGAumOVScexXP2MD4xW9LkYODgkBE4nm
        O8ZdjFwcQgK7GSWOHNvN0sXICRSXlDix8zkjhC0scb/lCCuILSTwnFFizyQREJtNQFti2sPd
        YHERAU+JB4t2sUAMms0kcf37abAEp0CsxK+OJ4wgy4QF/CXuLa0CCbMIqEocej2VCcTmFbCU
        OPZ5KjuELShxcuYTsBuYgeb3PmxlhLGXLXzNDHGPgsTPp8ug9rpJtO7dzApRIyIxu7ONeQKj
        0Cwko2YhGTULyahZSFoWMLKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIDnEtzR2M
        21d90DvEyMTBeIhRgoNZSYTXo9QpRYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6Ykl
        qdmpqQWpRTBZJg5OqQamBTbq+99PYlia+0P9yGk+/zktt3fsfGo86Zqp6oO4r1d6Lm+Wvt+z
        pyREZ/apg01Tvt328zb5cML/hpJs6tZWE6UAiROnXeoahE+vc5p2oS3i0LEDPILdx+5lZNl0
        PZe6VGG1zmF149LsI2lb7tX+tugQM2DgLxZMuCP6IvZ4/Kv9Eyr2LuHv49bVqb+wl0M4zueH
        zgnTtT4d3jOXMvE5amrlJkmuOJdq8srfRPhvrrL33nvXWw/+jZqwi+0830G7iLjJZ0L5V09o
        v1Qf1XnlZU5Cq+ihW0o7pysm7v4i9KPm9Md7Znc0zJ83rzM5osh48dSjtlLO29f2Xd9XYtnu
        cK5G6d/umMffz/C0qhhfUmIpzkg01GIuKk4EAKMaEZbgAgAA
X-CMS-MailID: 20230424045947epcas2p3ab053c5db5f3bcc4dfb6d61eba12b68b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230419072745epcas2p47b29940fe7e50d947a29546a8e79abb9
References: <cpgsproxy5@samsung.com; stanley.chu@mediatek.com>
        <CGME20230419072745epcas2p47b29940fe7e50d947a29546a8e79abb9@epcas2p4.samsung.com>
        <1681888769-36587-1-git-send-email-kwmad.kim@samsung.com>
        <DM6PR04MB65758403CC6D31654A98BB43FC669@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Regarding 5.7.12.11 in Unipro v1.8, PA rejects sebsequent requests
> > following the first request from upper layer or remote.
> > In this situation, PA responds w/ BUSY in cases when they come from
> > upper layer and does nothing for the requests. So HCI doesn't receive
> > ind, a.k.a. indicator for its requests and an interrupt, IS.UPMS isn't
> > generated.
> >
> > When LINERESET occurs, the error handler issues PMC which is
> > recognized as a request for PA. If a host's PA gets or raises
> > LINERESET, and a request for PMC, this could be a concurrent situation
> > mentioned above. And I found that situation w/ my environment.
> Can you please elaborate on how this concurrency can happen?
> My understanding is that both line reset indication and uic command are
> protected by host_lock?

Yes and one thing I have to correct on the clause: 5.7.12.11 -> 5.7.12.1.1

And I=E2=80=99m=20talking=20about=20the=20situation=20w/=20some=20requests=
=20w/=20PACP.=0D=0A=0D=0A>=20>=0D=0A>=20>=20=5B=20=20222.929539=5DI=5B0:Def=
aultDispatch:20410=5D=20exynos-ufs=2013500000.ufs:=0D=0A>=20>=20ufshcd_upda=
te_uic_error:=20uecdl=20:=200x80000002=20=5B=20=20222.999009=5DI=5B0:=0D=0A=
>=20>=20arch_disk_io_1:20413=5D=20exynos-ufs=2013500000.ufs:=0D=0A>=20>=20u=
fshcd_update_uic_error:=20uecpa=20:=200x80000010=20=5B=20=20222.999200=5D=
=20=5B6:=0D=0A>=20>=20kworker/u16:2:=20=20132=5D=20exynos-ufs=2013500000.uf=
s:=0D=0A>=20>=20ufs_pwr_mode_restore_needed=20:=20mode=20=3D=200x15,=20pwr_=
rx=20=3D=201,=20pwr_tx=20=3D=201=20=5B=0D=0A>=20>=20223.002876=5DI=5B0:=20a=
rch_disk_io_3:20422=5D=20exynos-ufs=2013500000.ufs:=0D=0A>=20>=20ufshcd_upd=
ate_uic_error:=20uecpa=20:=200x80000010=20=5B=20=20223.501050=5D=20=5B4:=0D=
=0A>=20>=20kworker/u16:2:=20=20132=5D=20exynos-ufs=2013500000.ufs:=20pwr=20=
ctrl=20cmd=0D=0A>=20>=200x2=20with=20mode=200x11=20completion=20timeout=0D=
=0A>=20>=20=5B=20=20223.502305=5D=20=5B4:=20=20kworker/u16:2:=20=20132=5D=
=20exynos-ufs=2013500000.ufs:=0D=0A>=20>=20ufshcd_change_power_mode:=20powe=
r=20mode=20change=20failed=20-110=20=5B=20=20223.502312=5D=0D=0A>=20>=20=5B=
4:=20=20kworker/u16:2:=20=20132=5D=20exynos-ufs=2013500000.ufs:=0D=0A>=20>=
=20ufshcd_err_handler:=20Failed=20to=20restore=20power=20mode,=20err=20=3D=
=20-110=20=5B=0D=0A>=20>=20223.502392=5D=20=5B4:=20=20kworker/u16:2:=20=201=
32=5D=20exynos-ufs=2013500000.ufs:=0D=0A>=20>=20ufshcd_is_pwr_mode_restore_=
needed=20:=20mode=20=3D=200x11,=20pwr_rx=20=3D=201,=20pwr_tx=20=3D=0D=0A>=
=20>=201=0D=0A>=20>=0D=0A>=20>=20This=20patch=20is=20to=20poll=20PMC's=20re=
sult=20w/o=20checking=20its=20ind=20until=20the=0D=0A>=20>=20result=20is=20=
not=20busy,=20i.e.=2009h,=20to=20avoid=20the=20rejection.=0D=0A>=20>=0D=0A>=
=20>=20Signed-off-by:=20Kiwoong=20Kim=20<kwmad.kim=40samsung.com>=0D=0A>=20=
>=20---=0D=0A>=20>=20=20drivers/ufs/core/ufshcd.c=20=7C=2092=0D=0A>=20>=20+=
+++++++++++++++++++++++++++++++++---------=0D=0A>=20>=20----=0D=0A>=20>=20=
=201=20file=20changed,=2067=20insertions(+),=2025=20deletions(-)=0D=0A>=20>=
=0D=0A>=20>=20diff=20--git=20a/drivers/ufs/core/ufshcd.c=20b/drivers/ufs/co=
re/ufshcd.c=0D=0A>=20>=20index=209434328..3fa58d9=20100644=0D=0A>=20>=20---=
=20a/drivers/ufs/core/ufshcd.c=0D=0A>=20>=20+++=20b/drivers/ufs/core/ufshcd=
.c=0D=0A>=20>=20=40=40=20-98,6=20+98,9=20=40=40=0D=0A>=20>=20=20/*=20Pollin=
g=20time=20to=20wait=20for=20fDeviceInit=20*/=20=20=23define=0D=0A>=20>=20F=
DEVICEINIT_COMPL_TIMEOUT=201500=20/*=20millisecs=20*/=0D=0A>=20>=0D=0A>=20>=
=20+/*=20Polling=20time=20to=20wait=20until=20PA=20is=20ready=20*/=0D=0A>=
=20>=20+=23define=20UIC_PA_RDY_TIMEOUT=20=20=20=20=2030=20=20=20=20=20=20/*=
=20millisecs=20*/=0D=0A>=20Is=20this=20something=20that=20is=20common=20to=
=20all=20hosts?=0D=0A=0D=0AThe=20values=20is=20based=20on=20the=20descripti=
on=20of=20T=20LINE-RESET=20in=20Table=2011=20in=20M-PHY=20v4.1=0D=0AIt=20sa=
ys=2020ms=20but=20it's=20just=20something=20like=20expectation.=0D=0ASo=20w=
e=20can't=20know=20its=20biggest=20value=20in=20the=20real=20world=20throug=
h=20the=20spec.=0D=0ASo=20I=20talked=20to=20some=20experts=20on=20it=20and=
=20decided=20to=20add=20some=20margin,=2010ms.=0D=0A=0D=0A>=20=0D=0A>=20>=
=20+=0D=0A>=20>=20=20/*=20UFSHC=204.0=20compliant=20HC=20support=20this=20m=
ode,=20refer=0D=0A>=20>=20param_set_mcq_mode()=20*/=20=20static=20bool=20us=
e_mcq_mode=20=3D=20true;=0D=0A>=20>=0D=0A>=20>=20=40=40=20-4138,6=20+4141,6=
4=20=40=40=20int=20ufshcd_dme_get_attr(struct=20ufs_hba=20*hba,=0D=0A>=20>=
=20u32=20attr_sel,=20=20=7D=20=20EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);=0D=
=0A>=20>=0D=0A>=20>=20+static=20int=20__ufshcd_poll_uic_pwr(struct=20ufs_hb=
a=20*hba,=20struct=0D=0A>=20>=20+uic_command=0D=0A>=20>=20*cmd,=0D=0A>=20>=
=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20struct=20completion=20*cnf=
)=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20unsigned=20long=20flags;=0D=0A>=
=20>=20+=20=20=20=20=20=20=20int=20ret;=0D=0A>=20>=20+=20=20=20=20=20=20=20=
ktime_t=20timeout;=0D=0A>=20>=20+=20=20=20=20=20=20=20u32=20mode=20=3D=20cm=
d->argument3;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20timeout=20=
=3D=20ktime_add_ms(ktime_get(),=20UIC_PA_RDY_TIMEOUT);=0D=0A>=20>=20+=20=20=
=20=20=20=20=20do=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20spin_lock_irqsave(hba->host->host_lock,=20flags);=0D=0A>=20>=20+=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20hba->active_uic_cmd=20=3D=20NU=
LL;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20if=20(ufshcd=
_is_link_broken(hba))=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20spin_unlock_irqrestore(hba->host->host_=
lock,=20flags);=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20ret=20=3D=20-ENOLINK;=0D=0A>=20>=20+=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20goto=20out;=0D=0A>=20=
>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=7D=0D=0A>=20>=20+=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20hba->uic_async_done=20=3D=20cnf;=0D=
=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20cmd->argument2=20=
=3D=200;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20cmd->ar=
gument3=20=3D=20mode;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20ret=20=3D=20__ufshcd_send_uic_cmd(hba,=20cmd,=20true);=0D=0A>=20>=20+=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20spin_unlock_irqrestore(hba->ho=
st->host_lock,=20flags);=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20if=20(ret)=20=7B=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20dev_err(hba->dev,=0D=0A>=20>=20+=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=22pwr=20ctrl=20cmd=200x%x=20with=20mode=200x%x=20uic=0D=0A>=20=
error=20%d=5Cn=22,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20cmd->command,=20cmd->arg=
ument3,=20ret);=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20goto=20out;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=7D=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20/*=20This=20value=20is=20heuristic=20*/=0D=0A>=20>=
=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20if=20(=21wait_for_completi=
on_timeout(&cmd->done,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20msecs_to_jiffies(5)))=20=7B=0D=0A>=20>=20+=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20ret=20=3D=20-ETIME=
DOUT;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20dev_err(hba->dev,=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=22pwr=20=
ctrl=20cmd=200x%x=20with=20mode=200x%x=20timeout=5Cn=22,=0D=0A>=20>=20+=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20cmd->command,=20cmd->argument3);=0D=0A>=20>=20+=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20if=20(cmd->cmd_act=
ive)=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20goto=20out;=0D=0A>=20>=20+=0D=0A>=20=
>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20d=
ev_info(hba->dev,=20=22%s:=20pwr=20ctrl=20cmd=20has=0D=0A>=20>=20+=20alread=
y=20been=0D=0A>=20>=20completed=5Cn=22,=20__func__);=0D=0A>=20>=20+=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=7D=0D=0A>=20>=20+=0D=0A>=20>=20+=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20/*=20retry=20for=20only=20busy=20=
cases=20*/=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20ret=
=20=3D=20cmd->argument2=20&=20MASK_UIC_COMMAND_RESULT;=0D=0A>=20>=20+=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20if=20(ret=20=21=3D=20UIC_CMD_RESULT_=
BUSY)=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20break;=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20dev_info(hba->dev,=20=22%s:=20PA=20is=20busy=20and=20c=
an't=20handle=20a=0D=0A>=20>=20+=20requeest=5Cn=22,=0D=0A>=20>=20__func__);=
=0D=0A>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20=7D=20while=20(ktime_bef=
ore(ktime_get(),=20timeout));=0D=0A>=20>=20+out:=0D=0A>=20>=20+=20=20=20=20=
=20=20=20spin_lock_irqsave(hba->host->host_lock,=20flags);=0D=0A>=20>=20+=
=20=20=20=20=20=20=20hba->active_uic_cmd=20=3D=20NULL;=0D=0A>=20>=20+=20=20=
=20=20=20=20=20spin_unlock_irqrestore(hba->host->host_lock,=20flags);=0D=0A=
>=20>=20+=0D=0A>=20>=20+=20=20=20=20=20=20=20return=20ret;=0D=0A>=20>=20+=
=7D=0D=0A>=20>=20+=0D=0A>=20>=20=20/**=0D=0A>=20>=20=20=20*=20ufshcd_uic_pw=
r_ctrl=20-=20executes=20UIC=20commands=20(which=20affects=20the=0D=0A>=20>=
=20link=20power=0D=0A>=20>=20=20=20*=20state)=20and=20waits=20for=20it=20to=
=20take=20effect.=0D=0A>=20>=20=40=40=20-4160,33=20+4221,16=20=40=40=20stat=
ic=20int=20ufshcd_uic_pwr_ctrl(struct=20ufs_hba=0D=0A>=20>=20*hba,=20struct=
=20uic_command=20*cmd)=0D=0A>=20>=20=20=20=20=20=20=20=20=20unsigned=20long=
=20flags;=0D=0A>=20>=20=20=20=20=20=20=20=20=20u8=20status;=0D=0A>=20>=20=
=20=20=20=20=20=20=20=20int=20ret;=0D=0A>=20>=20-=20=20=20=20=20=20=20bool=
=20reenable_intr=20=3D=20false;=0D=0A>=20>=0D=0A>=20>=20=20=20=20=20=20=20=
=20=20mutex_lock(&hba->uic_cmd_mutex);=0D=0A>=20>=20=20=20=20=20=20=20=20=
=20ufshcd_add_delay_before_dme_cmd(hba);=0D=0A>=20>=0D=0A>=20>=20-=20=20=20=
=20=20=20=20spin_lock_irqsave(hba->host->host_lock,=20flags);=0D=0A>=20>=20=
-=20=20=20=20=20=20=20if=20(ufshcd_is_link_broken(hba))=20=7B=0D=0A>=20>=20=
-=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20ret=20=3D=20-ENOLINK;=0D=0A>=
=20>=20-=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20goto=20out_unlock;=0D=
=0A>=20>=20-=20=20=20=20=20=20=20=7D=0D=0A>=20>=20-=20=20=20=20=20=20=20hba=
->uic_async_done=20=3D=20&uic_async_done;=0D=0A>=20>=20-=20=20=20=20=20=20=
=20if=20(ufshcd_readl(hba,=20REG_INTERRUPT_ENABLE)=20&=0D=0A>=20>=20UIC_COM=
MAND_COMPL)=20=7B=0D=0A>=20>=20-=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20ufshcd_disable_intr(hba,=20UIC_COMMAND_COMPL);=0D=0A>=20>=20-=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20/*=0D=0A>=20>=20-=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20*=20Make=20sure=20UIC=20command=20completion=20i=
nterrupt=20is=20disabled=0D=0A>=20before=0D=0A>=20>=20-=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20*=20issuing=20UIC=20command.=0D=0A>=20>=20-=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20*/=0D=0A>=20>=20-=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20wmb();=0D=0A>=20>=20-=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20reenable_intr=20=3D=20true;=0D=0A>=20>=20-=20=20=
=20=20=20=20=20=7D=0D=0A>=20>=20-=20=20=20=20=20=20=20ret=20=3D=20__ufshcd_=
send_uic_cmd(hba,=20cmd,=20false);=0D=0A>=20>=20-=20=20=20=20=20=20=20spin_=
unlock_irqrestore(hba->host->host_lock,=20flags);=0D=0A>=20>=20+=20=20=20=
=20=20=20=20ret=20=3D=20__ufshcd_poll_uic_pwr(hba,=20cmd,=20&uic_async_done=
);=0D=0A>=20>=20=20=20=20=20=20=20=20=20if=20(ret)=20=7B=0D=0A>=20>=20-=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20dev_err(hba->dev,=0D=0A>=20>=20-=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=22pwr=
=20ctrl=20cmd=200x%x=20with=20mode=200x%x=20uic=20error=20%d=5Cn=22,=0D=0A>=
=20>=20-=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20cmd->command,=20cmd->argument3,=20ret);=0D=0A>=20>=20-=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20goto=20out;=0D=0A>=20>=20+=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20if=20(ret=20=3D=3D=20-ENOLINK)=0D=0A>=20>=20+=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20goto=20out_u=
nlock;=0D=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20else=0D=
=0A>=20>=20+=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20goto=20out;=0D=0A>=20>=20=20=20=20=20=20=20=20=20=7D=0D=0A>=20>=0D=0A=
>=20>=20=20=20=20=20=20=20=20=20if=20(=21wait_for_completion_timeout(hba->u=
ic_async_done,=0D=0A>=20>=20=40=40=20-4223,14=20+4267,12=20=40=40=20static=
=20int=20ufshcd_uic_pwr_ctrl(struct=20ufs_hba=0D=0A>=20>=20*hba,=20struct=
=20uic_command=20*cmd)=0D=0A>=20>=20=20=20=20=20=20=20=20=20spin_lock_irqsa=
ve(hba->host->host_lock,=20flags);=0D=0A>=20>=20=20=20=20=20=20=20=20=20hba=
->active_uic_cmd=20=3D=20NULL;=0D=0A>=20>=20=20=20=20=20=20=20=20=20hba->ui=
c_async_done=20=3D=20NULL;=0D=0A>=20>=20-=20=20=20=20=20=20=20if=20(reenabl=
e_intr)=0D=0A>=20>=20-=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20ufshcd_e=
nable_intr(hba,=20UIC_COMMAND_COMPL);=0D=0A>=20>=20=20=20=20=20=20=20=20=20=
if=20(ret)=20=7B=0D=0A>=20>=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20ufshcd_set_link_broken(hba);=0D=0A>=20>=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20ufshcd_schedule_eh_work(hba);=0D=0A>=20>=20=20=20=20=20=
=20=20=20=20=7D=0D=0A>=20>=20-out_unlock:=0D=0A>=20>=20=20=20=20=20=20=20=
=20=20spin_unlock_irqrestore(hba->host->host_lock,=20flags);=0D=0A>=20>=20+=
out_unlock:=0D=0A>=20>=20=20=20=20=20=20=20=20=20mutex_unlock(&hba->uic_cmd=
_mutex);=0D=0A>=20>=0D=0A>=20>=20=20=20=20=20=20=20=20=20return=20ret;=0D=
=0A>=20>=20--=0D=0A>=20>=202.7.4=0D=0A=0D=0AI=20found=20one=20thing=20to=20=
be=20fixed=20and=20so=20will=20update=20this=20patch.=0D=0A=0D=0A=0D=0A
