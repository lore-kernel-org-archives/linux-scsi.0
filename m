Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D437C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32ADB61008
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242520AbhGLJWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:22:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40914 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245200AbhGLJW3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:22:29 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A48A022047;
        Mon, 12 Jul 2021 09:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1626081577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4gAy05ADERp9aLoDjQXPcKjAsRJw1KFdIgVOInJ+PYk=;
        b=a2+c1gix61nen6b0ciE45NG1GwPy9uXSWIGPO4SP2UlILwH1mBcKpKbcygEUdMB7NWbA8r
        cjNczjVsBLvMOcLBaKKggRU3T9VMJVHddanLGVTYnmwyo6utVc//+yHR1lXy97j4i7zDBQ
        d8TPv2oopwVzTZA+D7I5EC2d9t6HTvs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 723CD13B1E;
        Mon, 12 Jul 2021 09:19:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4YiEGSkJ7GBjIgAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 12 Jul 2021 09:19:37 +0000
Message-ID: <32a96fc27c250fb5772a0b301576ad702b8ea934.camel@suse.com>
Subject: Re: [PATCH 1/1]: scsi dm-mpath do not fail paths which are in ALUA
 state transitioning
From:   Martin Wilck <mwilck@suse.com>
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
Date:   Mon, 12 Jul 2021 11:19:36 +0200
In-Reply-To: <CAHZQxyKJ1qFatzhR-k19PXjAPo7eC0ZgwgaGKwfndB=jEO8mRQ@mail.gmail.com>
References: <CAHZQxyKJ1qFatzhR-k19PXjAPo7eC0ZgwgaGKwfndB=jEO8mRQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Brian,

On Do, 2021-07-08 at 13:42 -0700, Brian Bunker wrote:
> In a controller failover do not fail paths that are transitioning or
> an unexpected I/O error will return when accessing a multipath device.
> 
> Consider this case, a two controller array with paths coming from a
> primary and a secondary controller. During any upgrade there will be a
> transition from a secondary to a primary state.
> 
> [...]
> 4. It is not expected that the remaining 4 paths will also fail. This
> was not the case until the change which introduced BLK_STS_AGAIN into
> the SCSI ALUA device handler. With that change new I/O which reaches
> that handler on paths that are in ALUA state transitioning will result
> in those paths failing. Previous Linux versions, before that change,
> will not return an I/O error back to the client application.
> Similarly, this problem does not happen in other operating systems,
> e.g. ESXi, Windows, AIX, etc.

Please confirm that your kernel included ee8868c5c78f ("scsi:
scsi_dh_alua: Retry RTPG on a different path after failure").
That commit should cause the RTPG to be retried on other map members
which are not in failed state, thus avoiding this phenomenon.


> [...]
> 
> 6. The error gets back to the user of the muitipath device
> unexpectedly:
> Thu Jul  8 13:33:59 2021: /opt/Purity/bin/bb/pureload I/O Error: io
> 43047 fd 36  op read  offset 00000028ef7a7000  size 4096  errno 11
> rsize -1
> 
> The earlier patch I made for this was not desirable, so I am proposing
> this much smaller patch which will similarly not allow the
> transitioning paths to result in immediate failure.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> Acked-by: Seamus Connor <sconnor@purestorage.com>
> 
> ____
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index bced42f082b0..d5d6be96068d 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1657,7 +1657,7 @@ static int multipath_end_io(struct dm_target
> *ti, struct request *clone,
>                 else
>                         r = DM_ENDIO_REQUEUE;
> 
> -               if (pgpath)
> +               if (pgpath && (error != BLK_STS_AGAIN))
>                         fail_path(pgpath);
> 
>                 if (!atomic_read(&m->nr_valid_paths) &&
> 

I doubt that this is correct. If you look at the commit msg of
268940b80fa4 ("scsi: scsi_dh_alua: Return BLK_STS_AGAIN for ALUA
transitioning state"):


 "When the ALUA state indicates transitioning we should not retry the command
 immediately, but rather complete the command with BLK_STS_AGAIN to signal
 the completion handler that it might be retried.  This allows multipathing
 to redirect the command to another path if possible, and avoid stalls
 during lengthy transitioning times."

The purpose of that patch was to set the state of the transitioning
path to failed in order to make sure IO is retried on a different path.
Your patch would undermine this purpose.

Regards
Martin


