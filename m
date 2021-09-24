Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B87A2C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 10:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1F4A61107
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 10:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240521AbhIXKZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 06:25:29 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:35968 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240310AbhIXKZ3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 06:25:29 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3117222428;
        Fri, 24 Sep 2021 10:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632479035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cdj+MChX4WpMa83LUp1k/Esc7Eco7Cg2FeFEGab5+Ek=;
        b=pv2YhabYU/ytTd6fBQH7+j4RkgAtmgFmNovZGGs/+P36zRZwVqjrJBktgV4POBQ12oYZzx
        4N/jiMGIKPNCunjG3Nk6BDfd/loRPqRDo9ei426Xx0CU+R24/ABucJ3RcR5DGCw+Czb9Zw
        OzXRkMwb3kOD6neRWn7EyfiL5gaVQ4E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632479035;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cdj+MChX4WpMa83LUp1k/Esc7Eco7Cg2FeFEGab5+Ek=;
        b=6NUJqaIS7y8JdVBp6wmwnzYXCVi5O0aNUJB644YMQLY/T+EtDHvwzLAXLTbQ1RaMhmEAxb
        XwSscH6gaWUH6tBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 06D4313AB5;
        Fri, 24 Sep 2021 10:23:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0xGDADunTWEGTwAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 24 Sep 2021 10:23:55 +0000
Subject: Re: [PATCH v4 12/13] blk-mq: Use shared tags for shared sbitmap
 support
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, ming.lei@redhat.com
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-13-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9dd771bb-9e45-ecd2-d8e4-93c6e9cb9b59@suse.de>
Date:   Fri, 24 Sep 2021 12:23:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1632472110-244938-13-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/21 10:28 AM, John Garry wrote:
> Currently we use separate sbitmap pairs and active_queues atomic_t for
> shared sbitmap support.
> 
> However a full sets of static requests are used per HW queue, which is
> quite wasteful, considering that the total number of requests usable at
> any given time across all HW queues is limited by the shared sbitmap depth.
> 
> As such, it is considerably more memory efficient in the case of shared
> sbitmap to allocate a set of static rqs per tag set or request queue, and
> not per HW queue.
> 
> So replace the sbitmap pairs and active_queues atomic_t with a shared
> tags per tagset and request queue, which will hold a set of shared static
> rqs.
> 
> Since there is now no valid HW queue index to be passed to the blk_mq_ops
> .init and .exit_request callbacks, pass an invalid index token. This
> changes the semantics of the APIs, such that the callback would need to
> validate the HW queue index before using it. Currently no user of shared
> sbitmap actually uses the HW queue index (as would be expected).
> 
> Continue to use term "shared sbitmap" for now, as the meaning is known.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   block/blk-mq-sched.c   | 82 ++++++++++++++++++-------------------
>   block/blk-mq-tag.c     | 61 ++++++++++------------------
>   block/blk-mq-tag.h     |  6 +--
>   block/blk-mq.c         | 91 +++++++++++++++++++++++-------------------
>   block/blk-mq.h         |  5 ++-
>   include/linux/blk-mq.h | 15 ++++---
>   include/linux/blkdev.h |  3 +-
>   7 files changed, 125 insertions(+), 138 deletions(-)
> 
The overall idea to keep the full request allocation per queue was to 
ensure memory locality for the requests themselves.
When moving to a shared request structure we obviously loose that feature.

But I'm not sure if that matters here; the performance impact might be 
too small to be measurable, seeing that we'll be most likely bound by 
hardware latencies anyway.

Nevertheless: have you tested for performance regressions with this 
patchset?
I'm especially thinking of Kashyaps high-IOPS megaraid setup; if there 
is a performance impact that'll be likely scenario where we can measure it.

But even if there is a performance impact this patchset might be 
worthwhile, seeing that it'll reduce the memory footprint massively.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
