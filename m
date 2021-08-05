Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82755C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 21:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 657EA610FC
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 21:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhHEVnT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 17:43:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48955 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhHEVnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 17:43:18 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210805214302epoutp03d374096d4880b8730b53c65e3302252b~YhxNmlPPD0663206632epoutp03K
        for <linux-scsi@vger.kernel.org>; Thu,  5 Aug 2021 21:43:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210805214302epoutp03d374096d4880b8730b53c65e3302252b~YhxNmlPPD0663206632epoutp03K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1628199782;
        bh=K5iRgEqJiNNyLrU6LzBnoiXQEVtXKk2vWjzw+zqh9SI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=rvNO+mp5SRIHjF643Z42iNaVDZVcZjaqOc0+hl6FrYMFOzwUVZAG2DmrW1mW3DEpo
         dL632PWlYKUqsOgBVQuEHIICVObAo4Z9Ts/bPmrwZcYgGNuhXwBwVkrQpFu+dVsLkX
         ipKIACoGhnx8FdThXR4zzNFZwFnydtJcWlz940Ig=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20210805214302epcas3p3a89c3744509a0f4fc271b9650a2d4a54~YhxNFzQq61902219022epcas3p3G;
        Thu,  5 Aug 2021 21:43:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4GghtG0fylz4x9Pw; Thu,  5 Aug 2021 21:43:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v4 47/52] ufs: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210805191828.3559897-48-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01628199782065.JavaMail.epsvc@epcpadp4>
Date:   Fri, 06 Aug 2021 06:39:31 +0900
X-CMS-MailID: 20210805213931epcms2p1ded8a36c6ead04d0183172f7aa325cd8
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210805192017epcas2p486b21e2f00e29f9254892884bb340c40
References: <20210805191828.3559897-48-bvanassche@acm.org>
        <20210805191828.3559897-1-bvanassche@acm.org>
        <CGME20210805192017epcas2p486b21e2f00e29f9254892884bb340c40@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Prepare for removal of the request pointer by using scsi_cmd_to_rq()
>instead. This patch does not change any functionality.
> 
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good. 
Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
