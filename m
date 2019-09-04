Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28FEDC3A5A8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 17:07:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 083BB20882
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 17:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731911AbfIDRHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 13:07:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43520 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731625AbfIDRHv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 13:07:51 -0400
Received: by mail-pf1-f194.google.com with SMTP id d15so4124517pfo.10;
        Wed, 04 Sep 2019 10:07:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=doRviDRcuI8ukbxh960Ewx7U5Vu3KSMcpLgAPd33oB4=;
        b=T2oaSe2aH1ursHjCkmEAsLjRP2HY1OhNGPTQLwpXXRogemv0owBTT59/HkeipicoDC
         CcWL5Tq7bLRq/RIxj/nkusHBJl3HJsDGgdiIJGHQncqA7YWSwMgbkMQ88hagbqMAxJ5D
         4gCghOIkdwfmw56wGFpNiV6iBQdvF2KQdaujkujNJfo4zQAoIjv+8s/Un7Bi7p3BqSwS
         /JYUA4KshkPrKtquwHSb6AB8H5jR8UWc0WFZhlSv7PjPFMkjVEktKE1AVObqCFAyp4Ju
         S0w4VUMvzSNQ1mbZ1B+GJAzRz5ILwQmUBNZ7m0lhx7892wZmye9XjataeW0q4CT2yN29
         vdHA==
X-Gm-Message-State: APjAAAXZPtoqPmELC+0qLDA4hGqN5qvtVSmgMNbnu3uL5VS/EpemZFGW
        0xOW7v2KoXwQJ5gIjLpzCMg=
X-Google-Smtp-Source: APXvYqxTGX0yWsgvrQzLKsJf9CtThotqfcBWqegNulPltQ1d0FC1QU27SwfyIzRS1iCIIODIqAnaUA==
X-Received: by 2002:aa7:8a83:: with SMTP id a3mr47156125pfc.115.1567616870289;
        Wed, 04 Sep 2019 10:07:50 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 2sm23516255pfa.43.2019.09.04.10.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 10:07:49 -0700 (PDT)
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
Date:   Wed, 4 Sep 2019 10:07:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/3/19 12:50 AM, Daniel Lezcano wrote:
> On 03/09/2019 09:28, Ming Lei wrote:
>> On Tue, Sep 03, 2019 at 08:40:35AM +0200, Daniel Lezcano wrote:
>>> It is a scheduler problem then ?
>>
>> Scheduler can do nothing if the CPU is taken completely by handling
>> interrupt & softirq, so seems not a scheduler problem, IMO.
> 
> Why? If there is a irq pressure on one CPU reducing its capacity, the
> scheduler will balance the tasks on another CPU, no?

Only if CONFIG_IRQ_TIME_ACCOUNTING has been enabled. However, I don't 
know any Linux distro that enables that option. That's probably because 
that option introduces two rdtsc() calls in each interrupt. Given the 
overhead introduced by this option, I don't think this is the solution 
Ming is looking for.

See also irqtime_account_irq() in kernel/sched/cputime.c.

Bart.
