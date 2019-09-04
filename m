Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1B0C3A5AA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 17:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B3FF2087E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 17:31:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m0M/vz9F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbfIDRby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 13:31:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40077 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729594AbfIDRby (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 13:31:54 -0400
Received: by mail-wm1-f68.google.com with SMTP id t9so4753229wmi.5
        for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2019 10:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aYakpRRFoGVA9sz71v0r5VagfdiWC/MbZvxbHI4iRdc=;
        b=m0M/vz9FuKn/AEie3GlNsun9iMNiGECSE03FKZ5BxZ1yL4FHXepYRZzyp3omLczBeO
         EOoe5YBsNjD3HGxIcGjpeacQmr+xhXSSilxfQjWKo+jG4TOxXwbtdttpwR2w3vpLh4AV
         R+0dcXaxcnV+B+CW9Vf8V97PwLnQ4FOdDb5KGSc/7FJwZYHKCZPVwxoxbAldNzbMGvcu
         SG/M6rEZgJeg1HETuiJZttNcYNOTMEXlVeW7pZoMyZdfJg1YJz7/OuroXsz17hDwab/J
         YXssZyVl+H+ZGXFpM5ITUdOpygpA6lGaJH+NJb6dDD50TpEuoJP6KwadehnHZTqIsoGv
         XDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aYakpRRFoGVA9sz71v0r5VagfdiWC/MbZvxbHI4iRdc=;
        b=CULPsv9Yf+yzhhO0kymLs1v+4o4D7RIWpoa3OEuCyXmA2HWNxqFBvpgJ1en5Qe7waE
         8uLIsivL8mdvtclTe9ggxIVZu3hv+5TOM29MHviFg0B6twOmXCQf/pLUiwrfPTnmj43c
         jXWjg0LPJSxUvRobx9dfz5Umu5Y2gDCi5hHwsflfqBr1ZRN1zf2+KBjzB/6qoNc/WmUo
         VDqblvcu/MjyN7APxkV91WhNJ9jSCjvZlru9HJ4MGe8XilY3ya/n460BIhRQl4AzA7Th
         99bjmfz1QT7bm5tmqmV4SQoXS6TAvTgvAQJvLMKRD0mG1mH6ZD9DdjXmBAGTP43nsnQL
         STkA==
X-Gm-Message-State: APjAAAXYzOkjSm4XnTA7roL6Y5Du/wq6/XWl0OjIsa5ALSqnX5Tu1oFw
        InjTf0h9z7Curb5bUTMKLe/Hkg==
X-Google-Smtp-Source: APXvYqylHSYmUd3XhHwzu+LdoP/iw+mi4BQK1D6uwYhqo6KtUdjLENo9yvztksqRrOgy+x2zLAvUGA==
X-Received: by 2002:a1c:cf8c:: with SMTP id f134mr5573819wmg.174.1567618310825;
        Wed, 04 Sep 2019 10:31:50 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ed2f:f020:794a:5c4d:16b4:31a6? ([2a01:e34:ed2f:f020:794a:5c4d:16b4:31a6])
        by smtp.googlemail.com with ESMTPSA id q124sm5935819wma.5.2019.09.04.10.31.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 10:31:50 -0700 (PDT)
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
To:     Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Keith Busch <keith.busch@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
References: <20190827225827.GA5263@ming.t460p>
 <alpine.DEB.2.21.1908280104330.1939@nanos.tec.linutronix.de>
 <20190828110633.GC15524@ming.t460p>
 <alpine.DEB.2.21.1908281316230.1869@nanos.tec.linutronix.de>
 <20190828135054.GA23861@ming.t460p>
 <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
 <20190903033001.GB23861@ming.t460p>
 <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Openpgp: preference=signencrypt
Autocrypt: addr=daniel.lezcano@linaro.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
Date:   Wed, 4 Sep 2019 19:31:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 04/09/2019 19:07, Bart Van Assche wrote:
> On 9/3/19 12:50 AM, Daniel Lezcano wrote:
>> On 03/09/2019 09:28, Ming Lei wrote:
>>> On Tue, Sep 03, 2019 at 08:40:35AM +0200, Daniel Lezcano wrote:
>>>> It is a scheduler problem then ?
>>>
>>> Scheduler can do nothing if the CPU is taken completely by handling
>>> interrupt & softirq, so seems not a scheduler problem, IMO.
>>
>> Why? If there is a irq pressure on one CPU reducing its capacity, the
>> scheduler will balance the tasks on another CPU, no?
> 
> Only if CONFIG_IRQ_TIME_ACCOUNTING has been enabled. However, I don't
> know any Linux distro that enables that option. That's probably because
> that option introduces two rdtsc() calls in each interrupt. Given the
> overhead introduced by this option, I don't think this is the solution
> Ming is looking for.

Was this overhead reported somewhere ?

> See also irqtime_account_irq() in kernel/sched/cputime.c.

From my POV, this framework could be interesting to detect this situation.


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

