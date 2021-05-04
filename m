Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD0DC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 08:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D2D7610A1
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 08:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhEDI6R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 04:58:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:38346 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhEDI6Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 04:58:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620118639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mU1lr7/UxSLOigjv1VOIp6eiu0MQjaz3L+Dj0bKBH80=;
        b=Ii+YlIiSc2d1nxXGWbyuz6hj6MCsBm6c4DqFQNX5Sv4RoWGy3B4ZfVhhG5DTSh0UY7wz9U
        WFoQF8UYOJUdWu3F7omPVusxqa/ApZ8Px6KQyQtO13a8X2aF/CiNeBzihDcwMGsIgw80wM
        eRJEkeidAzY3FQc6TvXC/FkpeGXFlV4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 465B6AED7;
        Tue,  4 May 2021 08:57:19 +0000 (UTC)
Message-ID: <00b7270360f6427e752f941a9e8ae04df05c3a1f.camel@suse.com>
Subject: Re: [PATCH 3/3] fnic: check for started requests in
 fnic_wq_copy_cleanup_handler()
From:   Martin Wilck <mwilck@suse.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Date:   Tue, 04 May 2021 10:57:18 +0200
In-Reply-To: <YJEAlV3IQ6HQL9jU@T590>
References: <20210429122517.39659-1-hare@suse.de>
         <20210429122517.39659-4-hare@suse.de> <YIrD87Ekh3xBqE6u@T590>
         <8c971d37-e1ae-246f-9b9a-8170c76276b1@suse.de>
         <1f62775363a5e9050b1a660ae5b114868dbbb9bc.camel@suse.com>
         <YJEAlV3IQ6HQL9jU@T590>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-05-04 at 16:06 +0800, Ming Lei wrote:
> On Tue, May 04, 2021 at 09:49:12AM +0200, Martin Wilck wrote:
> > On Thu, 2021-04-29 at 19:28 +0200, Hannes Reinecke wrote:
> > > On 4/29/21 4:34 PM, Ming Lei wrote:
> > > > On Thu, Apr 29, 2021 at 02:25:17PM +0200, Hannes Reinecke
> > > > wrote:
> > > > > fnic_wq_copy_cleanup_handler() is using scsi_host_find_tag()
> > > > > to
> > > > > map id to a scsi command. However, as per discussion on the
> > > > > mailinglist
> > > > > scsi_host_find_tag() might return a non-started request, so
> > > > > we
> > > > > need
> > > > > to check the returned command with blk_mq_request_started()
> > > > > to
> > > > > avoid
> > > > > the function tripping over a non-initialized command.
> > > > > 
> > > > > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > > > > ---
> > > > >   drivers/scsi/fnic/fnic_scsi.c | 2 +-
> > > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/scsi/fnic/fnic_scsi.c
> > > > > b/drivers/scsi/fnic/fnic_scsi.c
> > > > > index 762cc8bd2653..b9fd3d87416b 100644
> > > > > --- a/drivers/scsi/fnic/fnic_scsi.c
> > > > > +++ b/drivers/scsi/fnic/fnic_scsi.c
> > > > > @@ -1466,7 +1466,7 @@ void
> > > > > fnic_wq_copy_cleanup_handler(struct
> > > > > vnic_wq_copy *wq,
> > > > >                 return;
> > > > >   
> > > > >         sc = scsi_host_find_tag(fnic->lport->host, id);
> > > > > -       if (!sc)
> > > > > +       if (!sc || !blk_mq_request_started(sc->request))
> > > > >                 return;
> > > > 
> > > > scsi_host_find_tag() has covered blk_mq_request_started check
> > > > already, so
> > > > this patch isn't necessary.
> > > > 
> > > Right. So drop it, then.
> > 
> > While you are at this, could you please re-consider e73a5e8e8003
> > ("scsi: core: Only return started requests from
> > scsi_host_find_tag()")
> > in general?
> > 
> > I have come to think that commit is incorrect. It was created as an
> > attempt to fix the observed fnic crashes, but it was ineffective.
> > The
> > crashes were eventually fixed by patch 2/3 of this series. 
> > 
> > IMO scsi_host_find_tag() should return a request if there is one,
> > regardless whether or not it's started, and leave the decision to
> > ignore pending requests to the caller, like it used to be until
> > v5.8.
> 
> Can you share the cases in which SCSI needs to deal with non in-
> flight
> requests via scsi_host_find_tag()? which is supposed to be used for
> retrieving
> request via one active tag in scsi io completion path.

No, I can't. I haven't reviewed every caller. I thought about the
function's documentation, which simply says "find the tagged command by
host". Maybe I got this wrong.

You're right that returning non-in-flight requests makes no sense for
drivers calling this function in the request completion code path.

The situation was a bit different until recently, when drivers used
scsi_host_find_tag() also for iterating over commands. The commit
message of e73a5e8e8003 stated that it avoids 'random errors' in this
case; I am not sure if that's actually the case. I can at least imagine
that a driver would want to abort or otherwise invalidate requests even
if they're not in flight yet (e.g. when shutting down a controller).
As the drivers have now been fixed to use blk_mq_tagset_busy_iter(),
there's no need to discuss this further.

Thanks,
Martin


