Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6BFC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 03:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7D652070A
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 03:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbhASDn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 22:43:27 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:20917 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbhASDnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 22:43:18 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210119034227epoutp014a8326c4298f256b289bb705d89bb1d7~bhTNr0G9y0338603386epoutp01E
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jan 2021 03:42:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210119034227epoutp014a8326c4298f256b289bb705d89bb1d7~bhTNr0G9y0338603386epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611027747;
        bh=0/XyJc2skLxvc6UmT4S2F0mrnpfpXZkdDpauvVsUM7w=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=Fmg/hgvcr7OhVnsi92I23Hn9Hkv758uvqRw9kQY+NCRIWPBXb7GYK8fdyUipWi2cD
         667CityQX5X/tAGdaxnYYzWIjaPR6fKGJG3K3D1edcnM9jgacV5D4uBjetrVjDyOa3
         4d57LnwmLHIjiosgRMmZX6sy+cjrFfgY1K1GsAb0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210119034226epcas2p11ffee3d0f5ffd484fb309ea3321c2851~bhTNCb2bB0932309323epcas2p1d;
        Tue, 19 Jan 2021 03:42:26 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.184]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DKZGl4HTzz4x9Q1; Tue, 19 Jan
        2021 03:42:23 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.7B.10621.F1556006; Tue, 19 Jan 2021 12:42:23 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210119034223epcas2p490651ec80b51251bfb810fdbe9c104af~bhTJaUPC_2918429184epcas2p4j;
        Tue, 19 Jan 2021 03:42:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210119034223epsmtrp1391a72ae22790ff966b0739a83077436~bhTJZdKsD1144811448epsmtrp1c;
        Tue, 19 Jan 2021 03:42:23 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-9a-6006551feea1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C1.B1.08745.E1556006; Tue, 19 Jan 2021 12:42:22 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210119034222epsmtip16618ade425e8c0371256379bbf1a521a~bhTJIIwgR2163121631epsmtip1G;
        Tue, 19 Jan 2021 03:42:22 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <cang@codeaurora.org>,
        <bvanassche@acm.org>, <grant.jung@samsung.com>,
        <sc.suh@samsung.com>, <hy50.seo@samsung.com>,
        <sh425.lee@samsung.com>, <bhoon95.kim@samsung.com>
In-Reply-To: <cover.1611023224.git.kwmad.kim@samsung.com>
Subject: RE: [ PATCH v6 0/2] introduce a quirk to allow only page-aligned sg
 entries
