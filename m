Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7B1C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 05:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 800F223426
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 05:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgLQFWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 00:22:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:62505 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgLQFWY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 00:22:24 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201217052141epoutp04253270c1157f586a22bcdf74af4f9f0f~RaXcGJ--K3001430014epoutp04O
        for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2020 05:21:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201217052141epoutp04253270c1157f586a22bcdf74af4f9f0f~RaXcGJ--K3001430014epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608182501;
        bh=ZJRr9ThMl7AYnQwkCkiO6B/tFmxcwl1/SNo1SXc5SDY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=jmGIlfWM4VKlCmpGzbWbN0soBUQXTz0a/UA+mRE/QLrpUpsNuMv+DkOkWpAURyoBN
         UPYEprPFRQ4Cwp9Ztf841hfA8gmfJr8l+pttpZGzxBxUmDHsM+fXoH+BQt0pWc51ui
         JCZDwJjCjOvQKHBRX3dYBhTjbzH934m57+PJwN2Y=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201217052140epcas2p3fdc76c9654b075c8dd0202cb67afdb42~RaXbNfqcl1344713447epcas2p3c;
        Thu, 17 Dec 2020 05:21:40 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.181]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CxL2W0cnQz4x9Q4; Thu, 17 Dec
        2020 05:21:39 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-0d-5fdaeae141d3
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        6E.24.52511.1EAEADF5; Thu, 17 Dec 2020 14:21:37 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: Subject: [PATCH v14 1/3] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
In-Reply-To: <X9nM5b4xK+QSFLpq@kroah.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20201217052136epcms2p175d2c38536ad1b83e7b24c190d3346d8@epcms2p1>
Date:   Thu, 17 Dec 2020 14:21:36 +0900
X-CMS-MailID: 20201217052136epcms2p175d2c38536ad1b83e7b24c190d3346d8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA12Te0xTZxjG951zOC1sJYda9RN1klM2wUBpkbJPAgxvy5nOjEnGMpJZz+Bw
        iaVtegpDiRtMQS6ClThwFZVLVgdjazEUCmSDtYaBmbt1KkWcGG+BBWReJrBg1lKYZv89+eV5
        8z7PdxHiYjcZLMzRGDi9hlXTZADR6QxXRt6cGFHJn3SvR+3XJ/zQ2JlOEn1bOihA47OXSeS8
        NiVAtdOzOHpgMfuhcUc4ah17Dx1qtpCo/lIRhqqO2UjUNNyJIVdPPYkqr9pJdO6Hpxi61hGA
        vrC5ASqvayNQU2MvkSRhXL/vZFzVVRjTbbouYIxN/YDpO90mYA4P9RHMX3dGCKa6oxUwD8+/
        zBzpr8SSA9LU8dkcm8HpQzhNujYjR5OVQO9MUW1VKWPlikjFJvQaHaJhc7kEettbyZFv5Kg9
        5eiQfFad50HJLM/TUYnxem2egQvJ1vKGBJrTZah1CoVOxrO5fJ4mS5auzY1TyOXRSo9zrzq7
        tKIE09XiBcVDh/2KgBWrAEIhpGJguUtUAfyFYsoOYN/PlBeLqCA4b1/mxcuoHfCzu7V+PgsN
        Lb+aBD4ugyM324BXk1QErBu8IfCOSqjd0FUrrwABQpxqJaF5aGhhFlIiePLIHcKnV8Ouczbg
        9ftT4dDY96YPh8EZcxXu08uh+6tJwZK+P3AW+LQElvxxadETBMdmexf5KjjQO4359CfQNjoH
        vBkgdRRAZ/fIYoYoeKWsnfBV3AVtbt6LCeoVOHOvjPRZtsGLdTULe3FqHeyarMe9dtwT09IT
        5TszKbwwQiyVKmr/R/B/jVOBsMw5/x+3n7m9mOxV+M2sBTMCqenZMZue22V6tqsB4K1gBafj
        c7M4PloX8/y9ngcLb3wDYwenJqdlDoAJgQNAIU5LRHv73SqxKIPdf4DTa1X6PDXHO4DS0/I4
        Hrw8Xev5JBqDSqGMjo2Vb1IiZWw0oleK3m2pVompLNbA7eM4HadfmsOE/sFFWMRlUNt86/7k
        Due6g1ph48N9JwK31IzqVxofJ3YMm02v77eWJhWkdO7J5J2pB8+K6kUaV7escaDyy6D0bO1P
        xza+nSSNGf5849rjHQfYYnN5Uve4Cf9AkuIeFxOJHdYaZ9ZaU7E1tDNw++a6/BfDaj40OHtv
        rPhxBo7WfScrvL1bcW9Lwy/DU4+e7LrVIA27wISGPpUrS3riP2o7Kcm/+CButiDNatS6/Cev
        JKxKS/54uj3ksfWFu2rt9/NRaySZh/7sGUy32965upqRdzWscWw2P5LtkX6a16I/8TX4O7Sl
        MGa9zLE104JHtb4/ITfOzf2mT21uj4uYcrJHY1IzBl4q5GmCz2YVG3A9z/4LECJwx2wEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306
References: <X9nM5b4xK+QSFLpq@kroah.com>
        <20201216024444epcms2p5e69281911dd675306c473df3d2cef8b2@epcms2p5>
        <20201216024532epcms2p22b8aadbce9f0d2aae7915bdf22e2fe8f@epcms2p2>
        <CGME20201215082235epcms2p88c9d8fd4dc773f6a4901dab241063306@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 16, 2020 at 11:45:32AM +0900, Daejun Park wrote:
> > This is a patch for the HPB initialization and adds HPB function calls to
> > UFS core driver.
> 
> <snip>
> 
> Your "subject" is odd, it has "Subject:" in it twice, did git
> format-patch create that?
> 
> thanks,
> 
> greg k-h
> 

Sorry, It is my mistake.
Should I resend this patch with proper subject?

Thansk,
Daejun
