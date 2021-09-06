Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DB8C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 22:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C85561057
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 22:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhIFWpS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 18:45:18 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:35716 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhIFWpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 18:45:17 -0400
Received: by mail-pj1-f45.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so309703pjb.0;
        Mon, 06 Sep 2021 15:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=v4nWbmM7r53yOQPSscHeKEA0/fBVH7rpaQnNEXPie98=;
        b=BQKtzWpyv0blX2+2vXU/TQHbrdUudXOKVvtC6oF6TRhGvAovzJNdi+2nGaYMkfponi
         SU41M6NFZxWwFSkkZSSg1obefJCAIB0hK5L3hlgIJBJ3Rm6zs8SHCs4hDAZQhcpn4Kv6
         PR2xlcrbWRsXNeL+Me6lZgb/hOv4IQLjxxk9gGTUxn/a/zzv2JmJcBLFkEALM2kwSagL
         wsuWwwnO/Q0JiiOwN8XvnLxv1iVTNECUPejMCJyAlTdI3fvQAFMnXIpZCh5DpKN5+XEd
         waG/EVlhYzP6RphjfAphEXQjuRjj8UIDvObeKRlkTha8iVWQ5k9DAWixp2DB9eeTaidU
         ZVNw==
X-Gm-Message-State: AOAM532IFJcym/6OooqMbxLZbCNQjvfIpn59ucmzY/e8TTwLDft4+TSN
        0NynMJ+boKOunINgI/nCVbQ=
X-Google-Smtp-Source: ABdhPJxkHENrhDo4m4JIpNYyst+4ckS6utzwPT4NwBGt0mpGYOECfulztmB8KvcXA9/MyIh2kMm2Kw==
X-Received: by 2002:a17:90a:a389:: with SMTP id x9mr1206002pjp.167.1630968251832;
        Mon, 06 Sep 2021 15:44:11 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:6d38:bd0e:234b:803? ([2601:647:4000:d7:6d38:bd0e:234b:803])
        by smtp.gmail.com with UTF8SMTPSA id u65sm8416236pfb.199.2021.09.06.15.44.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 15:44:10 -0700 (PDT)
Message-ID: <5bf71295-b729-2ec7-3913-afad3c5d2ef7@acm.org>
Date:   Mon, 6 Sep 2021 15:44:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.1
Subject: Re: [PATCH] blk-mq: avoid to iterate over stale request
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        luojiaxing <luojiaxing@huawei.com>
References: <20210906065003.439019-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20210906065003.439019-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/5/21 23:50, Ming Lei wrote:
> -	if (!rq || !refcount_inc_not_zero(&rq->ref))
> +	if (!rq || rq->tag != bitnr || !refcount_inc_not_zero(&rq->ref))
>   		rq = NULL;

Shouldn't the rq->tag != bitnr test happen after the refcount has been 
incremented since otherwise rq->tag can change after it has been read 
and before the refcount is incremented?

Thanks,

Bart.
