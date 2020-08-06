Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0E86C433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 23:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E711F2075A
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 23:18:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="I6hCyl8D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgHFXSG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 19:18:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27695 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgHFXSG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 19:18:06 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200806231803epoutp0268dba81eafd41bc96a7db5ca98399f11~o0QP-jIiu1705317053epoutp02B
        for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2020 23:18:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200806231803epoutp0268dba81eafd41bc96a7db5ca98399f11~o0QP-jIiu1705317053epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1596755883;
        bh=qepv6a95XKs0GXbFbCftAQvu650mnE1KSc7vk4o8Kps=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=I6hCyl8D5+y+Hpa44/4D9sBvXOUL6yFoI3RbgWsEU9vkOmnFh9OZZqwuQHoEn+418
         k+yMrEax4y5zp8wegtM6ZUBBetBZ04gVDzlk5RsvdJ3yzeoHn6CysHqTOkOQgJXPRn
         qQzMemYpaJwuM/RKM4vGawMdJo1UptuwD+m7MK9I=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200806231802epcas1p1b3ef4ff58eea9597465a8a6e8db93164~o0QPf4l8j2976929769epcas1p12;
        Thu,  6 Aug 2020 23:18:02 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v8 0/4] scsi: ufs: Add Host Performance Booster Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
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
In-Reply-To: <SN6PR04MB464069DD70022FC3C55265B6FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <963815509.21596755882463.JavaMail.epsvc@epcpadp2>
Date:   Fri, 07 Aug 2020 08:15:37 +0900
X-CMS-MailID: 20200806231537epcms2p504703655baf8e6962ea099fb907ab9bc
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d
References: <SN6PR04MB464069DD70022FC3C55265B6FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
        <7c59c7abf7b00c368228b3096e1bea8c9e2b2e80.camel@gmail.com>
        <SN6PR04MB4640CE297AAB3CF4D37EE002FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
        <39c546268abead68f4c00f17dc47c1597f3e0273.camel@gmail.com>
        <SN6PR04MB4640210D586CBA053F56DCF0FC480@SN6PR04MB4640.namprd04.prod.outlook.com>
        <e3aba7fba7c208ac58c638139bd615c871d2e52e.camel@gmail.com>
        <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p5>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,
> > 
> > On Thu, 2020-08-06 at 10:12 +0000, Avri Altman wrote:
> > > > >
> > > >
> > > > we didn't see you Acked-by in the pathwork, would you like to add
> > > > them?
> > > > Just for reminding us that you have agreed to mainline this series
> > > > patchset.
> > >
> > > I acked it - https://protect2.fireeye.com/v1/url?k=0669baeb-5ba5764e-066831a4-0cc47a30d446-27c87d7023437946&q=1&e=cf195d42-fec6-43bb-b797-203c71fd6665&u=https%3A%2F%2Fwww.spinics.net%2Flists%2Flinux-scsi%2Fmsg144660.html
> > > And asked Martin to move forward -
> > > https://protect2.fireeye.com/v1/url?k=f5035541-a8cf99e4-f502de0e-0cc47a30d446-b2b42329eddc02dc&q=1&e=cf195d42-fec6-43bb-b797-203c71fd6665&u=https%3A%2F%2Fwww.spinics.net%2Flists%2Flinux-scsi%2Fmsg144738.html
> > > Which he did, and got some sparse errors:
> > > https://protect2.fireeye.com/v1/url?k=242040ce-79ec8c6b-2421cb81-0cc47a30d446-4d1c0f96a36b8f4d&q=1&e=cf195d42-fec6-43bb-b797-203c71fd6665&u=https%3A%2F%2Fwww.spinics.net%2Flists%2Flinux-scsi%2Fmsg144977.html
> > > Which I asked Daejun to fix -
> > > https://protect2.fireeye.com/v1/url?k=44587fa8-1994b30d-4459f4e7-0cc47a30d446-d01ce202f9a3c6b5&q=1&e=cf195d42-fec6-43bb-b797-203c71fd6665&u=https%3A%2F%2Fwww.spinics.net%2Flists%2Flinux-scsi%2Fmsg144987.html
> > >
> > > For the next chain of events I guess you can follow by yourself.
> > >
> > > Thanks,
> > > Avri
> > 
> > Avri
> > Sorry for making you confusing. yes, I knew that, and following.
> > I mean Acked-by tag in the patchset, then we see your acked in the
> > patchwork, and let others know that you acked it, rather than going
> > backtrack history email.
> > 
> > Hi Daejun
> > I think you can add Avri's Acked-by tag in your patchset, just for
> > quickly moving forward and reminding.
> Ahhh - One moment please - 
> While rebasing the v8 on my platform, I noticed some substantial changes since v6.
> e.g. the hpb lun ref counting isn't there anymore, as well as some more stuff.
> While those changes might be only for the best,  I think any tested-by tag should be re-assign.

In this version, the HPB is no more loadable module, it is sticked with
UFS-core driver. So, I removed reference counter for HPB.

> Anyway, as for myself, I am not planning to put any more time in this,
> until there is a clear decision where this series is going to.
> 
> Martin - Are you considering to merge the HPB feature eventually to mainline kernel?
> 
> Thanks,
> Avri
> > 
> > thanks,
> > Bean
> 
> 
Thanks,
Daejun
