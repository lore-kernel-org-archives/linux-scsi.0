Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F4ECC43141
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 03:42:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F423207DD
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 03:42:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ekkPQNs7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfK0Dmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 22:42:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19587 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbfK0Dmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 22:42:36 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20191127034232epoutp01da5076473572da64a3e6fde277cb3c75~a6AqjTzIY1813718137epoutp01C
        for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2019 03:42:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20191127034232epoutp01da5076473572da64a3e6fde277cb3c75~a6AqjTzIY1813718137epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574826152;
        bh=pqomQtibYN+g0Hr/ZJ2ztmHx1bzf8wKFb0DFCvW/bSE=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ekkPQNs7k42A1tAViXaND/q1/kjtqiDRs3a4/eM3TTpR2dKTdCZl/hSORb4sBNXom
         GRqy8ZoDFfy7EeAVGj9rYtxkxCWUPEezTK5rSeF8Bwop80ITNdx2zto3NQJJynInvm
         krACnbxGG2cjyjZPeWVGTtbiZHG0wQk5WrQsUSSo=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191127034231epcas5p1c7022edf1d31c7b714d2ad77c1e8bc99~a6Ap19_YR2108321083epcas5p1P;
        Wed, 27 Nov 2019 03:42:31 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B4.90.19726.7A0FDDD5; Wed, 27 Nov 2019 12:42:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20191127034230epcas5p4b17b866b29e72ad2ecce3375059b948e~a6ApJZvzh1631116311epcas5p4I;
        Wed, 27 Nov 2019 03:42:30 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20191127034230epsmtrp2c8065aa39ebd6e35f2b7755fae8ce599~a6ApIRVpo2115121151epsmtrp26;
        Wed, 27 Nov 2019 03:42:30 +0000 (GMT)
X-AuditID: b6c32a49-7a9ff70000014d0e-c7-5dddf0a70f71
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F3.10.06569.6A0FDDD5; Wed, 27 Nov 2019 12:42:30 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.32]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20191127034228epsmtip27f9ef28e936b034ce908c22f10e55b56~a6Am_LH401894318943epsmtip2h;
        Wed, 27 Nov 2019 03:42:28 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Vignesh Raghavendra'" <vigneshr@ti.com>,
        "'Alim Akhtar'" <alim.akhtar@gmail.com>,
        "'sheebab'" <sheebab@cadence.com>
Cc:     "'Avri Altman'" <avri.altman@wdc.com>,
        "'Pedro Sousa'" <pedrom.sousa@synopsys.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'Bean Huo \(beanhuo\)'" <beanhuo@micron.com>,
        <yuehaibing@huawei.com>, <linux-scsi@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <rafalc@cadence.com>,
        <mparab@cadence.com>
In-Reply-To: <cfc2c86f-f9ae-ac91-39ac-8bb48c41b243@ti.com>
Subject: RE: [PATCH RESEND 2/2] scsi: ufs: Update L4 attributes on manual
 hibern8 exit in Cadence UFS.
