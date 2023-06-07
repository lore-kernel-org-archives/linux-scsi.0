Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5A2C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 17:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbjFGR4e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 13:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjFGR4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 13:56:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C34119BB;
        Wed,  7 Jun 2023 10:56:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 17E9D1FDB4;
        Wed,  7 Jun 2023 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686160585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CfJO2MZBqPiU9gS1PiDruSd09zHIk7cK2ZW0HamCWYI=;
        b=UvbxmwqjVqA7+rdSAxAwJIbwIc2AtQ2sDHc2L+RT6FUyz6GSyhKROFU8bxXUMNlidZYn5p
        1WEBfSIise+5dcn8c/rz11pR9R5w/v/8wK6IgkcNBn1BZFUB9BEudHLiGqRq1fLn1l/I/1
        8j35/38Uu9Lzo7msWpFL8SNf7E59UOs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A6B3F1346D;
        Wed,  7 Jun 2023 17:56:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id L0IHJ8jEgGRleAAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 17:56:24 +0000
Message-ID: <ffae1d21b9bc351b48e1152ecef1a14e5f7f03ae.camel@suse.com>
Subject: Re: [PATCH v2 3/3] scsi: simplify scsi_stop_queue()
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Date:   Wed, 07 Jun 2023 19:56:23 +0200
In-Reply-To: <c9f55fc9-3c60-5a6c-be2d-0c313c345bb2@acm.org>
References: <20230606193845.9627-1-mwilck@suse.com>
         <20230606193845.9627-4-mwilck@suse.com> <20230607052710.GC20052@lst.de>
         <c0563161eb613f9500e6a1cccdcff6fc64efffad.camel@suse.com>
         <903c7222-c95e-fda1-9b90-b59e184944cf@acm.org>
         <7ee70331d921854e2b27de3d072d0d8f8ce97f3b.camel@suse.com>
         <c9f55fc9-3c60-5a6c-be2d-0c313c345bb2@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-06-07 at 09:39 -0700, Bart Van Assche wrote:
> On 6/7/23 08:38, Martin Wilck wrote:
> > On Wed, 2023-06-07 at 07:05 -0700, Bart Van Assche wrote:
> > > On 6/7/23 02:26, Martin Wilck wrote:
> > > > On Wed, 2023-06-07 at 07:27 +0200, Christoph Hellwig wrote:
> > > > > On Tue, Jun 06, 2023 at 09:38:45PM +0200,
> > > > > mwilck@suse.com=A0wrote:
> > > > > > =A0=A0=A0scsi_target_block(struct device *dev)
> > > > > > =A0=A0=A0{
> > > > > > +=A0=A0=A0=A0=A0=A0=A0struct Scsi_Host *shost =3D dev_to_shost(=
dev);
> > > > > > +
> > > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (scsi_is_target_device(dev))
> > > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0starget_f=
or_each_device(to_scsi_target(de
> > > > > > v),
> > > > > > NULL,
> > > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0device_block=
);
> > > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> > > > > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0device_fo=
r_each_child(dev, NULL,
> > > > > > target_block);
> > > > > > +
> > > > > > +=A0=A0=A0=A0=A0=A0=A0/* Wait for ongoing scsi_queue_rq() calls=
 to
> > > > > > finish. */
> > > > > > +=A0=A0=A0=A0=A0=A0=A0if (!WARN_ON_ONCE(!shost))
> > > > >=20
> > > > > How could host ever be NULL here?=A0 I can't see why we'd want
> > > > > this
> > > > > check.
> > > >=20
> > > > The reason is simple: I wasn't certain if dev_to_shost() could
> > > > return
> > > > NULL, and preferred skipping the wait over an Oops. I hear you
> > > > say
> > > > that
> > > > dev_to_shost() can't go wrong, so I'll remove the NULL test.
> > >=20
> > > I propose to pass shost as the first argument to
> > > scsi_target_block()
> > > instead of using dev_to_shost() inside scsi_target_block().
> > > Except in
> > > __iscsi_block_session(), shost is already available as a local
> > > variable.
> >=20
> > If we do this, it might actually be cleaner to just pass the tag
> > set to
> > wait for.
>=20
> Wouldn't that be close to a layering violation? Shouldn't SCSI APIs
> accept
> pointers to SCSI objects instead of pointers to block layer
> abstractions?

My thought was that quiescing is based on tag sets in current kernels,
and passing in the tag set to scsi_target_block() would make that
explicit.

But you've got a point. I'll resubmit the with a Scsi_Host argument and
see how it goes.

Thanks,
Martin

