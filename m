Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76039C433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 21:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 465DE221F2
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jan 2021 21:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbhAAVsW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jan 2021 16:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbhAAVsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jan 2021 16:48:22 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A50CC061573;
        Fri,  1 Jan 2021 13:47:42 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id AF44F12800A7;
        Fri,  1 Jan 2021 13:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1609537659;
        bh=AcWCBmCpYzbMF/MEbnq/yt924qqZaAf5/HtOQS6bbQI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=xxxQDJ9eGCvU5L2CH4TO3Sw39TT45vF0q2pZF43DCIheQgfbvCNAkqWz4PryTJbNe
         G9oPT3K2yW0Yz10CufyjacpI43igvB5P/JKIi9Hzs44K4vRWnITlvP0gcNWkcN6erE
         97DgHTS5FtdPcl62Fic2rojl31y/5/uBovarnrpQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fTKmc7V4vpkN; Fri,  1 Jan 2021 13:47:39 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 47A0612800A0;
        Fri,  1 Jan 2021 13:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1609537659;
        bh=AcWCBmCpYzbMF/MEbnq/yt924qqZaAf5/HtOQS6bbQI=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=xxxQDJ9eGCvU5L2CH4TO3Sw39TT45vF0q2pZF43DCIheQgfbvCNAkqWz4PryTJbNe
         G9oPT3K2yW0Yz10CufyjacpI43igvB5P/JKIi9Hzs44K4vRWnITlvP0gcNWkcN6erE
         97DgHTS5FtdPcl62Fic2rojl31y/5/uBovarnrpQ=
Message-ID: <922c1a43c698df32e81f84c7324c96f2d017eff5.camel@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 5.11-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 01 Jan 2021 13:47:38 -0800
In-Reply-To: <CAHk-=widrXOWKSaDmMLZyhJzUvKx6M0uDP1xGJzYB4YGAJqHJA@mail.gmail.com>
References: <dd63a06d53c45f9511307085797086351784b1a3.camel@HansenPartnership.com>
         <CAHk-=widrXOWKSaDmMLZyhJzUvKx6M0uDP1xGJzYB4YGAJqHJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-01-01 at 13:21 -0800, Linus Torvalds wrote:
> On Fri, Jan 1, 2021 at 12:19 PM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Originally this change was slated for the merge window but a late
> > arriving build problem with CONFIG_PM=n derailed that.
> 
> So I've pulled this,

Thanks!

>  but we need to have a policy for reverting this
> quickly if it turns out to cause problems.

Sure, we'd have to revert the six patches plus the dependent PM fix.

> I'm not worried about any remaining build issues - but I'm simply
> worried about some missed case where code depended on the block layer
> passing commands through even while suspended.
> 
> The block bits would seem affect non-SCSI stuff too, how extensively
> have any random odd special case been tested?

The block bits have been in -next since 7 December, so it has had some
testing.  That said, REQ_PREEMPT doesn't affect much outside of SCSI
and IDE because we're where the original concept of at head insertion
for "special" error handling commands like request sense came from.

I'd expect the biggest field of potential problems to be in USB which
does both block/SCSI and PM.  That should have been well tested by the
PM people (as far as they can, as you know there are tons of non spec
devices out there in the space).

> So I'm not so much with you on the "the scary case is the spi domain
> validation case".  I'm more about "what about all the other random
> cases for random special drivers"

I picked on that because it's the least likely to get any testing for a
while.  However, you're right, there are other potential problem
consumers but hopefully any problem (if there is one) with the rest
will show up quickly.

James


