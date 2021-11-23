Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D1BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 08:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234136AbhKWI5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 03:57:42 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:35450 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbhKWI5k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 03:57:40 -0500
Received: by mail-wm1-f49.google.com with SMTP id 77-20020a1c0450000000b0033123de3425so1545909wme.0;
        Tue, 23 Nov 2021 00:54:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HFaINRL63IBNxp0Soii4v8PCGz3DCo3roLnsnw7uKlA=;
        b=upPbHUnFR8l9OUeP0SZKyJNEN1YUFQD3DtFytaBUqaymwX3sfZYTPEXLSH8DMdISRW
         eG953jTsu4t5oDQCw+2zYXEv+5ntJgCVbxXZdpCL12QtU2+sCOdN00talSum+EjEdypx
         FTwPS98+Be7UKs/apFcl/uk5kDzxkH5DLtu9u6tGdTHhhVZA2+I28lYDpb6uA4DyHAKG
         juLs+kvqna6gdtmGNCn4CpXeDSJ72ZjmADW4Q/cEgCvWpntYzzTkCYRkJTLqu7WZ4Syn
         9hn0GmbGDOKAUR1UTCW++W4Z+nskxSidCu7cAtrhGiEdyjjCEWFW3mznONWpe8jJPshA
         LE2Q==
X-Gm-Message-State: AOAM532dh9Rtj5wSDDX4TQXKj6BTdaj1H73zCgqaYPd4bth3os9Bew6X
        9N+H0L2hR02J+MQiEN3v4Hw=
X-Google-Smtp-Source: ABdhPJyFhDboZZAHwP1dMbmtQqaChktGrhfT/J1/+HcY10WP1jFZw9WdsEvIFetkr1Av3CMZx1G3gw==
X-Received: by 2002:a1c:7c19:: with SMTP id x25mr1081278wmc.42.1637657672093;
        Tue, 23 Nov 2021 00:54:32 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id m36sm479864wms.25.2021.11.23.00.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 00:54:31 -0800 (PST)
Subject: Re: [PATCH 2/5] blk-mq: rename hctx_lock & hctx_unlock
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-3-ming.lei@redhat.com>
 <ed13ee7f-a017-874a-cd28-e40b3aa6b4a7@grimberg.me> <YZuZCsCIyQrc+539@T590>
 <737e0543-9b7b-4872-082c-9ea51069d57f@grimberg.me> <YZww/1iBDbou1yQY@T590>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <c10b2729-d0ca-5705-5149-828dd269f191@grimberg.me>
Date:   Tue, 23 Nov 2021 10:54:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZww/1iBDbou1yQY@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Then look at q->has_srcu that Bart suggested?
> 
> Bart just suggested to rename q->alloc_srcu as q->has_srcu.

Yea, is there a problem using that instead of having callers
pass a flag?
