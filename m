Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CBCC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 01:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D176A22229
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 01:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="CvHGAf1y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732667AbgFRBpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:45:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27877 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733131AbgFRBpF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 21:45:05 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200618014503epoutp01649e82bf254d50a6eb906b771bf3dce1~ZgAVBAhbh1482214822epoutp01E
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2020 01:45:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200618014503epoutp01649e82bf254d50a6eb906b771bf3dce1~ZgAVBAhbh1482214822epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592444703;
        bh=LHnFRCa4HDOWm0RYymVWN7YfXGnU6fTOFZfK3I3tHJw=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=CvHGAf1yR63wrrquyBdw2Lpy0+bi+SpSQ1HYg5ZS0b6T2BoMjNAfM1xbn+VSaxZki
         vCMdtuGTpJzdLIQfQ6IrXQUZEwH4vLsLWFvjZ1+mwdWHWnEEZ2MpTHrqMLFWOCV1+K
         VVs/vE5aLkZEPXl8yzjSdIqcNv5JwUOMSn+H8IzM=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p4.samsung.com
        (KnoxPortal) with ESMTP id
        20200618014502epcas1p456f39db093eac2a257a8b443772238d9~ZgAUS8Bj62175421754epcas1p4e;
        Thu, 18 Jun 2020 01:45:02 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [RFC PATCH v2 3/5] scsi: ufs: Introduce HPB module
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
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
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <3d5748ce4481c789000979f9831a5ae681cd9d34.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <717176949.41592444702525.JavaMail.epsvc@epcpadp1>
Date:   Thu, 18 Jun 2020 10:06:04 +0900
X-CMS-MailID: 20200618010604epcms2p324800aa16fc9de874116c27b00b07c54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <3d5748ce4481c789000979f9831a5ae681cd9d34.camel@gmail.com>
        <SN6PR04MB46405EC52240E00F5D634E2AFC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <231786897.01592395081831.JavaMail.epsvc@epcpadp2>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > implemented
> > > > as a module parameter, so that it can be configurable by the
> > > > user.
> > > > 
> > > > To gurantee a minimum memory pool size of 4MB:
> > > > $ insmod ufshpb.ko ufshpb_host_map_kbytes=4096
> > > 
> > > You are going through a lot of troubles to make it a loadable
> > > module.
> > > What are, in your opinion, the pros and cons of this design
> > > decision?
> > 
> > In my opinion...
> > 
> > pros:
> > 1. A user can unload an unnecessary module when there is an
> > insufficient
> > memory situation (HPB case).
> > 2. Since each UFS vendor has a different way of implementing UFS
> > features,
> > it can be supported as a separate module. Otherwise, many quirks must
> > be attached to module, which is not desirable way.
> > 3. It is possible to distinguish parts that are not necessary for
> > essential
> > ufs operation.
> > 4. It is advantageous to implement the latest functions according to
> > the
> > development speed of UFS.
> > 
> > cons:
> > 1. It is difficult work to be implemented as a module.
> > 2. Modifying "ufsfeature.c" is required to implement the feature that
> > can
> > not supported by the exsiting "ufsf_operation".
> > 
> > Thanks,
> > Daejun
> 
> Dear Avri, Daejun, Bart
> 
> It is true that it is very difficult to make everyone happy.
> We now have three HPB drivers in the patchwork, but I still didn't see
> a final agreement. Please tell me which one do you want to focus on?
The HPB driver has been greatly improved in the process of being applied to
mobile devices since the release of the first HPB version in openMPDK. We
want to contribute to the linux mainline with the knowledge obtained
through the experience.
I find it difficult to make everyone happy, but I think it is possible that
everyone can accept the HPB driver through several revisions.

Thanks,
Daejun
