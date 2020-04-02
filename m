Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2AAC2BA12
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 677FF206CC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 15:08:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VOSnjOU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbgDBPI1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 11:08:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45548 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388871AbgDBPI0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 11:08:26 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200402150821epoutp03516b7a8f59fda00d788abe255c771263~CCSuZVCBe1292712927epoutp03h
        for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2020 15:08:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200402150821epoutp03516b7a8f59fda00d788abe255c771263~CCSuZVCBe1292712927epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585840101;
        bh=6n/U4UXr1sadm5NpMP9GqwT5rx5fOlWjC/IaV5L6yFI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=VOSnjOU3F90aQgXc10Zr3lnSf7D5vupy1FNDL5CHZ9DimK21wm1JldHQrPtSZZo05
         ILBvL3TWhlFsabG3rJydz27e4qqmZNp5PIidZ2ZBA+MkcgysDec8AWLn8azUPFw/lv
         UD6SrBHMU3HG22/MYJzVDgFHYrabT4pTypeswQ5s=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200402150820epcas5p3de6c9f31537388707edabd8a4a12df73~CCStqQfdI3224332243epcas5p3p;
        Thu,  2 Apr 2020 15:08:20 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        54.91.04782.4EFF58E5; Fri,  3 Apr 2020 00:08:20 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200402150820epcas5p1d7438cd324271c43d54bd446e239f108~CCStIGjxQ2767827678epcas5p1g;
        Thu,  2 Apr 2020 15:08:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200402150820epsmtrp26e18ee8b63dda67bfd570c016d798f08~CCStHTQBJ2842128421epsmtrp2Z;
        Thu,  2 Apr 2020 15:08:20 +0000 (GMT)
X-AuditID: b6c32a49-89bff700000012ae-a1-5e85ffe49d7c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.1F.04024.4EFF58E5; Fri,  3 Apr 2020 00:08:20 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200402150817epsmtip2bc01951f013328dcb2a8973e30a4a8cd~CCSqSFhsN0906209062epsmtip2I;
        Thu,  2 Apr 2020 15:08:17 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Cc:     <krzk@kernel.org>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <stanley.chu@mediatek.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <SN6PR04MB4640B92BC9EA5CFEB74BE5EAFCCD0@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v4 4/5] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
