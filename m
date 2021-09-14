Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469CDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 211CD60EB4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239906AbhINGJ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 02:09:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24377 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238933AbhINGJ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 02:09:58 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210914060840epoutp0130f301356235c4f0a527a557dd938634~km00YUzcz2613726137epoutp01l
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 06:08:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210914060840epoutp0130f301356235c4f0a527a557dd938634~km00YUzcz2613726137epoutp01l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631599720;
        bh=7HKgUm7WMxPZ/t67vTqPyxBbY0pEkTgltgJ8txP3BQA=;
        h=From:To:Subject:Date:References:From;
        b=RU6Xpq7a2PmfY71J1+kvmX/G2xRYbcxEFaA3AmBxrfDMmT1g1gkxc7WYldKr/cedi
         YSeOWKy4wmxWaER8rT/SKR2VMvvXhXS0f52j/Y27P1o21YXhl4OpliR6KOcDPimA8v
         2UcCDm6pc9KxFYjbADlg15jjS3TPhLDn4MnylIzE=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210914060839epcas2p1856e888549d455eeb03c65bebbc13e3d~km0zrXnok2725727257epcas2p1Y;
        Tue, 14 Sep 2021 06:08:39 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.184]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4H7tFd45tQz4x9QJ; Tue, 14 Sep
        2021 06:08:37 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6F.CC.09816.56C30416; Tue, 14 Sep 2021 15:08:37 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210914060836epcas2p2cf299639dba0abd11cdbe75534c9b9c9~km0w3uDyi0380003800epcas2p2_;
        Tue, 14 Sep 2021 06:08:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210914060836epsmtrp27137643bb1c5b6757abb35d685b574bc~km0w21RwA3046330463epsmtrp21;
        Tue, 14 Sep 2021 06:08:36 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-78-61403c65226b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.F2.09091.46C30416; Tue, 14 Sep 2021 15:08:36 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210914060836epsmtip13033c22826d2f98158046d24111d1760~km0wnOjN92267122671epsmtip11;
        Tue, 14 Sep 2021 06:08:36 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>,
        <adrian.hunter@intel.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