Date:   Wed, 27 Nov 2019 09:12:26 +0530
Message-ID: <08c701d5a4d4$b20c7300$16255900$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHedmnDsV+0XJYctqc2u08WFWQfYAIz26ApAn51KZIBSarR9wJHdWspp0qfzwA=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02SaUwTURSFfbN1qFYehei1GpcGYmQREZfRqKBRMkZF4k+00YlMKLJIWlBR
        flRFgVYikBi0IGplc0kQgsoikR2EQFyoIgEXLKgQCUtQUeMyDkb+nfvud3LPSR5LqgdpDRsR
        EycaYoQoLaOk7tUvW+pTONKrW9H6DXP53Se4j5N2hqt9m0pxtq57BFfd7cU9q8xhOMuLcoYr
        bP5JcK/axiguqWmC4kxlFxku946J4PLvvkTcr/YRBdcz8Z4KdOZvpw4RfIW1V8EnNXyi+XRb
        DeKTHj2k+C/FKQw/2t9N8WUPxxHf3HWf4MdLF/LJNRYiZGaockOYGBVxRDT4bjqg1CffcChi
        s4OOtfb9IEzI7m9GLAt4FeSlLTAjJ1aNqxBUnw81I+UfPYZgrMiikIfPCIYcaQqJkgzvfuTR
        8qIawalBMyEPgwjasmy0RDHYB8qvn2Uk7YZPwFhtBilBJH5CQsHJViQtnPB6eNfzWiHlcMV6
        aMoTJUlhD8juSpSkCq+DinaQYBV2gUeXHJSkSewFBdeGSDnPYpjsL6Al3A0Hw7UShYzMhcbJ
        c3+PAn6qgObGTCQX3goXOkNlqysMNpdN1dLA+HA1IyORcK7SX35OhPzcJkrWAVDTmUNJCImX
        QXGlr3xpNqR9dxCyUwUpZ9Uy7QGnh+1TzvmQYbHQsuah+3MOnY6WWKfVsk6rZZ2W3/r/2FVE
        3UTzxFhjdLhoXB3rFyMeXW4Uoo3xMeHLDx6OLkV/f6Dn9nJk7dhZhzCLtLNUepdenZoWjhgT
        ousQsKTWTeVV36NTq8KEhOOi4fB+Q3yUaKxD81lKO1eVSdv3qXG4ECdGimKsaPi3JVgnjQk5
        b9B51zS6a01Zui5/H+e9A3anjR9Wa/oe7G+wrW1J3Z34puqjvaQjaNdXavKxi7/esO1UREiQ
        EGT7ktYWGBw2XLGl4nl8a3zRQEufqX5RyspDIUrvWwI9uo6pDXylMfuucd0R4H5monB2tu9m
        R8PlT1f8ol6mH4TvHntmTMxJeBCspYx6wc+TNBiF33YOhSp9AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWy7bCSvO6yD3djDf4vV7BYeqva4uXPq2wW
        Bx92slgsurGNyWLvLW2Ly7vmsFl0X9/BZrH8+D8mi3unP7FYtBz7ymLRsGUGm8W8DQ1MFku3
        3mS0+H/2A7vFna/PWRz4PdZ0vmby2DnrLrtHy5G3rB4TFh1g9Gg5uZ/F4/v6DjaPj09vsXhs
        2f+Z0eP4je1MHp83yXm0H+hmCuCO4rJJSc3JLEst0rdL4Mo4OOMca8Eil4pXx68yNTDeM+xi
        5OSQEDCRePxnCWsXIxeHkMBuRonb92YwQySkJa5vnMAOYQtLrPz3nB2i6AWjxKHzv8ESbAK6
        EjsWt7GB2CICtRLPDzxmAiliFrjNLNH1aA8jRMcBJok1rbsYQao4BawkHt+5D9YtLJAmsWrF
        cqA4BweLgKrE7Bs1ICavgKXEzrMSIBW8AoISJ2c+YQGxmQW0JXoftjLC2MsWvoY6VEHi59Nl
        rCCtIgJ+Egs3skOUiEsc/dnDPIFReBaSSbOQTJqFZNIsJC0LGFlWMUqmFhTnpucWGxYY5aWW
        6xUn5haX5qXrJefnbmIER7WW1g7GEyfiDzEKcDAq8fBmCN6NFWJNLCuuzD3EKMHBrCTCq334
        TqwQb0piZVVqUX58UWlOavEhRmkOFiVxXvn8Y5FCAumJJanZqakFqUUwWSYOTqkGRounlWWP
        fLZyLt9redmqosVyDudiBeM+sx2v58W+Nf6ywHRijOkdVe9f/cfDPp7WkIsR6ta0Srs3oTtf
        oNSZvezXvS1z2Q7M7xZ4yscXOUWb/cmV3KhVkabd29l31Wa4+hjN6yxqfhk4iz1OUblp0fxs
        ixMLl4pNN5tiZfrw1NyV95psF918rMRSnJFoqMVcVJwIAMEhQwHmAgAA
X-CMS-MailID: 20191127034230epcas5p4b17b866b29e72ad2ecce3375059b948e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191121105613epcas4p1a83df10f9f8dcf9edaa583648cad449e
References: <1574147082-22725-1-git-send-email-sheebab@cadence.com>
        <1574147082-22725-3-git-send-email-sheebab@cadence.com>
        <CAGOxZ53Lotp6sBUryHsE2S1dbkQNZhPhWNMXidoi=BOmV074VA@mail.gmail.com>
        <CGME20191121105613epcas4p1a83df10f9f8dcf9edaa583648cad449e@epcas4p1.samsung.com>
        <cfc2c86f-f9ae-ac91-39ac-8bb48c41b243@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Vignesh Raghavendra <vigneshr=40ti.com>
