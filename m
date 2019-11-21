Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9283CC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 08:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AB682089D
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 08:55:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="axv/5Ts9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfKUIz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 03:55:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51504 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726765AbfKUIzz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Nov 2019 03:55:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574326552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DAhJV5arK6AsTYtgLyjX7wB4e5K+gxjAxRsNoHVoTLM=;
        b=axv/5Ts9APaQWHOuuN1cTspVXdlRos37PdJyn7BDmzAiRl075dROUhjt2wXis583AZgXae
        LbpHTAvDSAhhEISYN2qMoGi5i+TzZRVQfqbmqyn+3mWm3T07mfFdZ66WVmknU13Qr1EAbJ
        kuCMn6SvuRf0oeJgwvzdzt3zoFqeInI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-hoa8Kb7hMrSNWtrDn9ov2A-1; Thu, 21 Nov 2019 03:55:46 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D345800054;
        Thu, 21 Nov 2019 08:55:44 +0000 (UTC)
Received: from ming.t460p (ovpn-8-33.pek2.redhat.com [10.72.8.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E90A76FE5;
        Thu, 21 Nov 2019 08:55:35 +0000 (UTC)
Date:   Thu, 21 Nov 2019 16:55:31 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, hare@suse.com, bvanassche@acm.org,
        chenxiang66@hisilicon.com
Subject: Re: [PATCH RFC V2 3/5] blk-mq: Facilitate a shared sbitmap per tagset
Message-ID: <20191121085531.GC4755@ming.t460p>
References: <1574173658-76818-1-git-send-email-john.garry@huawei.com>
 <1574173658-76818-4-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
In-Reply-To: <1574173658-76818-4-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: hoa8Kb7hMrSNWtrDn9ov2A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 19, 2019 at 10:27:36PM +0800, John Garry wrote:
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
> ---
>  block/bfq-iosched.c    |  4 +--
>  block/blk-mq-debugfs.c |  4 +--
>  block/blk-mq-sched.c   | 14 ++++++++
>  block/blk-mq-tag.c     | 74 +++++++++++++++++++++++++++++++++---------
>  block/blk-mq-tag.h     | 15 +++++++--
>  block/blk-mq.c         | 57 +++++++++++++++++++++++++++++---
>  block/blk-mq.h         |  5 +++
>  block/kyber-iosched.c  |  4 +--
>  include/linux/blk-mq.h |  7 ++++
>  9 files changed, 157 insertions(+), 27 deletions(-)
>=20
> diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
> index 0319d6339822..9633c864af07 100644
> --- a/block/bfq-iosched.c
> +++ b/block/bfq-iosched.c
> @@ -6327,8 +6327,8 @@ static void bfq_depth_updated(struct blk_mq_hw_ctx =
*hctx)
>  =09struct blk_mq_tags *tags =3D hctx->sched_tags;
>  =09unsigned int min_shallow;
> =20
> -=09min_shallow =3D bfq_update_depths(bfqd, &tags->bitmap_tags);
> -=09sbitmap_queue_min_shallow_depth(&tags->bitmap_tags, min_shallow);
> +=09min_shallow =3D bfq_update_depths(bfqd, tags->pbitmap_tags);
> +=09sbitmap_queue_min_shallow_depth(tags->pbitmap_tags, min_shallow);
>  }
> =20
>  static int bfq_init_hctx(struct blk_mq_hw_ctx *hctx, unsigned int index)
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 33a40ae1d60f..9cf2f09c08e4 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -483,7 +483,7 @@ static int hctx_tags_bitmap_show(void *data, struct s=
eq_file *m)
>  =09res =3D mutex_lock_interruptible(&q->sysfs_lock);
>  =09if (res)
>  =09=09goto out;
> -=09if (hctx->tags)
> +=09if (hctx->tags) /* We should just iterate the relevant bits for this =
hctx FIXME */
>  =09=09sbitmap_bitmap_show(&hctx->tags->bitmap_tags.sb, m);
>  =09mutex_unlock(&q->sysfs_lock);
> =20
> @@ -517,7 +517,7 @@ static int hctx_sched_tags_bitmap_show(void *data, st=
ruct seq_file *m)
>  =09res =3D mutex_lock_interruptible(&q->sysfs_lock);
>  =09if (res)
>  =09=09goto out;
> -=09if (hctx->sched_tags)
> +=09if (hctx->sched_tags) /* We should just iterate the relevant bits for=
 this hctx FIXME */
>  =09=09sbitmap_bitmap_show(&hctx->sched_tags->bitmap_tags.sb, m);
>  =09mutex_unlock(&q->sysfs_lock);
> =20
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index ca22afd47b3d..b23547f10949 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -492,6 +492,7 @@ static void blk_mq_sched_tags_teardown(struct request=
_queue *q)
> =20
>  int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
>  {
> +=09struct blk_mq_tag_set *tag_set =3D q->tag_set;
>  =09struct blk_mq_hw_ctx *hctx;
>  =09struct elevator_queue *eq;
>  =09unsigned int i;
> @@ -537,6 +538,19 @@ int blk_mq_init_sched(struct request_queue *q, struc=
t elevator_type *e)
>  =09=09blk_mq_debugfs_register_sched_hctx(q, hctx);
>  =09}
> =20
> +=09if (blk_mq_is_sbitmap_shared(tag_set)) {
> +=09=09if (!blk_mq_init_sched_shared_sbitmap(tag_set, q->nr_requests)) {
> +=09=09=09ret =3D -ENOMEM;
> +=09=09=09goto err;
> +=09=09}
> +=09=09queue_for_each_hw_ctx(q, hctx, i) {
> +=09=09=09struct blk_mq_tags *tags =3D hctx->sched_tags;
> +
> +=09=09=09tags->pbitmap_tags =3D &tag_set->sched_shared_bitmap_tags;
> +=09=09=09tags->pbreserved_tags =3D &tag_set->sched_shared_breserved_tags=
;

This kind of sharing is wrong, sched tags should be request queue wide
instead of tagset wide, and each request queue has its own & independent
scheduler queue.

> +=09=09}
> +=09}
> +
>  =09return 0;
> =20
>  err:
> diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
> index 42792942b428..6625bebb46c3 100644
> --- a/block/blk-mq-tag.c
> +++ b/block/blk-mq-tag.c
> @@ -35,9 +35,9 @@ bool __blk_mq_tag_busy(struct blk_mq_hw_ctx *hctx)
>   */
>  void blk_mq_tag_wakeup_all(struct blk_mq_tags *tags, bool include_reserv=
e)
>  {
> -=09sbitmap_queue_wake_all(&tags->bitmap_tags);
> +=09sbitmap_queue_wake_all(tags->pbitmap_tags);
>  =09if (include_reserve)
> -=09=09sbitmap_queue_wake_all(&tags->breserved_tags);
> +=09=09sbitmap_queue_wake_all(tags->pbreserved_tags);
>  }
> =20
>  /*
> @@ -113,10 +113,10 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_dat=
a *data)
>  =09=09=09WARN_ON_ONCE(1);
>  =09=09=09return BLK_MQ_TAG_FAIL;
>  =09=09}
> -=09=09bt =3D &tags->breserved_tags;
> +=09=09bt =3D tags->pbreserved_tags;
>  =09=09tag_offset =3D 0;
>  =09} else {
> -=09=09bt =3D &tags->bitmap_tags;
> +=09=09bt =3D tags->pbitmap_tags;
>  =09=09tag_offset =3D tags->nr_reserved_tags;
>  =09}
> =20
> @@ -162,9 +162,9 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data =
*data)
>  =09=09=09=09=09=09data->ctx);
>  =09=09tags =3D blk_mq_tags_from_data(data);
>  =09=09if (data->flags & BLK_MQ_REQ_RESERVED)
> -=09=09=09bt =3D &tags->breserved_tags;
> +=09=09=09bt =3D tags->pbreserved_tags;
>  =09=09else
> -=09=09=09bt =3D &tags->bitmap_tags;
> +=09=09=09bt =3D tags->pbitmap_tags;
> =20
>  =09=09/*
>  =09=09 * If destination hw queue is changed, fake wake up on
> @@ -190,10 +190,10 @@ void blk_mq_put_tag(struct blk_mq_tags *tags, struc=
t blk_mq_ctx *ctx,
>  =09=09const int real_tag =3D tag - tags->nr_reserved_tags;
> =20
>  =09=09BUG_ON(real_tag >=3D tags->nr_tags);
> -=09=09sbitmap_queue_clear(&tags->bitmap_tags, real_tag, ctx->cpu);
> +=09=09sbitmap_queue_clear(tags->pbitmap_tags, real_tag, ctx->cpu);
>  =09} else {
>  =09=09BUG_ON(tag >=3D tags->nr_reserved_tags);
> -=09=09sbitmap_queue_clear(&tags->breserved_tags, tag, ctx->cpu);
> +=09=09sbitmap_queue_clear(tags->pbreserved_tags, tag, ctx->cpu);
>  =09}
>  }
> =20
> @@ -220,7 +220,7 @@ static bool bt_iter(struct sbitmap *bitmap, unsigned =
int bitnr, void *data)
>  =09 * We can hit rq =3D=3D NULL here, because the tagging functions
>  =09 * test and set the bit before assigning ->rqs[].
>  =09 */
> -=09if (rq && rq->q =3D=3D hctx->queue)
> +=09if (rq && rq->q =3D=3D hctx->queue && rq->mq_hctx =3D=3D hctx)
>  =09=09return iter_data->fn(hctx, rq, iter_data->data, reserved);
>  =09return true;
>  }
> @@ -321,8 +321,8 @@ static void blk_mq_all_tag_busy_iter(struct blk_mq_ta=
gs *tags,
>  =09=09busy_tag_iter_fn *fn, void *priv)
>  {
>  =09if (tags->nr_reserved_tags)
> -=09=09bt_tags_for_each(tags, &tags->breserved_tags, fn, priv, true);
> -=09bt_tags_for_each(tags, &tags->bitmap_tags, fn, priv, false);
> +=09=09bt_tags_for_each(tags, tags->pbreserved_tags, fn, priv, true);
> +=09bt_tags_for_each(tags, tags->pbitmap_tags, fn, priv, false);
>  }
> =20
>  /**
> @@ -419,8 +419,8 @@ void blk_mq_queue_tag_busy_iter(struct request_queue =
*q, busy_iter_fn *fn,
>  =09=09=09continue;
> =20
>  =09=09if (tags->nr_reserved_tags)
> -=09=09=09bt_for_each(hctx, &tags->breserved_tags, fn, priv, true);
> -=09=09bt_for_each(hctx, &tags->bitmap_tags, fn, priv, false);
> +=09=09=09bt_for_each(hctx, tags->pbreserved_tags, fn, priv, true);
> +=09=09bt_for_each(hctx, tags->pbitmap_tags, fn, priv, false);
>  =09}
>  =09blk_queue_exit(q);
>  }
> @@ -444,6 +444,9 @@ static struct blk_mq_tags *blk_mq_init_bitmap_tags(st=
ruct blk_mq_tags *tags,
>  =09=09     node))
>  =09=09goto free_bitmap_tags;
> =20
> +=09tags->pbitmap_tags =3D &tags->bitmap_tags;
> +=09tags->pbreserved_tags =3D &tags->breserved_tags;
> +
>  =09return tags;
>  free_bitmap_tags:
>  =09sbitmap_queue_free(&tags->bitmap_tags);
> @@ -452,7 +455,46 @@ static struct blk_mq_tags *blk_mq_init_bitmap_tags(s=
truct blk_mq_tags *tags,
>  =09return NULL;
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
> +bool blk_mq_init_sched_shared_sbitmap(struct blk_mq_tag_set *tag_set, un=
signed long nr_requests)
> +{
> +=09unsigned int depth =3D nr_requests -tag_set->reserved_tags;
> +=09int alloc_policy =3D BLK_MQ_FLAG_TO_ALLOC_POLICY(tag_set->flags);
> +=09bool round_robin =3D alloc_policy =3D=3D BLK_TAG_ALLOC_RR;
> +=09int node =3D tag_set->numa_node;
> +
> +=09if (bt_alloc(&tag_set->sched_shared_bitmap_tags, depth, round_robin, =
node))
> +=09=09return false;
> +=09if (bt_alloc(&tag_set->sched_shared_breserved_tags, tag_set->reserved=
_tags, round_robin,
> +=09=09=09 node))
> +=09=09goto free_bitmap_tags;
> +
> +=09return true;
> +free_bitmap_tags:
> +=09sbitmap_queue_free(&tag_set->sched_shared_bitmap_tags);
> +=09return false;
> +}
> +
> +struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
> +=09=09=09=09     unsigned int total_tags,
>  =09=09=09=09     unsigned int reserved_tags,
>  =09=09=09=09     int node, int alloc_policy)
>  {
> @@ -470,6 +512,8 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int tot=
al_tags,
>  =09tags->nr_tags =3D total_tags;
>  =09tags->nr_reserved_tags =3D reserved_tags;
> =20
> +=09if (blk_mq_is_sbitmap_shared(set))
> +=09=09return tags;
>  =09return blk_mq_init_bitmap_tags(tags, node, alloc_policy);
>  }
> =20
> @@ -526,7 +570,7 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hct=
x,
>  =09=09 * Don't need (or can't) update reserved tags here, they
>  =09=09 * remain static and should never need resizing.
>  =09=09 */
> -=09=09sbitmap_queue_resize(&tags->bitmap_tags,
> +=09=09sbitmap_queue_resize(tags->pbitmap_tags,
>  =09=09=09=09tdepth - tags->nr_reserved_tags);
>  =09}
> =20
> diff --git a/block/blk-mq-tag.h b/block/blk-mq-tag.h
> index e36bec8e0970..198b6fbe2c22 100644
> --- a/block/blk-mq-tag.h
> +++ b/block/blk-mq-tag.h
> @@ -13,20 +13,31 @@ struct blk_mq_tags {
> =20
>  =09atomic_t active_queues;
> =20
> +=09/* We should consider deleting these so they are not referenced by mi=
stake */
>  =09struct sbitmap_queue bitmap_tags;
>  =09struct sbitmap_queue breserved_tags;
> =20
> +=09struct sbitmap_queue *pbitmap_tags;
> +=09struct sbitmap_queue *pbreserved_tags;
> +
>  =09struct request **rqs;
>  =09struct request **static_rqs;
>  =09struct list_head page_list;
>  };
> =20
> =20
> -extern struct blk_mq_tags *blk_mq_init_tags(unsigned int nr_tags, unsign=
ed int reserved_tags, int node, int alloc_policy);
> +extern bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set);
> +extern bool blk_mq_init_sched_shared_sbitmap(struct blk_mq_tag_set *tag_=
set,
> +=09=09=09=09=09     unsigned long nr_requests);
> +extern struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *tag_s=
et,
> +=09=09=09=09=09    unsigned int nr_tags,
> +=09=09=09=09=09    unsigned int reserved_tags,
> +=09=09=09=09=09    int node, int alloc_policy);
>  extern void blk_mq_free_tags(struct blk_mq_tags *tags);
> =20
>  extern unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data);
> -extern void blk_mq_put_tag(struct blk_mq_tags *tags, struct blk_mq_ctx *=
ctx, unsigned int tag);
> +extern void blk_mq_put_tag(struct blk_mq_tags *tags,
> +=09=09=09   struct blk_mq_ctx *ctx, unsigned int tag);
>  extern int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
>  =09=09=09=09=09struct blk_mq_tags **tags,
>  =09=09=09=09=09unsigned int depth, bool can_grow);
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2d2956249ae9..8d5b21919c9a 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1089,7 +1089,7 @@ static int blk_mq_dispatch_wake(wait_queue_entry_t =
*wait, unsigned mode,
>  =09=09struct sbitmap_queue *sbq;
> =20
>  =09=09list_del_init(&wait->entry);
> -=09=09sbq =3D &hctx->tags->bitmap_tags;
> +=09=09sbq =3D hctx->tags->pbitmap_tags;
>  =09=09atomic_dec(&sbq->ws_active);
>  =09}
>  =09spin_unlock(&hctx->dispatch_wait_lock);
> @@ -1107,7 +1107,7 @@ static int blk_mq_dispatch_wake(wait_queue_entry_t =
*wait, unsigned mode,
>  static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx *hctx,
>  =09=09=09=09 struct request *rq)
>  {
> -=09struct sbitmap_queue *sbq =3D &hctx->tags->bitmap_tags;
> +=09struct sbitmap_queue *sbq =3D hctx->tags->pbitmap_tags;
>  =09struct wait_queue_head *wq;
>  =09wait_queue_entry_t *wait;
>  =09bool ret;
> @@ -2097,7 +2097,7 @@ struct blk_mq_tags *blk_mq_alloc_rq_map(struct blk_=
mq_tag_set *set,
>  =09if (node =3D=3D NUMA_NO_NODE)
>  =09=09node =3D set->numa_node;
> =20
> -=09tags =3D blk_mq_init_tags(nr_tags, reserved_tags, node,
> +=09tags =3D blk_mq_init_tags(set, nr_tags, reserved_tags, node,
>  =09=09=09=09BLK_MQ_FLAG_TO_ALLOC_POLICY(set->flags));
>  =09if (!tags)
>  =09=09return NULL;
> @@ -3100,6 +3100,20 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *se=
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
> +=09=09=09tags->pbitmap_tags =3D &set->shared_bitmap_tags;
> +=09=09=09tags->pbreserved_tags =3D &set->shared_breserved_tags;
> +=09=09}
> +=09}
> +
>  =09mutex_init(&set->tag_list_lock);
>  =09INIT_LIST_HEAD(&set->tag_list);
> =20
> @@ -3137,6 +3151,7 @@ int blk_mq_update_nr_requests(struct request_queue =
*q, unsigned int nr)
>  {
>  =09struct blk_mq_tag_set *set =3D q->tag_set;
>  =09struct blk_mq_hw_ctx *hctx;
> +=09bool sched_tags =3D false;
>  =09int i, ret;
> =20
>  =09if (!set)
> @@ -3160,6 +3175,7 @@ int blk_mq_update_nr_requests(struct request_queue =
*q, unsigned int nr)
>  =09=09=09ret =3D blk_mq_tag_update_depth(hctx, &hctx->tags, nr,
>  =09=09=09=09=09=09=09false);
>  =09=09} else {
> +=09=09=09sched_tags =3D true;
>  =09=09=09ret =3D blk_mq_tag_update_depth(hctx, &hctx->sched_tags,
>  =09=09=09=09=09=09=09nr, true);
>  =09=09}
> @@ -3169,8 +3185,41 @@ int blk_mq_update_nr_requests(struct request_queue=
 *q, unsigned int nr)
>  =09=09=09q->elevator->type->ops.depth_updated(hctx);
>  =09}
> =20
> -=09if (!ret)
> +=09/*
> +=09 * if ret is 0, all queues should have been updated to the same depth
> +=09 * if not, then maybe some have been updated - yuk, need to handle th=
is for shared sbitmap...
> +=09 * if some are updated, we should probably roll back the change altog=
ether. FIXME
> +=09 */
> +=09if (!ret) {
> +=09=09if (blk_mq_is_sbitmap_shared(set)) {
> +=09=09=09if (sched_tags) {
> +=09=09=09=09sbitmap_queue_free(&set->sched_shared_bitmap_tags);
> +=09=09=09=09sbitmap_queue_free(&set->sched_shared_breserved_tags);
> +=09=09=09=09if (!blk_mq_init_sched_shared_sbitmap(set, nr))
> +=09=09=09=09=09return -ENOMEM; /* fixup error handling */
> +
> +=09=09=09=09queue_for_each_hw_ctx(q, hctx, i) {
> +=09=09=09=09=09hctx->sched_tags->pbitmap_tags =3D &set->sched_shared_bit=
map_tags;
> +=09=09=09=09=09hctx->sched_tags->pbreserved_tags =3D &set->sched_shared_=
breserved_tags;
> +=09=09=09=09}
> +=09=09=09} else {
> +=09=09=09=09sbitmap_queue_free(&set->shared_bitmap_tags);
> +=09=09=09=09sbitmap_queue_free(&set->shared_breserved_tags);
> +=09=09=09=09if (!blk_mq_init_shared_sbitmap(set))
> +=09=09=09=09=09return -ENOMEM; /* fixup error handling */

No, we can't re-allocate driver tags here which are shared by all LUNs.
And you should see that 'can_grow' is set as false for driver tags
in blk_mq_update_nr_requests(), which can only touch per-request-queue
data, not tagset wide data.


Thanks,=20
Ming

