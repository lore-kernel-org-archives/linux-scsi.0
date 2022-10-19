Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F88BC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 08:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJSIT2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 04:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJSITZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 04:19:25 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1167E54;
        Wed, 19 Oct 2022 01:19:21 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id bv10so27740352wrb.4;
        Wed, 19 Oct 2022 01:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=nHS/CM6webR/7nd+4yMwfl0IAANpp1MykTgQv0ozjIoIxiWrcCB/ubApiOfUDLv/Z8
         SXXJew++KVBD5ffqfruxdYgBsa3hMWdtv/uYbbw58DsTHrijvKfA8cGcUQ64/OX6q9Z0
         NSv6haYqdseVZsI9B+MgjBTBHIeJqFHot/XxanYBiFOPqldRyZ0X8oNZ6AchafDZnAOm
         JC24rAinn60asxvkLsifIqqYVgEvUAfYTBSS2potzBk+XqUN8S8SaKSvf6FpYLLcgWlz
         ho8VSjvIk6G7pWJ0NNdmYO/mY51+gzdheudKMBLUSqTEJEJZlSkbC7dTaU64U93+rjjI
         W21Q==
X-Gm-Message-State: ACrzQf1mwlXD0orrKbPS+Nw2q0ZPCKUBAOA1hIZ2snl/rSGAJdYnwebC
        6r2ezAz8xULzRvC201H3D058S90/BNk=
X-Google-Smtp-Source: AMsMyM4phRfopiz5f0imFpQegXOUVZaDZySXbHjtKCWLqKaefCuITL0Nfnon8CM1wenadX1ryUnB6A==
X-Received: by 2002:a5d:584e:0:b0:22e:4276:c66b with SMTP id i14-20020a5d584e000000b0022e4276c66bmr4104280wrf.204.1666167560166;
        Wed, 19 Oct 2022 01:19:20 -0700 (PDT)
Received: from [192.168.64.53] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id u17-20020a5d4351000000b00231910fa71asm13212840wrr.57.2022.10.19.01.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 01:19:19 -0700 (PDT)
Message-ID: <56e35f32-e0d8-f4a3-f887-613c74b06664@grimberg.me>
Date:   Wed, 19 Oct 2022 11:19:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/4] blk-mq: move the call to blk_put_queue out of
 blk_mq_destroy_queue
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-2-hch@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20221018135720.670094-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