Date:   Tue, 19 Jan 2021 12:42:22 +0900
Message-ID: <047d01d6ee15$1892dc10$49b89430$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIzesnF+mLCsBdJMfotOaCZn7Z9bQEph7lpqWvoBxA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmqa58KFuCwdmlshYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZNF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        VI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtDdSgpl
        iTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ8MCveLE3OLSvHS95PxcK0MDAyNToMqE
        nIwzy66wFvSwVpxd3sbcwPiWuYuRk0NCwERiVfN1li5GLg4hgR2MEvtOHmaCcD4xShz7fRLK
        +cwosez6PriWI3umQSV2MUpMmtrEDOG8YJRYcHIfC0gVm4C2xLSHu1lBEiICL5gkbqy9zwaS
        4BSwlJi9+AwjiC0sECax8NUfMJtFQFXi2/P3YDW8IDX3XjFD2IISJ2c+ARvKLCAvsf3tHKgz
        FCR+Pl3GCmKLCFhJvLzaygxRIyIxu7MN7CIJgRMcEpu71zFCNLhIfL18ix3CFpZ4dXwLlC0l
        8bK/Dcqul9g3tYEVormHUeLpvn9QzcYSs561A9kcQBs0Jdbv0gcxJQSUJY7cgrqNT6Lj8F92
        iDCvREebEESjssSvSZOhhkhKzLx5B2qTh8T61jNMExgVZyH5chaSL2ch+WYWwt4FjCyrGMVS
        C4pz01OLjQoMkaN7EyM4VWu57mCc/PaD3iFGJg7GQ4wSHMxKIryl65gShHhTEiurUovy44tK
        c1KLDzGaAsN9IrOUaHI+MFvklcQbmhqZmRlYmlqYmhlZKInzFhs8iBcSSE8sSc1OTS1ILYLp
        Y+LglGpg0pXXMF2qpuV8Q+rB8aC6jwevCnj2P/56/IUgj/zCNibOl/7MdozMa/vSNp802lRZ
        dO+OKPOEr2wNR661SpzT0b8Rfs1Kb3K3nK+me3Bg7v38pa6mV09kNV+LCP7hnXXhQiCz27QD
        t4V4+Q+6Tpc317r/RjYr+XzMzhP1JtEySj/iK+P2rGdpvMqRYXy0h/dqdfLrZV7dvqIX7oZ/
        vxVhZTf/VUVu0CH1rQoBKX+Oqpk32tXFPn6/TLPpoFtnsUqKfFMI8+7l04plDq73y3+nWZob
        0Xg+sM8hx6O47i1XzQ0ZCcWHFvk35P5+UlRu/pf/zX5p65ZltzfZB+mYx4burGWanjO/RXXR
        n8liikosxRmJhlrMRcWJALjOSnBeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsWy7bCSnK5cKFuCwZvjphYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZNF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfGmWVXWAt6WCvOLm9jbmB8y9zFyMkhIWAicWTPNKYuRi4OIYEdjBJv
        /hxhhEhISpzY+RzKFpa433KEFaLoGaPE9SvrWUESbALaEtMe7gZLiAj8YpK4dmwzVFUXo8SZ
        la1gVZwClhKzF58BGyUsECKx790lNhCbRUBV4tvz92A2L0jNvVfMELagxMmZT1hAbGagDb0P
        WxkhbHmJ7W/nQN2tIPHz6TKw+SICVhIvr7YyQ9SISMzubGOewCg0C8moWUhGzUIyahaSlgWM
        LKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYKjU0trB+OeVR/0DjEycTAeYpTgYFYS
        4S1dx5QgxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA9PU
        m3OjzJMVTPsE7jztu51t43Dd0tjDs7VRZmYx4/3rIYsy+jZbte4/MXXulhWxlwIuxhj4sKZ+
        2RAk2+h5nkfApGxJovv/g3sniHDunLTnpnL9/53Xk64c7GcpZelnU/U0ZFp3tcB9VfQszcjm
        wiXzubsdDtZlzrBLj7m+dGJjp+efjt4NDV/VmbXtGI9Ymh4XenNk8xtPzkWzLqxZaD3F++X2
        Lm3JpTnrl638sLI3TLzlf1Hrw5iO/DkPpzoue1P2YvYWR+ktKbk/2gTrjRxPmYSXLvUpP6+3
        Wj7TI+XhBweD6wvXJl7Y0X7G7ZCf45TTf/+mGAmETRPqF2FJufO7K6hycmLxM3+j42wClUos
        xRmJhlrMRcWJAGbDS6Y9AwAA
X-CMS-MailID: 20210119034223epcas2p490651ec80b51251bfb810fdbe9c104af
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210119024011epcas2p45256028f99195958140a6846d40b9143
References: <CGME20210119024011epcas2p45256028f99195958140a6846d40b9143@epcas2p4.samsung.com>
        <cover.1611023224.git.kwmad.kim@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> v5 -> v6: collect received tags


There is a mistake on the part of this commit message.
Sorry, I'll post again.


Thanks.
Kiwoong Kim
> v4 -> v5: collect received tags
> v3 -> v4: fix some typos
> v2 -> v3: rename exynos functions
> v1 -> v2: rename the vops and fix some typos
> 
> Kiwoong Kim (2):
>   ufs: introduce a quirk to allow only page-aligned sg entries
>   ufs: ufs-exynos: use UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE
> 
>  drivers/scsi/ufs/ufs-exynos.c | 3 ++-
>  drivers/scsi/ufs/ufshcd.c     | 2 ++
>  drivers/scsi/ufs/ufshcd.h     | 4 ++++
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> --
> 2.7.4


