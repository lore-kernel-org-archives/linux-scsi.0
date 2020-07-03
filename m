Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4EA5C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 07:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6C90214F1
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 07:08:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lhlZtyr5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGCHI5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 03:08:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25037 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgGCHI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 03:08:56 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200703070853epoutp01315a837030232b242dfd51796acec5ee~eLGW-dvor0943609436epoutp01W
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 07:08:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200703070853epoutp01315a837030232b242dfd51796acec5ee~eLGW-dvor0943609436epoutp01W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593760133;
        bh=elBhYMIJdgvqKcPAifyTcBNckVeRc1VH49jTtKGKe3o=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=lhlZtyr5d6zoAcCDL+W4JZ3NGmVBANN2dvRN61rDl1ghxv5S0b9vdjoRYZa7gMu4f
         wa+sDsDWJFqKnZhoEBi0BazcfE4tgILcAAzlDad9kYbfpiC3NHWqdty75/JjjAXXO9
         AF3a7DNojX0zNjD6jWPn2HUOo64H3bvfcRpK3XDk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200703070853epcas2p3e4c039d9fd00903d2977d3029681b92b~eLGWuv-tn1443914439epcas2p3e
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 07:08:53 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49ymKH5VCNzMqYkb for
        <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 07:08:51 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.DD.19322.289DEFE5; Fri,  3 Jul 2020 16:08:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200703070850epcas2p22538f97bebb6fbfe0aeb90d9d1b27cbb~eLGT0CfqO2047620476epcas2p29
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 07:08:50 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200703070850epsmtrp16393766588189e4c1b31b0ab70ae439a~eLGTzauBg1958619586epsmtrp1P
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 07:08:50 +0000 (GMT)
X-AuditID: b6c32a45-7adff70000004b7a-da-5efed98262ef
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.57.08303.289DEFE5; Fri,  3 Jul 2020 16:08:50 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200703070850epsmtip266918132d8af055cfead956e268bf207~eLGToWLXQ1006910069epsmtip2-
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2020 07:08:50 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     <linux-scsi@vger.kernel.org>
In-Reply-To: <1593755992.3278.14.camel@mtkswgap22>
Subject: RE: [RFC PATCH v3 1/2] ufs: introduce a callback to get info of
 command completion
