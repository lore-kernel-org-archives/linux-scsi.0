Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0B7CA9ECF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 828BD21929
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 09:30:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="atl3Eu5u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfKDJav (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 04:30:51 -0500
Received: from mail-il1-f181.google.com ([209.85.166.181]:44664 "EHLO
        mail-il1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfKDJau (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 04:30:50 -0500
Received: by mail-il1-f181.google.com with SMTP id w1so5314945ilq.11
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 01:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=eXfoLjhE5p22mD8X4EvYXPy5VnjlywBZrl7Z/DhsOVs=;
        b=atl3Eu5u4KB9Bb5tRhg86i3ulXjnRy59SSJ7f9I3lnrUDO0fzL1u3qcWRE37gHHETp
         03rZxHCqSo134cxW9mKFDEB94QXQ3D88k8Eux1hs1yuo6UmFd32U4rAxotriOAHYSW5I
         50yagTMC1eSBd7YcsRQmhK6TtPNbsjg/3ixjg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=eXfoLjhE5p22mD8X4EvYXPy5VnjlywBZrl7Z/DhsOVs=;
        b=rUKceNorE96bYLtQsjP7y6umhDPqCIC8lN9J+8SWVguNPwUx4CKI+AeMYsgOkYQRKd
         Zn6qlrFxPkjxyDk3NZonm1qsYhxj967kT6lxY2wJXLKh+Q1YnsEDbAeHimWrKK48GZgN
         4vgIcfMxxZ0HU/Z1WN1slcDoR8FYCxFmyajT1KqjGsbM8wDscYGFMcVRyfs2bKs83CKU
         w5MSIjnqmray/FgpAQjBWoHukgueu3MPV7VaMlZvN0SozL7jrDR3vATlK6mH51tpFNih
         pHyfHiN5PFfOroihFvd5V6PMWruW7LacBL/tpSYVukD4BDHWRIGGSBMlmyxxRF6Hs4pf
         venw==
X-Gm-Message-State: APjAAAXRSmgL/PMjGcZeomX1+TfML4i4yKO5G2PHoUYQu+BZpDFRtGOe
        34jgJJmNkapQpEYgIUVYWGY20Wy1a9W8vRq207gaaOH5
X-Google-Smtp-Source: APXvYqzTJTCSAZZVFzDXlzPD9cS7Mxv7kKZRe7o7HrzDqwHzcAiEakY3Gvj9oWExUgoacm+aAUwDGlcA5SXNFUeWd4I=
X-Received: by 2002:a05:6e02:789:: with SMTP id q9mr23152480ils.96.1572859849667;
 Mon, 04 Nov 2019 01:30:49 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20191009093241.21481-1-ming.lei@redhat.com> <20191009093241.21481-3-ming.lei@redhat.com>
 <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org> <75fd79dc441f2100719c545110ec9aa2@mail.gmail.com>
 <20191023012838.GB18083@ming.t460p> <1c40066e1f3361f2b6c8f90b4115ad01@mail.gmail.com>
 <20191024010911.GC15426@ming.t460p> <a7c33fc8ee31675bce38aca5894be2a6@mail.gmail.com>
 <20191025215815.GB7076@ming.t460p>
In-Reply-To: <20191025215815.GB7076@ming.t460p>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJ+aAV5wNbUGIJ6nkm2Ot6VMXRpiQIhodcgAyzU6WgBsIy1CAFrdb8sAhQC8V0BsoKNYwNg6TDCAMzmuAKlphzpQA==
Date:   Mon, 4 Nov 2019 15:00:47 +0530
Message-ID: <fde89689599da4da91330061e5920d8e@mail.gmail.com>
Subject: RE: [RFC PATCH V4 2/2] scsi: core: don't limit per-LUN queue depth
 for SSD
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Fri, Oct 25, 2019 at 03:34:16PM +0530, Kashyap Desai wrote:
> > > >
> > > > >
> > > > > > Can we get supporting API from block layer (through SML)  ?
> > > > > > something similar to "atomic_read(&hctx->nr_active)" which can
> > > > > > be derived from
> > > > > > sdev->request_queue->hctx ?
> > > > > > At least for those driver which is nr_hw_queue = 1, it will be
> > > > > > useful and we can avoid sdev->device_busy dependency.
> > > > >
> > > > > If you mean to add new atomic counter, we just move the
> > > > > .device_busy
> > > > into
> > > > > blk-mq, that can become new bottleneck.
> > > >
> > > > How about below ? We define and use below API instead of
> > > > "atomic_read(&scp->device->device_busy) >" and it is giving
> > > > expected value. I have not captured performance impact on max IOPs
> profile.
> > > >
> > > > Inline unsigned long sdev_nr_inflight_request(struct request_queue
> > > > *q) {
> > > >         struct blk_mq_hw_ctx *hctx;
> > > >         unsigned long nr_requests = 0;
> > > >         int i;
> > > >
> > > >         queue_for_each_hw_ctx(q, hctx, i)
> > > >                 nr_requests += atomic_read(&hctx->nr_active);
> > > >
> > > >         return nr_requests;
> > > > }
> > >
> > > There is still difference between above and .device_busy in case of
> > none,
> > > because .nr_active is accounted actually when allocating the request
> > instead
> > > of getting driver tag(or before calling .queue_rq).
> >
> >
> > This will be fine as long as we get outstanding from allocation time
> > itself.
>
> Fine, but keep that in mind.
>
> > >
> > > Also the above only works in case that there are more than one
> > > active
> > LUNs.
> >
> > I am not able to understand this part. We have tested on setup which
> > has only one active LUN and it works. Can you help me to understand
> > this part ?
>
> Please see blk_mq_rq_ctx_init():
>
>    if (data->hctx->flags & BLK_MQ_F_TAG_SHARED) {
>                         rq_flags = RQF_MQ_INFLIGHT;
.
>    }
>
> blk_mq_init_allocated_queue
> 	blk_mq_add_queue_tag_set
> 		blk_mq_update_tag_set_depth(ture)
> 			queue_set_hctx_shared(q, shared)
>

Ming, Thanks for the pointers. Now I am able to follow you.  Only single
active LUN does not really require shared tag, so block layer starts using
BLK_MQ_F_TAG_SHARED only after more than one active LUN.
This limitation should be fine for megaraid_sas and mpt3sas driver. BTW,
how about using  BLK_MQ_F_TAG_SHARED flags for one active lun case ?
It will help us to remove single lun limitation, so that any other driver
module can take benefit of the same API.

I think we have to provide API  " sdev_nr_inflight_request" from block
layer OR scsi mid layer.
For this RFC, we need additional API discussed in this thread so that
megaraid_sas and mpt3sas driver does not break key functionality which has
dependency on sdev-> device_busy.

>
> thanks,
> Ming
