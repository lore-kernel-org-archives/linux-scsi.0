Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E92C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 00:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbiGHA3Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 20:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbiGHA3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 20:29:15 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ACC5A450
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 17:29:13 -0700 (PDT)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220708002910epoutp03f34ac1c5b49a0741c6cb7a4a66d9ccb2~-syLr4Q2k3181831818epoutp03l
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 00:29:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220708002910epoutp03f34ac1c5b49a0741c6cb7a4a66d9ccb2~-syLr4Q2k3181831818epoutp03l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1657240150;
        bh=bNrCIqf1WnbCJ++WCmdruzjfLqSBRGS4uNJtFsUwZxs=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ENlTVv5lgfhATBrDECmpQv1I3QtYprfg2g5PcBKM3aaxUnfpRrSWIvuHU+bcyalFU
         XKhkZGaV5o3iKQz2yzuMJrdHGidBtw1MuwDIpSfUVswmz4AFtChZXST/y1h9LR3B8m
         K+zxwatPfIIICq6wP5OeQHZM5SmpCxcBokGUhV48=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20220708002910epcas2p1c86656d472e5335c29f0f308ce9abefd~-syLRbTwQ2120621206epcas2p1e;
        Fri,  8 Jul 2022 00:29:10 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.97]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4LfDfs53KPz4x9Q9; Fri,  8 Jul
        2022 00:29:09 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.64.09642.55A77C26; Fri,  8 Jul 2022 09:29:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20220708002909epcas2p34aa1292b3627baed9a85fb6bee26a686~-syKjwFPV2578125781epcas2p3m;
        Fri,  8 Jul 2022 00:29:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220708002909epsmtrp2d7ff338dcf7f7272a6e4bdfecfc8987b~-syKioeB62212722127epsmtrp2E;
        Fri,  8 Jul 2022 00:29:09 +0000 (GMT)
