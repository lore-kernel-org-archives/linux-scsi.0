Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252B7C07E96
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jul 2021 17:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0867C613C7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jul 2021 17:01:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhGOREg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jul 2021 13:04:36 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50418 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhGOREg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jul 2021 13:04:36 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 30F801FE5A;
        Thu, 15 Jul 2021 17:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626368502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cmubAet99w7xkVJgHd71Bh2zXx4vYIktuP7LSlDUzRE=;
        b=upkIIo6jD6kfOlw7O79ysYs6wqUJBBpe9PQHqG42h8IVtpft9Qwg20ZGjeCwCnTZEaYCWN
        iEuUuqi/eJpoZM6o49hWGZUk6U8DvjHt0aqWXzOQxJuSfptQnPaK3Q1a7uAO/VHMQwIyUy
        Rbht7hJQ00vWUl83YE/NW/aZg+1uIjs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0326113C3F;
        Thu, 15 Jul 2021 17:01:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ilkvOvVp8GApEgAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 15 Jul 2021 17:01:41 +0000
Message-ID: <779ddba3c7d184b6b65a17ac1203d7dd5c0def6f.camel@suse.com>
Subject: Re: [PATCH] scsi: dm-mpath: do not fail paths when the target
 returns ALUA state transition
From:   Martin Wilck <mwilck@suse.com>
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.com>
Date:   Thu, 15 Jul 2021 19:01:41 +0200
In-Reply-To: <CAHZQxyLY3vNeuNiEHC3SzWzBgUaN-ZPOYyZ3bA=Ah63WYwgdfw@mail.gmail.com>
References: <CAHZQxyLY3vNeuNiEHC3SzWzBgUaN-ZPOYyZ3bA=Ah63WYwgdfw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Do, 2021-07-15 at 09:57 -0700, Brian Bunker wrote:
> When paths return an ALUA state transition, do not fail those paths.
> The expectation is that the transition is short lived until the new
> ALUA state is entered. There might not be other paths in an online
> state to serve the request which can lead to an unexpected I/O error
> on the multipath device.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> Acked-by: Seamus Connor <sconnor@purestorage.com>
> --
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index bced42f082b0..28948cc481f9 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1652,12 +1652,12 @@ static int multipath_end_io(struct dm_target
> *ti, struct request *clone,
>         if (error && blk_path_error(error)) {
>                 struct multipath *m = ti->private;
> 
> -               if (error == BLK_STS_RESOURCE)
> +               if (error == BLK_STS_RESOURCE || error ==
> BLK_STS_AGAIN)
>                         r = DM_ENDIO_DELAY_REQUEUE;
>                 else
>                         r = DM_ENDIO_REQUEUE;
> 
> -               if (pgpath)
> +               if (pgpath && (error != BLK_STS_AGAIN))
>                         fail_path(pgpath);
> 
>                 if (!atomic_read(&m->nr_valid_paths) &&
> --
> 
> Thanks,
> Brian
> 
> Brian Bunker
> PURE Storage, Inc.
> brian@purestorage.com
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>


