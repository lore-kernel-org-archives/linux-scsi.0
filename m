Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248BAEB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 10:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjGMKRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 06:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234074AbjGMKRE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 06:17:04 -0400
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810552D4E;
        Thu, 13 Jul 2023 03:16:35 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-31422f20399so134667f8f.1;
        Thu, 13 Jul 2023 03:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689243394; x=1691835394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8IQtZOX1Fe8N0zPumP1OlY/T7AiPFD7cpIHP1l3EW0U=;
        b=YnqeXOpdwQ/G016PTNWK6haOVDxfLNeKXJ5Au4O2c0TCKG0+8FPrZGPyXIifEsttcX
         ErErUnF5LfV1eDVuW3jwNWXFrQ58b3Ts97CpGFik/F/pMAfFCNCyP991QKxYTh+7cyu3
         UV5NxxSOJ7v+guCpRPfrmqEHYCy43T3pzCIi+Tbny40MqSPdMWXqE7GzKEaIE5dEHAvE
         KH0PVKGQt5uDSXtnMpcQ3+yJ7ucdC1npKuhH+OzOOZnAQ5Ztx3fHI/oxzPYUG5iliyUO
         xGb4HDnlofGYtF4ChUohwu4ki51eIMUWt6srdjxK7eZBWnRyB/BPfelVbbGjFXT+2QCV
         oH7g==
X-Gm-Message-State: ABy/qLY52maX/WM9LFYi15/wehWYvkBCUh/ByCAy5s8R2nbEq4evrX8C
        SZxL+fYMFHZ+uMhmruaZTYs=
X-Google-Smtp-Source: APBJJlGTjbNxG1CjgpAWLT5wgzTx28sLdkefBC44/Di2EyYSUItbCicuxptPZ4CzTUW9F8Kd7vQvfw==
X-Received: by 2002:a5d:60c8:0:b0:314:1593:9f2 with SMTP id x8-20020a5d60c8000000b00314159309f2mr1149818wrt.4.1689243393795;
        Thu, 13 Jul 2023 03:16:33 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id b16-20020a5d5510000000b0031417b0d338sm7497880wrv.87.2023.07.13.03.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 03:16:33 -0700 (PDT)
Message-ID: <5cb63b10-72ab-4b7c-7574-48583ea8ffd1@grimberg.me>
Date:   Thu, 13 Jul 2023 13:16:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: blktests failures with v6.4
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <lkmloyrqpebispffur5udxdiubmevvodtsvnap3jz7tv5ihstr@jg7ejye3bein>
 <165eceaa-55d4-f9c7-7e02-18115e6df6fe@grimberg.me>
 <v3n4k4gk5uhbuh6ijl2pwaysvxzidzhrmjejourfnmobebwbzi@hejuqcryp4nc>
 <152f0684-4bcd-699f-e0e3-40189be4b80a@grimberg.me>
 <142962ad-55fc-d193-de7a-949f290d3fdf@suse.de>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <142962ad-55fc-d193-de7a-949f290d3fdf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 7/13/23 11:41, Hannes Reinecke wrote:
