Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AECDC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7575261159
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 05:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239666AbhINFrM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 01:47:12 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34692 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbhINFrL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 01:47:11 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 305BC1FDB5;
        Tue, 14 Sep 2021 05:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1631598354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cKeW/FZ4DdJ2gCcaRtREb5G4unwhAswTry+aj0VxKRg=;
        b=H14+V7F8du5XmjoZDs9rG95TBrv5hlWfT1sk2mewYhv6adwf+4SYQCKhVyt5PS6kPNwwUp
        8h+nObreV/sJ00YuJ4iz3adIEwQzzh6y9ejNc+6uE+g02cDMV1F8JQVyJtRu7SNRjjGu6N
        3bDEq+mO2ZpKvmrK6aR+bF13T2/+36g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1631598354;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cKeW/FZ4DdJ2gCcaRtREb5G4unwhAswTry+aj0VxKRg=;
        b=ggZYQ4aAkqP86Rj2jukSHdJ+8JoMuV251XJZhx1XUwoLNxUCBlpwHxr4cfsdAV6KNsuP1Y
        pwdkuRDT/A8BbYCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 50CC013E4A;
        Tue, 14 Sep 2021 05:45:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3H6VCQ83QGGmUgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 14 Sep 2021 05:45:51 +0000
Subject: Re: [PATCH RESEND v3 08/13] blk-mq: Don't clear driver tags own
 mapping
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com, linux-scsi@vger.kernel.org
References: <1631545950-56586-1-git-send-email-john.garry@huawei.com>
 <1631545950-56586-9-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e489b220-b01d-4408-c166-e23c9d96d43a@suse.de>
Date:   Tue, 14 Sep 2021 07:45:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1631545950-56586-9-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 5:12 PM, John Garry wrote:
> Function blk_mq_clear_rq_mapping() is required to clear the sched tags
> mappings in driver tags rqs[].
> 
> But there is no need for a driver tags to clear its own mapping, so skip
> clearing the mapping in this scenario.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   block/blk-mq.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 4bae8afdfbe1..5229c5420b85 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -2308,6 +2308,10 @@ static void blk_mq_clear_rq_mapping(struct blk_mq_tags *drv_tags,
>   	struct page *page;
>   	unsigned long flags;
>   
> +	/* There is no need to clear a driver tags own mapping */
> +	if (drv_tags == tags)
> +		return;
> +
>   	list_for_each_entry(page, &tags->page_list, lru) {
>   		unsigned long start = (unsigned long)page_address(page);
>   		unsigned long end = start + order_to_size(page->private);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
