Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39A3C7EE29
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 09:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239934AbjFGJ0g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jun 2023 05:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239971AbjFGJ03 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2023 05:26:29 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B471BD8;
        Wed,  7 Jun 2023 02:26:06 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6D92F1FDAF;
        Wed,  7 Jun 2023 09:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686129965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ddOONOUpRa+eJ6om8K2Z3tbf7IjjN2McZwQcpxJyj8s=;
        b=DkPsJT263VxNk30Lt3K1r7zDB+gcvb87BrjNE2eVbs3tzjLMPalZrZ90vzuedqLFT1AtYi
        SCIgFuC78rqrJPhc+Au2qhQNXn7mZRsWGxTQb7rRNWyOVKt7xl0uecMpUhIqfijHhXtX3G
        3uotq+OYtUaxDr+FbQd5KUI9exg/jdI=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2701513776;
        Wed,  7 Jun 2023 09:26:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rPrtBy1NgGQjXgAAMHmgww
        (envelope-from <mwilck@suse.com>); Wed, 07 Jun 2023 09:26:05 +0000
Message-ID: <c0563161eb613f9500e6a1cccdcff6fc64efffad.camel@suse.com>
Subject: Re: [PATCH v2 3/3] scsi: simplify scsi_stop_queue()
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Date:   Wed, 07 Jun 2023 11:26:04 +0200
In-Reply-To: <20230607052710.GC20052@lst.de>
References: <20230606193845.9627-1-mwilck@suse.com>
         <20230606193845.9627-4-mwilck@suse.com> <20230607052710.GC20052@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-06-07 at 07:27 +0200, Christoph Hellwig wrote:
> On Tue, Jun 06, 2023 at 09:38:45PM +0200, mwilck@suse.com=A0wrote:
> > Simplify scsi_stop_queue(), which is only called in this code path,
> > to never
> > wait for the quiescing to finish. Rather call
> > blk_mq_wait_quiesce_done()
> > from scsi_target_block() after iterating over all devices.
>=20
> I don't think simplify is the right word here.=A0 The code isn't in any
> way simpler, it just is more efficient an shifts work from
> scsi_stop_queue to scsi_internal_device_block and scsi_target_block.
>=20
> But the whole transformation is very confusing to me even if it looks
> correct in the end, and it took me quite a while to understand it.
>=20
> I'd suggest to further split this up and include some additional
> cleanups:
>=20
> =A0 1) remove scsi_internal_device_block and fold it into device_block

ok

> =A0 2) move the scsi_internal_device_block in what was

You mean scsi_stop_queue() here, right?

> =A0=A0=A0=A0 scsi_internal_device_block and now is device_block out
> =A0=A0=A0=A0 of state_mutex (and document in the commit log why this is s=
afe)
> =A0 3) remove scsi_stop_queue and open code it in the two callers, one
> =A0=A0=A0=A0 of which currently wants nowait semantics, and one that does=
n't.
ok

> =A0 4) move the quiesce wait to scsi_target_block and make it per-
> tagset

ok

>=20
> > =A0scsi_target_block(struct device *dev)
> > =A0{
> > +=A0=A0=A0=A0=A0=A0=A0struct Scsi_Host *shost =3D dev_to_shost(dev);
> > +
> > =A0=A0=A0=A0=A0=A0=A0=A0if (scsi_is_target_device(dev))
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0starget_for_each_device=
(to_scsi_target(dev), NULL,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0device_block);
> > =A0=A0=A0=A0=A0=A0=A0=A0else
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0device_for_each_child(d=
ev, NULL, target_block);
> > +
> > +=A0=A0=A0=A0=A0=A0=A0/* Wait for ongoing scsi_queue_rq() calls to fini=
sh. */
> > +=A0=A0=A0=A0=A0=A0=A0if (!WARN_ON_ONCE(!shost))
>=20
> How could host ever be NULL here?=A0 I can't see why we'd want this
> check.
>=20

The reason is simple: I wasn't certain if dev_to_shost() could return
NULL, and preferred skipping the wait over an Oops. I hear you say that
dev_to_shost() can't go wrong, so I'll remove the NULL test.

> Btw, as far as I can tell scsi_target_block is never called for
> a device that is a target device.=A0 It might be worth throwing in
> another patch to remove support for that case and simplify things
> further.

Can we do this separately, maybe?=20

Thanks,
Martin

