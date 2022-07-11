Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1000DC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 04:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiGKEBd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 00:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGKEBc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 00:01:32 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C0117056
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jul 2022 21:01:30 -0700 (PDT)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220711040124epoutp01d9e915239abd0e958cd615bfdbf6a3b9~AqnWNhuHR2384623846epoutp01p
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 04:01:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220711040124epoutp01d9e915239abd0e958cd615bfdbf6a3b9~AqnWNhuHR2384623846epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657512084;
        bh=aQ8WG5vEnhrHRC0RXtP9GDoBkqtHituAFIcDKhKAtE0=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=qxXCXl1gYgOrT4y4jJzq7mWB8ironYT2GRe/FBafQV7LeTvgZ+36DwLz3rxnxUDl7
         rNlCWRqcf0ul5A/5BiNFCS1W/hzP1PfHwvtl6OqUntbuh22raCc357dFwYmWFo+V/S
         gHXaOEPUFP/F6i2XKrfEDJVR/FdqyhZCTq5KSoGA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20220711040124epcas2p2cf175b5be1b7b8e5c2baa7fcb0dbbfd1~AqnVnX4AO2600026000epcas2p2a;
        Mon, 11 Jul 2022 04:01:24 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.101]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Lh9DM1Wrqz4x9Q7; Mon, 11 Jul
        2022 04:01:23 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.06.09650.390ABC26; Mon, 11 Jul 2022 13:01:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20220711040122epcas2p204e14c906dff9fd7e5052adb04f9e3c4~AqnUN1OCd0225202252epcas2p2_;
        Mon, 11 Jul 2022 04:01:22 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220711040122epsmtrp2cb25a34d4fc5f14efb529220ce83a5d1~AqnUM8Sk_0167601676epsmtrp2B;
        Mon, 11 Jul 2022 04:01:22 +0000 (GMT)
X-AuditID: b6c32a46-0b9ff700000025b2-84-62cba0936442
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2D.DA.08802.290ABC26; Mon, 11 Jul 2022 13:01:22 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.18.123]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220711040122epsmtip1249835846597b59f7ab1caef70e2a852~AqnT35U9t2244922449epsmtip1n;
        Mon, 11 Jul 2022 04:01:22 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <adrian.hunter@intel.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>, <bhoon95.kim@samsung.com>
