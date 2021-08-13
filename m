Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A59C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 05:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABF5060FC0
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 05:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbhHMFcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 01:32:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11920 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhHMFcC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 01:32:02 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210813053134epoutp029d7e9e0f491b409badb350cea578a359~axrSinII70550805508epoutp02N
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 05:31:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210813053134epoutp029d7e9e0f491b409badb350cea578a359~axrSinII70550805508epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628832694;
        bh=iGDief16Fzc3SLhWwVJACEbw8Ik43QoS3vYZa+gMyns=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=NjGqrG3O/yN5PbjQtNFne/yx2/BF9ljrO84EYjOfCN856+w9yeqmpikLvr1ApB1Xh
         0qvyiKMx2RMYaOsV8eEhfkdUuBRB4dMq+BUKvo8mzWJ7z522TiOvhiAxsFmJvpncNk
         VxVLbjxTl46sHx0/ZJCU111woaEx4SEP7WqTbF4Q=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210813053133epcas2p1abc2b2e3499c3fe3152d289210e8715e~axrRutZsQ0274302743epcas2p1Q;
        Fri, 13 Aug 2021 05:31:33 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GmBxZ4zYbz4x9Qg; Fri, 13 Aug
        2021 05:31:30 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        F7.66.09921.2B306116; Fri, 13 Aug 2021 14:31:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210813053130epcas2p1a1d6da04716e4c279c15350fb55937c9~axrOg7Cnw0274002740epcas2p1C;
        Fri, 13 Aug 2021 05:31:29 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210813053129epsmtrp11c6bd4bad2b087fe23af18a43177b54b~axrOb8CN42126821268epsmtrp11;
        Fri, 13 Aug 2021 05:31:29 +0000 (GMT)
X-AuditID: b6c32a45-f9dff700000026c1-01-611603b22f00
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        1B.77.32548.1B306116; Fri, 13 Aug 2021 14:31:29 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210813053129epsmtip25c47b25ddf5818831ac26f717759ba8d~axrOItGrO3034130341epsmtip2t;
        Fri, 13 Aug 2021 05:31:29 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <cang@codeaurora.org>,
        <adrian.hunter@intel.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
