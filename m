Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12C5C7EE22
	for <linux-scsi@archiver.kernel.org>; Tue, 16 May 2023 03:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjEPD2X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 May 2023 23:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjEPD2W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 May 2023 23:28:22 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E189F49E0
        for <linux-scsi@vger.kernel.org>; Mon, 15 May 2023 20:28:19 -0700 (PDT)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230516032816epoutp022213a7a4fee1bfe6752c70fcc164af95~fgfoebVc00734607346epoutp02e
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 03:28:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230516032816epoutp022213a7a4fee1bfe6752c70fcc164af95~fgfoebVc00734607346epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684207696;
        bh=RmOSHTOoPYKhK/p+mE50qHzvxD9qqtl9Q289YGqv+pM=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=LRmQk9mXM0bVTmI7pZ0djNVaDba8CMY/iZArzNgh35UFCRELKgz5CMaIVDD8rlsSW
         eu5xmtMHGdvW9eItayqEEuVB5qNBj2WgQV6yjaHRuAcT0Uc8j9UTCxp8u1re8DvzoW
         WslDoPoGBTzTXWAXY8I581VWKZMEEvJsXSPx7J6A=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20230516032816epcas2p2c71f9136e21a950828288a2024efae09~fgfoAVnNK2004520045epcas2p2X;
        Tue, 16 May 2023 03:28:16 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.99]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4QL1sW6CkKz4x9Pr; Tue, 16 May
        2023 03:28:15 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.10.08199.F48F2646; Tue, 16 May 2023 12:28:15 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20230516032815epcas2p3926607c79fd9118d3d0f91e6161aef0f~fgfnA1GG12787927879epcas2p32;
        Tue, 16 May 2023 03:28:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230516032815epsmtrp2c472083aacac672e0737b6622694fd81~fgfnAOCcq2696126961epsmtrp2c;
        Tue, 16 May 2023 03:28:15 +0000 (GMT)
