Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 567C3C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 07:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjGMHsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 03:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbjGMHsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 03:48:18 -0400
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1544410FA;
        Thu, 13 Jul 2023 00:48:16 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-4fb87828386so124423e87.1;
        Thu, 13 Jul 2023 00:48:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689234494; x=1689839294;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T/j6txsL1LAa6TqQUQIjj+sTK0ZG/oC531uOufNfwD4=;
        b=ANdAhHaG+4JeezYe/0YkVsQXCGiKHIDo6shWAaKniXSizYQlegHRpwONn8pdUa35pr
         Unua2qXiNnh5Iduf0fhVfe4u8V+gPxmb8I9+4yiSKKwewnm4C4VzQFXPSmsIpzLhGxCH
         D7s9Oj4Ly8HJYCpqNFAr8xkszwEqfmnBaiFGYFKdD5IlE+JvhN7deoBKw9vXessMsgDm
         W8dSNjv2c5bbl2AwkfkwC8VuhMRfolSOBQrysr9ie9Hj/ZrVGG+ReH0lphXO41pm+/eZ
         r26q/4LPIIfZht52fwscP/G/IK6o1x7mLyrsSQZkxLY45tMaD4IRx0fNkxTofFwIP8eA
         DozQ==
X-Gm-Message-State: ABy/qLY0joH5Xzb8UvevIi3GjiK7Zuf0M1fai9P9VtzjLWHF2Ow3nrPG
        SwaOS+cDKryMg5sWYyLWZDYspucWcLs=
X-Google-Smtp-Source: APBJJlGH1XfNfN6Hk9YPZpTfnIc4LqK5nsPIdkMxQMMseZTRHRkODL5rjNptHgOb5BBKC0kZLzxyZQ==
X-Received: by 2002:a05:651c:1ce:b0:2b6:a662:b879 with SMTP id d14-20020a05651c01ce00b002b6a662b879mr649292ljn.3.1689234494025;
        Thu, 13 Jul 2023 00:48:14 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c281100b003fbca05faa9sm7019740wmb.24.2023.07.13.00.48.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 00:48:13 -0700 (PDT)
Message-ID: <152f0684-4bcd-699f-e0e3-40189be4b80a@grimberg.me>
Date:   Thu, 13 Jul 2023 10:48:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: blktests failures with v6.4
Content-Language: en-US
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <lkmloyrqpebispffur5udxdiubmevvodtsvnap3jz7tv5ihstr@jg7ejye3bein>
 <165eceaa-55d4-f9c7-7e02-18115e6df6fe@grimberg.me>
 <v3n4k4gk5uhbuh6ijl2pwaysvxzidzhrmjejourfnmobebwbzi@hejuqcryp4nc>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <v3n4k4gk5uhbuh6ijl2pwaysvxzidzhrmjejourfnmobebwbzi@hejuqcryp4nc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>> #3: nvme/003 (fabrics transport)
>>>
>>>      When nvme test group is run with trtype=rdma or tcp, the test case fails
>>>      due to lockdep WARNING "possible circular locking dependency detected".
>>>      Reported in May/2023. Bart suggested a fix for trytpe=rdma [4] but it
>>>      needs more discussion.
>>>
>>>      [4] https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvanassche@acm.org/
>>
>> This patch is unfortunately incorrect and buggy.
>>
>> This will likely make the issue go away, but adds another
>> old issue where a client can DDOS a target by bombarding it
>> with connect/disconnect. When releases are async and we don't
>> have any back-pressure, it is likely to happen.
>> --
>> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
>> index 4597bca43a6d..8b4f4aa48206 100644
>> --- a/drivers/nvme/target/rdma.c
>> +++ b/drivers/nvme/target/rdma.c
>> @@ -1582,11 +1582,6 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id
>> *cm_id,
>>                  goto put_device;
>>          }
>>
>> -       if (queue->host_qid == 0) {
>> -               /* Let inflight controller teardown complete */
>> -               flush_workqueue(nvmet_wq);
>> -       }
>> -
>>          ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
>>          if (ret) {
>>                  /*
>> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
>> index 868aa4de2e4c..c8cfa19e11c7 100644
>> --- a/drivers/nvme/target/tcp.c
>> +++ b/drivers/nvme/target/tcp.c
>> @@ -1844,11 +1844,6 @@ static u16 nvmet_tcp_install_queue(struct nvmet_sq
>> *sq)
>>          struct nvmet_tcp_queue *queue =
>>                  container_of(sq, struct nvmet_tcp_queue, nvme_sq);
>>
>> -       if (sq->qid == 0) {
>> -               /* Let inflight controller teardown complete */
>> -               flush_workqueue(nvmet_wq);
>> -       }
>> -
>>          queue->nr_cmds = sq->size * 2;
>>          if (nvmet_tcp_alloc_cmds(queue))
>>                  return NVME_SC_INTERNAL;
>> --
> 
> Thanks Sagi, I tried the patch above and confirmed the lockdep WARN disappears
> for both rdma and tcp. It indicates that the flush_workqueue(nvmet_wq)
> introduced the circular lock dependency.

Thanks for confirming. This was expected.

> I also found the two commits below
> record why the flush_workqueue(nvmet_wq) was introduced.
> 
>   777dc82395de ("nvmet-rdma: occasionally flush ongoing controller teardown")
>   8832cf922151 ("nvmet: use a private workqueue instead of the system workqueue")

The second patch is unrelated, before we used a global workqueue and
fundamentally had the same issue.

> The left question is how to avoid both the connect/disconnect bombarding DDOS
> and the circular lock possibility related to the nvmet_wq completion.

I don't see any way to synchronize connects with releases without moving 
connect sequences to a dedicated thread. Which in my mind is undesirable.

The only solution I can think of is to fail a host connect expecting the
host to reconnect and throttle this way, but that would lead to spurious
connect failures (at least from the host PoV).

Maybe we can add a NOT_READY connect error code in nvme for that...

