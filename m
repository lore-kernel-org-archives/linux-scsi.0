Return-Path: <SRS0=uOdR=AW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BECC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 05:43:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA6E0206F4
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Jul 2020 05:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZM1Twe0J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgGKFnw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Jul 2020 01:43:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62545 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgGKFnv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Jul 2020 01:43:51 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200711054348epoutp04913a9ae58389fe1caa5de452ec9038bd~gnGWZ6vwp3259732597epoutp04h
        for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2020 05:43:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200711054348epoutp04913a9ae58389fe1caa5de452ec9038bd~gnGWZ6vwp3259732597epoutp04h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594446228;
        bh=u0ShJ+mP9iCiMCtDpZkUDKjjJnQ0Qn5/gX2p/rC26GY=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=ZM1Twe0JjxN/ZwNUMaQWlQJ2Apj18JHbDfUuz83VujvznAmsq1fs9RNUIAuGjXR4G
         QaW18hE0kIHXFYGuH12gyi4tZasB0LUilKBTY/4L37A2/+h6YeRI5HL63/jCigNyiX
         ga0ncuwLXEMmFfTyYA1UOGobd5LmvAd3bKOlmbIc=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20200711054347epcas2p1f1058ead03854f8bdb00789a13684710~gnGVj1rBA1844818448epcas2p1g;
        Sat, 11 Jul 2020 05:43:47 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4B3f3Q1lTjzMqYkV; Sat, 11 Jul
        2020 05:43:46 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.A8.27441.091590F5; Sat, 11 Jul 2020 14:43:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20200711054343epcas2p4180ec99be3e12d23754b005c8f84055c~gnGSCitAU1016210162epcas2p4h;
        Sat, 11 Jul 2020 05:43:43 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200711054343epsmtrp1e45e1b6f783b0e638380de8a84364085~gnGR_6Sqx2970129701epsmtrp1g;
        Sat, 11 Jul 2020 05:43:43 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-4d-5f0951900cc6
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        83.5D.08303.F81590F5; Sat, 11 Jul 2020 14:43:43 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200711054343epsmtip2058c366578a1a4cce7caa88d6445c77e~gnGRxq26f1041410414epsmtip2U;
        Sat, 11 Jul 2020 05:43:43 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <BYAPR04MB46294F9AA905B811900BB48AFC640@BYAPR04MB4629.namprd04.prod.outlook.com>
Subject: RE: [RESEND RFC PATCH v4 3/3] ufs: exynos: implement
 dbg_register_dump
