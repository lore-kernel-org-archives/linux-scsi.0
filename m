Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EAAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 09:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2003561212
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 09:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhJOJzm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 05:55:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60014 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhJOJzl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 05:55:41 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211015095333epoutp048878a60b5c7d04b4d51ec1bc90f89561~uK5BWC8mn1010810108epoutp04z
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 09:53:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211015095333epoutp048878a60b5c7d04b4d51ec1bc90f89561~uK5BWC8mn1010810108epoutp04z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634291613;
        bh=839sOQsc18i6bZGSSp8VKBP9GO3v4xEHpMsvTh63QVE=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=J7kDgUgi8Uc5UrOJGfPsTWWex9cyFAOKcij1gsAWIlLWJEWK42W8Ko0r5QpKXA7Oj
         RTKcPFakidDAMQV8o5scuUxYGkILw13zzhkIBKoA9cLx6CLWmEJVvV5Vm3xOj+UGB4
         s1xWCqnkd5Ywijdh9WEJLD8Xz53kjWBPq9iSGZMI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20211015095332epcas2p39a7143e42c668301c86b57b192204a9f~uK5Ae4iI71402114021epcas2p3Q;
        Fri, 15 Oct 2021 09:53:32 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.101]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HW1mk1nlWz4x9Pv; Fri, 15 Oct
        2021 09:53:26 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.B6.09717.69F49616; Fri, 15 Oct 2021 18:53:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211015095325epcas2p3cc2a31325368f319b06d38bf462a52f6~uK45mZMIG0618806188epcas2p3V;
        Fri, 15 Oct 2021 09:53:25 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211015095325epsmtrp2ada074296891e425491cc7e29ee30d7e~uK45lXkz90448004480epsmtrp2I;
        Fri, 15 Oct 2021 09:53:25 +0000 (GMT)
X-AuditID: b6c32a45-4c1ff700000025f5-22-61694f963ad1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.69.09091.59F49616; Fri, 15 Oct 2021 18:53:25 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211015095325epsmtip196d9b2729082073a1a887eb0d0e1185c~uK45ZN1ZZ2717627176epsmtip1e;
        Fri, 15 Oct 2021 09:53:25 +0000 (GMT)
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
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <DM6PR04MB65752FCA8B8CDF2E0BA0988FFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [PATCH v4 07/16] scsi: ufs: ufs-exynos: correct timeout value
 setting registers
