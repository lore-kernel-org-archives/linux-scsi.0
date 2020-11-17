Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B71C388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 02:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98C172469D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 02:18:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2WioXuF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgKQCSa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 21:18:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727070AbgKQCSa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 21:18:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605579508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AKKtHa1h1PzW7noxlsAP8m0qc1sSSRJ+Gpxn2ZnlPMA=;
        b=P2WioXuFWAhJwxR2Z4nhERPQF1dy4o1MfTdQA/6hZk/S+2swzdjwHHDXfVafpNhfb4xcar
        597QUu8crPeHMu6XJ9FzlB6O0EjEKn2+S7V889zINPWFGylhTeaGcc7c0Xsps7mdBnAkdU
        QPLO0VuONZrqNokVJ6hULWAx2wFTmcU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-Et3En6DBOVaeMmozytIcaw-1; Mon, 16 Nov 2020 21:18:27 -0500
X-MC-Unique: Et3En6DBOVaeMmozytIcaw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 930AA80B736;
        Tue, 17 Nov 2020 02:18:25 +0000 (UTC)
Received: from T590 (ovpn-12-215.pek2.redhat.com [10.72.12.215])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DE09519D6C;
        Tue, 17 Nov 2020 02:18:17 +0000 (UTC)
Date:   Tue, 17 Nov 2020 10:18:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>
Subject: Re: [PATCH V4 11/12] scsi: make sure sdev->queue_depth is <=
 max(shost->can_queue, 1024)
Message-ID: <20201117021813.GD56247@T590>
References: <20201116090737.50989-1-ming.lei@redhat.com>
 <20201116090737.50989-12-ming.lei@redhat.com>
 <4479fc11-5c4f-e575-a253-e08c841c5cb2@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4479fc11-5c4f-e575-a253-e08c841c5cb2@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 16, 2020 at 10:44:54AM +0100, Hannes Reinecke wrote:
> On 11/16/20 10:07 AM, Ming Lei wrote:
> > Limit scsi device's queue depth is less than max(host->can_queue, 1024)
> > in scsi_change_queue_depth(), and 1024 is big enough for saturating
> > current fast SCSI LUN(SSD, or raid volume on multiple SSDs).
> > 
> > We need this patch for replacing sdev->device_busy with sbitmap which
> > has to be pre-allocated with reasonable max depth.
> > 
> > Cc: Omar Sandoval <osandov@fb.com>
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> > Cc: Ewan D. Milne <emilne@redhat.com>
> > Tested-by: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   drivers/scsi/scsi.c | 11 +++++++++++
> >   1 file changed, 11 insertions(+)
> > 
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index 24619c3bebd5..a28d48c850cf 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -214,6 +214,15 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
> >   	scsi_io_completion(cmd, good_bytes);
> >   }
> > +
> > +/*
> > + * 1024 is big enough for saturating the fast scsi LUN now
> > + */
> > +static int scsi_device_max_queue_depth(struct scsi_device *sdev)
> > +{
> > +	return max_t(int, sdev->host->can_queue, 1024);
> > +}
> > +
> 
> Shouldn't this rather be initialized with scsi_host->can_queue?

Multiple queues may be used for one single LUN, so in theory we should
return max queue depth as host->can_queue * host->nr_hw_queues, but
this number can be too big for the sbitmap's pre-allocation.

That is why this patch introduces one reasonable limit on this value
of max(sdev->host->can_queue, 1024). Suppose single SSD can be saturated
by ~128 requests, we still can saturate one LUN with 8 SSDs behind if
the hw queue depth is set as too low.

> These 'should be enough' settings inevitable turn out to be not enough in
> the long run ...

I have provided the theory behind this idea, not just simple 'should be
enough'.


Thanks,
Ming

