Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52FBDC2BA19
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 07:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18BAD2084D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 07:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tRoD2Ib1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgDUHyj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 03:54:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63101 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgDUHyj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 03:54:39 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200421075435epoutp030cc4356ccbb9815a31ba6e9d7351d779~Hxoa0fb0o2874928749epoutp03Q
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 07:54:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200421075435epoutp030cc4356ccbb9815a31ba6e9d7351d779~Hxoa0fb0o2874928749epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587455675;
        bh=iqpueYG4ts/r2whsv03bNtMq34F7oa+gBIlQq6viqd8=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=tRoD2Ib10jmu49a9NR8q8epsMBH+VoTrDC3XP3Y+uEndNISiquni6kRLOs2i/fA81
         v7CwNLPkUYcLksLD6gJbmOXVGZsZOG76rEtaXkWPbh9x1tApPGvfVebGjhvZuOeSJg
         D/Sb3186Rt+RVd6TfyqaQg+qK4gtyYrdt+kY6Jco=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200421075435epcas2p212505e2be729bd9c529efc5c08d68502~Hxoanfr842404824048epcas2p2O
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 07:54:35 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 495wnh4H8TzMqYkk for
        <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 07:54:32 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        02.3E.04393.7B6AE9E5; Tue, 21 Apr 2020 16:54:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200421075431epcas2p265c1d8adfa91233eced14c549563927a~HxoXFxWmR2404824048epcas2p2G
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 07:54:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200421075431epsmtrp2c36dfef0d476dc37e30d4126c1a67050~HxoXFIEIY2697826978epsmtrp2C
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 07:54:31 +0000 (GMT)
X-AuditID: b6c32a47-67fff70000001129-95-5e9ea6b78199
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.07.04024.7B6AE9E5; Tue, 21 Apr 2020 16:54:31 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200421075431epsmtip124a6ea17919d60b9ff69afde893f49de~HxoW7WkCK0525005250epsmtip1y
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 07:54:31 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>
In-Reply-To: <SN6PR04MB46408CF4DD05DB9B48DFE412FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Date:   Tue, 21 Apr 2020 16:54:31 +0900
Message-ID: <062101d617b2$1721ffd0$4565ff70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJQDPill8kAmUENoj8JBCZ49rLenQIFk/WPAcfxkaoBmLD4p6dkGFQA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCKsWRmVeSWpSXmKPExsWy7bCmhe72ZfPiDHbvNbfovr6DzYHR4/Mm
        uQDGqBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
        SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNT
        oMqEnIzLl1azFayUrXjS/JulgXGXWBcjJ4eEgInEgw/dLF2MXBxCAjsYJXZOXcwK4Uxmkpi/
        fR2UM51JonvdEnaYlqedk6Fa9jJK9DWeZoJwOpkkdr26wgRSxSagLTHt4W5WEFtEQEHib9sh
        ZhCbUyBWYu3izWBxYYEQievfnrKA2CwCqhKvN95nBLF5BSwlTtz+zwJhC0qcnPkEzGYGmrls
        4WtmiCsUJH4+XQY1303ifNdFqBoRidmdbcwgB0kI9LBJvF27mwmiwUXi261nULawxKvjW6De
        kZL4/G4vG4RdL7FvagMrVDOjxNN9/xghEsYSs561A9kcQBs0Jdbv0gcxJQSUJY7cgtrLJ9Fx
        +C87RJhXoqNNCKJRWeLXpMlQQyQlZt68A7XVQ2L+0VnsExgVZyH5chaSL2ch+WYWwt4FjCyr
        GMVSC4pz01OLjQqMkWN7EyM4xWm572Dcds7nEKMAB6MSD+8GsXlxQqyJZcWVuYcYJTiYlUR4
        LbSAQrwpiZVVqUX58UWlOanFhxhNgZEwkVlKNDkfmH7zSuINTY3MzAwsTS1MzYwslMR5N3Hf
        jBESSE8sSc1OTS1ILYLpY+LglGpgbFJ32RKca27c2fI3eJ/UU0dd8cOCHpemP5yYz3nK1fv7
        ac8Nai7n85+p7NfzEGC9LLP395qpUvvX3N5VcSv634F9v//YHJiSwFBvFvz/cW/DrZV+bhfS
        u1avY7S1Ej3JdTrx1+WwYHvuGLG0bcGf3baKCD1b77nH6pOhvr+xY03Sb4bixbfuKbEUZyQa
        ajEXFScCAM33CrCHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWy7bCSnO72ZfPiDC40S1l0X9/B5sDo8XmT
        XABjFJdNSmpOZllqkb5dAldG57VjTAWvZCpW9R5haWD8KtrFyMkhIWAi8bRzMksXIxeHkMBu
        RonH/7vZIBKSEid2PmeEsIUl7rccYQWxhQTamSQ2LEsFsdkEtCWmPdwNFhcRUJD423aIGWLQ
        BCaJk1e6WEASnAKxEmsXbwYq4uAQFgiSmHY6HCTMIqAq8XrjfbD5vAKWEidu/2eBsAUlTs58
        AmYzA83vfdjKCGMvW/iaGeIeBYmfT5dB7XWTON91EapeRGJ2ZxvzBEahWUhGzUIyahaSUbOQ
        tCxgZFnFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREc0FqaOxgvL4k/xCjAwajEw7tB
        bF6cEGtiWXFl7iFGCQ5mJRFeCy2gEG9KYmVValF+fFFpTmrxIUZpDhYlcd6neccihQTSE0tS
        s1NTC1KLYLJMHJxSDYxiBZJ8PBMd7Jc+ixUtvfImmOeoRse2p1f/e1hW+EkkWTOLbXE/Ze77
        9TqbY+e0v2Kt8zNnBlXHTNrlrPP0/S1ju10LE/YUaFWZMmselijOPvKNL9+1cKo6k2en8PtH
        b6/IZKrpfE70/ndkzmYO406xAIZZKmvCDngEXg+saVEpV1128+j3m0osxRmJhlrMRcWJAGPR
        iGhkAgAA