In-Reply-To: <32cc37cd-2f66-0f74-5242-cfcf86f58844@acm.org>
Subject: RE: [RFC PATCH v1 0/2] scsi: ufs: introduce vendor isr
Date:   Fri, 13 Aug 2021 14:31:29 +0900
Message-ID: <064a01d79004$77f087c0$67d19740$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLpLcRe5nxssMVHyiI1GTvVMnlTYwK++sB5AU8a/RsBw7fVSgIyhbLYqQ2JOBA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJsWRmVeSWpSXmKPExsWy7bCmue4mZrFEg8alqhYnn6xhs3gwbxub
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8ZqsXrxAxaLRTe2MVlc3jWHzaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeSze85LJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBG5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyVi/3qzgI0fF+ZvVDYy/2LoYOTkkBEwkjt3vY+li5OIQEtjBKPH2SjcbhPOJUWLu
        5OnsEM5nRonlN/YzwrTMOj2PCSKxi1HizNcGRgjnBaNE17YNYFVsAtoS0x7uZgVJiAi0MEtc
        2fuJCSTBKWAt8fTILqC5HBzCAvYSL/+JgYRZBFQljjy5wQxi8wpYStyfdpUdwhaUODnzCQuI
        zSwgL7H97RxmiCsUJH4+XcYKYosI+El8X3qbEaJGRGJ2ZxszyF4JgRscEk+33oU620Xi8cZv
        UF8LS7w6voUdwpaSeNnfBmXXS+yb2sAK0dzDKPF03z+oZmOJWc/aGUGOZhbQlFi/Sx/ElBBQ
        ljhyC+o2PomOw3/ZIcK8Eh1tQhCNyhK/Jk2GGiIpMfPmHahNHhKbjp1im8CoOAvJl7OQfDkL
        yTezEPYuYGRZxSiWWlCcm55abFRgiBzXmxjB6VrLdQfj5Lcf9A4xMnEwHmKU4GBWEuHdKSeU
        KMSbklhZlVqUH19UmpNafIjRFBjuE5mlRJPzgRkjryTe0NTIzMzA0tTC1MzIQkmcVyPua4KQ
        QHpiSWp2ampBahFMHxMHp1QDk2zoubaSluKLS3jUPJcU7NU8LxDnoLez5fWtH8826W6dOGHi
        LTHmWjnDuQqn9dS5lf//cNlxa5dk+YY3R39dPeqVlreT8b1C6PatPly1O/kuOapb8vf+2Kay
        QX8tW7jsMsX+a+WRittyvu3SYblrMlv10oaHG6WvXD/7guvoVZ+YXsm/v7Vb2xJXHj71Jjv1
        PrPX/gfHAlo+mfvc/rYo/seGRTM2zK6LkuAJuG1s8nmPhPajqbHVbix89Qn6zrJqrVmLTzy4
        acp2yI0nSvFi4aEFjxK3PzNcKCY2tdvqabdHxR+xV72TGA3mpXLfDL62/WGVRtz0QHv19ryz
        fxa4f7Q6aiZtetfbu1Kig/fgWiWW4oxEQy3mouJEAFj62nxgBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWy7bCSvO5GZrFEgznzDCxOPlnDZvFg3jY2
        i5c/r7JZHHzYyWLxdekzVotpH34yW3xav4zVYvXiBywWi25sY7K4vGsOm0X39R1sFsuP/2Oy
        6Lp7g9Fi6b+3LA58HpeveHtc7utl8li85yWTx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4MpYv96s4CNHxfmb1Q2Mv9i6GDk5JARMJGadnscEYgsJ7GCU
        OLXSDSIuKXFi53NGCFtY4n7LEdYuRi6gmmeMEkc/bwNLsAloS0x7uBssISIwhVnizrWjbBBV
        05gkbj3YxApSxSlgLfH0yC72LkYODmEBe4mX/8RAwiwCqhJHntxgBrF5BSwl7k+7yg5hC0qc
        nPmEBcRmBlrQ+7CVEcKWl9j+dg4zxEUKEj+fLgMbLyLgJ/F96W2oGhGJ2Z1tzBMYhWYhGTUL
        yahZSEbNQtKygJFlFaNkakFxbnpusWGBUV5quV5xYm5xaV66XnJ+7iZGcHxqae1g3LPqg94h
        RiYOxkOMEhzMSiK8O+WEEoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQ
        WgSTZeLglGpg2n1m4075F/bpiSemq3av28Bbp6Eskynk9bPtmVbSbZemCqmFrNXOP67zzLho
        pspmdf5kQaJpvEak0TKJtEfCbV81bnzffsm8IfyG3+KlDS/+VJ2s8KledFRArzj00fwkn/2M
        Ww+9XNNdpOAZWXUrc/fnnH1FGsLbsuUvvVK94ZbVLPogSP2b8MHbU0//muOzsvE935GJW0Qu
        bXovvvDib0FupeXnkrd3fcsteccd8dHtldpNgaKgALvwq6UN3z2aJz74uuDdgV53e8ktC5tv
        vj11UsRYptPjuPcN7npO6z+FOSfrYljUMnKC/6pt0XKY8ef3pheJpx9V100zkV1oOTVjv351
        9Z0zFXeU8tZLK7EUZyQaajEXFScCAHOZ2sQ+AwAA
X-CMS-MailID: 20210813053130epcas2p1a1d6da04716e4c279c15350fb55937c9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229
References: <CGME20210806064923epcas2p13dd6b442eed02404d87684afd9c1b229@epcas2p1.samsung.com>
        <cover.1628231581.git.kwmad.kim@samsung.com>
        <b3c18b34-2108-abfa-54ca-096a3eb31318@acm.org>
        <000601d78cf2$a160f820$e422e860$@samsung.com>
        <32cc37cd-2f66-0f74-5242-cfcf86f58844@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 8/9/21 12:46 AM, Kiwoong Kim wrote:
> >> How about extending the UFS spec instead of adding a non-standard
> >> mechanism in a driver that is otherwise based on a standard?
> >
> > It seems to be a great approach but I wonder if extending for the
> > events that all the SoC vendors require in the spec is recommendable.
> > Because I think there is quite possible that many of those things are
> > originated for architectural reasons.
> 
> Has the interrupt mechanism supported by this patch series already been
> implemented or is it still possible to change the ASIC design? In the
The former case. It has been included since mass production of the first SoC
supporting UFS for the first time.

> latter case, I propose the following:
> * Drop the new interrupt.
> * Instead of raising an interrupt if the UFS controller detects an
> inconsistency, report this via a check condition code, e.g. LOGICAL UNIT
> NOT READY, HARD RESET REQUIRED (there may be a better choice).
> 
> The above approach has the advantage that it does not slow down the UFS
> interrupt handler.
> 
> Thanks,
> 
> Bart.
> 


