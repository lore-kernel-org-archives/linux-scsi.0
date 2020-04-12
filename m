Return-Path: <SRS0=2Pbo=54=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB9AC2BB86
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 16:33:32 +0000 (UTC)
X-Greylist: delayed 202 seconds by postgrey-1.34 at mail.kernel.org; Sun, 12 Apr 2020 16:33:32 UTC
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Y1Ic/brO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4585B206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-scsi-owner@vger.kernel.org
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4585B206E9
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Apr 2020 16:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgDLQaG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Apr 2020 12:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgDLQaG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Apr 2020 12:30:06 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB02C0A3BF6
        for <linux-scsi@vger.kernel.org>; Sun, 12 Apr 2020 09:25:05 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200412162501epoutp038f5f674deff36e4eba85efdba8653fd0~FHygvuMQ71418614186epoutp03V
        for <linux-scsi@vger.kernel.org>; Sun, 12 Apr 2020 16:25:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200412162501epoutp038f5f674deff36e4eba85efdba8653fd0~FHygvuMQ71418614186epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1586708701;
        bh=7gehAhvPd0bQ/3Pb49DoC4efoIHtTlTiKUVA2ybcyCc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Y1Ic/brO5Q4p1E7KdT+B4Pt8Ikb4MRKjswj3wN12wAQlD5iuqviWPm86R/AoLOVHb
         TlfYDEcNomw75Z6tK5s38u0QvQ4iKm8e7Dr9B8zu3U61Mihrl6679WlpQ4K9r9cIOa
         Ez9b1hEUZc+TIfs3FHQ/+XiT4964B0wxmdx8ve8Y=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200412162500epcas5p348d02863b15b9d63e3ca730d2ae126b3~FHygIYJOc2939929399epcas5p3p;
        Sun, 12 Apr 2020 16:25:00 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        41.91.04778.CD0439E5; Mon, 13 Apr 2020 01:25:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200412162459epcas5p299fae74f80ad5ec2f68a9df865b4bff2~FHye6aPd-2705227052epcas5p2k;
        Sun, 12 Apr 2020 16:24:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200412162459epsmtrp1f6f67211c3b49863ed1db785630a8cf8~FHye2ymy70693706937epsmtrp1s;
        Sun, 12 Apr 2020 16:24:59 +0000 (GMT)
X-AuditID: b6c32a4a-353ff700000012aa-fc-5e9340dc000e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DB.15.04024.AD0439E5; Mon, 13 Apr 2020 01:24:59 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200412162455epsmtip2882de67d478a270b552da62c75357cad~FHybmFtyD2101821018epsmtip27;
        Sun, 12 Apr 2020 16:24:55 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <robh@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <martin.petersen@oracle.com>, <linux-kernel@vger.kernel.org>,
        <krzk@kernel.org>, <kwmad.kim@samsung.com>, <avri.altman@wdc.com>,
        <cang@codeaurora.org>, "'Seungwon Jeon'" <essuuj@gmail.com>,
        <stanley.chu@mediatek.com>, <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <20200412080947.GA6524@infradead.org>
