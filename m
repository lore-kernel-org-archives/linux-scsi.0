Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4247C19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 08:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiHIIVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 04:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHIIVr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 04:21:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455BF62EE
        for <linux-scsi@vger.kernel.org>; Tue,  9 Aug 2022 01:21:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B43B51FED5;
        Tue,  9 Aug 2022 08:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660033296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hs6j7JvkIBZwom726J75vUZ8Hnv7Za5ejyg75ai6cMc=;
        b=O33NlNoRmvdSxuScrhU7GXJUu9Y0qdtJEkxwFD6ugfucgeE9mCi0/DtQmYvIjOW5iI0Jsi
        uOoi9VBRJ4cg7QozOIGKfatSBNRQ1RYcgGAoEtqEVwfFEwDo7xuuaG/pxGSsCQ4qoZJBld
        dJuNqyY2fHKZY7QTuKXSnFFZQsOyIuw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C0F913AA1;
        Tue,  9 Aug 2022 08:21:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HfOzGBAZ8mJREgAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 09 Aug 2022 08:21:36 +0000
Message-ID: <068e9fbf445dd90b7b6538cded8b7cd98acccbbd.camel@suse.com>
Subject: Re: [PATCH RESEND] scsi: scan: retry INQUIRY after timeout
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Dave Prizer <dave.prizer@hpe.com>
Date:   Tue, 09 Aug 2022 10:21:35 +0200
In-Reply-To: <251c6042-5778-5d82-64e3-a2de5e1e2d36@oracle.com>
References: <20220808202018.22224-1-mwilck@suse.com>
         <251c6042-5778-5d82-64e3-a2de5e1e2d36@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2022-08-08 at 17:11 -0500, Mike Christie wrote:
> On 8/8/22 3:20 PM, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > The SCSI mid layer doesn't retry commands after DID_TIME_OUT (see
> > scsi_noretry_cmd()). Packet loss in the fabric can cause spurious
> > timeouts
> > during SCSI device probing, causing device probing to fail. This
> > has been
> > observed in FCoE uplink failover tests, for example.
>=20
> What about the other scan/probe related commands and other transient
> transport
> errors like this (so when we get to the point DID_TRANSPORT_DISRUPTED
> is returned)?
> I think if you changed your test a little so the fc port state
> changed, we could
> still hit the same end problem. We can hit similar errors with iscsi
> and plain old
> FC.

All true. My focus was to fix an issue that has been encountered=20
frequently by HPE. In the test scenario at hand, I expected to still
see some errors after applying this patch, but we didn't. Can we agree
to fix this issue now, and see later what else may need fixing?=20

I suppose that it's impossible to do error-proof probing in the
presence of random transport layer errors, so whatever we do will be
just a gradual improvement, improving matters in some scenarios while
possibly slowing down probing in others. Also, verifying changes in
this area with meaningful tests is difficult and a time and resource
consuming endeavour.


> For REPORT_LUNS it looks like we retry almost all errors 3 times. For
> the
> probe/setup commands, at least for disks, it looks like we also are
> more
> forgiving and will retry DID_TIME_OUT/DID_TRANSPORT_DISRUPTED 3 times
> for
> commands like SAI_READ_CAPACITY_16 (I didn't check every sd operation
> and
> other upper level drivers).
>=20
> However, for the other probe/setup=A0 operations that rely on
> scsi_attach_vpd
> succeeding like sd_read_block_limits then we will hit issues where
> the device
> is partially setup. Should scsi_vpd_inquiry be retrying 3 times as
> well?

I think so. A frequent cause of errors in the multipath context is that
the udev rules assume that as soon as the "inquiry" sysfs attribute is
valid, the attributes "vpd_pg80" and "vpd_pg83" will be valid, too. But
in the presence of transport errors, any of the vpd attributes may be
invalid unless we retry.

Perhaps it also make sense to discuss the default timeouts? Given that
the max delay is (n_retries * timeout), the worst-case delay caused by
a single probing command would not change if we cut the timeout in half
and retry DID_TIME_OUT instead. In the case at hand, that would
probably have made sense - if the INQUIRY response wasn't received
after a few seconds, it wouldn't make sense to wait any longer. But I
guess there are other scenarios where a timeout of 20s or more is
required.

Note that the kernel isn't the only point of failure. udev rules
calling sg_inq or other similar tools may fall into the same trap. It
is even worse there, because commands called from udev rules are
expected to terminate quickly, thus there isn't much room for retries.
sg_inq uses a default passthrough timeout of 60s, and no retries.

> An alternative to changing all the callers would be we could make
> scsi_noretry_cmd
> detect when it's an internal passthrough command and just retry these
> types of
> errors. For SG IO type of passthough we still want to fail right
> away.

We can't distinguish these two cases. I am not sure if we ever could,
but at least since da6269da4cfe2 ("block: remove
REQ_OP_SCSI_{IN,OUT}"), we obviously can't.

Martin K. P., Christoph, thoughts?

Regards,
Martin