In-Reply-To: <213634d7-a796-8509-9612-56fe7c61ef01@acm.org>
Subject: RE: [RESEND PATCH v3] scsi: ufs: exclude UECxx from SFR dump list
Date:   Mon, 11 Jul 2022 13:01:22 +0900
Message-ID: <002e01d894da$e2021bc0$a6065340$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQE7NzaYSR5yQWCLH5OMCMWgQFvAMQDlQII7Am+PYo4C+mpXyADlpixhrnmd/CA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJsWRmVeSWpSXmKPExsWy7bCmhe7kBaeTDA7d5bQ4+WQNm8WDedvY
        LF7+vMpmcfBhJ4vF16XPWC2mffjJbLF68QMWi0U3tjFZXN41h82i+/oONovlx/8xWXTdvcFo
        sfTfWxYHXo/LV7w9Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkCOKKybTJS
        E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlZSKEvMKQUK
        BSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgX6BUn5haX5qXr5aWWWBkaGBiZAhUmZGc8fXSP
        sWAxe8XDxadYGhjvsnYxcnJICJhILN1/hbmLkYtDSGAHo8SN5lVsEM4nRokn09qhnM+MEnfv
        nmCEaflw6jNUyy5GifnPexkhnJeMEs17m5lAqtgEtCWmPdzNCpIQEXjNJNG66Tw7SIJTwFri
        +4omoHYODmEBL4nvy7RBwiwCqhI32h4zgYR5BSwlFjxjBgnzCghKnJz5hAXEZgYauWzha2aI
        IxQkfj5dxgoRF5GY3dkGFhcR8JM4cWgSO8haCYEzHBKnb21kh2hwkVj55AOULSzx6vgWKFtK
        4vO7vWwgeyUEiiU27ZOH6G1glFjyaTMLRI2xxKxn7YwgNcwCmhLrd+lDlCtLHLkFdRqfRMfh
        v+wQYV6JjjYhiEZliV+TJkODTVJi5s07UEs9JN7t+c08gVFxFpInZyF5chaSx2Yh7F3AyLKK
        USy1oDg3PbXYqMAIHtfJ+bmbGMGJWcttB+OUtx/0DjEycTAeYpTgYFYS4f1z9lSSEG9KYmVV
        alF+fFFpTmrxIUZTYKhPZJYSTc4H5oa8knhDE0sDEzMzQ3MjUwNzJXFer5QNiUIC6Yklqdmp
        qQWpRTB9TBycUg1MzgbNx2e2r7u4m73QZFHM4UXJfeqPnr7+onCT1aHt7GqX/tZ+jU6j8PUt
        jQl8hyct5L7z+MMf5fg0VePwfSfNM2Lqnnkybos39Kw6PPfjh7TVc1qyOlIvPTc9dvNAgvCR
        E8aV5ZnJR3ZPvPI2voB3QojWxqXVZwUiA3fnzuKTuKX65t+KB/8P/T8/YequM1t+rl3plXZZ
        z38f/5SZRe6hRy6fOQEMyHBb1WCxZQ4tEk+3OTmuk3De9epoz8mmQ//TmORfG689KbF8rs6q
        J+UmvRs4DBYc7rhq6mjCsFB/X2Ig73m1hLJ5swzLRPckn0jYlPudl7e7Q/3gD9+l9sarWv09
        3f6v4stXyPexLjiqxFKckWioxVxUnAgAOo5ZpVUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSnO6kBaeTDHbvE7M4+WQNm8WDedvY
        LF7+vMpmcfBhJ4vF16XPWC2mffjJbLF68QMWi0U3tjFZXN41h82i+/oONovlx/8xWXTdvcFo
        sfTfWxYHXo/LV7w9Fu95yeQxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0HupkCOKK4bFJS
        czLLUov07RK4Mvbs/chcsJK9Yt/6v2wNjPdZuxg5OSQETCQ+nPrM3MXIxSEksINRYv3diUwQ
        CUmJEzufM0LYwhL3W46wQhQ9Z5R4//kXG0iCTUBbYtrD3WAJEYHfTBL73s2CGrWYSaJ33UFm
        kCpOAWuJ7yuagGwODmEBL4nvy7RBwiwCqhI32h4zgYR5BSwlFjwDq+YVEJQ4OfMJC4jNDDS/
        92ErI4y9bOFrZoiDFCR+Pl3GChEXkZjd2QYWFxHwkzhxaBL7BEahWUhGzUIyahaSUbOQtC9g
        ZFnFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcj1paOxj3rPqgd4iRiYPxEKMEB7OS
        CO+fs6eShHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamA6
        fO+ec3D790yL4xOPcvpWV7/60Fzzq/rhlN3tytMfHJ3Z/dn6laHrr9qAXh3Pxal7O1u37b84
        NTTnqbbU2v1rg1f99mPPux30KHrxLvHmduH5Cbt17zLdPykT97vr96y7l868W23NIMMxN/la
        s6CpX1PnzgTDQ2v2JN7gnmS059fTHUXz1tQdEFmc0Wh2immBoOmuXyVBv8OuTwm1+VJ7+f3b
        PwpTHSZNNDOTZ7M8o9M7J+VYMo/77bVrzS1EGv5OFT/zOe731e9icyOUNUxdDE3XZj3eHbcv
        y4zlpnvGV7PTf6acljiRvWd7irXzMofMrOLK1s+8b592TDr/OcGs99rqvGaj0Lqokz/quqVP
        KbEUZyQaajEXFScCAH6up5w2AwAA
X-CMS-MailID: 20220711040122epcas2p204e14c906dff9fd7e5052adb04f9e3c4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220315095716epcas2p2ec52c66863b71180a6c2c45856058683
References: <CGME20220315095716epcas2p2ec52c66863b71180a6c2c45856058683@epcas2p2.samsung.com>
        <1647338162-75639-1-git-send-email-kwmad.kim@samsung.com>
        <1ad26d79-9f5c-9b53-6904-7d7fd53fac2f@acm.org>
        <000001d894ca$45da51f0$d18ef5d0$@samsung.com>
        <213634d7-a796-8509-9612-56fe7c61ef01@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >> Is this behavior specific to the Exynos controller or is this
> >> behavior required by the UFSHCI specification? In the latter case,
> >> can you tell me where to find this requirement in the UFSHCI
> >> specification? I haven't found that requirement yet. Maybe this means
> that I overlooked something?
> >
> > This is needed because those SFRs are ROC (Read to Clear) type.
> > That means reading causes clearing contexts.
> > The SFRs are mainly read in interrupt context but the reading is also
> done in dump.
> The above repeats what I can find in the patch description but doesn't
> answer my question :-(
>=20
> Bart.

It's definitely not Exynos specific
because the fact that those SFRs are ROC type is written in UFSHCI.
I don't know more things to explain why this patch is needed.

You just want to know whether any additional descriptions about ROC is writ=
ten ?

Thanks.
Kiwoong Kim