Subject: RE: [PATCH v5 4/5] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
Date:   Sun, 12 Apr 2020 21:54:53 +0530
Message-ID: <000001d610e6$e8b11450$ba133cf0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHr+Y8xYXIsvNQeqORDaXjXFCUqCgIAvgGXAbEacNoBTCAGf6gh6cLQ
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA01Se0hTYRTvu69dR7PbLDzN6DGQcmClGd2ih4TEpYIK6o8ispUXHzmV3dQS
        I+lhti0fJZFDNDNn2sOaVsss17KVmlq+ykeaNkt7CCpIYlRud5L//c45v8c5Hx+Nyz+TCjoy
        5hivjVFHKykp8fCF33L/7uDLB1cVGhTs0EQbxY6WmUg2v6aRZIvf3sDY+szrGNvUdE/CdlS8
        JFjz53aSbanMpdirTc8wVv/eQrHFr/5g7N8qi4QtetCBgj25lvSLGPfY+FHCld9UcebSCxRX
        fuMUd7a2muBGBjoJLr2iFHFj5kXcease2yXdL90QxkdHJvDalZsOSSOG345jcWkex0c/eaag
        9xId8qCBCYJqSwbSISktZ54gsPb0uItRBNkTJZiTJWfGETS9WzitsN7vokTSUwS2kkfu4geC
        IV2Ny5di/MFSmEo58bwp3FAw6LLFmdM4/DbnuEgeTCDcLrEhJ/Zi9kB1d+uUgKYJxhdGHa62
        jFkHFvs5QsRzoTbH4cI4sxge/czFxY2WwMSAiRSztkLv86tujje8nDDgzlxgbBLIrjMTTn9g
        QsCkOylqveDbqwr3WyhgKCNVIlKOgqFytdhOhqI8OyHizWBtzXW54IwflFWuFJM84eKkAxOV
        MkhLlYtsXzgz3OZW+kCWXk+KmIPqwX4iEy01zrjLOOMu44z9jf/DriGiFC3g4wRNOC+siQuM
        4RNXCGqNEB8TvuJIrMaMXF9Ptc2CTI07bIihkXK2zNqedVBOqhOEExobAhpXzpM5EqdasjD1
        iSReGxuqjY/mBRvyoQmlt+wS2XZAzoSrj/FHeT6O105PMdpDkYJMezYmPwjaYiorff1V26+S
        To6U1EfVDXw3DG/wb46X5H/xvKvI3fJ1+MPIsiu3euz2fSHZswbG7hT1betbG5IfED45Od6F
        Og1EfU2dI287tTvpcF2WLjR0772dsxmVPXE++eZT5+uGZk1B/lO5XvDKvPtrzpqqqN71OweD
        pfKo9eNKQohQB6hwraD+Bza284Z2AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsWy7bCSvO5th8lxBqd3MVm8/HmVzeLT+mWs
        FvOPnGO1WH5hCZPF6QmLmCzOn9/AbnFzy1EWi02Pr7FaXN41h81ixvl9TBbd13ewWSw//o/J
        4v+eHewWS7feZHTg87jc18vksXPWXXaPzSu0PDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1Zxejx
        eZOcR/uBbqYArigum5TUnMyy1CJ9uwSujHcXvjEVdHBWfHrA18B4nb2LkZNDQsBE4sDG22wg
        tpDAbkaJw+0VEHFpiesbJ0DVCEus/PecHaLmFaPEnasJIDabgK7EjsVtYL0iQPbZhS8Yuxi5
        OJgFJjBLnLg3kwXEERJ4yiixYcsnZpAqTgEjiTUrDzGC2MICQRL/ex4CdXNwsAioSnx6Ahbm
        FbCU2HGslQXCFpQ4OfMJC0gJs4CeRNtGsBJmAXmJ7W/nMEPcpiDx8+kyVogb3CTuH5zBAlEj
        LnH0Zw/zBEbhWUgmzUKYNAvJpFlIOhYwsqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/d
        xAiOXS3NHYyXl8QfYhTgYFTi4T1wbWKcEGtiWXFl7iFGCQ5mJRHeJ+VAId6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4rxP845FCgmkJ5akZqemFqQWwWSZODilGhjjLI4/DDJ4/fx+71uPrxdKTry+
        oR15o8K2KoJ7zarXsxyO37eamMz77fcM3vApC97uXe9UOPml720BrVnH7+sWPTh8enmh8MVr
        GzOrpfaxTW+rllsr9e/uk5YJy7Xfuv9ZGdbNJCGwflGhjIrNv5OMXtd7n3F8rvFcmDBL38mE
        YUrtg41hHzesVGIpzkg01GIuKk4EAORK9mLZAgAA
X-CMS-MailID: 20200412162459epcas5p299fae74f80ad5ec2f68a9df865b4bff2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200412074218epcas5p3ef7973c8a47533a15a359b069da8003c
References: <20200412073159.37747-1-alim.akhtar@samsung.com>
        <CGME20200412074218epcas5p3ef7973c8a47533a15a359b069da8003c@epcas5p3.samsung.com>
        <20200412073159.37747-5-alim.akhtar@samsung.com>
        <20200412080947.GA6524@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Christoph,

> -----Original Message-----
> From: Christoph Hellwig <hch@infradead.org>
> Sent: 12 April 2020 13:40
> To: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: robh@kernel.org; devicetree@vger.kernel.org;
linux-scsi@vger.kernel.org;
> linux-samsung-soc@vger.kernel.org; martin.petersen@oracle.com; linux-
> kernel@vger.kernel.org; krzk@kernel.org; kwmad.kim@samsung.com;
> avri.altman@wdc.com; cang@codeaurora.org; Seungwon Jeon
> <essuuj@gmail.com>; stanley.chu@mediatek.com; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH v5 4/5] scsi: ufs-exynos: add UFS host support for
Exynos
> SoCs
> 
> On Sun, Apr 12, 2020 at 01:01:58PM +0530, Alim Akhtar wrote:
> > This patch introduces Exynos UFS host controller driver, which mainly
> > handles vendor-specific operations including link startup, power mode
> > change and hibernation/unhibernation.
> 
> So this doesn't actually require the various removed or not added quirks
after
> all?
This driver is actual consumer of those quirks, so those are still needed.
On Martin's 5.7/scsi-queue need to revert " 492001990f64 scsi: ufshcd:
remove unused quirks"

