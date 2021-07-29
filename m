Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0511C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 01:00:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D6E160F23
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 01:00:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhG2BAI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 21:00:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46911 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhG2BAH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 21:00:07 -0400
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210729010003epoutp01945f30c5a38ca5b2729405f6691f4589~WHS83p55Q0174601746epoutp01s
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 01:00:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210729010003epoutp01945f30c5a38ca5b2729405f6691f4589~WHS83p55Q0174601746epoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627520404;
        bh=nsHWm7siuj6X9DeJKRLdqlAV79LHd6653ZlBm9s7+W4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=mtF3BMts7AVsBZ/1tZrMGCi6hizgQvmN5ljnA1RjCOOkuacR2Xp1kSQI5bB3cNc6w
         iTfo3B6timG/DxrSntXtAGfzrIQhhGbFdOTmndJTe/qsOpxKU5FAocMAQcEmDFza97
         hb3Tbj1hjKe135f7mFnIexuF0cjG5urPykm9/Jl0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210729010002epcas3p3726e3767e9baaeffd05200f5d18b184a~WHS7gHA2I0885608856epcas3p3w;
        Thu, 29 Jul 2021 01:00:02 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp1.localdomain
        (Postfix) with ESMTP id 4GZsdG2fpyz4x9QH; Thu, 29 Jul 2021 01:00:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 08/18] scsi: ufs: Improve static type checking for
 the host controller state
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-9-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01627520402353.JavaMail.epsvc@epcpadp3>
Date:   Thu, 29 Jul 2021 09:57:22 +0900
X-CMS-MailID: 20210729005722epcms2p1e4543ff65b25ff23c62b501c1856ecf5
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033531epcas2p4a4a975689ad7966d3db56dd81a7a255f
References: <20210722033439.26550-9-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033531epcas2p4a4a975689ad7966d3db56dd81a7a255f@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Assign a name to the enumeration type for UFS host controller states and
>remove the default clause from switch statements on this enumeration type
>to make the compiler warn about unhandled enumeration labels.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
