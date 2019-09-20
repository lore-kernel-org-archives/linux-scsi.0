Return-Path: <SRS0=xi/P=XP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F805C49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 17:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15B042086A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 17:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392002AbfITRJy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Sep 2019 13:09:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50456 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391955AbfITRJy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2019 13:09:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id 5so3298283wmg.0;
        Fri, 20 Sep 2019 10:09:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cfxFfQGUkBcjDLVOdYbMW4OGTPS6aOIfBZ/xv+D9EV8=;
        b=NktxVWczbCF04tpwqXtY8rVRuxRUw6PmudofqxzVOVQ33RpD6jf5L1H4Gkb5eb50dE
         MhdjwSUDYw++54RgTiwsAN+I7b+OzTYV8WQTRaCV3yvbRCzrBtvv/xEtOIG+9kYecF2u
         Fldn13McAOdY15XJ+EfGGwQ6VsrBAtvF8K1HJA3EXQrdUi3qYvErEIkN2azkyZheJqlx
         6nyl6vIqy2Al/kL8wsOXHTMTrXS4bm3Jr74CTu0xGW2YTRLDwLigeBtdINwe+NcVhMrq
         /3FNHvVueAL4/YcmJG4WJPVw78u54XoFcazhSa+Bz8h63in5vbS5eew8zJVARR2/mVKa
         zCGg==
X-Gm-Message-State: APjAAAVudo/Mq8MnM+f0DQcpac6/nUIFIaXuwjGUikMoXTP4puOwIqvS
        K+Ni67li97374vWjHzgWIWk=
X-Google-Smtp-Source: APXvYqy8dyp35r2taAzQm5OQLG1ObLmax7stbIj278cwtbNZj3zbQZo+lNJuvh0+dpDPAdbtrpx2fQ==
X-Received: by 2002:a7b:caa9:: with SMTP id r9mr4516694wml.14.1568999392829;
        Fri, 20 Sep 2019 10:09:52 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id y3sm3012481wrw.83.2019.09.20.10.09.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 10:09:52 -0700 (PDT)
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Keith Busch <keith.busch@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@fb.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
References: <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
 <ffefcfa0-09b6-9af5-f94e-8e7ddd2eef16@linaro.org>
 <6eb2a745-7b92-73ce-46f5-cc6a5ef08abc@grimberg.me>
 <20190907000100.GC12290@ming.t460p>
 <f5685543-8cd5-6c6a-5b80-c77ef09c6b3b@grimberg.me>
 <20190918143732.GA19364@ming.t460p>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <1f01c041-cc6e-e27e-7691-63c903d1fed7@grimberg.me>
Date:   Fri, 20 Sep 2019 10:09:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190918143732.GA19364@ming.t460p>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> It seems like we're attempting to stay in irq context for as long as we
>> can instead of scheduling to softirq/thread context if we have more than
>> a minimal amount of work to do. Without at least understanding why
>> softirq/thread degrades us so much this code seems like the wrong
>> approach to me. Interrupt context will always be faster, but it is
>> not a sufficient reason to spend as much time as possible there, is it?
> 
> If extra latency is added in IO completion path, this latency will be
> introduced in the submission path, because the hw queue depth is fixed,
> which is often small. Especially in case of multiple submission vs.
> single(shared) completion, the whole hw queue tags can be exhausted
> easily.

This is why the patch is reaping the first batch from hard-irq, but only
if it has more will defer to softirq. So I'm not sure the short QD use
case applies here...

> I guess no such effect for networking IO.

Maybe, maybe not...
