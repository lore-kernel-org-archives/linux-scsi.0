Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA70C3A5A8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 17:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FDE121883
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 17:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbfIDRjC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 13:39:02 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44051 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbfIDRjC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 13:39:02 -0400
Received: by mail-pf1-f195.google.com with SMTP id q21so8654771pfn.11;
        Wed, 04 Sep 2019 10:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KnvfsSXVbwlDdjXbwbCBJbJBscMecP2Y83R9nu77QrY=;
        b=W0m8p/8M5k1Vf4lOjxwRazjXPVDZWgSpR+qgH6StaPwOejJv5NzV9jvwP/3CuhNwkI
         T/mTtNCnRg4fLeqso22vLhRUZi07GTOFRn7tCJOK1QGkBlS0pLh1RJPHAn7DVhcxv6e7
         WDBMbP8D0iY60BAVP2FUXUcP9HvHo63216NccbvAPyLHnvrPmZGtT5aSLhtHiQSFNhah
         8FDzxM+5icfIw5kkSUOVOyiLp/oNl/f2LKSSB8XtLHbsZy6hrHgw2H7pl4aTUMnMZq5D
         YZRqY2q2L9vOzwo+TTkC9MVmCmtvndP6l+mMBI4jFL8yoEPziYC3ande2J+ktG44efRP
         Xe5w==
X-Gm-Message-State: APjAAAVXZqRElTbH3tvrxvtwqByjaICjLD7kQlgaEsH0HpK13TNla6iC
        ay3gg9n/ekDxQVhyc7+7Ryk=
X-Google-Smtp-Source: APXvYqzrk/gkg2yGQWmQ4/JeJVdU8iF4leHlHSGlyvREresBS+YkyH/0INQtThrw0f/ygpLmb9mz8g==
X-Received: by 2002:a63:ff65:: with SMTP id s37mr35380567pgk.102.1567618741236;
        Wed, 04 Sep 2019 10:39:01 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id v15sm23521222pfn.69.2019.09.04.10.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Sep 2019 10:39:00 -0700 (PDT)
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Keith Busch <keith.busch@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@fb.com>,
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
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <de16de12-fa1a-666c-ea19-fea5d096c1ca@acm.org>
Date:   Wed, 4 Sep 2019 10:38:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/4/19 10:31 AM, Daniel Lezcano wrote:
> On 04/09/2019 19:07, Bart Van Assche wrote:
>> Only if CONFIG_IRQ_TIME_ACCOUNTING has been enabled. However, I don't
>> know any Linux distro that enables that option. That's probably because
>> that option introduces two rdtsc() calls in each interrupt. Given the
>> overhead introduced by this option, I don't think this is the solution
>> Ming is looking for.
> 
> Was this overhead reported somewhere ?
  I think it is widely known that rdtsc is a relatively slow x86 
instruction. So I expect that using that instruction will cause a 
measurable overhead if it is called frequently enough. I'm not aware of 
any publicly available measurement data however.

Bart.
