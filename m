Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C13C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 02:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C98B320756
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 02:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nQNDBZOC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgFPCuF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 22:50:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36924 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgFPCuF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 22:50:05 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200616025002epoutp03df3f890796e286de3dd11fde1d5a471c~Y5mfwtYQ11034510345epoutp03h
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2020 02:50:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200616025002epoutp03df3f890796e286de3dd11fde1d5a471c~Y5mfwtYQ11034510345epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592275802;
        bh=LxQRlTC7iL0L+qHFsNsjwE0X+VN3mnmMRGvEckdvV+Y=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=nQNDBZOCWEgVt77xfPXuo5lnTdDRaPPMt8xnfA13g4X2FHFJXJqKVYcHPcuLJjP/L
         tJdzzuEsJvjQ2KKeOqXNXfhMCcvnnLevuQc1/uw2WKFQlIVxor9rVgU01laaj6/ekd
         ahyRJSUhHQhNnhT7NQ9VmICLg/glth6MBhCxaoig=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200616025001epcas1p2bac7260510918b8e2ae55da822437f52~Y5mfXXVo82697926979epcas1p2b;
        Tue, 16 Jun 2020 02:50:01 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [RFC PATCH v2 4/5] scsi: ufs: L2P map management for HPB read
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
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
In-Reply-To: <078bb71ddc9cda4454d213333afa4b6a905b8b09.camel@gmail.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01592275801931.JavaMail.epsvc@epcpadp1>
Date:   Tue, 16 Jun 2020 10:17:44 +0900
X-CMS-MailID: 20200616011744epcms2p781f586af00852f67a62d9b557ee05591
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210
References: <078bb71ddc9cda4454d213333afa4b6a905b8b09.camel@gmail.com>
        <231786897.01592213402355.JavaMail.epsvc@epcpadp1>
        <231786897.01592212081335.JavaMail.epsvc@epcpadp2>
        <336371513.41592205783606.JavaMail.epsvc@epcpadp2>
        <231786897.01592205482200.JavaMail.epsvc@epcpadp2>
        <231786897.01592214002170.JavaMail.epsvc@epcpadp1>
        <CGME20200615062708epcms2p19a7fbc051bcd5e843c29dcd58fff4210@epcms2p7>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean
> 
> 
> On Mon, 2020-06-15 at 18:30 +0900, Daejun Park wrote:
> > +static int ufshpb_execute_map_req(struct ufshpb_lu *hpb,
> > +                                 struct ufshpb_req *map_req)
> > +{
> > +       struct request_queue *q;
> > +       struct request *req;
> > +       struct scsi_request *rq;
> > +       int ret = 0;
> > +
> > +       q = hpb->sdev_ufs_lu->request_queue;
> > +       ret = ufshpb_map_req_add_bio_page(hpb, q, map_req->bio,
> > +                                         map_req->mctx);
> > +       if (ret) {
> > +               dev_notice(&hpb->hpb_lu_dev,
> > +                          "map_req_add_bio_page fail %d - %d\n",
> > +                          map_req->rgn_idx, map_req->srgn_idx);
> > +               return ret;
> > +       }
> > +
> > +       req = map_req->req;
> > +
> > +       blk_rq_append_bio(req, &map_req->bio);
> > +
> > +       req->timeout = 0;
> > +       req->end_io_data = (void *)map_req;
> > +
> > +       rq = scsi_req(req);
> > +       ufshpb_set_read_buf_cmd(rq->cmd, map_req->rgn_idx,
> > +                               map_req->srgn_idx, hpb-
> > >srgn_mem_size);
> > +       rq->cmd_len = HPB_READ_BUFFER_CMD_LENGTH;
> > +
> > +       blk_execute_rq_nowait(q, NULL, req, 1,
> > ufshpb_map_req_compl_fn);
> 
> 
> HPB map_req is now being en-queued in sdev->request_queue.
> This is ok for the HPB v1.0. Have you ever been thinking about
> changing this way to directly issue HPB requests to UFS?
I think it is enough to support HPB.

> Actually, there are two reasons for this way:
> 
> 1. Latency of loading mapping entries is lower comparing to your curret
> approach.
Our map request style utilizes block layer API. It makes the codes keep
simple and reliable. Also, I think the latency of loading mapping entries 
is not critical for HPB. Futhermore, I think the other requests from
user is important than loading mapping entries. If the map_work issues map
request directly, the user requests can be disturbed by map requests.

> 2. Also, it is preparing for the HPB v2.0.  After all HPB 1.0 only
> supports 4KB read, this is useless, I am looking for the HPB v2.0.
I don't understand this comment. In HPB v2.0, this code can be used without
changing.

Thanks,
Daejun
