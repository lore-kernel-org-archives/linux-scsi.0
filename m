Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13049C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 01:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFAAF60F43
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 01:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhG2BaI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 21:30:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27919 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233142AbhG2BaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 21:30:07 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210729013003epoutp0437b5824f1715caec745c5b389a7c5adb~WHtJDOC2o1475714757epoutp04z
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 01:30:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210729013003epoutp0437b5824f1715caec745c5b389a7c5adb~WHtJDOC2o1475714757epoutp04z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627522203;
        bh=nc411u8xYr70oG2ZWOibXBg/rWcbdAtPphHBq1O5BD8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=gGNlc+Uj6+1TRjjDXOYrTeJ5meZMe/j1cFQX8hi7GnBNAMyfApxfY7sxCZvlOa45i
         9e+M4GIr7LU1qjADTH05ZCWUCI8GTfCSpsFKEMrALfnL9l/nzJgE3xazVB8D6cwsB0
         gXmOQAZgq+zQ/s0UifQd1SSK4l2wZksW1UdAOMCU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210729013002epcas3p3ed64fe50b4770c37fbabf4e0ade934f1~WHtH5vLdT3174231742epcas3p3C;
        Thu, 29 Jul 2021 01:30:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4GZtHt2qXxz4x9Pr; Thu, 29 Jul 2021 01:30:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 13/18] scsi: ufs: Optimize SCSI command processing
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-14-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01627522202382.JavaMail.epsvc@epcpadp3>
Date:   Thu, 29 Jul 2021 10:25:02 +0900
X-CMS-MailID: 20210729012502epcms2p1b7b0f63eed6c4f8a73a1d086e8d22631
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033553epcas2p2818d9c1f046e8514415a72a4ddddc3db
References: <20210722033439.26550-14-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033553epcas2p2818d9c1f046e8514415a72a4ddddc3db@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Use a spinlock to protect hba->outstanding_reqs instead of using atomic
>operations to update this member variable.
> 
>This patch is a performance improvement because it reduces the number of
>atomic operations in the hot path (test_and_clear_bit()) and because it
>reduces the lock contention on the SCSI host lock. On my test setup this
>patch improves IOPS by about 1%.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
