Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7626C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 00:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C71A720720
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 00:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MryOQnvU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgGMAIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 20:08:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55822 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbgGMAIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jul 2020 20:08:05 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200713000802epoutp027c425bb8f6ab23bee2eca0dc61f436c6~hJzwapk0B0881008810epoutp02t
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:08:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200713000802epoutp027c425bb8f6ab23bee2eca0dc61f436c6~hJzwapk0B0881008810epoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594598882;
        bh=R4PAN69ucimjy2ioirWdXkfKM+7E7GcFNAK7iRR5aYA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=MryOQnvUKc6xgcBsbwqEWireYlKh6UldzNDZLThj5MaORU0MYLVMisufCzqvtljMp
         Bbd4Y6jRK/RQRb9rlDDYWtNjZy9dIJYyFEeWksiWcndWrDCNUmrDfJNTP79kuo/pl8
         g9RnlI7orirqx42cVINBpO5tH//+cVRijfw8dSP8=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200713000801epcas1p20f7460052175851ae2c2de394cf1de81~hJzv5bLzA2422624226epcas1p2x;
        Mon, 13 Jul 2020 00:08:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
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
In-Reply-To: <SN6PR04MB464021F98E8EDF7C79D6CB4FFC640@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01594598881549.JavaMail.epsvc@epcpadp2>
Date:   Mon, 13 Jul 2020 09:04:41 +0900
X-CMS-MailID: 20200713000441epcms2p88ed3e29e0d7f36f9373b803b4cf6a5cf
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4
References: <SN6PR04MB464021F98E8EDF7C79D6CB4FFC640@SN6PR04MB4640.namprd04.prod.outlook.com>
        <SN6PR04MB464097E646395C000C2DCAC3FC640@SN6PR04MB4640.namprd04.prod.outlook.com>
        <963815509.21593732182531.JavaMail.epsvc@epcpadp2>
        <231786897.01594251001808.JavaMail.epsvc@epcpadp1>
        <336371513.41594280882718.JavaMail.epsvc@epcpadp2>
        <CGME20200702231936epcms2p81557f83504ef1c1e81bfc81a0143a5b4@epcms2p8>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> > Hello,
> > > >
> > > > Just a gentle reminder that I'd like some feedback.
> > > > Any suggestions here?
> > > If no-one objects, I think you can submit your patches for review as non-
> > RFC.
> > >
> > [PATCH v5 0/5] scsi: ufs: Add Host Performance Booster Support
> > ~~~~~~
> > It is non-RFC version.
> Oops - sorry.  I was in RFC state of mind.
> 
> Bart - how do you want to proceed?
> 
> Thanks,
> Avri
> 
> > 
> > Thanks,
> > Daejun.

Avri and I are waiting for your comments.
I hope to receive your mail soon.

Thanks,
Daejun
