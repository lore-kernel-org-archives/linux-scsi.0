Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9496AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 00:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70C4C208C3
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 00:20:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UKRVppsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgFSAUG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Jun 2020 20:20:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44971 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728711AbgFSAUF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2020 20:20:05 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200619002002epoutp044846ee5c15a81f2923722ca1eb69762b~ZyfYwKKa40101501015epoutp04-
        for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2020 00:20:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200619002002epoutp044846ee5c15a81f2923722ca1eb69762b~ZyfYwKKa40101501015epoutp04-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592526002;
        bh=qllPWHtyQDpgVZtZhXrldNZVcdedGzFgcgGqEa7an5o=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=UKRVppslD2a8bk98GG+1UAqZiClJhTZiI0FTIk8fFXxEVT+pscZoSbMkDtKkGhcaY
         tUIPVLLgPKTfSUHw/AUrs9UFq7dgeQyCn3wBUm1rn/l/C7Ig8UF1nrOJCJfyeLXxZ8
         1rF/+t/8LBULMjRIDErWUmLmeXFoWAhe23vOeeb8=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p3.samsung.com
        (KnoxPortal) with ESMTP id
        20200619002001epcas1p354c155552aba2b742c752d5cf91908d9~ZyfYG_78R0349603496epcas1p3q;
        Fri, 19 Jun 2020 00:20:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
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
In-Reply-To: <SN6PR04MB4640A9A9A78456A1A9AB827AFC9B0@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01592526001702.JavaMail.epsvc@epcpadp1>
Date:   Fri, 19 Jun 2020 09:16:40 +0900
X-CMS-MailID: 20200619001640epcms2p130129f48c57b56c8ae802cc9e2570225
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <SN6PR04MB4640A9A9A78456A1A9AB827AFC9B0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <SN6PR04MB4640114902AEFE69CCC54C01FC9A0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
        <1210830415.21592444702291.JavaMail.epsvc@epcpadp1>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p1>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > +
> > > > +static struct ufshpb_map_ctx *ufshpb_get_map_ctx(struct ufshpb_lu
> > *hpb)
> > > > +{
> > > > +       struct ufshpb_map_ctx *mctx;
> > > > +       int i, j;
> > > > +
> > > > +       mctx = mempool_alloc(ufshpb_drv.ufshpb_mctx_pool, GFP_KERNEL);
> > > > +       if (!mctx)
> > > > +               return NULL;
> > > So you use ufshpb_host_map_kbytes as the min_nr in your
> > mempool_create,
> > > But you know that you need max_lru_active_cnt x srgns_per_rgn such
> > mapping context elements.
> > > So you are
> > > a) failing to provide the slab allocator an information that you already have,
> > and
> > > b) selecting from a finite pool will assure that you'll never exceed max-
> > active-regions,
> > >    even if some corner case fails your logic.
> > It was intend to provide user-configurable pre-allocated memory to reduce
> > latency due to memory allocation. The value of ufshpb_host_map_kbytes can
> > be set to max_lru_active_cnt x srgns_per_rgn, if the user want to.
> Ok, I see your point.
> It is as if you expect that a "user" will query the unit descriptors first,
> Make some calculations, and then will run modprobe with the proper value.
> Are you assuming that an "intelligent" user does all that?
> 
> The reasonable scenario IMO, is that OEMs will initiate a service in their
> ramdisk/init.rc with some default value.
> 
> Don't you see the damage potential in using a wrong value here?
> 
I understand your scenario. I will remove module parameter and set min_nr
value of memory pool as "max_lru_active_cnt x srgns_per_rgn" size.

Thanks,
Daejun
