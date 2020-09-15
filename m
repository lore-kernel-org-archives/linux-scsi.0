Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB04EC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 07:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F35420897
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 07:15:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KaE+RVno"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgIOHPG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:15:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38372 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgIOHPF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 03:15:05 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200915071502epoutp04659894db838198a19f061ee62458c145~0462TwM4C3039530395epoutp043
        for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2020 07:15:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200915071502epoutp04659894db838198a19f061ee62458c145~0462TwM4C3039530395epoutp043
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1600154102;
        bh=DduciN/JwcnwqiVl5IpPOg+0xjvc7x2ue/tjaNhaSYA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=KaE+RVnowPMqIGz9bI6lqDRt70JmC/Vz6+zjtzfbtNk7lldGHTnVEj58do3xdjZWA
         JeNpJVWiNa+uivbnR2xnhu+ZM77RjKkWj+VueS5HFJysXlQ9GFY5/kbEkC8b4r/Mhx
         tPI1AqUYVgSn4pCuLUx3xS6Olh/5zFujDJEPr2JY=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200915071501epcas1p32ec33830c4ffae37f585cb1a6220b37d~0461u7IbB0453704537epcas1p3C;
        Tue, 15 Sep 2020 07:15:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufs: Fix NOP OUT timeout value
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <BY5PR04MB6705EA7473F8971029B8372FFC200@BY5PR04MB6705.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01600154101631.JavaMail.epsvc@epcpadp1>
Date:   Tue, 15 Sep 2020 16:08:22 +0900
X-CMS-MailID: 20200915070822epcms2p860645039610710de7c5acc829d9f9862
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200902025852epcms2p2a2d4ac934f4fc09233d4272c96df9ff1
References: <BY5PR04MB6705EA7473F8971029B8372FFC200@BY5PR04MB6705.namprd04.prod.outlook.com>
        <231786897.01599016081767.JavaMail.epsvc@epcpadp2>
        <CGME20200902025852epcms2p2a2d4ac934f4fc09233d4272c96df9ff1@epcms2p8>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> > In some Samsung UFS devices, there is some booting fail issue with
> > low-power UFS device. The reason of this issue is the UFS device has a
> > little bit longer latency for NOP OUT response. It causes booting fail
> > because NOP OUT command is issued during initialization to check whether
> > the device transport protocol is ready or not. This issue is resolved by
> > releasing NOP_OUT_TIMEOUT value.
> > 
> > NOP_OUT_TIMEOUT: 30ms -> 50ms
> > 
> > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> Acked-by: Avri Altman <avri.altman@wdc.com>

Thanks for the review.

Bart,
Could you review this patch, please?

Thanks,
Daejun