> Sent: 21 November 2019 16:26
> To: Alim Akhtar <alim.akhtar=40gmail.com>; sheebab <sheebab=40cadence.com=
>
> Cc: Alim Akhtar <alim.akhtar=40samsung.com>; Avri Altman
> <avri.altman=40wdc.com>; Pedro Sousa <pedrom.sousa=40synopsys.com>; James
> E.J. Bottomley <jejb=40linux.ibm.com>; Martin K. Petersen
> <martin.petersen=40oracle.com>; Stanley Chu <stanley.chu=40mediatek.com>;
> Bean Huo (beanhuo) <beanhuo=40micron.com>; yuehaibing=40huawei.com; linux=
-
> scsi=40vger.kernel.org; open list <linux-kernel=40vger.kernel.org>; linux=
-
> block=40vger.kernel.org; rafalc=40cadence.com; mparab=40cadence.com
> Subject: Re: =5BPATCH RESEND 2/2=5D scsi: ufs: Update L4 attributes on ma=
nual
> hibern8 exit in Cadence UFS.
>=20
>=20
>=20
> On 20/11/19 9:50 PM, Alim Akhtar wrote:
> > Hi Sheebab
> >
> > On Tue, Nov 19, 2019 at 12:38 PM sheebab <sheebab=40cadence.com> wrote:
> >>
> >> Backup L4 attributes duirng manual hibern8 entry and restore the L4
> >> attributes on manual hibern8 exit as per JESD220C.
> >>
> > Can you point me to the relevant section on the spec?
> >
>=20
> Per JESD 220C 9.4 UniPro/UFS Control Interface (Control Plane):
>=20
> =22NOTE After exit from Hibernate all UniPro Transport Layer attributes (=
including
> L4 T_PeerDeviceID,
>=20
> L4 T_PeerCPortID, L4 T_ConnectionState, etc.) will be reset to their rese=
t values.
> All required attributes
>=20
> must be restored properly on both ends before communication can resume.=
=22
>=20
> But its not clear whether SW needs to restore these attributes or hardwar=
e
>=20
Thanks Vignesh for pointing out the spec section, yes it is not clear, one =
way to confirm this is just by read L4 attributes before=20
And after hinern8 entry/exit.
(at least in the current platform it is not being done)
AFA this patch is concerns, this looks ok to me.
=40 Avri , any thought on this?

