Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D296C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F22861163
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbhINGqw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 02:46:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64510 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240084AbhINGqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 02:46:49 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210914064530epoutp03687d85480c54bf0011daed52dc8acedd~knU_4Ezag0251302513epoutp03r
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 06:45:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210914064530epoutp03687d85480c54bf0011daed52dc8acedd~knU_4Ezag0251302513epoutp03r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1631601930;
        bh=CbwcZMcTVmj8jrpPGRhezAlsckWIYSoPdTZFhcohHEc=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=j9XwXdbnihJphRi8njnDKrByu3OtZB7fTKs6aqX2TSE/XOA54kvm1dIHaIR5RgLV0
         WlFpPcFfJ2tp7eANJsAlVaMo++yaYHLf7DYB2UDCM7wffxRmCMesLeodLBLoMRXyIl
         2Fz+qsCRRSEYmzl5/vg/C8kX5FI8ODQjayUtvKk4=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210914064525epcas2p286c5f9f5e13a08f1d7deb32f14495bf5~knU5jA2im2795327953epcas2p2Y;
        Tue, 14 Sep 2021 06:45:25 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4H7v42715Sz4x9QM; Tue, 14 Sep
        2021 06:45:22 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        BD.3F.09717.20540416; Tue, 14 Sep 2021 15:45:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210914064518epcas2p43f72c99734d820940859f0a9912bbf51~knUzO21fh3015130151epcas2p4j;
        Tue, 14 Sep 2021 06:45:18 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210914064518epsmtrp16ace9b8668e07858bee8a4e99475646d~knUzLyobA1125611256epsmtrp1x;
        Tue, 14 Sep 2021 06:45:18 +0000 (GMT)
X-AuditID: b6c32a45-4abff700000025f5-1f-6140450275ea
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        86.37.09091.DF440416; Tue, 14 Sep 2021 15:45:18 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210914064517epsmtip15c927e09fc8ae1050b5d940bc1eeb020~knUy7fiW31486914869epsmtip1W;
        Tue, 14 Sep 2021 06:45:17 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <adrian.hunter@intel.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>, <bhoon95.kim@samsung.com>
In-Reply-To: <DM6PR04MB657564DA7CCE9220453DD6F8FCDA9@DM6PR04MB6575.namprd04.prod.outlook.com>
Subject: RE: Question about ufs_bsg
Date:   Tue, 14 Sep 2021 15:45:17 +0900
Message-ID: <000401d7a934$149c9a80$3dd5cf80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIofGn0UG3+CckosuV0xfSpT90zewKkECLHAf2dX0Kq3GDZAA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJsWRmVeSWpSXmKPExsWy7bCmuS6Tq0OiwcdtZhYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8Wn9ctYLVYvfsBisejGNiaLy7vmsFl0X9/BZrH8+D8mi667Nxgt
        lv57y+LA63G5r5fJY/Gel0weExYdYPT4vr6DzePj01ssHn1bVjF6fN4k59F+oJspgCMqxyYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GYlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhYYFecWJucWleul5yfq6VoYGBkSlQZUJOxovz
        axkL/vNX/L5/hK2BcRNPFyMnh4SAicSct29Yuxi5OIQEdjBK/J64hQXC+cQo8XPRamaQKiGB
        b4wS0384w3TMeDaHEaJoL6PEy6troZwXjBIbbhxgA6liE9CWmPZwN9hcEYEXTBJH9q8FG8Up
        ECtx/9w9sCJhAWWJptbZLCA2i4CqxMOJfUA2BwevgKXE9GviIGFeAUGJkzOfgJUwA81ctvA1
        M8QVChI/ny5jBbFFBJwkjl+axwRRIyIxu7ONGWSvhMAZDokle66wQTS4SKy48JQRwhaWeHV8
        CzuELSXxsr8Nyq6X2De1gRWiuYdR4um+f1ANxhKznrUzghzHLKApsX6XPogpAXT/kVtQt/FJ
        dBz+yw4R5pXoaBOCaFSW+DVpMtQQSYmZN+9AbfKQWH/tKOsERsVZSL6cheTLWUi+mYWwdwEj
        yypGsdSC4tz01GKjAkPkyN7ECE7PWq47GCe//aB3iJGJg/EQowQHs5II77Y3tolCvCmJlVWp
        RfnxRaU5qcWHGE2BwT6RWUo0OR+YIfJK4g1NjczMDCxNLUzNjCyUxHnPv7ZMFBJITyxJzU5N
        LUgtgulj4uCUamCqDH6t7n5bLyf/YVReeLritNknXYqt2y6cD5hz/ZSmpcYDBcYq24Uvp9gL
        Mj+YuqZ36zv10kebXgZMbduhtrFed53Z++yVXWHOF+zkn7ht/fPmaQtP+SaGZdzzC91cuXdx
        z9151i2L646FyI1UlToXnaePVodqbjIRW84bKThNRfJa2PMTNtsvt8WJHrv6NIlZ8P+9hm+J
        zfkVElqhAXFv/2264SNt7bzGQKb6tD/bDWb2lwWn/hkeqQwsPzuDS6DTPe/F+xmz6pSFTs4I
        iEpYmv3dI54j37BR1GbmW9tzK5/yxMyd4/nGhFdE64Won3W8aJLl44l66Rs874onp8xaIVQc
        GpXe+sJPTXhGmBJLcUaioRZzUXEiAE9w9I9YBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSnO4/F4dEg/u/mCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotP65exWqxe/IDFYtGNbUwWl3fNYbPovr6DzWL58X9MFl13bzBa
        LP33lsWB1+NyXy+Tx+I9L5k8Jiw6wOjxfX0Hm8fHp7dYPPq2rGL0+LxJzqP9QDdTAEcUl01K
        ak5mWWqRvl0CV8aJuQdYC/oEKnbP825g3M7TxcjJISFgIjHj2RzGLkYuDiGB3YwS1y7PYodI
        SEqc2PmcEcIWlrjfcoQVougZo8ScJw1MIAk2AW2JaQ93gyVEBH4wSfy5/JgdouoOo0T3n+lg
        ozgFYiXun7vHBmILCyhLNLXOZgGxWQRUJR5O7AOyOTh4BSwlpl8TBwnzCghKnJz5BKyEGWjB
        05tP4exlC18zQ1ykIPHz6TJWEFtEwEni+KV5TBA1IhKzO9uYJzAKzUIyahaSUbOQjJqFpGUB
        I8sqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS95PzcTYzgiNTS3MG4fdUHvUOMTByMhxglOJiV
        RHi3vbFNFOJNSaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoFp
        Zv7xhU7+5a/e3RbaVrzA+MGOwt4NxxZzRZx/W5DaxZwVuOd2TMjJE/N98s0U5u5e9/Rdd2qW
        9LJFrNP/GygJikzpvnJ9h6xJTIGX/L99BtvjWw6Knbg/uU66iiHbMEJh1Wcdu++GvjXujoEl
        zZtSXlSL/9q03lxg5/Vljz1tJn/XePtW4OTyTy2lc/LSdJ1t5VgcYreJCax4aHe40/B7rWG4
        Rd26d2dXJD96JCkbtMVq9crQGI3W1RMUxVaUfZgWuzrjnU3RidLqp+5velZJOvOm5MmIR92+
        djNYb9mDXQnH/s2XqMk76dGT4jN944sVBkaFodIRnw79fXNhwkeLjh69yYd8EuWZJdZoJ5cq
        sRRnJBpqMRcVJwIAiW3QrTcDAAA=
