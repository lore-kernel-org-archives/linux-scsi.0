Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 064B8C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 01:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9FD32070B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 01:28:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PAtzzUaO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgGMB2F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 21:28:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51284 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgGMB2F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jul 2020 21:28:05 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200713012802epoutp04fd2604d13c710410b89047d2a2098e6b~hK5nDneiL0694006940epoutp04L
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:28:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200713012802epoutp04fd2604d13c710410b89047d2a2098e6b~hK5nDneiL0694006940epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594603682;
        bh=CLT1OPkpGw1YjUHnIfrbYqXwcJBpjvqV4GFZIs43Tkc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=PAtzzUaOfXzSe3lfvOa9VgpIjXXFqlgYp1tBMjxNAB08alge2F0XaEnA0zRNW4spL
         l/0zr11UMd9GYLdzufQmXDoo3aQl8t6nOzCNT2N5/1xsgQdiG+pcRp5DUqtx2nVVKg
         jAm+z3690rxz4SfI2xWKZxEeWa/MaJ40YeOuop/4=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p4.samsung.com
        (KnoxPortal) with ESMTP id
        20200713012801epcas1p4b12b1038a5f2c4f926a5aa7eb88d13e1~hK5mm-H4Z0233102331epcas1p44;
        Mon, 13 Jul 2020 01:28:01 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <91dcecde-dd0d-c930-7c45-56ba144e748c@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21594603681971.JavaMail.epsvc@epcpadp2>
Date:   Mon, 13 Jul 2020 10:27:17 +0900
X-CMS-MailID: 20200713012717epcms2p78e1607a05f5aa19a2aa22399f10f116c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4
References: <91dcecde-dd0d-c930-7c45-56ba144e748c@acm.org>
        <SN6PR04MB464097E646395C000C2DCAC3FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
        <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
        <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
        <336371513.41594280882718.JavaMail.epsvc@epcpadp2>
        <SN6PR04MB464021F98E8EDF7C79D6CB4FFC640@SN6PR04MB4640.namprd04.prod.outlook.com>
        <CGME20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4@epcms2p7>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> > Bart - how do you want to proceed?
> 
> Hi Avri and Daejun,
> 
> As far as I can see none of the five patches have Reviewed-by tags yet. I
> think that Martin expects formal reviews for this patch series from one or
> more reviewers who are not colleagues of the author of this patch series.
> 
> Note: recently I have been more busy than usual, hence the delayed reply.
Thank you for replying to the email even though you are busy.

Arvi, Bean - if patches looks ok, can this series have your reviewed-by tag?

Thanks,
Daejun