Date:   Fri, 3 Jul 2020 16:08:49 +0900
Message-ID: <00c801d65108$cd58deb0$680a9c10$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQGzyCHOhCeJxiopSPNZAUTahmxpDALbRwriAcIz1fADRH8/v6j7cW0A
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsWy7bCmqW7TzX9xBtNWqlh0X9/B5sDo8XmT
        XABjVI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
        JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BoWGBXnFibnFpXrpecn6ulaGBgZEp
        UGVCTsbFFfwFu1krfm9vZmtgnMvSxcjJISFgItE8/T0jiC0ksINR4u/rpC5GLiB7MpPEwbnv
        mSCcKUwSmxfsZYPp+Pn1NTtEYhejxKO2DYwQTieTROvtSWCz2AS0JaY93M0KYosIKEj8bTvE
        DGJzChhJLOrtB5skLBArcWnjFHYQm0VARWLt+RlgNbwClhLPfvQyQdiCEidnPgG7lVlAXmL7
        2znMEFcoSPx8uowVIi4iMbuzjRlil5vE1GfNUJfuYpf4PlUfwnaRmP3oDFRcWOLV8S3sELaU
        xMv+Nii7XmLf1AZWkGckBHoYJZ7u+8cIkTCWmPWsHcjmAFqmKbF+lz6IKSGgLHHkFtRpfBId
        h/+yQ4R5JTrahCAalSV+TZoMNURSYubNO1CbPCT6ls1jn8CoOAvJk7OQPDkLyWOzEPYuYGRZ
        xSiWWlCcm55abFRgiBzVmxjByU3LdQfj5Lcf9A4xMnEwHmKU4GBWEuFNUP0XJ8SbklhZlVqU
        H19UmpNafIjRFBjsE5mlRJPzgek1ryTe0NTIzMzA0tTC1MzIQkmcN1fxQpyQQHpiSWp2ampB
        ahFMHxMHp1QDE1OlnFyCWNMnabHG0BZ9jutpJfaetYEbjJ9GO/YGXnsRwrr+ccCyZWETVq9h
        /eD773Vd2pPeGf6rDnN+MKsIzGF2mB9gss96Zdc/y4z5e1rmKwjOZ9eRXCXE//rAJgUph5iy
        qcfeplZVyB8qsztptDs3Yt5c0V2HxX00/+9aHSSWmfGw3VE49ZL+Mfc3T9esMv4htXvmE7fe
        OT8nRafrySS9d5FU/3VIcEX+tHkLOPYcjlh7Ry7R3/Nst9jFiuvzJB5lBCpd36XDrul7f++O
        uvM39nq09yqLr/kYJNkkqHh1rv9HyVS9E8FZqS/DOGct4tizKmrGV60fveJPdNwnsn6+teP8
        4v7EY/V2nTqzlViKMxINtZiLihMBhi5rv/cDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWy7bCSvG7TzX9xBkv/sVl0X9/B5sDo8XmT
        XABjFJdNSmpOZllqkb5dAlfGxRX8BbtZK35vb2ZrYJzL0sXIySEhYCLx8+tr9i5GLg4hgR2M
        EotenmWFSEhKnNj5nBHCFpa433KEFaKonUni+ZVHzCAJNgFtiWkPd4M1iAgoSPxtO8QMUdTA
        JNH04gnYCk4BI4lFvf1sILawQLTErMd7wBpYBFQk1p6fATaIV8BS4tmPXiYIW1Di5EyIXmag
        Bb0PWxkhbHmJ7W/nMENcpCDx8+kyVoi4iMTszjZmiCPcJKY+a2abwCg0C8moWUhGzUIyahaS
        9gWMLKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz0vWS83M3MYJDWktrB+OeVR/0DjEycTAeYpTg
        YFYS4U1Q/RcnxJuSWFmVWpQfX1Sak1p8iFGag0VJnPfrrIVxQgLpiSWp2ampBalFMFkmDk6p
        BibnRae2mogGPOcLkd24U/Pm7o+1LCJGrpMWM0wX0Nnwk/vl/s9iC9XYrZaK2ti4mDfuYD1V
        eOWv9AT5IF2GgIYA0wOpW39cfWrffH8m8zGbnRuf64aGFG9Yofrj4dPgpGbP8uqXfn8iF2/9
        a8zOFXM4es+uN7WpC+f4s31xDchmUGhR/b5Y2nzBZyEmVcn4nKcbZY67K/9MjVo7LfFGUsqk
        J4mln7NYvvJWGmTzT6tbb553tiv40sSb/0UF3VQyc7MkpyRX7pbmlzqwrfvWl69+zz64dsx7
        9/KG1CcnvoC52q+XTtwba7jIJldDeI/mp8bZP8S0K07dF90Sf3G+TtRHx7ls1WeOHjkt/dwu
        65ASS3FGoqEWc1FxIgCvPSVQ2AIAAA==
X-CMS-MailID: 20200703070850epcas2p22538f97bebb6fbfe0aeb90d9d1b27cbb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d
References: <cover.1593752220.git.kwmad.kim@samsung.com>
        <CGME20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d@epcas2p1.samsung.com>
        <93c364a2285a6c8eaaed6e0f68bbc8376ae7519e.1593752220.git.kwmad.kim@samsung.com>
        <1593755992.3278.14.camel@mtkswgap22>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Hi Kiwoong,
> 
> On Fri, 2020-07-03 at 14:31 +0900, Kiwoong Kim wrote:
> > Some SoC specific might need command history for various reasons, such
> > as stacking command contexts in system memory to check for debugging
> > in the future or scaling some DVFS knobs to boost IO throughput.
> >
> > What you would do with the information could be variant per SoC
> > vendor.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> 
> Please help collect all tags received in previous versions and add them to
> any future new versions, for example, for this patch,
> 
> Acked-By: Stanley Chu <stanley.chu@mediatek.com>
> 
> 

Oh, got it.

Thanks.
Kiwoong Kim