> On 7/13/23 09:48, Sagi Grimberg wrote:
>>
>>>>> #3: nvme/003 (fabrics transport)
>>>>>
>>>>>      When nvme test group is run with trtype=rdma or tcp, the test 
>>>>> case fails
>>>>>      due to lockdep WARNING "possible circular locking dependency 
>>>>> detected".
>>>>>      Reported in May/2023. Bart suggested a fix for trytpe=rdma [4] 
>>>>> but it
>>>>>      needs more discussion.
>>>>>
>>>>>      [4] 
>>>>> https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvanassche@acm.org/
>>>>
>>>> This patch is unfortunately incorrect and buggy.
>>>>
>>>> This will likely make the issue go away, but adds another
>>>> old issue where a client can DDOS a target by bombarding it
>>>> with connect/disconnect. When releases are async and we don't
>>>> have any back-pressure, it is likely to happen.
>>>> -- 
>>>> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
>>>> index 4597bca43a6d..8b4f4aa48206 100644
>>>> --- a/drivers/nvme/target/rdma.c
>>>> +++ b/drivers/nvme/target/rdma.c
>>>> @@ -1582,11 +1582,6 @@ static int nvmet_rdma_queue_connect(struct 
>>>> rdma_cm_id
>>>> *cm_id,
>>>>                  goto put_device;
>>>>          }
>>>>
>>>> -       if (queue->host_qid == 0) {
>>>> -               /* Let inflight controller teardown complete */
>>>> -               flush_workqueue(nvmet_wq);
>>>> -       }
>>>> -
>>>>          ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
>>>>          if (ret) {
>>>>                  /*
>>>> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
>>>> index 868aa4de2e4c..c8cfa19e11c7 100644
>>>> --- a/drivers/nvme/target/tcp.c
>>>> +++ b/drivers/nvme/target/tcp.c
>>>> @@ -1844,11 +1844,6 @@ static u16 nvmet_tcp_install_queue(struct 
>>>> nvmet_sq
>>>> *sq)
>>>>          struct nvmet_tcp_queue *queue =
>>>>                  container_of(sq, struct nvmet_tcp_queue, nvme_sq);
>>>>
>>>> -       if (sq->qid == 0) {
>>>> -               /* Let inflight controller teardown complete */
>>>> -               flush_workqueue(nvmet_wq);
>>>> -       }
>>>> -
>>>>          queue->nr_cmds = sq->size * 2;
>>>>          if (nvmet_tcp_alloc_cmds(queue))
>>>>                  return NVME_SC_INTERNAL;
>>>> -- 
>>>
>>> Thanks Sagi, I tried the patch above and confirmed the lockdep WARN 
>>> disappears
>>> for both rdma and tcp. It indicates that the flush_workqueue(nvmet_wq)
>>> introduced the circular lock dependency.
>>
>> Thanks for confirming. This was expected.
>>
>>> I also found the two commits below
>>> record why the flush_workqueue(nvmet_wq) was introduced.
>>>
>>>   777dc82395de ("nvmet-rdma: occasionally flush ongoing controller 
>>> teardown")
>>>   8832cf922151 ("nvmet: use a private workqueue instead of the system 
>>> workqueue")
>>
>> The second patch is unrelated, before we used a global workqueue and
>> fundamentally had the same issue.
>>
>>> The left question is how to avoid both the connect/disconnect 
>>> bombarding DDOS
>>> and the circular lock possibility related to the nvmet_wq completion.
>>
>> I don't see any way to synchronize connects with releases without 
>> moving connect sequences to a dedicated thread. Which in my mind is 
>> undesirable.
>>
>> The only solution I can think of is to fail a host connect expecting the
>> host to reconnect and throttle this way, but that would lead to spurious
>> connect failures (at least from the host PoV).
>>
>> Maybe we can add a NOT_READY connect error code in nvme for that...
>>
> You know, I have been seeing the very same lockdep warning during TLS 
> testing; wasn't sure, though, if it's a generic issue or something I've 
> introduced with the TLS logic.
> 
> I guess we can solve this by adding another NVMET_TCP_Q_INIT state 
> before NVMET_TCP_Q_CONNECTING; then we can flip the state from INIT to 
> CONNECTING in nvmet_tcp_alloc_queue():
> 
> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
> index ed98df72c76b..e6f699a44128 100644
> --- a/drivers/nvme/target/tcp.c
> +++ b/drivers/nvme/target/tcp.c
> @@ -121,6 +121,7 @@ struct nvmet_tcp_cmd {
>   };
> 
>   enum nvmet_tcp_queue_state {
> +       NVMET_TCP_Q_INIT,
>          NVMET_TCP_Q_CONNECTING,
>          NVMET_TCP_Q_LIVE,
>          NVMET_TCP_Q_DISCONNECTING,
> @@ -1274,7 +1275,8 @@ static int nvmet_tcp_try_recv(struct 
> nvmet_tcp_queue *queue,
>   static void nvmet_tcp_schedule_release_queue(struct nvmet_tcp_queue 
> *queue)
>   {
>          spin_lock(&queue->state_lock);
> -       if (queue->state != NVMET_TCP_Q_DISCONNECTING) {
> +       if (queue->state != NVMET_TCP_Q_INIT &&
> +           queue->state != NVMET_TCP_Q_DISCONNECTING) {
>                  queue->state = NVMET_TCP_Q_DISCONNECTING;
>                  queue_work(nvmet_wq, &queue->release_work);
>          }
> @@ -1625,7 +1627,7 @@ static int nvmet_tcp_alloc_queue(struct 
> nvmet_tcp_port *port,
>          queue->port = port;
>          queue->nr_cmds = 0;
>          spin_lock_init(&queue->state_lock);
> -       queue->state = NVMET_TCP_Q_CONNECTING;
> +       queue->state = NVMET_TCP_Q_INIT;
>          INIT_LIST_HEAD(&queue->free_list);
>          init_llist_head(&queue->resp_list);
>          INIT_LIST_HEAD(&queue->resp_send_list);
> @@ -1832,10 +1834,12 @@ static u16 nvmet_tcp_install_queue(struct 
> nvmet_sq *sq)
>          struct nvmet_tcp_queue *queue =
>                  container_of(sq, struct nvmet_tcp_queue, nvme_sq);
> 
> -       if (sq->qid == 0) {
> -               /* Let inflight controller teardown complete */
> -               flush_workqueue(nvmet_wq);
> +       spin_lock(&queue->state_lock);
> +       if (queue->state != NVMET_TCP_Q_INIT) {
> +               spin_unlock(&queue->state_lock);
> +               return NVME_SC_NOT_READY;
>          }
> +       spin_unlock(&queue->state_lock);
> 
>          queue->nr_cmds = sq->size * 2;
>          if (nvmet_tcp_alloc_cmds(queue))
> 
> With that we'll return 'not ready' whenever we hit this condition, but 
> that should be fine as we would've crashed anyway with the old code.
> 
> Hmm?

I don't understand what this patch is doing... Nor how it solves
anything.
