Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8662FC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 12:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 548A360200
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 12:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350683AbhDNMJ1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 08:09:27 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2853 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350681AbhDNMJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 08:09:23 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FL1Kh2DKwz688Lc;
        Wed, 14 Apr 2021 20:01:44 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 14 Apr 2021 14:08:59 +0200
Received: from [10.47.25.158] (10.47.25.158) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 14 Apr
 2021 13:08:58 +0100
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Ming Lei <ming.lei@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Douglas Gilbert" <dgilbert@interlog.com>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com> <YHbOOfGNHwO4SMS7@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
Date:   Wed, 14 Apr 2021 13:06:25 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YHbOOfGNHwO4SMS7@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.25.158]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/04/2021 12:12, Ming Lei wrote:
> On Wed, Apr 14, 2021 at 04:12:22PM +0530, Kashyap Desai wrote:
>>> Hi Ming,
>>>
>>>> It is reported inside RH that CPU utilization is increased ~20% when
>>>> running simple FIO test inside VM which disk is built on image stored
>>>> on XFS/megaraid_sas.
>>>>
>>>> When I try to investigate by reproducing the issue via scsi_debug, I
>>>> found IO hang when running randread IO(8k, direct IO, libaio) on
>>>> scsi_debug disk created by the following command:
>>>>
>>>> 	modprobe scsi_debug host_max_queue=128
>>> submit_queues=$NR_CPUS
>>>> virtual_gb=256
>>>>
>>> So I can recreate this hang for using mq-deadline IO sched for scsi debug,
>>> in
>>> that fio does not exit. I'm using v5.12-rc7.
>> I can also recreate this issue using mq-deadline. Using <none>, there is no
>> IO hang issue.
>> Also if I run script to change scheduler periodically (none, mq-deadline),
>> sysfs entry hangs.
>>
>> Here is call trace-
>> Call Trace:
>> [ 1229.879862]  __schedule+0x29d/0x7a0
>> [ 1229.879871]  schedule+0x3c/0xa0
>> [ 1229.879875]  blk_mq_freeze_queue_wait+0x62/0x90
>> [ 1229.879880]  ? finish_wait+0x80/0x80
>> [ 1229.879884]  elevator_switch+0x12/0x40
>> [ 1229.879888]  elv_iosched_store+0x79/0x120
>> [ 1229.879892]  ? kernfs_fop_write_iter+0xc7/0x1b0
>> [ 1229.879897]  queue_attr_store+0x42/0x70
>> [ 1229.879901]  kernfs_fop_write_iter+0x11f/0x1b0
>> [ 1229.879905]  new_sync_write+0x11f/0x1b0
>> [ 1229.879912]  vfs_write+0x184/0x250
>> [ 1229.879915]  ksys_write+0x59/0xd0
>> [ 1229.879917]  do_syscall_64+0x33/0x40
>> [ 1229.879922]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>>
>> I tried both - 5.12.0-rc1 and 5.11.0-rc2+ and there is a same behavior.
>> Let me also check  megaraid_sas and see if anything generic or this is a
>> special case of scsi_debug.
> As I mentioned, it could be one generic issue wrt. SCHED_RESTART.
> shared tags might have to restart all hctx since all share same tags.

I tested on hisi_sas v2 hw (which now sets host_tagset), and can 
reproduce. Seems to be combination of mq-deadline and fio rw=randread 
settings required to reproduce from limited experiments.

Incidentally, about the mq-deadline vs none IO scheduler on the same 
host, I get this with 6x SAS SSD:

rw=read
		CPU util			IOPs
mq-deadline	usr=26.80%, sys=52.78%		650K
none		usr=22.99%, sys=74.10%		475K

rw=randread
		CPU util			IOPs
mq-deadline	usr=21.72%, sys=44.18%,		423K
none		usr=23.15%, sys=74.01%		450K

Thanks,
John

