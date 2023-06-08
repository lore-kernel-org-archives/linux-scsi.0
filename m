Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B2DAC7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 14:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbjFHOM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jun 2023 10:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236602AbjFHOM5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2023 10:12:57 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DF72D4A;
        Thu,  8 Jun 2023 07:12:56 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1b0218c979cso3115075ad.3;
        Thu, 08 Jun 2023 07:12:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686233576; x=1688825576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5WSQm3jsV2ylI50jn9FwejTu48YKDnkoB8Ab6okVFqA=;
        b=kfOsdrsCZtMrR7J+wzkbJfkG1ENPweAEJtlbKYFMeYTPBJOys+SZsH9ERwKJiFA9kq
         9Mh4KQnDiy/V4SsAfQtd8pyjar6VVzQ6RvqEl0+h7tmJ24GpHM0ssc7jekGyQ7P8FzKN
         zQIx3fqBoUAS5CTeBhwADIE2b9TGdvWOwEGKHiDDa2WOolhRNfOXQDunnwpp/CzrdvSs
         gT04FowBQBA1PNWJ8d6o+Cpimt5c5cfX5qwMSXxskrSxARZ9WHPUQJ0juWMUKfYONngq
         AvuBal1amdvzwG6NRLmx9mXf/3HB9+KInD6jyh6hPLZcRNXJEC8Gl/On6WZDlB7XPOmG
         zGsA==
X-Gm-Message-State: AC+VfDyfK3yL7mT/f9TrX1XkltspquQITSbthUAG7qBqm7WXLcKNhe+C
        woQRywMcOpK/KEq6aLA3tkY=
X-Google-Smtp-Source: ACHHUZ409pm2xluQ0vboILMC88Ey4KLB3NfQriKWaZE7INXLY1h6NDQ6wWfT0l+Xc2k4vQejy5/7jg==
X-Received: by 2002:a17:902:da8b:b0:1b2:28ca:d30 with SMTP id j11-20020a170902da8b00b001b228ca0d30mr7436474plx.10.1686233575677;
        Thu, 08 Jun 2023 07:12:55 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id d7-20020a170902854700b001b00e0ab7b3sm1503456plo.50.2023.06.08.07.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 07:12:55 -0700 (PDT)
Message-ID: <5be7eebb-f734-1a0a-9f97-1b3534bc26ac@acm.org>
Date:   Thu, 8 Jun 2023 07:12:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 4/8] scsi: call scsi_stop_queue() without state_mutex
 held
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Martin Wilck <mwilck@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230607182249.22623-1-mwilck@suse.com>
 <20230607182249.22623-5-mwilck@suse.com>
 <3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org>
 <50cb1a5bd501721d7c816b1ca8bf560daa8e3cc9.camel@suse.com>
 <ff669f59e3c42e5dec4920d705e2b8748ad600d5.camel@suse.com>
 <20230608054444.GB11554@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230608054444.GB11554@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/23 22:44, Christoph Hellwig wrote:
>>> Thanks. This wasn't obvious to me from the current code. I'll add a
>>> comment in the next version.
>>
>> The crucial question is now, is it sufficient to call
>> blk_mq_quiesce_queue_nowait() under the mutex, or does the call to
>> blk_mq_wait_quiesce_done() have to be under the mutex, too?
>> The latter would actually kill off our attempt to fix the delay
>> in fc_remote_port_delete() that was caused by repeated
>> synchronize_rcu() calls.
>>
>> But if I understand you correctly, moving the wait out of the mutex
>> should be ok. I'll update the series accordingly.
> 
> I can't think of a reason we'd want to lock over the wait, but Bart
> knows this code way better than I do.

Unless deep changes would be made in the block layer 
blk_mq_quiesce_queue_nowait() and/or blk_mq_wait_quiesce_done() 
functions, moving blk_mq_wait_quiesce_done() outside the critical 
section seems fine to me.

Thanks,

Bart.
