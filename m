Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB49C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 01:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C72F20717
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 01:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AEQm4AGf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgGUBNr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 21:13:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45668 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726390AbgGUBNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 21:13:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595294025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=242qISjfeixY1o86Yfb+A75hdUEk1zcgp/jdbdwcQqI=;
        b=AEQm4AGfoCW+ZvWrubAtLBuC7cwdz6UIk/fuMI7DwgCyX9GGOHmjZjwAbWslgKBBpsczBg
        kHoOJ5SbRizE+vIvmby29+OPX7s/49MI6zhtg3fiBEUzWtzDqE7HGs89Ey78FjzmMi+sJw
        91Yyxo3w977F+NzMpicPnQIq9hyEdNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-vKVOsk1wMi63ao8GHId7CQ-1; Mon, 20 Jul 2020 21:13:41 -0400
X-MC-Unique: vKVOsk1wMi63ao8GHId7CQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 714A51DE9;
        Tue, 21 Jul 2020 01:13:39 +0000 (UTC)
Received: from T590 (ovpn-12-200.pek2.redhat.com [10.72.12.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91AD760E1C;
        Tue, 21 Jul 2020 01:13:28 +0000 (UTC)
Date:   Tue, 21 Jul 2020 09:13:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
Message-ID: <20200721011323.GA833377@T590>
References: <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com>
 <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com>
 <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
 <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com>
 <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com>
 <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 <e69dc243174664efd414a4cd0176e59d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e69dc243174664efd414a4cd0176e59d@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 20, 2020 at 12:53:55PM +0530, Kashyap Desai wrote:
> > > > I also noticed nr_hw_queues are now exposed in sysfs -
> > > >
> > > >
> > /sys/devices/pci0000:85/0000:85:00.0/0000:86:00.0/0000:87:04.0/0000:8b
> > > >
> > >
> > :00.0/0000:8c:00.0/0000:8d:00.0/host14/scsi_host/host14/nr_hw_queues:1
> > > > 28
> > > > .
> > >
> > > That's on my v8 wip branch, so I guess you're picking it up from there.
> >
> > John - I did more testing on v8 wip branch.  CPU hotplug is working as
> > expected, but I still see some performance issue on Logical Volumes.
> >
> > I created 8 Drives Raid-0 VD on MR controller and below is performance
> > impact of this RFC. Looks like contention is on single <sdev>.
> >
> > I used command - "numactl -N 1  fio 1vd.fio --iodepth=128 --bs=4k --
> > rw=randread --cpus_allowed_policy=split --ioscheduler=none --
> > group_reporting --runtime=200 --numjobs=1"
> > IOPS without RFC = 300K IOPS with RFC = 230K.
> >
> > Perf top (shared host tag. IOPS = 230K)
> >
> > 13.98%  [kernel]        [k] sbitmap_any_bit_set
> >      6.43%  [kernel]        [k] blk_mq_run_hw_queue
> 
> blk_mq_run_hw_queue function take more CPU which is called from "
> scsi_end_request"

The problem could be that nr_hw_queues is increased a lot so that
sample on blk_mq_run_hw_queue() can be observed now.

> It looks like " blk_mq_hctx_has_pending" handles only elevator (scheduler)
> case. If  queue has ioscheduler=none, we can skip. I case of scheduler=none,
> IO will be pushed to hardware queue and it by pass software queue.
> Based on above understanding, I added below patch and I can see performance
> scale back to expectation.
> 
> Ming mentioned that - we cannot remove blk_mq_run_hw_queues() from IO
> completion path otherwise we may see IO hang. So I have just modified
> completion path assuming it is only required for IO scheduler case.
> https://www.spinics.net/lists/linux-block/msg55049.html
> 
> Please review and let me know if this is good or we have to address with
> proper fix.
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 1be7ac5a4040..b6a5b41b7fc2 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1559,6 +1559,9 @@ void blk_mq_run_hw_queues(struct request_queue *q,
> bool async)
>         struct blk_mq_hw_ctx *hctx;
>         int i;
> 
> +       if (!q->elevator)
> +               return;
> +

This way shouldn't be correct, blk_mq_run_hw_queues() is still needed for
none because request may not be dispatched successfully by direct issue.


Thanks,
Ming

