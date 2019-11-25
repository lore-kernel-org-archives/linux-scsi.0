Return-Path: <SRS0=IzRR=ZR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B787BC43141
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 03:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9059220815
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Nov 2019 03:01:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WYIOG6ny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfKYDBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Nov 2019 22:01:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23481 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727031AbfKYDBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Nov 2019 22:01:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574650858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6P1WQxGh+eOZbLMqUFKkHUrN72jbjpeZrRL9ImAF7xs=;
        b=WYIOG6nyHacllKmBOx+A5TSzWCnOFHYoBKt7qvNzYCtQkX7KAYlKnPgi2koOj9y/z9tspV
        oW5g/IIYUJ9Sfe/FXAS0ovg1wXRq+V9vwbMWI21YYU31Lv3DlNmIfGEriA52tqRKycIDyF
        hqba3aGST7Z3aEYX8aLyfmKiSxgsYtk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-ToudedkUOK6Ine94EMYuwQ-1; Sun, 24 Nov 2019 22:00:54 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55553800585;
        Mon, 25 Nov 2019 03:00:52 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C53E8600C1;
        Mon, 25 Nov 2019 03:00:43 +0000 (UTC)
Date:   Mon, 25 Nov 2019 11:00:39 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Re: [PATCH RFC V2 3/5] blk-mq: Facilitate a shared sbitmap per tagset
Message-ID: <20191125030039.GA29462@ming.t460p>
References: <1574173658-76818-1-git-send-email-john.garry@huawei.com>
 <1574173658-76818-4-git-send-email-john.garry@huawei.com>
 <20191121085531.GC4755@ming.t460p>
 <db93e0ba-118a-a4f6-41a8-064353568ef7@huawei.com>
MIME-Version: 1.0
In-Reply-To: <db93e0ba-118a-a4f6-41a8-064353568ef7@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: ToudedkUOK6Ine94EMYuwQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 21, 2019 at 10:24:16AM +0000, John Garry wrote:
> > >   int blk_mq_init_sched(struct request_queue *q, struct elevator_type=
 *e)
