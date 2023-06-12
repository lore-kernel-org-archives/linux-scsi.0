Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDBAC88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 16:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232336AbjFLQHA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 12:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjFLQHA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 12:07:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A09130;
        Mon, 12 Jun 2023 09:06:59 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B380B2024E;
        Mon, 12 Jun 2023 16:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686586017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dBZCWQyWB01XV9FsASWxA6AEiC/uR9E27Z1cR7kGPPw=;
        b=RSQomsOD9sO7AyIuJdX41/p8ZR24CcHUW3Jbz/fhsakyc1bQqGhYAxKhTNT/oFZOsZDYOh
        1zzw8jms08QaYusbQzyTEzAKPqc4d0DbGOkS5pPDW+tSwy09Oiqewu9vlkT6w2auHxxI2I
        OEJtzZoXATiouaehAszI5FrlOKZXkcw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 63D7A1357F;
        Mon, 12 Jun 2023 16:06:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jIyvFqFCh2RYTAAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 12 Jun 2023 16:06:57 +0000
Message-ID: <d81c6330ba40d75277945d64f719b471eed4549a.camel@suse.com>
Subject: Re: [PATCH v4 3/6] scsi: merge scsi_internal_device_block() and
 device_block()
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Date:   Mon, 12 Jun 2023 18:06:56 +0200
In-Reply-To: <50f5ba1e-8dc7-804f-7e43-cd838ff05ce7@acm.org>
References: <20230612150309.18103-1-mwilck@suse.com>
         <20230612150309.18103-4-mwilck@suse.com>
         <50f5ba1e-8dc7-804f-7e43-cd838ff05ce7@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-06-12 at 08:35 -0700, Bart Van Assche wrote:
> On 6/12/23 08:03, mwilck@suse.com=A0wrote:
> > -static int scsi_internal_device_block(struct scsi_device *sdev)
> > +static void scsi_device_block(struct scsi_device *sdev, void
> > *data)
> > =A0 {
> > =A0=A0=A0=A0=A0=A0=A0=A0int err;
> > =A0=20
> > @@ -2805,7 +2804,8 @@ static int scsi_internal_device_block(struct
> > scsi_device *sdev)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0scsi_stop_queue(sdev, f=
alse);
> > =A0=A0=A0=A0=A0=A0=A0=A0mutex_unlock(&sdev->state_mutex);
> > =A0=20
> > -=A0=A0=A0=A0=A0=A0=A0return err;
> > +=A0=A0=A0=A0=A0=A0=A0WARN_ONCE(err, "__scsi_internal_device_block_nowa=
it(%s)
> > failed: err =3D %d\n",
> > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_name(&sdev->sdev_=
gendev), err);
> > =A0 }
>=20
> Hmm ... shouldn't the WARN_ONCE() statement refer to
> scsi_device_block()=20
> instead of __scsi_internal_device_block_nowait()?

The message references the function that failed, and prints the return
value of that function. It used to be scsi_internal_device_block()
before my patch, and it's __scsi_internal_device_block_nowait() now.=20

But I agree that the message is ugly. I'll to come up with something
better.

Thanks,
Martin

