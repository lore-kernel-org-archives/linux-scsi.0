Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEAE1C41513
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 17:01:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjHNRA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 13:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjHNRAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 13:00:39 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D408F1733;
        Mon, 14 Aug 2023 10:00:25 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-26b0b4a7cccso3013789a91.1;
        Mon, 14 Aug 2023 10:00:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692032425; x=1692637225;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nteGdYrZN3XFEVLmrj3D/CZDWuq6FRMukFgAkXDOWhQ=;
        b=bPckEnPJlpXgdaxkH+B5h/3nUFMV7P9go6u5Zc9XOxGezKs339vkatbQvtpT2QIlJX
         A69ZTorVk9erNdczawYhZOlAGkeAt0MfJsuoWR5y/MP52hswhIDq1GDEP6LAH7T3KAXN
         XqsuHWBBeFwsAm7iwDIiDVo7mmJsBX4cBomQ3dVlpJesVSekwzoud4prKieaSoAVWnC1
         TsEfpFMFh40prqPNzRJLRj902ERMaEyr0r9AFhKZFMW2T1S3SxN1bJ3K6RFlWOOl127/
         Znz+KKEs0zg8Lgn9UfZgHXJ4920IYGXYCE4TusbmzEm167paCC89Zg2CaLVI4tjvOF/g
         VGTA==
X-Gm-Message-State: AOJu0YzwyKXGinwp5Cggk6Gbswm9rQCg6yReYNtqLpoW+UwVxcbzyXj5
        ntt8QU48Pl+FlRunSTEXTfA=
X-Google-Smtp-Source: AGHT+IH+bjbLr4DX+IkMbvLZQd7N+08Jyz/7L4FWGQ4pQMpP7P35MTkHlUbBp08iXgNRaMghy2qpGg==
X-Received: by 2002:a17:90a:9e2:b0:26b:c5b:bb44 with SMTP id 89-20020a17090a09e200b0026b0c5bbb44mr9291283pjo.13.1692032425205;
        Mon, 14 Aug 2023 10:00:25 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:e105:59a6:229c:65de? ([2620:15c:211:201:e105:59a6:229c:65de])
        by smtp.gmail.com with ESMTPSA id jw14-20020a17090b464e00b0026b26181ac9sm6289647pjb.14.2023.08.14.10.00.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 10:00:24 -0700 (PDT)
Message-ID: <e7054af1-d820-b808-80ac-1b636c0f6a40@acm.org>
Date:   Mon, 14 Aug 2023 10:00:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v8 2/9] block/mq-deadline: Only use zone locking if
 necessary
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-3-bvanassche@acm.org>
 <0ba79726-fb9c-c5ae-146f-ffc29703ec21@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0ba79726-fb9c-c5ae-146f-ffc29703ec21@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 05:33, Damien Le Moal wrote:
> On 8/12/23 06:35, Bart Van Assche wrote:
>> @@ -934,7 +936,7 @@ static void dd_finish_request(struct request *rq)
>>   
>>   	atomic_inc(&per_prio->stats.completed);
>>   
>> -	if (blk_queue_is_zoned(q)) {
>> +	if (rq->q->limits.use_zone_write_lock) {
> 
> This is all nice and simple ! However, an inline helper to check
> rq->q->limits.use_zone_write_lock would be nice. E.g.
> blk_queue_use_zone_write_lock() ?

Hi Damien,

Do you perhaps want me to introduce a function that does nothing else than
returning the value of q->limits.use_zone_write_lock? I'm asking this because
recently I have seen a fair number of patches that remove functions that do
nothing else than returning the value of a single member variable.

Thanks,

Bart.

