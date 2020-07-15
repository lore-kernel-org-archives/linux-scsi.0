Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94A3C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 937782064C
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 08:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FRLa7Zdp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgGOIDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 04:03:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41010 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbgGOIDn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 04:03:43 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200715080340epoutp01b35ac6eee1611cdc1e672a9272f417c5~h3lnbWZB62234222342epoutp01d
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 08:03:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200715080340epoutp01b35ac6eee1611cdc1e672a9272f417c5~h3lnbWZB62234222342epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594800220;
        bh=3cryH2VZEYKkL8mhkjPdWfwqKL0MS1pbtQP8BzwwVf0=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=FRLa7ZdpSTmxlbhhbvrNk6pGwpmu0dsCWHZ/hm8x1FsGxYLJe1sVFM8r2zUQXzSwI
         Yppl7O4hMXyD0i7K8ZIyMEXJoMS+cppOOxc+3DxX9gNJeOdHw/EDQyLJ4JYTOQxxkR
         ohK25INLAyB6YMLOgVwEVJ81isFQ7WNrOSMIJRDM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200715080339epcas2p42c8450fa3808ae542b5d2a7c527bf7e3~h3lm4MIdv0323003230epcas2p47;
        Wed, 15 Jul 2020 08:03:39 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B68yw6CMWzMqYkr; Wed, 15 Jul
        2020 08:03:36 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.CE.18874.858BE0F5; Wed, 15 Jul 2020 17:03:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200715080336epcas2p1552c56dd96a74fa6d9f427811de9ed9e~h3ljeohZs0749907499epcas2p1-;
        Wed, 15 Jul 2020 08:03:36 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200715080336epsmtrp1b43ef18dbf292cd7a15f18016449eb84~h3ljd3UC02635726357epsmtrp1F;
        Wed, 15 Jul 2020 08:03:36 +0000 (GMT)
X-AuditID: b6c32a46-a92a8a80000049ba-6b-5f0eb8583b65
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.89.08303.858BE0F5; Wed, 15 Jul 2020 17:03:36 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200715080336epsmtip212b39533670fe4d18c679f085a918850~h3ljNS6PT0763807638epsmtip2C;
        Wed, 15 Jul 2020 08:03:36 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB464046C39B0B2AC5E36A7BF5FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 1/2] ufs: support various values per device
