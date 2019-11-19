Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F10C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 02:21:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12A2522311
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 02:21:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmlVjp5v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfKSCVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 21:21:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41255 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbfKSCVS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 21:21:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574130077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86O2DN0L3SDx4AnwOCmuZblOGVlZFGCkgSfX2dhNKhc=;
        b=ZmlVjp5vdRB8CVEz9kM9EAbGGyr+uAJ4nW/oM2FiXXDlzpE2uvcEsHOaDgiyaKn4SVg/q6
        yifg+o0vpXU2UKBbLy++RPgDp7qMHo4+zJ1TV5HpbMm0D1wKi635YD2W73A2azVF4hbrpq
        qdgMEw4ivW7W/75A74XyvdLu4qzEObM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-tcmB4oYwN1Gc4tkqhGpUTw-1; Mon, 18 Nov 2019 21:21:13 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43623801E5A;
        Tue, 19 Nov 2019 02:21:11 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BBCE600CD;
        Tue, 19 Nov 2019 02:21:03 +0000 (UTC)
Date:   Tue, 19 Nov 2019 10:20:58 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Long Li <longli@microsoft.com>, linux-block@vger.kernel.org
Subject: Re: [PATCH V2] scsi: core: only re-run queue in scsi_end_request()
 if device queue is busy
Message-ID: <20191119022058.GB391@ming.t460p>
References: <20191118100640.3673-1-ming.lei@redhat.com>
 <9e7b1a1c-f125-b359-4b59-675368e100f2@acm.org>
MIME-Version: 1.0
In-Reply-To: <9e7b1a1c-f125-b359-4b59-675368e100f2@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: tcmB4oYwN1Gc4tkqhGpUTw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 18, 2019 at 03:40:06PM -0800, Bart Van Assche wrote:
> On 11/18/19 2:06 AM, Ming Lei wrote:
> > Now the request queue is run in scsi_end_request() unconditionally if b=
oth
> > target queue and host queue is ready. We should have re-run request que=
ue
> > only after this device queue becomes busy for restarting this LUN only.
> >=20
> > Recently Long Li reported that cost of run queue may be very heavy in
> > case of high queue depth. So improve this situation by only running
> > the request queue when this LUN is busy.
> >=20
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Ewan D. Milne <emilne@redhat.com>
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: Damien Le Moal <damien.lemoal@wdc.com>
> > Cc: Long Li <longli@microsoft.com>
> > Cc: linux-block@vger.kernel.org
> > Reported-by: Long Li <longli@microsoft.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> > V2:
> > =09- commit log change, no any code change
> > =09- add reported-by tag
> >=20
> >=20
> >   drivers/scsi/scsi_lib.c    | 29 +++++++++++++++++++++++++++--
> >   include/scsi/scsi_device.h |  1 +
> >   2 files changed, 28 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 379533ce8661..62a86a82c38d 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -612,7 +612,7 @@ static bool scsi_end_request(struct request *req, b=
lk_status_t error,
> >   =09if (scsi_target(sdev)->single_lun ||
> >   =09    !list_empty(&sdev->host->starved_list))
> >   =09=09kblockd_schedule_work(&sdev->requeue_work);
> > -=09else
> > +=09else if (READ_ONCE(sdev->restart))
> >   =09=09blk_mq_run_hw_queues(q, true);
> >   =09percpu_ref_put(&q->q_usage_counter);
> > @@ -1632,8 +1632,33 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_=
ctx *hctx)
> >   =09struct request_queue *q =3D hctx->queue;
> >   =09struct scsi_device *sdev =3D q->queuedata;
> > -=09if (scsi_dev_queue_ready(q, sdev))
> > +=09if (scsi_dev_queue_ready(q, sdev)) {
> > +=09=09WRITE_ONCE(sdev->restart, 0);
> >   =09=09return true;
> > +=09}
> > +
> > +=09/*
> > +=09 * If all in-flight requests originated from this LUN are completed
> > +=09 * before setting .restart, sdev->device_busy will be observed as
> > +=09 * zero, then blk_mq_delay_run_hw_queue() will dispatch this reques=
t
> > +=09 * soon. Otherwise, completion of one of these request will observe
> > +=09 * the .restart flag, and the request queue will be run for handlin=
g
> > +=09 * this request, see scsi_end_request().
> > +=09 *
> > +=09 * However, the .restart flag may be cleared from other dispatch co=
de
> > +=09 * path after one inflight request is completed, then:
> > +=09 *
> > +=09 * 1) if this request is dispatched from scheduler queue or sw queu=
e one
> > +=09 * by one, this request will be handled in that dispatch path too g=
iven
> > +=09 * the request still stays at scheduler/sw queue when calling .get_=
budget()
> > +=09 * callback.
> > +=09 *
> > +=09 * 2) if this request is dispatched from hctx->dispatch or
> > +=09 * blk_mq_flush_busy_ctxs(), this request will be put into hctx->di=
spatch
> > +=09 * list soon, and blk-mq will be responsible for covering it, see
> > +=09 * blk_mq_dispatch_rq_list().
> > +=09 */
> > +=09WRITE_ONCE(sdev->restart, 1);
>=20
> Hi Ming,
>=20
> Are any memory barriers needed?
>=20
> Should WRITE_ONCE(sdev->restart, 1) perhaps be moved above the
> scsi_dev_queue_ready()? Consider e.g. the following scenario:
>=20
> sdev->restart =3D=3D 0
>=20
> scsi_mq_get_budget() calls scsi_dev_queue_ready() and that last function
> returns false.
>=20
> scsi_end_request() calls __blk_mq_end_request()
> scsi_end_request() skips the blk_mq_run_hw_queues() call

Suppose the sdev->restart isn't set as 1 or isn't visible by
scsi_end_request().

>=20
> scsi_mq_get_budget() changes sdev->restart into 1.

As the comment mentioned, if there isn't any in-flight requests
originated from this LUN, blk_mq_delay_run_hw_queue() in
scsi_mq_get_budget() will run the hw queue. If there is any
in-flight requests from this LUN, that request's scsi_end_request()
will handle that.

Then looks one barrier is required between 'WRITE_ONCE(sdev->restart, 1)'
and 'atomic_read(&sdev->device_busy) =3D=3D 0'.

And its pair is scsi_device_unbusy() and READ_ONCE(sdev->restart).
The barrier between the pair could be implied by __blk_mq_end_request(),
either __blk_mq_free_request() or rq->end_io.

>=20
> Can this race happen with the above patch applied? Will this scenario res=
ult
> in a queue stall?

If barrier is added between 'WRITE_ONCE(sdev->restart, 1)' and
'atomic_read(&sdev->device_busy) =3D=3D 0', the race should be avoided.

Will do that in V3.

Thanks,
Ming

