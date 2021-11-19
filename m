Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F613C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 20:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 895A9611F2
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 20:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbhKSUK4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbhKSUK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:10:56 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714AFC061574;
        Fri, 19 Nov 2021 12:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1637352474;
        bh=GoH8Z3qQb7lyaM011BrYXNUd8I3bbmPLKjf7XPbDzD8=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=SA2dkc0wyLU8/amoW6rKP2KA/LilJroNBMHKZIhz7vEcVQ1+ibSUjIy6LNtddYmor
         HPEdz0JEh+lkZ4FlXDrwikd7nJFHklxXdbs+kXENV1bYDmtazbJXtkbOfsx3TmTvPp
         fmhA3jAfEPx10Yxg/HguCaGr25EvRsCAgpHG8lyQ=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 1A8B71280CDD;
        Fri, 19 Nov 2021 15:07:54 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kRn0czFAr-2H; Fri, 19 Nov 2021 15:07:54 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1637352473;
        bh=GoH8Z3qQb7lyaM011BrYXNUd8I3bbmPLKjf7XPbDzD8=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=m8qKepLX/cI3EvDssSoW9hMbE7HNLExAPBLDWIPwOF+/lSPLhN35OIyZUMqNnp4c/
         XDHoYAZbtJm8pgGIPEj6FYmGbLj6xHxyBRbIwTa7MFgWcScQkuE/1dFSh7uk7cZqQ6
         ab6/NH96BXF8eECRHrmWw6P7Ioh4VqVy/YmNVLIo=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6931F1280C85;
        Fri, 19 Nov 2021 15:07:53 -0500 (EST)
Message-ID: <af4fd590c7b90e5b3eef13f2fcd0bbb500192d2a.camel@HansenPartnership.com>
Subject: Re: [GIT PULL] SCSI fixes for 5.16-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 19 Nov 2021 15:07:52 -0500
In-Reply-To: <CAHk-=wjiTXOy3EJ4Eb++umuCgiDufJxrNZ9Z17_NhdORKZGbSA@mail.gmail.com>
References: <0a508ff31bbfa9cd73c24713c54a29ac459e3254.camel@HansenPartnership.com>
         <CAHk-=wjiTXOy3EJ4Eb++umuCgiDufJxrNZ9Z17_NhdORKZGbSA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-11-19 at 11:29 -0800, Linus Torvalds wrote:
> On Fri, Nov 19, 2021 at 10:20 AM James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > Six fixes, five in drivers (ufs, qla2xxx, iscsi) and one core
> > change to fix a regression in user space device state setting,
> > which is used by the iscsi daemons to effect device recovery.
> 
> Language nit.

hey your "nit" is that I used an English verb correctly?

> One of the few correct uses of "to effect" - but perhaps best avoided
> just because even native speakers get it wrong. And we have a lot of
> non-native speakers too.

Well, OK, we do the difference between effect and affect in high
school, but I'm happy to use a more neutral phrasing because I do
notice when people get it wrong (I just silently correct internally).

> It might have been clearer to just say "to start device recovery" or
> perhaps just "as part of device recovery". Just to avoid confusion
> with "affect". Which it obviously _also_ does.
> 
> I kept your wording, but this is just a note that maybe commit
> messages should strive to generally use fairly basic English language
> and try to avoid things that are known to trip people up.

I can certainly relate to the need to be clear and unambiguous, but
this is the thin end of the wedge: you'll be telling me I can't use the
subjunctive mood next just because Americans don't understand what it
is ...

James


