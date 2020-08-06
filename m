Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9A3C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF5D92224D
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kPuygxwo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgHFS6F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 14:58:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59454 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728615AbgHFS6E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 14:58:04 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200806185802epoutp01aa004f5d25d7b10ea766f983c3b0bb51~owtOnJbGH0485604856epoutp01L
        for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2020 18:58:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200806185802epoutp01aa004f5d25d7b10ea766f983c3b0bb51~owtOnJbGH0485604856epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1596740282;
        bh=0CUPozoJxgZ/+ZdJILzBOZVCWR6NdezQpSnjAUwVyU4=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=kPuygxwooEgX6AMHSEzrWxr42fUJy/KTV7FO1htBUEZG37V3fUmJjcP6xnEcIysUe
         DPrZXLUMhfhkvqurRquQclOgXJZApyQ/axB5NYQo+wHcc2MmabH9zLY47xm0bsYlOF
         4wviMOS2rCwdPFsXve7MeiWwueyVKopkk+jGC3HY=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200806185801epcas1p15e673f1efea77c748d7bee2c3dfcbd67~owtOKc4Zw1388513885epcas1p19;
        Thu,  6 Aug 2020 18:58:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v7 0/4] scsi: ufs: Add Host Performance Booster
 Support
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <3e36260c917ce65963a1ee2cd040c0f3@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01596740281687.JavaMail.epsvc@epcpadp2>
Date:   Thu, 06 Aug 2020 16:26:35 +0900
X-CMS-MailID: 20200806072635epcms2p7faba0ff059f75015a6325f0664b01c42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200805033750epcms2p3fd74b94500593df38d50e1bf426c2347
References: <3e36260c917ce65963a1ee2cd040c0f3@codeaurora.org>
        <231786897.01596600181895.JavaMail.epsvc@epcpadp2>
        <CGME20200805033750epcms2p3fd74b94500593df38d50e1bf426c2347@epcms2p7>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can Guo,
> 
> On 2020-08-05 11:37, Daejun Park wrote:
> > Changelog:
> > 
> > v6 -> v7
> > 1. Remove UFS feature layer.
> > 2. Cleanup for sparse error.
> > 
> > v5 -> v6
> > Change base commit to b53293fa662e28ae0cdd40828dc641c09f133405
> > 
> > v4 -> v5
> > Delete unused macro define.
> > 
> > v3 -> v4
> > 1. Cleanup.
> > 
> > v2 -> v3
> > 1. Add checking input module parameter value.
> > 2. Change base commit from 5.8/scsi-queue to 5.9/scsi-queue.
> > 3. Cleanup for unused variables and label.
> > 
> > v1 -> v2
> > 1. Change the full boilerplate text to SPDX style.
> > 2. Adopt dynamic allocation for sub-region data structure.
> > 3. Cleanup.
> > 
> > NAND flash memory-based storage devices use Flash Translation Layer 
> > (FTL)
> > to translate logical addresses of I/O requests to corresponding flash
> > memory addresses. Mobile storage devices typically have RAM with
> > constrained size, thus lack in memory to keep the whole mapping table.
> > Therefore, mapping tables are partially retrieved from NAND flash on
> > demand, causing random-read performance degradation.
> > 
> > To improve random read performance, JESD220-3 (HPB v1.0) proposes HPB
> > (Host Performance Booster) which uses host system memory as a cache for 
> > the
> > FTL mapping table. By using HPB, FTL data can be read from host memory
> > faster than from NAND flash memory.
> > 
> > The current version only supports the DCM (device control mode).
> > This patch consists of 3 parts to support HPB feature.
> > 
> > 1) HPB probe and initialization process
> > 2) READ -> HPB READ using cached map information
> > 3) L2P (logical to physical) map management
> > 
> > In the HPB probe and init process, the device information of the UFS is
> > queried. After checking supported features, the data structure for the 
> > HPB
> > is initialized according to the device information.
> > 
> > A read I/O in the active sub-region where the map is cached is changed 
> > to
> > HPB READ by the HPB.
> > 
> > The HPB manages the L2P map using information received from the
> > device. For active sub-region, the HPB caches through ufshpb_map
> > request. For the in-active region, the HPB discards the L2P map.
> > When a write I/O occurs in an active sub-region area, associated dirty
> > bitmap checked as dirty for preventing stale read.
> > 
> > HPB is shown to have a performance improvement of 58 - 67% for random 
> > read
> > workload. [1]
> > 
> > This series patches are based on the 5.9/scsi-queue branch.
> > 
> > [1]:
> > https://www.usenix.org/conference/hotstorage17/program/presentation/jeong
> > 
> > Daejun park (4):
> >  scsi: ufs: Add UFS feature related parameter
> >  scsi: ufs: Introduce HPB feature
> >  scsi: ufs: L2P map management for HPB read
> >  scsi: ufs: Prepare HPB read for cached sub-region
> > 
> >  drivers/scsi/ufs/Kconfig  |   18 +
> >  drivers/scsi/ufs/Makefile |    1 +
> >  drivers/scsi/ufs/ufs.h    |   12 +
> >  drivers/scsi/ufs/ufshcd.c |   42 +
> >  drivers/scsi/ufs/ufshcd.h |    9 +
> >  drivers/scsi/ufs/ufshpb.c | 1926 
> > ++++++++++++++++++++++++++++++++++++++++
> >  drivers/scsi/ufs/ufshpb.h |  241 +++++
> >  7 files changed, 2249 insertions(+)
> >  created mode 100644 drivers/scsi/ufs/ufshpb.c
> >  created mode 100644 drivers/scsi/ufs/ufshpb.h
> 
> I only gave my reviewed-by tag to the very first patch (changes to 
> ufshcd.h),
> but not the whole series. Please remove those tags accordingly.
> 
OK, I am sorry about that.
I will remove tags and re-submit my patches.

Thanks,

Daejun
