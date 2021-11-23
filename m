Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE07C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 09:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhKWJEb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 04:04:31 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:51070 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbhKWJD4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 04:03:56 -0500
Received: by mail-wm1-f51.google.com with SMTP id 133so18044709wme.0;
        Tue, 23 Nov 2021 01:00:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OnHAzUmYmHyiou7htb9izLcLP4Hb0p+wQ9+wsknUGE4=;
        b=Wk2aivI2/pgwAcOWmnHF354uQNtS4nbYeMfYDQUlVSobQYjZhlQFo/JwMwA1c5O0LS
         XHkepVpNkoIuHjaSlCeRsa5LqS06BEvbmBL+QomWP5Kb1hMHOEvyVB7GAM6qYtXhNo1f
         y+T89KZ7nfPh3+yDVjnq6uPfVyZsPbGEwdzO7oMIgNZpB8Uc5GbR+WkHfDwwHxZ34UVw
         hXvhVcAEGE4f8m9L0l6FCC4WPKgMZ39/C3EibJZGgw4uaPAmX09mD/qBF2W0Qlr6LT+M
         3z//kf7ZP1KIe1eoSwLCMbWfY38zs07uqTV0SdcMLGSY7QlKflAaMqLlMADXwCBSh7co
         jxhQ==
X-Gm-Message-State: AOAM531+eeygW4c6DhNd9nBH+JwirgxGJxcnHHmpT+3yn2XVCHQDPM60
        PcWbPYUwzi5MewryV2pJnOo=
X-Google-Smtp-Source: ABdhPJwoOdRL+1nkU4Ok1N37YLzlgzH2jXbsbn+xRIeN0SH5D+6MY87SVdPsc1gbpEjJ16zy+tlbjw==
X-Received: by 2002:a05:600c:511c:: with SMTP id o28mr1122946wms.96.1637658047316;
        Tue, 23 Nov 2021 01:00:47 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id g18sm614107wmq.4.2021.11.23.01.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 01:00:46 -0800 (PST)
Subject: Re: [PATCH 3/5] blk-mq: add helper of blk_mq_global_quiesce_wait()
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-4-ming.lei@redhat.com>
 <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me> <YZuagPbZJ6CjiUNi@T590>
 <38b9661e-c5b8-ae18-f2ab-b30f9d3e7115@grimberg.me> <YZwzEBtFug6JEmMZ@T590>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a3ea006a-738b-af69-4dd5-f33444e3559d@grimberg.me>
Date:   Tue, 23 Nov 2021 11:00:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZwzEBtFug6JEmMZ@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>>>> Add helper of blk_mq_global_quiesce_wait() for supporting to quiesce
>>>>> queues in parallel, then we can just wait once if global quiesce wait
>>>>> is allowed.
>>>>
>>>> blk_mq_global_quiesce_wait() is a poor name... global is scope-less and
>>>> obviously it has a scope.
>>>
>>> How about blk_mq_shared_quiesce_wait()? or any suggestion?
>>
>> Shared between what?
> 
> All request queues in one host-wide, both scsi and nvme has such
> requirement.
> 
>>
>> Maybe if the queue has a non-blocking tagset, it can have a "quiesced"
>> flag that is cleared in unquiesce? then the callers can just continue
>> to iterate but will only wait the rcu grace period once.
> 
> Yeah, that is what these patches try to implement.

I was suggesting to "hide" it in the interface.
Maybe something like:
--
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8799fa73ef34..627b631db1f9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -263,14 +263,18 @@ void blk_mq_wait_quiesce_done(struct request_queue *q)
         unsigned int i;
         bool rcu = false;

+       if (!q->has_srcu && q->quiesced)
+               return;
         queue_for_each_hw_ctx(q, hctx, i) {
                 if (hctx->flags & BLK_MQ_F_BLOCKING)
                         synchronize_srcu(hctx->srcu);
                 else
                         rcu = true;
         }
-       if (rcu)
+       if (rcu) {
                 synchronize_rcu();
+               q->quiesced = true;
+       }
  }
  EXPORT_SYMBOL_GPL(blk_mq_wait_quiesce_done);

@@ -308,6 +312,7 @@ void blk_mq_unquiesce_queue(struct request_queue *q)
         } else if (!--q->quiesce_depth) {
                 blk_queue_flag_clear(QUEUE_FLAG_QUIESCED, q);
                 run_queue = true;
+               q->quiesced = false;
         }
         spin_unlock_irqrestore(&q->queue_lock, flags);
--
