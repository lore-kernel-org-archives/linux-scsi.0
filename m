Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9032C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 00:21:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4EF220707
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 00:21:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Zl8P0LSa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388467AbgFYAVQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 20:21:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:42014 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387843AbgFYAVP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 20:21:15 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200625002112epoutp037ae614c1c640a91405de385456a5d885~boYHm0T8H0416904169epoutp03C
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 00:21:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200625002112epoutp037ae614c1c640a91405de385456a5d885~boYHm0T8H0416904169epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593044472;
        bh=9Tvx5LVQ92yDOHnxdae1m8tcACjD0IX4pwyY2EQbYCM=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Zl8P0LSa8/v3Yqw9dIrC8x8Qlf0OzYghUAwUvSLy5fvSCwjMhNyELi2msW5ornFq7
         ezsslF4sD1miiNS7B0Fn7afWpTqTbY4rUROd7a06Qh9yyVaIR+vkAVs1Yy90KZHvlx
         vrMn1oDksuuJdhqn7lGe+G/HnbefMepw0Au33O54=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200625002111epcas5p31684db82d7f5e8246f24bbf3792aa8ae~boYHCljLa2533125331epcas5p3I;
        Thu, 25 Jun 2020 00:21:11 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.2A.09467.7FDE3FE5; Thu, 25 Jun 2020 09:21:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200625002111epcas5p276f95efdd9e8675b7014b2050a2f0e4a~boYGhZnAJ0922509225epcas5p2F;
        Thu, 25 Jun 2020 00:21:11 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200625002111epsmtrp2c6d129880dc0084f20367ba47cb16590~boYGdwGHl2241922419epsmtrp2X;
        Thu, 25 Jun 2020 00:21:11 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-65-5ef3edf7d0c1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C2.09.08382.7FDE3FE5; Thu, 25 Jun 2020 09:21:11 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200625002107epsmtip1aae9c4ad2d264c605d250d7aecb38d57~boYDWPAYc1560015600epsmtip1E;
        Thu, 25 Jun 2020 00:21:07 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Vinod Koul'" <vkoul@kernel.org>
Cc:     "'Kishon Vijay Abraham I'" <kishon@ti.com>, <robh@kernel.org>,
        <krzk@kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <avri.altman@wdc.com>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cang@codeaurora.org>,
        <devicetree@vger.kernel.org>, <kwmad.kim@samsung.com>,
        <linux-kernel@vger.kernel.org>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>
In-Reply-To: <20200624173000.GJ2324254@vkoul-mobl>
Subject: RE: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
Date:   Thu, 25 Jun 2020 05:51:06 +0530
Message-ID: <008b01d64a86$872af1e0$9580d5a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-in
Thread-Index: AQNA14zZ9KpC6NxovY65uGX80LQ4kgIpylB3AdlmWUMBx1WEmQIl7FhyAiYYQSwBBY3htAG7IsXOAfG87UylnQyD8A==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7bCmuu73t5/jDBZ2Glq8/HmVzeLT+mWs
        FvOPnGO1uPC0h83i/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUaLnXdOMDvweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJVxdu0i1oLX3BXv9p5nbGA8z9nFyMkhIWAisazhF2sXIxeH
        kMBuRomne2YxQzifGCWeTFrADuF8Y5R4tHEtUIYDouVfIER8L6PE+mnvoIreMEpMe3KKFWQu
        m4CuxI7FbWwgtoiAqsSWJw/AbGaBhcwSWxbog9icAkYSa5ccZQSxhQWcJF6v2MMEYrMA1T+8
        PQFsDq+ApcT+rTuhbEGJkzOfsEDMkZfY/nYOM8QPChI/ny5jhYiLSxz92QN2qIhAlsTTb1Ug
        t0kIvOCQODf1DxNEvYvEx2db2SFsYYlXx7dA2VISn9/tZYN4MluiZ5cxRLhGYum8YywQtr3E
        gStzWEBKmAU0Jdbv0ofYyifR+/sJE0Qnr0RHmxBEtapE87urUJ3SEhO7u1khSjwk+ppEJzAq
        zkLy1iwkb81C8soshF0LGFlWMUqmFhTnpqcWmxYY5qWW6xUn5haX5qXrJefnbmIEJzstzx2M
        dx980DvEyMTBeIhRgoNZSYQ3xO1TnBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFepR9n4oQE0hNL
        UrNTUwtSi2CyTBycUg1MG7auZ3nE1zRVtUmqxmpu++dbuy22i3saltSs3L1dqpxF6rRBvf3E
        noaM79ttG249dno76cek7Vc5LV/emhg89dGXpCwT9Ys/k199Kgj53Wkvc0n6sO+RP+wan5TL
        Mp6ferXtxXGRIrXUJcfFGVhsz/SrrM3z1Dr7P14uL/nuOx6H4zpSiQoXWo4q/pn7Sl3i6Moj
        KZPPV5//m7fzlugORucfja4fb1kJdE/YeUngisOUA98aZtpvEQj6ylBRtS+AYVn6wTj92ZL3
        Yl6LnMz5mXfglGGhXHlN0EmGh0HFEfcTZsTe1pLjCu87dIqx88/Xr9FHb3UILed51j6n7X5d
        ycq02b3F/uk8FWHv5wu3KbEUZyQaajEXFScCACwH/SzlAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSnO73t5/jDC61c1q8/HmVzeLT+mWs
        FvOPnGO1uPC0h83i/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUaLnXdOMDvweVzu62Xy2LSqk81j85J6j5aT+1k8Pj69xeLRt2UVo8fxG9uZPD5vkvNo
        P9DNFMAZxWWTkpqTWZZapG+XwJVxdu0i1oLX3BXv9p5nbGA8z9nFyMEhIWAisexfIIgpJLCb
        UeJmbRcjJ1BUWuL6xgnsELawxMp/z8FsIYFXjBKHJ1iA2GwCuhI7FrexgdgiAqoSW548ALK5
        OJgF1jJLzD+0GswREjjLLHHp6WmwKk4BI4m1S44ygtjCAk4Sr1fsYQKxWYC6H96ewApi8wpY
        SuzfuhPKFpQ4OfMJC8hxzAJ6Em0bwVqZBeQltr+dwwxxnILEz6fLWCHi4hJHf/Ywg5SLCGRJ
        PP1WNYFReBaSQbMQBs1CMmgWkuYFjCyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGC
        I1ZLcwfj9lUf9A4xMnEwHmKU4GBWEuENcfsUJ8SbklhZlVqUH19UmpNafIhRmoNFSZz3RuHC
        OCGB9MSS1OzU1ILUIpgsEwenVANTBf9/L/23vubxtUEs6s99pk/TONAcusD49pZq+VdZe2rr
        9r7eu+f3v7fvdI2MJkX7hoRFvVow7V/NikubtNOL3r88zDmlKtq6Jq2qI+N1hX3+9M0PtjZU
        pWzleGCsJaIn/TLj570F21qfxX/1tnNusRU/cDj1/EfHv/Ln5e+kWDjpV9b4mf6eXfzu4aaA
        lX7LrSJ0XwkGz+DaFd5fw7ePK2eZvPhfx/kXw49dEd6+oP0Wm/yXs7NTKjzn8zQ25FjHy8VL
        bivPW/ilpdLB8WqytUvbsZNy0iq513304s1euln8nKGuO4UjuTL9X+JkPYuYZ8G7v+xYbHmf
        ZwJbVbzqVBEN9okNDw8d8FuxYpkSS3FGoqEWc1FxIgBkQA9mRwMAAA==
