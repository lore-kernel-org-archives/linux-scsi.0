Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44810CA9EB9
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 00:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015AB20684
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 00:59:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FbhEnkGr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389933AbfJXA7A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 20:59:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22478 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389845AbfJXA7A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 20:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571878738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XwoEt4JIxWUSxkNlXdoTQPp+xWkJJugSXgu8E+JyFCg=;
        b=FbhEnkGrCgs6tQFYEQxjAqyvPjKdoyE2aTmTIHG8GxS4K8BAOHJr7HdFJDZOsqvpT196p5
        dxTs5IwkXr4EgiHU4Lv0xDIfaSnpJNYgmyeNkrlLVQI5XOuYIg67PpLWG40mQA7JHlOsvM
        nbIPvoCSF2sppwwwICnaIzUZD/3dLiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-b0-O1X_dNYS2N8aNc3NI-Q-1; Wed, 23 Oct 2019 20:58:55 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D10AA1005500;
        Thu, 24 Oct 2019 00:58:53 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B268960C83;
        Thu, 24 Oct 2019 00:58:35 +0000 (UTC)
Date:   Thu, 24 Oct 2019 08:58:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH V4 1/2] scsi: core: avoid host-wide host_busy counter for
 scsi_mq
Message-ID: <20191024005828.GB15426@ming.t460p>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-2-ming.lei@redhat.com>
 <7d95de12-6114-c0d7-8b21-d36b2ea020fc@huawei.com>
MIME-Version: 1.0
In-Reply-To: <7d95de12-6114-c0d7-8b21-d36b2ea020fc@huawei.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: b0-O1X_dNYS2N8aNc3NI-Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 23, 2019 at 09:52:41AM +0100, John Garry wrote:
> On 09/10/2019 10:32, Ming Lei wrote:
> > It isn't necessary to check the host depth in scsi_queue_rq() any more
> > since it has been respected by blk-mq before calling scsi_queue_rq() vi=
a
> > getting driver tag.
> >=20
> > Lots of LUNs may attach to same host and per-host IOPS may reach millio=
ns,
> > so we should avoid expensive atomic operations on the host-wide counter=
 in
