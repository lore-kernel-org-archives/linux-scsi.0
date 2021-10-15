Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF226C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 11:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BC7560D07
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 11:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbhJOL7a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 07:59:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14922 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbhJOL7a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 07:59:30 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211015115722epoutp03d4a2f41df8791a9faf17a64f70a3832b~uMlHgd18_1986619866epoutp038
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 11:57:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211015115722epoutp03d4a2f41df8791a9faf17a64f70a3832b~uMlHgd18_1986619866epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634299042;
        bh=/k+lkotVXOQkOoOek2Nc6DuwBiJxK5K6VBoT+qsXVEg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Ruo7ouJuF0cerPieOUn9XtGhl0zTlyM5IcXmbnfbq0fnwWBP1tDy2EMSk6N54s3CW
         pRGOl4uyMd9RXu33TY5iWO4/GzgsjhDP7ukOL7pnIW92ov7yOEIa9XyTGDvg6WP3DO
         187be0wsWQNXK0/UritDqXvwblHPKRQwZI+a0Fbk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20211015115720epcas2p1f3d96b107439581366e748a5c77f2aab~uMlGTZmc11603316033epcas2p1u;
        Fri, 15 Oct 2021 11:57:20 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.100]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HW4WZ4RxWz4x9Px; Fri, 15 Oct
        2021 11:57:14 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.D0.09472.A9C69616; Fri, 15 Oct 2021 20:57:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20211015115713epcas2p36e1cbe87d21fb677651511618d277cde~uMk-hSSD72732127321epcas2p3A;
        Fri, 15 Oct 2021 11:57:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211015115713epsmtrp1923ecfadc1ab50a6d770ddf7583dc2ee~uMk-gvgK82620326203epsmtrp1L;
        Fri, 15 Oct 2021 11:57:13 +0000 (GMT)
