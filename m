Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688C3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 16:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238368AbiEWQEB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 12:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbiEWQD5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 12:03:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62351427D4
        for <linux-scsi@vger.kernel.org>; Mon, 23 May 2022 09:03:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0FC811F8F7;
        Mon, 23 May 2022 16:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653321835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dgIrvAbgiXvQe1ojJocIPS6NJaPhDEe4uVub3JCJWAA=;
        b=H8BhQwOBZAGVEG72ntQ10yDeHQd0PXCMaleDb50qQpE+VPAeuSNCaamLSJdtSWI/PAqKCp
        K2os29pssYlm37Qp32Ijo8RAjsrHTYdjxnhEsZzRsihv2O7dZkrHsrZXDY2WGsVS+ByJYF
        xTEf2NvPJZ+XtRhmoMzWSbx4O7NT7v4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C56CA139F5;
        Mon, 23 May 2022 16:03:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9c6MLmqwi2KHJwAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 23 May 2022 16:03:54 +0000
Message-ID: <07f3474feb4ea7c2e80664c9977ae0e24b82cc09.camel@suse.com>
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
From:   Martin Wilck <mwilck@suse.com>
To:     Brian Bunker <brian@purestorage.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Benjamin Marzinski <bmarzins@redhat.com>
Date:   Mon, 23 May 2022 18:03:54 +0200
In-Reply-To: <CAHZQxyLEOw8jXUzLj8DugbbsVkFP=OMjv-Lkz6LkuayEavYahg@mail.gmail.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
         <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
         <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
         <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
         <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
         <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com>
         <234ccf5fc9f36fd837b3959057691a716685da3b.camel@suse.com>
         <CAHZQxyLEOw8jXUzLj8DugbbsVkFP=OMjv-Lkz6LkuayEavYahg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2022-05-20 at 19:52 -0700, Brian Bunker wrote:
> From my perspective, the ALUA transitioning state is a temporary
> state
> where the target is saying that it does not have a permanent state
> yet. Having the initiator try another pg to me doesn't seem like the
> right thing for it to do.

I agree. Unfortunately, there's no logic in dm-multipath saying "I may
switch paths inside a PG, but I may not do PG failover".

>  If the target wanted the initiator to use a
> different pg, it should use an ALUA state which would make that
> clear,
> standby, unavailable, etc. The target would only return an error
> state
> if it was aware that some other path is in an active state.When
> transitioning is returned, I don't think the initiator should assume
> that any other pg would be a better choice. I think it should assume
> that the target will make its intention clear for that path with a
> permanent state within a transition timeout.

For me the question is still whether trying to send I/O to the path
that is known not to be able to process it makes sense.=A0As noted
elsewhere, you patch just delays the BLK_STS_AGAIN by a few
milliseconds. You want to avoid a PG switch, and I second that, but IMO
that needs a different approach.

> From my perspective the right thing to do is to let the ALUA handler
> do what it is trying to do. If the pg state is transitioning and
> within the transition timeout it should continue to retry that
> request
> checking each time the transition timeout.

But this means that we should modify the logic not only in
alua_prep_fn() but also=A0for handling of NOT READY conditions, either in
alua_check_sense() or in scsi_io_completion_action().
I agree that this would make a lot of sense, perhaps more than trying
to implement a cleverer logic in dm-multipath as discussed between
Hannes and myself.

This is what we need to figure out first: Do we want to change the
logic in the multipath layer, making it somehow aware of the special
nature of "transitioning" state, or should we tune the retry logic in
the SCSI layer such that dm-multipath will "do the right thing"
automatically?
=20
Regards
Martin

