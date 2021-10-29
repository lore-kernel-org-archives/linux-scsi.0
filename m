Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37ADDC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 04:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 128E360F22
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 04:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhJ2EmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 00:42:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54833 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhJ2EmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 00:42:22 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20211029043952epoutp04edefae4dc712479c1b4b09fcd0e9c98a~yZpIr45q80401704017epoutp04j
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 04:39:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20211029043952epoutp04edefae4dc712479c1b4b09fcd0e9c98a~yZpIr45q80401704017epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1635482392;
        bh=KIdFSd9RMZ1vTwpAMSHIlov3UbncuFyrg1wa2ddSedk=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=NRXFwZ5RiUk4wjTe87PlR7KI0hn1A8RYWA+oKNTHz5fN+COEOt+D2tFxchVxAt4yD
         J4yPPJZrZAorSXC29WG4BiRfvmQFW7IxJmkxr8vz8L6YQeKLklWvQY04ZO6I4nprqv
         MDza7ANUKIVx7fnfTuQtirZL2uyIvKEmBQeFcUKg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20211029043952epcas2p48bdc5e578aa5a9b6f997b7fef605e823~yZpIHPliK0098600986epcas2p4g;
        Fri, 29 Oct 2021 04:39:52 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.99]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4HgV8C0kFNz4x9Qg; Fri, 29 Oct
        2021 04:39:39 +0000 (GMT)
X-AuditID: b6c32a46-a0fff70000002722-16-617b7b0202f4
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.1C.10018.20B7B716; Fri, 29 Oct 2021 13:39:30 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Daejun Park <daejun7.park@samsung.com>
CC:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <YXtnM9pwcBymG+Oz@T590>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20211029043930epcms2p19b67f03cdae76f455714c9a60b2ac761@epcms2p1>
Date:   Fri, 29 Oct 2021 13:39:30 +0900
X-CMS-MailID: 20211029043930epcms2p19b67f03cdae76f455714c9a60b2ac761
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNJsWRmVeSWpSXmKPExsWy7bCmqS5TdXWiwaNeVYsH87axWbz8eZXN
        YtqHn8wWLw9pWqx6EG4x52wDk8WiG9uYLI6ffMdocXnXHDaL7us72CyWH//HZHFocjOTA4/H
        5SveHjtn3WX3mLDoAKPHx6e3WDze77vK5tG3ZRWjx+dNch7tB7qZAjiism0yUhNTUosUUvOS
        81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgG5VUihLzCkFCgUkFhcr6dvZ
        FOWXlqQqZOQXl9gqpRak5BSYF+gVJ+YWl+al6+WlllgZGhgYmQIVJmRnzHxUXbBDteL4hNlM
        DYwbpbsYOTkkBEwkDm44wdLFyMUhJLCDUeLFypusXYwcHLwCghJ/dwiD1AgLuEksXzWJEcQW
        ElCSWH9xFjtEXE/i1sM1YHE2AR2J6Sfug8VFBLwkNjxbyQgyk1ngALPE8blv2CCW8UrMaH/K
        AmFLS2xfvhWsmVNARWLupjWsEHENiR/LepkhbFGJm6vfssPY74/NZ4SwRSRa752FqhGUePBz
        N1RcUuLY7g9MEHa9xNY7v8COkBDoYZQ4vPMW1AJ9iWsdG8GO4BXwlVjRswcsziKgKnHu7CWo
        GheJ7fNfgg1lFpCX2P52DjMoUJgFNCXW79IHMSUElCWO3GKBeath4292dDazAJ9Ex+G/cPEd
        855AnaYmse7neqYJjMqzECE9C8muWQi7FjAyr2IUSy0ozk1PLTYqMILHbXJ+7iZGcKrVctvB
        OOXtB71DjEwcjIcYJTiYlUR4L88rTxTiTUmsrEotyo8vKs1JLT7EaAr05URmKdHkfGCyzyuJ
        NzSxNDAxMzM0NzI1MFcS57UUzU4UEkhPLEnNTk0tSC2C6WPi4JRqYJp2VEs0PqKxgO+5Zn/T
        +lt/zwZfaheZmtNvq/HXze6gt1N5WtiP5AW1GXtNlr54HBP1jW/lVAVNg2vXE2X//WqbyN2n
        xCK0U+7vuS458YSy1P+XgtRYts7fZFMSbqm+tfG0obeH3rw7pVdy4vmu/si96fZN+0ZpUq5s
        8/6k14ZH3s6Q/JCRd6LwdeAHGZUJlkv3RIeW8x6OXBTl/+FT78sSwc9Znzq1hHLm7hZoD5nw
        8cSdj7MXKyz1P/Z1yqN5+60zltr9NDySJ7OXK3hLTcDd6UJSBQ/DhA5sr/DrNa9/WMriNdtk
        cvjEZfEyf6ZHXi9m6pm7dvvW+duvVAq92XL59I4apYnSq6vNFhSsXK/EUpyRaKjFXFScCABe
        42AwPgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff
