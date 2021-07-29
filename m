Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD97BC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 01:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB2526103A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 01:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhG2B2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 21:28:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15105 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhG2B2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 21:28:06 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210729012802epoutp039776e686a8f084930af3b822effc53cf~WHrYJF59g2806428064epoutp03b
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 01:28:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210729012802epoutp039776e686a8f084930af3b822effc53cf~WHrYJF59g2806428064epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627522082;
        bh=31iX16CBWLFffzW+Do3lRqnaqapPbnbBLZt6+oQEuj4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=l6gVxePYBdErPKyvCd2A2c5rtdTlWPUjTgCvdv9LxmLK8IgwGE/UAxGwS+d1l4w6A
         iqMGxKtBaHNAcfPcZ7N+Uc86/i89ZHojTC6npmSiIecwEP5BqH5cbOJuOZdqDMp6lE
         jB7Exlu603kI1CEcz2p8s+PJ11+ezmp8YpeQYEZI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210729012801epcas3p1aad0f83e1dbf21b5661e71db0fc6cc26~WHrXlTw-Q0457604576epcas3p1V;
        Thu, 29 Jul 2021 01:28:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4GZtFY6KpNz4x9Pw; Thu, 29 Jul 2021 01:28:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 09/18] scsi: ufs: Remove several wmb() calls
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-10-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21627522081850.JavaMail.epsvc@epcpadp4>
Date:   Thu, 29 Jul 2021 10:24:58 +0900
X-CMS-MailID: 20210729012458epcms2p5885e48fd27efb576cec7bd6b9f7771d7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033536epcas2p133eef1f5e2e5a1022ccef23e9c1035aa
References: <20210722033439.26550-10-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033536epcas2p133eef1f5e2e5a1022ccef23e9c1035aa@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>From arch/arm/include/asm/io.h
> 
>  #define __iowmb() wmb()
>  [ ... ]
>  #define writel(v,c) ({ __iowmb(); writel_relaxed(v,c); })
> 
>From Documentation/memory-barriers.txt: "Note that, when using writel(), a
>prior wmb() is not needed to guarantee that the cache coherent memory
>writes have completed before writing to the MMIO region."
> 
>In other words, calling wmb() before writel() is not necessary. Hence
>remove the wmb() calls that precede a writel() call. Remove the wmb()
>calls that precede a ufshcd_send_command() call since the latter function
>uses writel(). Remove the wmb() call from ufshcd_wait_for_dev_cmd()
>since the following chain of events guarantees that the CPU will see
>up-to-date LRB values:
>* UFS controller writes to host memory.
>* UFS controller posts completion interrupt after the memory writes from
>  the previous step are visible to the CPU.
>* complete(hba->dev_cmd.complete) is called from the UFS interrupt handler.
>* The wait_for_completion(hba->dev_cmd.complete) call in
>  ufshcd_wait_for_dev_cmd() returns.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
