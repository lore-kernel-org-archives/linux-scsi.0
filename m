Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FD7C54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 15:49:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E9AF206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 15:49:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="sc2MQ0EO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbgDTPtu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 11:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728555AbgDTPtt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 11:49:49 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7ACC061A10
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 08:49:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id b12so11471723ion.8
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 08:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ld3oOwYGZhj2t3a7f7UcWkxlb8VunpJ+wMQxWcezo4s=;
        b=sc2MQ0EOZetDwEtyZAl/p8EF+WvZFJ8v/HZbdEWfQZPzIUtQVfm8R4kHoyfEpor73s
         o5qr3q1cai7UEl2ibKLX7oaJ6SKcFaRuGovY2fd9fdqJfsJB5HPWh/W1JezKX9MPBKHW
         3bujHKf3bOeIH6nDPjvpwaU5iy5hIoEV1+SwYf4cyTT2HhONXbZ2o0v/WQ6SIBcORThm
         PBXU21RyxQ+6wRFMhwafJqz2b88swmcnSHdH9VhQ2rjkGs/uohJ6sFXy6IStjHU6aj4Z
         lWmntuTyRwIr6fZSt1NFIkLVm57T1EevevibxFt+ntpb0k5NNoeSwNcyry7t2eHdZ9dO
         2zTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ld3oOwYGZhj2t3a7f7UcWkxlb8VunpJ+wMQxWcezo4s=;
        b=gkWyGbFCwBh6vdBaN141iYiq1HTfZBABXbdq2JtK4Db/4V8KkXtE2ID/mqRHmxk+yC
         5N77z+Xpq02d1E+ne+AbH7ZJZ2bRj/K5lNKMnPeQMeeo5kLPuDLCcpWzAbY3vPS3+kAE
         52cV7RWOJp7aHaVLNeFuXkapws5H/ZpblCM2v/2ZM2friuNeauVTcF31PeUc8HZmmmLS
         +FXl/jClydzntk0TptchpdkxsIZr0ilHrV5xt2uCE9Xzk7rBdslUVJ/wUeQsbnv9b6Dn
         cLBi/PdNlyY5U9C7+WzXhrarI1UJhyzs1/Bt4eu/MRd/C7Edpk3svZmoLTXim7Q6n3tg
         kcuA==
X-Gm-Message-State: AGi0PubAxFUU6lZfktYjIDjX4+9z9ZAdctyJHur3/in80btdw2rd2tJM
        oP8+w5pLP6t9bPuj2jWHXdvrhA==
X-Google-Smtp-Source: APiQypIRcRm8p1FuzAD+r56BPYHCpWIgYQOn3iX8qZd0S4y1cfXF7po5uEsr3rPiCSk1k5DaaN6ObQ==
X-Received: by 2002:a6b:f812:: with SMTP id o18mr5324402ioh.87.1587397787288;
        Mon, 20 Apr 2020 08:49:47 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f145sm402897ilh.48.2020.04.20.08.49.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 08:49:46 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] blk-mq: Fix two causes of IO stalls found in
 reboot testing
To:     Doug Anderson <dianders@chromium.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Guenter Roeck <groeck@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        linux-scsi@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Salman Qazi <sqazi@google.com>,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        LKML <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20200408150402.21208-1-dianders@chromium.org>
 <CAD=FV=Upkdz_7TG8gde9jC+iWBFHckVf3yZe5Zyz9gq27Ys0GQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <18812f7f-abba-ba0e-5e97-695a1d97da05@kernel.dk>
