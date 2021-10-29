Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 151D8C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 03:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E44C960524
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 03:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhJ2DSE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 23:18:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36125 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231558AbhJ2DSD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 23:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635477335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3pYzmXHRuJS5a4JTUR2VzeH599pTh8w8NKmslhTSrbs=;
        b=HHegkJw46wucSIuhMlABN7N9urs8r95iqhKJi5lwmVTmCvWfR3XRprC8ilfPr6cs+tXxEQ
        A5ldyiDWMIa/MIoxj2jgqv+4AmP1piePOrZernw7O9SVs5RSPol8fjYJtavBnthj2jTjxq
        iI/vAHyObtmpHxCTO8lqb1Hd/UxFVuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-S-hPaw3BN8ygbqkn2yGlNg-1; Thu, 28 Oct 2021 23:15:30 -0400
X-MC-Unique: S-hPaw3BN8ygbqkn2yGlNg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A2A7802682;
        Fri, 29 Oct 2021 03:15:28 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 36C2060843;
        Fri, 29 Oct 2021 03:15:04 +0000 (UTC)
Date:   Fri, 29 Oct 2021 11:14:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Message-ID: <YXtnM9pwcBymG+Oz@T590>
References: <YXtYME4yW6bFA1Cb@T590>
 <YXtPNIDzeln8zBCn@T590>
 <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <20211029015015epcms2p3a46e0779e43ab84c00388d99abf3b867@epcms2p3>
 <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p4>
 <20211029025012epcms2p429d940cb32f5f31a2ac3fe395538a755@epcms2p4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029025012epcms2p429d940cb32f5f31a2ac3fe395538a755@epcms2p4>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 29, 2021 at 11:50:12AM +0900, Daejun Park wrote:
> > On Fri, Oct 29, 2021 at 10:50:15AM +0900, Daejun Park wrote:
> > > > On Thu, Oct 28, 2021 at 07:36:19AM +0900, Daejun Park wrote:
> > > > > This patch addresses the issue of using the wrong API to create a
> > > > > pre_request for HPB READ.
> > > > > HPB READ candidate that require a pre-request will try to allocate a
> > > > > pre-request only during request_timeout_ms (default: 0). Otherwise, it is
> > > >  
> > > > Can you explain about 'only during request_timeout_ms'?
> > > >  
> > > > From the following code in ufshpb_prep(), the pre-request is allocated
> > > > for each READ IO in case of (!ufshpb_is_legacy(hba) && ufshpb_is_required_wb(hpb,
> > > > transfer_len)).
> > > >  
> > > >    if (!ufshpb_is_legacy(hba) &&
> > > >             ufshpb_is_required_wb(hpb, transfer_len)) {
> > > >                 err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> > > >  
> > > > > passed as normal READ, so deadlock problem can be resolved.
> > > > > 
> > > > > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > > > > ---
> > > > >  drivers/scsi/ufs/ufshpb.c | 11 +++++------
> > > > >  drivers/scsi/ufs/ufshpb.h |  1 +
> > > > >  2 files changed, 6 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > > > > index 02fb51ae8b25..3117bd47d762 100644
> > > > > --- a/drivers/scsi/ufs/ufshpb.c
> > > > > +++ b/drivers/scsi/ufs/ufshpb.c
> > > > > @@ -548,8 +548,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
> > > > >                                   read_id);
> > > > >          rq->cmd_len = scsi_command_size(rq->cmd);
> > > > >  
> > > > > -        if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> > > > > -                return -EAGAIN;
> > > > > +        blk_execute_rq_nowait(NULL, req, true, ufshpb_pre_req_compl_fn);
> > > >  
> > > > Be care with above change, blk_insert_cloned_request() allocates
> > > > driver tag and issues the request to LLD directly, then returns the
> > > > result. If anything fails in the code path, -EAGAIN is returned.
> > > >  
> > > > But blk_execute_rq_nowait() simply queued the request in block layer,
> > > > and run hw queue. It doesn't allocate driver tag, and doesn't issue it
> > > > to LLD.
> > > >  
> > > > So ufshpb_execute_pre_req() may think the pre-request is issued to LLD
> > > > successfully, but actually not, maybe never. What will happen after the
> > > > READ IO is issued to device, but the pre-request(write buffer) isn't
> > > > sent to device?
> > > 
> > > In that case, the HPB READ cannot get benefit from pre-request. But it is not
> > > common case.
> >  
> > OK, so the device will ignore the pre-request if it isn't received in
> > time, not sure it is common or not, since blk_execute_rq_nowait()
> > doesn't provide any feedback. Here looks blk_insert_cloned_request()
> > is better.
> 
> Yor're right.
> 
> > > 
> > > > Can you explain how this change solves the deadlock?
> > > 
> > > The deadlock is happen when the READ waiting allocation of pre-request. But
> > > the timeout code makes to stop waiting after given time later.
> >  
> > If you mean blk-mq timeout code will be triggered, I think it won't.
> > Meantime, LLD may see nothing to timeout too.
> 
> I mean timeout of the HPB code. Please refer following code:
> 
> if (!ufshpb_is_legacy(hba) &&
> 	ufshpb_is_required_wb(hpb, transfer_len)) {
> 	err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> 	if (err) {
> 		unsigned long timeout;
> 
> 		timeout = cmd->jiffies_at_alloc + msecs_to_jiffies(
> 			  hpb->params.requeue_timeout_ms);
> 
> 		if (time_before(jiffies, timeout))
> 			return -EAGAIN;
> 
> 		hpb->stats.miss_cnt++;
> 		return 0;
> 	}
> }
> 
> Although the return value of ufshpb_issue_pre_req() is -EAGAIN, the code
> ignores the return value and issues READ not HPB READ.

OK, got it, this way should avoid the deadlock. But just be curious why
you change hpb->throttle_pre_req to 4, seems it isn't necessary for
avoiding the deadlock?


Thanks,
Ming