> > >   {
> > > +=09struct blk_mq_tag_set *tag_set =3D q->tag_set;
> > >   =09struct blk_mq_hw_ctx *hctx;
> > >   =09struct elevator_queue *eq;
> > >   =09unsigned int i;
> > > @@ -537,6 +538,19 @@ int blk_mq_init_sched(struct request_queue *q, s=
truct elevator_type *e)
> > >   =09=09blk_mq_debugfs_register_sched_hctx(q, hctx);
> > >   =09}
> > > +=09if (blk_mq_is_sbitmap_shared(tag_set)) {
> > > +=09=09if (!blk_mq_init_sched_shared_sbitmap(tag_set, q->nr_requests)=
) {
> > > +=09=09=09ret =3D -ENOMEM;
> > > +=09=09=09goto err;
> > > +=09=09}
> > > +=09=09queue_for_each_hw_ctx(q, hctx, i) {
> > > +=09=09=09struct blk_mq_tags *tags =3D hctx->sched_tags;
> > > +
> > > +=09=09=09tags->pbitmap_tags =3D &tag_set->sched_shared_bitmap_tags;
> > > +=09=09=09tags->pbreserved_tags =3D &tag_set->sched_shared_breserved_=
tags;
> >=20
> > This kind of sharing is wrong, sched tags should be request queue wide
> > instead of tagset wide, and each request queue has its own & independen=
t
> > scheduler queue.
>=20
> Right, so if we get get a scheduler tag we still need to get a driver tag=
,
> and this would be the "shared" tag.
>=20
> That makes things simpler then.
>=20
> >=20
> > > +=09=09}
> > > +=09}
> > > +
> > >   =09return 0;
> > >   err:
> > > diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> > > index 42792942b428..6625bebb46c3 100644
> > > --- a/block/blk-mq-tag.c
> > > +++ b/block/blk-mq-tag.c
> > > @@ -35,9 +35,9 @@ bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
> > >    */
> > >   void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool include_r=
eserve)
> > >   {
> > > -=09sbitmap_queue_wake_all(&tags->bitmap_tags);
> > > +=09sbitmap_queue_wake_all(tags->pbitmap_tags);
> > >   =09if (include_reserve)
> > > -=09=09sbitmap_queue_wake_all(&tags->breserved_tags);
> > > +=09=09sbitmap_queue_wake_all(tags->pbreserved_tags);
> > >   }
>=20
> [...]
>=20
>=20
> > >   =09mutex_init(&set->tag_list_lock);
> > >   =09INIT_LIST_HEAD(&set->tag_list);
> > > @@ -3137,6 +3151,7 @@ int blk_mq_update_nr_requests(struct request_qu=
eue *q, unsigned int nr)
> > >   {
> > >   =09struct blk_mq_tag_set *set =3D q->tag_set;
> > >   =09struct blk_mq_hw_ctx *hctx;
> > > +=09bool sched_tags =3D false;
> > >   =09int i, ret;
> > >   =09if (!set)
> > > @@ -3160,6 +3175,7 @@ int blk_mq_update_nr_requests(struct request_qu=
eue *q, unsigned int nr)
> > >   =09=09=09ret =3D blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
> > >   =09=09=09=09=09=09=09false);
> > >   =09=09} else {
> > > +=09=09=09sched_tags =3D true;
> > >   =09=09=09ret =3D blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
> > >   =09=09=09=09=09=09=09nr, true);
> > >   =09=09}
> > > @@ -3169,8 +3185,41 @@ int blk_mq_update_nr_requests(struct request_q=
ueue *q, unsigned int nr)
> > >   =09=09=09q->elevator->type->ops.depth_updated(hctx);
> > >   =09}
> > > -=09if (!ret)
> > > +=09/*
> > > +=09 * if ret is 0, all queues should have been updated to the same d=
epth
> > > +=09 * if not, then maybe some have been updated - yuk, need to handl=
e this for shared sbitmap...
> > > +=09 * if some are updated, we should probably roll back the change a=
ltogether. FIXME
> > > +=09 */
> > > +=09if (!ret) {
> > > +=09=09if (blk_mq_is_sbitmap_shared(set)) {
> > > +=09=09=09if (sched_tags) {
> > > +=09=09=09=09sbitmap_queue_free(&set->sched_shared_bitmap_tags);
> > > +=09=09=09=09sbitmap_queue_free(&set->sched_shared_breserved_tags);
> > > +=09=09=09=09if (!blk_mq_init_sched_shared_sbitmap(set, nr))
> > > +=09=09=09=09=09return -ENOMEM; /* fixup error handling */
> > > +
> > > +=09=09=09=09queue_for_each_hw_ctx(q, hctx, i) {
> > > +=09=09=09=09=09hctx->sched_tags->pbitmap_tags =3D &set->sched_shared=
_bitmap_tags;
> > > +=09=09=09=09=09hctx->sched_tags->pbreserved_tags =3D &set->sched_sha=
red_breserved_tags;
> > > +=09=09=09=09}
> > > +=09=09=09} else {
> > > +=09=09=09=09sbitmap_queue_free(&set->shared_bitmap_tags);
> > > +=09=09=09=09sbitmap_queue_free(&set->shared_breserved_tags);
> > > +=09=09=09=09if (!blk_mq_init_shared_sbitmap(set))
> > > +=09=09=09=09=09return -ENOMEM; /* fixup error handling */
> >=20
> > No, we can't re-allocate driver tags here which are shared by all LUNs.=
 > And you should see that 'can_grow' is set as false for driver tags
> > in blk_mq_update_nr_requests(), which can only touch per-request-queue
> > data, not tagset wide data.
>=20
> Yeah, I see that. We should just resize for driver tags bitmap.
>=20
> Personally I think the mainline code is a little loose here, as if we cou=
ld
> grow driver tags, then blk_mq_tagset.tags would be out-of-sync with the
> hctx->tags. Maybe that should be made more explicit in the code.
>=20
> BTW, do you have anything to say about this (modified slightly) comment:
>=20
> /*
>  * if ret !=3D 0, q->nr_requests would not be updated, yet the depth
>  * for some hctx sched tags may have changed - is that the right thing
>  * to do?
>  */

In theory, your concern is right, but so far we only support same
depth of hctx for either sched tags or driver tags, so not an issue
so far.


Thanks,
Ming

