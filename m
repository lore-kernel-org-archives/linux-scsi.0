Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65491C001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 08:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjGMIn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbjGMInh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 04:43:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E32A1FEA;
        Thu, 13 Jul 2023 01:41:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1A79E2218F;
        Thu, 13 Jul 2023 08:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1689237700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1KgJ9b4cdiZIcEXMAwDsegI3Npa1Ik9C7lO9ptGTJ5I=;
        b=H6/jDACyxdlBd8hsPY4LydrTExUUQmFg7zRPTH79GCqgTqg6+RmFH7WkPcSeo382hchjUl
        CiElvvDRsVoSb6nCtZbPOEWTVxNJloAx6j2gJaZJIBx9zcdItz+9cSKEAguG3AKzQTgFw4
        SgyOGtr1OnTIa9r+ozHm5GFKcmhW5lU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1689237700;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1KgJ9b4cdiZIcEXMAwDsegI3Npa1Ik9C7lO9ptGTJ5I=;
        b=OGz/jjPNyVaIDuxQ9Oh254HyyphEpByzhRttLXj/+/Or2a9uoEosAr/G9ao0GVEJ9HD+CD
        OPbfsqB7ZHu2OSCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0C6CA13489;
        Thu, 13 Jul 2023 08:41:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1COjAsS4r2SHNQAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 13 Jul 2023 08:41:40 +0000
Message-ID: <142962ad-55fc-d193-de7a-949f290d3fdf@suse.de>
Date:   Thu, 13 Jul 2023 10:41:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: blktests failures with v6.4
To:     Sagi Grimberg <sagi@grimberg.me>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <lkmloyrqpebispffur5udxdiubmevvodtsvnap3jz7tv5ihstr@jg7ejye3bein>
 <165eceaa-55d4-f9c7-7e02-18115e6df6fe@grimberg.me>
 <v3n4k4gk5uhbuh6ijl2pwaysvxzidzhrmjejourfnmobebwbzi@hejuqcryp4nc>
 <152f0684-4bcd-699f-e0e3-40189be4b80a@grimberg.me>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <152f0684-4bcd-699f-e0e3-40189be4b80a@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/23 09:48, Sagi Grimberg wrote:
