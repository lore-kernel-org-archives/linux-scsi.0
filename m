Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410C3CD37AA
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 21:34:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbjIOVeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 17:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237816AbjIOVeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 17:34:08 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CD3193
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 14:34:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6026E21908;
        Fri, 15 Sep 2023 21:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1694813641; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZyTYYYM7x3Syoiso2nl6lnkYtmgJWncVB/81yayL+Kg=;
        b=KDo+j8AVoeSCH+yVSiju6kr7DA6mdzp0Kny12T4KNyrFrPK3hLfM1g2iBYT+BTf56qCXCG
        G4TGKefGwLhVdyc4dAwB7p2ku9NkslARzDaQqIizeOMwjv/rilcTiUXuTSxSnsKbSShFcp
        TDEOhHsawhWDgMgFzaQOyqRbpnEvSoU=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0F7A113251;
        Fri, 15 Sep 2023 21:34:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oZoNAcnNBGXwKAAAMHmgww
        (envelope-from <mwilck@suse.com>); Fri, 15 Sep 2023 21:34:01 +0000
Message-ID: <8d8cdaefa944afd3c478ffb77570cce53f7041c6.camel@suse.com>
Subject: Re: [PATCH v11 07/34] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Date:   Fri, 15 Sep 2023 23:34:00 +0200
In-Reply-To: <d3d8bc89e45708cde24912b497348f12c662f45f.camel@suse.com>
References: <20230905231547.83945-1-michael.christie@oracle.com>
         <20230905231547.83945-8-michael.christie@oracle.com>
         <d3d8bc89e45708cde24912b497348f12c662f45f.camel@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2023-09-15 at 22:21 +0200, Martin Wilck wrote:
> On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
> > This has read_capacity_16 have scsi-ml retry errors instead of
> > driving
> > them itself.
> >=20
> > There are 2 behavior changes with this patch:
> > 1. There is one behavior change where we no longer retry when
> > scsi_execute_cmd returns < 0, but we should be ok. We don't need to
> > retry
> > for failures like the queue being removed, and for the case where
> > there
> > are no tags/reqs since the block layer waits/retries for us. For
> > possible
> > memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
> > retrying will probably not help.
> > 2. For the specific UAs we checked for and retried, we would get
> > READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were
> > left
> > from the loop's retries. Each UA now gets
> > READ_CAPACITY_RETRIES_ON_RESET
> > reties, and the other errors (not including medium not present) get
> > up
> > to 3 retries.
>=20
> This is ok, but - just a thought - would it make sense to add a field
> for maximum total retry count (summed over all failures)? That would
> allow us to minimize behavior changes also in other cases.

Could we perhaps use scmd->allowed for this purpose?

I noted that several callers of scsi_execute_cmd() in your patch set
set the allowed parameter, e.g. to sdkp->max_retries in 07/34.
But allowed doesn't seem to be used at all in the passthrough case,
so we might as well use it as an upper limit for the total number of
retries.


