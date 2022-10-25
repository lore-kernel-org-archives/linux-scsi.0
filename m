Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0277C38A2D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 14:26:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbiJYO0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 10:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbiJYO0C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 10:26:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300E3BD674
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 07:26:00 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so1363560pjh.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 07:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y1A0KinkqJZXtWc3dy8dV7laoDmD4Squ4QKOY43J8ng=;
        b=xUMCAlnR4XuvMILi6XmutYRtljYg02457nRtLmvx2A+0aFb0YQkKh8YfGvPAoHf0+P
         5Oo6SqzVv9eUx4wVJnu49TfX+gvkEFflu3R3snxw/93wGYTjmY+Q663a55WeddgabKdu
         TCjUjPg1tzXLfoKJNKgS4CISdJzH7KKTbvPwjw0TKrkKtb61La4e1QMC6c7JzxL2pTSw
         dIxVDIsn8rbIVCcLMwfxj7BPYaXsxDsy5j25MXoS8mecJonOGwzAl8uXVxwuEHatnSCk
         dTbX8xkdm2iPMku/+oAcphsLdwRC20XZ4lGzSc5SMgLRoS5kKXmAd39Eayz2HSrqxaX9
         LJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y1A0KinkqJZXtWc3dy8dV7laoDmD4Squ4QKOY43J8ng=;
        b=y3eaLBcqiSaDPFhJYMsO9WHM6S5KDSnMQ+zlZuKZMoz/0S9Ps0sQEIqizkZ41Ya4rB
         PDuhHI47J/Osovh4TrlpH9e5OCXCa6CTh+ZJlQ/IzM6li5zU1oBl4LsyBp98cLddEzKG
         /7aMTWKULKlt7DkTM9vAmJaF09NFmTwSJOyuSC9lr8jqwMq6wfnz2284UTWYVfpbEKob
         bTljHnb3FYoQW1xxLRAAYKzI1NdnxcgihiM1Hc3hoSVtvoeB444GJP9YnX/upuGwMKj+
         7hES7/dZTtG4yUYHvq0T9FOK9Tzhl220ETb+zvKEt+EDHm2TBcEjftNz96osKdr8norR
         s5Ig==
X-Gm-Message-State: ACrzQf0e8/Opi0il+V9FoGb8oBXGflZy/o2vk+mnkLsq5pwCLjYIHN4k
        PVbmLgNRj/NPpVJJOoAEuCp8Fw==
X-Google-Smtp-Source: AMsMyM5D8UaatM+carGEAks6HckRgLt6KP4qSesCxzY7evMPtiIz7wRcG4NASMf1Gn2JCZMhYBMHtA==
X-Received: by 2002:a17:902:b417:b0:181:d0e4:3310 with SMTP id x23-20020a170902b41700b00181d0e43310mr39010074plr.134.1666707960022;
        Tue, 25 Oct 2022 07:26:00 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709027ec100b00185480a85f1sm1261456plb.285.2022.10.25.07.25.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 07:25:59 -0700 (PDT)
Message-ID: <7e9c2c88-2fe4-d48e-dabf-3fa345bcc8e6@kernel.dk>
Date:   Tue, 25 Oct 2022 08:25:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH 1/4] blk-mq: move the call to blk_put_queue out of
 blk_mq_destroy_queue
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
References: <20221018135720.670094-1-hch@lst.de>
 <20221018135720.670094-2-hch@lst.de>
 <2baca1bc-cee0-9a52-3fcd-bdb812e5f512@kernel.dk>
In-Reply-To: <2baca1bc-cee0-9a52-3fcd-bdb812e5f512@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/22 8:23 AM, Jens Axboe wrote:
>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
>> index 059737c1a2c19..07381673170b9 100644
>> --- a/drivers/nvme/host/core.c
>> +++ b/drivers/nvme/host/core.c
>> @@ -4847,6 +4847,7 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
>>  
>>  out_cleanup_admin_q:
>>  	blk_mq_destroy_queue(ctrl->fabrics_q);
>> +	blk_put_queue(ctrl->fabrics_q);
>>  out_free_tagset:
>>  	blk_mq_free_tag_set(ctrl->admin_tagset);
>>  	return ret;
> This is wrong and doesn't apply because it got fixed upstream:
> 
> commit 4739824e2d7878dcea88397a6758e31e3c5c124e
> Author: Dan Carpenter <error27@gmail.com>
> Date:   Sat Oct 15 11:25:56 2022 +0300
> 
>     nvme: fix error pointer dereference in error handling
> 
> Can you respin this series so we can get it applied?

I just made the trivial edit in the patch itself, rest was
fine.

-- 
Jens Axboe


