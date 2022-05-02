Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68288C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 16:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241836AbiEBQ0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 12:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241610AbiEBQ0M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 12:26:12 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A1EAE59
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 09:22:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 02267210EE;
        Mon,  2 May 2022 16:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651508561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vv/tpMQ4hyEOMny+RhSkApOsB5stOnmxtAiqSmGhNF4=;
        b=Bj7wGKc7IllbyJPS4hh4J7ThlQCCtA/3lIaA6n3/VenBt3ip9TvgRRYAsa3TPIq3iM0aSR
        u6AqGzseWl5Blp7sIt0l8G41/dCTft+Q1XQDaTgM1P3A7fgTycoJPx6M9PPf5OvtsQfaqm
        Hp89w1wZTzJzcgyQ4DBL6A6fJDdjrnU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651508561;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vv/tpMQ4hyEOMny+RhSkApOsB5stOnmxtAiqSmGhNF4=;
        b=TxRfNmHtTYZAo8Hq7SToq/cZw+v6E0v7+EV/7DpYsu1o4ygJ0XFh4cMm43YjiMNffjFGMQ
        OJ3eBPwoqVj1zZAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4D7BA13491;
        Mon,  2 May 2022 16:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2VJuBlAFcGITZwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 02 May 2022 16:22:40 +0000
Message-ID: <97362a06-2a50-21b9-eb1c-1fdb2179d0c9@suse.de>
Date:   Mon, 2 May 2022 09:22:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
Content-Language: en-US
To:     Brian Bunker <brian@purestorage.com>, linux-scsi@vger.kernel.org
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 08:09, Brian Bunker wrote:
> The handling of the ALUA transitioning state is currently broken. When
> a target goes into this state, it is expected that the target is
> allowed to stay in this state for the implicit transition timeout
> without a path failure. The handler has this logic, but it gets
> skipped currently.
> 
> When the target transitions, there is in-flight I/O from the
> initiator. The first of these responses from the target will be a unit
> attention letting the initiator know that the ALUA state has changed.
> The remaining in-flight I/Os, before the initiator finds out that the
> portal state has changed, will return not ready, ALUA state is
> transitioning. The portal state will change to
> SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new I/O
> immediately failing the path unexpectedly. The path failure happens in
> less than a second instead of the expected successes until the
> transition timer is exceeded.
> 
> This change allows I/Os to continue while the path is in the ALUA
> transitioning state. The handler already takes care of a target that
> stays in the transitioning state for too long by changing the state to
> ALUA state standby once the transition timeout is exceeded at which
> point the path will fail.
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
> Acked-by: Seamus Connor <sconnor@purestorage.com>
> ___
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 37d06f993b76..1d9be771f3ee 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -1172,9 +1172,8 @@ static blk_status_t alua_prep_fn(struct
> scsi_device *sdev, struct request *req)
>          case SCSI_ACCESS_STATE_OPTIMAL:
>          case SCSI_ACCESS_STATE_ACTIVE:
>          case SCSI_ACCESS_STATE_LBA:
> -               return BLK_STS_OK;
>          case SCSI_ACCESS_STATE_TRANSITIONING:
> -               return BLK_STS_AGAIN;
> +               return BLK_STS_OK;
>          default:
>                  req->rq_flags |= RQF_QUIET;
>                  return BLK_STS_IOERR;

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
