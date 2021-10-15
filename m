Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E15FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 11:44:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BCCD601FA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 11:44:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238526AbhJOLqz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 07:46:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23036 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238518AbhJOLqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 07:46:54 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211015114446epoutp0494f05dfd9099f07596a9eeb19f4ed900~uMaIUnd_Z0521505215epoutp04Y
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 11:44:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211015114446epoutp0494f05dfd9099f07596a9eeb19f4ed900~uMaIUnd_Z0521505215epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634298287;
        bh=9ibLWWYXtqONpYsM+RPoBB6btYvbtxljbm2cBx/1ix0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=cGwVQAwsLr7IhrPQfeMiDwGjOkoh7YQoUAeSOPIjOSL3I+QWWD9qnkZvbx7qWNOSy
         zB3mTahWhSN+RsV60IIqKcKnMdlFa6FR2ZDWtQlPISgpBbbyd8jcd7rC79WkkGrGcF
         bVpjD9sR8fAC0pH3owVrIOtbjajYgDHT7j+reyrM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211015114445epcas2p4204a3597938779299794151157ce46ed~uMaHXXokb1732817328epcas2p4C;
        Fri, 15 Oct 2021 11:44:45 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.98]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HW4F74sbzz4x9Pt; Fri, 15 Oct
        2021 11:44:43 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.4A.09717.BA969616; Fri, 15 Oct 2021 20:44:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20211015114442epcas2p4fb759f8baa5e5ca6aa4529ff1d196a3a~uMaDtdnoY3156031560epcas2p4O;
        Fri, 15 Oct 2021 11:44:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211015114442epsmtrp2c0b926d14c589ba5c544a2dd4a9c3cf6~uMaDrpsdS0939409394epsmtrp2M;
        Fri, 15 Oct 2021 11:44:41 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-75-616969abc327
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.2E.09091.9A969616; Fri, 15 Oct 2021 20:44:41 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20211015114441epsmtip2f1b8505a260d865937c24c392a8d17a0~uMaDb4j6G1883118831epsmtip2Z;
        Fri, 15 Oct 2021 11:44:41 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>, <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        "'Sowon Na'" <sowon.na@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Inki Dae'" <inki.dae@samsung.com>
In-Reply-To: <DM6PR04MB65750B8E2F84802BF0647D7EFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [PATCH v4 14/16] scsi: ufs: ufs-exynos: multi-host
 configuration for exynosauto
