Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E028AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 00:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCDBC61214
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 00:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243713AbhIXBAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:00:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61745 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243676AbhIXBAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 21:00:45 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210924005911epoutp02f900b8f20031bf45241233610141b6f7~nnDdlw9bi2645526455epoutp02P
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 00:59:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210924005911epoutp02f900b8f20031bf45241233610141b6f7~nnDdlw9bi2645526455epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632445151;
        bh=WFCq2/zrr/HKXNeVKi4gsmQqvTfdA4ojLkWwclKqf5E=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=TPiuXAPf5h7Xj/UPHhNM75OThmF9UKtp3FEUjwBJvulv6K0n1bznEmaVWBdlIj29x
         /zYeNWnGBhr3HVE4q9sZMyJXPqd4zjihgQzSaLM2l2kEuj9OlsRFQ2q1n17iZTMcMs
         iVqS66XGTsFAOcD7Xz9jnkr17pUoW3Pfu1bpKy9M=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210924005910epcas2p325bdab2052f81b2c26909957dc4c5ef8~nnDceusa82834928349epcas2p3H;
        Fri, 24 Sep 2021 00:59:10 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HFtvw45YJz4x9QF; Fri, 24 Sep
        2021 00:59:08 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.0F.09749.CD22D416; Fri, 24 Sep 2021 09:59:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210924005907epcas2p229e29158756790fc41eaf7b603bb9f4b~nnDZ0_ah31139011390epcas2p2F;
        Fri, 24 Sep 2021 00:59:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210924005907epsmtrp24d199aea3ff94d2e9a2a686dd3fdfbc8~nnDZz2BB_2894628946epsmtrp2j;
        Fri, 24 Sep 2021 00:59:07 +0000 (GMT)
X-AuditID: b6c32a47-d13ff70000002615-bb-614d22dcb3aa
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        23.93.09091.BD22D416; Fri, 24 Sep 2021 09:59:07 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210924005907epsmtip20e4f0a9e8040864dfbba66d0cbdedb22~nnDZm-SZt0782307823epsmtip29;
        Fri, 24 Sep 2021 00:59:07 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Rob Herring'" <robh@kernel.org>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <YUxyZKRDYXtTUZGJ@robh.at.kernel.org>
Subject: RE: [PATCH v3 06/17] scsi: ufs: ufs-exynos: get sysreg regmap for
 io-coherency
