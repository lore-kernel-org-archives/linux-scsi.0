Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EB4C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 20:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A4D96144F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 20:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhD1Uzn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 16:55:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:42548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229993AbhD1Uzn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Apr 2021 16:55:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619643296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=abLiDSv2N89jhGRyaxZH56+tP1PcAmuXSHlaG22UQn0=;
        b=fjva+nEd+KY4/Bgvs7FRzrXK9xeqxA6dHuq8iOeHXVkYN3bGe7TAqr+JWfm7IRPI3pWFrj
        ZLCfAuCQVq5b4wujNpjh0wY/N3673Pld3p1vKYmG9gEUq1T0szFDJJ1FGooODK27UYMeON
        EfQsS+ziepuUUBg37M6hmLFFlNLV/Uw=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2F966AF75;
        Wed, 28 Apr 2021 20:54:56 +0000 (UTC)
Message-ID: <3719d0b8ab39d1008030e8f4e462fb4ee98952ac.camel@suse.com>
Subject: Re: dm: dm_blk_ioctl(): implement failover for SG_IO on dm-multipath
From:   Martin Wilck <mwilck@suse.com>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Date:   Wed, 28 Apr 2021 22:54:55 +0200
In-Reply-To: <20210428195457.GA46518@lobo>
References: <20210422202130.30906-1-mwilck@suse.com>
         <20210428195457.GA46518@lobo>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-04-28 at 15:54 -0400, Mike Snitzer wrote:
> 
> Ngh... not loving this at all.  

I'm not surprised :-) I infer from your reply that you acknowledge this
is something that should be done one way or the other, and I'm glad
about that.

> But here is a patch (that I didn't
> compile test) that should be folded in, still have to think about how
> this could be made cleaner in general though.

Thanks, much appreciated.

> Also, dm_sg_io_ioctl should probably be in dm-rq.c (maybe even dm-
> mpath.c!?)
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Wed, 28 Apr 2021 15:03:20 -0400
> Subject: [PATCH] dm: use scsi_result_to_blk_status rather than open-
> coding it
> 
> Other small cleanups/nits.
> 
> BUT the fact that dm.c now #includes <scsi/scsi.h> and <scsi/sg.h>
> leaves a very bitter taste.
> 
> Also, hardcoding the issuing of a "fail_path" message (assumes tgt is
> dm-mpath) but still having checks like !tgt->type->message.. its all
> very contrived and awkward!

This I can explain. I need to check t->type->message because not all
targets define it. If I didn't, yet used message(), the kernel might
crash. I would have avoided the hard-coded "fail_path", too, if I had
found a way to figure out which messages a given target supports, or
whether the target in question is the multipath target in the first
place. But I couldn't figure it out. If it's possible, please tell me
how. 

Wrt "fail_path", the assumption is that other rq-based targets would
either not support "fail_path" and thus return an error, or implement
it with the same semantics as multipath. In both cases, my patch would
do the "right thing" (falling back to standard behavior in the error
case).

Thanks,
Martin


