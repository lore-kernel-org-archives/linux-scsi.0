Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F5FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 10:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AB4A610CB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 10:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245512AbhIXKJn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 06:09:43 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33614 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245423AbhIXKJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 06:09:42 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6E18A2239C;
        Fri, 24 Sep 2021 10:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1632478088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Az/gC5KGv43+SgELQ31mu60xbm11p3hDz0QY5xlRQWY=;
        b=vGEbQQXGMoytgpOtdIQtyEjPHnLSPwh0U+WXXrtU0FaPCwJjzdAAqiToZW1NtF5rveKK6Y
        cGFuEiy7wqSY2eg9BmcIv2Kt7sV4la5iOgoXNE/R04n/7O0zS0e868+ST7Ws1EwNwBFyNO
        IHMpVp3mQXnnxu0L4aJqSRX5DrKVa8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1632478088;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Az/gC5KGv43+SgELQ31mu60xbm11p3hDz0QY5xlRQWY=;
        b=63ipEH6EgjLo1kkIaCFgA5lBc8DN1eQ4OtKRgw6I+2O/19sRhdCZSdyiSvG8CPureuvRoH
        cTZeMXoKs58hJyDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 20A15139F0;
        Fri, 24 Sep 2021 10:08:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zZf1BIijTWHDRgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 24 Sep 2021 10:08:08 +0000
Subject: Re: [PATCH v4 05/13] blk-mq-sched: Rename blk_mq_sched_alloc_{tags ->
 map_and_rqs}()
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, ming.lei@redhat.com
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-6-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <45c9da89-2f69-20dc-9ead-86a8b387a643@suse.de>
Date:   Fri, 24 Sep 2021 12:08:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1632472110-244938-6-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/21 10:28 AM, John Garry wrote:
> Function blk_mq_sched_alloc_tags() does same as
> __blk_mq_alloc_map_and_request(), so give a similar name to be consistent.
> 
> Similarly rename label err_free_tags -> err_free_map_and_rqs.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-mq-sched.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
