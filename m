Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20245C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 08:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6DD76139A
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 08:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhEDIHy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 04:07:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230025AbhEDIHy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2021 04:07:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620115619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OKyRLxAkLHCcFQaXTAxMkWZsjuIqopgV7O87rNNBcdM=;
        b=Qipkkmyxf/fAfzx2mEjCZhVuiRrduTxfYYG8EnuzK5aHRL4oaMgGCFZeLA3sLTKyqKCSTH
        pOxNCcZJWEu0DgsHgFdUKbUPuannM1xeDqq79ZfVhH98rCHkUYQpbZ36mFDcP3DqD4TqEi
        pCg1vMX/inFXbeTrI0EtjJ0TKpze5X0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-0z5nHh_GOpSFz4clRHbLzA-1; Tue, 04 May 2021 04:06:57 -0400
X-MC-Unique: 0z5nHh_GOpSFz4clRHbLzA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51D3361244;
        Tue,  4 May 2021 08:06:56 +0000 (UTC)
Received: from T590 (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 221706061F;
        Tue,  4 May 2021 08:06:49 +0000 (UTC)
Date:   Tue, 4 May 2021 16:06:45 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Martin Wilck <mwilck@suse.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] fnic: check for started requests in
 fnic_wq_copy_cleanup_handler()
Message-ID: <YJEAlV3IQ6HQL9jU@T590>
References: <20210429122517.39659-1-hare@suse.de>
 <20210429122517.39659-4-hare@suse.de>
 <YIrD87Ekh3xBqE6u@T590>
 <8c971d37-e1ae-246f-9b9a-8170c76276b1@suse.de>
 <1f62775363a5e9050b1a660ae5b114868dbbb9bc.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f62775363a5e9050b1a660ae5b114868dbbb9bc.camel@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 04, 2021 at 09:49:12AM +0200, Martin Wilck wrote:
> On Thu, 2021-04-29 at 19:28 +0200, Hannes Reinecke wrote:
> > On 4/29/21 4:34 PM, Ming Lei wrote:
> > > On Thu, Apr 29, 2021 at 02:25:17PM +0200, Hannes Reinecke wrote:
> > > > fnic_wq_copy_cleanup_handler() is using scsi_host_find_tag() to
> > > > map id to a scsi command. However, as per discussion on the
> > > > mailinglist
> > > > scsi_host_find_tag() might return a non-started request, so we
> > > > need
> > > > to check the returned command with blk_mq_request_started() to
> > > > avoid
> > > > the function tripping over a non-initialized command.
> > > > 
> > > > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > > > ---
> > > >   drivers/scsi/fnic/fnic_scsi.c | 2 +-
> > > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/scsi/fnic/fnic_scsi.c
> > > > b/drivers/scsi/fnic/fnic_scsi.c
> > > > index 762cc8bd2653..b9fd3d87416b 100644
> > > > --- a/drivers/scsi/fnic/fnic_scsi.c
> > > > +++ b/drivers/scsi/fnic/fnic_scsi.c
> > > > @@ -1466,7 +1466,7 @@ void fnic_wq_copy_cleanup_handler(struct
> > > > vnic_wq_copy *wq,
> > > >                 return;
> > > >   
> > > >         sc = scsi_host_find_tag(fnic->lport->host, id);
> > > > -       if (!sc)
> > > > +       if (!sc || !blk_mq_request_started(sc->request))
> > > >                 return;
> > > 
> > > scsi_host_find_tag() has covered blk_mq_request_started check
> > > already, so
> > > this patch isn't necessary.
> > > 
> > Right. So drop it, then.
> 
> While you are at this, could you please re-consider e73a5e8e8003
> ("scsi: core: Only return started requests from scsi_host_find_tag()")
> in general?
> 
> I have come to think that commit is incorrect. It was created as an
> attempt to fix the observed fnic crashes, but it was ineffective. The
> crashes were eventually fixed by patch 2/3 of this series. 
> 
> IMO scsi_host_find_tag() should return a request if there is one,
> regardless whether or not it's started, and leave the decision to
> ignore pending requests to the caller, like it used to be until v5.8.

Can you share the cases in which SCSI needs to deal with non in-flight
requests via scsi_host_find_tag()? which is supposed to be used for retrieving
request via one active tag in scsi io completion path.


Thanks,
Ming

