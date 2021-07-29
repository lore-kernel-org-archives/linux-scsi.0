Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23679C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 01:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DFF26103A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 01:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhG2B2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 21:28:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32352 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbhG2B2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 21:28:06 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210729012802epoutp0134b56e7267ade0ae3697744d025b5613~WHrYdaRwU2547925479epoutp01K
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 01:28:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210729012802epoutp0134b56e7267ade0ae3697744d025b5613~WHrYdaRwU2547925479epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627522082;
        bh=WzdIPXlft7/OFpH9NKbzflmeKiAe6dUJINLgwLFCHsc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=oO9pBRVwadk2VizNNOLZpqm/yS3GLbe8e1lHgyGzAfGuKUna1vWdtyrkPj1Utes7Y
         vUYl9YgMDLHkTIDcdJxxJo5ECUGh4YEFkPYjh+K9km29knRJ9iP/IyBX9n+3OPNVpS
         lc11xteQnQo4dTuV40cAOs61/SlcUDBgP6vPUJK0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210729012802epcas3p1f59893112269dca7af55a79613247eec~WHrX4tOrT0457604576epcas3p1a;
        Thu, 29 Jul 2021 01:28:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4GZtFZ1TD4z4x9QB; Thu, 29 Jul 2021 01:28:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 12/18] scsi: ufs: Optimize serialization of
 setup_xfer_req() calls
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-13-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1796371666.41627522082177.JavaMail.epsvc@epcpadp4>
Date:   Thu, 29 Jul 2021 10:25:00 +0900
X-CMS-MailID: 20210729012500epcms2p2c7976b7b4b65e997e778f9291c9c2e3f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033552epcas2p39f68ea806091ffa9755a25b778d70101
References: <20210722033439.26550-13-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033552epcas2p39f68ea806091ffa9755a25b778d70101@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Reduce the number of times the host lock is taken in the hot path.
>Additionally, inline ufshcd_vops_setup_xfer_req() because that function is
>too short to keep it.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
