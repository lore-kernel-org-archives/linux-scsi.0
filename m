Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7F8C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 10:28:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B3A020758
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 10:28:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Nh6bhDXl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgGMK2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 06:28:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28457 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgGMK2F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 06:28:05 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200713102801epoutp039bcb9dcb58c1864dce15409077ba2ede~hSRFaoB4G2411324113epoutp03i
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 10:28:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200713102801epoutp039bcb9dcb58c1864dce15409077ba2ede~hSRFaoB4G2411324113epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594636081;
        bh=wr0TSnSOYDrnW0OXmJJItmyosy7uPnji9OSa71BR9MQ=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Nh6bhDXlPywZVIXnBTnzFcxuxU7cGtUmpMYSTWXpGa5eFEUpxA7U0YDv7VixOhZEP
         KibD8Y8HNDexrl2p3fXKkfBS9jXXsNWd5HBfLUYR+QAuO+0dKzGYrB60dUkPVbZ5mA
         yzp+dgAqq62cZzuk/Qqp/uN+dk/0exm9TKxkzmO4=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200713102801epcas1p1c32b511ae839b91532ad5e29c8eb2277~hSRFChy_V1773917739epcas1p1I;
        Mon, 13 Jul 2020 10:28:01 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
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
In-Reply-To: <65b3b5bb56d2be8e365aae2163227aac7a71e600.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01594636081523.JavaMail.epsvc@epcpadp2>
Date:   Mon, 13 Jul 2020 19:25:20 +0900
X-CMS-MailID: 20200713102520epcms2p5834b14ea70637529588802a11cabe94c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4
References: <65b3b5bb56d2be8e365aae2163227aac7a71e600.camel@gmail.com>
        <91dcecde-dd0d-c930-7c45-56ba144e748c@acm.org>
        <SN6PR04MB464097E646395C000C2DCAC3FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
        <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
        <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
        <336371513.41594280882718.JavaMail.epsvc@epcpadp2>
        <SN6PR04MB464021F98E8EDF7C79D6CB4FFC640@SN6PR04MB4640.namprd04.prod.outlook.com>
        <963815509.21594603681971.JavaMail.epsvc@epcpadp2>
        <CGME20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4@epcms2p5>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean
> > Hi Bart,
> > 
> > > > Bart - how do you want to proceed?
> > > 
> > > Hi Avri and Daejun,
> > > 
> > > As far as I can see none of the five patches have Reviewed-by tags
> > > yet. I
> > > think that Martin expects formal reviews for this patch series from
> > > one or
> > > more reviewers who are not colleagues of the author of this patch
> > > series.
> > > 
> > > Note: recently I have been more busy than usual, hence the delayed
> > > reply.
> > 
> > Thank you for replying to the email even though you are busy.
> > 
> > Arvi, Bean - if patches looks ok, can this series have your reviewed-
> > by tag?
> > 
> > Thanks,
> > Daejun
> 
> Hi Daejun
> 
> 
> I only can give my tested-by tag since I preliminary tested it and it
> works. However, as I said in the previous email, there is performance
> downgrade comparing to the direct submission approach, also, we should
> think about HPB 2.0.

I plan to add your direct submission approach with HPB 2.0.

> Anyway, if Avri wants firstly make this series patch mainlined,
> performance fixup later, this is fine to me. I can add and fix it
> later.
> 
> BTW, you should rebase your this series set patch since there are
> conflicts with latest Martin' git repo, after that, you can add my
> tested-by tag.
> 
OK, I will. Thanks!

> Tested-by: Bean Huo <beanhuo@micron.com>
> 
> 
> Thanks,
> Bean
> 

Thanks,
Daejun
