Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F04E9C07E95
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 09:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A0961375
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 09:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhGMJQB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 05:16:01 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41632 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbhGMJQA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 05:16:00 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4C51E21FBA;
        Tue, 13 Jul 2021 09:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626167590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xJJZGqRKvaoSQWrGeiCwSEP1fPLBYIr1w75j4HAXvsE=;
        b=ajuUlFVm2PAIkObw9NmxyQ/sgtaT0h2DJiL+skP2C05ZGWo4FbInyTcegYMD9L/qxdAgOh
        6I5Oc3CMUoVpFf+xRwwoV47tdKMxcTEYYp7nkbvyHvEmnGPDWqQKYciUxMIPTJIqoiRjO/
        AdhuIDCg2JG9/ztZwW3qsH8a41io9gY=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 239C213B3B;
        Tue, 13 Jul 2021 09:13:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RjoFBiZZ7WBjUQAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 13 Jul 2021 09:13:10 +0000
Message-ID: <82ec344b73abce8460a82474b6f150fbc576943c.camel@suse.com>
Subject: Re: [PATCH 1/1]: scsi dm-mpath do not fail paths which are in ALUA
 state transitioning
From:   Martin Wilck <mwilck@suse.com>
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Date:   Tue, 13 Jul 2021 11:13:09 +0200
In-Reply-To: <CAHZQxyLmDFf+7tmZQFm7e6Xt97vSuav0f8kBbZjcwaufQX+x0w@mail.gmail.com>
References: <CAHZQxyKJ1qFatzhR-k19PXjAPo7eC0ZgwgaGKwfndB=jEO8mRQ@mail.gmail.com>
         <32a96fc27c250fb5772a0b301576ad702b8ea934.camel@suse.com>
         <CAHZQxyLmDFf+7tmZQFm7e6Xt97vSuav0f8kBbZjcwaufQX+x0w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Brian,

On Mo, 2021-07-12 at 14:38 -0700, Brian Bunker wrote:
> Martin,
> 
> > Please confirm that your kernel included ee8868c5c78f ("scsi:
> > scsi_dh_alua: Retry RTPG on a different path after failure").
> > That commit should cause the RTPG to be retried on other map 
> > members
> > which are not in failed state, thus avoiding this phenomenon.
> 
> In my case, there are no other map members that are not in the failed
> state. One set of paths goes to the ALUA unavailable state when the
> primary fails, and the second set of paths moves to ALUA state
> transitioning as the previous secondary becomes the primary.

IMO this is the problem. How does your array respond to SCSI commands
while ports are transitioning? 

SPC5 (§5.16.2.6) says that the server should either fail all commands
with BUSY or CHECK CONDITION/NOT READY/LOGICAL UNIT NOT
ACCESSIBLE/ASYMMETRIC ACCESS STATE TRANSITION (a), or should support
all TMFs and a subset of SCSI commands, while responding with
CC/NR/AAST to all other commands (b). SPC6 (§5.18.2.6) is no different.

No matter how you read that paragraph, it's pretty clear that
"transitioning" is generally not a healthy state to attempt I/O.

Are you saying that on your server, the transitioning ports are able to
process regular I/O commands like READ and WRITE? If that's the case,
why do you pretend to be "transitioning" at all, rather than in an
active state? If it's not the case, why would it make sense for the
host to retry I/O on the transitioning path?

>  If the
> paths are failed which are transitioning, an all paths down state
> happens which is not expected.

IMO it _is_ expected if in fact no path is able to process SCSI
commands at the given point in time.

>  There should be a time for which
> transitioning is a transient state until the next state is entered.
> Failing a path assuming there would be non-failed paths seems wrong.

This is a misunderstanding. The path isn't failed because of
assumptions about other paths. It is failed because we know that it's
non-functional, and thus we must try other paths, if there are any.

Before 268940b80fa4 ("scsi: scsi_dh_alua: Return BLK_STS_AGAIN for ALUA
transitioning state"), I/O was indeed retried on transitioning paths,
possibly forever. This posed a serious problem when a transitioning
path was about to be removed (e.g. dev_loss_tmo expired). And I'm still
quite convinced that it was wrong in general, because by all reasonable
means a "transitioning" path isn't usable for the host.

If we find a transitioning path, it might make sense to retry on other
paths first and eventually switch back to the transitioning path, when
all others have failed hard (e.g. "unavailable" state). However, this
logic doesn't exist in the kernel. In theory, it could be mapped to a
"transitioning" priority group in device-mapper multipath. But prio
groups are managed in user space (multipathd), which treats
transitioning paths as "almost failed" (priority 0) anyway. We can
discuss enhancing multipathd such that it re-checks transitioning paths
more frequently, in order to be able to reinstate them ASAP.

According to what you said above, the "transitioning" ports in the
problem situation ("second set") are those that were in "unavailable"
state before, which means "failed" as far as device mapper is concerned
- IOW, the paths in question would be unused anyway, until they got
reinstated, which wouldn't happen before they are fully up. With this
in mind, I have to say I don't understand why your proposed patch would
help at all. Please explain.

> > The purpose of that patch was to set the state of the transitioning
> > path to failed in order to make sure IO is retried on a different  >
> path.
> > Your patch would undermine this purpose.

(Additional indentation added by me) Can you please use proper quoting?
You were mixing my statements and your own. 

> I agree this is what happens but those transitioning paths might be
> the only non-failed paths available. I don't think it is reasonable
> to
> fail them. This is the same as treating transitioning as standby or
> unavailable.

Right, and according to the SPC spec (see above), that makes more sense
than treating it as "active".

Storage vendors seem to interpret "transitioning" very differently,
both in terms of commands supported and in terms of time required to
reach the target state. That makes it hard to deal with it correctly on
the host side.

>  As you point out this happened with the commit you
> mention. Before this commit what I am doing does not result in an all
> paths down error, and similarly, it does not in earlier Linux
> versions
> or other OS's under the same condition. I see this as a regression.

If you use a suitable "no_path_retry" setting in multipathd, you should
be able to handle the situation you describe just fine by queueing the
I/O until the transitioning paths are fully up. IIUC, on your server
"transitioning" is a transient state that ends quickly, so queueing
shouldn't be an issue. E.g. if you are certain that "transitioning"
won't last longer than 10s, you could set "no_path_retry 2".

Regards,
Martin



