Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C06E9C55182
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 07:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9976A2074B
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 07:51:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="tc+aNwHb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgDUHvq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 03:51:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61372 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbgDUHvp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2020 03:51:45 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200421075142epoutp031238095e2d5584ed007cac042271c5fc~Hxl5k_Ysn2615226152epoutp03V
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 07:51:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200421075142epoutp031238095e2d5584ed007cac042271c5fc~Hxl5k_Ysn2615226152epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587455502;
        bh=+r0OP1H3iJ44Yz3O1PgyXWJYbt9pTQXZ6pMxnxpslHo=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=tc+aNwHbhc5m520XsNZCCWwXswXTwjyTiTN9lZcj8u0NxzHu7Zodv9SqtpFmvlTJl
         pRZxf4MrunXrM81McOBZSaKFVzK9aI+o7OMuDe1Z5VjpRiFcC6Nzj/Ri2iZKvKDQXl
         jXYfwzrhVvP0HLi0GxLexhZV9EW/+lBV+m5UXXjo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200421075141epcas2p26f29dddc42c4d73a3ea0956a97df7ab4~Hxl5GNyE53196431964epcas2p2W;
        Tue, 21 Apr 2020 07:51:41 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 495wkL0ZTlzMqYkx; Tue, 21 Apr
        2020 07:51:38 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        47.A7.04704.906AE9E5; Tue, 21 Apr 2020 16:51:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200421075137epcas2p23b692423ff31029ea79b968eb9ade7e7~Hxl1AlqPN2296922969epcas2p2v;
        Tue, 21 Apr 2020 07:51:37 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200421075137epsmtrp208a3eb3131f654d1b32a91bb3d91cacf~Hxl0-mDAR2553125531epsmtrp2f;
        Tue, 21 Apr 2020 07:51:37 +0000 (GMT)
X-AuditID: b6c32a46-829ff70000001260-63-5e9ea609547f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.04.04158.906AE9E5; Tue, 21 Apr 2020 16:51:37 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200421075137epsmtip2c02987a134833b7748371740e790f9a9~Hxl0vZmL70218802188epsmtip2a;
        Tue, 21 Apr 2020 07:51:37 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>, <robh@kernel.org>,
        <cpgs@samsung.com>
Cc:     <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <krzk@kernel.org>, <martin.petersen@oracle.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <SN6PR04MB46408CF4DD05DB9B48DFE412FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Date:   Tue, 21 Apr 2020 16:51:37 +0900
Message-ID: <062001d617b1$af5f0aa0$0e1d1fe0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJQDPill8kAmUENoj8JBCZ49rLenQIFk/WPAcfxkaoBmLD4p6dkF1Qg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0hTcRTH+e1ud1u1uk2zw6IY1x6ombvLratpT5FVQlJB9NSbuzhrr3a3
        yCBcBb4qs6SwWZYaGgvTVsmwlLBIwspAy4qe5MqKCrUstaw7b5H/fc/v+zm/c87vIcOUt3GV
        LMvqZB1Wxkzi48QNNyN00fLq8q2a0x8S6FflDTj9fvAhTvfVVUvo9y0R9Jlb9yV0e3u9lPa9
        eSShOxpP4XRpe7OIPtjlx+ma1hER/fu6X7pkgqGj6LDI4PMW4IbL53IMvYGnYkPRFS8y9Ptm
        GPJuHBSlSjeaE0wsY2QdataaYTNmWTMTyVVr05an6fQaKpqKoxeQaitjYRPJpJTU6OQsM98n
        qd7FmF38UirDcWTMogSHzeVk1SYb50wkWbvRbKco+zyOsXAua+a8DJslntJotDqeTDeb3vSe
        ldhrpu/uPjAsdqPGsEIklwERCy/7KvFCNE6mJPwIvtc/x4OGkuhD4PcZBWMAwUjrbdG/jH1H
        azDBaELw7UuJRAh6EHy5/gIFKZyIghOvr0mCOpTYC96yQhSEMGIQQfdwAAsacmIL1FZdHoVC
        iHXQNRAQB7WYmAWedxXSoFYQcTBQuR8JejLcOdk9ymB8geqKj5jQkhoGA9V/iyXDhXs/cIEJ
        hbKC3NFWgSiXQuepr/wMMj5Igv6u2UJuCHxovSIVtAr6Pzfhgs6B5uNuiZB7CEGgeQQJxnzw
        vM1DwX0wIgLqGmOELcPh1lOxQCjAfWlYKrQwEfJv/pIKiALyc5UCEg5Dx0pQMQr3jBnMM2Yw
        z5gBPP9rnUViLwpj7Zwlk+W0du3Yy/ah0TccmexH5+6ntCBChsgJivqw8q1KCbOLy7a0IJBh
        ZKiCjuSXFEYmew/rsKU5XGaWa0E6/tyPYqopGTb+R1idaZROq9dr4nS0Tq+lyakK3/gnm5VE
        JuNkd7CsnXX8yxPJ5Co3qo1vmxN5917JJO2a1rb17xrKVEsPrTrwePWG9KHU/tLZ7thl8rZP
        v857P+oLVkY7V8zYsvhnTlxhnv9VzNUl25J2zpzS+7ItvtOuTqwzXZy0+Nm1hVTs5O1z04s3
        7XZWpTTpiaGon9lLHxyZP9zjMhYvqGjPLavtnkblF/XsKR3K10eYSDFnYqhIzMExfwA1kHzU
        2QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWy7bCSvC7nsnlxBi2XxS0ezNvGZvHy51U2
        i0/rl7FavDykaTH/yDlWi/PnN7BbbHp8jdXi8q45bBYzzu9jsui+voPNYvnxf0wW//fsYHfg
        8bjc18vksWlVJ5vH5iX1Hh+f3mLx6NuyitHj8yY5j/YD3UwB7FFcNimpOZllqUX6dglcGUef
        Fxa8kKlY1XuEpYHxq2gXIyeHhICJROPE5cwgtpDAbkaJTa+VIOKSEid2PmeEsIUl7rccYe1i
        5AKqecYocen+NrAGNgFtiWkPd4MlRAQaGSV2N8xgBHGYBRqZJBac6IdqmcAkcfJKFwtIC6dA
        rMTaxZuBEhwcwgJBEtNOh4OEWQRUJWY9X8gOYvMKWEp8W9TECGELSpyc+QSslRloW+/DVkYY
        e9nC18wQ5ylI/Hy6jBXEFhFwk1h99gcbRI2IxOzONuYJjMKzkIyahWTULCSjZiFpWcDIsopR
        MrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzgitbR2MJ44EX+IUYCDUYmHd4PYvDgh1sSy
        4srcQ4wSHMxKIrwWWkAh3pTEyqrUovz4otKc1OJDjNIcLErivPL5xyKFBNITS1KzU1MLUotg
        skwcnFINjKbdtqoXtJZVLPOu7V5xecvG3Yobg3Z7Lg2t0TfPPKm1lmu3o3YP5zXVI74bFvyc
        9D/9dNo59hdWE4X6F2pKpz57XTs7taxiQfXGxd9/PEiMkz6u9XPhQ8YchgNvnsksXGfyutKG
        zcAnR+186toNNYX3HiSkdc54WOzAf3RyxZQdX+xnNs0y+aXEUpyRaKjFXFScCABRJ6a3xAIA
        AA==
X-CMS-MailID: 20200421075137epcas2p23b692423ff31029ea79b968eb9ade7e7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
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

