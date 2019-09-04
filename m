Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F994C3A5AB
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 19:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 236DF21726
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 19:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfIDTrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 15:47:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43037 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727562AbfIDTrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 15:47:16 -0400
Received: by mail-pf1-f194.google.com with SMTP id d15so4447949pfo.10;
        Wed, 04 Sep 2019 12:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eVl+9tAIHMvBrQx3eBUEyjTBamIfURj9LIAwDSTkbB0=;
        b=H68lfn27AU639Ja/djh2IG9+Mv7q0Foy2QH/tXbmyul7u68uwW/FqLmkEov66r950n
         QmoNKD2KYsUYdw5CSWVkW9KZRt1+mRnuxgMJ1Pm4PZBmhcLSVAkpvmDZjI9nWFlLhi3q
         0QTHcQACYpHH+D/Jcibcfee5LwV8RW3QbMrqPupSZAll5xHQqUvAFHtFXI9gkY6mHTKs
         UkmprGsbjBFvi74exCiQArhkpFbVQISFnY+KsSBCDJPcMyimQ7uErWGUbsc9scNOSQZf
         9+2O2AYnIm6iM1Xw2KLY8VSSWHF08yK9CRBPvE18b1i64vwqUSC8L882LFgAatxcoQld
         TTSQ==
X-Gm-Message-State: APjAAAX5ddMCxo6/CX1fDEXa9kxfgV13StKLUi1dLwTyokGtDwEC6+X/
        rAB4KKsrj4Dpt2zrNzobPCk=
X-Google-Smtp-Source: APXvYqx+3PI2yKaiUlmIJkEhbY9ZelMh9dTSVitv6do41wzJeS7xqPQb6h7FvJuVpl5L7IOgn6YEcw==
X-Received: by 2002:a63:31c1:: with SMTP id x184mr37650267pgx.128.1567626435911;
        Wed, 04 Sep 2019 12:47:15 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id m19sm41874829pff.108.2019.09.04.12.47.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 12:47:15 -0700 (PDT)
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ming Lei <ming.lei@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@fb.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
References: <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
 <20190903033001.GB23861@ming.t460p>
 <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <de16de12-fa1a-666c-ea19-fea5d096c1ca@acm.org>
 <20190904180211.GX2332@hirez.programming.kicks-ass.net>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9b924e48-e217-9c11-c1fb-46c92a82ea2d@acm.org>
Date:   Wed, 4 Sep 2019 12:47:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190904180211.GX2332@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/4/19 11:02 AM, Peter Zijlstra wrote:
> On Wed, Sep 04, 2019 at 10:38:59AM -0700, Bart Van Assche wrote:
>> I think it is widely known that rdtsc is a relatively slow x86 instruction.
>> So I expect that using that instruction will cause a measurable overhead if
>> it is called frequently enough. I'm not aware of any publicly available
>> measurement data however.
> 
> https://www.agner.org/optimize/instruction_tables.pdf
> 
> RDTSC, Ryzen: ~36
> RDTSC, Skylake: ~20
> 
> Sadly those same tables don't list the cost of actual exceptions or even
> IRET :/

Thanks Peter for having looked up these numbers. These numbers are much 
better than last time I checked. Ming, would CONFIG_IRQ_TIME_ACCOUNTING 
help your workload?

Does anyone know which CPUs the following text from 
Documentation/admin-guide/kernel-parameters.txt refers to?

tsc=		[ ... ]
		[x86] noirqtime: Do not use TSC to do irq accounting.
		Used to run time disable IRQ_TIME_ACCOUNTING on any
		platforms where RDTSC is slow and this accounting
		can add overhead.

Bart.
