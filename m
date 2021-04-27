Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A11C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D40461002
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 08:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhD0IzJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 04:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58753 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhD0IzI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 04:55:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619513665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZZ/NQlCaJK/0v5kyGD3++s9FSBVlBWJKG64tPlZ/6fs=;
        b=MFgugRFfKiRvNi2d6qxIo6xvnCojSSGHih7J9m0iG/ni2ghFFB1DKD9ynMVae0X886uxBh
        r8HdrjJp7mlAayfpEhI8tQmF30Pnqbl0ZLGbkNeN9f84GiJ/SJPtOTL/KrET+hSdHBhXZJ
        c4UHvb1rSh+Ppabpmh5A+Znm7AYivqo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-551-uLEy_RLKOnueLZtG0VH-0A-1; Tue, 27 Apr 2021 04:54:23 -0400
X-MC-Unique: uLEy_RLKOnueLZtG0VH-0A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB50C107ACCA;
        Tue, 27 Apr 2021 08:54:20 +0000 (UTC)
Received: from T590 (ovpn-13-248.pek2.redhat.com [10.72.13.248])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7301A100763C;
        Tue, 27 Apr 2021 08:54:11 +0000 (UTC)
Date:   Tue, 27 Apr 2021 16:54:17 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
Subject: Re: [PATCH 6/8] block: drivers: complete request locally from
 blk_mq_tagset_busy_iter
Message-ID: <YIfRObi3RTEbA5vd@T590>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <20210425085753.2617424-7-ming.lei@redhat.com>
 <bcdfc3a0-f5fa-dc06-8067-4349a133e531@acm.org>
 <YIZcuMkLV1+DKhLZ@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIZcuMkLV1+DKhLZ@T590>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 26, 2021 at 02:24:56PM +0800, Ming Lei wrote:
> On Sun, Apr 25, 2021 at 08:02:10PM -0700, Bart Van Assche wrote:
> > On 4/25/21 1:57 AM, Ming Lei wrote:
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index c289991ffaed..7cbaee282b6d 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -1568,7 +1568,11 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
> > >  	if (unlikely(test_and_set_bit(SCMD_STATE_COMPLETE, &cmd->state)))
> > >  		return;
> > >  	trace_scsi_dispatch_cmd_done(cmd);
> > > -	blk_mq_complete_request(cmd->request);
> > > +
> > > +	if (unlikely(host_byte(cmd->result) != DID_OK))
> > > +		blk_mq_complete_request_locally(cmd->request);
> > > +	else
> > > +		blk_mq_complete_request(cmd->request);
> > >  }
> > 
> > This change is so tricky that it deserves a comment.
> > 
> > An even better approach would be *not* to export
> > blk_mq_complete_request_locally() from the block layer to block drivers
> > and instead modify the block layer such that it completes a request on
> > the same CPU if request completion happens from inside the context of a
> > tag iteration function. That would save driver writers the trouble of
> > learning yet another block layer API.
> 
> Yeah, that is possible, and one request flag(eg. RQF_ITERATED) can be added.
> The flag is set before calling ->fn(), and evaluated in
> blk_mq_complete_request_remote().

Thinking of the issue further, we have grabbed rq->refcnt before calling
->fn(), not only request UAF is fixed, but also driver gets valid
request instance to check if the request has been completed, so we needn't
to consider the double completion issue[1] any more, which is supposed
to be covered by driver, such as, scsi uses SCMD_STATE_COMPLETE in
scsi_mq_done() for avoiding double completion.

[1] https://lore.kernel.org/linux-block/YIdWz8C5eklPvEiV@T590/T/#u

Thanks,
Ming

