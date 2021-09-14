Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A012C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03CCA610A6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbhINFhJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 01:37:09 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:33434 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237341AbhINFhH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 01:37:07 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6BECD1FDCA;
        Tue, 14 Sep 2021 05:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631597749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0a/VnN2wn6kf3CRj3bkdHFe/CL4cRuLtEaRPbeckjQ4=;
        b=KsjLS31ATYXTnlL4QvHJ/ThAcNB3xoCMosE6QzcP1t2e/HO1CIEPaJjmzqWoSPkbgBqTpA
        p5xUfuwKGf2WFjNgkGEsT2ZcadRYw34yjsCGSHV6IiB6nrVaZSVKWJ7fTJAmkMU9nsQSXJ
        dkiBtoEnOTeSQNBYhcrxvOFwcwhZyuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631597749;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0a/VnN2wn6kf3CRj3bkdHFe/CL4cRuLtEaRPbeckjQ4=;
        b=FKOY6uS0FUh60q5rvrz+RVtV1Rb1Oika+KRaosu8ykFoYfSekYTiv6+Qw0GMPGV7n/xeWe
        oefhygvPfR60ddDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2244F13E4A;
        Tue, 14 Sep 2021 05:35:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iZ5EArU0QGEOTwAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Sep 2021 05:35:48 +0000
Subject: Re: [PATCH RESEND v3 01/13] blk-mq: Change rqs check in
 blk_mq_free_rqs()
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org
References: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
 <1631545950-56586-2-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7a75a9e0-5467-e4fa-d059-8154f5568854@suse.de>
Date:   Tue, 14 Sep 2021 07:35:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1631545950-56586-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 5:12 PM, John Garry wrote:
> The original code in commit 24d2f90309b23 ("blk-mq: split out tag
> initialization, support shared tags") would check tags->rqs is non-NULL and
> then dereference tags->rqs[].
> 
> Then in commit 2af8cbe30531 ("blk-mq: split tag ->rqs[] into two"), we
> started to dereference tags->static_rqs[], but continued to check non-NULL
> tags->rqs.
> 
> Check tags->static_rqs as non-NULL instead, which is more logical.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-mq.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 108a352051be..2316ff27c1f5 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2340,7 +2340,7 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>   {
>   	struct page *page;
>   
> -	if (tags->rqs && set->ops->exit_request) {
> +	if (tags->static_rqs && set->ops->exit_request) {
>   		int i;
>   
>   		for (i = 0; i < tags->nr_tags; i++) {
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
