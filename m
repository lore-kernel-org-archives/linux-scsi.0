Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0A4C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 03:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D4E20639
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 03:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="VKqIB/4g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgHMDSH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 23:18:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37726 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgHMDSH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 23:18:07 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200813031804epoutp03f4c534e3a7b7e89282a898b811778beb~qtZhuE8LA1508715087epoutp038
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 03:18:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200813031804epoutp03f4c534e3a7b7e89282a898b811778beb~qtZhuE8LA1508715087epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597288684;
        bh=PbimsoKST2hIlxdVObLAJhxRszolI+mgrlOzs8o6b4g=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=VKqIB/4g5SmiHIn5pKHW/hP1BEKlkZ95mfd8A0M8Yio9v4ZDqDEAuSRCYGWi4YE87
         /WMitBDooPf4QVOXcleElil6YWK6YTDvxuEXWgtZrs7dmt//RRmm8oxH6g+mel3jLw
         3Ztc4bk6teh9xrWs68Pv8/Ftx/EyIcE9PAqLbhQc=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200813031803epcas1p2f2585f68585a95c2160db0e5ab12d4c4~qtZhVpD301239712397epcas1p22;
        Thu, 13 Aug 2020 03:18:03 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v8 4/4] scsi: ufs: Prepare HPB read for cached
 sub-region
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
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
In-Reply-To: <89f7bd4e-b328-7916-b099-2882d5182236@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1239183618.61597288683730.JavaMail.epsvc@epcpadp2>
Date:   Thu, 13 Aug 2020 12:15:36 +0900
X-CMS-MailID: 20200813031536epcms2p2ad6e0310107279aee230e411a4f2d8cf
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d
References: <89f7bd4e-b328-7916-b099-2882d5182236@acm.org>
        <336371513.41596705485601.JavaMail.epsvc@epcpadp2>
        <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
        <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
        <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
        <231786897.01596705781817.JavaMail.epsvc@epcpadp2>
        <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-06 02:18, Daejun Park wrote:
> > +static inline u32 ufshpb_get_lpn(struct scsi_cmnd *cmnd)
> > +{
> > +    return blk_rq_pos(cmnd->request) >>
> > +        (ilog2(cmnd->device->sector_size) - 9);
> > +}
> 
> Please use sectors_to_logical() from drivers/scsi/sd.h instead of open-coding
> that function.

OK, I will.

> > +static inline unsigned int ufshpb_get_len(struct scsi_cmnd *cmnd)
> > +{
> > +    return blk_rq_sectors(cmnd->request) >>
> > +        (ilog2(cmnd->device->sector_size) - 9);
> > +}
> 
> Same comment here.

OK
 
> > +/* routine : READ10 -> HPB_READ  */
> 
> Please expand this comment.

OK

Thanks,
Daejun
