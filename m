Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 741F3C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 19:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A3DD61186
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 19:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbhJFTVn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 15:21:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229926AbhJFTVm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Oct 2021 15:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB8EF60E08;
        Wed,  6 Oct 2021 19:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633547990;
        bh=jtxsG2SwawdYzU6il/sfJ0ENU64MGlMKlZB80iW6roU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VyaoB/EI+7jjXddZ4SHcH6AV6AtIFbAae+qixWQ/hOt749shXxxaEoJabGr3+q+DT
         etE0sPLuPKY10HhidWeRDgwi2cx31o/deCcjst00Ye/Seed7zKwydYQQmxoMWT9dik
         kPf+5C9cRwN4bF4fp+G0WSFVWNMD3V7YLgKT4J3HlldRzG23vvRq9G4Gb5x3cZO7F+
         gYP3hH7QxxiO4O9LRn6bcBJjYCAhwqMYsAIAJ6UK2aEfUSGkKYEtkJvtIgB//bf0ie
         Y+cq/1c9scMiyPP5tVqRfwOO/w+Q9EmqNR3VawZiRkXmj1t/zz4OMLFYn1D0fqn1X0
         TQWW2OGrDRQ1g==
Date:   Wed, 6 Oct 2021 12:19:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        Satya Tangirala <satyaprateek2357@gmail.com>,
        dm-devel@redhat.com, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v4 3/4] blk-crypto: rename blk_keyslot_manager to
 blk_crypto_profile
Message-ID: <YV321JFYV/u7pbsO@gmail.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
 <20210929163600.52141-4-ebiggers@kernel.org>
 <YV2kdHeS4GTXUdpi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV2kdHeS4GTXUdpi@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 06, 2021 at 09:28:20AM -0400, Mike Snitzer wrote:
> On Wed, Sep 29 2021 at 12:35P -0400,
> Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > blk_keyslot_manager is misnamed because it doesn't necessarily manage
> > keyslots.  It actually does several different things:
> > 
> >   - Contains the crypto capabilities of the device.
> > 
> >   - Provides functions to control the inline encryption hardware.
> >     Originally these were just for programming/evicting keyslots;
> >     however, new functionality (hardware-wrapped keys) will require new
> >     functions here which are unrelated to keyslots.  Moreover,
> >     device-mapper devices already (ab)use "keyslot_evict" to pass key
> >     eviction requests to their underlying devices even though
> >     device-mapper devices don't have any keyslots themselves (so it
> >     really should be "evict_key", not "keyslot_evict").
> > 
> >   - Sometimes (but not always!) it manages keyslots.  Originally it
> >     always did, but device-mapper devices don't have keyslots
> >     themselves, so they use a "passthrough keyslot manager" which
> >     doesn't actually manage keyslots.  This hack works, but the
> >     terminology is unnatural.  Also, some hardware doesn't have keyslots
> >     and thus also uses a "passthrough keyslot manager" (support for such
> >     hardware is yet to be upstreamed, but it will happen eventually).
> > 
> > Let's stop having keyslot managers which don't actually manage keyslots.
> > Instead, rename blk_keyslot_manager to blk_crypto_profile.
> > 
> > This is a fairly big change, since for consistency it also has to update
> > keyslot manager-related function names, variable names, and comments --
> > not just the actual struct name.  However it's still a fairly
> > straightforward change, as it doesn't change any actual functionality.
> > 
> > Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Unfortunate how fiddley this change forced you to get but it looks
> like you've done a very solid job of cleaning it all up to be
> consistent.
> 
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>
> 

Thanks for the reviews!  Yes, we should have done it this way originally which
would have saved some pain, but better late than never.

Jens, anything else you're waiting for before applying this series?  Note that
I'm not sure that Satya will leave any feedback, given that he's no longer
working for Google, so any kernel work he does is in his free time.

- Eric