X-CMS-MailID: 20200625002111epcas5p276f95efdd9e8675b7014b2050a2f0e4a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200528013223epcas5p2be85fa8803326b49a905fb7225992cad
References: <CGME20200528013223epcas5p2be85fa8803326b49a905fb7225992cad@epcas5p2.samsung.com>
        <20200528011658.71590-1-alim.akhtar@samsung.com>
        <159114947915.26776.12485309894552696104.b4-ty@oracle.com>
        <013a01d63d3e$ecf404d0$c6dc0e70$@samsung.com>
        <89b96bd0-a9a3-cdd8-dc67-1f9f49eef264@ti.com>
        <000001d646a6$6cb5fd70$4621f850$@samsung.com>
        <20200624102112.GX2324254@vkoul-mobl>
        <004b01d64a48$8bb87270$a3295750$@samsung.com>
        <20200624173000.GJ2324254@vkoul-mobl>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Vinod,

> -----Original Message-----
> From: Vinod Koul <vkoul@kernel.org>
> Sent: 24 June 2020 23:00
> To: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: 'Kishon Vijay Abraham I' <kishon@ti.com>; robh@kernel.org;
> krzk@kernel.org; linux-samsung-soc@vger.kernel.org; avri.altman@wdc.com;
> stanley.chu@mediatek.com; linux-scsi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; cang@codeaurora.org;
devicetree@vger.kernel.org;
> kwmad.kim@samsung.com; linux-kernel@vger.kernel.org; 'Martin K. Petersen'
> <martin.petersen@oracle.com>
> Subject: Re: [PATCH v10 00/10] exynos-ufs: Add support for UFS HCI
> 
> Hi Alim,
> 
> On 24-06-20, 22:27, Alim Akhtar wrote:
> > > > > Sure, will re-send this series.
> > >
> > > But patches have not been sent right, pls send and me/Kishon will
> > > review
> > >
> > Thanks for your kind attention on this series. As per [0] comment from
> > Kishon, patch 7/10 [1] and probably 6/10 [2] should have been Applied
> > after
> > 5.8-rc1 was tagged.
> 
> And that is something I am trying atm, but I dont have patches in my
mailbox, so
> would you be kind enough to resend me these patches after rebasing to phy-
> next, also do add acks/reviews collected in previous posts.
> 
> I dont think I have seen resend, or maybe I wasnt cced
> 
Just noticed you were not CCed.
I have sent those two patches.
https://patchwork.kernel.org/patch/11624571/
https://patchwork.kernel.org/patch/11624569/

PTAL,

Thanks,

> 
> --
> ~Vinod

