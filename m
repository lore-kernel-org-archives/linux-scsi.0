Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1115CA9EC9
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DB1220659
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GJhQyodF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbfKEAYA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:24:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40339 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387415AbfKEAX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572913437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jck9dmD9OT2C+GvcwxOKYlYB+DPgH+aDy/0V3JYm61Q=;
        b=GJhQyodFUjCYFewjqETElrRrhVYuWgv2jrGRE0Cc+wXqM1zIZArGw2Xuu3kgwVtBdr4F2h
        ERkLlzOfRMId1fZGgeRkzv1JtnUPJDFdLk2wItLnVVrU5OAq/5pvoymp+zoDHj4nP73IWU
        yPT60nRgc0WU1MyRMMZnb/IQJHhbvoU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-n8ThcFQ6NzaQxkHwVhnDOg-1; Mon, 04 Nov 2019 19:23:48 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C9BB2800C73;
        Tue,  5 Nov 2019 00:23:46 +0000 (UTC)
Received: from ming.t460p (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C7AD608AC;
        Tue,  5 Nov 2019 00:23:37 +0000 (UTC)
Date:   Tue, 5 Nov 2019 08:23:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
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
Subject: Re: [RFC PATCH V4 2/2] scsi: core: don't limit per-LUN queue depth
 for SSD
Message-ID: <20191105002334.GA11436@ming.t460p>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-3-ming.lei@redhat.com>
 <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org>
 <75fd79dc441f2100719c545110ec9aa2@mail.gmail.com>
 <20191023012838.GB18083@ming.t460p>
 <1c40066e1f3361f2b6c8f90b4115ad01@mail.gmail.com>
 <20191024010911.GC15426@ming.t460p>
 <a7c33fc8ee31675bce38aca5894be2a6@mail.gmail.com>
 <20191025215815.GB7076@ming.t460p>
 <fde89689599da4da91330061e5920d8e@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <fde89689599da4da91330061e5920d8e@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: n8ThcFQ6NzaQxkHwVhnDOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 04, 2019 at 03:00:47PM +0530, Kashyap Desai wrote:
> > On Fri, Oct 25, 2019 at 03:34:16PM +0530, Kashyap Desai wrote:
> > > > >
> > > > > >
> > > > > > > Can we get supporting API from block layer (through SML)  ?
> > > > > > > something similar to "atomic_read(&hctx->nr_active)" which ca=
n
> > > > > > > be derived from
> > > > > > > sdev->request_queue->hctx ?
> > > > > > > At least for those driver which is nr_hw_queue =3D 1, it will=
 be
> > > > > > > useful and we can avoid sdev->device_busy dependency.
> > > > > >
> > > > > > If you mean to add new atomic counter, we just move the
> > > > > > .device_busy
> > > > > into
> > > > > > blk-mq, that can become new bottleneck.
> > > > >
> > > > > How about below ? We define and use below API instead of
> > > > > "atomic_read(&scp->device->device_busy) >" and it is giving
> > > > > expected value. I have not captured performance impact on max IOP=
s
> > profile.
> > > > >
> > > > > Inline unsigned long sdev_nr_inflight_request(struct request_queu=
e
> > > > > *q) {
> > > > >         struct blk_mq_hw_ctx *hctx;
> > > > >         unsigned long nr_requests =3D 0;
> > > > >         int i;
> > > > >
> > > > >         queue_for_each_hw_ctx(q, hctx, i)
> > > > >                 nr_requests +=3D atomic_read(&hctx->nr_active);
> > > > >
> > > > >         return nr_requests;
> > > > > }
> > > >
> > > > There is still difference between above and .device_busy in case of
> > > none,
> > > > because .nr_active is accounted actually when allocating the reques=
t
> > > instead
> > > > of getting driver tag(or before calling .queue_rq).
> > >
> > >
> > > This will be fine as long as we get outstanding from allocation time
> > > itself.
> >
> > Fine, but keep that in mind.
> >
> > > >
> > > > Also the above only works in case that there are more than one
> > > > active
> > > LUNs.
> > >
> > > I am not able to understand this part. We have tested on setup which
> > > has only one active LUN and it works. Can you help me to understand
> > > this part ?
> >
> > Please see blk_mq_rq_ctx_init():
> >
> >    if (data->hctx->flags & BLK_MQ_F_TAG_SHARED) {
> >                         rq_flags =3D RQF_MQ_INFLIGHT;
> .
> >    }
> >
> > blk_mq_init_allocated_queue
> > =09blk_mq_add_queue_tag_set
> > =09=09blk_mq_update_tag_set_depth(ture)
> > =09=09=09queue_set_hctx_shared(q, shared)
> >
>=20
> Ming, Thanks for the pointers. Now I am able to follow you.  Only single
> active LUN does not really require shared tag, so block layer starts usin=
g
> BLK_MQ_F_TAG_SHARED only after more than one active LUN.
> This limitation should be fine for megaraid_sas and mpt3sas driver. BTW,
> how about using  BLK_MQ_F_TAG_SHARED flags for one active lun case ?

I guess it won't be accepted, given .nr_active is used for fair driver
tag allocation among all LUNs, and the counting does has cost.

> It will help us to remove single lun limitation, so that any other driver
> module can take benefit of the same API.
>=20
> I think we have to provide API  " sdev_nr_inflight_request" from block
> layer OR scsi mid layer.
> For this RFC, we need additional API discussed in this thread so that
> megaraid_sas and mpt3sas driver does not break key functionality which ha=
s
> dependency on sdev-> device_busy.

I will take a close look at this usage, and see if there is better way.


Thanks,
Ming

