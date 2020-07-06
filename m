Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BF5C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 11:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB5F52073E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 11:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lPr8SP/j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgGFLfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 07:35:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40328 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbgGFLfI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 07:35:08 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200706113504epoutp029dbf862bbfa011887405323ce573fe7e~fJqno5S0H1277212772epoutp02Q
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 11:35:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200706113504epoutp029dbf862bbfa011887405323ce573fe7e~fJqno5S0H1277212772epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594035304;
        bh=wZP33tOC6Ppxb5tO7IRudsucTwq11oS9eQkAgtTcVsE=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=lPr8SP/j/qZT9XSl8de0dcFUKcVKDahxNY0Fetc/Hb6xMf6XdG89HnZQGFubVvtnY
         RxnXH9EAUWVqR/n/I5AMKOZYyybi6ETY+dqVgU7X6BedlvzqtPzaxxOnRJ7mpvfLQE
         kp7bqKS18YAqV4r+/izBlXZ/9qTbqdGBoQuhvIgw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200706113503epcas1p196304a5963ba181e0f7cfc692e03b66e~fJqnN_AfI1408014080epcas1p1C;
        Mon,  6 Jul 2020 11:35:03 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.159]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B0k524lM7zMqYkY; Mon,  6 Jul
        2020 11:35:02 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        99.62.28581.66C030F5; Mon,  6 Jul 2020 20:35:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20200706113502epcas1p477aaca8ed42c91c53282823b001b9574~fJqlprsUp2106321063epcas1p4a;
        Mon,  6 Jul 2020 11:35:02 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200706113502epsmtrp17f25f1b23e23e88d884586e89014008d~fJqlou_KF1254812548epsmtrp1L;
        Mon,  6 Jul 2020 11:35:02 +0000 (GMT)
X-AuditID: b6c32a38-2cdff70000006fa5-f8-5f030c66a30e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        79.82.08382.56C030F5; Mon,  6 Jul 2020 20:35:02 +0900 (KST)
Received: from grantjung02 (unknown [10.214.113.116]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200706113501epsmtip1cc700886249d0c43aad092fdc37a1b6d~fJqlZgT6c3030530305epsmtip1y;
        Mon,  6 Jul 2020 11:35:01 +0000 (GMT)
From:   "Grant Jung" <grant.jung@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB464046C39B0B2AC5E36A7BF5FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 1/2] ufs: support various values per device
Date:   Mon, 6 Jul 2020 20:35:01 +0900
Message-ID: <478701d65389$7c936df0$75ba49d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHu1pDNEI1WArg19xfehYJkuPyuggFIo2zFASntDDcCTmR2VaijUmSg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmnm4aD3O8wepZihYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFqsXP2CxWHRjG5PFzS1HWSy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiMqxyUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WUmhLDGnFCgU
        kFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhQoFecmFtcmpeul5yfa2VoYGBkClSZkJOx/e8z
        toIm0Yq2IwdYGhi/83cxcnBICJhInO+162Lk4hAS2MEocXvhQ9YuRk4g5xOjxLwjyRCJb4wS
        Ow7+YAFJgDSs/rCEFSKxl1Hi0JvZjBDOK0aJ5Ut72UGq2AS0JSbu+swEkhAReMcksebMFrC5
        nAKxEtv2XGYB2S0s4CbxYEcRSJhFQEXi/4k1jCA2r4ClxPxZ+1ggbEGJkzOfgNnMQDOXLXzN
        DHGFgsTPp8tYQcaIAI358VcMokREYnZnGzPIWgmBMxwS99qfsEK86SIxf4EJRKuwxKvjW9gh
        bCmJl/1t7BD1/YwS63pOs0A4E4CcdQehlhlLfPr8mRFkELOApsT6XfoQYUWJnb/nMkIs5pN4
        97UHahevREebEESJisTJjbdYYXY92DcPaqKHRN+Ou6wTGBVnIflyFpIvZyF5ZxbC4gWMLKsY
        xVILinPTU4sNC0yQ43oTIzg1a1nsYJz79oPeIUYmDsZDjBIczEoivL3ajPFCvCmJlVWpRfnx
        RaU5qcWHGE2B4T6RWUo0OR+YHfJK4g1NjYyNjS1MzMzNTI2VxHlPWl2IExJITyxJzU5NLUgt
        gulj4uCUamDKbjwyTeW6beXRewf942fpX5Q07LF5ZiYvPVViTvtpt3C56/G1ylviNr6w8lb2
        eCh1wHDrJMUoDZfLquIZX199rfxkzPj49QxezbNirnxSujv2xyYYmLoHHIwXWSrafVf5vMj0
        yuar29JTrN7p2um/9JlkLWM4hT94c/y3Zf5eTReeat74fGrn/e7O2ClOuTFP77fKhzZqXOtN
        PPso6OqbyufNXzsUcu78OKBbm9z06v5fzzNM+1Nbbwen75C/zXM00F15w4kTNR0N/9TfHJq0
        M/9ngZCn66KIRfpGMvEhf3ZlfRMTmN2U5uqyfvGFfpXNzkw7Zk1xi3veXT/x8orI0skT40K5
        P+xj7L4dUK/EUpyRaKjFXFScCABjxEINVgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsWy7bCSnG4aD3O8QU8vk8WDedvYLPa2nWC3
        ePnzKpvFwYedLBbTPvxktvi0fhmrxerFD1gsFt3YxmRxc8tRFovu6zvYLJYf/8dk0XX3BqPF
        0n9vWRx4PS5f8fa43NfL5DFh0QFGj+/rO9g8Pj69xeLRt2UVo8fnTXIe7Qe6mQI4orhsUlJz
        MstSi/TtErgyDu56z1pwVKSiZc0v1gbGHfxdjJwcEgImEqs/LGEFsYUEdjNKfLugBBGXklh8
        +QFzFyMHkC0scfhwcRcjF1DJC0aJJ+/usIHUsAloS0zc9ZkJJCEi8IdJYtrPM0wQVauZJE5c
        OcIMUsUpECuxbc9lFpBJwgJuEg92FIGEWQRUJP6fWMMIYvMKWErMn7WPBcIWlDg58wmYzQy0
        oPdhKyOMvWzha2aI4xQkfj5dxgoyUgRo5I+/YhAlIhKzO9uYJzAKzUIyaRaSSbOQTJqFpGUB
        I8sqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgWNTS3MG4fdUHvUOMTByMhxglOJiV
        RHh7tRnjhXhTEiurUovy44tKc1KLDzFKc7AoifPeKFwYJySQnliSmp2aWpBaBJNl4uCUamAK
        e3rlvzTLbadjfc2bfVT+cj0UrrubluiueTrp5duvqy9eVteZbLimsJpl64url9XMPp5LD1fd
        VGfzu8kopLxWe9eyX3df1/hUWx9Ku7j9Q8b7Gftc2d+Wbu75H7Wtz0H81h2BV1xL0wT/NXQK
        HpnEnxoWcWLZIpcPjrvLFXXOt6SJO7no9J3sCG5zOHdlfnRsbl711cWWj469P7nr+XtZn648
        Ts4lKh8aJRn3730998CqK5+2/zBlrJvKkX4wY6aSY7z8nh+qRcKvLA/srowyqXb94TplxTsr
        W5P7yyaw1j7fqRFy+oJM+uYbz5nDZO+lNx7v9WFN5nKX3hf86KSMRHS0aVOgnnxBRPvX3GtK
        LMUZiYZazEXFiQDfheS8NAMAAA==
