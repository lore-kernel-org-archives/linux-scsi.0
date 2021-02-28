Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA574C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 16:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916CE64EB7
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Feb 2021 16:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhB1Qhr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Feb 2021 11:37:47 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:58612 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229834AbhB1Qhq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Feb 2021 11:37:46 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 71F3F12808DB;
        Sun, 28 Feb 2021 08:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1614530224;
        bh=5V2a/TJD0A4I7b81AJzzgsFoUVXT9QzubVAxkUo4i+4=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=DP3suaUz/olv+mNjqUwRrz95Dh9JaVXOleWkcSwOQx/fVWxP3FfUD45HTN8SBKyDW
         8UnnLkSXkQHqXJdCoAKQi3tDjjdNBT86yWK+fUv/OncOJgZOr0NDFT6KrZtH2IXbNL
         tkHi1nr511KUYlWKIi36nVWL7jfTHV+4KE5eQG1g=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vpP3usmwSBWx; Sun, 28 Feb 2021 08:37:04 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 225EB12808D9;
        Sun, 28 Feb 2021 08:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1614530224;
        bh=5V2a/TJD0A4I7b81AJzzgsFoUVXT9QzubVAxkUo4i+4=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=DP3suaUz/olv+mNjqUwRrz95Dh9JaVXOleWkcSwOQx/fVWxP3FfUD45HTN8SBKyDW
         8UnnLkSXkQHqXJdCoAKQi3tDjjdNBT86yWK+fUv/OncOJgZOr0NDFT6KrZtH2IXbNL
         tkHi1nr511KUYlWKIi36nVWL7jfTHV+4KE5eQG1g=
Message-ID: <443d92dd844e329bcd40a1e59b7cc3784ed3db94.camel@HansenPartnership.com>
Subject: Re: [PATCH RESEND v2] scsi: ignore Synchronize Cache command
 failures to keep using drives not supporting it
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Guido Trentalancia <guido@trentalancia.com>,
        linux-scsi@vger.kernel.org
Date:   Sun, 28 Feb 2021 08:37:03 -0800
In-Reply-To: <1614502908.6594.6.camel@trentalancia.com>
References: <1614502908.6594.6.camel@trentalancia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 2021-02-28 at 10:01 +0100, Guido Trentalancia wrote:
> Many obsolete hard drives do not support the Synchronize Cache SCSI
> command. Such command is generally issued during fsync() calls which
> at the moment therefore fail with the ILLEGAL_REQUEST sense key.

It should be that all drives that don't support sync cache also don't
have write back caches, which means we don't try to do a cache sync on
them.  The only time you we ever try to sync the cache is if the device
advertises a write back cache, in which case the sync cache command is
mandatory.

I'm sure some SATA manufacturers somewhere cut enough corners to
produce an illegally spec'd drive like this, but your proposed remedy
is unviable: you can't ignore a cache failure on flush barriers which
will cause data corruption.  You have to disable barriers on the
filesystem to get correct operation and be very careful about power
down.

James


