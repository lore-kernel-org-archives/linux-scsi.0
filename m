Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A20C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Mar 2022 01:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiCFBGZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Mar 2022 20:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiCFBGY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2022 20:06:24 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3FE212A9B;
        Sat,  5 Mar 2022 17:05:33 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id w37so10597779pga.7;
        Sat, 05 Mar 2022 17:05:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=j2FSp3cfxcn5KCrqDrI7U0kH+LHHo0cs2vtQaNFHar0=;
        b=mHdnG/zhvGjLQ7rGHFHS2UfSgec0d2umnlpBEpzN5BKvFx3plQ1qtXrJSyNbztEMqp
         kahpbEATZXhuPxE9+A9yj1im2Dx9Ihlpa8Q/T5L1qsRtnMFu7XcmEWZl0s3BQQbKU8tq
         vsLVP/aKzlaR6KykhaIP0kBKrkuBDX/P0bB2BdECcUaovH3kq9egu6kseGAB/w07nwIC
         2NvUmVbHHQwjyH8ryqI4PXSYBHKTkDKDk7XL13xCtf/lUpZeJ569h+YOIrg8n82cHaTr
         CBQNDZk+SPpFtpYb87q2UHgi4rtR/vTTSFKx+2MDrmqHRRSOYl5MmjvABZKj6XgvMZYp
         hUXg==
X-Gm-Message-State: AOAM533UudICCYc28szevP57bnjuhg5rGQrtVnZd5eFxhuLytvbn89pM
        5VZNPSTR/EXXLbPyvd4S5OA=
X-Google-Smtp-Source: ABdhPJwspvFEJqHRa2HWn9oEiByNYY0AyVvqPgN57xQYciMRkF8YDivakC8M4EXszS0/82J2GBPweg==
X-Received: by 2002:a05:6a00:1a56:b0:4f4:1a2a:6d1b with SMTP id h22-20020a056a001a5600b004f41a2a6d1bmr6038318pfv.65.1646528733068;
        Sat, 05 Mar 2022 17:05:33 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s6-20020a056a0008c600b004f667b8a6b6sm10832122pfu.193.2022.03.05.17.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 17:05:32 -0800 (PST)
Message-ID: <f367967d-81af-2d1d-9d07-7c8e792335ef@acm.org>
Date:   Sat, 5 Mar 2022 17:05:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 02/14] blk-mq: handle already freed tags gracefully in
 blk_mq_free_rqs
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220304160331.399757-1-hch@lst.de>
 <20220304160331.399757-3-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220304160331.399757-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/22 08:03, Christoph Hellwig wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> To simplify further changes allow for double calling blk_mq_free_rqs on
> a queue.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