X-CMS-MailID: 20200706113502epcas1p477aaca8ed42c91c53282823b001b9574
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a
References: <cover.1593753896.git.kwmad.kim@samsung.com>
        <CGME20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a@epcas2p1.samsung.com>
        <dc21b368f44c8a9a257d1b00549e3b5aeec00755.1593753896.git.kwmad.kim@samsung.com>
        <SN6PR04MB464046C39B0B2AC5E36A7BF5FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Respective UFS devices have their own characteristics and many of them
> > could be a form of numbers, such as timeout and a number of retires.
> > This introduces the way to set those things per specific device vendor
> > or specific device.
> >
> > I wrote this like the style of ufs_fixups stuffs.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> This patch legitimize quirks of all kinds and shapes.
> I am not sure that we should allow it.
>=20
>=20
> > ---
> >  drivers/scsi/ufs/ufs_quirks.h =7C 13 +++++++++++++
> >  drivers/scsi/ufs/ufshcd.c     =7C 39
> > +++++++++++++++++++++++++++++++++++++++
> >  drivers/scsi/ufs/ufshcd.h     =7C  1 +
> >  3 files changed, 53 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufs_quirks.h
> > b/drivers/scsi/ufs/ufs_quirks.h index 2a00414..f074093 100644
> > --- a/drivers/scsi/ufs/ufs_quirks.h
> > +++ b/drivers/scsi/ufs/ufs_quirks.h
> > =40=40 -29,6 +29,19 =40=40 struct ufs_dev_fix =7B
> >         unsigned int quirk;
> >  =7D;
> >
> > +enum dev_val_type =7B
> > +       DEV_VAL_FDEVICEINIT     =3D 0x0,
>=20
>             /* keep last */
> > +       DEV_VAL_NUM,
> > +=7D;
> > +
> > +struct ufs_dev_value =7B
> > +       u16 wmanufacturerid;
> > +       u8 *model;
> > +       u32 key;
> > +       u32 val;
> > +       bool enable;
> > +=7D;
> > +
> >  =23define END_FIX =7B =7D
> >
> >  /* add specific device quirk */
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 52abe82..b26f182 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > =40=40 -207,6 +207,21 =40=40 static struct ufs_dev_fix ufs_fixups=5B=5D=
 =3D =7B
> >         END_FIX
> >  =7D;
> >
> > +static const struct ufs_dev_value ufs_dev_values=5B=5D =3D =7B
> > +       =7B0, 0, 0, 0, false=7D,
> > +=7D;
> > +
> > +static inline bool
> > +ufs_get_dev_specific_value(struct ufs_hba *hba,
> > +                          enum dev_val_type type, u32 *val) =7B
> If (ARRAY_SIZE(ufs_dev_values) <=3D type)
>     return false;
>=20
>=20
> Thanks,
> Avri

There is no specification for fdeviceinit timeout value like eMMC CMD1 whic=
h is 1s.
Usually this value is small but can be increased under some abnormal situat=
ion like SPO(fdeviceinit after Sudden Power Off).
I think that 1000 retries take less than 1 second but it is inaccurate and =
not enough. Some UFS vendor wants 1.5s.
Moreover, the latency of resuming ufs driver can be dependent on this value=
 when vcc and vccq is off during suspend.
So it's bad to set with big value to apply all UFS devices.
=20
I wonder quirk is needed for that.

BR
Grant