X-CMS-MailID: 20200421075431epcas2p265c1d8adfa91233eced14c549563927a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08@epcas5p2.samsung.com>
        <20200417175944.47189-6-alim.akhtar@samsung.com>
        <SN6PR04MB46408CF4DD05DB9B48DFE412FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: Monday, April 20, 2020 5:56 PM
> To: Alim Akhtar <alim.akhtar=40samsung.com>; robh=40kernel.org
> Cc: devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org;
> krzk=40kernel.org; martin.petersen=40oracle.com; kwmad.kim=40samsung.com;
> stanley.chu=40mediatek.com; cang=40codeaurora.org; linux-samsung-
> soc=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; linux-
> kernel=40vger.kernel.org
> Subject: RE: =5BPATCH v6 05/10=5D scsi: ufs: add quirk to fix abnormal oc=
s
> fatal error
>=20
> >
> > From: Kiwoong Kim <kwmad.kim=40samsung.com>
> >
> > Some architectures determines if fatal error for OCS occurrs to check
> > status in response upiu. This patch
> Typo - occurs
>=20
> > is to prevent from reporting command results with that.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c =7C 6 ++++++
> >  drivers/scsi/ufs/ufshcd.h =7C 6 ++++++
> >  2 files changed, 12 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index b32fcedcdcb9..8c07caff0a5c 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > =40=40 -4794,6 +4794,12 =40=40 ufshcd_transfer_rsp_status(struct ufs_hb=
a *hba,
> > struct ufshcd_lrb *lrbp)
> >         /* overall command status of utrd */
> >         ocs =3D ufshcd_get_tr_ocs(lrbp);
> >
> > +       if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) =7B
> > +               if (be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_1) &
> > +                                       MASK_RSP_UPIU_RESULT)
> > +                       ocs =3D OCS_SUCCESS;
> > +       =7D
> > +
> Not sure that I follow what this quirk is all about.
> Your code overrides ocs by open coding ufshcd_get_rsp_upiu_result.
>=20
> Normally OCS is in utp transfer req descriptor, dword 2, bits 0..7.
> My understanding from your description, is that some fatal error might
> occur, But the host controller does not report it, and it still needs to
> be checked in the response upiu.
> Evidently you are not doing so.
> Please elaborate your description.
>=20
> P.S.
> The ocs is being evaluated in device management commands as well, Isn't
> this something you need to attend?
>=20
> Thanks,
> Avri
>=20
> >         switch (ocs) =7B
> >         case OCS_SUCCESS:
> >                 result =3D ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index a9b9ace9fc72..e1d09c2c4302 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > =40=40 -541,6 +541,12 =40=40 enum ufshcd_quirks =7B
> >          * resolution of the values of PRDTO and PRDTL in UTRD as byte.
> >          */
> >         UFSHCD_QUIRK_PRDT_BYTE_GRAN                     =3D 1 << 9,
> > +
> > +       /*
> > +        * This quirk needs to be enabled if the host controller report=
s
> > +        * OCS FATAL ERROR with device error through sense data
> > +        */
> > +       UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR             =3D 1 << 10,
> >  =7D;
> >
> >  enum ufshcd_caps =7B
> > --
> > 2.17.1

Avri

As specified in the spec, OCS isn't supposed to refer to the contents of RE=
SPONSE UPIU.
But, Exynos host behaves like that in some cases, e.g. a value of 'state' i=
n is isn't GOOD(00h).

For QUERY RESPONSE, its offset, i.e. =22 dword_1=22 is reserved, so current=
ly no impact, I think.
But if you feel another condition is necessary to identify if this request =
is QUERY REQEUST or not, we can add more.

Thanks

