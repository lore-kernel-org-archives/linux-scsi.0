Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B830C2FC3D
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 14:21:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351805AbjHQOVZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351811AbjHQOVV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 10:21:21 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFA230C6;
        Thu, 17 Aug 2023 07:21:19 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1bdc8081147so7019095ad.1;
        Thu, 17 Aug 2023 07:21:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692282079; x=1692886879;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=doPszRaxb9/4aAuNDgX3hC/2hLgfoHZ5dbhDCD5Yc84=;
        b=GE46xeWYJM8E+28luULAeiTHBf1zb3k5yYa8GzC5oQrTfnv2Uum1D9vQ2nkr4RnulG
         76rOQ0Hal8TaZdwihhaLQlBS9+sTuR1SEzL2RVk4HTEzhLgaXHRb5uzXFvEizB5LoHO0
         P0gNseEKZyyGD1b96AFwuSZ545GgpTzt1hiWuANd6KzUeUIGHPV1xp62RHbkWRnm0QtP
         uiNTEPN74AIIg75LsTNFKRN/ZBiGI2Pu44NEeptjERGIPh8FIlXjrxpC2tBsn2WFN5pd
         +bf1lMcIetmkjvux8lY2dv6nqnIh5YhSYO2i6DqlSbVmYu2+C7c2uSaecb5U1ELOUVQ2
         mODA==
X-Gm-Message-State: AOJu0Yycwz0IJ6K0t2yi/s8ST1w0J3jK2u0azuWJZMRy8PplTA7OrR+D
        DyXJjOzLgnmGxMhADf0MIh0=
X-Google-Smtp-Source: AGHT+IGK2O968MxULonLkiIvt0R8Fnr37jU6Li4FQru1mc7wC2vtfEJavqSEFjuNCY3YSvHzpj1YWA==
X-Received: by 2002:a17:902:d4c2:b0:1bd:9498:f15d with SMTP id o2-20020a170902d4c200b001bd9498f15dmr3298255plg.24.1692282079283;
        Thu, 17 Aug 2023 07:21:19 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dfd:6f25:f7be:a9ca? ([2620:15c:211:201:dfd:6f25:f7be:a9ca])
        by smtp.gmail.com with ESMTPSA id jh15-20020a170903328f00b001bde77f3d0esm7673475plb.117.2023.08.17.07.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 07:21:18 -0700 (PDT)
Message-ID: <5f45675d-20ac-02b5-8f88-edcc0d4ffc8a@acm.org>
Date:   Thu, 17 Aug 2023 07:21:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v9 02/17] block: Only use write locking if necessary
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-3-bvanassche@acm.org>
 <0b3b4453-52a1-75e3-4dfd-6aae74c8c257@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0b3b4453-52a1-75e3-4dfd-6aae74c8c257@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:01, Damien Le Moal wrote:
> On 8/17/23 04:53, Bart Van Assche wrote:
>> Make blk_req_needs_zone_write_lock() return false if
>> q->limits.use_zone_write_lock is false. Inline this function because it
>> is short and because it is called from the hot path of the mq-deadline
>> I/O scheduler.
> 
> Your are not actually inlining the function. Did you forget to move it to
> blkdev.h ?

I considered inlining but eventually decided not to inline 
blk_req_needs_zone_write_lock(). I will update the patch description.

Thanks,

Bart.

