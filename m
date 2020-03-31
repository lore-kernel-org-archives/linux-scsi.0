Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD40C2D0EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 18:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8994D20CC7
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 18:26:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="rJlBKfpc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgCaS0F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 14:26:05 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46900 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgCaS0F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2020 14:26:05 -0400
Received: by mail-io1-f65.google.com with SMTP id i3so13652984ioo.13
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 11:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zTlwgmGnB1cU3zTn4DEJZ8fbxVPFlHmycQ95U9sMbsg=;
        b=rJlBKfpc9trObZI3GDcY/hj9Prgsnr2UUSPu7MoZgwW+UYvgO6ojYmpUMa8D9gkR2d
         jHzqLzqXw+bcrVIjTAwan9UAYz75jpQMkVOfo3FQ9z95iWUi14eG4kf2j9ER1WyNVYMO
         zzgQrlQUAR5uIaIILYDYe72AhhhG6ofXaZs0DcYUTAO7ixsCO99fTsQ6tZ+txEnNyATH
         hf433+P2Y7tOINgKoyuQtPeiBm+Oc/B46Y9yxwRpxxct0yjtZ+Kphd26RFxwcqy4svIt
         zlw43C0FHxtDS1nDrcD2z8bbHKfixzk5hC0ze5g2GiXbqCTnC0Vagtf0X7WKqQvdUMg7
         HRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zTlwgmGnB1cU3zTn4DEJZ8fbxVPFlHmycQ95U9sMbsg=;
        b=Bkx2Wf+t4RnhzXU/ZJOZytqkdwZINwGrXppLdSu3GhigoKKCqZY7RYLXOMVVGWBYlO
         NRrducJoEQMcju0nip1jC0PPdTDhq/lVSkyzFzbuWh4Q8IK2kd1ZhU/2vO+IUqvpq2tp
         b2+4Smf4129QCB4Jz8kuItWubxb1spF7AEEtoc9RwKkRmDWBsSM9QcWbFbakpdnfPQVc
         GEBB081B0zNHjFAAb8yEwVeThdzYBx5FkpjJEoXztnT7gHXPHyZVBiaZh7Scl3cxbJZl
         dAVtcgsUMG8Nwjc8PpaNSwIHJlg/7ALCYovCTCptp8hlxoUsHE01IEMgX8/3ghkBbUVK
         m4Gg==
X-Gm-Message-State: ANhLgQ3ZPNDNJSYT2V7iZMuzrZKeiLJL6Z6XZQdUrjROySxT4QR0N9cr
        /Yr7z9uUyb0Tr9UU86IKd0s20A==
X-Google-Smtp-Source: ADFU+vtsgO04ADJ14bnAugG3u148qvxQ/2Jo5IgjZHLrY/snL+kMRclGcQ/tPKsaJebS6vvXnAvhqg==
X-Received: by 2002:a5d:8d90:: with SMTP id b16mr16929726ioj.9.1585679163757;
        Tue, 31 Mar 2020 11:26:03 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l12sm3656192ils.55.2020.03.31.11.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 11:26:02 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi: core: Fix stall if two threads request budget
 at the same time
To:     Paolo Valente <paolo.valente@linaro.org>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Douglas Anderson <dianders@chromium.org>, jejb@linux.ibm.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block <linux-block@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        linux-scsi@vger.kernel.org, sqazi@google.com,
        linux-kernel@vger.kernel.org
References: <20200330144907.13011-1-dianders@chromium.org>
 <20200330074856.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
 <20200331014109.GA20230@ming.t460p>
 <D38AB98D-7F6A-4C61-8A8F-C22C53671AC8@linaro.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d6af2344-11f7-5862-daed-e21cbd496d92@kernel.dk>
Date:   Tue, 31 Mar 2020 12:26:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <D38AB98D-7F6A-4C61-8A8F-C22C53671AC8@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/20 12:07 PM, Paolo Valente wrote:
>> Il giorno 31 mar 2020, alle ore 03:41, Ming Lei <ming.lei@redhat.com> ha scritto:
>>
>> On Mon, Mar 30, 2020 at 07:49:06AM -0700, Douglas Anderson wrote:
>>> It is possible for two threads to be running
>>> blk_mq_do_dispatch_sched() at the same time with the same "hctx".
>>> This is because there can be more than one caller to
>>> __blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() doesn't
>>> prevent more than one thread from entering.
>>>
>>> If more than one thread is running blk_mq_do_dispatch_sched() at the
>>> same time with the same "hctx", they may have contention acquiring
>>> budget.  The blk_mq_get_dispatch_budget() can eventually translate
>>> into scsi_mq_get_budget().  If the device's "queue_depth" is 1 (not
>>> uncommon) then only one of the two threads will be the one to
>>> increment "device_busy" to 1 and get the budget.
>>>
>>> The losing thread will break out of blk_mq_do_dispatch_sched() and
>>> will stop dispatching requests.  The assumption is that when more
>>> budget is available later (when existing transactions finish) the
>>> queue will be kicked again, perhaps in scsi_end_request().
>>>
>>> The winning thread now has budget and can go on to call
>>> dispatch_request().  If dispatch_request() returns NULL here then we
>>> have a potential problem.  Specifically we'll now call
>>
>> I guess this problem should be BFQ specific. Now there is definitely
>> requests in BFQ queue wrt. this hctx. However, looks this request is
>> only available from another loser thread, and it won't be retrieved in
>> the winning thread via e->type->ops.dispatch_request().
>>
>> Just wondering why BFQ is implemented in this way?
>>
> 
> BFQ inherited this powerful non-working scheme from CFQ, some age ago.
> 
> In more detail: if BFQ has at least one non-empty internal queue, then
> is says of course that there is work to do.  But if the currently
> in-service queue is empty, and is expected to receive new I/O, then
> BFQ plugs I/O dispatch to enforce service guarantees for the
> in-service queue, i.e., BFQ responds NULL to a dispatch request.

What BFQ is doing is fine, IFF it always ensures that the queue is run
at some later time, if it returns "yep I have work" yet returns NULL
when attempting to retrieve that work. Generally this should happen from
subsequent IO completion, or whatever else condition will resolve the
issue that is currently preventing dispatch of that request. Last resort
would be a timer, but that can happen if you're slicing your scheduling
somehow.

> It would be very easy to change bfq_has_work so that it returns false
> in case the in-service queue is empty, even if there is I/O
> backlogged.  My only concern is: since everything has worked with the
> current scheme for probably 15 years, are we sure that everything is
> still ok after we change this scheme?

You're comparing apples to oranges, CFQ never worked within the blk-mq
scheduling framework.

That said, I don't think such a change is needed. If we currently have a
hang due to this discrepancy between has_work and gets_work, then it
sounds like we're not always re-running the queue as we should. From the
original patch, the budget putting is not something the scheduler is
involved with. Do we just need to ensure that if we put budget without
having dispatched a request, we need to kick off dispatching again?


-- 
Jens Axboe

