Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF4DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A507A60F6D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240036AbhINGG4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 02:06:56 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36996 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239977AbhINGGt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 02:06:49 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DC50D1FDB5;
        Tue, 14 Sep 2021 06:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631599531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czloRHDt7KG6dixgZlMBPS8hgVmlcKIlRgQy6IQr0Qc=;
        b=mXzTvmQ0fT5Rlu2mZ46JTwZ6V5roI73STmJKRDy4Wod4z613d3vn5J4MlJU/Q0KK/C1OWW
        onrvj5CdbsfO+NVumqdV6SPnf7DWI5cqYREcgT0TKqmPTNn+YdY1Uxb8GpxTvpjgdaLu9g
        26Bcq43CEyvMe5NJns5A0tj9B8ocZwQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631599531;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czloRHDt7KG6dixgZlMBPS8hgVmlcKIlRgQy6IQr0Qc=;
        b=3to0PJoVYXaPC3CGvvVAkwt854FYkwBpfOEBkWf6VncNnhkbFAnJHl/QT3nj9LwYdsrtwc
        4595tkTI9OzkTXDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0E85913E48;
        Tue, 14 Sep 2021 06:05:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 05vgNag7QGF9WQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Sep 2021 06:05:28 +0000
Subject: Re: [PATCH RESEND v3 13/13] blk-mq: Stop using pointers for
 blk_mq_tags bitmap tags
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org
References: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
 <1631545950-56586-14-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <cbbd167f-1b11-6cb4-94fb-7c13aa0b65b5@suse.de>
Date:   Tue, 14 Sep 2021 08:05:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1631545950-56586-14-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 5:12 PM, John Garry wrote:
> Now that we use shared tags for shared sbitmap support, we don't require
> the tags sbitmap pointers, so drop them.
> 
> This essentially reverts commit 222a5ae03cdd ("blk-mq: Use pointers for
> blk_mq_tags bitmap tags").
> 
> Function blk_mq_init_bitmap_tags() is removed also, since it would be only
> a wrappper for blk_mq_init_bitmaps().
> 
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   block/bfq-iosched.c    |  4 +--
>   block/blk-mq-debugfs.c |  8 +++---
>   block/blk-mq-tag.c     | 56 +++++++++++++++---------------------------
>   block/blk-mq-tag.h     |  7 ++----
>   block/blk-mq.c         |  8 +++---
>   block/kyber-iosched.c  |  4 +--
>   block/mq-deadline.c    |  2 +-
>   7 files changed, 35 insertions(+), 54 deletions(-)
> A round of silent applause :-)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