> 
>>>> #3: nvme/003 (fabrics transport)
>>>>
>>>>      When nvme test group is run with trtype=rdma or tcp, the test 
>>>> case fails
>>>>      due to lockdep WARNING "possible circular locking dependency 
>>>> detected".
>>>>      Reported in May/2023. Bart suggested a fix for trytpe=rdma [4] 
>>>> but it
>>>>      needs more discussion.
>>>>
>>>>      [4] 
>>>> https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvanassche@acm.org/
>>>
>>> This patch is unfortunately incorrect and buggy.
>>>
>>> This will likely make the issue go away, but adds another
>>> old issue where a client can DDOS a target by bombarding it
>>> with connect/disconnect. When releases are async and we don't
>>> have any back-pressure, it is likely to happen.
>>> -- 
>>> diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
>>> index 4597bca43a6d..8b4f4aa48206 100644
>>> --- a/drivers/nvme/target/rdma.c
>>> +++ b/drivers/nvme/target/rdma.c
>>> @@ -1582,11 +1582,6 @@ static int nvmet_rdma_queue_connect(struct 
>>> rdma_cm_id
>>> *cm_id,
>>>                  goto put_device;
>>>          }
>>>
>>> -       if (queue->host_qid == 0) {
>>> -               /* Let inflight controller teardown complete */
>>> -               flush_workqueue(nvmet_wq);
>>> -       }
>>> -
>>>          ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
>>>          if (ret) {
>>>                  /*
>>> diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
>>> index 868aa4de2e4c..c8cfa19e11c7 100644
>>> --- a/drivers/nvme/target/tcp.c
>>> +++ b/drivers/nvme/target/tcp.c
>>> @@ -1844,11 +1844,6 @@ static u16 nvmet_tcp_install_queue(struct 
>>> nvmet_sq
>>> *sq)
>>>          struct nvmet_tcp_queue *queue =
>>>                  container_of(sq, struct nvmet_tcp_queue, nvme_sq);
>>>
>>> -       if (sq->qid == 0) {
>>> -               /* Let inflight controller teardown complete */
>>> -               flush_workqueue(nvmet_wq);
>>> -       }
>>> -
>>>          queue->nr_cmds = sq->size * 2;
>>>          if (nvmet_tcp_alloc_cmds(queue))
>>>                  return NVME_SC_INTERNAL;
>>> -- 
>>
>> Thanks Sagi, I tried the patch above and confirmed the lockdep WARN 
>> disappears
>> for both rdma and tcp. It indicates that the flush_workqueue(nvmet_wq)
>> introduced the circular lock dependency.
> 
> Thanks for confirming. This was expected.
> 
>> I also found the two commits below
>> record why the flush_workqueue(nvmet_wq) was introduced.
>>
>>   777dc82395de ("nvmet-rdma: occasionally flush ongoing controller 
>> teardown")
>>   8832cf922151 ("nvmet: use a private workqueue instead of the system 
>> workqueue")
> 
> The second patch is unrelated, before we used a global workqueue and
> fundamentally had the same issue.
> 
>> The left question is how to avoid both the connect/disconnect 
>> bombarding DDOS
>> and the circular lock possibility related to the nvmet_wq completion.
> 
> I don't see any way to synchronize connects with releases without moving 
> connect sequences to a dedicated thread. Which in my mind is undesirable.
> 
> The only solution I can think of is to fail a host connect expecting the
> host to reconnect and throttle this way, but that would lead to spurious
> connect failures (at least from the host PoV).
> 
> Maybe we can add a NOT_READY connect error code in nvme for that...
> 
You know, I have been seeing the very same lockdep warning during TLS 
testing; wasn't sure, though, if it's a generic issue or something I've 
introduced with the TLS logic.

I guess we can solve this by adding another NVMET_TCP_Q_INIT state 
before NVMET_TCP_Q_CONNECTING; then we can flip the state from INIT to 
CONNECTING in nvmet_tcp_alloc_queue():

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index ed98df72c76b..e6f699a44128 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -121,6 +121,7 @@ struct nvmet_tcp_cmd {
  };

  enum nvmet_tcp_queue_state {
+       NVMET_TCP_Q_INIT,
         NVMET_TCP_Q_CONNECTING,
         NVMET_TCP_Q_LIVE,
         NVMET_TCP_Q_DISCONNECTING,
@@ -1274,7 +1275,8 @@ static int nvmet_tcp_try_recv(struct 
nvmet_tcp_queue *queue,
  static void nvmet_tcp_schedule_release_queue(struct nvmet_tcp_queue 
*queue)
  {
         spin_lock(&queue->state_lock);
-       if (queue->state != NVMET_TCP_Q_DISCONNECTING) {
+       if (queue->state != NVMET_TCP_Q_INIT &&
+           queue->state != NVMET_TCP_Q_DISCONNECTING) {
                 queue->state = NVMET_TCP_Q_DISCONNECTING;
                 queue_work(nvmet_wq, &queue->release_work);
         }
@@ -1625,7 +1627,7 @@ static int nvmet_tcp_alloc_queue(struct 
nvmet_tcp_port *port,
         queue->port = port;
         queue->nr_cmds = 0;
         spin_lock_init(&queue->state_lock);
-       queue->state = NVMET_TCP_Q_CONNECTING;
+       queue->state = NVMET_TCP_Q_INIT;
         INIT_LIST_HEAD(&queue->free_list);
         init_llist_head(&queue->resp_list);
         INIT_LIST_HEAD(&queue->resp_send_list);
@@ -1832,10 +1834,12 @@ static u16 nvmet_tcp_install_queue(struct 
nvmet_sq *sq)
         struct nvmet_tcp_queue *queue =
                 container_of(sq, struct nvmet_tcp_queue, nvme_sq);

-       if (sq->qid == 0) {
-               /* Let inflight controller teardown complete */
-               flush_workqueue(nvmet_wq);
+       spin_lock(&queue->state_lock);
+       if (queue->state != NVMET_TCP_Q_INIT) {
+               spin_unlock(&queue->state_lock);
+               return NVME_SC_NOT_READY;
         }
+       spin_unlock(&queue->state_lock);

         queue->nr_cmds = sq->size * 2;
         if (nvmet_tcp_alloc_cmds(queue))

With that we'll return 'not ready' whenever we hit this condition, but 
that should be fine as we would've crashed anyway with the old code.

Hmm?

Cheers,

Hannes