> > the IO path.
> >=20
> > This patch implements scsi_host_busy() via blk_mq_tagset_busy_iter()
> > with one scsi command state for reading the count of busy IOs for scsi_=
mq.
> >=20
> > It is observed that IOPS is increased by 15% in IO test on scsi_debug (=
32
> > LUNs, 32 submit queues, 1024 can_queue, libaio/dio) in a dual-socket
> > system.
> >=20
> > V2:
> > =09- introduce SCMD_STATE_INFLIGHT for getting accurate host busy
> > =09via blk_mq_tagset_busy_iter()
> > =09- verified that original Jens's report[1] is fixed
> > =09- verified that SCSI timeout/abort works fine
> >=20
> > [1] https://www.spinics.net/lists/linux-scsi/msg122867.html
> > [2] V1 & its revert:
> >=20
> > d772a65d8a6c Revert "scsi: core: avoid host-wide host_busy counter for =
scsi_mq"
> > 23aa8e69f2c6 Revert "scsi: core: fix scsi_host_queue_ready"
> > 265d59aacbce scsi: core: fix scsi_host_queue_ready
> > 328728630d9f scsi: core: avoid host-wide host_busy counter for scsi_mq
> >=20
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Ewan D. Milne <emilne@redhat.com>
> > Cc: Omar Sandoval <osandov@fb.com>,
> > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> > Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> > Cc: Christoph Hellwig <hch@lst.de>,
> > Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Laurence Oberman <loberman@redhat.com>
> > Cc: Bart Van Assche <bart.vanassche@wdc.com>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >   drivers/scsi/hosts.c     | 19 ++++++++++++++++++-
> >   drivers/scsi/scsi.c      |  2 +-
> >   drivers/scsi/scsi_lib.c  | 35 +++++++++++++++++------------------
> >   drivers/scsi/scsi_priv.h |  2 +-
> >   include/scsi/scsi_cmnd.h |  1 +
> >   include/scsi/scsi_host.h |  1 -
> >   6 files changed, 38 insertions(+), 22 deletions(-)
> >=20
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 55522b7162d3..1d669e47b692 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -38,6 +38,7 @@
> >   #include <scsi/scsi_device.h>
> >   #include <scsi/scsi_host.h>
> >   #include <scsi/scsi_transport.h>
> > +#include <scsi/scsi_cmnd.h>
>=20
> alphabetic ordering could be maintained
>=20
> >   #include "scsi_priv.h"
> >   #include "scsi_logging.h"
> > @@ -554,13 +555,29 @@ struct Scsi_Host *scsi_host_get(struct Scsi_Host =
*shost)
> >   }
> >   EXPORT_SYMBOL(scsi_host_get);
> > +static bool scsi_host_check_in_flight(struct request *rq, void *data,
> > +=09=09=09=09      bool reserved)
> > +{
> > +=09int *count =3D data;
> > +=09struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
> > +
> > +=09if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
> > +=09=09(*count)++;
> > +
> > +=09return true;
> > +}
> > +
> >   /**
> >    * scsi_host_busy - Return the host busy counter
>=20
> is this comment accurate now?

Nothing changed wrt. the above comment, I will explain below.

>=20
> >    * @shost:=09Pointer to Scsi_Host to inc.
> >    **/
> >   int scsi_host_busy(struct Scsi_Host *shost)
> >   {
> > -=09return atomic_read(&shost->host_busy);
> > +=09int cnt =3D 0;
> > +
> > +=09blk_mq_tagset_busy_iter(&shost->tag_set,
> > +=09=09=09=09scsi_host_check_in_flight, &cnt);
>=20
> When I check blk_mq_tagset_busy_iter(), it does not seem to lock the tags
> for all hw queues against preemption for the counting, so how can we
> guarantee that this count will be always accurate?
>=20
> Or it never can be and you just don't care?

When the atomic variable of .host_busy is used, there isn't any host lock
to sync updating the variable and reading the variable, so nothing
changed wrt. its usage given atomic variable can be updated when reading th=
e
variable.

That means it depends on its users. If the user doesn't care it, no lock
is needed, otherwise user will deal with that, such as
scsi_eh_scmd_add() and scsi_eh_inc_host_failed(), the host is put into
SHOST_RECOVERY state first to prevent new requests from being queued,
then read the counter in RCU callback via call_rcu().

>=20
> > +=09return cnt;
> >   }
> >   EXPORT_SYMBOL(scsi_host_busy);
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index 1f5b5c8a7f72..ddc4ec6ea2a1 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -186,7 +186,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
> >   =09struct scsi_driver *drv;
> >   =09unsigned int good_bytes;
> > -=09scsi_device_unbusy(sdev);
> > +=09scsi_device_unbusy(sdev, cmd);
> >   =09/*
> >   =09 * Clear the flags that say that the device/target/host is no long=
er
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index dc210b9d4896..b6f66dcb15a5 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -189,7 +189,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *c=
md, int reason, bool unbusy)
> >   =09 * active on the host/device.
> >   =09 */
> >   =09if (unbusy)
> > -=09=09scsi_device_unbusy(device);
> > +=09=09scsi_device_unbusy(device, cmd);
> >   =09/*
> >   =09 * Requeue this command.  It will go before all other commands > @=
@
> > -329,12 +329,12 @@ static void scsi_init_cmd_errh(struct scsi_cmnd
> *cmd)
>=20
>=20
> The comment for scsi_dec_host_busy() is "Decrement the host_busy counter =
and
> ", so does this need to be fixed up?

Yeah, will fix it in next version.

>=20
> I'm guessing that there's lots more places like this...

I just run a grep, looks not found others.

>=20
> >    * host_failed counter or that it notices the shost state change made=
 by
> >    * scsi_eh_scmd_add().
> >    */
>=20
>=20
> > -static void scsi_dec_host_busy(struct Scsi_Host *shost)
> > +static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cm=
nd *cmd)
> >   {
> >   =09unsigned long flags;
> >   =09rcu_read_lock();
> > -=09atomic_dec(&shost->host_busy);
> > +=09__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> >   =09if (unlikely(scsi_host_in_recovery(shost))) {
> >   =09=09spin_lock_irqsave(shost->host_lock, flags);
> >   =09=09if (shost->host_failed || shost->host_eh_scheduled)
> > @@ -344,12 +344,12 @@ static void scsi_dec_host_busy(struct Scsi_Host *=
shost)
> >   =09rcu_read_unlock();
> >   }
> > -void scsi_device_unbusy(struct scsi_device *sdev)
> > +void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cm=
d)
> >   {
> >   =09struct Scsi_Host *shost =3D sdev->host;
> >   =09struct scsi_target *starget =3D scsi_target(sdev);
> > -=09scsi_dec_host_busy(shost);
> > +=09scsi_dec_host_busy(shost, cmd);
> >   =09if (starget->can_queue > 0)
> >   =09=09atomic_dec(&starget->target_busy);
> > @@ -430,9 +430,6 @@ static inline bool scsi_target_is_busy(struct scsi_=
target *starget)
> >   static inline bool scsi_host_is_busy(struct Scsi_Host *shost)
> >   {
> > -=09if (shost->can_queue > 0 &&
> > -=09    atomic_read(&shost->host_busy) >=3D shost->can_queue)
> > -=09=09return true;
>=20
> Do we still honour "do not send more than can_queue commands to the
> adapter", regardless of how many queues the LLDD exposes?

What we should honour is that 'do not send more than can_queue commands
to each hw queue', that is exactly guaranteed by blk-mq.

The point is simple, because each hw queue has its own independent tags,
that is why I mentioned your Hisilicon SAS can't be converted to MQ
easily cause this hardware has only single shared tags.


thanks,
Ming