X-AuditID: b6c32a47-5e1ff700000025aa-92-62c77a55c009
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        59.87.08802.55A77C26; Fri,  8 Jul 2022 09:29:09 +0900 (KST)
Received: from KORCO082417 (unknown [10.229.8.121]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220708002909epsmtip1d014eade0641e9e084e27447ecc6d3ae~-syKWKBqA1429814298epsmtip1y;
        Fri,  8 Jul 2022 00:29:09 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc:     "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Vinod Koul'" <vkoul@kernel.org>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-phy@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>
In-Reply-To: <yq17d4o624t.fsf@ca-mkp.ca.oracle.com>
Subject: RE: [PATCH v2 0/3] change exynos ufs phy control
Date:   Fri, 8 Jul 2022 09:29:08 +0900
Message-ID: <000a01d89261$bd2c4df0$3784e9d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQJzILGI1MJ4mVKNG27n9ebje/AInwNTesy8AnBoo8KsEGIUIA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsWy7bCmmW5o1fEkgzNH1S0ezNvGZjHtw09m
        i0U3tjFZXHjaw2ax9/VWdotNj6+xWkxY9Y3FYsb5fUwW3dd3sFksP/6PyWLnnRPMDtwel694
        e2xa1cnmcefaHjaPCYsOMHpsXlLv8fHpLRaPvi2rGD2O39jO5PF5k1wAZ1S2TUZqYkpqkUJq
        XnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QsUoKZYk5pUChgMTiYiV9
        O5ui/NKSVIWM/OISW6XUgpScAvMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IwdexeyFVxiqVhz
        cRlrA+Ml5i5GTg4JAROJA+9vsHYxcnEICexglLj48jU7hPOJUeLl55ksEM5nRon+aQfYYFo2
        tr9lhEjsYpT4cWcVVP8LRomHKyeCVbEJ6Eu87NjGCmKLCJhLTJxwFGwUs8AqZoneH2uYQBKc
        AsYSn9esYAexhQUsJc49+gRmswioSHQvfgVm8wLFv846wgxhC0qcnPmEBcRmFpCX2P52DtQX
        ChI/ny5jhYiLSMzubGOGWOwk8eTqR2aQxRICRzgkDu+5B/WDi8TttfegmoUlXh3fwg5hS0l8
        frcXqqZYYumsT0wQzQ2MEpe3/YJKGEvMetYODAAOoG2aEut36YOYEgLKEkduQd3GJ9Fx+C87
        RJhXoqNNCKJRXeLA9uksELasRPecz6wTGJVmIflsFpLPZiH5ZhbCrgWMLKsYxVILinPTU4uN
        Cozh0Z2cn7uJEZyStdx3MM54+0HvECMTB+MhRgkOZiUR3njl40lCvCmJlVWpRfnxRaU5qcWH
        GE2BYT2RWUo0OR+YFfJK4g1NLA1MzMwMzY1MDcyVxHm9UjYkCgmkJ5akZqemFqQWwfQxcXBK
        NTAVJlw+9+lj6/PIOf5fWd9MqD7P+fFE2a+jezvNkiPPJ7XaO1e+bXfnWPj57apfOz6yfj/6
        NZTr7aQfiicvhZ320X75aNmLG11btWbLnV6UN4sx7vKTWbL/JWrF5xd/sDz7xKCyZcGVhrZo
        /q89k2KFPmpv5T/8qvb+3gYbsTv2H5V22QV8twlqLb/AnstWffBX1M7d4dLxBe0cUgExX9JO
        XtN0XM27Z1KQYh7TxD6/mtIfXzeLr+Xd/zxlreVi1dcNH69vTW0Unlls8kfQO4D/2KtZbFV/
        GBX7d764kSz1eBaLzSeekPm/VwgdK3j5+GWYaO/a7bGPD/MbFATlWuwW7FtkbW176vnEL3IX
        Wrh4lFiKMxINtZiLihMBzOLoUVIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWy7bCSnG5o1fEkgxsLOCwezNvGZjHtw09m
        i0U3tjFZXHjaw2ax9/VWdotNj6+xWkxY9Y3FYsb5fUwW3dd3sFksP/6PyWLnnRPMDtwel694
        e2xa1cnmcefaHjaPCYsOMHpsXlLv8fHpLRaPvi2rGD2O39jO5PF5k1wAZxSXTUpqTmZZapG+
        XQJXxo69C9kKLrFUrLm4jLWB8RJzFyMnh4SAicTG9reMXYxcHEICOxglHp5bywaRkJV49m4H
        O4QtLHG/5QgrRNEzRombM5tZQBJsAvoSLzu2sYLYIgLmEhMnHAWLMwtsYJZYvKsYbur6x2fB
        EpwCxhKf16wAmyosYClx7tEnMJtFQEWie/ErMJsXKP511hFmCFtQ4uTMJ0C9HEBD9STaNjJC
        zJeX2P52DtQHChI/ny5jhYiLSMzubGOGuMdJ4snVj8wTGIVnIZk0C2HSLCSTZiHpXsDIsopR
        MrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzgytbR2MO5Z9UHvECMTB+MhRgkOZiUR3njl
        40lCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MC07eCfw
        v4xZbcQeiYXZrAand2jZ74/fILBk0j/F4G97hQUKM1dsFxcsma5wYPLkJd0rw6/IPU+YaMXl
        7XB+/5cmHm+G2+ZrVzEc036jobtNzeNFrsD995zlRuty55V5dEvztncsYQwsZ9qnbjJTVG3a
        3eMy77+bdW+OiNw9Z4XF1c17rTdXSuQfXtoZ3zBtifTUBYfvHYpdufbXIl33n8WHZkX4Sq4O
        3yOTLXW5K0HTvP2YVEHbk4j1vn9yunw4ftQGRl2/EqMwa9HbZ1NOup0KLWowcq/fXNgppGKg
        cDZc/GrxqTUKcw3ulBm7P/qfkWxXLPJKY7esbrOZqfeSu65Lz/alnvx1Y56Uw/7OR0osxRmJ
        hlrMRcWJAKbhYeE7AwAA
X-CMS-MailID: 20220708002909epcas2p34aa1292b3627baed9a85fb6bee26a686
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220706020540epcas2p37a8b697af2c6786db9e4ed67cf20a40f
References: <CGME20220706020540epcas2p37a8b697af2c6786db9e4ed67cf20a40f@epcas2p3.samsung.com>
        <20220706020255.151177-1-chanho61.park@samsung.com>
        <yq17d4o624t.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > The first patch is for changing phy clocks manipulation from
> > controlling each symbol/ref clocks to clk_bulk APIs. The second patch
> > is for making power on/off sequences between pmu isolation and clk
> > control.  Finally, the third patch changes the phy on/off and init
> > sequences from ufs-exynos host driver.
> 
> Were you intending this series to go through SCSI or the phy tree?

I thinks the first two patches are going to phy-tree and you'll need to pick
the last patch.

Vinod,
Could you pick the first two patches in your tree?

Best Regards,
Chanho Park

