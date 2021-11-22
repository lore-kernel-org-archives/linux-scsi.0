Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75CAC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 07:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhKVHvp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 02:51:45 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:35653 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbhKVHvo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 02:51:44 -0500
Received: by mail-wr1-f50.google.com with SMTP id i5so31006176wrb.2;
        Sun, 21 Nov 2021 23:48:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C4zT3ReMn99MOdO3ezzDw+pZFjCzqehx4f/GcytHtJ8=;
        b=dIzKiIC6B3cPXS6oXNfJLpJwjW0Sn3v566RLNZU1b7JjCmqbgH8r99tMCmM9a8hc2L
         vgTw281jewzowZHY61mP7stONCnd33zqk7OZQc8Vi3GZ4mySfJDBM5To2Os3Cno6Kd+6
         EfeJ+4FyVgaCEMMuNJ3CrUOwbX00EWwffEJBkOABDrthjnEx+yTKNHGMAsMeK8QaK1/7
         Liu9pAc/C4zuZUbemKziUomYaoSuBYRLE6X9SBEIsS4fECs+4gJZj8hSyVqd+SbJu87+
         k4YGVF2oU6MtTPnunKb8Qzyrhw+lPNSN9km/Wt1AnDw2YPBtnVLo7NQ2KkRKgEvSUhpH
         Of1Q==
X-Gm-Message-State: AOAM531qrGxfBvaSQDb/FhOc6WPsVyMxHF/RqyTBdz9MyMHdsiQlADcN
        tfkN7MBC5ZXDpdDHZ9Vfji4=
X-Google-Smtp-Source: ABdhPJwMLV1WjMkc93GmHdHQiSqhJHqhjTncRIF462XpmhlliKKGh6d/HzRUcY0RtzZOGfeCmuqNhA==
X-Received: by 2002:a5d:62c5:: with SMTP id o5mr35867758wrv.408.1637567316940;
        Sun, 21 Nov 2021 23:48:36 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id e7sm10032241wrg.31.2021.11.21.23.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Nov 2021 23:48:36 -0800 (PST)
Subject: Re: [PATCH 1/5] blk-mq: move srcu from blk_mq_hw_ctx to request_queue
To:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-2-ming.lei@redhat.com>
 <a3192b20-fa76-0b64-a2a9-c0c337741156@acm.org> <YZdb2/XoJVJOa1r+@T590>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a219fff8-8f2d-adb1-eb8c-3e5712cea5bd@grimberg.me>
Date:   Mon, 22 Nov 2021 09:48:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YZdb2/XoJVJOa1r+@T590>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>> +	bool			alloc_srcu;
>>
>> I found the following statement multiple times in this patch:
>>
>> WARN_ON_ONCE(q->alloc_srcu != !!(q->tag_set->flags & BLK_MQ_F_BLOCKING));
>>
>> Does this mean that the new q->alloc_srcu member variable can be left out
>> and that it can be replaced with the following test?
>>
>> q->tag_set->flags & BLK_MQ_F_BLOCKING
> 
> q->tag_set can't be used anymore after blk_cleanup_queue() returns,
> and we need the flag for freeing request_queue instance.

Why not just look at the queue->srcu pointer? it is allocated only
for BLK_MQ_F_BLOCKING no?
