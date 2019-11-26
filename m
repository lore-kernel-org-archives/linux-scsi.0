Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EABDC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 15:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43FE42071E
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 15:55:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YxiNl0sH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbfKZPzF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 10:55:05 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:57979 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728274AbfKZPzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 10:55:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574783703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ar/D25SBEFcx0dq8v0mzY1o+k0hAybQEiuyuAMqXOeQ=;
        b=YxiNl0sHezmg9Y7Z9S8V1LUkCYksyEpPvQPNks/CP+LH2TVxKEzCU5znXXRtefoEm3dn9R
        FWada6JDzbkp8A+EVP8AJJ8YwpP32gOq69/8SUaJJVQMrH6NaWSs3KvGkHTAB11j+JyQB8
        l4906Uud9I6EDbnSACqo3qyp1kNz+zU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-2QMMGfMOP5i-B1WoQ7UDqQ-1; Tue, 26 Nov 2019 10:54:59 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 908511074FAD;
        Tue, 26 Nov 2019 15:54:57 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34D0B5D9CA;
        Tue, 26 Nov 2019 15:54:49 +0000 (UTC)
Date:   Tue, 26 Nov 2019 23:54:45 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
Message-ID: <20191126155445.GB17602@ming.t460p>
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-5-hare@suse.de>
 <20191126110527.GE32135@ming.t460p>
 <8a10e2f0-bbdc-8b47-a118-0fd7837ef44e@suse.de>
MIME-Version: 1.0
In-Reply-To: <8a10e2f0-bbdc-8b47-a118-0fd7837ef44e@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 2QMMGfMOP5i-B1WoQ7UDqQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 26, 2019 at 12:27:50PM +0100, Hannes Reinecke wrote:
> On 11/26/19 12:05 PM, Ming Lei wrote:
> > On Tue, Nov 26, 2019 at 10:14:12AM +0100, Hannes Reinecke wrote:
> [ .. ]
> >> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> >> index ca22afd47b3d..f3589f42b96d 100644
> >> --- a/block/blk-mq-sched.c
> >> +++ b/block/blk-mq-sched.c
> >> @@ -452,7 +452,7 @@ static void blk_mq_sched_free_tags(struct blk_mq_t=
ag_set *set,
> >>  {
> >>  =09if (hctx->sched_tags) {
> >>  =09=09blk_mq_free_rqs(set, hctx->sched_tags, hctx_idx);
> >> -=09=09blk_mq_free_rq_map(hctx->sched_tags);
> >> +=09=09blk_mq_free_rq_map(hctx->sched_tags, false);
> >>  =09=09hctx->sched_tags =3D NULL;
> >>  =09}
> >>  }
> >> @@ -462,10 +462,14 @@ static int blk_mq_sched_alloc_tags(struct reques=
t_queue *q,
> >>  =09=09=09=09   unsigned int hctx_idx)
> >>  {
> >>  =09struct blk_mq_tag_set *set =3D q->tag_set;
> >> +=09int flags =3D set->flags;
> >>  =09int ret;
> >> =20
> >> +=09/* Scheduler tags are never shared */
> >> +=09set->flags &=3D ~BLK_MQ_F_TAG_HCTX_SHARED;
> >>  =09hctx->sched_tags =3D blk_mq_alloc_rq_map(set, hctx_idx, q->nr_requ=
ests,
> >>  =09=09=09=09=09       set->reserved_tags);
> >> +=09set->flags =3D flags;
> >=20
> > This way is very fragile, race is made against other uses of
> > blk_mq_is_sbitmap_shared().
> >=20
> We are allocating tags, I don't think we're even able to modify it at
> this point.

Sched tags is allocated when setting up scheduler, which can be done
anytime from writing to queue/scheduler.

>=20
> > From performance viewpoint, all hctx belonging to this request queue sh=
ould
> > share one scheduler tagset in case of BLK_MQ_F_TAG_HCTX_SHARED, cause
> > driver tag queue depth isn't changed.
> >=20
> Hmm. Now you get me confused.
> In an earlier mail you said:
>=20
> > This kind of sharing is wrong, sched tags should be request
> > queue wide instead of tagset wide, and each request queue has
> > its own & independent scheduler queue.
>=20
> as in v2 we _had_ shared scheduler tags, too.
> Did I misread your comment above?

Yes, what I meant is that we can't share sched tags in tagset wide.

Now I mean we should share sched tags among all hctxs in same request
queue, and I believe I have described it clearly.


Thanks,=20
Ming