X-AuditID: b6c32a47-e99fd70000002007-75-6462f84f7ca9
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5D.3C.27706.F48F2646; Tue, 16 May 2023 12:28:15 +0900 (KST)
Received: from KORCO011456 (unknown [10.229.38.105]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230516032815epsmtip19d3fdf42a4342d5476f84fe6826f57bb~fgfm0z6IG2258622586epsmtip1X;
        Tue, 16 May 2023 03:28:15 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bao D. Nguyen'" <quic_nguyenb@quicinc.com>,
        <linux-scsi@vger.kernel.org>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <kwangwon.min@samsung.com>
In-Reply-To: <991cac52-22bc-0150-4332-76ac044c5bcb@quicinc.com>
Subject: RE: [RFC PATCH v1] ufs: poll HCS.UCRDY before issuing a UIC command
Date:   Tue, 16 May 2023 12:28:15 +0900
Message-ID: <012d01d987a6$733d2c10$59b78430$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGTQ//Bn9HITMBER2fQmcGpYd1IAgEVn6BsAYR8HMav0/O+YA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdljTTNf/R1KKQV+vocXqxQ9YLLbe2Mli
        0X19B5vF1BfH2S267t5gtFj67y2LA5vHxD11Hn1bVjF6fN4kF8AclW2TkZqYklqkkJqXnJ+S
        mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RWSaEsMacUKBSQWFyspG9nU5Rf
        WpKqkJFfXGKrlFqQklNgXqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdcW7WG/aC60wVN9sfsjQw
        djB1MXJySAiYSEyfswnMFhLYwShxdbtiFyMXkP2JUeLWxqnMEIlvjBLTu2JgGt5tvsQCEd/L
        KDHtrDdEw0tGiXMNjWANbALaEtMe7mYFSYgIbGWU6Nu1mQ0kwSlgL7HlzFVGEFtYwEdi6cEW
        sNUsAqoSXbP+gU3lFbCU6Np3mhHCFpQ4OfMJWJxZQF5i+9s5zBBXKEj8fLqMFcQWEXCSmPfh
        GlSNiMTszjZmkMUSAi/ZJZb9v8AG0eAisX5hBwuELSzx6vgWdghbSuLzu71ANRxAdrbEnoVi
        EOEKicXT3kKVG0vMetbOCFLCLKApsX6XPkS1ssSRW1Bb+SQ6Dv9lhwjzSnS0CUE0Kkv8mjSZ
        EcKWlJh58w7UTg+Je3+OME5gVJyF5MdZSH6cheSXWQh7FzCyrGIUSy0ozk1PLTYqMIbHdHJ+
        7iZGcHLUct/BOOPtB71DjEwcjIcYJTiYlUR422fGpwjxpiRWVqUW5ccXleakFh9iNAWG+kRm
        KdHkfGB6ziuJNzSxNDAxMzM0NzI1MFcS55W2PZksJJCeWJKanZpakFoE08fEwSnVwLQvfMLF
        1UF/1LZ0TJq1JefoKYFNLep3q2Z0rYuc8FTozsLFVWvZvqxiFmpQ11frMdQICbn5t2Tv7uua
        d/7bHL73JXNiQUt07XvjTxM4/l/a8PKjp3kLT96rY8Vh5s/neVgoB/xlkzktlq23Xt7VaYrD
        8UnZu08uXCzT4NnbY2/o/XcmoyQDmyn3TynbMssF1jzuER9/Xg20ceja98bl3i7dDVJzrqm8
        UpocvqTi/MRSMZ89TTem2am/8exUuOi14t3EleJTcr4Le9yJVmlMevntTedfec7tMwp7YxPu
        NOSt1RPkcZI6sHp+313+mu9MvI5PPBdxJ6zfdy8gvPUqm1hljodJ42F2gTDRlq2uc5VYijMS
        DbWYi4oTAUBNH2QXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsWy7bCSnK7/j6QUg//HBS1WL37AYrH1xk4W
        i+7rO9gspr44zm7RdfcGo8XSf29ZHNg8Ju6p8+jbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
        c7PesBdcZ6q42f6QpYGxg6mLkZNDQsBE4t3mSyxdjFwcQgK7GSX2tL5hhkhISpzY+ZwRwhaW
        uN9yhBWi6DmjxOPHXSwgCTYBbYlpD3ezgtgiIN2tO+VAbCGB04wSXydagNicAvYSW85cBRsk
        LOAjsfRgC9hmFgFVia5Z/8Dm8ApYSnTtO80IYQtKnJz5BCzODDS/92ErI4QtL7H97Ryo4xQk
        fj5dBrXXSWLeh2tQ9SISszvbmCcwCs1CMmoWklGzkIyahaRlASPLKkbJ1ILi3PTcYsMCw7zU
        cr3ixNzi0rx0veT83E2M4LjQ0tzBuH3VB71DjEwcjIcYJTiYlUR422fGpwjxpiRWVqUW5ccX
        leakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAdFRL/WKZ14nVy+7dOZljKbXb
        7UHILvuD+qVP2yP29Vc4F552OFB6OLuDuWGWPNu+aqft9/Mlo2ReczLGHEnwPl8bdmzlkvOi
        wicz5AvW9KbnBl9wt8lODGTI0CydccpbbPXCa8XnbrgV3+32m3zToueg3fN/Ky4EK9/Ku/3K
        /LD1nkqRTtHtnNovPV8snbn+cH1d8QKfkhWP1To25rpb5Ft+3XL2i6+59K5NuhaNV/at8Nrk
        vDO9aP7FJq5LRc8sTouv9fh8irfnikrG0dw3EhYtErIZfnOdTqZmTPbcN0N7RYzQ5/KM/4xO
        2r5nVXeH2h8NFlOfMc1+/RVOM/kpZ+a6a7+7tEnMff5Py1Y2JZbijERDLeai4kQAr/ctq/oC
        AAA=
X-CMS-MailID: 20230516032815epcas2p3926607c79fd9118d3d0f91e6161aef0f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230509083312epcas2p375f77d18a9026f7d263750baf9c9a5bb
References: <CGME20230509083312epcas2p375f77d18a9026f7d263750baf9c9a5bb@epcas2p3.samsung.com>
        <1683620674-160173-1-git-send-email-kwmad.kim@samsung.com>
        <991cac52-22bc-0150-4332-76ac044c5bcb@quicinc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > +	do {
> > +		val = ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
> > +			UIC_COMMAND_READY;
> > +		if (val)
> > +			break;
> > +		usleep_range(500, 1000);
> Hi Kiwoong,
> It looks like you are sleeping while holding the spin_lock_irqsave(hba-
> >host->host_lock, flags) in ufshcd_send_uic_cmd()?

You're right. Let me fix it.


