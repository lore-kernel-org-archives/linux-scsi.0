Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E60D6C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 02:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A69DF20768
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 02:28:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KiKDqaZO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbgFWC2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 22:28:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14372 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730456AbgFWC2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2020 22:28:15 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200623022812epoutp034cbd4c9161cfdd30db4695b78ccdfa0d~bC0bXc8pb0796507965epoutp03N
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 02:28:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200623022812epoutp034cbd4c9161cfdd30db4695b78ccdfa0d~bC0bXc8pb0796507965epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592879292;
        bh=4TH4yJk+8xa+LtLSheQ9FiqYorylgA0q0MRYPRy/ACU=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=KiKDqaZO+L74/do2LYSLDNkLfcVfvuRJfjKnrtAa0O7Z4S0qMMdO7NFL9OyVmcu6K
         byRNc7WOS6GqmFdYq8Cgw9GI149okd7z3nQ/d09qMcrd3CCe9rP0rp2Ke44KOEV+ki
         zRUYhxFI/YSem6eEhbDFLtuvnrQH38wySQ6JQru0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200623022811epcas2p214eab636b6743fe8ad51568c088d61f6~bC0a7Da2M0212802128epcas2p2W;
        Tue, 23 Jun 2020 02:28:11 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.181]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 49rVZ16HshzMqYkc; Tue, 23 Jun
        2020 02:28:09 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.99.27441.7B861FE5; Tue, 23 Jun 2020 11:28:07 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200623022807epcas2p1760bcf3ab73c5fa5b875e1e6f4d25fdf~bC0W8mQe70672306723epcas2p1E;
        Tue, 23 Jun 2020 02:28:07 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200623022807epsmtrp1873f927256144881f9cbcaf957fd42fa~bC0W75ru41077010770epsmtrp1G;
        Tue, 23 Jun 2020 02:28:07 +0000 (GMT)
X-AuditID: b6c32a47-fc5ff70000006b31-bd-5ef168b7f296
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        85.92.08303.7B861FE5; Tue, 23 Jun 2020 11:28:07 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200623022807epsmtip1f21744f0acbd539f2d74dd88210b96f6~bC0WqCG8d1801118011epsmtip1h;
        Tue, 23 Jun 2020 02:28:07 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        "'Christoph Hellwig'" <hch@lst.de>
In-Reply-To: <992d1812-98b9-99b5-acc0-69c7aba3d074@acm.org>
Subject: RE: [RFC PATCH v1 1/2] ufs: introduce callbacks to get command
 information
