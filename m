Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2FAC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 12:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8388A61437
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 12:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238911AbhDUMeV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 08:34:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:52354 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234573AbhDUMeV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 08:34:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619008427; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e5Kbd0TXj3KwG0jUyeYj91X/tkHEooUWTjSvtbN17YA=;
        b=bi8Sv/WQwsJYdc0AafMMFpJigAeNWbH+q95qZe699wnJktzvNP25lh3cX9OTkQsrYmHnqz
        rYLW5rlYNx8F/cnIEJGEIhCwujkJLP/hkmVqXyRC0t9e/5e21meLfDsrZXmH6MXgsM2Qto
        I7EOQ6iBM4O5IRph3HOthQmENNrEUSY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 47C4AAF2C;
        Wed, 21 Apr 2021 12:33:47 +0000 (UTC)
Message-ID: <fd6f98c269e95d9cd0a36cf4b62d290e612ba006.camel@suse.com>
Subject: Re: [PATCH 0/5] scsi: fnic: use blk_mq_tagset_busy_iter() to walk
 scsi commands
From:   Martin Wilck <mwilck@suse.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        David Jeffery <djeffery@redhat.com>,
        Daniel Wagner <dwagner@suse.de>
Date:   Wed, 21 Apr 2021 14:33:46 +0200
In-Reply-To: <YIABO6e3VLDCFU1b@T590>
References: <20210421075543.1919826-1-ming.lei@redhat.com>
         <fce30dfdee0eed3959358d4b8b826ecc20f5f7bd.camel@suse.com>
         <YIABO6e3VLDCFU1b@T590>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-04-21 at 18:40 +0800, Ming Lei wrote:
> On Wed, Apr 21, 2021 at 12:19:00PM +0200, Martin Wilck wrote:
> > On Wed, 2021-04-21 at 15:55 +0800, Ming Lei wrote:
> > > Hello Guys,
> > > 
> > > fnic uses the following way to walk scsi commands in failure
> > > handling,
> > > which is obvious wrong, because caller of scsi_host_find_tag has
> > > to
> > > guarantee that the tag is active.
> > > 
> > >         for (tag = 0; tag < fnic->fnic_max_tag_id; tag++) {
> > >                                 ...
> > >                 sc = scsi_host_find_tag(fnic->lport->host, tag);
> > >                                 ...
> > >                 }
> > > 
> > > Fix the issue by using blk_mq_tagset_busy_iter() to walk
> > > request/scsi_command.
> > 
> > How does this relate to Hannes' previous patch?
> > https://marc.info/?l=linux-scsi&m=161400059528859&w=2
> 
> oops, this patch is actually same or similar with Hannes's.
> 
> Given these patches are bug fix, can we cherry-pick them for 5.13?

No objections in principle, but the differences between your patch and
Hannes' are pretty large. I couldn't tell which one is more
appropriate.

Question: Both your patch set and Hannes' patch replace a couple of
scsi_host_find_tag() calls in the fnic driver, while leaving some
others in place. It's not clear to me why we can be sure that no
corruption occurs in any of the latter. Could you explain?

Regards,
Martin


