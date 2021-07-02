Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66C4DC11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 14:21:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DFBA61427
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 14:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhGBOXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 10:23:35 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60374 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbhGBOXf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 10:23:35 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 32C2321BA8;
        Fri,  2 Jul 2021 14:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625235662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdVlVyMIhZYAE1Rur9k142DKOHes23GQyE4Lr9maiIU=;
        b=olHbqMS57DAacAU+Lg3glkWbNeqcp6j+ip15Y50wSYgxyEyicO/nen9Jf6VOZgrkd3H3xR
        AlLf0Yt4e+JeDbmI2YBrVPgDUrJqzzNE5mUpQc/w7JTqh6QCzhZimqh8TFU0MzAC5waB5l
        nw5HOXsraebA8/RE9ka7rTOO8b/AoJA=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id BD73211C84;
        Fri,  2 Jul 2021 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625235662; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VdVlVyMIhZYAE1Rur9k142DKOHes23GQyE4Lr9maiIU=;
        b=olHbqMS57DAacAU+Lg3glkWbNeqcp6j+ip15Y50wSYgxyEyicO/nen9Jf6VOZgrkd3H3xR
        AlLf0Yt4e+JeDbmI2YBrVPgDUrJqzzNE5mUpQc/w7JTqh6QCzhZimqh8TFU0MzAC5waB5l
        nw5HOXsraebA8/RE9ka7rTOO8b/AoJA=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 1ymoLM0g32C4XgAALh3uQQ
        (envelope-from <mwilck@suse.com>); Fri, 02 Jul 2021 14:21:01 +0000
Message-ID: <003727e7a195cb0f525cc2d7abda3a19ff16eb98.camel@suse.com>
Subject: Re: [dm-devel] [PATCH v5 3/3] dm mpath: add
 CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
        Daniel Wagner <dwagner@suse.de>, emilne@redhat.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        nkoenig@redhat.com, Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Alasdair G Kergon <agk@redhat.com>
Date:   Fri, 02 Jul 2021 16:21:01 +0200
In-Reply-To: <20210701113442.GA10793@lst.de>
References: <20210628151558.2289-1-mwilck@suse.com>
         <20210628151558.2289-4-mwilck@suse.com> <20210701075629.GA25768@lst.de>
         <de1e3dcbd26a4c680b27b557ea5384ba40fc7575.camel@suse.com>
         <20210701113442.GA10793@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Do, 2021-07-01 at 13:34 +0200, Christoph Hellwig wrote:
> On Thu, Jul 01, 2021 at 12:35:53PM +0200, Martin Wilck wrote:
> > I respectfully disagree. Users of dm-multipath devices expect that
> > IO
> > succeeds as long as there's at least one healthy path. This is a
> > fundamental property of multipath devices. Whether IO is sent
> > "normally" or via SG_IO doesn't make a difference wrt this
> > expectation.
> 
> If you have those (pretty reasonable) expections don't use SG_IO.
> That is what the regular read/write path is for.  SG_IO gives you
> raw access to the SCSI logic unit, and you get to keep the pieces
> if anything goes wrong.

With this logic, if some paths are down, SG_IO commands on multipath
devices yield random results. On one path a command would fail, and on
another it would succeed. User space has no way to control or even see
what path is being used. That's a very fragile user space API, on the
fringe of being useless IMO.

If user space is interested in the error handling semantics you
describe, it can run SG_IO on individual SCSI devices any time. With
the change I am proposing, nothing is lost for user space. If user
space decides to do SG_IO on a multipath device, it has a different
expectation, which my patch set implements. IMO we should strive to
match the semantics for ioctls on natively multipathed NVMe namespaces.

Regards
Martin


