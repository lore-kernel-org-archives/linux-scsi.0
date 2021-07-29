Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820EBC4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68CB960527
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhG2A6J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 20:58:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28292 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbhG2A6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 20:58:08 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210729005804epoutp032d5d19718089e759a6a04c15fbb96d72~WHRNLgfXl0148501485epoutp03c
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210729005804epoutp032d5d19718089e759a6a04c15fbb96d72~WHRNLgfXl0148501485epoutp03c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627520284;
        bh=wWBiHfqrwBb5ygsTgkxffJ6/w/HAizByv73RPm0yy/s=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=s+O9vr4mcbt4uWBF8XjRyloix5/mWhIm6Nkqk2NdBug+67KenN9FopVef89ilXPLX
         wJ9UJtuWE6HKcXMPWwUoIURvKlGCJVe6t6v0DbbquahBUticj7R2sshP9u2z5huuuu
         bUEpFypX7jIcalpOZk0uWGgwiqIpA9oMR1a2QgyQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210729005803epcas3p1c87d6775b029bfd32181c386f3bbec0b~WHRMt63kd1796217962epcas3p1Y;
        Thu, 29 Jul 2021 00:58:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4GZsZz3g8Sz4x9Q5; Thu, 29 Jul 2021 00:58:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 03/18] scsi: ufs: Only include power management code
 if necessary
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-4-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1381713434.61627520283503.JavaMail.epsvc@epcpadp4>
Date:   Thu, 29 Jul 2021 09:56:52 +0900
X-CMS-MailID: 20210729005652epcms2p8bb77b9568fe122a8586ba40b49ba3fbe
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033513epcas2p22e4c2e6ea644992ede2739ebe381d53f
References: <20210722033439.26550-4-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033513epcas2p22e4c2e6ea644992ede2739ebe381d53f@epcms2p8>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,
 
>This patch slightly reduces the UFS driver size if built with power
>management support disabled.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
