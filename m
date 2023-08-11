Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C12B8C001B0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 15:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbjHKPuE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 11:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjHKPuD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 11:50:03 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDE82123;
        Fri, 11 Aug 2023 08:50:02 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-686f090310dso1945199b3a.0;
        Fri, 11 Aug 2023 08:50:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691769002; x=1692373802;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7BGmmVu/pwR0eeIJc8KqR8StUrvY/sFCiKoCd8mLBP4=;
        b=XephIM7Mi9Dvtt+rhRmKrIWjbKvUV+JRAmGw6RRLbpF7eR0jSpGyt8X8cc5nqHkkJI
         eKWHUwR1C1xnW2TxvD9d0VMXwRStEDy4y+AJGPGx7K2mzL6W9Hj1Rq+p7xE4KiasEuFF
         epjpigc42l5C1W31nRTp+OGJ7vz7RVvN3oYS2pD3b14myalRVAPCnEYqmLeb5bEdsvxc
         qZwWNqvCX5h6UPwoRlIHEJcgPAg5Pn0rpwt84UXJa+J6Zb0KgmgY6h+SvWeBScFpx6e2
         K6gutGCdEzPX/mZcXqmqnN3/YjBb+NYEgsTR5FG2Ei/n7jC5aZh0BmyFKirM8DgOJTRI
         p5iQ==
X-Gm-Message-State: AOJu0Yws1kPyDjpDNt1vz5I12GtcuZAQ0WvgQYAsHw6BYYci57/uTE3S
        tfWosGDlfN3SJtdlyvspHNA=
X-Google-Smtp-Source: AGHT+IHo6hekdjQwRm3gH90+uHzaTBLtvZ2IW4bJmXqPitJaguiXiQfV3grffUFMmo8u5ZiJSeGe/w==
X-Received: by 2002:a05:6a00:198b:b0:676:399f:346b with SMTP id d11-20020a056a00198b00b00676399f346bmr2781776pfl.1.1691769001878;
        Fri, 11 Aug 2023 08:50:01 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a40a:5c20:3595:c0ec? ([2620:15c:211:201:a40a:5c20:3595:c0ec])
        by smtp.gmail.com with ESMTPSA id x5-20020aa784c5000000b006875493da1fsm3608575pfn.10.2023.08.11.08.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Aug 2023 08:50:01 -0700 (PDT)
Message-ID: <92e109dc-c5ee-ce0c-002c-3323f3918503@acm.org>
Date:   Fri, 11 Aug 2023 08:49:59 -0700
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
 <d83cb0aa-ae35-bb58-5cd0-72b8c03d934f@acm.org>
 <8aa716eb-e440-8a28-0c89-07729fcf1715@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8aa716eb-e440-8a28-0c89-07729fcf1715@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/23 17:45, Damien Le Moal wrote:
> With that, mq-deadline can even be simplified to not even look at the
> q zoned model and simply us q->limits.use_zone_write_lock to
> determine if locking a zone is needed or not.

Hi Damien,

I think implementing the above proposal requires splitting 
'use_zone_write_lock' into two variables:
(a) One member variable that indicates whether the zone write lock
     should be used.
(b) Another member variable that indicates whether or not the LLD
     preserves the order of SCSI commands.

Member variable (b) should be set by the LLD and member variable (a) can 
be set by disk_set_zoned().

Do you want me to implement this approach?

Thanks,

Bart.


