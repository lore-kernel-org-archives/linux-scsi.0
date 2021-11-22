Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4EBC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbhKVN6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:58:46 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:37731 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbhKVN6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:58:45 -0500
Received: by mail-wm1-f48.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso16846008wms.2;
        Mon, 22 Nov 2021 05:55:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2XjOzACDW7rUkmtrfr1HAifUKw3J31vQSKBnxuwuJ8g=;
        b=2/Qi1hcSMyYOHA1FCKxYaIxlrJoJd8i4O6pfpBxtCG72LsL44UKg2/RpdWYA5du6J3
         hRV0f5krQsyWTAaYfhD5KbJGFfFrVpc6O9jWJT+v6akr7Gr/Pw3Wm3Uv+TXHHCLsqA1o
         wfvj2R6YPsPg35ZodU/Ni7zfBDUc/IFezysTQZD9LjoFRqqBpf2ixpd/+QFaIEwA+ITo
         WXTz/qgF/F5QtYSAwzpEzrEzfKjou93rjvFXFNANN8qgfynGBrt4/da27+k3cO9623q4
         FAPmWBbb+JJIePiQwMFGYZ+KkyquLyNVnhiAb4vpM2sWiYAGvdeLdX3gGQqNtQo53e9G
         QpDA==
X-Gm-Message-State: AOAM531hbT0vZfelxqM9hhUXvW84Qje5GxfwVPvd2Q/9icL32w7MsYX8
        2J8onv7tx2OsnSWQAo0OzEY=
X-Google-Smtp-Source: ABdhPJwnKiWn1edWGJeYIgb4UdPnjH6KQyYj/SgbK8Y1T/NH4oHrBbgWTMmkZ4uecxdgm7i6xBvEtA==
X-Received: by 2002:a05:600c:1d97:: with SMTP id p23mr29788839wms.186.1637589338490;
        Mon, 22 Nov 2021 05:55:38 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id l5sm10895275wrs.59.2021.11.22.05.55.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 05:55:38 -0800 (PST)
Subject: Re: [PATCH 3/5] blk-mq: add helper of blk_mq_global_quiesce_wait()
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-4-ming.lei@redhat.com>
 <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me> <YZuagPbZJ6CjiUNi@T590>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <38b9661e-c5b8-ae18-f2ab-b30f9d3e7115@grimberg.me>
Date:   Mon, 22 Nov 2021 15:55:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZuagPbZJ6CjiUNi@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>> Add helper of blk_mq_global_quiesce_wait() for supporting to quiesce
>>> queues in parallel, then we can just wait once if global quiesce wait
>>> is allowed.
>>
>> blk_mq_global_quiesce_wait() is a poor name... global is scope-less and
>> obviously it has a scope.
> 
> How about blk_mq_shared_quiesce_wait()? or any suggestion?

Shared between what?

Maybe if the queue has a non-blocking tagset, it can have a "quiesced"
flag that is cleared in unquiesce? then the callers can just continue
to iterate but will only wait the rcu grace period once.
