Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88BDDCA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 21:58:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53EE2222BD
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 21:58:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FXcwxJzq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfJYV6g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 17:58:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60422 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726285AbfJYV6f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Oct 2019 17:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572040714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XXUWTAUaV+/DEPQVukGSmuSsmAoEpYC9V4dz5mLhX/k=;
        b=FXcwxJzqz03i2+ASBy9sXGqeoEbdQSXRKJL0sG0pSv7ud0kCGaoGAg1d6wkc93/KtkQvpe
        2mC64mT6AzSUs2Bgkp+dNkcA9SzGaE6Ouv9afy4TwzDU9JNTmG78F71jTPPmW84CW4+l3k
        yDXUoT7fpV+kPJ3Fxu4II1H1+rPjIZE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-X42RoVTvNeaZzwSKLJDa3A-1; Fri, 25 Oct 2019 17:58:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D89080183E;
        Fri, 25 Oct 2019 21:58:29 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D0AE5D6A3;
        Fri, 25 Oct 2019 21:58:20 +0000 (UTC)
Date:   Sat, 26 Oct 2019 05:58:15 +0800
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
Message-ID: <20191025215815.GB7076@ming.t460p>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-3-ming.lei@redhat.com>
 <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org>
 <75fd79dc441f2100719c545110ec9aa2@mail.gmail.com>
 <20191023012838.GB18083@ming.t460p>
 <1c40066e1f3361f2b6c8f90b4115ad01@mail.gmail.com>
 <20191024010911.GC15426@ming.t460p>
 <a7c33fc8ee31675bce38aca5894be2a6@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <a7c33fc8ee31675bce38aca5894be2a6@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: X42RoVTvNeaZzwSKLJDa3A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 25, 2019 at 03:34:16PM +0530, Kashyap Desai wrote:
> > >
> > > >
> > > > > Can we get supporting API from block layer (through SML)  ?
> > > > > something similar to "atomic_read(&hctx->nr_active)" which can be
> > > > > derived from
> > > > > sdev->request_queue->hctx ?
> > > > > At least for those driver which is nr_hw_queue =3D 1, it will be
> > > > > useful and we can avoid sdev->device_busy dependency.
> > > >
> > > > If you mean to add new atomic counter, we just move the .device_bus=
y
> > > into
> > > > blk-mq, that can become new bottleneck.
> > >
> > > How about below ? We define and use below API instead of
> > > "atomic_read(&scp->device->device_busy) >" and it is giving expected
> > > value. I have not captured performance impact on max IOPs profile.
> > >
> > > Inline unsigned long sdev_nr_inflight_request(struct request_queue *q=
)
> > > {
> > >         struct blk_mq_hw_ctx *hctx;
> > >         unsigned long nr_requests =3D 0;
> > >         int i;
> > >
> > >         queue_for_each_hw_ctx(q, hctx, i)
> > >                 nr_requests +=3D atomic_read(&hctx->nr_active);
> > >
> > >         return nr_requests;
> > > }
> >
> > There is still difference between above and .device_busy in case of
> none,
> > because .nr_active is accounted actually when allocating the request
> instead
> > of getting driver tag(or before calling .queue_rq).
>=20
>=20
> This will be fine as long as we get outstanding from allocation time
> itself.

Fine, but keep that in mind.

> >
> > Also the above only works in case that there are more than one active
> LUNs.
>=20
> I am not able to understand this part. We have tested on setup which has
> only one active LUN and it works. Can you help me to understand this part
> ?

Please see blk_mq_rq_ctx_init():

   if (data->hctx->flags & BLK_MQ_F_TAG_SHARED) {
                        rq_flags =3D RQF_MQ_INFLIGHT;
                        atomic_inc(&data->hctx->nr_active);
   }

blk_mq_init_allocated_queue
=09blk_mq_add_queue_tag_set
=09=09blk_mq_update_tag_set_depth(ture)
=09=09=09queue_set_hctx_shared(q, shared)
=09=09

thanks,
Ming