Date:   Fri, 15 Oct 2021 18:53:25 +0900
Message-ID: <000e01d7c1aa$7f3b9010$7db2b030$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL83TaU2gFk6OcLuUCqdNaZ93XEzwKEYZcgAzmGClsBvqAog6lNsCpg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02TeVAbVRzHfbubJUSDSwr2lSpmFtGBCiTIsSjQWo7Z2jJlxmEcmam4kh2u
        kMRssNU6harlSssxjByhlYqVMmk7TENIseUqFCJjL7kaKOVQqKQFhpaZKnhgwlLlv8/v/X7f
        3/XeE6ISO+4lzFDpWK2KUZK4CLP0+IUGVO7PYGTtpc9S/TPncWrqGwtO2VeGcerqdBFGVS6t
        oNTjpgYBdfyHGOqnsnqEmmkyoFS9zYJQttV8AXVx4Q+EGjX3YlT1rQ6E0t9pxamz1n8Q6s+V
        bmSXOz04tJc25J3A6cGSEwjd3OhPf9dmR2iTsQiny+q7AP17UyFOP5odw+gSsxHQyyZvuqBL
        jyQ+l5wVmc4yClYrZVWpakWGKi2K3PtuSkxKaJhMHiCPoMJJqYrJZqPI2H2JAfEZSsdgpPQT
        RpnjOEpkOI4Mio7UqnN0rDRdzemiSFajUGrCNYEck83lqNICVazuTblMFhzqCPwwK32xwksz
        JjrUO7GE5oES12LgKoRECBy6dhorBiKhhGgFcNKQB3jjMYDHmppdeOMJgPkdHeCp5ProAsI7
        2gE01lhwp0NCzAFo/dHfyTgRBO2FFoEzyINYA7D8+BzqdKDEAApNo+uZXIkD8Fj72rp4C/EB
        bBuqc3EyRvhC641JzMliIgK2fNkOeHaH/TUzGJ9nB2z49iHKdySFK7MNAid7EPHwhrUG52M8
        YG1RPupsAhKlrrDtUa+AF8TCB1+0boi3wAdWswvPXnB5sR3nBXrHAn5Z23CcA7Do6D6ed8LV
        KrMjkdBRwQ82XQ5yIiR84LWxjd7cYGHP3y78sRgW5kt44Wuw61IVxvNLUH9yWVAGSMOmyQyb
        JjNsmsDwf63TADOCF1gNl53GcsEa+X+XnarONoH1N+8f1woqFpYCuwEiBN0AClHSQ7zYlcZI
        xArm089YrTpFm6NkuW4Q6th1Oerlmap2fBqVLkUeEiELCQuThweHysLJrWJ1TAYjIdIYHZvF
        shpW+1SHCF298pDwj5C+4Weu/namuPv5iw+Fr75dW37P1jPaa40Lfs+6Y1xflXleKYoq2N6S
        Wzvht9PUeaWms23b2ZfDOibP5Ainbm5zy6rLzD3ya/Suu33994tESMPU1uDpUyUjC102S7Jo
        bnvbgdUkW+cbXycnwYFXoufvjsXn/mWWyPb0zWdOU+NJu8ft5w4VDE8gXLNPum9jAem++PNu
        VLFHrgy0XVqKSzjyVl2NPXCGeMf4/vWRw9Wmr0rLszzutHwO5DcPjiS8HjNsnk7IP+p9z108
        Vh3ru7+xNmbW8/5hkZpxu0C8qPp+iakkr1x2KbjVf+H2lGH+iXSQom57DlREKg+ii77ePh/r
        SYxLZ+T+qJZj/gUzsDakfAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWy7bCSnO5U/8xEg4aN4hYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLXp2OlucnrCIyeLJ+lnMFotubGOyuPGrjdVi49sfTBY3
        txxlsZhxfh+TRff1HWwWy4//Y7L4/fMQk4Ogx+Ur3h6zGnrZPC739TJ5bF6h5bF4z0smj02r
        Otk8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAE8Ul01Kak5mWWqRvl0CV0bzg2uM
        BZu4Kp5sXcjWwPiMo4uRk0NCwETizM23TF2MXBxCArsZJVZtOMUKkZCVePZuBzuELSxxv+UI
        K0TRM0aJN88+s4Ak2AT0JV52bANLiAg0Mkmca25iAXGYBe4wSyw4eZYFomUak8T7bT+ZQVo4
        BWIlWvf+ZwOxhQViJCZ/WgG2g0VAVeL42ftgY3kFLCW2Nu9lhLAFJU7OfAIWZxbQlnh68ymc
        vWzha2aI+xQkfj5dBna3iICbxNnjM9kgakQkZne2MU9gFJ6FZNQsJKNmIRk1C0nLAkaWVYyS
        qQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwZGvpbmDcfuqD3qHGJk4GA8xSnAwK4nwvjuQ
        nijEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTEktTs1NSC1CKYLBMHp1QD09zAv9d4
        q5ZNjfuyMt2fOWhC/hSOysevlew6MpdJqEUlRb/61jijX/aeqZDHvw3vFIJWxxscmXWAJbdx
        gqPODlGPve0vg4+/+qbWJBTNuTD++ErZC2+FX01PY1BefiJTuNP6VHhHk9OtSzkFpdaac3cE
        /rmYw/bhWqmm6ITnIub+nVwnxMRmO0V+XcZz5Vls+1HX57baftrfVdq44kT/ntdnbrOVfbSO
        cdfSX6KJypOYb1Vt3CMaFZ43n2vH1FPShy6/lL6spyYSHrrs/hVetZ0KJ217edIOrc2Ie13V
        HJdj0/AnX79P/t3+bYqMxZ/Oh/Hc7TAy19niFnlf+a1XfLRCQeLb9B+u3bkTzr5WYinOSDTU
        Yi4qTgQAT2X5FmsDAAA=
X-CMS-MailID: 20211015095325epcas2p3cc2a31325368f319b06d38bf462a52f6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081134epcas2p49d174a4da55c5042e2bee42c249678c3
References: <20211007080934.108804-1-chanho61.park@samsung.com>
        <CGME20211007081134epcas2p49d174a4da55c5042e2bee42c249678c3@epcas2p4.samsung.com>
        <20211007080934.108804-8-chanho61.park@samsung.com>
        <DM6PR04MB65752FCA8B8CDF2E0BA0988FFCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Thanks for your review.

> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: Thursday, October 14, 2021 9:12 PM
> To: Chanho Park <chanho61.park=40samsung.com>; Alim Akhtar
> <alim.akhtar=40samsung.com>; James E . J . Bottomley <jejb=40linux.ibm.co=
m>;
> Martin K . Petersen <martin.petersen=40oracle.com>; Krzysztof Kozlowski
> <krzysztof.kozlowski=40canonical.com>
> Cc: Bean Huo <beanhuo=40micron.com>; Bart Van Assche <bvanassche=40acm.or=
g>;
> Adrian Hunter <adrian.hunter=40intel.com>; hch=40infradead.org; Can Guo
> <cang=40codeaurora.org>; Jaegeuk Kim <jaegeuk=40kernel.org>; Jaehoon Chun=
g
> <jh80.chung=40samsung.com>; Gyunghoon Kwon <goodjob.kwon=40samsung.com>; =
Sowon
> Na <sowon.na=40samsung.com>; linux-samsung-soc=40vger.kernel.org; linux-
> scsi=40vger.kernel.org; Kiwoong Kim <kwmad.kim=40samsung.com>
> Subject: RE: =5BPATCH v4 07/16=5D scsi: ufs: ufs-exynos: correct timeout =
value
> setting registers
>=20
> >
> > PA_PWRMODEUSERDATA0 -> DL_FC0PROTTIMEOUTVAL
> > PA_PWRMODEUSERDATA1 -> DL_TC0REPLAYTIMEOUTVAL
> > PA_PWRMODEUSERDATA2 -> DL_AFC0REQTIMEOUTVAL
> Is there a specific reason why this fix is part of the exynosauto series?

I found the issue when I made the patches with some refactoring of ufs-exyn=
os driver.
I can send it separately.

Best Regards,
Chanho Park

