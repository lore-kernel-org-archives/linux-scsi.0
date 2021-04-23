Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43666C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 17:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C9CF6144D
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 17:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhDWRxX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 13:53:23 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:34530 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWRxW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 13:53:22 -0400
Received: by mail-pj1-f50.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so4824750pjb.1;
        Fri, 23 Apr 2021 10:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ll6DMNNS84hPb2bm+HCQeoF8tRzjzBhtBjzXJJa1V6s=;
        b=bvzdz1UqOFqcTfZZCf9XWX7ni4HbY8sjNT7rH8YkxOpWjXCiyY3EBrHZvV8jhuC4pS
         PX229pSN0f+IfJfQkYzWYNuxgH7ZlQrGX67Yad8mVkMPFvxnajjMat4rZNFYi0VAS6Hc
         5m3Tqyl3W/5iRZ8xXGxOsrCetsGzkyGvpKhhx1EXGMaiNq78yRAliXgRma6/uX0Tsjr6
         jdplfDZpjiYMkUoHxrB8Xrikq5G4kVyyeV1aKjSjm7PN2W4ZkoHg1cgF/rS5dUF99/KQ
         09QXhbtQXNFhlWj/886PtM5/XRKGGjoQzj3qMZcNV5frHIEJAUyjRSt6JacHLHh0aHJa
         EEwQ==
X-Gm-Message-State: AOAM530opFSU3pQaZBKIFMypcPVUsXScz9qTFJQPF2OMPfgMHUmdPMMo
        bo0OA04vAFD7ojZMRkXnfgBERIyhfNoe3Q==
X-Google-Smtp-Source: ABdhPJypMV20L2RYVMMZWM5sgBnC+vuncBaqn7GsnfEEX4ZXp1m7Oyxf2fyhIJh1powjML4SYhx87g==
X-Received: by 2002:a17:90a:ca83:: with SMTP id y3mr7199104pjt.191.1619200365869;
        Fri, 23 Apr 2021 10:52:45 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:a976:f332:ee26:584f? ([2601:647:4000:d7:a976:f332:ee26:584f])
        by smtp.gmail.com with ESMTPSA id lx11sm5400808pjb.27.2021.04.23.10.52.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 10:52:44 -0700 (PDT)
Subject: Re: [PATCH v7 3/5] blk-mq: Fix races between iterating over requests
 and freeing requests
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <dwagner@suse.de>,
        Khazhismel Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210421000235.2028-1-bvanassche@acm.org>
 <20210421000235.2028-4-bvanassche@acm.org> <YIDqa6YkNoD5OiKN@T590>
 <b717ffc0-a434-738f-9c63-32901bd164b2@acm.org> <YIEiElb9wxReV/oL@T590>
 <32a121b7-2444-ac19-420d-4961f2a18129@acm.org> <YIJEg9DLWoOJ06Kc@T590>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <28607d75-042f-7a6a-f5d0-2ee03754917e@acm.org>
Date:   Fri, 23 Apr 2021 10:52:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIJEg9DLWoOJ06Kc@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/22/21 8:52 PM, Ming Lei wrote:
> For example, scsi aacraid normal completion vs. reset together with elevator
> switch, aacraid is one single queue HBA, and the request will be completed
> via IPI or softirq asynchronously, that said request isn't really completed
> after blk_mq_complete_request() returns.
> 
> 1) interrupt comes, and request A is completed via blk_mq_complete_request()
> from aacraid's interrupt handler via ->scsi_done()
> 
> 2) _aac_reset_adapter() comes because of reset event which can be
> triggered by sysfs store or whatever, irq is drained in 
> _aac_reset_adpter(), so blk_mq_complete_request(request A) from aacraid irq
> context is done, but request A is just scheduled to be completed via IPI
> or softirq asynchronously, not really done yet.
> 
> 3) scsi_host_complete_all_commands() is called from _aac_reset_adapter() for
> failing all pending requests. request A is still visible in
> scsi_host_complete_all_commands, because its tag isn't freed yet. But the
> tag & request A can be completed & freed exactly after scsi_host_complete_all_commands()
> reads ->rqs[bitnr] in bt_tags_iter(), which calls complete_all_cmds_iter()
> -> .scsi_done() -> blk_mq_complete_request(), and same request A is scheduled via
> IPI or softirq, and request A is addded in ipi or softirq list.
> 
> 4) meantime request A is freed from normal completion triggered by interrupt, one
> pending elevator switch can move on since request A drops the last reference; and
> bt_tags_iter() returns from reset path, so blk_mq_wait_for_tag_iter() can return
> too, then the whole scheduler request pool is freed now.
> 
> 5) request A in ipi/softirq list scheduled from _aac_reset_adapter is read , UAF
> is triggered.
> 
> It is supposed that driver covers normal completion vs. error handling, but wrt.
> remove completion, not sure driver is capable of covering that.

Hi Ming,

I agree that the scenario above can happen and also that a fix is
needed. However, I do not agree that this should be fixed by modifying
the tag iteration functions. I see scsi_host_complete_all_commands() as
a workaround for broken storage controllers - storage controllers that
do not have a facility for terminating all pending commands. NVMe
controllers can be told to terminate all pending I/O commands by e.g.
deleting all I/O submission queues. Many SCSI controllers also provide a
facility for aborting all pending commands. For SCSI controllers that do
not provide such a facility I propose to fix races like the race
described above in the SCSI LLD instead of modifying the block layer tag
iteration functions.

Thanks,

Bart.
