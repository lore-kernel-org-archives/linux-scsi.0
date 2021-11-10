Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DF8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 06:59:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E62B611C9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 06:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhKJHCH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 02:02:07 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50792 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhKJHCG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 02:02:06 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 60A7821B18;
        Wed, 10 Nov 2021 06:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636527557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v20ZPswb1lmQvGyovqV6K2Hy4u+qVNrI6anvbwb2hRM=;
        b=LRWixLysELZdr5mI0/jkVM1CcfqjQ1EQ+gbe9RiPYTGYlhGPEuTvdg4GVpEC0Z5sk68B/d
        eSrLecwcXnBAnKKm3lJjA87poBPNpyOUiFUxZjcE2Zx2PP4Ex3zAvODNIW/nDV5iKS6gck
        QAbqEb+J/Qp+hva7iNHr5LEwU0w52Hg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636527557;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v20ZPswb1lmQvGyovqV6K2Hy4u+qVNrI6anvbwb2hRM=;
        b=fjNLchQ5c0e6mpAPuM0Iwe80B7x8OpYGc9md9zkwXg6gNfRn6m1QSSLmyEAzgT2R0gIhTZ
        tguHsASO11EpE5BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 450E313B52;
        Wed, 10 Nov 2021 06:59:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9zkYEMVti2GPWgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 10 Nov 2021 06:59:17 +0000
Subject: Re: [PATCH 1/2] scsi: core: Add support for reserved tags
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-2-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <139e5cb6-c91e-fa64-f261-6359b6abe376@suse.de>
Date:   Wed, 10 Nov 2021 07:59:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20211103000529.1549411-2-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/3/21 1:05 AM, Bart Van Assche wrote:
> Allow SCSI LLDs to allocate reserved tags by passing the BLK_MQ_REQ_RESERVED
> flag to blk_get_request().
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c  | 4 +++-
>   include/scsi/scsi_host.h | 9 ++++++++-
>   2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d0b7c6dc74f8..1cbade5fe990 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1917,6 +1917,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   {
>   	unsigned int cmd_size, sgl_size;
>   	struct blk_mq_tag_set *tag_set = &shost->tag_set;
> +	unsigned int reserved_tags = shost->hostt->reserved_tags;
>   
>   	sgl_size = max_t(unsigned int, sizeof(struct scatterlist),
>   				scsi_mq_inline_sgl_size(shost));
> @@ -1932,7 +1933,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   		tag_set->ops = &scsi_mq_ops_no_commit;
>   	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
>   	tag_set->nr_maps = shost->nr_maps ? : 1;
> -	tag_set->queue_depth = shost->can_queue;
> +	tag_set->queue_depth = shost->can_queue + reserved_tags;
> +	tag_set->reserved_tags = reserved_tags;
>   	tag_set->cmd_size = cmd_size;
>   	tag_set->numa_node = NUMA_NO_NODE;
>   	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 97cdad14de56..5502fcb306db 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -367,10 +367,17 @@ struct scsi_host_template {
>   	/*
>   	 * This determines if we will use a non-interrupt driven
>   	 * or an interrupt driven scheme.  It is set to the maximum number
> -	 * of simultaneous commands a single hw queue in HBA will accept.
> +	 * of simultaneous commands a single hw queue in HBA will accept. Does
> +	 * not include @reserved_tags.
>   	 */
>   	int can_queue;
>   
> +	/*
> +	 * Number of tags to reserve. A reserved tag can be allocated by passing
> +	 * the BLK_MQ_REQ_RESERVED flag to blk_get_request().
> +	 */
> +	unsigned reserved_tags;
> +
>   	/*
>   	 * In many instances, especially where disconnect / reconnect are
>   	 * supported, our host also has an ID on the SCSI bus.  If this is
> 
This is essentially the same patch as I posted a while ago (cf 
https://lore.kernel.org/linux-scsi/20210222132405.91369-1- hare@suse.de/).

But there had been push-back on that series as it would also try to use 
a scsi host device for driver-internal commands.

Maybe we should combine our efforts; patch 2 is equivalent to your 
patch, and 3-5 are a conversion of the fnic driver to use those 
commands. So we should merge our efforts to get this thing off the ground.

For the remainder of the patchset I'm currently working on a solution to 
address the upstream concerns.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
