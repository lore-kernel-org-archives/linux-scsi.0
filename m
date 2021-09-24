Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E7BFC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 01:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 798A061241
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 01:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbhIXBLj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:11:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45541 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243676AbhIXBLi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 21:11:38 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210924011004epoutp012b5f17912f6f2ce5efda0400ca800653~nnM9YLDm42802128021epoutp01w
        for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2021 01:10:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210924011004epoutp012b5f17912f6f2ce5efda0400ca800653~nnM9YLDm42802128021epoutp01w
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632445804;
        bh=V0HZSHUZzy9kK6+ysd/jd9GqpM44S84Cd2QYn8LsPxE=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=g6ZgVWnJ6bNLL25y1s5HD5Zx6qG5uolGyMIjIAnZUrvIPzinan95YSdI5cWUkwh0k
         x3AqSq/E5CRilFBdgGXXhkkDs+vl5Ocy6TEg6SvJPQ/H6kurURPb1l/K+7mzXR2wVX
         lx5TPQV0TqllorywDhy6Q6z0p/bmR7DlhsHglYsI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210924011003epcas2p1c46d517bf83bd54a2e36602b4fe2efa4~nnM8pDo0S2085120851epcas2p1B;
        Fri, 24 Sep 2021 01:10:03 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HFv8T5KKGz4x9Q4; Fri, 24 Sep
        2021 01:10:01 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D1.1B.09816.9652D416; Fri, 24 Sep 2021 10:10:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210924011001epcas2p2942a0366238ce6e5a02a3759f39ba0bd~nnM6hx28l1833718337epcas2p2H;
        Fri, 24 Sep 2021 01:10:01 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210924011001epsmtrp29a5916da3a0e49b9f46adc23fbb6ddbf~nnM6gT6u50274302743epsmtrp2Q;
        Fri, 24 Sep 2021 01:10:01 +0000 (GMT)
X-AuditID: b6c32a46-625ff70000002658-3a-614d25696691
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        2F.C7.08750.9652D416; Fri, 24 Sep 2021 10:10:01 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210924011000epsmtip1e7f2de16570cd271581e0bb1bf80763c~nnM6QQ8A50905209052epsmtip1O;
        Fri, 24 Sep 2021 01:10:00 +0000 (GMT)
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
        <devicetree@vger.kernel.org>
In-Reply-To: <YUx1bp8a/hhnlwl0@robh.at.kernel.org>
Subject: RE: [PATCH v3 05/17] dt-bindings: ufs: exynos-ufs: add sysreg
 regmap property