Date:   Wed, 15 Jul 2020 17:03:35 +0900
Message-ID: <01f401d65a7e$70f5bba0$52e132e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHu1pDNEI1WArg19xfehYJkuPyuggFIo2zFASntDDcCTmR2VaixRx3Q
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmhW7EDr54g4vtBhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiMqxyUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WUmhLDGnFCgU
        kFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJMxpfUM
        c8FuwYqdvaoNjL94uhg5OCQETCSOtNh1MXJxCAnsYJS41j6THcL5xCjRsmIhK4TzmVFi5fEJ
        LF2MnGAds97dYIFI7GKUeLq7E6rlBaPEtL/bWUGq2AS0JaY93A3WLiJwn0niyM4HYO2cArES
        2/ZcZgFZLizgJvFgRxFImEVAVeLFz3ZGEJtXwFJia+M+ZghbUOLkzCdgrcwC8hLb385hhrhC
        QeLn02Vgu0SAxhxd3c4MUSMiMbuzDarmDIfErCOVELaLxI1lh5ggbGGJV8e3sEPYUhIv+9ug
        7HqJfVMbwG6WEOgB+mzfP0aIhLHErGcgx3EALdCUWL9LHxJ2yhJHbkGdxifRcfgvO0SYV6Kj
        TQiiUVni16TJUEMkJWbevAO1yUOib8dd1gmMirOQPDkLyZOzkDwzC2HvAkaWVYxiqQXFuemp
        xUYFRshRvYkRnJi13HYwTnn7Qe8QIxMH4yFGCQ5mJRFeHi7eeCHelMTKqtSi/Pii0pzU4kOM
        psBgn8gsJZqcD8wNeSXxhqZGZmYGlqYWpmZGFkrivPWKF+KEBNITS1KzU1MLUotg+pg4OKUa
        mJaaqM7fMbdbNn7BL2Xv6wz6tw1vfFt9ajZv/YbXhyWbuVen28xZfdPb7tDzPcoM1b/qNl2+
        4tq/Ye2FufKdXrkT2RRa/t7wMnphzzy9mNlolwxz6aHLfKebFQ31Dz4P8HkoMMl7i/1jVSG9
        f9rMSs+arzzwPL11j/4WAdHKLttFV4z962ZVH1SN8XA6vsrR+sttpjXmshZbtOr5dpVz7vY8
        N0ncVM4qeW6kU+ffyayu9iHSq/lZUxlPG9w/1nQtUnR5iq96RJdI//Mbj2V2bgvzOPQ2YM5V
        b8crUyw27heIe7Tsye1uHXnGGgb/QufwvMpisaaZc91Trt6KfFp5rK3mqBFn9ssQ9aSwab+M
        lFiKMxINtZiLihMBYjF33lUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSvG7EDr54gxktvBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKmNJ6hrlgt2DFzl7VBsZfPF2MnBwSAiYSs97dYOli5OIQEtjBKLG3ZS47REJS
        4sTO54wQtrDE/ZYjrBBFzxglbq0+AFbEJqAtMe3hbrCEiMBbJok7ty8zQVStZpI4ceUIM0gV
        p0CsxLY9l4F2cHAIC7hJPNhRBBJmEVCVePGzHWwDr4ClxNbGfcwQtqDEyZlPWEBsZqAFvQ9b
        GSFseYntb+cwQ1ykIPHz6TJWEFsEaOTR1e3MEDUiErM725gnMArNQjJqFpJRs5CMmoWkZQEj
        yypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOB41NLawbhn1Qe9Q4xMHIyHGCU4mJVE
        eHm4eOOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ836dtTBOSCA9sSQ1OzW1ILUIJsvEwSnVwOQZ
        Mz90wYvNmewPmvXOWYR9yp+usD5D2uX150OCKud0C1wtdbpX3Hq+wi0uR7Bj9WVBqZ8f8ww9
        ZjnHP15km7ui5u0V55n3j2kf8LfhfZ58LqRNc/o1ZZlrbYemty3288vdlsB3KI4/WvyudE31
        TjPhCf4FvvoX/75mVIlv+Lid+V9oevjC3c2rqli6p5y6ELWLNamssnvyA2cuZt8Xb4sZXR1S
        Kou5Mu6saDz557T/sc3LL6x4GDzv5l65SHUOvg6NGz06gTwbvn7Xf3rp7svQd4mhKR6G+k3P
        uI0eyKif01/yI9Z8j9xulkVtHbcm/lzzIHLd7DOr3nz1PH6kfP/2G3eD2eZd7pN9dXG+1UUl
        luKMREMt5qLiRABS5N30NgMAAA==
X-CMS-MailID: 20200715080336epcas2p1552c56dd96a74fa6d9f427811de9ed9e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
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
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> This patch legitimize quirks of all kinds and shapes.
> I am not sure that we should allow it.
If you're concerning the name 'quirk' literally, I can change the way
to use another values by device tree or whatever.
Or do you concern introducing various values?

> 
> 
> > ---
> >  drivers/scsi/ufs/ufs_quirks.h | 13 +++++++++++++
> >  drivers/scsi/ufs/ufshcd.c     | 39
> > +++++++++++++++++++++++++++++++++++++++
> >  drivers/scsi/ufs/ufshcd.h     |  1 +
> >  3 files changed, 53 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufs_quirks.h
> > b/drivers/scsi/ufs/ufs_quirks.h index 2a00414..f074093 100644
> > --- a/drivers/scsi/ufs/ufs_quirks.h
> > +++ b/drivers/scsi/ufs/ufs_quirks.h
> > @@ -29,6 +29,19 @@ struct ufs_dev_fix {
> >         unsigned int quirk;
> >  };
> >
> > +enum dev_val_type {
> > +       DEV_VAL_FDEVICEINIT     = 0x0,
> 
>             /* keep last */
> > +       DEV_VAL_NUM,
> > +};
> > +
> > +struct ufs_dev_value {
> > +       u16 wmanufacturerid;
> > +       u8 *model;
> > +       u32 key;
> > +       u32 val;
> > +       bool enable;
> > +};
> > +
> >  #define END_FIX { }
> >
> >  /* add specific device quirk */
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 52abe82..b26f182 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -207,6 +207,21 @@ static struct ufs_dev_fix ufs_fixups[] = {
> >         END_FIX
> >  };
> >
> > +static const struct ufs_dev_value ufs_dev_values[] = {
> > +       {0, 0, 0, 0, false},
> > +};
> > +
> > +static inline bool
> > +ufs_get_dev_specific_value(struct ufs_hba *hba,
> > +                          enum dev_val_type type, u32 *val) {
> If (ARRAY_SIZE(ufs_dev_values) <= type)
>     return false;
> 
> 
> Thanks,
> Avri
Got it.

Thanks.
Kiwoong Kim

