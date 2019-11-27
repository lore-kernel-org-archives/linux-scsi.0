Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C988EC432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 17:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABCB92073F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 17:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfK0RDs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 12:03:48 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38107 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK0RDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2019 12:03:48 -0500
Received: by mail-pf1-f195.google.com with SMTP id c13so11323256pfp.5;
        Wed, 27 Nov 2019 09:03:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Jz2XEVcAJv6zWLzycZcog3vVuzU7EH6ssgXse21sBk=;
        b=HXjp1FtQpiL3Gg3m+nuSA2zYln7RGs2G9pSbYQCIIhGAuwrgHZhdeoQWp7wcKK8FeP
         ETeXbr8MsjtzmU0h1N9QXH9oXNeeEbdMPmfbL3NthSzj0nDKPYcwKfFCrxboeZ4ecm13
         SzcL11IuCasWkVv9yjB+0VILQElghk+tEtO5sJWuahz63AVH8dgP9kRJ4QvoGuCOXkQv
         2zEAGREjpxqrKIOaRq8NGilT8FiNLrxCodb35KLGr9OPqYEnQ8tetAtoKJhnkq5NV63Z
         XupPNDq6cAV6ihyPyFP0FjcTJl8pzr9VpJV0V/LAM8FbMJs8hJiNN5WhP5z4PSCMA1FC
         30WA==
X-Gm-Message-State: APjAAAWgiaS21defDLlN3aIVV+wQGx2weQRvDaRDC8ot7cQovuFH+f1m
        RQNlAL+T0Wdvje0MJ3RZB5STSJrA
X-Google-Smtp-Source: APXvYqxjOAsHlBeJKrtbIe67WTm3bRAA6BazjPVieUlq8WVWYX8A8ZSB+H8SHLM65X8dWopbrSe2+A==
X-Received: by 2002:a63:5a1b:: with SMTP id o27mr6244661pgb.251.1574874225497;
        Wed, 27 Nov 2019 09:03:45 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id y12sm7933677pjy.0.2019.11.27.09.03.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 09:03:44 -0800 (PST)
Subject: Re: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20191126131009.71726-1-hare@suse.de>
 <20191126131009.71726-5-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a18af250-04d0-7504-d6f9-3c18d19f5862@acm.org>
Date:   Wed, 27 Nov 2019 09:03:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191126131009.71726-5-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/19 5:10 AM, Hannes Reinecke wrote:
> -struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
> +bool blk_mq_init_shared_sbitmap(struct blk_mq_tag_set *tag_set)
> +{
> +	unsigned int depth = tag_set->queue_depth -tag_set->reserved_tags;

A nit: please follow the coding style for spaces around the subtraction 
sign.

> +struct blk_mq_tags *blk_mq_init_tags(struct blk_mq_tag_set *set,
> +				     unsigned int total_tags,
>   				     unsigned int reserved_tags,
> -				     int node, int alloc_policy)
> +				     int node, int alloc_policy,
> +				     bool shared_tags)
>   {
>   	struct blk_mq_tags *tags;
>   
> @@ -488,9 +517,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
>   	tags->nr_tags = total_tags;
>   	tags->nr_reserved_tags = reserved_tags;
>   
> -	if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
> -		kfree(tags);
> -		tags = NULL;
> +	if (shared_tags) {
> +		if (blk_mq_init_bitmap_tags(tags, node, alloc_policy) < 0) {
> +			kfree(tags);
> +			tags = NULL;
> +		}
>   	}
>   	return tags;
>   }

The above looks weird to me: the existing code path is only called if 
shared tags are enabled? Shouldn't "if (shared_tags)" be changed into 
"if (!shared_tags)"?

> +static inline bool blk_mq_is_sbitmap_shared(struct blk_mq_tag_set *tag_set)
> +{
> +	return !!(tag_set->flags & BLK_MQ_F_TAG_HCTX_SHARED);
> +}

Another nit: since the return type of this function is 'bool', the 
double exclamation mark and the parentheses are superfluous.

Bart.