Date:   Fri, 24 Sep 2021 10:10:00 +0900
Message-ID: <000901d7b0e0$e618b220$b24a1660$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQLrZ3V1AdZHg9YCn30eDgG0vbDVAc/JwHCpsu1osA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02TbUxTZxTH89zb3hYVci3InrC4NXcyJ6PQFosPDtwQNXeTTczMNMtivYM7
        2q20XS9lkw8LbNFRCohxUSwwNtzAgEmldhQYAiuMl5m5OKCKCwqsTljGa4MOjLK2FzO+/c45
        /5Nz/s+LGJd4iSixVp/LmvSMjiLWCZq7tyXKtNFvMvI560towHuJQGNfNxNoammYQD+NWwTo
        7NwSjhbsdUJU03NdiEpa09C18loMee02HNXeasZQ0/S/GKr4rQND1pstBKrve4KhlfYW0Wsk
        PTi0n7YVlBL0YFkpRl+5GENfaJ/CaEeDhaDLa7sA/dBeRNDz924L6DJnA6B9jufoL7usWMaG
        d3XJGpbJYk1SVp9pyNLqs1Oo/W+r09SqRLlCpkhCOyipnslhU6g96RmyfVqd3xMlzWN0Zn8q
        g+E4Kn5XsslgzmWlGgOXm0KxxiydUaEwxnFMDmfWZ8dlGnJ2KuRypcqvPKbT1E+cwowW8tML
        7lpRAWjaUAxCxJDcDkfu1GDFYJ1YQrYAWNo7uBosADjrsIgCKgnpA9D784tPO1of/SrkRW0A
        fr94V8AHkwAu37wrDKgIMh5OFTUHOYKMhp/bxoIinLQI4YJtkAgUQkglHO4cCXI4eQSeWqgO
        ssDfMPq4HgtwKJkEuzuGRDxvhAPnvYIA4+Tz0DVdhfMrSeHSvTr/MLF/2DvwviuWl0TASsvJ
        VYk1BDp6GJ73wMbSVhHP4fDvPucqR0HfzFUisKdfD+CJiZXVQiOAlsJ0nl+Fy+ecwVk4uQ3a
        2+IDCMkXYM/t1c3CYFH3YxGfDoVFJyV841bY5Ton4HkztFb5hOWAsq3xZVvjy7bGgO3/Wd8A
        QQOIZI1cTjbLKY3KtXftAMHnHrOvBXw1PRfnBpgYuAEU41REqO/WG4wkNIs5ns+aDGqTWcdy
        bqDyn/RpPGpTpsH/X/S5aoVKmZgoT1IhVaISUc+EVj/ZzUjIbCaX/YhljazpaR8mDokqwL5j
        X/f8KW+6+KCtk4k8NFy55fLYwdGOBFA8nfDt6IRxqKR3tu7KgDpsca76yEzISI1xh+wDJ3Yp
        9neD/rPUZ2cXmsbv7433VpQdbv3ni3wTt/nqsbxeafJY+C/L78/H7pzEUat9fb4yw40iJ7eC
        QhUnF45ZVM7DU0VnXab1874OV3GmoPHOmbdAVafvkYzzPPxEc6I7WQal580zNQnj0SMxsWkl
        KxUdJarLKamF5qkfslNzDvUzsWfUP24Je/notVGPZ7Zb2dN1PO897Yc30Ma+9hvsTFuldlHj
        OrjsOWDalZIe5UaevcKSnk3X+62jER9zB/7o1+7e/uDoK6f/aicpAadhFDG4iWP+A30SxZx3
        BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsWy7bCSnG6mqm+iwcunrBYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLeYfOcdq0bPT2eL0hEVMFk/Wz2K2WHRjG5PFxrc/mCxm
        nN/HZNF9fQebxfLj/5gs/u/Zwe4g4HH5irfHrIZeNo/Lfb1MHptXaHks3vOSyWPTqk42jwmL
        DjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMATxWWTkpqTWZZapG+XwJWx/FE/U0GnQMXi
        Q4vYGxg38nQxcnJICJhI7Px9lrWLkYtDSGAHo8T/WZcYIRKyEs/e7WCHsIUl7rccgSp6xihx
        aNo/VpAEm4C+xMuObWC2iICqRNOsBywgRcwCk1kljp4/zQLRsZ9J4sG7frAqTgEjiav7b7J1
        MXJwCAuESezfYQcSZgFqvvt3OROIzStgKXF43xV2CFtQ4uTMJywg5cwCehJtG8GOYxaQl9j+
        dg4zxHEKEj+fLmMFKREBmvh8uw5EiYjE7M425gmMwrOQDJqFMGgWkkGzkHQsYGRZxSiZWlCc
        m55bbFhglJdarlecmFtcmpeul5yfu4kRHOVaWjsY96z6oHeIkYmD8RCjBAezkgjv5xteiUK8
        KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwbeuMUM8LvfMi
        KGvaTM7YiPteigbajGuuctXma7d+2aCY4en2Pt2uJWF23ZL0gOkT9FZe2/bR9vPnmXwKV7J+
        xfGtWusoG/PU8O2l2d/0Lhde2dW+fVFd361U8Vkvc4r/XJ8cVPBAvXxOQ8Xdv/PXcv6YF8jK
        dv7rvIiosttSZ0PkgtYJfctVyXZrYjh/MnhBxJlH0xo9K87NlD2ts9nzybdjty0KBXbpRZX1
        PX4iPCX0/JmUOwu1Two2nvO+LO39Vv7lL5tGxbOBTodMFr9Zc5OxdH76HnGOvNTerhO+dapL
        /c/cvjcn9YSHbfTVixo+UyRfl8Uxte2ddF31Tm6YdNRyJzbGII3b7JdzY+pXKbEUZyQaajEX
        FScCAG4D2mJhAwAA
X-CMS-MailID: 20210924011001epcas2p2942a0366238ce6e5a02a3759f39ba0bd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p3ff66daa15c8c782f839422756c388d93
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p3ff66daa15c8c782f839422756c388d93@epcas2p3.samsung.com>
        <20210917065436.145629-6-chanho61.park@samsung.com>
        <YUuKpSPgdKl2CiSy@robh.at.kernel.org>
        <000801d7b014$9ed9fe40$dc8dfac0$@samsung.com>
        <YUx1bp8a/hhnlwl0@robh.at.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > > +  sysreg:
> > >
> > > Needs a vendor prefix.
> >
> > Thanks. I'll use "samsung,sysreg-phandle".
> 
> No '-phandle'.

Will use "samsung,sysreg" next patch series.

> 
> >
> > >
> > > > +    $ref: '/schemas/types.yaml#/definitions/phandle'
> > > > +    description: phandle for FSYS sysreg interface, used to control
> > > > +                 sysreg register bit for UFS IO Coherency
> > >
> > > Is there more than 1 FSYS? If not, you can just get the node by its
> > > compatible.
> >
> > The phandle can be differed each exynos SoCs, AFAIK. I think other
> > exynos SoCs since exnos7 will need this but not upstreamed yet...
> 
> That's still fine. You really only need a phandle if there is more than
> 1 instance on a given platform.
> 
> Of course you could end up with multiple compatible strings to deal with,
> but you might need that anyway as the registers are likely to be
different.
> That can sometimes be mitigated by putting register offsets into the DT
> property (something to consider here).  This is the problem with drivers
> directly twiddling bits in  other h/w blocks and why we have common
> interfaces for clocks, resets, etc.

Regarding ufs-exynos, it can have multiple instances (ufs_0/1/22). I'm also
preparing to support ufs_1 for exynosautov9 SoC but not yet finished due to
ufs phy control. Each instances has their own sysreg offset. To support
secondary ufs, I need to rework this patch and add the offset field as DT
propery.

+#define UFS_SHAREABILITY_OFFSET        0x710

For UFS1, this should be 0x714.

> 
> I leave it to you to decide how you want to do it.
> 
> BTW, If you want to see another way to handle the same problem, see
> highbank_platform_notifier(). Notifiers aren't great either, but it keeps
> some SoC specifics out of the driver.
> 

I checked highbank_platform_notifier() implementation but I need to keep
this way to have further support multiple ufs instances and can be used for
exynos8/9 SoCs as well.

Best Regards,
Chanho Park

