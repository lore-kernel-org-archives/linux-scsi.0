Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A641C32771
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 14:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbiIXOpD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Sep 2022 10:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiIXOpC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Sep 2022 10:45:02 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1910E193E7
        for <linux-scsi@vger.kernel.org>; Sat, 24 Sep 2022 07:44:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 78so2750718pgb.13
        for <linux-scsi@vger.kernel.org>; Sat, 24 Sep 2022 07:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=TWVzC21c5d2NqQztqHDFwpjqSWsHdjN9DLlu20PUWx8=;
        b=ItptfoELiWkjEYFyiIX8hiMBoKNuUQuAttg1trY0mIsImaGVH6DszeMst6K1KS82Ii
         RYcaDEQYT4udFeskrHRVLQBjIPsgGAwataX5FrZjrMJrWrhUy3ObhDyqrTOM4r45HVC7
         hIeQADVq0iMjiNc3W+HNI7oYYHaL3EEz8CN7pUF+iHdnkyFOlMSs8hZ/Wy6VzqfZFngG
         3qt8F8cL+rhqMPIzlR07lX4i6l7xZUDTq9piUxD2M/MuryShRm4Wd1f0ynPhoTi9B3v0
         J0BBuYTqDODOiZW6/5VN73NY/VqfCGSNgTlULGIdVwixeiFgUnCBre7OxFs1X4cmtxJs
         31xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=TWVzC21c5d2NqQztqHDFwpjqSWsHdjN9DLlu20PUWx8=;
        b=jcupn1Mmz3E8TpPZfW4wGL6CEMzaiJVoXKMQcMkhERBklVW9RziVzE7y92X1vN4QCX
         Mj/0e1TDns28FKdHFar8f5i1CNoZ4ht9ejT9DfZa9h9W9Qx5Mc5s8x4HKRAN6xfm4wOX
         ep15svg4TYPEUxf4l30YfAlb4zBMiIa8NkzQPTjME0OemIdZzjWm4DmTZFA/GhLWjKOa
         gaCbR9nX9OOUf/9zUO5vvau9ZWh7IfjD3SYsIpUGZTNWjyqPPBCzY/G2faBl6iC0GQqF
         mFhYDtf0gPxkNFqs8KHE+A/uZbKsFKBdG3JSFapECOqpAB2T931Yz7CCuXqxlhtjInSa
         Gg5w==
X-Gm-Message-State: ACrzQf0XitmwOsrkBzDWDr7vRwVDRXCfNjLTlizH4oGyOjVqOn1aAuxU
        Ue2uwtdxXd9VruuI1XDP+HlMoA==
X-Google-Smtp-Source: AMsMyM6sTGXP7jWsSWvUC/oEVRP7gnuPS1ZqAwV7Y99Dd6a0eEpjvNDQkMDyFA16cKFF1Y1vfMSfSw==
X-Received: by 2002:a05:6a00:18a1:b0:542:5e3a:3093 with SMTP id x33-20020a056a0018a100b005425e3a3093mr14288143pfh.18.1664030695771;
        Sat, 24 Sep 2022 07:44:55 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jg11-20020a17090326cb00b001769ee307d8sm7920782plb.59.2022.09.24.07.44.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Sep 2022 07:44:55 -0700 (PDT)
Message-ID: <3048caf9-3f67-d198-225e-6c7efc8aa373@kernel.dk>
Date:   Sat, 24 Sep 2022 08:44:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/5] block: enable batched allocation for
 blk_mq_alloc_request()
To:     Pankaj Raghav <p.raghav@samsung.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, joshi.k@samsung.com,
        Pankaj Raghav <pankydev8@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-2-axboe@kernel.dk>
 <CGME20220923145245eucas1p107655755f446bb1e1318539a3f82d301@eucas1p1.samsung.com>
 <20220923145236.pr7ssckko4okklo2@quentin>
 <c7b76fa1-f7e3-3ac6-c92d-35baa0d9a40a@samsung.com>
 <2e484ccb-b65b-2991-e259-d3f7be6ad1a6@kernel.dk>
 <59e40929-bc1e-5d1e-3dcf-b9ba39b3d393@samsung.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <59e40929-bc1e-5d1e-3dcf-b9ba39b3d393@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/24/22 5:56 AM, Pankaj Raghav wrote:
>>>> As the passthrough path can now support request caching via blk_mq_alloc_request(),
>>>> and it uses blk_execute_rq_nowait(), bad things can happen at least for zoned
>>>> devices:
>>>>
>>>> static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>>>> {
>>>> 	/* Zoned block device write operation case: do not plug the BIO */
>>>> 	if (bdev_is_zoned(bio->bi_bdev) && op_is_write(bio_op(bio)))
>>>> 		return NULL;
>>>> ..
>>>
>>> Thinking more about it, even this will not fix it because op is
>>> REQ_OP_DRV_OUT if it is a NVMe write for passthrough requests.
>>>
>>> @Damien Should the condition in blk_mq_plug() be changed to:
>>>
>>> static inline struct blk_plug *blk_mq_plug( struct bio *bio)
>>> {
>>> 	/* Zoned block device write operation case: do not plug the BIO */
>>> 	if (bdev_is_zoned(bio->bi_bdev) && !op_is_read(bio_op(bio)))
>>> 		return NULL;
>>
>> That looks reasonable to me. It'll prevent plug optimizations even
>> for passthrough on zoned devices, but that's probably fine.
>>
> 
> Do you want me send a separate patch for this change or you will fold it in
> the existing series?

Probably cleaner as a separate patch, would be great if you could
send one.

-- 
Jens Axboe


