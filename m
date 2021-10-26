Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF429C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 17:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C81DD6103C
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 17:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237754AbhJZRWB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 13:22:01 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:51314 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237595AbhJZRWA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 13:22:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635268776;
        bh=52xK43kRKfdluKoJGhYc3FsNA0B0U9qwYIxYqNUo/Iw=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Y+ZTU/RWspPBQdmW8KVwKWskjBGUVY4y199yzzfSAAr0vrc2yN3u5cfK4+fi6OgCd
         z2r/D/Bhn2z1fddQMw92AWLWnW8umxrjthG9ihGXq3cV+wq7hx6dDcGIbWaNSROabk
         3609xkxHuyWyisXX4o7tyFQ1VlTXSqVkAxlngN6I=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7AE9E12805D0;
        Tue, 26 Oct 2021 13:19:36 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xPGqYtobtT2F; Tue, 26 Oct 2021 13:19:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635268776;
        bh=52xK43kRKfdluKoJGhYc3FsNA0B0U9qwYIxYqNUo/Iw=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Y+ZTU/RWspPBQdmW8KVwKWskjBGUVY4y199yzzfSAAr0vrc2yN3u5cfK4+fi6OgCd
         z2r/D/Bhn2z1fddQMw92AWLWnW8umxrjthG9ihGXq3cV+wq7hx6dDcGIbWaNSROabk
         3609xkxHuyWyisXX4o7tyFQ1VlTXSqVkAxlngN6I=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id A7A291280518;
        Tue, 26 Oct 2021 13:19:35 -0400 (EDT)
Message-ID: <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc:     axboe@kernel.dk, alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Date:   Tue, 26 Oct 2021 13:19:34 -0400
In-Reply-To: <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
References: <20211026071204.1709318-1-hch@lst.de>
         <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-10-26 at 09:36 -0700, Bart Van Assche wrote:
> On 10/26/21 12:12 AM, Christoph Hellwig wrote:
> > The HPB support added this merge window is fundanetally flawed as
> > it
>                                               ^^^^^^^^^^^^
>                                               fundanetally ->
> fundamentally
> 
> Since the implementation can be reworked not to use
> blk_insert_cloned_request() I'm not sure using the word
> "fundamentally" is appropriate.

I'm not so sure about that.  The READ BUFFER implementation runs from a
work queue and looks fine.  The WRITE BUFFER implementation is trying
to spawn a second command to precede the queued command which is a
fundamental problem for the block API.  It's not clear to me that the
WRITE BUFFER can be fixed because of the tying to the sent command ...
but like I said, the standard is proprietary so I can't look at it to
see if there are alternative ways of achieving the same effect.

James