X-AuditID: b6c32a48-d5fff70000002500-5e-61696c9a9c59
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.5E.09091.99C69616; Fri, 15 Oct 2021 20:57:13 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20211015115713epsmtip1087112d10b24ab777a59779854187497~uMk-N_Q3M0465904659epsmtip1u;
        Fri, 15 Oct 2021 11:57:13 +0000 (GMT)
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
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <DM6PR04MB657579A3B5545C759F325830FCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: [PATCH v4 00/16] introduce exynosauto v9 ufs driver
Date:   Fri, 15 Oct 2021 20:57:13 +0900
Message-ID: <001b01d7c1bb$caa62450$5ff26cf0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQF4S3CUF/MqmW1HgeqxJ+l+A7GEXwL83TaUAhpEWmmsaidIUA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01TfUwTZxzee9ceLaPLrWB9h5nrzhknkdISPo4J6ICYyzCOhAQSlgEXuEGl
        tLdeq7LogkwqWBFIFEYtUzuHFIYVZIiwLaz4AfsQE/mozcw2VxjdgiIMBRZxbQ83/nve3+95
        3uf3vB8iVDqFhYvUWgOj19IaAgsW9AxuJSMtGjWtfOx5nRz2fImRv37Wg5HepTGM/O63agHZ
        MLuEknOOFiF5/Goq+UOdDSE9DgtK2lw9COlaNgnJzplFhPx05FuENE/0YuSFmysI+c+SE9mJ
        U3dG0ylLeQ1G3TlRg1CXWyOoz7/2IlRXWzVG1dkGAPXEUYVRjybdAupEdxug5rs2UkcHzEhG
        SE5JYjFDFzJ6OaMt0BWqtUVJRHpmXmpebJxSFalKIOMJuZYuZZKItN0ZkbvUGl8mQr6P1hh9
        pQya44io5ES9zmhg5MU6zpBEMGyhho1nFRxdyhm1RQotY3hLpVRGx/qI+SXFnZVdgDXJDszZ
        V7By8Ad+DIhFEI+Bv4ydwo6BYJEU7wXwb1N5EL+YA/D8Jz8J/Cwp/hjA/mnlc8W5Jw8FPOkb
        AA9fr1mVTwPYUnEjoMDwKOit6hH6G2H4MwDrj0+j/gWK21Hocd7F/Cwx/j6sbV5E/DgU3wkn
        3E0BLMA3w+oKd2AnCZ4AV0ZqhTx+GQ43eQJ1FH8NXpmxovxMcrg02RLghOEp0G6tR3hOGDxd
        bQoYQ/yoGF5wWDFekAYr3L2rOBT+ebM7iMfh0FtrCuIFZgAr7z9bbbQDWH14N493wOXGbp+b
        yOewFTr6ovwQ4pvgNffqbC/BqsGnQXxZAqtMUl64BQ5caRTw+FVots4L6wBhWZPMsiaZZU0C
        y/9eZ4GgDcgYlistYrhoNua/6y7QlXaBwIOPoHrB6ZlZhRMgIuAEUIQSYZIHA0W0VFJIl33E
        6HV5eqOG4Zwg1nfW9Wj4ugKd78doDXmqmARlTFycKj46VhlPrJfoUtW0FC+iDUwJw7CM/rkO
        EYnDy5GGsBfux0c2Z1VtGBKvR9v2jV3Kyg3dluS15ee++9e1M6MzOSwhaElEz74zN5hp+D09
        ZfLtYMfFj91TL66Qd7ckm0T2xv6N94wSxa2BW+av9ro6pfPzkvHCi2zHDfUrzB7XoaGy6acn
        FXuhbZes4baek3zQix0ax/tdrKumeYG9VLqHy17I+dmgM25r5TrUo4MWpyr7DctQ/4+Vl63z
        BxfaNF9sVxSUJXg2myOmmj7EbNHEI+1y3/nZkQMhrfYsYXJWbkfmOllNzoP2h+2a7+9JDgap
        h2T5K973rgcfOZMml51803ok5XbfdP5SY4chYwe5ff/4fnbxanZI3fDEhth6QsAV06oIVM/R
        /wJprkGjeQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsWy7bCSnO7MnMxEgwP/xCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvTsdLY4PWERk8WT9bOYLRbd2MZkceNXG6vFxrc/mCxm
        nN/HZNF9fQebxfLj/5gsfv88xOQg4HH5irfHrIZeNo/Lfb1MHptXaHks3vOSyWPTqk42jwmL
        DjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMATxWWTkpqTWZZapG+XwJWxsXUTY0GbWMWn
        lf/YGhifC3QxcnJICJhILPz+nqWLkYtDSGA3o8TV/79YIBKyEs/e7WCHsIUl7rccYYUoesYo
        Mfn5bkaQBJuAvsTLjm1gCRGBRiaJc81NYKOYBTYyS9x9fJENouURo0TT/TlgszgFYiX65/5g
        ArGFBRwkrt+aCWazCKhKdDbdAtvNK2Ap8e98PyuELShxcuYTsDizgLbE05tPoWx5ie1v5zBD
        3Kcg8fPpMrB6EQEniZVzJjJB1IhIzO5sY57AKDwLyahZSEbNQjJqFpKWBYwsqxglUwuKc9Nz
        iw0LDPNSy/WKE3OLS/PS9ZLzczcxguNdS3MH4/ZVH/QOMTJxMB5ilOBgVhLhfXcgPVGINyWx
        siq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGpkW9l1a8MjOVWnh7
        atGF25MUVRd9l9p87LjZIZctK2r8Z+d2hXkxlVyaOPti47/a57uSL04pcXD6Y3xI8ZXlsf2x
        XjMYpLWWuB7QVEiXaqnYNfHnoy09DO2CzM8WLbr4b7+PSrDY1Yv83fm/3t3S6m6x4RcoZNjN
        uDEqZovUtcqTPhbrTkrxdi26pmDkXGefYdfMdnyiSLFSdIui1WVnqyv2tzbUyeeeV2wsZ5xt
        qb175WIh98YAGZGnFlHyArIN+SEubefOnb49S/3I1aQXuy6quiQmWKcnzJjT7xgdURFy4gf/
        qeMX3k9h13Se8rgl5HpBtdp1O95XS6f8Ezi9mddEcbfclSu72ni52wU0lFiKMxINtZiLihMB
        V28DZGYDAAA=
