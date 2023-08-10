Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFA6C04A6A
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Aug 2023 14:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbjHJOA5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Aug 2023 10:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbjHJOAw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Aug 2023 10:00:52 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00E5EA;
        Thu, 10 Aug 2023 07:00:51 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-26871992645so627487a91.0;
        Thu, 10 Aug 2023 07:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691676051; x=1692280851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LlypYbRKG3NKpXgPKPqR+UWALgFg6Q8FfGNiBjrzt2Y=;
        b=SR1SkR8AN1tw05fgF1Jfpq9f4vb/iR1QBbAJ+AMI0Mwe8xeFD9ydQ/6Srh4YiE1SZ5
         Wk943Btwp/DtCtHUWFj8+4DnlWtBbKp2otGf5ibtmjHBs4fGf+2G+KIjMGwDFVoBLVS9
         Ni/L19TiFz68b6/3MJbypBXGVNdS21/ZLV0EO5DgirPh/k9c5NtGKpDvj6dYosPvJgA0
         KCHi7FHb9VqeIlCOmYzijIPCE1zqrC/abk4017i5W5Kaj1Z/lWHLFHG3x8C0aPAjaatO
         w3vrr6xOssFXKSUSycrJmqmXk8li2sR+3+wPD0nHbsphe6EOqUAXrK0f0ndjCsZRDv6W
         +K7g==
X-Gm-Message-State: AOJu0YxZL9cy9EqOZshTC2MwYSAAn/x9gKvmG4l5lhwC+w/ad2Y0lUw8
        Cye2NgLVR8bTJxl3EQAIMvU=
X-Google-Smtp-Source: AGHT+IFDz3mok5Kt8wN7GsVxc1JbntKwspV6ya4sG4nYEBvX7NmXHUlRpnR7On6oK8H9hCQdqErg/A==
X-Received: by 2002:a17:90b:614:b0:261:685:95b6 with SMTP id gb20-20020a17090b061400b00261068595b6mr2393491pjb.13.1691676051026;
        Thu, 10 Aug 2023 07:00:51 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id c4-20020a17090ab28400b00256a4d59bfasm3354851pjr.23.2023.08.10.07.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 07:00:50 -0700 (PDT)
Message-ID: <d83cb0aa-ae35-bb58-5cd0-72b8c03d934f@acm.org>
Date:   Thu, 10 Aug 2023 07:00:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v7 2/7] block/mq-deadline: Only use zone locking if
 necessary
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230809202355.1171455-1-bvanassche@acm.org>
 <20230809202355.1171455-3-bvanassche@acm.org>
 <06527195-8f6d-0395-a7d5-d19634a00ad2@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <06527195-8f6d-0395-a7d5-d19634a00ad2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/23 18:36, Damien Le Moal wrote:
> On 8/10/23 05:23, Bart Van Assche wrote:
>> +static bool dd_use_zone_write_locking(struct request_queue *q)
>> +{
>> +	return q->limits.use_zone_write_lock && blk_queue_is_zoned(q);
> 
> use_zone_write_lock should be true ONLY if the queue is zoned.
> So the "&& blk_queue_is_zoned(q)" seems unnecessary to me.
> This little helper could be moved to be generic in blkdev.h too.

Hi Damien,

use_zone_write_lock should be set by the block driver (e.g. a SCSI
LLD) before I/O starts. The zone model information is retrieved by
submitting I/O. It is not clear to me how to set use_zone_write_lock
to true only for zoned block devices before I/O starts since I/O is
required to retrieve information about the zone model.

Thanks,

Bart.
