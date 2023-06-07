Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA23C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 19:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjFGTiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 15:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjFGTiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 15:38:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 435581FC3;
        Wed,  7 Jun 2023 12:38:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4F7C6219F4;
        Wed,  7 Jun 2023 19:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686166675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/IIBHvDe2WpR9ciTNt7hHAMdyrVQCkGZbO3fPkRrgmA=;
        b=M+UOC0F2fNLo3GbSWjeFCcm/0FHHhQ0L7Y7ASpk5iCgEidmxbkvnKzLJ3uF3+2FrqhYZ+1
        p8c8pWm+FSqb6nEwaeCbgnqf+C+5Mne1Sk4f1OPQSZ0jvt4daRMpjf/GZGSyttW7n4cTyk
        Hd9GZhKQC0WBNj3t8SMiU0orxCxjDvQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BDCAA13776;
        Wed,  7 Jun 2023 19:37:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8G5iK5LcgGTBJQAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 19:37:54 +0000
Message-ID: <50cb1a5bd501721d7c816b1ca8bf560daa8e3cc9.camel@suse.com>
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
Date:   Wed, 07 Jun 2023 21:37:53 +0200
In-Reply-To: <3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org>
References: <20230607182249.22623-1-mwilck@suse.com>
         <20230607182249.22623-5-mwilck@suse.com>
         <3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-06-07 at 12:16 -0700, Bart Van Assche wrote:
> On 6/7/23 11:22, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > sdev->state_mutex protects only sdev->sdev_state. There's no reason
> > to keep it held while calling scsi_stop_queue().
> >=20
> > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > ---
> > =A0 drivers/scsi/scsi_lib.c | 2 +-
> > =A0 1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index ce5788643011..26e7ce25fa05 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -2795,9 +2795,9 @@ static void scsi_device_block(struct
> > scsi_device *sdev, void *data)
> > =A0=20
> > =A0=A0=A0=A0=A0=A0=A0=A0mutex_lock(&sdev->state_mutex);
> > =A0=A0=A0=A0=A0=A0=A0=A0err =3D __scsi_internal_device_block_nowait(sde=
v);
> > +=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&sdev->state_mutex);
> > =A0=A0=A0=A0=A0=A0=A0=A0if (err =3D=3D 0)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_stop_queue(sdev, f=
alse);
> > -=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&sdev->state_mutex);
> > =A0=20
> > =A0=A0=A0=A0=A0=A0=A0=A0WARN_ONCE(err, "__scsi_internal_device_block_no=
wait(%s)
> > failed: err =3D %d\n",
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_name(&sdev->sde=
v_gendev), err);
>=20
> There is a reason why scsi_stop_queue() is called with the sdev state
> mutex held: if this mutex is not held, unblocking of a SCSI device
> can=20
> start before the scsi_stop_queue() call has finished. It is not
> allowed=20
> to swap the order of the blk_mq_quiesce_queue() and=20
> blk_mq_unquiesce_queue() calls.

Thanks. This wasn't obvious to me from the current code. I'll add a
comment in the next version.

Regards
Martin


