Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54120C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EBDA610FB
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239812AbhINGAb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 02:00:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37986 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239639AbhINGAa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 02:00:30 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210914055911epoutp0499a69f29ed2307e5a7fe60bad800d482~kmsipJZGa1334813348epoutp04T
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 05:59:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210914055911epoutp0499a69f29ed2307e5a7fe60bad800d482~kmsipJZGa1334813348epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631599151;
        bh=CqEjZQuCMDS2ROC6JzgcbDJfIGS65t1ChHRfPgvFvKc=;
        h=From:To:Subject:Date:References:From;
        b=Sf0XoCMvj68P1X4iAB63uipngeiJ1dUlSC/Mk0qDtGyQdtHWivy+6zn79r0++G7/y
         62TgxObV+ajYyva6fD4LqfJVOaVHtu9Jw/34/zBFwqpUp0kbw3RcduEj/Z12ua2lYh
         Mj+yRsiQyel21Vp+LGsuEfCConwTctD0quHgW5DA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210914055911epcas2p4f9b533a8d8e96b87be234f9b68aa0511~kmsiEDQg21315213152epcas2p4D;
        Tue, 14 Sep 2021 05:59:11 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4H7t2h6hkRz4x9QQ; Tue, 14 Sep
        2021 05:59:08 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        0C.EC.09749.C2A30416; Tue, 14 Sep 2021 14:59:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210914055907epcas2p1c9d5d91c61592a67b9ce4b2a88d8f279~kmsebsi_E2282322823epcas2p1k;
        Tue, 14 Sep 2021 05:59:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210914055907epsmtrp2a5d75cc40f149affcc2554268d5e420a~kmseax96f2427024270epsmtrp2N;
        Tue, 14 Sep 2021 05:59:07 +0000 (GMT)
X-AuditID: b6c32a47-d29ff70000002615-c8-61403a2c96d4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        13.91.09091.A2A30416; Tue, 14 Sep 2021 14:59:06 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210914055906epsmtip2f4f257ce1dad645652694be6a76463f3~kmseKnXpt2534925349epsmtip2X;
        Tue, 14 Sep 2021 05:59:06 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>,
        <adrian.hunter@intel.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
