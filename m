Return-Path: <SRS0=E1i/=AA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF702C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 23:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9E93224B1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Jun 2020 23:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y9aW/oVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgFSXtU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Jun 2020 19:49:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37410 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726321AbgFSXtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jun 2020 19:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592610558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yNZnxlbGuPU4YC+U1/0TYouC5Ifb75XSHcGnTIYuOjc=;
        b=Y9aW/oVKo/fFnWAzqcIy7iuBNFaao3tGiPideKkICTQKCyzD1YGKVsZRDkP1PwRqARfjTs
        L7VfwPj6w0dQG2LIQURDFsuAhk/o3ntRc2zqHMP4oTW6WbZq2LC6b3e6jOCX/vwUDx9GND
        aZh9f/Y0LliCU5HCGTjpYnp1JfY4sso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-d7n_UMonMtWJgywOjVzDNg-1; Fri, 19 Jun 2020 19:49:16 -0400
X-MC-Unique: d7n_UMonMtWJgywOjVzDNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 433C6800053;
        Fri, 19 Jun 2020 23:49:15 +0000 (UTC)
Received: from T590 (ovpn-12-19.pek2.redhat.com [10.72.12.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BFC8719C4F;
        Fri, 19 Jun 2020 23:49:07 +0000 (UTC)
Date:   Sat, 20 Jun 2020 07:49:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Keith Busch <keith.busch@wdc.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] block: only return started requests from
 blk_mq_tag_to_rq()
Message-ID: <20200619234903.GG353853@T590>
References: <20200619140159.141905-1-hare@suse.de>
 <60e34dce-aea4-311f-22da-4cb130c5ba88@suse.de>
 <57a809a0-d449-e5f1-8986-761d6417e2c2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57a809a0-d449-e5f1-8986-761d6417e2c2@kernel.dk>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 19, 2020 at 12:38:01PM -0600, Jens Axboe wrote:
> On 6/19/20 8:09 AM, Hannes Reinecke wrote:
> > On 6/19/20 4:01 PM, Hannes Reinecke wrote:
> >> blk_mq_tag_to_rq() is used from within the driver to map a tag
> >> to a request. As such it should only return requests which are
> >> already started (ie passed to the driver); otherwise the driver
> >> might trip over requests which it has never seen and random
> >> crashes will occur.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>   block/blk-mq.c | 6 +++++-
> >>   1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/block/blk-mq.c b/block/blk-mq.c
> >> index 4f57d27bfa73..f02d18113f9e 100644
> >> --- a/block/blk-mq.c
> >> +++ b/block/blk-mq.c
> >> @@ -815,9 +815,13 @@ EXPORT_SYMBOL(blk_mq_delay_kick_requeue_list);
> >>   
> >>   struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
> >>   {
> >> +	struct request *rq;
> >> +
> >>   	if (tag < tags->nr_tags) {
> >>   		prefetch(tags->rqs[tag]);
> >> -		return tags->rqs[tag];
> >> +		rq = tags->rqs[tag];
> >> +		if (blk_mq_request_started(rq))
> >> +			return rq;
> >>   	}
> >>   
> >>   	return NULL;
> >>
> > This becomes particularly obnoxious for SCSI drivers using 
> > scsi_host_find_tag() for cleaning up stale commands (ie drivers like 
> > qla4xxx, fnic, and snic).
> > All other drivers use it from the completion routine, so one can expect 
> > a valid (and started) tag here. So for those it shouldn't matter.
> > 
> > But still, if there are objections I could look at fixing it within the 
> > SCSI stack; although that would most likely mean I'll have to implement 
> > the above patch as an additional function.
> 
> The helper does exactly what it should, return a request associated
> with a tag. Either add the logic to the caller, or provide a new
> helper that does what you need. I'd be inclined to just add it to
> the caller that needs it.

I agree, even though the idea is good for most of driver usage since driver
should only care started request.

It may cause kernel oops in some corner case, such as blk_mq_poll_hybrid(),
blk_poll() may see one not-started request, one example is nvme_execute_rq_polled().

Thanks,
Ming