Date:   Mon, 20 Apr 2020 09:49:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Upkdz_7TG8gde9jC+iWBFHckVf3yZe5Zyz9gq27Ys0GQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/20 8:45 AM, Doug Anderson wrote:
> Hi Jens,
> 
> On Wed, Apr 8, 2020 at 8:35 AM Douglas Anderson <dianders@chromium.org> wrote:
>>
>> While doing reboot testing, I found that occasionally my device would
>> trigger the hung task detector.  Many tasks were stuck waiting for the
>> a blkdev mutex, but at least one task in the system was always sitting
>> waiting for IO to complete (and holding the blkdev mutex).  One
>> example of a task that was just waiting for its IO to complete on one
>> reboot:
>>
>>  udevd           D    0  2177    306 0x00400209
>>  Call trace:
>>   __switch_to+0x15c/0x17c
>>   __schedule+0x6e0/0x928
>>   schedule+0x8c/0xbc
>>   schedule_timeout+0x9c/0xfc
>>   io_schedule_timeout+0x24/0x48
>>   do_wait_for_common+0xd0/0x160
>>   wait_for_completion_io_timeout+0x54/0x74
>>   blk_execute_rq+0x9c/0xd8
>>   __scsi_execute+0x104/0x198
>>   scsi_test_unit_ready+0xa0/0x154
>>   sd_check_events+0xb4/0x164
>>   disk_check_events+0x58/0x154
>>   disk_clear_events+0x74/0x110
>>   check_disk_change+0x28/0x6c
>>   sd_open+0x5c/0x130
>>   __blkdev_get+0x20c/0x3d4
>>   blkdev_get+0x74/0x170
>>   blkdev_open+0x94/0xa8
>>   do_dentry_open+0x268/0x3a0
>>   vfs_open+0x34/0x40
>>   path_openat+0x39c/0xdf4
>>   do_filp_open+0x90/0x10c
>>   do_sys_open+0x150/0x3c8
>>   ...
>>
>> I've reproduced this on two systems: one boots from an internal UFS
>> disk and one from eMMC.  Each has a card reader attached via USB with
>> an SD card plugged in.  On the USB-attached SD card is a disk with 12
>> partitions (a Chrome OS test image), if it matters.  The system
>> doesn't do much with the USB disk other than probe it (it's plugged in
>> my system to help me recover).
>>
>> From digging, I believe that there are two separate but related
>> issues.  Both issues relate to the SCSI code saying that there is no
>> budget.
>>
>> I have done testing with only one or the other of the two patches in
>> this series and found that I could still encounter hung tasks if only
>> one of the two patches was applied.  This deserves a bit of
>> explanation.  To me, it's fairly obvious that the first fix wouldn't
>> fix the problems talked about in the second patch.  However, it's less
>> obvious why the second patch doesn't fix the problems in
>> blk_mq_dispatch_rq_list().  It turns out that it _almost_ does
>> (problems become much more rare), but I did manage to get a single
>> trace where the "kick" scheduled by the second patch happened really
>> quickly.  The scheduled kick then ran and found nothing to do.  This
>> happened in parallel to a task running in blk_mq_dispatch_rq_list()
>> which hadn't gotten around to splicing the list back into
>> hctx->dispatch.  This is why we need both fixes.
>>
>> Most of my testing has been atop Chrome OS 5.4's kernel tree which
>> currently has v5.4.30 merged in.  The Chrome OS 5.4 tree also has a
>> patch by Salman Qazi, namely ("block: Limit number of items taken from
>> the I/O scheduler in one go").  Reverting that patch didn't make the
>> hung tasks go away, so I kept it in for most of my testing.
>>
>> I have also done some testing on mainline Linux (most on what git
>> describe calls v5.6-rc7-227-gf3e69428b5e2) even without Salman's
>> patch.  I found that I could reproduce the problems there and that
>> traces looked about the same as I saw on the downstream branch.  These
>> patches were also confirmed to fix the problems on mainline.
>>
>> Chrome OS is currently setup to use the BFQ scheduler and I found that
>> I couldn't reproduce the problems without BFQ.  As discussed in the
>> second patch this is believed to be because BFQ sometimes returns
>> "true" from has_work() but then NULL from dispatch_request().
>>
>> I'll insert my usual caveat that I'm sending patches to code that I
>> know very little about.  If I'm making a total bozo patch here, please
>> help me figure out how I should fix the problems I found in a better
>> way.
>>
>> If you want to see a total ridiculous amount of chatter where I
>> stumbled around a whole bunch trying to figure out what was wrong and
>> how to fix it, feel free to read <https://crbug.com/1061950>.  I
>> promise it will make your eyes glaze over right away if this cover
>> letter didn't already do that.  Specifically comment 79 in that bug
>> includes a link to my ugly prototype of making BFQ's has_work() more
>> exact (I only managed it by actually defining _both_ an exact and
>> inexact function to avoid circular locking problems when it was called
>> directly from blk_mq_hctx_has_pending()).  Comment 79 also has more
>> thoughts about alternatives considered.
>>
>> I don't know if these fixes represent a regression of some sort or are
>> new.  As per above I could only reproduce with BFQ enabled which makes
>> it nearly impossible to go too far back with this.  I haven't listed
>> any "Fixes" tags here, but if someone felt it was appropriate to
>> backport this to some stable trees that seems like it'd be nice.
>> Presumably at least 5.4 stable would make sense.
>>
>> Thanks to Salman Qazi, Paolo Valente, and Guenter Roeck who spent a
>> bunch of time helping me trawl through some of this code and reviewing
>> early versions of this patch.
>>
>> Changes in v4:
>> - Only kick in blk_mq_do_dispatch_ctx() / blk_mq_do_dispatch_sched().
>>
>> Changes in v3:
>> - Note why blk_mq_dispatch_rq_list() change is needed.
>> - ("blk-mq: Add blk_mq_delay_run_hw_queues() API call") new for v3
>> - Always kick when putting the budget.
>> - Delay blk_mq_do_dispatch_sched() kick by 3 ms for inexact has_work().
>> - Totally rewrote commit message.
>> - ("Revert "scsi: core: run queue...") new for v3.
>>
>> Changes in v2:
>> - Replace ("scsi: core: Fix stall...") w/ ("blk-mq: Rerun dispatch...")
>>
>> Douglas Anderson (4):
>>   blk-mq: In blk_mq_dispatch_rq_list() "no budget" is a reason to kick
>>   blk-mq: Add blk_mq_delay_run_hw_queues() API call
>>   blk-mq: Rerun dispatching in the case of budget contention
>>   Revert "scsi: core: run queue if SCSI device queue isn't ready and
>>     queue is idle"
>>
>>  block/blk-mq-sched.c    | 18 ++++++++++++++++++
>>  block/blk-mq.c          | 30 +++++++++++++++++++++++++++---
>>  drivers/scsi/scsi_lib.c |  7 +------
>>  include/linux/blk-mq.h  |  1 +
>>  4 files changed, 47 insertions(+), 9 deletions(-)
> 
> Is there anything blocking this series from landing?  All has been
> quiet for a while.  All the patches have Ming's review and the SCSI
> patch has Martin's Ack.  This seems like a great time to get it into
> linux-next so it can get a whole bunch of testing before the next
> merge window.

Current series doesn't apply - can you resend it?

-- 
Jens Axboe

