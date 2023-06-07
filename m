Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9076FC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 20:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjFGUHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 16:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjFGUHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 16:07:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352D4210B;
        Wed,  7 Jun 2023 13:07:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B751821A13;
        Wed,  7 Jun 2023 20:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686168432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J7ykc0e+u/G22RQG0NJx6bGNqBYp+rLwfwbPjKoPuKo=;
        b=g7jLqcvh8igTvb1wOAZd4B/00TRukbouCHqJtLOPclbw1zGRKXibWhd4CK1pSaXyhiy7dK
        M4UzZiPWkwDWGTIYOht3LyMjofwjgzpKQvNnhElsXt1WYrbgR+wA65Mco/JO6p0t1/O3vL
        BjKVrkNGTx9CSPx/gqBj/11+lY2GHFk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1FBFA1346D;
        Wed,  7 Jun 2023 20:07:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id e7rfA3DjgGTkMQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 20:07:12 +0000
Message-ID: <ff669f59e3c42e5dec4920d705e2b8748ad600d5.camel@suse.com>
Subject: Re: [PATCH v3 4/8] scsi: call scsi_stop_queue() without state_mutex
 held
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Date:   Wed, 07 Jun 2023 22:07:10 +0200
In-Reply-To: <50cb1a5bd501721d7c816b1ca8bf560daa8e3cc9.camel@suse.com>
References: <20230607182249.22623-1-mwilck@suse.com>
         <20230607182249.22623-5-mwilck@suse.com>
         <3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org>
         <50cb1a5bd501721d7c816b1ca8bf560daa8e3cc9.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart,

On Wed, 2023-06-07 at 21:37 +0200, Martin Wilck wrote:
> On Wed, 2023-06-07 at 12:16 -0700, Bart Van Assche wrote:
> > On 6/7/23 11:22, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > sdev->state_mutex protects only sdev->sdev_state. There's no
> > > reason
> > > to keep it held while calling scsi_stop_queue().
> > >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > > =A0 drivers/scsi/scsi_lib.c | 2 +-
> > > =A0 1 file changed, 1 insertion(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index ce5788643011..26e7ce25fa05 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -2795,9 +2795,9 @@ static void scsi_device_block(struct
> > > scsi_device *sdev, void *data)
> > > =A0=20
> > > =A0=A0=A0=A0=A0=A0=A0=A0mutex_lock(&sdev->state_mutex);
> > > =A0=A0=A0=A0=A0=A0=A0=A0err =3D __scsi_internal_device_block_nowait(s=
dev);
> > > +=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&sdev->state_mutex);
> > > =A0=A0=A0=A0=A0=A0=A0=A0if (err =3D=3D 0)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_stop_queue(sdev,=
 false);
> > > -=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&sdev->state_mutex);
> > > =A0=20
> > > =A0=A0=A0=A0=A0=A0=A0=A0WARN_ONCE(err, "__scsi_internal_device_block_=
nowait(%s)
> > > failed: err =3D %d\n",
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_name(&sdev->s=
dev_gendev), err);
> >=20
> > There is a reason why scsi_stop_queue() is called with the sdev
> > state
> > mutex held: if this mutex is not held, unblocking of a SCSI device
> > can=20
> > start before the scsi_stop_queue() call has finished. It is not
> > allowed=20
> > to swap the order of the blk_mq_quiesce_queue() and=20
> > blk_mq_unquiesce_queue() calls.
>=20
> Thanks. This wasn't obvious to me from the current code. I'll add a
> comment in the next version.

The crucial question is now, is it sufficient to call
blk_mq_quiesce_queue_nowait() under the mutex, or does the call to
blk_mq_wait_quiesce_done() have to be under the mutex, too?
The latter would actually kill off our attempt to fix the delay
in fc_remote_port_delete() that was caused by repeated
synchronize_rcu() calls.

But if I understand you correctly, moving the wait out of the mutex
should be ok. I'll update the series accordingly.

Thanks,
Martin