Date:   Fri, 15 Oct 2021 20:44:41 +0900
Message-ID: <001a01d7c1ba$0ab7bb50$202731f0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL83TaU2gFk6OcLuUCqdNaZ93XEzwJh+NfxAgJZnjEB7B3NeqlXF7wQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01Te0xTVxzOube9Lc7itTx2JOjwLs6IAVpG6UFA2UB3nW6iLs4sU7iBu9JR
        2q4ti4+YYAiP8jAoYkd56JiCKVMGdC0jslUUecy5LIIKURQCWtxgSnEDFBjlso3/vu93vu/8
        ft95CHHxGOEnVKoNrE7NqChiGc92bQMKqlUqGcm0yx91Dn1LoEeVNgKNTPUQ6OqAkYfOPJvC
        0XhdNR8V/BCLfi6qwtCph0U8NFRnxlHVPRuG7k1n81H96CSGeq1tPPTVrz9iKP9uE4Fq2mcx
        9HKqFYsR07e7d9DmjEKCvn2iEKMbLwbS31wZwegGi5Ggi6ocgP67Lpegnw/38egTVgugXQ1r
        6BxHPha//JPUqBSWSWZ1Aaw6SZOsVCuiqR17E2ITZOESaZA0AsmpADWTxkZTcTvjg7YpVfPp
        qIAvGVX6fCme0eupkM1ROk26gQ1I0egN0RSrTVZp5dpgPZOmT1crgtWsYZNUIgmVzQsTU1Nq
        BqcxbcFrhyZKx4kMcFWYB4RCSIbBnLy1eWCZUEw2AWjq7ME4Mg5g+f2bfI78BeCcw0HkAY8F
        x4u2wkVVC4BlHWWAI04AXQMTuFtFkCFwJNe2YPcm5wA8WeDE3QQnp3BoL34K3CoP8gB82OcU
        uLEXeRDe6q9dqPPIdTAzsxN3TygiI6Dx5ofusohcCTtLh3hujJMbYfXXv+PcSAFwaria78be
        5DZYWdst4DTesMyYvdAXkmUe8EbHA4JLHQePXz7Ieb3g03argMN+0DXWQnD6fACzBucWF2oB
        NB7fyeEtcNpk5bv3wckNsK45hNvyTXi9b3E0T5h7bUbAlUUwN1vMGddDh93E4/BqmF/u4hcB
        yrwkmHlJMPOSAOb/e50DPAvwZbX6NAWrD9VK/7vsJE1aA1h4+IFbm0Dx6LPgVoAJQSuAQpzy
        Fo05FIxYlMwcPsLqNAm6dBWrbwWy+ZM+ifv5JGnmf47akCANi5CEhYdL5aEyiZx6XaSJVTJi
        UsEY2FSW1bK6f32Y0MMvA7s4Ibj0ETp9vstuqhRdIK3H6OuPtz/pUEVOVsiO6gS7j7T0f3+n
        t+SUx/bmsfuCdzdhiWOW2aq+Y9bkS9qK3XcyJi9cziSS3spRbE7SPNAUbnFkDT7pk01+FhH3
        xT5GuKKrvtv6U9DHFTMlsu+y/f1FkdEv98rbV7eFHqouMdgNBxpXvL+/aMDW/MJu1Y2uFbBR
        6wW9iWddu/aY3lge5NkQFeek/Q5fibGM9rxdcaPkbn/oKnqWdK7yrWnelfVb03hE/WzC/i6T
        rcIn8s+jnjHlZ0/fqnmcUk/4vpKZf3n0eflzn+IPhjfuy2s8XyqzbP005I91XkZfcYjc951X
        0vfq1szsyaV4+hRGGojr9Mw/FoSn7YEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWy7bCSvO7KzMxEg70tZhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLXp2OlucnrCIyWLS/QksFk/Wz2K2WHRjG5PFjV9trBYb
        3/5gsri55SiLxYzz+5gsuq/vYLNYfvwfk8Xvn4eYHIQ8Ll/x9pjV0Mvmcbmvl8lj8wotj8V7
        XjJ5bFrVyeYxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkCeKK4bFJSczLLUov07RK4
        MhYdOMVe0Mtd0b99A1MD4x6OLkZODgkBE4mvR3uZuhi5OIQEdjNKzNzVxgKRkJV49m4HO4Qt
        LHG/5QgrRNEzRomb626BFbEJ6Eu87NgGlhARaGSSONfcxALiMAs0s0is/XkFqmU6k8S+LY3M
        IC2cArES92+9AJsrLBAjcWjHdyYQm0VAVaK5+SRQDQcHr4ClROcZP5Awr4CgxMmZT8C2MQto
        Szy9+RTOXrbwNTPEeQoSP58uYwWxRQTcJOatvsIOUSMiMbuzjXkCo/AsJKNmIRk1C8moWUha
        FjCyrGKUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECE4AWpo7GLev+qB3iJGJg/EQowQH
        s5II77sD6YlCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1
        MG19ZOGVdfSYoEav2+9Wk0Mm7w+1iU6/dGPfd5ZgSwN2FuXgKQu6/7Dc77bc88BIpifvT/eZ
        FYtu22psK3q1d0fmRfHFoiwztoRyxxyTmfhDY2Xk5fdvL4fWWGhe+vOD4ct07qLvIkl1aodt
        JzHuvZ5Z/earzpO3MtM01GtElWwefr92bPLzj7O2fGTavjb8WbmD1JuXR8NWJT9dVPd7qtwf
        r7V7Pu5+8PeOxPwIyUlnojccfcsg1zKneR0HU8FRi4yXCnoWxxZ8PvdAxTFkwrFHQityo8N+
        deocnCL37trr5ZUslz6JbD64/OvLTA2DbTvq71otWaQmMTVae0qq8qufIvMXHlBru6ck8jnK
        P2hLrxJLcUaioRZzUXEiAAceDvxvAwAA
X-CMS-MailID: 20211015114442epcas2p4fb759f8baa5e5ca6aa4529ff1d196a3a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081135epcas2p410e67850fdd25fc762b0bfa49c6e24f1
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081135epcas2p410e67850fdd25fc762b0bfa49c6e24f1@epcas2p4.samsung.com>
        <20211007080934.108804-15-chanho61.park@samsung.com>
        <DM6PR04MB65750B8E2F84802BF0647D7EFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +static int exynosauto_ufs_post_hce_enable(struct exynos_ufs *ufs) =7B
> > +       struct ufs_hba *hba =3D ufs->hba;
> > +
> > +       /* Enable Virtual Host =231 */
> > +       ufshcd_rmwl(hba, MHCTRL_EN_VH_MASK, MHCTRL_EN_VH(1), MHCTRL);
> > +       /* Default VH Transfer permissions */
> > +       hci_writel(ufs, ALLOW_TRANS_VH_DEFAULT,
> > HCI_MH_ALLOWABLE_TRAN_OF_VH);
> > +       /* IID information is replaced in TASKTAG=5B7:5=5D instead of I=
ID in
> UCD */
> > +       hci_writel(ufs, 0x1, HCI_MH_IID_IN_TASK_TAG);
> If I understand correctly, once you set this register, the hw takes care
> of properly arbitrating the requests - PH + up to 4 VHs total of 5
> machines, each supporting 32 requests doorbell.


Actually, four Multi Hosts (1 for PH and 3 for VHs)

> Can you share what policy the arbiter uses among the 5 doorbells?

AFAIK, it is working something like round-robin. It also has a full checker=
 so it will be acting as the RR arbiter until the requests are full not to =
be handled by the controller (I'm not sure the exact number of the full cou=
nt). If full, the lowest UTRD idx will be first.


>=20
> You are designating this change to be used in a UFS2.1 platforms, correct=
?

Yes.

> Are you planning to use the same framework for UFSHCI4.0, which uses MCQ?

AFAIK, next chip will be compatible with 3.1 not 4.0.

Best Regards,
Chanho Park