References: <YXtnM9pwcBymG+Oz@T590> <YXtYME4yW6bFA1Cb@T590>
        <YXtPNIDzeln8zBCn@T590>
        <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
        <20211029015015epcms2p3a46e0779e43ab84c00388d99abf3b867@epcms2p3>
        <20211029025012epcms2p429d940cb32f5f31a2ac3fe395538a755@epcms2p4>
        <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Fri, Oct 29, 2021 at 11:50:12AM +0900, Daejun Park wrote:
> > > On Fri, Oct 29, 2021 at 10:50:15AM +0900, Daejun Park wrote:
> > > > > On Thu, Oct 28, 2021 at 07:36:19AM +0900, Daejun Park wrote:
> > > > > > This patch addresses the issue of using the wrong API to create a
> > > > > > pre_request for HPB READ.
> > > > > > HPB READ candidate that require a pre-request will try to allocate a
> > > > > > pre-request only during request_timeout_ms (default: 0). Otherwise, it is
> > > > >  
> > > > > Can you explain about 'only during request_timeout_ms'?
> > > > >  
> > > > > From the following code in ufshpb_prep(), the pre-request is allocated
> > > > > for each READ IO in case of (!ufshpb_is_legacy(hba) && ufshpb_is_required_wb(hpb,
> > > > > transfer_len)).
> > > > >  
> > > > >    if (!ufshpb_is_legacy(hba) &&
> > > > >             ufshpb_is_required_wb(hpb, transfer_len)) {
> > > > >                 err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> > > > >  
> > > > > > passed as normal READ, so deadlock problem can be resolved.
> > > > > > 
> > > > > > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > > > > > ---
> > > > > >  drivers/scsi/ufs/ufshpb.c | 11 +++++------
> > > > > >  drivers/scsi/ufs/ufshpb.h |  1 +
> > > > > >  2 files changed, 6 insertions(+), 6 deletions(-)
> > > > > > 
> > > > > > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > > > > > index 02fb51ae8b25..3117bd47d762 100644
> > > > > > --- a/drivers/scsi/ufs/ufshpb.c
> > > > > > +++ b/drivers/scsi/ufs/ufshpb.c
> > > > > > @@ -548,8 +548,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
> > > > > >                                   read_id);
> > > > > >          rq->cmd_len = scsi_command_size(rq->cmd);
> > > > > >  
> > > > > > -        if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> > > > > > -                return -EAGAIN;
> > > > > > +        blk_execute_rq_nowait(NULL, req, true, ufshpb_pre_req_compl_fn);
> > > > >  
> > > > > Be care with above change, blk_insert_cloned_request() allocates
> > > > > driver tag and issues the request to LLD directly, then returns the
> > > > > result. If anything fails in the code path, -EAGAIN is returned.
> > > > >  
> > > > > But blk_execute_rq_nowait() simply queued the request in block layer,
> > > > > and run hw queue. It doesn't allocate driver tag, and doesn't issue it
> > > > > to LLD.
> > > > >  
> > > > > So ufshpb_execute_pre_req() may think the pre-request is issued to LLD
> > > > > successfully, but actually not, maybe never. What will happen after the
> > > > > READ IO is issued to device, but the pre-request(write buffer) isn't
> > > > > sent to device?
> > > > 
> > > > In that case, the HPB READ cannot get benefit from pre-request. But it is not
> > > > common case.
> > >  
> > > OK, so the device will ignore the pre-request if it isn't received in
> > > time, not sure it is common or not, since blk_execute_rq_nowait()
> > > doesn't provide any feedback. Here looks blk_insert_cloned_request()
> > > is better.
> > 
> > Yor're right.
> > 
> > > > 
> > > > > Can you explain how this change solves the deadlock?
> > > > 
> > > > The deadlock is happen when the READ waiting allocation of pre-request. But
> > > > the timeout code makes to stop waiting after given time later.
> > >  
> > > If you mean blk-mq timeout code will be triggered, I think it won't.
> > > Meantime, LLD may see nothing to timeout too.
> > 
> > I mean timeout of the HPB code. Please refer following code:
> > 
> > if (!ufshpb_is_legacy(hba) &&
> >         ufshpb_is_required_wb(hpb, transfer_len)) {
> >         err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> >         if (err) {
> >                 unsigned long timeout;
> > 
> >                 timeout = cmd->jiffies_at_alloc + msecs_to_jiffies(
> >                           hpb->params.requeue_timeout_ms);
> > 
> >                 if (time_before(jiffies, timeout))
> >                         return -EAGAIN;
> > 
> >                 hpb->stats.miss_cnt++;
> >                 return 0;
> >         }
> > }
> > 
> > Although the return value of ufshpb_issue_pre_req() is -EAGAIN, the code
> > ignores the return value and issues READ not HPB READ.
>  
> OK, got it, this way should avoid the deadlock. But just be curious why
> you change hpb->throttle_pre_req to 4, seems it isn't necessary for
> avoiding the deadlock?

Because blk_execute_rq_nowait calls blk_mq_run_hw_queue, not dispatchs WRITE_BUFFER directly.
So, if the next request requires pre-request, it makes the latency of first read longer.
Therefore, it prevents this extreme case by limiting number of pre-request.

Thanks,
Daejun
