Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46601C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 17:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235737AbiHKRPz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 13:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbiHKRPj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 13:15:39 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CF395ACE
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2022 10:02:24 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D87DF20805;
        Thu, 11 Aug 2022 17:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660237342; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xS2ydyW/VdJNC6Py8HjhdLUTqqqCrdmBEBUPrJEEyOY=;
        b=sa+FXYHMGGhGrPIieZqA53zJygpF/u8F3ilziacNSA0ate3qPdNgt3ijvxzLA84j4RU47F
        pqAtjw0mljv5ROjQy4210qZKKuw1hLs/qkqXt8k6XcGCHy6arcVndrkoCLaxWUlktkv2HM
        8MzWxOfibmXSDi6nEQatHkk47UWTKoA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 97EB813A9B;
        Thu, 11 Aug 2022 17:02:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id k25oIx429WLBSQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 11 Aug 2022 17:02:22 +0000
Message-ID: <29f24bf21ea98082b7709e067cb2d08d2253cab8.camel@suse.com>
Subject: Re: [PATCH 3/4] scsi: Internally retry scsi_execute commands
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Hannes Reinecke <Hannes.Reinecke@suse.com>
Date:   Thu, 11 Aug 2022 19:02:21 +0200
In-Reply-To: <e7318011-ee9f-05ec-eb87-1d95f4fe12e5@oracle.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
         <20220810034155.20744-4-michael.christie@oracle.com>
         <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com>
         <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com>
         <e4dd855269b2efb2e2f3efdde92f1f3339159878.camel@suse.com>
         <e7318011-ee9f-05ec-eb87-1d95f4fe12e5@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2022-08-11 at 11:15 -0500, Mike Christie wrote:
> >=20
> > I don't think it's _that_ speficic. (retries < allowed) is the
> > default
> > case, at least for the first failure. REQ_FAILFAST_DEV has very few
> > users except for the device handlers, and NEEDS_RETRY is a rather
> > frequently used disposition.
> I'm saying it's really specific because we only hit this code
> path that is causing issues when scsi_check_sense returns
> NEEDS_RETRY.

What about the other cases in scsi_decide_disposition() that jump to
maybe_retry?


> There's 5 in there and one in scsi_dh_alua. 4 of them are UAs.
>=20
> Compared to all the sense errors that we check for in the
> scsi_execute callers and including all the times they do a retry for
> all errors the 5 cases in scsi_check_sense seemed really specific.
>=20
> Let me send a patch for this type of design because in the other mail
> Christoph was asking for more details. I originally started going
> that
> route so it won't be too much trouble to do a RFC so we can get an
> idea of what it will look like.

Looking forward to it.

Martin

