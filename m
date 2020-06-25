Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE66C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 00:28:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D98D20707
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 00:28:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EgIjsy4i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388778AbgFYA2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 20:28:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30788 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388665AbgFYA2F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 20:28:05 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200625002802epoutp02bd1e4f02b52bc65b3cd29624db9ee0f4~boeFQ38-91095410954epoutp02-
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2020 00:28:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200625002802epoutp02bd1e4f02b52bc65b3cd29624db9ee0f4~boeFQ38-91095410954epoutp02-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593044882;
        bh=7IZmdj+FZkoGAji8ipF6nQxQP/nCDW3lsFFYgG8+3YY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=EgIjsy4ir/VQN0gqG9PVJ7jHp7pfQlh8lx1lKxEymkUjUGMlogrUbK6+85kHE4U1x
         9FQdpBHvGwTMD1J+G9ghpqbtxg8cJoDGN8FyiTIVJZoQ16KTyxg0tAYVACmXy5JZzS
         OPtfHT5MPEll7o4gLfqiBBtuJqebFKrZjkAFQ62A=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200625002801epcas1p33be6bcbdf0266b8d56c2122fc7f4ae50~boeEvPpcs1986819868epcas1p3R;
        Thu, 25 Jun 2020 00:28:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH v3 4/5] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <SN6PR04MB46409F94E8C0690B2E227B34FC950@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01593044881689.JavaMail.epsvc@epcpadp2>
Date:   Thu, 25 Jun 2020 09:18:25 +0900
X-CMS-MailID: 20200625001825epcms2p34281d13498b9265155382e20192bde24
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200623010201epcms2p11aebdf1fbc719b409968cba997507114
References: <SN6PR04MB46409F94E8C0690B2E227B34FC950@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01592884981694.JavaMail.epsvc@epcpadp2>
        <963815509.21592884502243.JavaMail.epsvc@epcpadp1>
        <231786897.01592884381695.JavaMail.epsvc@epcpadp2>
        <963815509.21592879582091.JavaMail.epsvc@epcpadp2>
        <231786897.01592886181765.JavaMail.epsvc@epcpadp2>
        <CGME20200623010201epcms2p11aebdf1fbc719b409968cba997507114@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>  static struct ufshpb_driver ufshpb_drv;
> > +unsigned int ufshpb_host_map_kbytes = 1 * 1024;
> I think you've already declared this as a module parameter in 3/5.
> 
> No need to fix this now, unless there will be some more comments,
> And you'll issue a v4.

OK, thanks!