Subject: Question about cmd_queue
Date:   Tue, 14 Sep 2021 15:08:36 +0900
Message-ID: <000001d7a92e$f4688800$dd399800$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdepLrlIqY/QqB7AQZSxee8N2kqb0Q==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJsWRmVeSWpSXmKPExsWy7bCmmW6qjUOiwbJHEhYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLy7vmsFl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63G5r5fJY/Gel0weExYdYPT4vr6DzePj01ssHn1bVjF6fN4k59F+oJspgCMqxyYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GYlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhYYFecWJucWleul5yfq6VoYGBkSlQZUJORtfW
        jawFp7kq1l/5yNTAuJaji5GTQ0LAROL3pu+MXYxcHEICOxglllx6zgzhfGKU2LLnLROE841R
        YubvfUwwLW/fzIVK7GWU6H/VyArhvGCU6G1+zghSxSagLTHt4W6whIjADSaJTfe3g7ULCyhK
        rF/2ggXEZhFQldg9pZsVxOYVsJRY+/o6C4QtKHFy5hMwmxlo0LKFr5khVitI/Hy6DKxeREBP
        4tKfS2wQNSISszvbwA6XEFjLIbFx+lNGiAYXiTm3+1kgbGGJV8e3sEPYUhKf3+1lg7DrJfZN
        bWCFaO5hlHi67x9Us7HErGftQDYH0AZNifW79EFMCQFliSO3oG7jk+g4/JcdIswr0dEmBNGo
        LPFr0mSoIZISM2/egdrqIbFjzWZwMAgJxErcPPqUZQKjwiwkH89C8vEsJJ/NQrhhASPLKkax
        1ILi3PTUYqMCI+To3sQITtFabjsYp7z9oHeIkYmD8RCjBAezkgjvtje2iUK8KYmVValF+fFF
        pTmpxYcYTYFxMJFZSjQ5H5gl8kriDU2NzMwMLE0tTM2MLJTEec+/tkwUEkhPLEnNTk0tSC2C
        6WPi4JRqYFKuDa91qnlw9+LTVxcF/rXrtdeWf3qzIjomZaGlS/erJ5INt+a3vea+OGH3qQQj
        sSPq9xi5ZmZbiD27EG2gcWeRk1dK89x3nt4xyz+5pxhvffF6/byij5dU+5IucJpUKKyRrZ7R
        8qHtrlJp3doDVtVHDJ6vzrx68rV/gs5Nk8Jdj75+vlNZKDuVZWb55Uwlu9Tlqnkf1bNviK08
        rM5cLuPbeJ3ZdmJM9aNfLYteNf/hmTTR7ZSR265FPrV7brsknnm3dmuY1pc5a+tTKwpzdvJr
        SgjsbFvk/NChv019/q1LmpsiJbTvcB2x/aW6+YSRT/rfNSc0l202Stg8ZUfIn5NLq35NYDP2
        3zUhrJHnlJISS3FGoqEWc1FxIgBeqChJWgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42LZdlhJTjfFxiHR4NZaRYuTT9awWTyYt43N
        4uXPq2wWBx92slh8XfqM1eLT+mWsFqsXP2CxWHRjG5PF5V1z2Cy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bjc18vksXjPSyaPCYsOMHp8X9/B5vHx6S0Wj74tqxg9Pm+S82g/0M0UwBHFZZOS
        mpNZllqkb5fAlXH27VW2gltcFZPXd7E0MG7i6GLk5JAQMJF4+2YuUxcjF4eQwG5GiT331jNC
        JCQlTux8DmULS9xvOcIKUfSMUeLE5WPsIAk2AW2JaQ93gyVEBF4wSfzbv5kNJCEsoCixftkL
        FhCbRUBVYveUblYQm1fAUmLt6+ssELagxMmZT8BsZqBBT28+hbOXLXzNDLFZQeLn02VgvSIC
        ehKX/lxig6gRkZjd2cY8gVFgFpJRs5CMmoVk1CwkLQsYWVYxSqYWFOem5xYbFhjmpZbrFSfm
        Fpfmpesl5+duYgTHmJbmDsbtqz7oHWJk4mA8xCjBwawkwrvtjW2iEG9KYmVValF+fFFpTmrx
        IUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxSDUzyNT/KQ+R+qi+wO7X/20ypvCqmv4fn
        bUv4v3X9e/YzvlVzu+onVth1B6yJsnM3bS6Vcvp25W3QkgyBRWt/m1ziMdJ3+b+qiVFw/jJu
        1/khcSemTd3+54Le0z1CX/fXRTC+OOZx/L2F4uPr818/Zv2XonvVt/xvWIDezC1zUrrPuVx4
        GCWyZIvVtWUee1bsv3H+n9/LE4Lt391N9t1IvXfg9ZYnarG2Z2cKz+w4ez+t+NgkjenXCydv
        Se1zfBgs8bs35s6Nd8HrTU9Muxhsdr87nFG3Nlnnb1bZuoDKYyvmHpCr3vL4mlDHtJNnI+/V
        Kbg0vZswrepRbYF3kNcGibU/lYQmbuvSO7foq3mJvGm1sxJLcUaioRZzUXEiAPSdduUgAwAA
X-CMS-MailID: 20210914060836epcas2p2cf299639dba0abd11cdbe75534c9b9c9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210914060836epcas2p2cf299639dba0abd11cdbe75534c9b9c9
References: <CGME20210914060836epcas2p2cf299639dba0abd11cdbe75534c9b9c9@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> ufs_bsg was introduced nearly three years ago and it allocates its own
> request queue.

This is not related with ufs_bsg. I want to talk about a member under ufs_h=
ba, cmd_queue.
Very sorry for making you confused.

> I faced a sytmpom with this and want to ask something about it.
>=20
> That is, sometimes queue depth for ufs is limited to half of the its
> maximum value even in a situation with many IO requests from filesystem.
> It turned out that it only occurs when a query is being processed at the
> same time.
> Regarding my tracing, when the query process starts, users for the hctx
> that represents a ufs host increase to two and with this, some pathes
> calling 'hctx_may_queue'
> function in blk-mq seems to throttle dispatches, technically with 16
> because the number of ufs slots (32 in my case) is dividend by two (users=
).
>=20
> I found that it happened when a query for write booster is processed
> because write booster only turns on in some conditions in my base that is
> different from kernel mainline. But when an exceptional event or others
> that could lead to a query occurs, it can happen even in mainline.
>=20
> I think the throttling is a little bit excessive, so the question: is
> there any way to assign queue depth per user on an asymmetric basis?
>=20
> Thanks.
> Kiwoong Kim


