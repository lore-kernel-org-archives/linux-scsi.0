Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 857DAC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 16:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EF3361363
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 16:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhDYQRq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 12:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhDYQRq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 12:17:46 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12DEC061574
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 09:17:04 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f29so1391176pgm.8
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 09:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/CgjknHmTbeCE3qHm1ZKMHULGEo8L8qg3hm7ZUKCAB8=;
        b=CwkD7LZ2gjDf1jUOl+BTcW8S5J2jaGTZTB/NU5HDfpmvSA+mwTH01PgAnQRHkJyfGY
         et4vXfuSk+XeNiGfUpVM80X/eBBEiO4vUrab27Ti1zVGHx6N1wkAjtj2KbBPiGLxD+8C
         BiiDvh5kONzRdMm4MD+d2QsJamO0otPwX8nE4Qa8i4fJAbbvcItLjCup/b8XvtvnxZj5
         fyg6yvX7ww0tIPTROJuJqFS5lcLlubrY+j1eSdbm5tyfflY0qgLbYB3NNrfx/+N2sow7
         KTF5axmykWytJj61DzPAd5qeYwFnT3vubO1+GTXi8z30yGI8oid4bzT8QfDKOptVEBNW
         mOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/CgjknHmTbeCE3qHm1ZKMHULGEo8L8qg3hm7ZUKCAB8=;
        b=UAuVJ3JjsotRRw3vp8/zWmc/OTwJDA2D+s3gnVI9HJkV6UYCZdwHHtQ6KENiskzks2
         GaMRqh17KMh0JTLYY7S8Zpwpa7+M8REqWBoxusbxjQtO/aQ+Y2hkwXFlO2Jo1ipNsum2
         /iIJUsPWo6RMT5XFnvWbjgd6M7ias5q2NI0r+d2SAkUgYY5HNdh24ANB5g7Jr6xAjBiv
         3ZWKQxnh61aouELOu3r1NkKzWac2VeP3iMMhlRdqcUvcNU/tV5Vo6PLzhNZmBySvRP7Y
         mYlm1P8lr/BmuPJNZ+QRdlVlKV9pW4rUEKrDknva6CjaxDZbvm1cRw/TVkEx2Mq5xyVO
         0P8g==
X-Gm-Message-State: AOAM5322OFWUusQVrY2DwKUCcbfCBgncwXnvgvaNinqc8k+ub1/DFXpy
        vmcbYtaIiUh72ImYnr08nF1xWA==
X-Google-Smtp-Source: ABdhPJwXiKeutKRiBmXDFfYFHWo7CYfXl/YngWn0hLcnMONUYMfSiRTFl3d0IAvP+SBSTFR29TusYw==
X-Received: by 2002:a62:5c6:0:b029:24d:e97f:1b1d with SMTP id 189-20020a6205c60000b029024de97f1b1dmr13801534pff.40.1619367424423;
        Sun, 25 Apr 2021 09:17:04 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q26sm9585477pfg.146.2021.04.25.09.17.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 09:17:03 -0700 (PDT)
Subject: Re: [PATCH 0/8] blk-mq: fix request UAF related with iterating over
 tagset requests
To:     Ming Lei <ming.lei@redhat.com>, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <77cbc472-279e-5c9a-3428-b1a485b3f1b7@kernel.dk>
Date:   Sun, 25 Apr 2021 10:17:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210425085753.2617424-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/21 2:57 AM, Ming Lei wrote:
> Hi Guys,
> 
> Revert 4 patches from Bart which try to fix request UAF issue related
> with iterating over tagset wide requests, because:
> 
> 1) request UAF caused by normal completion vs. async completion during
> iterating can't be covered[1]
> 
> 2) clearing ->rqs[] is added in fast path, which causes performance loss
> by 1% according to Bart's test
> 
> 3) Bart's approach is too complicated, and some changes aren't needed,
> such as adding two versions of tagset iteration
> 
> This patchset fixes the request UAF issue by one simpler approach,
> without any change in fast path.
> 
> 1) always complete request synchronously when the completing is run
> via blk_mq_tagset_busy_iter(), done in 1st two patches
> 
> 2) grab request's ref before calling ->fn in blk_mq_tagset_busy_iter,
> and release it after calling ->fn, so ->fn won't be called for one
> request if its queue is frozen, done in 3rd patch
> 
> 3) clearing any stale request referred in ->rqs[] before freeing the
> request pool, one per-tags spinlock is added for protecting
> grabbing request ref vs. clearing ->rqs[tag], so UAF by refcount_inc_not_zero
> in bt_tags_iter() is avoided, done in 4th patch.

I'm going to pull the UAF series for now so we don't need to do a series
of reverts if we deem this a better approach. I'll take a further look
at it tomorrow.

-- 
Jens Axboe