> Regards
> Vignesh
>=20
> >> Signed-off-by: sheebab <sheebab=40cadence.com>
> >> ---
> >>  drivers/scsi/ufs/cdns-pltfrm.c =7C 97
> >> +++++++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 95 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/ufs/cdns-pltfrm.c
> >> b/drivers/scsi/ufs/cdns-pltfrm.c index adbbd60..5510567 100644
> >> --- a/drivers/scsi/ufs/cdns-pltfrm.c
> >> +++ b/drivers/scsi/ufs/cdns-pltfrm.c
> >> =40=40 -19,6 +19,14 =40=40
> >>
> >>  =23define CDNS_UFS_REG_HCLKDIV   0xFC
> >>  =23define CDNS_UFS_REG_PHY_XCFGD1        0x113C
> >> +=23define CDNS_UFS_MAX 12
> >> +
> >> +struct cdns_ufs_host =7B
> >> +       /**
> >> +        * cdns_ufs_dme_attr_val - for storing L4 attributes
> >> +        */
> >> +       u32 cdns_ufs_dme_attr_val=5BCDNS_UFS_MAX=5D;
> >> +=7D;
> >>
> >>  /**
> >>   * cdns_ufs_enable_intr - enable interrupts =40=40 -47,6 +55,77 =40=
=40
> >> static void cdns_ufs_disable_intr(struct ufs_hba *hba, u32 intrs)  =7D
> >>
> >>  /**
> >> + * cdns_ufs_get_l4_attr - get L4 attributes on local side
> >> + * =40hba: per adapter instance
> >> + *
> >> + */
> >> +static void cdns_ufs_get_l4_attr(struct ufs_hba *hba) =7B
> >> +       struct cdns_ufs_host *host =3D ufshcd_get_variant(hba);
> >> +
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERDEVICEID),
> >> +                      &host->cdns_ufs_dme_attr_val=5B0=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERCPORTID),
> >> +                      &host->cdns_ufs_dme_attr_val=5B1=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
> >> +                      &host->cdns_ufs_dme_attr_val=5B2=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PROTOCOLID),
> >> +                      &host->cdns_ufs_dme_attr_val=5B3=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTFLAGS),
> >> +                      &host->cdns_ufs_dme_attr_val=5B4=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
> >> +                      &host->cdns_ufs_dme_attr_val=5B5=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
> >> +                      &host->cdns_ufs_dme_attr_val=5B6=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
> >> +                      &host->cdns_ufs_dme_attr_val=5B7=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
> >> +                      &host->cdns_ufs_dme_attr_val=5B8=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
> >> +                      &host->cdns_ufs_dme_attr_val=5B9=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CPORTMODE),
> >> +                      &host->cdns_ufs_dme_attr_val=5B10=5D);
> >> +       ufshcd_dme_get(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> >> +                      &host->cdns_ufs_dme_attr_val=5B11=5D);
> >> +=7D
> >> +
> >> +/**
> >> + * cdns_ufs_set_l4_attr - set L4 attributes on local side
> >> + * =40hba: per adapter instance
> >> + *
> >> + */
> >> +static void cdns_ufs_set_l4_attr(struct ufs_hba *hba) =7B
> >> +       struct cdns_ufs_host *host =3D ufshcd_get_variant(hba);
> >> +
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE), 0);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID),
> >> +                      host->cdns_ufs_dme_attr_val=5B0=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID),
> >> +                      host->cdns_ufs_dme_attr_val=5B1=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
> >> +                      host->cdns_ufs_dme_attr_val=5B2=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PROTOCOLID),
> >> +                      host->cdns_ufs_dme_attr_val=5B3=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS),
> >> +                      host->cdns_ufs_dme_attr_val=5B4=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_TXTOKENVALUE),
> >> +                      host->cdns_ufs_dme_attr_val=5B5=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_RXTOKENVALUE),
> >> +                      host->cdns_ufs_dme_attr_val=5B6=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_LOCALBUFFERSPACE),
> >> +                      host->cdns_ufs_dme_attr_val=5B7=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERBUFFERSPACE),
> >> +                      host->cdns_ufs_dme_attr_val=5B8=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CREDITSTOSEND),
> >> +                      host->cdns_ufs_dme_attr_val=5B9=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTMODE),
> >> +                      host->cdns_ufs_dme_attr_val=5B10=5D);
> >> +       ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> >> +                      host->cdns_ufs_dme_attr_val=5B11=5D); =7D
> >> +
> >> +/**
> >>   * Sets HCLKDIV register value based on the core_clk
> >>   * =40hba: host controller instance
> >>   *
> >> =40=40 -134,6 +213,7 =40=40 static void cdns_ufs_hibern8_notify(struct=
 ufs_hba
> *hba, enum uic_cmd_dme cmd,
> >>                  * before manual hibernate entry.
> >>                  */
> >>                 cdns_ufs_enable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
> >> +               cdns_ufs_get_l4_attr(hba);
> >>         =7D
> >>         if (status =3D=3D POST_CHANGE && cmd =3D=3D UIC_CMD_DME_HIBER_=
EXIT) =7B
> >>                 /**
> >> =40=40 -141,6 +221,7 =40=40 static void cdns_ufs_hibern8_notify(struct=
 ufs_hba
> *hba, enum uic_cmd_dme cmd,
> >>                  * after manual hibern8 exit.
> >>                  */
> >>                 cdns_ufs_disable_intr(hba, UFSHCD_UIC_HIBERN8_MASK);
> >> +               cdns_ufs_set_l4_attr(hba);
> >>         =7D
> >>  =7D
> >>
> >> =40=40 -245,15 +326,27 =40=40 static int cdns_ufs_pltfrm_probe(struct
> platform_device *pdev)
> >>         const struct of_device_id *of_id;
> >>         struct ufs_hba_variant_ops *vops;
> >>         struct device *dev =3D &pdev->dev;
> >> +       struct cdns_ufs_host *host;
> >> +       struct ufs_hba *hba;
> >>
> >>         of_id =3D of_match_node(cdns_ufs_of_match, dev->of_node);
> >>         vops =3D (struct ufs_hba_variant_ops *)of_id->data;
> >>
> >>         /* Perform generic probe */
> >>         err =3D ufshcd_pltfrm_init(pdev, vops);
> >> -       if (err)
> >> +       if (err) =7B
> >>                 dev_err(dev, =22ufshcd_pltfrm_init() failed %d=5Cn=22,
> >> err);
> >> -
> >> +               goto out;
> >> +       =7D
> >> +       host =3D devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> >> +       if (=21host) =7B
> >> +               err =3D -ENOMEM;
> >> +               dev_err(dev, =22%s: no memory for cdns host=5Cn=22, __=
func__);
> >> +               goto out;
> >> +       =7D
> >> +       hba =3D  platform_get_drvdata(pdev);
> >> +       ufshcd_set_variant(hba, host);
> >> +out:
> >>         return err;
> >>  =7D
> >>
> >> --
> >> 2.7.4
> >>
> >
> >
>=20
> --
> Regards
> Vignesh

