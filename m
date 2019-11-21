Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6503FC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 00:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CB942089D
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 00:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VoYmzusf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKUAxt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 19:53:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60432 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726658AbfKUAxt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 19:53:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574297626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HG0/OMA4IePs0RwQcFpc3v10JQC01dLQlpMZrLx9Fik=;
        b=VoYmzusf8qRucvaC9NJcwHK4wy56Kd7P8W9aI8dO+xwiJOqzkAag6PjW0toOFKOqthzR/t
        516beU2qzbc6OTmzjaPis2K2N9mqTvYe1Mj6kLcv7C54g4b8XPCs/s4Ap1IPhM26szTt0a
        BcVsNnGocS1jqTssHtBjSrNijTEX/jY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-5Q7zU7eZOsaArDUQb6CWuA-1; Wed, 20 Nov 2019 19:53:38 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E455910CE792;
        Thu, 21 Nov 2019 00:53:36 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 670046E501;
        Thu, 21 Nov 2019 00:53:27 +0000 (UTC)
Date:   Thu, 21 Nov 2019 08:53:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
Message-ID: <20191121005323.GB24548@ming.t460p>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
MIME-Version: 1.0
In-Reply-To: <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 5Q7zU7eZOsaArDUQb6CWuA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2019 at 11:05:24AM +0100, Hannes Reinecke wrote:
> On 11/18/19 11:31 AM, Ming Lei wrote:
> > SCSI core uses the atomic variable of sdev->device_busy to track
> > in-flight IO requests dispatched to this scsi device. IO request may be
> > submitted from any CPU, so the cost for maintaining the shared atomic
> > counter can be very big on big NUMA machine with lots of CPU cores.
> >=20
> > sdev->queue_depth is usually used for two purposes: 1) improve IO merge=
;
> > 2) fair IO request scattered among all LUNs.
> >=20
> > blk-mq already provides fair request allocation among all active shared
> > request queues(LUNs), see hctx_may_queue().
> >=20
> > NVMe doesn't have such per-request-queue(namespace) queue depth, so it
> > is reasonable to ignore the limit for SCSI SSD too. Also IO merge won't
> > play big role for reaching top SSD performance.
> >=20
> > With this patch, big cost for tracking in-flight per-LUN requests via
> > atomic variable can be saved.
> >=20
> > Given QUEUE_FLAG_NONROT is read in IO path, we have to freeze queue
> > before changing this flag.
> >=20
> > Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> > Cc: Chaitra P B <chaitra.basappa@broadcom.com>
> > Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> > Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> > Cc: Ewan D. Milne <emilne@redhat.com>
> > Cc: Christoph Hellwig <hch@lst.de>,
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Bart Van Assche <bart.vanassche@wdc.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  block/blk-sysfs.c       | 14 +++++++++++++-
> >  drivers/scsi/scsi_lib.c | 24 ++++++++++++++++++------
> >  drivers/scsi/sd.c       |  4 ++++
> >  3 files changed, 35 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> > index fca9b158f4a0..9cc0dd5f88a1 100644
> > --- a/block/blk-sysfs.c
> > +++ b/block/blk-sysfs.c
> > @@ -281,6 +281,18 @@ QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
> >  QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
> >  #undef QUEUE_SYSFS_BIT_FNS
> > =20
> > +static ssize_t queue_store_nonrot_freeze(struct request_queue *q,
> > +=09=09const char *page, size_t count)
> > +{
> > +=09size_t ret;
> > +
> > +=09blk_mq_freeze_queue(q);
> > +=09ret =3D queue_store_nonrot(q, page, count);
> > +=09blk_mq_unfreeze_queue(q);
> > +
> > +=09return ret;
> > +}
> > +
> >  static ssize_t queue_zoned_show(struct request_queue *q, char *page)
> >  {
> >  =09switch (blk_queue_zoned_model(q)) {
> > @@ -642,7 +654,7 @@ static struct queue_sysfs_entry queue_write_zeroes_=
max_entry =3D {
> >  static struct queue_sysfs_entry queue_nonrot_entry =3D {
> >  =09.attr =3D {.name =3D "rotational", .mode =3D 0644 },
> >  =09.show =3D queue_show_nonrot,
> > -=09.store =3D queue_store_nonrot,
> > +=09.store =3D queue_store_nonrot_freeze,
> >  };
> > =20
> >  static struct queue_sysfs_entry queue_zoned_entry =3D {
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 62a86a82c38d..72655a049efd 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -354,7 +354,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, s=
truct scsi_cmnd *cmd)
> >  =09if (starget->can_queue > 0)
> >  =09=09atomic_dec(&starget->target_busy);
> > =20
> > -=09atomic_dec(&sdev->device_busy);
> > +=09if (!blk_queue_nonrot(sdev->request_queue))
> > +=09=09atomic_dec(&sdev->device_busy);
> >  }
> > =20
> >  static void scsi_kick_queue(struct request_queue *q)
> > @@ -410,7 +411,8 @@ static void scsi_single_lun_run(struct scsi_device =
*current_sdev)
> > =20
> >  static inline bool scsi_device_is_busy(struct scsi_device *sdev)
> >  {
> > -=09if (atomic_read(&sdev->device_busy) >=3D sdev->queue_depth)
> > +=09if (!blk_queue_nonrot(sdev->request_queue) &&
> > +=09=09=09atomic_read(&sdev->device_busy) >=3D sdev->queue_depth)
> >  =09=09return true;
> >  =09if (atomic_read(&sdev->device_blocked) > 0)
> >  =09=09return true;
> > @@ -1283,8 +1285,12 @@ static inline int scsi_dev_queue_ready(struct re=
quest_queue *q,
> >  =09=09=09=09  struct scsi_device *sdev)
> >  {
> >  =09unsigned int busy;
> > +=09bool bypass =3D blk_queue_nonrot(sdev->request_queue);
> > =20
> > -=09busy =3D atomic_inc_return(&sdev->device_busy) - 1;
> > +=09if (!bypass)
> > +=09=09busy =3D atomic_inc_return(&sdev->device_busy) - 1;
> > +=09else
> > +=09=09busy =3D 0;
> >  =09if (atomic_read(&sdev->device_blocked)) {
> >  =09=09if (busy)
> >  =09=09=09goto out_dec;
> > @@ -1298,12 +1304,16 @@ static inline int scsi_dev_queue_ready(struct r=
equest_queue *q,
> >  =09=09=09=09   "unblocking device at zero depth\n"));
> >  =09}
> > =20
> > +=09if (bypass)
> > +=09=09return 1;
> > +
> >  =09if (busy >=3D sdev->queue_depth)
> >  =09=09goto out_dec;
> > =20
> >  =09return 1;
> >  out_dec:
> > -=09atomic_dec(&sdev->device_busy);
> > +=09if (!bypass)
> > +=09=09atomic_dec(&sdev->device_busy);
> >  =09return 0;
> >  }
> > =20
> > @@ -1624,7 +1634,8 @@ static void scsi_mq_put_budget(struct blk_mq_hw_c=
tx *hctx)
> >  =09struct request_queue *q =3D hctx->queue;
> >  =09struct scsi_device *sdev =3D q->queuedata;
> > =20
> > -=09atomic_dec(&sdev->device_busy);
> > +=09if (!blk_queue_nonrot(sdev->request_queue))
> > +=09=09atomic_dec(&sdev->device_busy);
> >  }
> > =20
> >  static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
> > @@ -1731,7 +1742,8 @@ static blk_status_t scsi_queue_rq(struct blk_mq_h=
w_ctx *hctx,
> >  =09case BLK_STS_OK:
> >  =09=09break;
> >  =09case BLK_STS_RESOURCE:
> > -=09=09if (atomic_read(&sdev->device_busy) ||
> > +=09=09if ((!blk_queue_nonrot(sdev->request_queue) &&
> > +=09=09     atomic_read(&sdev->device_busy)) ||
> >  =09=09    scsi_device_blocked(sdev))
> >  =09=09=09ret =3D BLK_STS_DEV_RESOURCE;
> >  =09=09break;
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 0744c34468e1..c3d47117700d 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -2927,7 +2927,9 @@ static void sd_read_block_characteristics(struct =
scsi_disk *sdkp)
> >  =09rot =3D get_unaligned_be16(&buffer[4]);
> > =20
> >  =09if (rot =3D=3D 1) {
> > +=09=09blk_mq_freeze_queue(q);
> >  =09=09blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
> > +=09=09blk_mq_unfreeze_queue(q);
> >  =09=09blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, q);
> >  =09}
> > =20
> > @@ -3123,7 +3125,9 @@ static int sd_revalidate_disk(struct gendisk *dis=
k)
> >  =09=09 * cause this to be updated correctly and any device which
> >  =09=09 * doesn't support it should be treated as rotational.
> >  =09=09 */
> > +=09=09blk_mq_freeze_queue(q);
> >  =09=09blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
> > +=09=09blk_mq_unfreeze_queue(q);
> >  =09=09blk_queue_flag_set(QUEUE_FLAG_ADD_RANDOM, q);
> > =20
> >  =09=09if (scsi_device_supports_vpd(sdp)) {
> >=20
> Hmm.
>=20
> I must admit I patently don't like this explicit dependency on
> blk_nonrot(). Having a conditional counter is just an open invitation to
> getting things wrong...

That won't be an issue given this patch freezes queue when the
NONROT queue flag is changed.

>=20
> I would far prefer if we could delegate any queueing decision to the
> elevators, and completely drop the device_busy flag for all devices.

If you drop it, you may create big sequential IO performance drop
on HDD., that is why this patch only bypasses sdev->queue_depth on
SSD. NVMe bypasses it because no one uses HDD. via NVMe.

> But I do see that this might not be easy to do, nor necessarily
> something which others agree on.
> So alternatively, can't we make this a per-host flag, instead of having
> it per device characteristic?

Are you sure each LUN shares the same NONROT flag? I think it can be
true for each LUN to have different NONROT flag.

>=20
> I'm just thinking of a storage array with a massive cache; it's anyone's
> guess if 'nonrot' is set there, but at the same time these things can be
> fast, so they might be profiting from dropping the device_busy counter
> there, too.

If you are worrying about slow queue freeze, that won't be an issue,
given we don't switch to percpu mode until the flag is updated during
sd probe, and blk_mq_freeze_queue_wait() is pretty quick in ATOMIC
mode.


Thanks,
Ming