Date:   Tue, 23 Jun 2020 11:28:06 +0900
Message-ID: <003201d64905$ee05a5e0$ca10f1a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQL8/V917mWvtxF9jWsyhmCCDxjM/gJ/aiFPAZXtAI+md2NA4A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNJsWRmVeSWpSXmKPExsWy7bCmqe72jI9xBscea1g8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWqxcfZTJYtGNbUwW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD02H2zgc3j+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAM6oHJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoEOVFMoSc0qBQgGJxcVK+nY2Rfml
        JakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GX2L9jAWbOaoOP7zPUsD
        43m2LkZODgkBE4ndrZdZuxi5OIQEdjBKHNoxhRnC+cQoMeHzGyYI5zOjxK+G9UAZDrCWkw/F
        IOK7gDomfGeDcF4wSlw90AU2l01AW2Law91gc0UEljBJHJ5xEyzBKWAtcerlNBYQW1ggVOLB
        ryPMIDaLgKrE+Q3H2UFsXgFLiVMXb0PZghInZz4Bq2cGGrps4WtmiMMVJH4+XcYKYosIOEk8
        OHWdEaJGRGJ2ZxvYDxICOzgkbt44yQTR4CIx/dY+qGZhiVfHt7BD2FISL/vboOx6iX1TG1gh
        mnsYJZ7u+8cIkTCWmPWsnRHkf2YBTYn1u/QhQaEsceQW1G18Eh2H/7JDhHklOtqEIBqVJX5N
        mgw1RFJi5s07UJs8JPZ+aGCcwKg4C8mXs5B8OQvJN7MQ9i5gZFnFKJZaUJybnlpsVGCMHNub
        GMGpWMt9B+OMtx/0DjEycTAeYpTgYFYS4X0d8C5OiDclsbIqtSg/vqg0J7X4EKMpMNwnMkuJ
        JucDs0FeSbyhqZGZmYGlqYWpmZGFkjhvsdWFOCGB9MSS1OzU1ILUIpg+Jg5OqQYm5R3WgqsF
        u0vd1GyY3080dVNkPsImmhD/zC+zKPOo1OuQzWomC4KSb7N++n/y79zvJ/ZVtEV6Pma52z/Z
        f779KvvHM0SWJV99cOH9qSuLVXes9Io6UKX6vOL4+lP16xR/9IfxCrsxic9g1zTmU3DzP3Et
        sicxoGl71jrvjLDDIdu1dIPLZ1qf857399jqmChXbw32PVqXdrknvzih1tF7++3l5f131X+s
        j5vEvvV61pqZvet8sxb/Um+f8UD04mOpWPnS7edyS773sH57Zx2jvf6T8AnT15OFJx1KW++x
        febfosOvhUU5uSdm7GLJ3zBd59yX7zHPzy96Gelks7imak/4woCaSxs7Lh6//eHcRyWW4oxE
        Qy3mouJEAGelC6dOBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWy7bCSnO72jI9xBpNn8Vo8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWqxcfZTJYtGNbUwW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD02H2zgc3j+/oONo+PT2+xePRtWcXo8XmTnEf7gW6mAM4oLpuU1JzMstQifbsErowV
        B98zFWzjqOjc/outgfECWxcjB4eEgInEyYdiXYxcHEICOxgleqeuAIpzAsUlJU7sfM4IYQtL
        3G85wgpR9IxRomPSNhaQBJuAtsS0h7vBEiIC65gkNnw8ywhRdYxR4vndu+wgVZwC1hKnXk4D
        6xAWCJZ48OMcWJxFQFXi/IbjYDavgKXEqYu3oWxBiZMzn4DVMwNt6H3YyghjL1v4mhniJAWJ
        n0+XsYLYIgJOEg9OXYeqEZGY3dnGPIFRaBaSUbOQjJqFZNQsJC0LGFlWMUqmFhTnpucWGxYY
        5aWW6xUn5haX5qXrJefnbmIER5+W1g7GPas+6B1iZOJgPMQowcGsJML7OuBdnBBvSmJlVWpR
        fnxRaU5q8SFGaQ4WJXHer7MWxgkJpCeWpGanphakFsFkmTg4pRqYUsvOKs6rvmMcrVoS8U8k
        mJ3pt94bnQt8xkuu//la8n/WjctH/IQ65jsfYpHZGnNzz2P2/31ylvHntScnVXjZPq2JsJ3j
        PX3Vu40PLjJnf7d1uRm7VcVI66zg9lzbrT9SlO+fMnrfu71dZO5pjbtigvvjkze96PFzl16b
        XWzxd0lzCcO8+9naHq5nZl63mJe8TKfKRI+9XfGbYTbPj5eb77DVledG79U8z29Sun2JlrX6
        h93VTxqfJT5wEd24K9f5nfuKc1mxz69v/lB8//K9bens1kuaZVrfZKyW4vHkPST4UWd14fGA
        hTP+9WuWxCo+EFy9eVOdzVo3rUnbJtz7fDDS4FJomcS2hxe54je8VmIpzkg01GIuKk4EAHY3
        emUtAwAA
X-CMS-MailID: 20200623022807epcas2p1760bcf3ab73c5fa5b875e1e6f4d25fdf
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30
References: <CGME20200620070044epcas2p269e3c266c86c65dd0e894d8188036a30@epcas2p2.samsung.com>
        <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
        <992d1812-98b9-99b5-acc0-69c7aba3d074@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2020-06-19 23:53, Kiwoong Kim wrote:
> > Some SoC specific might need command history for various reasons, such
> > as stacking command contexts in system memory to check for debugging
> > in the future or scaling some DVFS knobs to boost IO throughput.
> >
> > What you would do with the information could be variant per SoC
> > vendor.
>=20
> Isn't this something that should be done in an I/O scheduler instead of i=
n
> a SCSI LLD? I don't like the idea behind this patch series at all.
>=20
> Bart.

If you could get the information, Many would exploit it for their respectiv=
e purposes.
But, it's important for the information to contain accurate timestamps when=
 the driver
hooks it, if you're trying to figure out something wrong.

As for scaling DVFS knobs to boost UFS throughput, locating in the ufs driv=
er is more
Beneficial because SoC vendors have their own power domains and thus lead t=
o make
different way of what to scale up to boost. If it's populated in block laye=
r, there is
no way to introduce boosting per SoC.

