Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67581C55194
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 15:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4019420700
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 15:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="suLIqLRg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgDZPyv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 11:54:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16403 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgDZPyu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 11:54:50 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200426155445epoutp01406f7b714237f17f874d066eab340357~JaaF_NCeb2459224592epoutp01z
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2020 15:54:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200426155445epoutp01406f7b714237f17f874d066eab340357~JaaF_NCeb2459224592epoutp01z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587916485;
        bh=ayTtcD8jBSxoZnaUehKS7YmNzBMMmlbCJaXAqNqdFw4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=suLIqLRgSJ0n29xccidoO6y7ymR7AgF1aSATSn0Gcz1d8oj5ApHh+82EywESIiBBH
         IYi0bfCAwdHbHOAHosf7GvCtCwSa9TK5ht4wV9NAsbIHmsW0E3GTIUP0OqFwnjEm7/
         jOQ+iJyMNNvUDqmWyH7xs4OoBGJxiWsDUnIzYYR0=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200426155445epcas5p266d05e625b8553b75733f2739b6803bd~JaaFHu8Ly1668516685epcas5p2f;
        Sun, 26 Apr 2020 15:54:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.5F.10083.4CEA5AE5; Mon, 27 Apr 2020 00:54:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200426155444epcas5p160e8dbd5387e9e850a7bea6f157cd33e~JaaEstjrR1766617666epcas5p1m;
        Sun, 26 Apr 2020 15:54:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200426155444epsmtrp2f4e38028e6914e0fc02c8a24e673ee82~JaaEr5-vM1929019290epsmtrp2E;
        Sun, 26 Apr 2020 15:54:44 +0000 (GMT)
X-AuditID: b6c32a4a-88dff70000002763-55-5ea5aec47912
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F1.EB.25866.4CEA5AE5; Mon, 27 Apr 2020 00:54:44 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200426155441epsmtip23336a1144606adeff21350f99aef3eb1~JaaBvkxLp0981409814epsmtip2G;
        Sun, 26 Apr 2020 15:54:41 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>, <robh@kernel.org>,
        <cpgs@samsung.com>
