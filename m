Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE2AC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 14:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BADFE60E0C
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 14:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhDZOuO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 10:50:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232575AbhDZOuO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 10:50:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619448572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oTjEzjqJoCoO7K0CKQdpUaf9JDTQKBtrmItdAop9wE8=;
        b=i1DHrFOHBjQtvyQbxA1/UiNVfImP15jnoCTHPq/UWANcqAlnh4wlYfgIQEKGadO68rBIJE
        Y37mtCtlZOVsFUl4l+fCQK5rTRnK88s+A7rwAwPPUfNS2Pizr+DrjzlRIhUEc4jGTSVgFs
        GDrVF/f2K7/D+8IrhwtbUfo2Z5aZmDc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-rgroyF7UN4SkCO2ZHSPjzQ-1; Mon, 26 Apr 2021 10:49:28 -0400
X-MC-Unique: rgroyF7UN4SkCO2ZHSPjzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E668A1020C25;
        Mon, 26 Apr 2021 14:49:10 +0000 (UTC)
Received: from T590 (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BCD381045E81;
        Mon, 26 Apr 2021 14:48:46 +0000 (UTC)
Date:   Mon, 26 Apr 2021 22:48:53 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YIbS1dgSYrsAeGvZ@T590>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com>
 <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
 <YHe3M62agQET6o6O@T590>
 <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
 <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c1d5abaa-c460-55f8-5351-16f09d6aa81f@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 26, 2021 at 11:53:45AM +0100, John Garry wrote:
> On 23/04/2021 09:43, John Garry wrote:
> > > 1) randread test on ibm-x3850x6[*] with deadline
> > > 
> > >                |IOPS    | FIO CPU util
> > > ------------------------------------------------
> > > hosttags      | 94k    | usr=1.13%, sys=14.75%
> > > ------------------------------------------------
> > > non hosttags  | 124k   | usr=1.12%, sys=10.65%,
> > > 
> > 
> > Getting these results for mq-deadline:
> > 
> > hosttags
> > 100K cpu 1.52 4.47
> > 
> > non-hosttags
> > 109K cpu 1.74 5.49
> > 
> > So I still don't see the same CPU usage increase for hosttags.
> > 
> > But throughput is down, so at least I can check on that...
> > 
> > > 
> > > 2) randread test on ibm-x3850x6[*] with none
> > >                |IOPS    | FIO CPU util
> > > ------------------------------------------------
> > > hosttags      | 120k   | usr=0.89%, sys=6.55%
> > > ------------------------------------------------
> > > non hosttags  | 121k   | usr=1.07%, sys=7.35%
> > > ------------------------------------------------
> > > 
> > 
> > Here I get:
> > hosttags
> > 113K cpu 2.04 5.83
> > 
> > non-hosttags
> > 108K cpu 1.71 5.05
> 
> Hi Ming,
> 
> One thing I noticed is that for the non-hosttags scenario is that I am
> hitting the IO scheduler tag exhaustion path in blk_mq_get_tag() often;
> here's some perf output:
> 
> |--15.88%--blk_mq_submit_bio
> |     |
> |     |--11.27%--__blk_mq_alloc_request
> |     |      |
> |     |       --11.19%--blk_mq_get_tag
> |     |      |
> |     |      |--6.00%--__blk_mq_delay_run_hw_queue
> |     |      |     |
> 
> ...
> 
> |     |      |
> |     |      |--3.29%--io_schedule
> |     |      |     |
> 
> ....
> 
> |     |      |     |
> |     |      |     --1.32%--io_schedule_prepare
> |     |      |
> 
> ...
> 
> |     |      |
> |     |      |--0.60%--sbitmap_finish_wait
> |     |      |
>      --0.56%--sbitmap_get
> 
> I don't see this for hostwide tags - this may be because we have multiple
> hctx, and the IO sched tags are per hctx, so less chance of exhaustion. But
> this is not from hostwide tags specifically, but for multiple HW queues in
> general. As I understood, sched tags were meant to be per request queue,
> right? I am reading this correctly?

sched tags is still per-hctx.

I just found that you didn't change sched tags into per-request-queue
shared tags. Then for hostwide tags, each hctx still has its own
standalone sched tags and request pool, that is one big difference with
non hostwide tags. That is why you observe that scheduler tag exhaustion
is easy to trigger in case of non-hostwide tags.

I'd suggest to add one per-request-queue sched tags, and make all hctxs
sharing it, just like what you did for driver tag.


Thanks,
Ming