Subject: Question about ufs_bsg
Date:   Tue, 14 Sep 2021 14:59:06 +0900
Message-ID: <000001d7a92d$a0edcb00$e2c96100$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdepKfDft4+mL617SwWrELRDClUMdw==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmua6OlUOiwYPlLBYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLy7vmsFl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63G5r5fJY/Gel0weExYdYPT4vr6DzePj01ssHn1bVjF6fN4k59F+oJspgCMqxyYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GYlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhYYFecWJucWleul5yfq6VoYGBkSlQZUJOxqce
        4YIVnBUX3hxmaWBczd7FyMkhIWAicWvdbsYuRi4OIYEdjBIzJ5xlh3A+MUpMbDrMBOF8Y5R4
        2XsKruXNwZksILaQwF5GiR8vbSCKXjBKHFyxmQkkwSagLTHt4W5WkISIwA0miU33t4MlhAXk
        JS6v2sAGYrMIqEpc+XcCLM4rYClxcM0zNghbUOLkzCdgG5iBBi1b+JoZYrOCxM+ny1hBbBEB
        PYmJD34yQtSISMzubIOqWcshMX2hHoTtInHy9hImCFtY4tXxLVAfSEl8freXDcKul9g3tQHs
        UAmBHkaJp/v+MUIkjCVmPWsHsjmAFmhKrN+lD2JKCChLHLkFdRqfRMfhv+wQYV6JjjYhiEZl
        iV+TJkMNkZSYefMO1FYPifXXjrJCwi1WYsOxXcwTGBVmIXl4FpKHZyF5bBbCDQsYWVYxiqUW
        FOempxYbFRgjx/UmRnBy1nLfwTjj7Qe9Q4xMHIyHGCU4mJVEeLe9sU0U4k1JrKxKLcqPLyrN
        SS0+xGgKjIKJzFKiyfnA/JBXEm9oamRmZmBpamFqZmShJM57/rVlopBAemJJanZqakFqEUwf
        EwenVAMTs87lwN8Pm7e9etQvdu19z798O5/gQ09mbmRnaVhjobOCo/fhknWqc/1ZN07oPnzg
        k9VzqQ1n5ixPe6SWXBldtTp4ae7KwobbB1y2CK7ffCPyuqjDpmfLuP6xHXvafb4sSb3/v6NK
        YkXuBtnP3J+tPrTu4/ZUfWka61iQENIdl7RKYHNeu1GuQ/a/++WJu7KkohZtUnUQ3eP35nYD
        a9Xz7Se2Ky4/O2Nm3fZrr1NlXDxc+RuEDPSaJnnsyvbsnqddf87wzMr1Sr82ruX49XN5mbn6
        C++eVbzn+7gFf2dG/OTPsjkxSb9w/iqVLs9oR4EbXHrLjm3+e4N9eeJhUY7qyl9r7RiO3te8
        pHP5W1CvEktxRqKhFnNRcSIAWApvaFcEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42LZdlhJXlfLyiHRYPdaG4uTT9awWTyYt43N
        4uXPq2wWBx92slh8XfqM1eLT+mWsFqsXP2CxWHRjG5PF5V1z2Cy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bjc18vksXjPSyaPCYsOMHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBHFZZOS
        mpNZllqkb5fAldG2dTtTwQrOir0nvjI3MK5m72Lk5JAQMJF4c3AmSxcjF4eQwG5Gif4Fx5gg
        EpISJ3Y+Z4SwhSXutxxhhSh6xiixdPcBsG42AW2JaQ93gyVEBF4wSfzbv5kNJCEsIC9xedUG
        MJtFQFXiyr8TYFN5BSwlDq55xgZhC0qcnPmEBcRmBhr09OZTOHvZwtfMEJsVJH4+XcYKYosI
        6ElMfPCTEaJGRGJ2ZxvzBEaBWUhGzUIyahaSUbOQtCxgZFnFKJlaUJybnltsWGCYl1quV5yY
        W1yal66XnJ+7iREcY1qaOxi3r/qgd4iRiYPxEKMEB7OSCO+2N7aJQrwpiZVVqUX58UWlOanF
        hxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTBl2Jw99KyH3+vDC3amkqteL3acbL41
        v+v5r7ddc7UOrlmSsj4x0j5S1VLb0NziuE6W51Oz4wlVp1f/bfErvviq8l7KHNW5aZyHvCff
        qnZc0ZxnLbtk8Zb7abdOWPD/bTsiwX7sieWCFLnNX783NRSrbuypXLrE6KPJkr0i5ZeKXqpc
        mV54PfVm0pFzJ+wzfr6L+3mrYv23idc0TkxiVb47ZbtYcI/ARuF/h+ozXC26Nvz9FxC7Z820
        z/EBvrERbWzxOyYHBbNpXfxhznM5JfO9UPxZy+une8J3266bynrMvSpqVtzhtSECGdEzZifk
        eomGVd1c0st4lGGhquCZjvrUU6s0cm6mTm1a+vrAgWc/lFiKMxINtZiLihMBDEm58yADAAA=
X-CMS-MailID: 20210914055907epcas2p1c9d5d91c61592a67b9ce4b2a88d8f279
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210914055907epcas2p1c9d5d91c61592a67b9ce4b2a88d8f279
References: <CGME20210914055907epcas2p1c9d5d91c61592a67b9ce4b2a88d8f279@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

ufs_bsg was introduced nearly three years ago and it allocates its own requ=
est queue.
I faced a sytmpom with this and want to ask something about it.

That is, sometimes queue depth for ufs is limited to half of the its maximu=
m value
even in a situation with many IO requests from filesystem.
It turned out that it only occurs when a query is being processed at the sa=
me time.
Regarding my tracing, when the query process starts, users for the hctx tha=
t represents
a ufs host increase to two and with this, some pathes calling 'hctx_may_que=
ue'
function in blk-mq seems to throttle dispatches, technically with 16 becaus=
e the number of
ufs slots (32 in my case) is dividend by two (users).

I found that it happened when a query for write booster is processed
because write booster only turns on in some conditions in my base that is d=
ifferent
from kernel mainline. But when an exceptional event or others that could le=
ad to a query occurs,
it can happen even in mainline.

I think the throttling is a little bit excessive,
so the question: is there any way to assign queue depth per user on an asym=
metric basis?

Thanks.
Kiwoong Kim