Date:   Sat, 11 Jul 2020 14:43:43 +0900
Message-ID: <000901d65746$3cd27100$b6775300$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ3IuC2j48zjcAhrcL1upjrEzI4TgDqKC/VANjrfnQCUldxsaefmzuQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmhe6EQM54g9O7uSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usXrxAxaLRTe2MVl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63H5irfH5b5eJo8Jiw4wenxf38Hm8fHpLRaPvi2rGD0+b5LzaD/QzRTAEZVjk5Ga
        mJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0spJCWWJOKVAo
        ILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwNCwQK84Mbe4NC9dLzk/18rQwMDIFKgyISfj9sSX
        LAWTmSv+zH7N0sC4lqmLkZNDQsBE4t+Bg+xdjFwcQgI7GCVObt3FDOF8YpQ4OHE2lPOZUWL6
        7N+sXYwcYC2Pl2hDxHcxSmztX8wK4bxglDi3egsLyFw2AW2JaQ93gyVEBO4zSRzZ+QAswSkQ
        K/HpQhcTyCRhgUCJha/tQcIsAqoSvQ29YAt4BSwldrRqg4R5BQQlTs58AtbJLCAvsf3tHGaI
        sxUkfj5dxgpiiwi4Scya08QOUSMiMbuzDexoCYELHBI/v3xlhDjaRWLiBAOIXmGJV8e3sEPY
        UhIv+9ug7HqJfVMbWCF6exglnu77xwiRMJaY9awdbA6zgKbE+l36ECOVJY7cgjqNT6Lj8F92
        iDCvREebEESjssSvSZOhhkhKzLx5B2qTh8TJU79YJjAqzkLy5CwkT85C8swshL0LGFlWMYql
        FhTnpqcWGxUYI0f1JkZwYtZy38E44+0HvUOMTByMhxglOJiVRHijRTnjhXhTEiurUovy44tK
        c1KLDzGaAkN9IrOUaHI+MDfklcQbmhqZmRlYmlqYmhlZKInzFltdiBMSSE8sSc1OTS1ILYLp
        Y+LglGpg0nzdYN998FLDIZGFcZGXhSbnyD9+erLl1U+eVc8nOc4QNG5h9NrhtFLXf9eKQ8Ha
        2z0VRAxOvbOQ5VniEZMksX+/9GPdI/dr1Z857No4UcLn11+ZXZO5TULYsyrkOrt9tTi39x0X
        CTwp2XJ/p/PmE0mzVHcty3L6/fPcgdkzP+0QEnG4vPJ3ztxrsmEzbeP+vmi22C1gIePks6D3
        7Ny84CbLrX+tXlouXqBc2JzoutzltGJx+rkXC8TtlFxfGrqKOcW9OeE2uWFe4E2zk2w6emqW
        m3vWvufkqt5klD3pwebV5z/s+BGXmfQz7ZgHy4UJnN8tdzF/UF3UZrlme9GCT7NLA90zUkLf
        hDSt3LFpqhJLcUaioRZzUXEiAArEppRVBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSvG5/IGe8wZkvUhYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKuD3xJUvBZOaKP7NfszQwrmXqYuTgkBAwkXi8RLuLkZNDSGAHo8SKMwYgtoSA
        pMSJnc8ZIWxhifstR1i7GLmAap4xSnx+tIcZJMEmoC0x7eFusISIwFsmiTu3LzNBVK1mkpj3
        7jNYO6dArMSnC11MILawgL/EkeZJYDaLgKpEb0MvK8gVvAKWEjtawa7gFRCUODnzCQuIzQy0
        oPdhKyOELS+x/e0cZoiLFCR+Pl3GCmKLCLhJzJrTxA5RIyIxu7ONeQKj0Cwko2YhGTULyahZ
        SFoWMLKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjkYtrR2Me1Z90DvEyMTBeIhR
        goNZSYQ3WpQzXog3JbGyKrUoP76oNCe1+BCjNAeLkjjv11kL44QE0hNLUrNTUwtSi2CyTByc
        Ug1MNeuWnZpxeW5oWHoxv9yKq8elmzL16kRN3Xb8dTnuvKVD2MqAQ+en0qnfzfPi556s/GYc
        LNIUKSueZCrr904n6tFC0ZNHj/oK2ybO+3W5p/j2w8xtaV8bDKIj4pxrHq3w8phhZ3km7N/R
        PreAMGm9qmWnzs067LRAb5nvJ9mHEw2WSlxjs9/DX6R81V7OXOJ24/Hr6dJFx5WV3vpoqcWk
        pHFuOF6j9jiN+9q29yGv8ye3vK7u+5T/lvvxXte4v6s/iu9bEfGVrfEhR+69C2mh9evzWW1+
        9DNx/FkkeGnq5QaP5Mu2K69WmWppd+Y9/GJjtT5ZO/1Z3dvdd+MvCvfs+awwu+LX2t0+UqHn
        Mz2VWIozEg21mIuKEwFySGMYNQMAAA==
X-CMS-MailID: 20200711054343epcas2p4180ec99be3e12d23754b005c8f84055c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200708023156epcas2p188781afcff94b548918326986d58a2d7
References: <cover.1594174981.git.kwmad.kim@samsung.com>
        <CGME20200708023156epcas2p188781afcff94b548918326986d58a2d7@epcas2p1.samsung.com>
        <ace3fe9ebea3b82e23c6c6ebc5bd92fbdde23b51.1594174981.git.kwmad.kim@samsung.com>
        <BYAPR04MB46294F9AA905B811900BB48AFC640@BYAPR04MB4629.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static void exynos_ufs_dbg_register_dump(struct ufs_hba *hba) {
> > +       struct exynos_ufs *ufs = ufshcd_get_variant(hba);
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&ufs->dbg_lock, flags);
> > +       if (ufs->under_dump == 0)
> If you would use test_and_set_bit it would save you both under_dump and
> dbg_lock ?


Great. Got it.

Thanks.
Kiwoong Kim

