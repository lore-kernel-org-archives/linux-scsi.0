Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DC5C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50BBE613B0
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 10:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhDOKoy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 06:44:54 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2866 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDOKox (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 06:44:53 -0400
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FLbRx1gVfz68BSk;
        Thu, 15 Apr 2021 18:39:09 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Apr 2021 12:44:27 +0200
Received: from [10.47.83.117] (10.47.83.117) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Thu, 15 Apr
 2021 11:44:26 +0100
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
Message-ID: <3e76ffc7-1d71-83b6-ef5b-3986e947e372@huawei.com>
Date:   Thu, 15 Apr 2021 11:41:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YHe3M62agQET6o6O@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.117]
X-ClientProxiedBy: lhreml721-chm.china.huawei.com (10.201.108.72) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,

I'll have a look.

BTW, are you intentionally using scsi_debug over null_blk? null_blk 
supports shared sbitmap as well, and performance figures there are 
generally higher than scsi_debug for similar fio settings.

Thanks,
john

EOM


>> 		IOPs
>> mq-deadline	usr=21.72%, sys=44.18%,		423K
>> none		usr=23.15%, sys=74.01%		450K
> Today I re-run the scsi_debug test on two server hardwares(32cores, dual
> numa nodes), and the CPU utilization issue can be reproduced, follow
> the test result:
> 
> 1) randread test on ibm-x3850x6[*] with deadline
> 
>                |IOPS    | FIO CPU util
> ------------------------------------------------
> hosttags      | 94k    | usr=1.13%, sys=14.75%
> ------------------------------------------------
> non hosttags  | 124k   | usr=1.12%, sys=10.65%,
> 
> 
> 2) randread test on ibm-x3850x6[*] with none
>                |IOPS    | FIO CPU util
> ------------------------------------------------
> hosttags      | 120k   | usr=0.89%, sys=6.55%
> ------------------------------------------------
> non hosttags  | 121k   | usr=1.07%, sys=7.35%
> ------------------------------------------------
> 
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


