Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EFEC71155
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 11:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DE382086A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 11:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgLALtx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 06:49:53 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2183 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgLALtx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 06:49:53 -0500
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ClgLM5PFFz67D41;
        Tue,  1 Dec 2020 19:46:51 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 1 Dec 2020 12:49:10 +0100
Received: from [10.47.7.145] (10.47.7.145) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 1 Dec 2020
 11:49:09 +0000
Subject: Re: [bug report] Hang on sync after dd
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     chenxiang <chenxiang66@hisilicon.com>,
        <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>,
        Ewan Milne <emilne@redhat.com>, Long Li <longli@microsoft.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <2847d0e1-ccb1-7be6-2456-274e41ea981b@huawei.com>
 <6cd6f97324474f88a0a748e218c8dddf@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <3c82dc5d-0095-cd10-4094-477a4a7535ec@huawei.com>
Date:   Tue, 1 Dec 2020 11:48:43 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <6cd6f97324474f88a0a748e218c8dddf@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.7.145]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Kashyap,

> John - I tested V4 version "scsi: core: Only re-run queue in
> scsi_end_request() if device queue is busy" on MR controller.
> I used different reduced device queue depth (1 to 16). I can try the exact
> same test case with MR controller.
> 

Thanks, I still can't recreate to help debug...

>>
>>
>> Block debugfs info is as follows:
>>
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat active cpu101/ cpu96/
>> cpu99/ dispatch_busy io_poll sched_tags tags busy cpu102/ cpu97/ ctx_map
>> dispatched queued sched_tags_bitmap tags_bitmap cpu100/ cpu103/ cpu98/
>> dispatch flags run state type estuary:/sys/kernel/debug/block/sda/hctx8$
>> cat
>> cpu cpu100/ cpu101/ cpu102/ cpu103/ cpu96/ cpu97/ cpu98/ cpu99/
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu cpu100/ cpu101/
>> cpu102/ cpu103/ cpu96/ cpu97/ cpu98/ cpu99/
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu96/ completed
>> default_rq_list dispatched merged poll_rq_list read_rq_list
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu96/dispatched
>> 0 0
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu97/dispatched
>> 0 0
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu98/dispatched
>> 0 0
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu99/dispatched
>> 0 0
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu100/dispatched
>> 3 0
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat cpu100/completed
>> 2 0
>> estuary:/sys/kernel/debug/block/sda/hctx8$
>> estuary:/sys/kernel/debug/block/sda/hctx8$
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat state SCHED_RESTART
> 
> When I tested V3 "scsi: core: Only re-run queue in scsi_end_request() if
> device queue  is busy". I noticed the similar hang and that was fixed in V4
> (final patch).
> Let me try on MR controller one more time. Hctx state SCHED_RESTART
> indicates that someone should kicked-off h/w queue but it was missed. It may
> be possible that
> When you revert " scsi: core: Only re-run queue in scsi_end_request() if
> device queue  is busy", actual race condition windows narrows and it may be
> actually existing hidden issue.

So do you know how would changing to single hctx (by checking out to 
commit before we enable hot_tagset in the driver) would affect this? 
Apparently this also "solves" the issue.

> 
> 
>> estuary:/sys/kernel/debug/block/sda/hctx8$ ls active cpu101 cpu96 cpu99
>> dispatch_busy io_poll sched_tags tags busy cpu102 cpu97 ctx_map
>> dispatched queued sched_tags_bitmap tags_bitmap
>> cpu100 cpu103 cpu98 dispatch flags run state type
>> estuary:/sys/kernel/debug/block/sda/hctx8$ cat dispatch 000000007abb596e
>> {.op=FLUSH, .cmd_flags=PREFLUSH,
>> .rq_flags=FLUSH_SEQ|MQ_INFLIGHT|DONTPREP, .state=idle, .tag=21,
>> .internal_tag=-1, .cmd=opcode=0x35 35 00 00 00 00 00 00 00 00 00,
>> .retries=0, .result = 0x0, .flags=TAGGED|INITIALIZED|3, .timeout=60.000,
> 
> If this issue is reproducible, can you check pending commands. Is there any
> pattern in pending command ?

chenxiang, please assist in checking this.

> 
>> allocated 2208.876 s ago} estuary:/sys/kernel/debug/block/sda/hctx8$
>>
>>
>> On cpu100, it seems completed is less than number dispatched.

Cheers,
John