Date:   Fri, 24 Sep 2021 09:59:07 +0900
Message-ID: <000001d7b0df$60903ca0$21b0b5e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQIApKS6Ans9QPYBmW2HKAIOmn+9AcJSwsSpuuaWQA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJsWRmVeSWpSXmKPExsWy7bCmhe4dJd9Eg64zChYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLXp2OlucnrCIyeLJ+lnMFotubGOy2Pj2B5PFzS1HWSxm
        nN/HZNF9fQebxfLj/5gs/u/Zwe4g4HH5irfHrIZeNo/Lfb1MHptXaHks3vOSyWPTqk42jwmL
        DjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMATlWOTkZqYklqkkJqXnJ+SmZduq+QdHO8c
        b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA/STkkJZYk4pUCggsbhYSd/Opii/tCRVISO/uMRW
        KbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ+PMm5ssBT2sFT27L7A1ME5m6WLk5JAQ
        MJGY2vqctYuRi0NIYAejxMb2r8wQzidGiVdn9jOCVAkJfGOU+P5ep4uRHaxjcQZEyV5GiW8v
        vrJClLxglLjRLQZiswnoS7zs2AYWFxFQlWia9YAFpIFZYAqrxOsbh5lBEpwCRhIT91wHs4UF
        IiXufp7DBGKzADU8apsB1swrYCmx6+NcZghbUOLkzCdgVzMLyEtsfzuHGeIDBYmfT5dBLQuT
        uPHwMyNEjYjE7M42sGckBLo5JU5tn8rWxcgB5LhIrGjlgOgVlnh1fAs7hC0l8fndXjaoekaJ
        1kf/oRKrGSU6G30gbHuJX9O3sILMYRbQlFi/Sx9ipLLEkVtQp/FJdBz+yw4R5pXoaBOCaFSX
        OLB9OjTMZSW653xmncCoNAvJY7OQPDYLyQOzEHYtYGRZxSiWWlCcm55abFRgjBzTmxjBiV3L
        fQfjjLcf9A4xMnEwHmKU4GBWEuH9fMMrUYg3JbGyKrUoP76oNCe1+BCjKTCoJzJLiSbnA3NL
        Xkm8oamRmZmBpamFqZmRhZI479x/TolCAumJJanZqakFqUUwfUwcnFINTJJz51XsZmDhbT6o
        eNH3UwCzG6Na8HfmVVLz87VCG3icJq08yxkTf+7Ig42LRHK/1916NWPrkoLbz45PXPLftfgH
        R2LY55lb1qvvkjDdNnf+FCUGr+zZOa2fQ2vb3O/WRN2v51CaXJLmufYH+7l9gYX5gp41xksU
        Xzl8dBYXXup92q3pHNvfLYy/Dj95qhh6PSC5LKb84S7x8P9LVYI9a92sr9hOUVph5WrDwdLU
        ZZ9osFJFgaPofJBD4bzc/bf3Gyw1O2ai4v7nCV/N27RflvEO767uu6YYbCcg3aU/f46G6tSj
        U6My16tnnTBYq7FOay3fszq/htB5ux6ZNczb36uvoPCsqu3Vc93in1K/lFiKMxINtZiLihMB
        LVStWXUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSvO5tJd9Eg8cTlCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvTsdLY4PWERk8WT9bOYLRbd2MZksfHtDyaLm1uOsljM
        OL+PyaL7+g42i+XH/zFZ/N+zg91BwOPyFW+PWQ29bB6X+3qZPDav0PJYvOclk8emVZ1sHhMW
        HWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAnissmJTUnsyy1SN8ugSvjzJubLAU9rBU9
        uy+wNTBOZuliZOeQEDCRWJzRxcjFISSwm1FixalbbF2MnEBhWYln73awQ9jCEvdbjrBCFD1j
        lDj6aAUTSIJNQF/iZcc2VhBbREBVomnWAxaQImaBeawSu5bthurYzyRx7MUesA5OASOJiXuu
        M3cxcnAIC4RLNCxkAQmzADU/apsBNohXwFJi18e5zBC2oMTJmU9YQMqZBfQk2jYygoSZBeQl
        tr+dwwxxnILEz6fLoG4Ik7jx8DNUjYjE7M425gmMwrOQTJqFMGkWkkmzkHQsYGRZxSiZWlCc
        m55bbFhgmJdarlecmFtcmpeul5yfu4kRHONamjsYt6/6oHeIkYmD8RCjBAezkgjv5xteiUK8
        KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwrdjMsv5te/BP
        pkv62U/5XmzhrtPu4jjy2rLncmf0RvM7u5RnNrt+PjA9vWSdkgYf9+5tMU45/k4GZZ13GtZN
        Kvu3h6+OKfj2poqcXTEz1vTcFH/8buWS/c45oXui1t9WXfCQuyR8uh5zWKPUA3mrO3tXps0M
        aHv2YG2LcnK4iETUJdmtUj+0rKwbDYVkPXMPmv9wiXWwcfn027Ujc+X0iYwbOJvzl2s0rzVo
        ElncvN9zZ/+y7iOCzrua1l4+sLBz9oclV/d0J3y8KfT0hiXPEf6b1irbLy3qttFTv8ZVsIzD
        5o1l67I+Ttf5zW/zS4xeqHk/5Iz5v6nwxH8L9vDIz6YB4knXtrgfaZor98lNiaU4I9FQi7mo
        OBEATbeoH2ADAAA=
X-CMS-MailID: 20210924005907epcas2p229e29158756790fc41eaf7b603bb9f4b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p477a63b06cbb9f5588aa2c149c9d1db10@epcas2p4.samsung.com>
        <20210917065436.145629-7-chanho61.park@samsung.com>
        <YUuKJj7+wmJd7DSe@robh.at.kernel.org>
        <000701d7b013$8237ef50$86a7cdf0$@samsung.com>
        <YUxyZKRDYXtTUZGJ@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > This patch is a nop... Fold it into the patch using sysreg.
> >
> > I separated them to be reviewed easily by different maintainers. I'll
> > squash them on next patchset.
> 
> Patch 14 is what this should be merged with. How is that a different
> maintainer?

Ah, Okay. I got your point. I'd like to split them for getting some reviews
from previous ufs-exynos driver owner before adding exynosautov9 ufs driver.

0006-scsi-ufs-ufs-exynos-get-sysreg-regmap-for-io-coheren.patch
0014-scsi-ufs-ufs-exynos-support-exynosauto-v9-ufs-driver.patch

I think both patches can be squashed as you suggested.

Best Regards,
Chanho Park

