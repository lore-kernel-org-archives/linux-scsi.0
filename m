Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E911CCA9EB9
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 01:09:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B77C120650
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 01:09:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NtCnRoj3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390009AbfJXBJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 21:09:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30063 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389933AbfJXBJc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 21:09:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571879370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FwJaXiitWmDssKBbabUxsTSnK8RhergzhVtLMWfH58o=;
        b=NtCnRoj32FeCXpqdY87sA2OTiteCoKIjcoUdeZJGGnqkSUyacg0l79Jzyxq4bhDNH+qr5n
        AawNEkRt8Wa+SXP39dlFfa7jDxhONVcG+BqsLjY7FX3j/BucSVBAH+UpiAd9B25tbDnmy5
        ZKAqmIRnWm3Qpgyx8tyW8s6l1myeat8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-ybpXh325OGuEy6JCdJGzqg-1; Wed, 23 Oct 2019 21:09:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89B571800D6B;
        Thu, 24 Oct 2019 01:09:25 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 51F1E1001B28;
        Thu, 24 Oct 2019 01:09:16 +0000 (UTC)
Date:   Thu, 24 Oct 2019 09:09:12 +0800
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
Message-ID: <20191024010911.GC15426@ming.t460p>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-3-ming.lei@redhat.com>
 <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org>
 <75fd79dc441f2100719c545110ec9aa2@mail.gmail.com>
 <20191023012838.GB18083@ming.t460p>
 <1c40066e1f3361f2b6c8f90b4115ad01@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <1c40066e1f3361f2b6c8f90b4115ad01@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ybpXh325OGuEy6JCdJGzqg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 23, 2019 at 01:16:48PM +0530, Kashyap Desai wrote:
> V4 2/2] scsi: core: don't limit per-LUN queue depth
> > for SSD
> >
> > On Fri, Oct 18, 2019 at 12:00:07AM +0530, Kashyap Desai wrote:
> > > > On 10/9/19 2:32 AM, Ming Lei wrote:
> > > > > @@ -354,7 +354,8 @@ void scsi_device_unbusy(struct scsi_device
> > > > > *sdev,
> > > > struct scsi_cmnd *cmd)
> > > > >   =09if (starget->can_queue > 0)
> > > > >   =09=09atomic_dec(&starget->target_busy);
> > > > >
> > > > > -=09atomic_dec(&sdev->device_busy);
> > > > > +=09if (!blk_queue_nonrot(sdev->request_queue))
> > > > > +=09=09atomic_dec(&sdev->device_busy);
> > > > >   }
> > > > >
> > > >
> > > > Hi Ming,
> > > >
> > > > Does this patch impact the meaning of the queue_depth sysfs
> > > > attribute (see also sdev_store_queue_depth()) and also the queue
> > > > depth ramp up/down mechanism (see also
> > scsi_handle_queue_ramp_up())?
> > > > Have you considered to enable/disable busy tracking per LUN
> > > > depending on whether or not sdev-
> > > > >queue_depth < shost->can_queue?
> > > >
> > > > The megaraid and mpt3sas drivers read sdev->device_busy directly. I=
s
> > > > the current version of this patch compatible with these drivers?
> > >
> > > We need to know per scsi device outstanding in mpt3sas and
> > > megaraid_sas driver.
> >
> > Is the READ done in fast path or slow path? If it is on slow path, it
> should be
> > easy to do via blk_mq_in_flight_rw().
>=20
> READ is done in fast path.
>=20
> >
> > > Can we get supporting API from block layer (through SML)  ? something
> > > similar to "atomic_read(&hctx->nr_active)" which can be derived from
> > > sdev->request_queue->hctx ?
> > > At least for those driver which is nr_hw_queue =3D 1, it will be usef=
ul
> > > and we can avoid sdev->device_busy dependency.
> >
> > If you mean to add new atomic counter, we just move the .device_busy
> into
> > blk-mq, that can become new bottleneck.
>=20
> How about below ? We define and use below API instead of
> "atomic_read(&scp->device->device_busy) >" and it is giving expected
> value. I have not captured performance impact on max IOPs profile.
>=20
> Inline unsigned long sdev_nr_inflight_request(struct request_queue *q)
> {
>         struct blk_mq_hw_ctx *hctx;
>         unsigned long nr_requests =3D 0;
>         int i;
>=20
>         queue_for_each_hw_ctx(q, hctx, i)
>                 nr_requests +=3D atomic_read(&hctx->nr_active);
>=20
>         return nr_requests;
> }

There is still difference between above and .device_busy in case of
none, because .nr_active is accounted actually when allocating the request
instead of getting driver tag(or before calling .queue_rq).

Also the above only works in case that there are more than one active LUNs.

If you don't need it in case of single LUN AND don't care the difference
in case of none, the above API looks fine.

Thanks,
Ming

