Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEFA4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:36:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B7EA60FD7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239619AbhINFiF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 01:38:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:54464 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237341AbhINFiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 01:38:04 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BCC8B21FB5;
        Tue, 14 Sep 2021 05:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631597806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yqoE3yuxHbsN412U1V0Dy7fxfTcYoCnv06i6jbVEWrw=;
        b=nmRNeZlwEvtTML5rDeJk/MsLdPkHUlEWIxrpKkf6KWhfmwxxPJP950R0ENeDbXwWX02zn6
        qLGeeT2jol+uAOXODx9DQCpBWOwTof70wFEr2lGweD74ShVOnLA4tfeoaOzaMzzduX++Hf
        gS3P4gC7AbZmusBNidTxNFKoL5H4sIM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631597806;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yqoE3yuxHbsN412U1V0Dy7fxfTcYoCnv06i6jbVEWrw=;
        b=z5uwft8Fptb0sj7C6TrHkQgWtixPG0LpXLOjUYmzTT+VcHxGLOa8lNYsezYRdocfRTsiqz
        YP8UoAKbjJ9GsiCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 986E313E4A;
        Tue, 14 Sep 2021 05:36:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RUCVI+40QGFgTwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Sep 2021 05:36:46 +0000
Subject: Re: [PATCH RESEND v3 02/13] block: Rename BLKDEV_MAX_RQ ->
 BLKDEV_DEFAULT_RQ
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org
References: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
 <1631545950-56586-3-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <3a3d09d8-10b3-3861-84dc-b4d1785a0cc0@suse.de>
Date:   Tue, 14 Sep 2021 07:36:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1631545950-56586-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 5:12 PM, John Garry wrote:
> It is a bit confusing that there is BLKDEV_MAX_RQ and MAX_SCHED_RQ, as
> the name BLKDEV_MAX_RQ would imply the max requests always, which it is
> not.
> 
> Rename to BLKDEV_MAX_RQ to BLKDEV_DEFAULT_RQ, matching it's usage - that being
> the default number of requests assigned when allocating a request queue.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-core.c       | 2 +-
>   block/blk-mq-sched.c   | 2 +-
>   block/blk-mq-sched.h   | 2 +-
>   drivers/block/rbd.c    | 2 +-
>   include/linux/blkdev.h | 2 +-
>   5 files changed, 5 insertions(+), 5 deletions(-)
>  
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
