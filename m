Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D65C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E27F60FD7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhG2A6K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 20:58:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63152 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhG2A6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 20:58:08 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210729005804epoutp0253558c485d7800e32dceef5265214043~WHROAetWd0166001660epoutp02X
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210729005804epoutp0253558c485d7800e32dceef5265214043~WHROAetWd0166001660epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627520284;
        bh=ZJq34MoG2V6IAKA8hoHAqxq+UsHCZb+emd+W9MVSItc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=k2irI7WMrcWHVqfV7EuZNRBLyfvZedDR6OafWgH3qoDPtqyijAJCqWr1YAzGgYzSr
         Qb1p/IA8LQRFQ2BbYM+J76Jy43k3lVlGUjfItpAI1faXlqEDqIocu573/nChD//XeH
         tooEErIMJo9IfPGQXI1hzSJ4FARzE+hdcuOaa3Qg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210729005804epcas3p167c070d4157fc9aef04d004ba272e933~WHRNmsNcL0831108311epcas3p1x;
        Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4GZsb03LPxz4x9QG; Thu, 29 Jul 2021 00:58:04 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 05/18] scsi: ufs: Use DECLARE_COMPLETION_ONSTACK()
 where appropriate
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
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-6-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1150284200.161627520284458.JavaMail.epsvc@epcpadp4>
Date:   Thu, 29 Jul 2021 09:57:07 +0900
X-CMS-MailID: 20210729005707epcms2p779e83f1000601c7583376659d482f753
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033523epcas2p22ea9a4afaeb46870638ff4429010a3c1
References: <20210722033439.26550-6-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033523epcas2p22ea9a4afaeb46870638ff4429010a3c1@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>From Documentation/scheduler/completion.rst: "When a completion is declared
>as a local variable within a function, then the initialization should
>always use DECLARE_COMPLETION_ONSTACK() explicitly, not just to make
>lockdep happy, but also to make it clear that limited scope had been
>considered and is intentional."

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
