Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EA7C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 20:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243089AbiBWUEg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 15:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233174AbiBWUEf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 15:04:35 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF13A3EA98;
        Wed, 23 Feb 2022 12:04:06 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id w2so4187600pfu.11;
        Wed, 23 Feb 2022 12:04:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7DoUFNNhoGzk6ehqwEzXgPKmAy7XslVFFB8HpLekwkU=;
        b=AiZk4CSCmJHWOVGUNB6EXQTVHfAKNbvB/8Gj1/trEH9RZZgqLeWszo0p4/ItlokBqe
         BCabvQ3ePQ3I2KxVtkq8Tym0SPwV8VnA5fWb+h150Q4H15pSP5RiVOAPmGHhbLs0XVKU
         4sACHgAY8OqInWJfceCYYIG/IQ3eZ0AXFS1VqF/TSeECAtIhTklQefqaYYM6Ss8VCjkp
         Ak9scJUZoIOOgtizsqTv0BbImDhxRWAEJ3NE8wKALa3rFKy2pAnj0Os81QniURyUIvGk
         lv7omPVzCb8in2hIkL883QXMaUtn0Yoxb6AVvJOsVvAVCi3vdr55lmGYCysC5VA+ymmr
         NS7Q==
X-Gm-Message-State: AOAM530ZQcGmvqJy0WqaJQWkrV4dINvbs2kp/BkevgvZG+jVYdUsUynI
        RwzNUe8iihl4FNn6liXX0yQ=
X-Google-Smtp-Source: ABdhPJwuvUgG5I/9maElA3dJmdu1ppWHjirNniVvVt/EeEo/VmTZ8YY+ZACEA9e+s9imMym2LE0M4A==
X-Received: by 2002:a05:6a00:2296:b0:4e1:3029:ee2 with SMTP id f22-20020a056a00229600b004e130290ee2mr1412121pfe.22.1645646646081;
        Wed, 23 Feb 2022 12:04:06 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id go1-20020a17090b03c100b001bcb5ef0597sm399760pjb.55.2022.02.23.12.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 12:04:05 -0800 (PST)
Message-ID: <d2cbbf56-6984-fc54-9eb4-2142a69c379a@acm.org>
Date:   Wed, 23 Feb 2022 12:04:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 10/12] block: move blk_exit_queue into disk_release
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20220222141450.591193-1-hch@lst.de>
 <20220222141450.591193-11-hch@lst.de>
 <4b9a4121-7f37-9bd3-036a-51892a456eef@acm.org> <YhXapc7fuhb8mlwW@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YhXapc7fuhb8mlwW@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 22:56, Ming Lei wrote:
> But I admit here the name of blk_mq_release_queue() is very misleading,
> maybe blk_mq_release_io_queue() is better?

I'm not sure what the best name for that function would be. Anyway, 
thanks for having clarified that disk structures are removed before the 
request queue is cleaned up. That's something I was missing.

Bart.
