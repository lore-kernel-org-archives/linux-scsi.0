Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B29C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Oct 2022 20:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiJTU0y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Oct 2022 16:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJTU0w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2022 16:26:52 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087A916EA32;
        Thu, 20 Oct 2022 13:26:52 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 128so614350pga.1;
        Thu, 20 Oct 2022 13:26:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UcVdsVpWTg1bqp0DssZWEbQWVHACMWpyZ0EkSPZisAw=;
        b=J4ODttDsOblkWlUsTwJLGV9YmJTfXMTfbGc06rWcEFScHmpeDHYCINz4sUB600wk9s
         NEVcn6X6WuQAkfjraKcO7eWXPx0C5jjJ9imIP0eKtEOFgPUEj7qyijwP2thuGoiY+mvr
         rAN6L/0Ym87bT4ta03Y43Y1Y6eIoClgtw/q944Iee37TwpzUfvugVTOIrpnvRrIJ6ViS
         257XG+fWrBDf+RXSImVDiOYh/s0rImLdYshDq6AhPpvwYi5Bj+OeWLRjUpU7g4FhEVZe
         ooh6pXJCAqRIDS3tUklDSaS2XqzCzVL9YOdpoj6H+/tGsQ2PffqJazA+mjfV7sVElcR7
         b5UA==
X-Gm-Message-State: ACrzQf2+u8vlFo3bOw4O8bT0zRKfoB7ZyEoCs9aSdvQ77NOEqqFpB+Zu
        JKVCtNJ29OixDxPvublO3h0=
X-Google-Smtp-Source: AMsMyM6xtAkA3oCIoi3Vof6+mOsYN/mliGzKF84BTGsSAugy3LveMr0HkCXlNJtYd8K7dP3Swvmh/w==
X-Received: by 2002:a63:5a05:0:b0:434:23a5:a5ca with SMTP id o5-20020a635a05000000b0043423a5a5camr13281708pgb.515.1666297611256;
        Thu, 20 Oct 2022 13:26:51 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e10c:786f:1f97:68bc? ([2620:15c:211:201:e10c:786f:1f97:68bc])
        by smtp.gmail.com with ESMTPSA id b10-20020a170902650a00b001752216ca51sm13285395plk.39.2022.10.20.13.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 13:26:50 -0700 (PDT)
Message-ID: <7d5eae39-3a56-df7d-eb72-3cb910c2b802@acm.org>
Date:   Thu, 20 Oct 2022 13:26:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [Bug] double ->queue_rq() because of timeout in ->queue_rq()
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, djeffery@redhat.com,
        stefanha@redhat.com
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <Y1EQdafQlKNAsutk@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y1EQdafQlKNAsutk@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/22 02:10, Ming Lei wrote:
 > [ ... ]

Hi Ming,

Fixing this in the block layer seems fine to me. A few comments:

> +	/* Before walking tags, we must ensure any submit started before the
> +	 * current time has finished. Since the submit uses srcu or rcu, wait
> +	 * for a synchronization point to ensure all running submits have
> +	 * finished
> +	 */

Should the above comment follow the style of other comments in the block 
layer?

> +	blk_mq_wait_quiesce_done(q);
> +
> +	blk_mq_queue_tag_busy_iter(q, blk_mq_check_expired, &expired);

The above doesn't look sufficient to me since .queue_rq() may be called 
while blk_mq_queue_tag_busy_iter() is in progress. How about moving the 
blk_mq_wait_quiesce_done() call into blk_mq_check_expired() and 
preventing new .queue_rq() calls before the timeout handler is called?

Thanks,

Bart.
