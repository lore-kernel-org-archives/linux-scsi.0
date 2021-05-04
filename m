Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5CEC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 07:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABBB4613AA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 07:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbhEDHuJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 03:50:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:37390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEDHuI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 03:50:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620114553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=djcLdlKfRfRXgK0mBKOLYNkLNaXTK5fkqmlir9Mky2g=;
        b=ISUb7CzgdiWjEAtZ91adg+NNUW93EJnZ6pv2gMjFyXGy/YmKzzYBjHOAwXCqONyyqI3960
        Thx6o1mZyql/YHSmVmFYHDO1O/8r4GU6NRHc98N9pP/iZ3y4bH6as2QCprHNZ5NNIS6A2m
        3c3h2dDAQ6WpSqXjytekm5swDs3talw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2EBD4AECB;
        Tue,  4 May 2021 07:49:13 +0000 (UTC)
Message-ID: <1f62775363a5e9050b1a660ae5b114868dbbb9bc.camel@suse.com>
Subject: Re: [PATCH 3/3] fnic: check for started requests in
 fnic_wq_copy_cleanup_handler()
From:   Martin Wilck <mwilck@suse.com>
To:     Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Date:   Tue, 04 May 2021 09:49:12 +0200
In-Reply-To: <8c971d37-e1ae-246f-9b9a-8170c76276b1@suse.de>
References: <20210429122517.39659-1-hare@suse.de>
         <20210429122517.39659-4-hare@suse.de> <YIrD87Ekh3xBqE6u@T590>
         <8c971d37-e1ae-246f-9b9a-8170c76276b1@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-04-29 at 19:28 +0200, Hannes Reinecke wrote:
> On 4/29/21 4:34 PM, Ming Lei wrote:
> > On Thu, Apr 29, 2021 at 02:25:17PM +0200, Hannes Reinecke wrote:
> > > fnic_wq_copy_cleanup_handler() is using scsi_host_find_tag() to
> > > map id to a scsi command. However, as per discussion on the
> > > mailinglist
> > > scsi_host_find_tag() might return a non-started request, so we
> > > need
> > > to check the returned command with blk_mq_request_started() to
> > > avoid
> > > the function tripping over a non-initialized command.
> > > 
> > > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > > ---
> > >   drivers/scsi/fnic/fnic_scsi.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/fnic/fnic_scsi.c
> > > b/drivers/scsi/fnic/fnic_scsi.c
> > > index 762cc8bd2653..b9fd3d87416b 100644
> > > --- a/drivers/scsi/fnic/fnic_scsi.c
> > > +++ b/drivers/scsi/fnic/fnic_scsi.c
> > > @@ -1466,7 +1466,7 @@ void fnic_wq_copy_cleanup_handler(struct
> > > vnic_wq_copy *wq,
> > >                 return;
> > >   
> > >         sc = scsi_host_find_tag(fnic->lport->host, id);
> > > -       if (!sc)
> > > +       if (!sc || !blk_mq_request_started(sc->request))
> > >                 return;
> > 
> > scsi_host_find_tag() has covered blk_mq_request_started check
> > already, so
> > this patch isn't necessary.
> > 
> Right. So drop it, then.

While you are at this, could you please re-consider e73a5e8e8003
("scsi: core: Only return started requests from scsi_host_find_tag()")
in general?

I have come to think that commit is incorrect. It was created as an
attempt to fix the observed fnic crashes, but it was ineffective. The
crashes were eventually fixed by patch 2/3 of this series. 

IMO scsi_host_find_tag() should return a request if there is one,
regardless whether or not it's started, and leave the decision to
ignore pending requests to the caller, like it used to be until v5.8.

Regards
Martin


