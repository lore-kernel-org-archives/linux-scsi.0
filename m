Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93A01C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 11:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 586C320727
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 11:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c4NV6z48"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfKZLFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 06:05:50 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbfKZLFt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 06:05:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574766348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=02JNOrrF++T0eAGhDvMbOuNQROCybLoys/1Evtnyj8s=;
        b=c4NV6z486j0/52Z2lur+p/nEupbywQN8s4gTyDptdQqKiF6yg6Om70pKqgH5mmOVqbP2B1
        rGrDCUlBHc4mbOqPjrUnpuoGoVDYCvSt+YqI25/bmfhlcGUuRk9t1BxTzfKc08DnX8KQ6q
        HQPffFWGFJA6oenm8hBqQarvGR/QPoI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-3pakwAX2MY2NdO7SXt6Clw-1; Tue, 26 Nov 2019 06:05:44 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7EC5107ACE3;
        Tue, 26 Nov 2019 11:05:42 +0000 (UTC)
Received: from ming.t460p (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D7FC60BE2;
        Tue, 26 Nov 2019 11:05:32 +0000 (UTC)
Date:   Tue, 26 Nov 2019 19:05:27 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
Message-ID: <20191126110527.GE32135@ming.t460p>
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-5-hare@suse.de>
MIME-Version: 1.0
In-Reply-To: <20191126091416.20052-5-hare@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 3pakwAX2MY2NdO7SXt6Clw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 26, 2019 at 10:14:12AM +0100, Hannes Reinecke wrote:
> From: John Garry <john.garry@huawei.com>
>=20
> Some SCSI HBAs (such as HPSA, megaraid, mpt3sas, hisi_sas_v3 ..) support
> multiple reply queues with single hostwide tags.
>=20
> In addition, these drivers want to use interrupt assignment in
> pci_alloc_irq_vectors(PCI_IRQ_AFFINITY). However, as discussed in [0],
> CPU hotplug may cause in-flight IO completion to not be serviced when an
> interrupt is shutdown.
>=20
> To solve that problem, Ming's patchset to drain hctx's should ensure no
> IOs are missed in-flight [1].
>=20
> However, to take advantage of that patchset, we need to map the HBA HW
> queues to blk mq hctx's; to do that, we need to expose the HBA HW queues.
>=20
> In making that transition, the per-SCSI command request tags are no
> longer unique per Scsi host - they are just unique per hctx. As such, the
> HBA LLDD would have to generate this tag internally, which has a certain
> performance overhead.
>=20
> However another problem is that blk mq assumes the host may accept
> (Scsi_host.can_queue * #hw queue) commands. In [2], we removed the Scsi
> host busy counter, which would stop the LLDD being sent more than
> .can_queue commands; however, we should still ensure that the block layer
> does not issue more than .can_queue commands to the Scsi host.
>=20
> To solve this problem, introduce a shared sbitmap per blk_mq_tag_set,
> which may be requested at init time.
>=20
> New flag BLK_MQ_F_TAG_HCTX_SHARED should be set when requesting the
> tagset to indicate whether the shared sbitmap should be used.
>=20
> Even when BLK_MQ_F_TAG_HCTX_SHARED is set, we still allocate a full set o=
f
> tags and requests per hctx; the reason for this is that if we only alloca=
te
> tags and requests for a single hctx - like hctx0 - we may break block
> drivers which expect a request be associated with a specific hctx, i.e.
> not hctx0.
>=20
> This is based on work originally from Ming Lei in [3] and from Bart's
> suggestion in [4].
>=20
> [0] https://lore.kernel.org/linux-block/alpine.DEB.2.21.1904051331270.180=
2@nanos.tec.linutronix.de/
> [1] https://lore.kernel.org/linux-block/20191014015043.25029-1-ming.lei@r=
edhat.com/
> [2] https://lore.kernel.org/linux-scsi/20191025065855.6309-1-ming.lei@red=
hat.com/
> [3] https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@r=
edhat.com/
> [4] https://lore.kernel.org/linux-block/ff77beff-5fd9-9f05-12b6-826922bac=
e1f@huawei.com/T/#m3db0a602f095cbcbff27e9c884d6b4ae826144be
>=20
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  block/blk-mq-sched.c   |  8 ++++++--
>  block/blk-mq-tag.c     | 36 +++++++++++++++++++++++++++++-------
>  block/blk-mq-tag.h     |  6 +++++-
>  block/blk-mq.c         | 45 ++++++++++++++++++++++++++++++++++++--------=
-
>  block/blk-mq.h         |  7 ++++++-
>  include/linux/blk-mq.h |  7 +++++++
>  6 files changed, 89 insertions(+), 20 deletions(-)
>=20
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index ca22afd47b3d..f3589f42b96d 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -452,7 +452,7 @@ static void blk_mq_sched_free_tags(struct blk_mq_tag_=
set *set,
>  {
>  =09if (hctx->sched_tags) {
>  =09=09blk_mq_free_rqs(set, hctx->sched_tags, hctx_idx);
> -=09=09blk_mq_free_rq_map(hctx->sched_tags);
> +=09=09blk_mq_free_rq_map(hctx->sched_tags, false);
>  =09=09hctx->sched_tags =3D NULL;
>  =09}
>  }
> @@ -462,10 +462,14 @@ static int blk_mq_sched_alloc_tags(struct request_q=
ueue *q,
>  =09=09=09=09   unsigned int hctx_idx)
>  {
>  =09struct blk_mq_tag_set *set =3D q->tag_set;
> +=09int flags =3D set->flags;
>  =09int ret;
> =20
> +=09/* Scheduler tags are never shared */
> +=09set->flags &=3D ~BLK_MQ_F_TAG_HCTX_SHARED;
>  =09hctx->sched_tags =3D blk_mq_alloc_rq_map(set, hctx_idx, q->nr_request=
s,
>  =09=09=09=09=09       set->reserved_tags);
> +=09set->flags =3D flags;

This way is very fragile, race is made against other uses of
blk_mq_is_sbitmap_shared().

From performance viewpoint, all hctx belonging to this request queue should
share one scheduler tagset in case of BLK_MQ_F_TAG_HCTX_SHARED, cause
driver tag queue depth isn't changed.

>  =09if (!hctx->sched_tags)
>  =09=09return -ENOMEM;
> =20
> @@ -484,7 +488,7 @@ static void blk_mq_sched_tags_teardown(struct request=
_queue *q)
> =20
>  =09queue_for_each_hw_ctx(q, hctx, i) {
>  =09=09if (hctx->sched_tags) {
> -=09=09=09blk_mq_free_rq_map(hctx->sched_tags);
> +=09=09=09blk_mq_free_rq_map(hctx->sched_tags, false);
>  =09=09=09hctx->sched_tags =3D NULL;
>  =09=09}
>  =09}
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 332d71cd3976..53b4c4c53c6a 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -228,7 +228,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned =
int bitnr, void *data)
>  =09 * We can hit rq =3D=3D NULL here, because the tagging functions
>  =09 * test and set the bit before assigning ->rqs[].
>  =09 */
> -=09if (rq && rq->q =3D=3D hctx->queue)
> +=09if (rq && rq->q =3D=3D hctx->queue && rq->mq_hctx =3D=3D hctx)
>  =09=09return iter_data->fn(hctx, rq, iter_data->data, reserved);
>  =09return true;
>  }
> @@ -470,7 +470,27 @@ static int blk_mq_init_bitmap_tags(struct blk_mq_tag=
s *tags,
>  =09return -ENOMEM;
>  }
> =20
> -struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
> +bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set)
> +{
> +=09unsigned int depth =3D tag_set->queue_depth -tag_set->reserved_tags;
> +=09int alloc_policy =3D BLK_MQ_FLAG_TO_ALLOC_POLICY(tag_set->flags);
> +=09bool round_robin =3D alloc_policy =3D=3D BLK_TAG_ALLOC_RR;
> +=09int node =3D tag_set->numa_node;
> +
> +=09if (bt_alloc(&tag_set->shared_bitmap_tags, depth, round_robin, node))
> +=09=09return false;
> +=09if (bt_alloc(&tag_set->shared_breserved_tags, tag_set->reserved_tags,=
 round_robin,
> +=09=09=09 node))
> +=09=09goto free_bitmap_tags;
> +
> +=09return true;
> +free_bitmap_tags:
> +=09sbitmap_queue_free(&tag_set->shared_bitmap_tags);
> +=09return false;
> +}
> +
> +struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
> +=09=09=09=09     unsigned int total_tags,
>  =09=09=09=09     unsigned int reserved_tags,
>  =09=09=09=09     int node, int alloc_policy)
>  {
> @@ -488,9 +508,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int to=
tal_tags,
>  =09tags->nr_tags =3D total_tags;
>  =09tags->nr_reserved_tags =3D reserved_tags;
> =20
> -=09if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
> -=09=09kfree(tags);
> -=09=09tags =3D NULL;
> +=09if (!blk_mq_is_sbitmap_shared(set)) {
> +=09=09if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
> +=09=09=09kfree(tags);
> +=09=09=09tags =3D NULL;
> +=09=09}
>  =09}
>  =09return tags;
>  }
> @@ -538,12 +560,12 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *h=
ctx,
>  =09=09=09return -ENOMEM;
>  =09=09ret =3D blk_mq_alloc_rqs(set, new, hctx->queue_num, tdepth);
>  =09=09if (ret) {
> -=09=09=09blk_mq_free_rq_map(new);
> +=09=09=09blk_mq_free_rq_map(new, blk_mq_is_sbitmap_shared(set));
>  =09=09=09return -ENOMEM;
>  =09=09}
> =20
>  =09=09blk_mq_free_rqs(set, *tagsptr, hctx->queue_num);
> -=09=09blk_mq_free_rq_map(*tagsptr);
> +=09=09blk_mq_free_rq_map(*tagsptr, blk_mq_is_sbitmap_shared(set));
>  =09=09*tagsptr =3D new;
>  =09} else {
>  =09=09/*
> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
> index 10b66fd4664a..279a861c7e58 100644
> --- a/block/blk-mq-tag.h
> +++ b/block/blk-mq-tag.h
> @@ -22,7 +22,11 @@ struct blk_mq_tags {
>  };
> =20
> =20
> -extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsign=
ed int reserved_tags, int node, int alloc_policy);
> +extern bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set);
> +extern struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *tag_s=
et,
> +=09=09=09=09=09    unsigned int nr_tags,
> +=09=09=09=09=09    unsigned int reserved_tags,
> +=09=09=09=09=09    int node, int alloc_policy);
>  extern void blk_mq_free_tags(struct blk_mq_tags *tags);
> =20
>  extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f0c40fcbd8ae..db87b0f57dbe 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2075,13 +2075,14 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, =
struct blk_mq_tags *tags,
>  =09}
>  }
> =20
> -void blk_mq_free_rq_map(struct blk_mq_tags *tags)
> +void blk_mq_free_rq_map(struct blk_mq_tags *tags, bool shared)
>  {
>  =09kfree(tags->rqs);
>  =09tags->rqs =3D NULL;
>  =09kfree(tags->static_rqs);
>  =09tags->static_rqs =3D NULL;
> -=09blk_mq_free_tags(tags);
> +=09if (!shared)
> +=09=09blk_mq_free_tags(tags);
>  }
> =20
>  struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
> @@ -2096,7 +2097,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_=
mq_tag_set *set,
>  =09if (node =3D=3D NUMA_NO_NODE)
>  =09=09node =3D set->numa_node;
> =20
> -=09tags =3D blk_mq_init_tags(nr_tags, reserved_tags, node,
> +=09tags =3D blk_mq_init_tags(set, nr_tags, reserved_tags, node,
>  =09=09=09=09BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
>  =09if (!tags)
>  =09=09return NULL;
> @@ -2105,7 +2106,8 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_=
mq_tag_set *set,
>  =09=09=09=09 GFP_NOIO | __GFP_NOWARN | __GFP_NORETRY,
>  =09=09=09=09 node);
>  =09if (!tags->rqs) {
> -=09=09blk_mq_free_tags(tags);
> +=09=09if (!blk_mq_is_sbitmap_shared(set))
> +=09=09=09blk_mq_free_tags(tags);
>  =09=09return NULL;
>  =09}
> =20
> @@ -2114,7 +2116,8 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_=
mq_tag_set *set,
>  =09=09=09=09=09node);
>  =09if (!tags->static_rqs) {
>  =09=09kfree(tags->rqs);
> -=09=09blk_mq_free_tags(tags);
> +=09=09if (!blk_mq_is_sbitmap_shared(set))
> +=09=09=09blk_mq_free_tags(tags);
>  =09=09return NULL;
>  =09}
> =20
> @@ -2446,7 +2449,7 @@ static bool __blk_mq_alloc_rq_map(struct blk_mq_tag=
_set *set, int hctx_idx)
>  =09if (!ret)
>  =09=09return true;
> =20
> -=09blk_mq_free_rq_map(set->tags[hctx_idx]);
> +=09blk_mq_free_rq_map(set->tags[hctx_idx], blk_mq_is_sbitmap_shared(set)=
);
>  =09set->tags[hctx_idx] =3D NULL;
>  =09return false;
>  }
> @@ -2456,7 +2459,8 @@ static void blk_mq_free_map_and_requests(struct blk=
_mq_tag_set *set,
>  {
>  =09if (set->tags && set->tags[hctx_idx]) {
>  =09=09blk_mq_free_rqs(set, set->tags[hctx_idx], hctx_idx);
> -=09=09blk_mq_free_rq_map(set->tags[hctx_idx]);
> +=09=09blk_mq_free_rq_map(set->tags[hctx_idx],
> +=09=09=09=09   blk_mq_is_sbitmap_shared(set));
>  =09=09set->tags[hctx_idx] =3D NULL;
>  =09}

Who will free the shared tags finally in case of blk_mq_is_sbitmap_shared()=
?

>  }
> @@ -2954,7 +2958,7 @@ static int __blk_mq_alloc_rq_maps(struct blk_mq_tag=
_set *set)
> =20
>  out_unwind:
>  =09while (--i >=3D 0)
> -=09=09blk_mq_free_rq_map(set->tags[i]);
> +=09=09blk_mq_free_rq_map(set->tags[i], blk_mq_is_sbitmap_shared(set));
> =20
>  =09return -ENOMEM;
>  }
> @@ -3099,6 +3103,20 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *se=
t)
>  =09if (ret)
>  =09=09goto out_free_mq_map;
> =20
> +=09if (blk_mq_is_sbitmap_shared(set)) {
> +=09=09if (!blk_mq_init_shared_sbitmap(set)) {
> +=09=09=09ret =3D -ENOMEM;
> +=09=09=09goto out_free_mq_map;
> +=09=09}
> +
> +=09=09for (i =3D 0; i < set->nr_hw_queues; i++) {
> +=09=09=09struct blk_mq_tags *tags =3D set->tags[i];
> +
> +=09=09=09tags->bitmap_tags =3D &set->shared_bitmap_tags;
> +=09=09=09tags->breserved_tags =3D &set->shared_breserved_tags;
> +=09=09}
> +=09}
> +
>  =09mutex_init(&set->tag_list_lock);
>  =09INIT_LIST_HEAD(&set->tag_list);
> =20
> @@ -3168,8 +3186,17 @@ int blk_mq_update_nr_requests(struct request_queue=
 *q, unsigned int nr)
>  =09=09=09q->elevator->type->ops.depth_updated(hctx);
>  =09}
> =20
> -=09if (!ret)
> +=09if (!ret) {
> +=09=09if (blk_mq_is_sbitmap_shared(set)) {
> +=09=09=09sbitmap_queue_resize(&set->shared_bitmap_tags, nr);
> +=09=09=09sbitmap_queue_resize(&set->shared_breserved_tags, nr);
> +=09=09}

The above change is wrong in case of hctx->sched_tags.

>  =09=09q->nr_requests =3D nr;
> +=09}
> +=09/*
> +=09 * if ret !=3D 0, q->nr_requests would not be updated, yet the depth
> +=09 * for some hctx may have changed - is that right?
> +=09 */
> =20
>  =09blk_mq_unquiesce_queue(q);
>  =09blk_mq_unfreeze_queue(q);
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 78d38b5f2793..c4b8213dfdfc 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -53,7 +53,7 @@ struct request *blk_mq_dequeue_from_ctx(struct blk_mq_h=
w_ctx *hctx,
>   */
>  void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tag=
s,
>  =09=09     unsigned int hctx_idx);
> -void blk_mq_free_rq_map(struct blk_mq_tags *tags);
> +void blk_mq_free_rq_map(struct blk_mq_tags *tags, bool shared);
>  struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_mq_tag_set *set,
>  =09=09=09=09=09unsigned int hctx_idx,
>  =09=09=09=09=09unsigned int nr_tags,
> @@ -166,6 +166,11 @@ struct blk_mq_alloc_data {
>  =09struct blk_mq_hw_ctx *hctx;
>  };
> =20
> +static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set *tag_s=
et)
> +{
> +=09return !!(tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED);
> +}
> +
>  static inline struct blk_mq_tags *blk_mq_tags_from_data(struct blk_mq_al=
loc_data *data)
>  {
>  =09if (data->flags & BLK_MQ_REQ_INTERNAL)
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 147185394a25..670e9a949d32 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -109,6 +109,12 @@ struct blk_mq_tag_set {
>  =09unsigned int=09=09flags;=09=09/* BLK_MQ_F_* */
>  =09void=09=09=09*driver_data;
> =20
> +=09struct sbitmap_queue shared_bitmap_tags;
> +=09struct sbitmap_queue shared_breserved_tags;
> +
> +=09struct sbitmap_queue sched_shared_bitmap_tags;
> +=09struct sbitmap_queue sched_shared_breserved_tags;
> +

The above two fields aren't used in this patch.

>  =09struct blk_mq_tags=09**tags;
> =20
>  =09struct mutex=09=09tag_list_lock;
> @@ -226,6 +232,7 @@ struct blk_mq_ops {
>  enum {
>  =09BLK_MQ_F_SHOULD_MERGE=09=3D 1 << 0,
>  =09BLK_MQ_F_TAG_QUEUE_SHARED=09=3D 1 << 1,
> +=09BLK_MQ_F_TAG_HCTX_SHARED=09=3D 1 << 2,
>  =09BLK_MQ_F_BLOCKING=09=3D 1 << 5,
>  =09BLK_MQ_F_NO_SCHED=09=3D 1 << 6,
>  =09BLK_MQ_F_ALLOC_POLICY_START_BIT =3D 8,
> --=20
> 2.16.4
>=20

--=20
Ming

