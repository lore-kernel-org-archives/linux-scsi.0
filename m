Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F18C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 02:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 966AD61051
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 02:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhJ2CNp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 22:13:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231348AbhJ2CNo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 22:13:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635473476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BZDNMK/nwidg9L+nz8w5aCeWPNSAafxlZqjfIW0PaA0=;
        b=PEzrpzNYjZF61HUM4CmQE9l8ye8q7IsQewmlKx7WL0sI9VmjbFhwRo6LngFEnvo4PWexAR
        JVPnYqF+/DWgEzvZvJheDawCafCuuneMDMrIUVrYMr5zBU96f0oCnsBoOOsKlVi3qEnhIu
        srINZ1uA+6s3gVy+SRs7semD35fEaSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-X80_X8mWPTyYCEzk8VGgsw-1; Thu, 28 Oct 2021 22:11:12 -0400
X-MC-Unique: X80_X8mWPTyYCEzk8VGgsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3FCB10A8E01;
        Fri, 29 Oct 2021 02:11:10 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D57A4100E12C;
        Fri, 29 Oct 2021 02:11:01 +0000 (UTC)
Date:   Fri, 29 Oct 2021 10:10:56 +0800
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ming.lei@redhat.com
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Message-ID: <YXtYME4yW6bFA1Cb@T590>
References: <YXtPNIDzeln8zBCn@T590>
 <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p3>
 <20211029015015epcms2p3a46e0779e43ab84c00388d99abf3b867@epcms2p3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211029015015epcms2p3a46e0779e43ab84c00388d99abf3b867@epcms2p3>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 29, 2021 at 10:50:15AM +0900, Daejun Park wrote:
> > On Thu, Oct 28, 2021 at 07:36:19AM +0900, Daejun Park wrote:
> > > This patch addresses the issue of using the wrong API to create a
> > > pre_request for HPB READ.
> > > HPB READ candidate that require a pre-request will try to allocate a
> > > pre-request only during request_timeout_ms (default: 0). Otherwise, it is
> >  
> > Can you explain about 'only during request_timeout_ms'?
> >  
> > From the following code in ufshpb_prep(), the pre-request is allocated
> > for each READ IO in case of (!ufshpb_is_legacy(hba) && ufshpb_is_required_wb(hpb,
> > transfer_len)).
> >  
> >    if (!ufshpb_is_legacy(hba) &&
> >             ufshpb_is_required_wb(hpb, transfer_len)) {
> >                 err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
> >  
> > > passed as normal READ, so deadlock problem can be resolved.
> > > 
> > > Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> > > ---
> > >  drivers/scsi/ufs/ufshpb.c | 11 +++++------
> > >  drivers/scsi/ufs/ufshpb.h |  1 +
> > >  2 files changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> > > index 02fb51ae8b25..3117bd47d762 100644
> > > --- a/drivers/scsi/ufs/ufshpb.c
> > > +++ b/drivers/scsi/ufs/ufshpb.c
> > > @@ -548,8 +548,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
> > >                                   read_id);
> > >          rq->cmd_len = scsi_command_size(rq->cmd);
> > >  
> > > -        if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> > > -                return -EAGAIN;
> > > +        blk_execute_rq_nowait(NULL, req, true, ufshpb_pre_req_compl_fn);
> >  
> > Be care with above change, blk_insert_cloned_request() allocates
> > driver tag and issues the request to LLD directly, then returns the
> > result. If anything fails in the code path, -EAGAIN is returned.
> >  
> > But blk_execute_rq_nowait() simply queued the request in block layer,
> > and run hw queue. It doesn't allocate driver tag, and doesn't issue it
> > to LLD.
> >  
> > So ufshpb_execute_pre_req() may think the pre-request is issued to LLD
> > successfully, but actually not, maybe never. What will happen after the
> > READ IO is issued to device, but the pre-request(write buffer) isn't
> > sent to device?
> 
> In that case, the HPB READ cannot get benefit from pre-request. But it is not
> common case.

OK, so the device will ignore the pre-request if it isn't received in
time, not sure it is common or not, since blk_execute_rq_nowait()
doesn't provide any feedback. Here looks blk_insert_cloned_request()
is better.

> 
> > Can you explain how this change solves the deadlock?
> 
> The deadlock is happen when the READ waiting allocation of pre-request. But
> the timeout code makes to stop waiting after given time later.

If you mean blk-mq timeout code will be triggered, I think it won't.
Meantime, LLD may see nothing to timeout too.

For example, in case of none io sched, the queue depth is 128, and 128 READ
IOs are sent to ufshcd_queuecommand() at the same time, and all these 128 IOs
require to allocate pre-request, but no one can move on because 128 tags are
used up.

So no request can be sent to device and BLK_STS_RESOURCE is always returned
from ufshcd_queuecommand(), also when blk-mq timeout is triggered, all in-flight
request's state may just be updated as IDLE, so blk-mq may find nothing to expire.

In case of real io scheduler, request->tag is released when BLK_STS_RESOURCE
is returned from ufshcd_queuecommand(), but it doesn't mean that
pre-request can get tag always.

The approach[1] of reserving one slot for pre-request should provide
forward progress guarantee.


[1] https://lore.kernel.org/linux-block/YXoF59XeZ5KS0jZj@T590/

Thanks,
Ming

