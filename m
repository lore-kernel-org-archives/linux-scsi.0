Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3F37C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 02:17:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C574523A62
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 02:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732068AbgLRCRF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 21:17:05 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37513 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732043AbgLRCRD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 21:17:03 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201218021620epoutp03b3642863da7007b5b2ce7812e415d4ea~Rre4VIyEA3124131241epoutp03q
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2020 02:16:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201218021620epoutp03b3642863da7007b5b2ce7812e415d4ea~Rre4VIyEA3124131241epoutp03q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608257780;
        bh=ZNJ9AwwFRLryVdoqqow17j0pDYph2wLXbS+jhL3E9js=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=ggNhYlUOXA7jlWds5P27LDKIhz3UXWkx7HZ19zTIavtE01mu0HxD7sR5T8msWQGS4
         8xbnaPnROPGM5e/lebkdECzea82swkBg1VwI6J7dW5+CPbVAds8CHks/L3/kGYVrrn
         FQA8NnUNWTGhLdVr7TIWHsIlh9ci9N7HKBO+LQtI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201218021618epcas2p2406b042bab11e41f5b18d97dc02fa3be~Rre3WKZay1104111041epcas2p2Q;
        Fri, 18 Dec 2020 02:16:18 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.188]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Cxst81y9hz4x9QH; Fri, 18 Dec
        2020 02:16:16 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-57-5fdc10ee84e5
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1E.78.56312.EE01CDF5; Fri, 18 Dec 2020 11:16:14 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v14 0/3] scsi: ufs: Add Host Performance Booster
 Support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <e8b08117-0670-7222-05bb-a88910a93be1@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201218021613epcms2p7ef4b3b095f9be9e7e1f8c74e1dc6af44@epcms2p7>
Date:   Fri, 18 Dec 2020 11:16:13 +0900
X-CMS-MailID: 20201218021613epcms2p7ef4b3b095f9be9e7e1f8c74e1dc6af44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmhe47gTvxBk9Pc1psvPuK1eLBvG1s
        FnvbTrBbvPx5lc3i8O137BbTPvxktvi0fhmrxctDmharHoRbNC9ez2Yx52wDk0Vv/1Y2i0U3
        tjFZXN41h82i+/oONovlx/8xWdzewmWxdOtNRovO6WtYLBYt3M3iIOJx+Yq3x+W+XiaPnbPu
        sntMWHSA0WP/3DXsHi0n97N4fHx6i8Wjb8sqRo/Pm+Q82g90MwVwReXYZKQmpqQWKaTmJeen
        ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gA9p6RQlphTChQKSCwuVtK3synK
        Ly1JVcjILy6xVUotSMkpMDQs0CtOzC0uzUvXS87PtTI0MDAyBapMyMlonnKXveAUW8W2Z3fZ
        GhifsnQxcnJICJhIzDrXydTFyMUhJLCDUWJD7x22LkYODl4BQYm/O4RBTGGBIIlnB/1AyoUE
        lCTWX5zFDmILC+hJ3Hq4hhHEZhPQkZh+4j5YXESgQmL2vw3sICOZBf6zSvzb8pYVYhevxIx2
        mL3SEtuXbwVr5hSwlrhzajYbRFxD4seyXmYIW1Ti5uq37DD2+2PzGSFsEYnWe2ehagQlHvzc
        DRWXlDi2+wMThF0vsfXOL0aQIyQEehglDu+8BXWEvsS1jo1gR/AK+ErsP78IbDGLgKrE0nf3
        oJpdJJZubgazmQXkJba/ncMMCghmAU2J9bv0QUwJAWWJI7dYYN5q2PibHZ3NLMAn0XH4L1x8
        x7wnUNPVJNb9XM80gVF5FiKgZyHZNQth1wJG5lWMYqkFxbnpqcVGBUbIcbuJEZzOtdx2ME55
        +0HvECMTB+MhRgkOZiUR3tAHt+OFeFMSK6tSi/Lji0pzUosPMZoCfTmRWUo0OR+YUfJK4g1N
        jczMDCxNLUzNjCyUxHlDV/bFCwmkJ5akZqemFqQWwfQxcXBKNTCd+TpnotUr1egToie+Pz3F
        z9dXuSt+c7X88/yfhv8brkprP2W9pN/mPNVJg33iIfNjqmIP5u8WW+T+/2VE6pqwlqqqKL8+
        W64H6z+oHpt19ti6tiqZNKY4ubLsWbvfrW9eLd2/cfeL6c3Gl1wK5armXD+koCLk4L/ikcuC
        Dc4TvCcbcxiVbjL3/SEqnLxIiJUxedo1TUHTaM6UP0+OlbMbPT/sNVV43cnEHsddCt2HZtQl
        ilds3bIze6G+9+uC67M/Ltj3IvZbpKfWS5HNNoksDjtWSD9bfk9fovPVBalq2wmS5m9mb0m5
        z1/5Mcfv4nVtgSn7lzWUnlUKUIja0/DA4cMS5qk57dZ7Nhrc2TJLiaU4I9FQi7moOBEAngR5
        kXAEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306
References: <e8b08117-0670-7222-05bb-a88910a93be1@acm.org>
        <X9ncUJH/vHO7Luqi@kroah.com>
        <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
        <20201218010520epcms2p1f7994bde414008ea1f44c733350308db@epcms2p1>
        <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/17/20 5:05 PM, Daejun Park wrote:
> > Here is my iozone script:
> > iozone -r 4k -+n -i2 -ecI -t 16 -l 16 -u 16 
> > -s $IO_RANGE/16 -F mnt/tmp_1 mnt/tmp_2 mnt/tmp_3 mnt/tmp_4 
> > mnt/tmp_5 mnt/tmp_6 mnt/tmp_7 mnt/tmp_8 mnt/tmp_9 mnt/tmp_10 mnt/tmp_11 
> > mnt/tmp_12 mnt/tmp_13 mnt/tmp_14 mnt/tmp_15 mnt/tmp_16
> > 
> > Result:
> > +----------+--------+---------+
> > | IO range | HPB on | HPB off |
> > +----------+--------+---------+
> > |   1 GB   | 294.8  | 300.87  |
> > |   4 GB   | 293.51 | 179.35  |
> > |   8 GB   | 294.85 | 162.52  |
> > |  16 GB   | 293.45 | 156.26  |
> > |  32 GB   | 277.4  | 153.25  |
> > +----------+--------+---------+
> 
> Hi Daejun,
> 
> What are the units of the numbers in columns 2 and 3?
> 
> Thanks,
> 
> Bart.
> 
I forgot to add units, it is MB/s.

Thanks
Daejun