X-CMS-MailID: 20211015115713epcas2p36e1cbe87d21fb677651511618d277cde
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211007081133epcas2p31f973709609d82dbbc76bd7b51232cb2
References: <CGME20211007081133epcas2p31f973709609d82dbbc76bd7b51232cb2@epcas2p3.samsung.com>
        <20211007080934.108804-1-chanho61.park@samsung.com>
        <DM6PR04MB657579A3B5545C759F325830FCB89@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Thanks for your review.

> -----Original Message-----
> From: Avri Altman <Avri.Altman@wdc.com>
> Sent: Thursday, October 14, 2021 7:05 PM
> To: Chanho Park <chanho61.park@samsung.com>; Alim Akhtar
> <alim.akhtar@samsung.com>; James E . J . Bottomley <jejb@linux.ibm.com>;
> Martin K . Petersen <martin.petersen@oracle.com>; Krzysztof Kozlowski
> <krzysztof.kozlowski@canonical.com>
> Cc: Bean Huo <beanhuo@micron.com>; Bart Van Assche <bvanassche@acm.org>;
> Adrian Hunter <adrian.hunter@intel.com>; hch@infradead.org; Can Guo
> <cang@codeaurora.org>; Jaegeuk Kim <jaegeuk@kernel.org>; Jaehoon Chung
> <jh80.chung@samsung.com>; Gyunghoon Kwon <goodjob.kwon@samsung.com>; Sowon
> Na <sowon.na@samsung.com>; linux-samsung-soc@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Subject: RE: [PATCH v4 00/16] introduce exynosauto v9 ufs driver
> 
> Hi,
> >
> > In ExynosAuto(variant of the Exynos for automotive), the UFS Storage
> > needs to be accessed from multi-OS. To increase IO performance and
> > reduce SW complexity, we implemented UFS-IOV to support storage IO
> > virtualization feature on UFS.
> >
> > IO virtualization increases IO performance and reduce SW complexity
> > with small area cost. And IO virtualization supports virtual machine
> > isolation for Security and Safety which are requested by Multi-OS
> > system such as automotive application.
> >
> > Below figure is the conception of UFS-IOV architeture.
> Conception --> a conceptual design
> 
> >
> >     +------+          +------+
> >     | OS#1 |          | OS#2 |
> >     +------+          +------+
> >        |                 |
> >  +------------+     +------------+
> >  |  Physical  |     |   Virtual  |
> >  |    Host    |     |    Host    |
> >  +------------+     +------------+
> >    |      |              | <-- UTP_CMD_SAP, UTP_TM_SAP
> >    |   +-------------------------+
> >    |   |    Function Arbitor     |
> >    |   +-------------------------+
> >  +-------------------------------+
> >  |           UTP Layer           |
> >  +-------------------------------+
> >  +-------------------------------+
> >  |           UIC Layer           |
> >  +-------------------------------+
> >
> > There are two types of host controllers on the UFS host controller
> > that we designed.
> > The UFS device has a Function Arbitor that arranges commands of each
> host.
> > When each host transmits a command to the Arbitor, the Arbitor
> > transmits it to the UTP layer.
> - Arbitor --> arbiter
>  - ufs devise --> host controller
> And maybe rephrase the above description (and sketch) so it is clear that
> the PH, VH, and function arbiter are all hw modules in the host controller.

I'll rephrase the descriptions next patchset. Thanks.

Best Regards,
Chanho Park

