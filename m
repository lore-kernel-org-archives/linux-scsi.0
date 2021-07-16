Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20F3C07E95
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 06:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B80613EB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 06:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhGPGaa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 02:30:30 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:46084 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhGPGa3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 02:30:29 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A47F522B2C;
        Fri, 16 Jul 2021 06:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626416854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TmMy70WD+CpKzOcn1WOO998XRVBC5aWIVMeL/cL9/x4=;
        b=yUKMzHUnJLYoaaNxkyS7wQ5Jst0tfVkVMfg9JgSl5KWASgxsIqrYa5ipWEzEVc+jEkA8kJ
        KqsiY5DNxjKl/zBC49QA04z899KyxGgjdIeH5zIyu7TxpadAGlZ3rynt2WwCuPQXgz6Bsi
        cFvZn95BQc/LzCRq1Imkg8DU/PnCL+8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626416854;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TmMy70WD+CpKzOcn1WOO998XRVBC5aWIVMeL/cL9/x4=;
        b=OPEW4Df7DHPbdtcTSq9hk2TgI3EAqDSTYqwLzLeRmyh/VOohc/Y5tCsqK1iWVraWqtSEYd
        iOCYGrqgbfYZWvBA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 7D95313357;
        Fri, 16 Jul 2021 06:27:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id OjXhHNYm8WDiQAAAGKfGzw
        (envelope-from <hare@suse.de>); Fri, 16 Jul 2021 06:27:34 +0000
Subject: Re: [PATCH] scsi: dm-mpath: do not fail paths when the target returns
 ALUA state transition
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.com>
References: <CAHZQxyLY3vNeuNiEHC3SzWzBgUaN-ZPOYyZ3bA=Ah63WYwgdfw@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <eace208b-fd4a-2a98-5dc7-7262bf7a390c@suse.de>
Date:   Fri, 16 Jul 2021 08:27:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHZQxyLY3vNeuNiEHC3SzWzBgUaN-ZPOYyZ3bA=Ah63WYwgdfw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/15/21 6:57 PM, Brian Bunker wrote:
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
>          if (error && blk_path_error(error)) {
>                  struct multipath *m = ti->private;
> 
> -               if (error == BLK_STS_RESOURCE)
> +               if (error == BLK_STS_RESOURCE || error == BLK_STS_AGAIN)
>                          r = DM_ENDIO_DELAY_REQUEUE;
>                  else
>                          r = DM_ENDIO_REQUEUE;
> 
> -               if (pgpath)
> +               if (pgpath && (error != BLK_STS_AGAIN))
>                          fail_path(pgpath);
> 
>                  if (!atomic_read(&m->nr_valid_paths) &&
> --

Sorry, but this will lead to regressions during failover for arrays 
taking longer time (some take up to 30 minutes for a complete failover).
And for those it's absolutely crucial to _not_ retry I/O on the paths in 
transitioning.

And you already admitted that 'queue_if_no_path' would resolve this 
problem, so why not update the device configuration in multipath-tools 
to have the correct setting for your array?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
