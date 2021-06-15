Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F9F5C48BDF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 10:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 095EA61457
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 10:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhFOK4t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 06:56:49 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50846 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbhFOK4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 06:56:37 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0E6E321916;
        Tue, 15 Jun 2021 10:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623754472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t6HuWyqhZ3KNuWlmko6Y8RbgTmQRRBqbmgWwnyRLJb0=;
        b=Bq5fP8qrdXw8FbU7r4d28kfBP7XaoY6xMQi8kQSzSwWI1w8o6VBa+UR6LwNZqBCwhpoHM9
        jR6HUMBqky/PTcZLn8HD8uTbautPgDqPXwp078xQbBTHtyFp3/SkKRQ4V2nsrK62CugOn1
        T+XbX7hs1hZFn8rZSHX+HS8IQYMC8X8=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id A042C118DD;
        Tue, 15 Jun 2021 10:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623754472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t6HuWyqhZ3KNuWlmko6Y8RbgTmQRRBqbmgWwnyRLJb0=;
        b=Bq5fP8qrdXw8FbU7r4d28kfBP7XaoY6xMQi8kQSzSwWI1w8o6VBa+UR6LwNZqBCwhpoHM9
        jR6HUMBqky/PTcZLn8HD8uTbautPgDqPXwp078xQbBTHtyFp3/SkKRQ4V2nsrK62CugOn1
        T+XbX7hs1hZFn8rZSHX+HS8IQYMC8X8=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 1N34JOeGyGCBMAAALh3uQQ
        (envelope-from <mwilck@suse.com>); Tue, 15 Jun 2021 10:54:31 +0000
Message-ID: <44fc94278e0c4b15a611a6887c668f41c262e001.camel@suse.com>
Subject: Re: [PATCH v3 0/2]  dm: dm_blk_ioctl(): implement failover for
 SG_IO on dm-multipath
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Alasdair G Kergon <agk@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Benjamin Marzinski <bmarzins@redhat.com>,
        linux-scsi@vger.kernel.org
Date:   Tue, 15 Jun 2021 12:54:31 +0200
In-Reply-To: <YMdyh62mR/lEifMR@redhat.com>
References: <20210611202509.5426-1-mwilck@suse.com>
         <YMdyh62mR/lEifMR@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Mike,

On Mo, 2021-06-14 at 11:15 -0400, Mike Snitzer wrote:
> 
> This work offers a proof-of-concept but it needs further refinement
> for sure.

Thanks for looking into it again. I need some more guidance from your
part in order to be able to resubmit the set in a form that you
consider ready for merging.

> The proposed open-coded SCSI code (in patch 2's drivers/md/dm-
> scsi_ioctl.c) 
> is well beyond what I'm willing to take in DM.

I'm not sure what code you're referring to. Is it the processing of the
bytes of the SCSI result code? If yes, please note that I had changed
that to open-coded form in response to Bart's review of my v2
submission. If it's something else, please point it out to me.

To minimize the special-casing for this code path, Hannes suggested to
use a target-specific unprepare_ioctl() callback to to tell the generic
dm code whether a given ioctl could be retried. The logic that I've put
into dm-scsi_ioctl.c could then be moved into the unprepare_ioctl()
callback of dm-mpath. dm_blk_ioctl() would need to check the callback's
return value and possibly retry the ioctl. Would hat appeal to you?

>   If this type of
> functionality is still needed (for kvm's SCSI passthru snafu) then
> more work is needed to negotiate proper interfaces with the SCSI
> subsystem (added linux-scsi to cc, odd they weren't engaged on this).

Not cc'ing linux-scsi was my oversight, sorry about that. 

But I don't quite understand what interfaces you have in mind. SCSI
needs to expose the SG_IO interface to dm, which it does; I just needed
to export sg_io() to get access to the sg_io_hdr fields. The question
whether a given IO can be retried is decided on the dm (-mpath) layer,
based on blk_status_t; no additional interface on the SCSI side is
necessary for that.

> Does it make sense to extend the SCSI device handler interface to add
> the required enablement? (I think it'd have to if this line of work
> is
> to ultimately get upstream).

My current code uses the device handler indirectly for activating paths
during priority group switching, via the dm-mpath prepare_ioctl()
method and __pg_init_all_paths(). This is what I intended - to use
exactly the same logic for SG_IO which is used for regular read/write
IO on the block device. What additional functionality for the device
handler do you have in mind?

Regards and thanks,
Martin

> 
> Mike
> 
>   
> > Changes v1->v2:
> > 
> >  - applied modifications from Mike Snitzer
> >  - moved SG_IO dependent code to a separate file, no scsi includes
> > in
> >    dm.c any more
> >  - made the new code depend on a configuration option 
> >  - separated out scsi changes, made scsi_result_to_blk_status()
> >    inline to avoid dependency of dm_mod from scsi_mod (Paolo
> > Bonzini)
> > 
> > Martin Wilck (2):
> >   scsi: export __scsi_result_to_blk_status() in scsi_ioctl.c
> >   dm: add CONFIG_DM_MULTIPATH_SG_IO - failover for SG_IO on dm-
> > multipath
> > 
> >  block/scsi_ioctl.c         |  52 ++++++++++++++-
> >  drivers/md/Kconfig         |  11 ++++
> >  drivers/md/Makefile        |   4 ++
> >  drivers/md/dm-core.h       |   5 ++
> >  drivers/md/dm-rq.h         |  11 ++++
> >  drivers/md/dm-scsi_ioctl.c | 127
> > +++++++++++++++++++++++++++++++++++++
> >  drivers/md/dm.c            |  20 +++++-
> >  drivers/scsi/scsi_lib.c    |  29 +--------
> >  include/linux/blkdev.h     |   3 +
> >  9 files changed, 229 insertions(+), 33 deletions(-)
> >  create mode 100644 drivers/md/dm-scsi_ioctl.c
> > 
> > -- 
> > 2.31.1
> > 
> 