Cc:     <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <krzk@kernel.org>, <martin.petersen@oracle.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <SN6PR04MB464022365ECC9F5565030147FCD50@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Date:   Sun, 26 Apr 2020 21:24:39 +0530
Message-ID: <000001d61be3$00e656f0$02b304d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJQDPill8kAmUENoj8JBCZ49rLenQIFk/WPAcfxkaoBmLD4pwI/njykAykf0ROnQTP84A==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsWy7bCmhu7RdUvjDHZ7Wbz8eZXN4tP6ZawW
        Lw9pWsw/co7V4vz5DewWN7ccZbHY9Pgaq8XlXXPYLGac38dk0X19B5vF8uP/mCz+79nB7sDj
        cbmvl8lj06pONo/NS+o9Pj69xeLRt2UVo8fnTXIe7Qe6mQLYo7hsUlJzMstSi/TtErgy/l/h
        KjihWfF65zOmBsbj8l2MnBwSAiYSLxdOZO1i5OIQEtjNKHFuw0JGCOcTo8SGKz+ZIZzPjBIz
        Oh6zwbTM7Z8NVbWLUWLbhCtQzhtGiWlHNjGDVLEJ6ErsWNwG1iEiUC2xpm0SO0gRs8BPRokn
        v5+CFXEKxErs71/ACGILC4RIXP/2lAXEZhFQlWiauBsszitgKTHlwiIoW1Di5MwnYDXMAtoS
        yxa+ZoY4SUHi59NlrBDLwiRavk5nhKgRlzj6swfsBwmBExwSS2ZcYoFocJGY3nOWEcIWlnh1
        fAs7hC0l8fndXqCrOYDsbImeXcYQ4RqJpfOOQbXaSxy4MocFpIRZQFNi/S59iDCvRMPG3+wQ
        a/kken8/YYKYwivR0SYEUaIq0fzuKtQUaYmJ3d2sExiVZiF5bBaSx2YheWAWwrIFjCyrGCVT
        C4pz01OLTQuM8lLL9YoTc4tL89L1kvNzNzGC05iW1w7GZed8DjEKcDAq8fB2pC6JE2JNLCuu
        zD3EKMHBrCTCG1OyKE6INyWxsiq1KD++qDQntfgQozQHi5I47yTWqzFCAumJJanZqakFqUUw
        WSYOTqkGxoWtizoi1jw/r/Yp7NLpo01aws9KNO75me8L3DK9d+lD+28eCb/Ohk9JfKKqvNqJ
        9af9ZsOjW9+k2DdNeXXh/LY1jUrRP3Y9mXohf7Zqi9SFS2qFM9ucL8yNNv/emTF1/YyYxuQZ
        +ap+P5X7tghq2vzXcAxzuT93yrlz7zRuzT7KnzF5WXhYzwIlluKMREMt5qLiRAB4TW5lXwMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSvO6RdUvjDPY+kbF4+fMqm8Wn9ctY
        LV4e0rSYf+Qcq8X58xvYLW5uOcpisenxNVaLy7vmsFnMOL+PyaL7+g42i+XH/zFZ/N+zg92B
        x+NyXy+Tx6ZVnWwem5fUe3x8eovFo2/LKkaPz5vkPNoPdDMFsEdx2aSk5mSWpRbp2yVwZXw4
        38FY8FajYvNC4QbGR3JdjJwcEgImEnP7ZzN2MXJxCAnsYJRouvaRHSIhLXF94wQoW1hi5b/n
        7BBFrxglWmcvZwJJsAnoSuxY3MYGYosI1Eu0XlvOClLELNDIJLHgRD8rREc/s8TNuXtZQao4
        BWIl9vcvANrHwSEsECQx7XQ4SJhFQFWiaeJuRhCbV8BSYsqFRVC2oMTJmU9YQGxmAW2Jpzef
        wtnLFr5mhrhOQeLn02WsEEeESbR8nc4IUSMucfRnD/MERuFZSEbNQjJqFpJRs5C0LGBkWcUo
        mVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERyRWlo7GPes+qB3iJGJg/EQowQHs5IIb0zJ
        ojgh3pTEyqrUovz4otKc1OJDjNIcLErivF9nLYwTEkhPLEnNTk0tSC2CyTJxcEo1MDGa+i5Y
        edZgzYn6VAaun1MXfdZrLdA0dHfkUmnQ+Xn8IJfkTg6t0FuxM2bsNrGecPKXecn2oxmSnCwr
        dPdwZDzrurEys3HigsPlaXf5TzRHv3r7hG1JquL5p4a+TzfGvUx5cjTGlMlv5YqrnGbzzu2+
        dKrPS4ir0rutesvN9c+U1zV84tJssJl1Kr355mfVJ3HrPtw5zJXju6PBadn+bceyg5s4p2y/
        8f7SkjVss9acNdPn+uEpxhLB8WLp8vVpFy+nN6cqVu5+I51e5ei3Uq24s/b1uhe5spxt6cWf
        i1lPRR+b8HsF0wImmTsbzwU6LZmt0WHkyntR4Uuh+c7sGjW39ilfnutyZ6pnztRb6KbEUpyR
        aKjFXFScCAAgZ4voNwMAAA==
X-CMS-MailID: 20200426155444epcas5p160e8dbd5387e9e850a7bea6f157cd33e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-CPGSPASS: Y
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08@epcas5p2.samsung.com>
        <20200417175944.47189-6-alim.akhtar@samsung.com>
        <SN6PR04MB46408CF4DD05DB9B48DFE412FCD40@SN6PR04MB4640.namprd04.prod.outlook.com>
        <062001d617b1$af5f0aa0$0e1d1fe0$@samsung.com>
        <SN6PR04MB464022365ECC9F5565030147FCD50@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri

> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: 21 April 2020 17:37
> To: Kiwoong Kim <kwmad.kim=40samsung.com>; 'Alim Akhtar'
> <alim.akhtar=40samsung.com>; robh=40kernel.org; cpgs=40samsung.com
> Cc: devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org; krzk=40ke=
rnel.org;
> martin.petersen=40oracle.com; cang=40codeaurora.org; linux-samsung-
> soc=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; linux-
> kernel=40vger.kernel.org
> Subject: RE: =5BPATCH v6 05/10=5D scsi: ufs: add quirk to fix abnormal oc=
s fatal error
>=20
> >
> > > -----Original Message-----
> > > From: Avri Altman <Avri.Altman=40wdc.com>
> > > Sent: Monday, April 20, 2020 5:56 PM
> > > To: Alim Akhtar <alim.akhtar=40samsung.com>; robh=40kernel.org
> > > Cc: devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org;
> > > krzk=40kernel.org; martin.petersen=40oracle.com;
> > kwmad.kim=40samsung.com;
> > > stanley.chu=40mediatek.com; cang=40codeaurora.org; linux-samsung-
> > > soc=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; linux-
> > > kernel=40vger.kernel.org
> > > Subject: RE: =5BPATCH v6 05/10=5D scsi: ufs: add quirk to fix abnorma=
l
> > > ocs fatal error
> > >
> > > >
> > > > From: Kiwoong Kim <kwmad.kim=40samsung.com>
> > > >
> > > > Some architectures determines if fatal error for OCS occurrs to
> > > > check status in response upiu. This patch
> > > Typo - occurs
> > >
> > > > is to prevent from reporting command results with that.
> > > >
> > > > Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> > > > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
> > > > ---
> > > >  drivers/scsi/ufs/ufshcd.c =7C 6 ++++++  drivers/scsi/ufs/ufshcd.h =
=7C
> > > > 6 ++++++
> > > >  2 files changed, 12 insertions(+)
> > > >
> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > > index b32fcedcdcb9..8c07caff0a5c 100644
> > > > --- a/drivers/scsi/ufs/ufshcd.c
> > > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > > =40=40 -4794,6 +4794,12 =40=40 ufshcd_transfer_rsp_status(struct uf=
s_hba
> > *hba,
> > > > struct ufshcd_lrb *lrbp)
> > > >         /* overall command status of utrd */
> > > >         ocs =3D ufshcd_get_tr_ocs(lrbp);
> > > >
> > > > +       if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) =7B
> > > > +               if (be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_1) =
&
> > > > +                                       MASK_RSP_UPIU_RESULT)
> > > > +                       ocs =3D OCS_SUCCESS;
> > > > +       =7D
> > > > +
> > > Not sure that I follow what this quirk is all about.
> > > Your code overrides ocs by open coding ufshcd_get_rsp_upiu_result.
> > >
> > > Normally OCS is in utp transfer req descriptor, dword 2, bits 0..7.
> > > My understanding from your description, is that some fatal error
> > > might occur, But the host controller does not report it, and it
> > > still needs to be checked in the response upiu.
> > > Evidently you are not doing so.
> > > Please elaborate your description.
> > >
> > > P.S.
> > > The ocs is being evaluated in device management commands as well,
> > > Isn't this something you need to attend?
> > >
> > > Thanks,
> > > Avri
> > >
> > > >         switch (ocs) =7B
> > > >         case OCS_SUCCESS:
> > > >                 result =3D ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
> > > > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > > > index a9b9ace9fc72..e1d09c2c4302 100644
> > > > --- a/drivers/scsi/ufs/ufshcd.h
> > > > +++ b/drivers/scsi/ufs/ufshcd.h
> > > > =40=40 -541,6 +541,12 =40=40 enum ufshcd_quirks =7B
> > > >          * resolution of the values of PRDTO and PRDTL in UTRD as b=
yte.
> > > >          */
> > > >         UFSHCD_QUIRK_PRDT_BYTE_GRAN                     =3D 1 << 9,
> > > > +
> > > > +       /*
> > > > +        * This quirk needs to be enabled if the host controller re=
ports
> > > > +        * OCS FATAL ERROR with device error through sense data
> > > > +        */
> > > > +       UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR             =3D 1 << 10=
,
> > > >  =7D;
> > > >
> > > >  enum ufshcd_caps =7B
> > > > --
> > > > 2.17.1
> > Avri
> >
> > As specified in the spec, OCS isn't supposed to refer to the contents
> > of RESPONSE UPIU.
> > But, Exynos host behaves like that in some cases, e.g. a value of
> > 'state' in is isn't GOOD(00h).
> OK.
> I still think that you might consider rewording your commit, explaining t=
his quirk
> better.
> Specifically you might not want to say =22if fatal...=22 because fatal co=
de (0x7) is just
> one error code out of many.
> Also you might want to use ufshcd_get_rsp_upiu_result() in the quirk body
> instead of open coding it.
>=20
> >
> > For QUERY RESPONSE, its offset, i.e. =22 dword_1=22 is reserved, so
> > currently no impact, I think.
> > But if you feel another condition is necessary to identify if this
> > request is QUERY REQEUST or not, we can add more.
> No need, as long as you are ok with whatever ufshcd_get_tr_ocs() returns =
in
> ufshcd_wait_for_dev_cmd().
>=20
I will update the commit message to make it clear in the next version of th=
e patch set.

> Thanks,
> Avri
>=20
> >
> > Thanks