X-CMS-MailID: 20210914064518epcas2p43f72c99734d820940859f0a9912bbf51
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210914055907epcas2p1c9d5d91c61592a67b9ce4b2a88d8f279
References: <CGME20210914055907epcas2p1c9d5d91c61592a67b9ce4b2a88d8f279@epcas2p1.samsung.com>
        <000001d7a92d$a0edcb00$e2c96100$@samsung.com>
        <DM6PR04MB657564DA7CCE9220453DD6F8FCDA9@DM6PR04MB6575.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi,
>=20
> > Hi,
> >
> > ufs_bsg was introduced nearly three years ago and it allocates its own
> > request queue.
> > I faced a sytmpom with this and want to ask something about it.
> >
> > That is, sometimes queue depth for ufs is limited to half of the its
> > maximum value even in a situation with many IO requests from
> > filesystem.
> This is interesting indeed. Before going further with investigating this,

Hi. What I first intended is not ufs_bsg but as you might already know, it =
also allocated its own request queue.
In that point, we can imagine it could be the same situation.

> Could you share some more details on your setup:
> The bsg node it creates was originally meant to convey a single query
> request via SG_IO ioctl, Which is blocking.
>  - How do you create many IO requests queueing on that request queue?

I used some benchmarks, such tiobench or Androbench that could make heavy I=
O scenarios.

>  - command upiu is not implemented, are all those IOs are query requests?

What I've seen is just one query and many scsi commands.

>=20
> > It turned out that it only occurs when a query is being processed at
> > the same time.
> > Regarding my tracing, when the query process starts, users for the
> > hctx that represents a ufs host increase to two and with this, some
> > pathes calling 'hctx_may_queue'
> > function in blk-mq seems to throttle dispatches, technically with 16
> > because the number of ufs slots (32 in my case) is dividend by two
> > (users).
> >
> > I found that it happened when a query for write booster is processed
> > because write booster only turns on in some conditions in my base that
> > is different from kernel mainline. But when an exceptional event or
> > others that could lead to a query occurs, it can happen even in
> > mainline.
> >
> > I think the throttling is a little bit excessive, so the question: is
> > there any way to assign queue depth per user on an asymmetric basis?
> >
> > Thanks.
> > Kiwoong Kim
> >


