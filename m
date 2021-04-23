Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993C7C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 08:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68C50613D5
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 08:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhDWIqh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 04:46:37 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2911 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhDWIqh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 04:46:37 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FRSKl02bdz77b2F;
        Fri, 23 Apr 2021 16:35:39 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 10:45:58 +0200
Received: from [10.47.95.78] (10.47.95.78) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 23 Apr
 2021 09:45:57 +0100
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Ming Lei <ming.lei@redhat.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com> <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com> <YHe3M62agQET6o6O@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0c85fe52-ebc7-68b3-2dbe-dfad5d604346@huawei.com>
Date:   Fri, 23 Apr 2021 09:43:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YHe3M62agQET6o6O@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.95.78]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/04/2021 04:46, Ming Lei wrote:
>> CPU util			IOPs
>> mq-deadline	usr=21.72%, sys=44.18%,		423K
>> none		usr=23.15%, sys=74.01%		450K
> Today I re-run the scsi_debug test on two server hardwares(32cores, dual
> numa nodes), and the CPU utilization issue can be reproduced, follow
> the test result:
> 

I haven't forgotten about this.

I finally got your .config working in x86 qemu with only a 4-CPU system.

> 1) randread test on ibm-x3850x6[*] with deadline
> 
>                |IOPS    | FIO CPU util
> ------------------------------------------------
> hosttags      | 94k    | usr=1.13%, sys=14.75%
> ------------------------------------------------
> non hosttags  | 124k   | usr=1.12%, sys=10.65%,
> 

Getting these results for mq-deadline:

hosttags
100K cpu 1.52 4.47

non-hosttags
109K cpu 1.74 5.49

So I still don't see the same CPU usage increase for hosttags.

But throughput is down, so at least I can check on that...

> 
> 2) randread test on ibm-x3850x6[*] with none
>                |IOPS    | FIO CPU util
> ------------------------------------------------
> hosttags      | 120k   | usr=0.89%, sys=6.55%
> ------------------------------------------------
> non hosttags  | 121k   | usr=1.07%, sys=7.35%
> ------------------------------------------------
> 

Here I get:
hosttags
113K cpu 2.04 5.83

non-hosttags
108K cpu 1.71 5.05

Thanks,
John



>   *:
>   	- that is the machine Yanhui reported VM cpu utilization increased by 20%
> 	- kernel: latest linus tree(v5.12-rc7, commit: 7f75285ca57)
> 	- also run same test on another 32cores machine, IOPS drop isn't
> 	  observed, but CPU utilization is increased obviously
> 
> 3) test script
> #/bin/bash
> 
> run_fio() {
> 	RTIME=$1
> 	JOBS=$2
> 	DEVS=$3
> 	BS=$4
> 
> 	QD=64
> 	BATCH=16
> 
> 	fio --bs=$BS --ioengine=libaio \
> 		--iodepth=$QD \
> 	    --iodepth_batch_submit=$BATCH \
> 		--iodepth_batch_complete_min=$BATCH \
> 		--filename=$DEVS \
> 		--direct=1 --runtime=$RTIME --numjobs=$JOBS --rw=randread \
> 		--name=test --group_reporting
> }
> 
> SCHED=$1
> 
> NRQS=`getconf _NPROCESSORS_ONLN`
> 
> rmmod scsi_debug
> modprobe scsi_debug host_max_queue=128 submit_queues=$NRQS virtual_gb=256
> sleep 2
> DEV=`lsscsi | grep scsi_debug | awk '{print $6}'`
> echo $SCHED >/sys/block/`basename $DEV`/queue/scheduler
> echo 128 >/sys/block/`basename $DEV`/device/queue_depth
> run_fio 20 16 $DEV 8K
> 
> 
> rmmod scsi_debug
> modprobe scsi_debug max_queue=128 submit_queues=1 virtual_gb=256
> sleep 2
> DEV=`lsscsi | grep scsi_debug | awk '{print $6}'`
> echo $SCHED >/sys/block/`basename $DEV`/queue/scheduler
> echo 128 >/sys/block/`basename $DEV`/device/queue_depth
> run_fio 20 16 $DEV 8k

