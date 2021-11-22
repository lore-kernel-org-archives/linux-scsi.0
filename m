Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B90C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 17:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbhKVRlu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 12:41:50 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:45985 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbhKVRlt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 12:41:49 -0500
Received: by mail-pj1-f45.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so507605pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 09:38:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yZh1YYYEzZ+KpjHgtkVKRS202CaMlzmdEZ7ABaH7YiU=;
        b=dDWyqx/Dc31tMZRpEhSLQehA4o80cI2c11YV1Gb9aqk4FvWLYIyz+t2cBJ7QoNKn5p
         Alk4vdDGZptqmL0FPz6wTZ0Hix79H93DdxSpHzCW2OjyNRsAQgKdGnLF9BH2btiT66Hj
         JLp80C/uhzPCaInnVZxCPOMXTXzBi3FrxR5WArQUjmlMPRMvra0avd7ZmlWHdufh8NU/
         buYcyGdX9QP6RF/7Dk2hYaFp296ogwqbdVgpSDWIp/M3z6l8ym+mOT4UB1iD42/uoU5u
         0XKxqGEZtHX2CtsJbGwS3FLIgQScRSe21L0rJaD9nb+AgdmD91806ULxfpuv/Mcj5vgO
         CGcg==
X-Gm-Message-State: AOAM533rvjUyOsiVf12c8c79KEq5RmvCK30pZ9dDp0G8tzwMlvI8R97U
        JIvEmDQcDw5VKOIjZBDUMOE=
X-Google-Smtp-Source: ABdhPJzASrTRuLE4vP628ovwAV3PlIkzDz6mjV0GUu/i639BT11Wfxkl80543NYRrKiHIZ/0qsv7VQ==
X-Received: by 2002:a17:90b:3b43:: with SMTP id ot3mr33827804pjb.205.1637602723005;
        Mon, 22 Nov 2021 09:38:43 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3432:c377:2744:1125])
        by smtp.gmail.com with ESMTPSA id j8sm9930778pfc.8.2021.11.22.09.38.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 09:38:42 -0800 (PST)
Subject: Re: [PATCH v2 01/20] block: Add a flag for internal commands
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-2-bvanassche@acm.org>
 <c2f48945-6e6f-d610-9e56-1546fee07b49@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cb0fbbaf-9ad5-ceb8-dbed-942f36ea943f@acm.org>
Date:   Mon, 22 Nov 2021 09:38:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c2f48945-6e6f-d610-9e56-1546fee07b49@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/21 12:46 AM, John Garry wrote:
> On 19/11/2021 19:57, Bart Van Assche wrote:
>> From: Hannes Reinecke <hare@suse.de> >
>> Some drivers use a single tag space for requests submitted by the block
>> layer and driver-internal requests. Driver-internal requests will never
>> pass through the block layer but require a valid tag. This patch adds a
>> new request flag REQ_INTERNAL.
> 
> I'm not sure on the name. Don't we already use term "internal" for 
> elevator request tag?

I don't see how any confusion could arise between "internal_tag" and 
"REQ_INTERNAL" since in both cases the context is made clear - either 
the request tag or the request in its entirety.

>> to mark such requests and a terminates any
>> such commands in blk_execute_rq_nowait() with a WARN_ON_ONCE() to signal
>> such an invalid usage.
 >
> FYI, I have been working on a different stream, that allows us to send 
> the reserved request through the block layer, as we need it for poll 
> mode support. The reason is that we need to send reserved requests on 
> specific HW queues, which may be polling. However poll mode support only 
> allows us to poll requests with bios, so that's a problem ATM.

Please use REQ_OP_DRV_* without REQ_INTERNAL for requests that need to 
be sent through the block layer.

Thanks,

Bart.