Date:   Thu, 2 Apr 2020 20:38:15 +0530
Message-ID: <000001d60900$8b6f5e70$a24e1b50$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKI+vJzlUBp7WIi19k8pRZBKIHK2gGl+w7dArc8+ogCfXKHn6bJNFzg
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmlu6T/61xBh/nGFq8/HmVzeLT+mWs
        FvOPnGO1OH9+A7vFzS1HWSw2Pb7GanF51xw2ixnn9zFZdF/fwWax/Pg/JovWvUfYLZZuvcno
        wONxua+XyWPTqk42j81L6j1aTu5n8fj49BaLR9+WVYwenzfJebQf6GYK4IjisklJzcksSy3S
        t0vgyliw2LngOU/F1Jf3mBsYV3F1MXJySAiYSOxZ9YKpi5GLQ0hgN6PE6h332SGcT4wS5589
        ZwGpEhL4xigxfakqTEfn/l6oor2MEu+/voFy3jBKLJqzjxWkik1AV2LH4jY2EFtEoFZi8eQO
        VpAiZpCx3/ZOBhvLKRAr8fPJNEYQW1ggROLG6+VgzSwCKhKrHt9iBrF5BSwl9i+7wAphC0qc
        nPkErJdZQFti2cLXzBAnKUj8fLqMFWKZm8T7exOYIGrEJY7+7GEGWSwhsIxd4tO1dawQDS4S
        lzadY4SwhSVeHd/CDmFLSXx+txfoag4gO1uiZ5cxRLhGYum8YywQtr3EgStzWEBKmAU0Jdbv
        0odYxSfR+/sJE0Qnr0RHmxBEtapE87urUJ3SEhO7u6EO8JD423uIaQKj4iwkj81C8tgsJA/M
        Qli2gJFlFaNkakFxbnpqsWmBYV5quV5xYm5xaV66XnJ+7iZGcErT8tzBOOuczyFGAQ5GJR5e
        hoOtcUKsiWXFlbmHGCU4mJVEeB1nAIV4UxIrq1KL8uOLSnNSiw8xSnOwKInzTmK9GiMkkJ5Y
        kpqdmlqQWgSTZeLglGpgDOdqszdfoWPp0h3DErrd+tVh3pR3G/m6YrX91nXt7MvcpeFblaNZ
        s9jcaMN574ipu8S44meWpm0te7XQ/+qFuWfrvnsd/3f+74Nj4r/2/97Iozo5+k/RqSMZonuq
        +7u5eCJPz2/pnvxm/5/7HMnXOvpaKib9rPoQabrr5JTnR4o+TvFzcd70QYmlOCPRUIu5qDgR
        AF51hTZlAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsWy7bCSvO6T/61xBi3nuS1e/rzKZvFp/TJW
        i/lHzrFanD+/gd3i5pajLBabHl9jtbi8aw6bxYzz+5gsuq/vYLNYfvwfk0Xr3iPsFku33mR0
        4PG43NfL5LFpVSebx+Yl9R4tJ/ezeHx8eovFo2/LKkaPz5vkPNoPdDMFcERx2aSk5mSWpRbp
        2yVwZTSe7GcrOMpT8enmN/YGxg6uLkZODgkBE4nO/b3sXYxcHEICuxklpq94ywKRkJa4vnEC
        O4QtLLHy33OooleMEms6TjOBJNgEdCV2LG5jA0mICDQySiz+t4QRxGEW+MUo8WTtQyaIlglM
        En8vLmUEaeEUiJX4+WQamC0sECTx/8RGNhCbRUBFYtXjW8wgNq+ApcT+ZRdYIWxBiZMzn4Dd
        xCygLfH05lM4e9nC18wQ9ylI/Hy6DKxeRMBN4v29CUwQNeISR3/2ME9gFJ6FZNQsJKNmIRk1
        C0nLAkaWVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwTGqpbmD8fKS+EOMAhyMSjy8
        DAdb44RYE8uKK3MPMUpwMCuJ8DrOAArxpiRWVqUW5ccXleakFh9ilOZgURLnfZp3LFJIID2x
        JDU7NbUgtQgmy8TBKdXAmMgiJcbzOX79dEt9Z8O3K5LP/Y+z3OGR8khQxdOunufQouN7LiZ3
        OrQcm14nurfNs/xx4owcp52dnacO9uRXehVP+N/n1hC4OXq/auNPtuZJk8QOHtHWf/dr25Rn
        8gzzr004/uqL0r1wj3RzsU79HQENrm7rzy2OerWQ042573KEtN/WaoYYJZbijERDLeai4kQA
        sutWFs0CAAA=
X-CMS-MailID: 20200402150820epcas5p1d7438cd324271c43d54bd446e239f108
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200327171420epcas5p490e1e6d090a540eaf050e0728a39ba25
References: <20200327170638.17670-1-alim.akhtar@samsung.com>
        <CGME20200327171420epcas5p490e1e6d090a540eaf050e0728a39ba25@epcas5p4.samsung.com>
        <20200327170638.17670-5-alim.akhtar@samsung.com>
        <SN6PR04MB4640B92BC9EA5CFEB74BE5EAFCCD0@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri

> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: 28 March 2020 16:58
> To: Alim Akhtar <alim.akhtar=40samsung.com>; robh+dt=40kernel.org;
> devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org
> Cc: krzk=40kernel.org; martin.petersen=40oracle.com; kwmad.kim=40samsung.=
com;
> stanley.chu=40mediatek.com; cang=40codeaurora.org; linux-samsung-
> soc=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; linux-
> kernel=40vger.kernel.org
> Subject: RE: =5BPATCH v4 4/5=5D scsi: ufs-exynos: add UFS host support fo=
r Exynos
> SoCs
>=20
> Hi,
>=20
> > +
> > +long exynos_ufs_calc_time_cntr(struct exynos_ufs *ufs, long period) =
=7B
> > +       const int precise =3D 10;
> > +       long pclk_rate =3D ufs->pclk_rate;
> > +       long clk_period, fraction;
> > +
> > +       clk_period =3D UNIPRO_PCLK_PERIOD(ufs);
> > +       fraction =3D ((NSEC_PER_SEC % pclk_rate) * precise) / pclk_rate=
;
> > +
> > +       return (period * precise) / ((clk_period * precise) +
> > +fraction); =7D
> This helper essentially calculates a factor f, and returns period x f.
> Why not do that regardless of period?
>=20
The period can be different for different timing attributes, so this helper=
 function takes the period and returns the timer counter value based on the=
 pclk_rate.=20

> > +extern long exynos_ufs_calc_time_cntr(struct exynos_ufs *, long);
> Why this factor needed to be exported?
Yes, not needed, will correct this in next version, which I am planning to =
post soon.
Thanks for your time and review, let me know if you have more inputs.

