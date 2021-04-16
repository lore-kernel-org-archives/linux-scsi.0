Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8433C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 15:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7E9A61184
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 15:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244892AbhDPPCL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 11:02:11 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2874 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236384AbhDPPCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 11:02:11 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FMK4106jLz689yY;
        Fri, 16 Apr 2021 22:54:25 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 16 Apr 2021 17:01:45 +0200
Received: from [10.47.83.179] (10.47.83.179) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 16 Apr
 2021 16:01:44 +0100
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Ming Lei <ming.lei@redhat.com>
CC:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
References: <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com> <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com> <YHe3M62agQET6o6O@T590>
 <3e76ffc7-1d71-83b6-ef5b-3986e947e372@huawei.com> <YHgvMAHqIq9f6pQn@T590>
 <f66f9204-83ff-48d4-dbf4-4a5e1dc100b7@huawei.com> <YHjeUrCTbrSft18t@T590>
 <217e4cc1-c915-0e95-1d1c-4a11496080d6@huawei.com> <YHlNS3RqsYDMA3jQ@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <89ebc37c-21d6-c57e-4267-cac49a3e5953@huawei.com>
Date:   Fri, 16 Apr 2021 15:59:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YHlNS3RqsYDMA3jQ@T590>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.179]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/04/2021 09:39, Ming Lei wrote:
> On Fri, Apr 16, 2021 at 09:29:37AM +0100, John Garry wrote:
>> On 16/04/2021 01:46, Ming Lei wrote:
>>>> I can't seem to recreate your same issue. Are you mainline defconfig, or a
>>>> special disto config?
>>> The config is rhel8 config.
>>>
>> Can you share that? Has anyone tested against mainline x86 config?
> Sure, see the attachment.

Thanks. I assume that this is not seen on mainline x86 defconfig.

Unfortunately it's anything but easy for me to install an x86 kernel ATM.

And I am still seeing this on hisi_sas v2 hw with 5.12-rc7:

[  214.448368] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  214.454468] rcu:Tasks blocked on level-1 rcu_node (CPUs 0-15):
[  214.460474]  (detected by 40, t=5255 jiffies, g=2229, q=1110)
[  214.466208] rcu: All QSes seen, last rcu_preempt kthread activity 1 
(4294945760-4294945759), jiffies_till_next_fqs=1, root ->qsmask 0x1
[  214.478466] BUG: scheduling while atomic: 
irq/151-hisi_sa/503/0x00000004
[  214.485162] Modules linked in:
[  214.488208] CPU: 40 PID: 503 Comm: irq/151-hisi_sa Not tainted 5.11.0 
#75
[  214.494985] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon 
D05 IT21 Nemo 2.0 RC0 04/18/2018
[  214.504105] Call trace:
[  214.506540]  dump_backtrace+0x0/0x1b0
[  214.510208]  show_stack+0x18/0x68
[  214.513513]  dump_stack+0xd8/0x134
[  214.516907]  __schedule_bug+0x60/0x78
[  214.520560]  __schedule+0x620/0x6d8
[  214.524039]  schedule+0x70/0x108
[  214.527256]  irq_thread+0xdc/0x230
[  214.530648]  kthread+0x154/0x158
[  214.533866]  ret_from_fork+0x10/0x30
john@ubuntu:~$

For rw=randread and mq-deadline only, it seems. v5.11 has the same. Not 
sure if this is a driver or other issue.

Today I don't have access to other boards with enough disks to get a 
decent throughput to test against :(

Thanks,
John
