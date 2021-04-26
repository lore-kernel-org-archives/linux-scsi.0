Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF5AC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 01:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED822611F0
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 01:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhDZB6G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 21:58:06 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:44567 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhDZB6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 21:58:05 -0400
Received: by mail-pl1-f173.google.com with SMTP id y1so12431347plg.11;
        Sun, 25 Apr 2021 18:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6HEg/Ddsftly7/3yRUEs2qLA5+xUFCZApQad+9OPs/Y=;
        b=dgTfbANYAETMhHte/tVV0jgbszjbSsOhB/vzJUYELcOM1WQSk5rlGR9Zns8NauyMM/
         KAe+NTMIFxnNNfNQ1URvdPC2DrhYP665U2903sB1799PqKLvotmjaCnWuT2B/SNfMilb
         KRl62kZAfHL1pF63WDdmcH2imMEfVB0TTK6mceNDlP883MDG1LSSGMx2T1+GtAkiasgd
         Fae7kII+hzY8g1DTLhAGafiE20M+gqPJdDdQMqg7+WVCqXeFHloL0bhXjYmKkeA+w73b
         gOPvA+I9fEHpEVNbWqScNsd3f0jkUmkfZkSNmfDCa6LFgp5CiP5HlnhWquwOg2cnfsNx
         Tlvg==
X-Gm-Message-State: AOAM532OURgxh02Rh+UNrnXHGks8xO6Byhx37J+vYrajlpF9OdCSnv5e
        XGSrYk+QzbMprht+zCRUUGU=
X-Google-Smtp-Source: ABdhPJyZilykJIV4HMDyE83hi7h3BZxEs7dCPfJYWuizazoZ0MILumlUOVaQeM72OAnEpff7bvNQag==
X-Received: by 2002:a17:90a:cf8d:: with SMTP id i13mr11564066pju.53.1619402244598;
        Sun, 25 Apr 2021 18:57:24 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b21sm10719230pji.39.2021.04.25.18.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 18:57:23 -0700 (PDT)
Subject: Re: [PATCH 0/8] blk-mq: fix request UAF related with iterating over
 tagset requests
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <YIU2BhuYZAAgonN0@T590> <5c1ef3ec-dd6a-4992-586b-6e67bcd1a678@acm.org>
 <YIYVMQmAZgKL2qdP@T590>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <56ae9ca8-4e17-0d82-8ff2-08973e1f4693@acm.org>
Date:   Sun, 25 Apr 2021 18:57:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIYVMQmAZgKL2qdP@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/21 6:19 PM, Ming Lei wrote:
> On Sun, Apr 25, 2021 at 01:53:16PM -0700, Bart Van Assche wrote:
>> On 4/25/21 2:27 AM, Ming Lei wrote:
>>> 4) synchronize_rcu() is added before shutting down one request queue,
>>> which may slow down reboot/poweroff very much on big systems with lots of
>>> HBAs in which lots of LUNs are attached.
>>
>> The synchronize_rcu() can be removed by using a semaphore
>> (<linux/semaphore.h>) instead of an RCU reader lock inside bt_tags_iter().
> 
> I am not sure you can, because some iteration is done in atomic context.

I meant <linux/rwlock.h>. The functions like read_lock_irq() that are
declared in that header file are appropriate for atomic context.

Bart.
