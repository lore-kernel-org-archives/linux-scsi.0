Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B50C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA3C961221
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhDTDHH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 23:07:07 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:56443 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTDHG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 23:07:06 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id A2F512EA0A2;
        Mon, 19 Apr 2021 23:06:35 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 485TIwXYucmy; Mon, 19 Apr 2021 22:46:55 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 64FA22EA00A;
        Mon, 19 Apr 2021 23:06:34 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
References: <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com> <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com> <YHe3M62agQET6o6O@T590>
 <3e76ffc7-1d71-83b6-ef5b-3986e947e372@huawei.com> <YHgvMAHqIq9f6pQn@T590>
 <f66f9204-83ff-48d4-dbf4-4a5e1dc100b7@huawei.com> <YHjeUrCTbrSft18t@T590>
 <217e4cc1-c915-0e95-1d1c-4a11496080d6@huawei.com> <YHlNS3RqsYDMA3jQ@T590>
 <89ebc37c-21d6-c57e-4267-cac49a3e5953@huawei.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <ccdaee0e-3824-927c-8647-e8f44c1557dc@interlog.com>
Date:   Mon, 19 Apr 2021 23:06:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <89ebc37c-21d6-c57e-4267-cac49a3e5953@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-16 10:59 a.m., John Garry wrote:
> On 16/04/2021 09:39, Ming Lei wrote:
>> On Fri, Apr 16, 2021 at 09:29:37AM +0100, John Garry wrote:
>>> On 16/04/2021 01:46, Ming Lei wrote:
>>>>> I can't seem to recreate your same issue. Are you mainline defconfig, or a
>>>>> special disto config?
>>>> The config is rhel8 config.
>>>>
>>> Can you share that? Has anyone tested against mainline x86 config?
>> Sure, see the attachment.
> 
> Thanks. I assume that this is not seen on mainline x86 defconfig.
> 
> Unfortunately it's anything but easy for me to install an x86 kernel ATM.
> 
> And I am still seeing this on hisi_sas v2 hw with 5.12-rc7:
> 
> [  214.448368] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  214.454468] rcu:Tasks blocked on level-1 rcu_node (CPUs 0-15):
> [  214.460474]  (detected by 40, t=5255 jiffies, g=2229, q=1110)
> [  214.466208] rcu: All QSes seen, last rcu_preempt kthread activity 1 
> (4294945760-4294945759), jiffies_till_next_fqs=1, root ->qsmask 0x1
> [  214.478466] BUG: scheduling while atomic: irq/151-hisi_sa/503/0x00000004
> [  214.485162] Modules linked in:
> [  214.488208] CPU: 40 PID: 503 Comm: irq/151-hisi_sa Not tainted 5.11.0 #75
> [  214.494985] Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon D05 IT21 
> Nemo 2.0 RC0 04/18/2018
> [  214.504105] Call trace:
> [  214.506540]  dump_backtrace+0x0/0x1b0
> [  214.510208]  show_stack+0x18/0x68
> [  214.513513]  dump_stack+0xd8/0x134
> [  214.516907]  __schedule_bug+0x60/0x78
> [  214.520560]  __schedule+0x620/0x6d8
> [  214.524039]  schedule+0x70/0x108
> [  214.527256]  irq_thread+0xdc/0x230
> [  214.530648]  kthread+0x154/0x158
> [  214.533866]  ret_from_fork+0x10/0x30
> john@ubuntu:~$
> 
> For rw=randread and mq-deadline only, it seems. v5.11 has the same. Not sure if 
> this is a driver or other issue.
> 
> Today I don't have access to other boards with enough disks to get a decent 
> throughput to test against :(

I have always suspected under extreme pressure the block layer (or scsi
mid-level) does strange things, like an IO hang, attempts to prove that
usually lead back to my own code :-). But I have one example recently
where upwards of 10 commands had been submitted (blk_execute_rq_nowait())
and the following one stalled (all on the same thread). Seconds later
those 10 commands reported DID_TIME_OUT, the stalled thread awoke, and
my dd variant went to its conclusion (reporting 10 errors). Following
copies showed no ill effects.

My weapons of choice are sg_dd, actually sgh_dd and sg_mrq_dd. Those last
two monitor for stalls during the copy. Each submitted READ and WRITE
command gets its pack_id from an incrementing atomic and a management
thread in those copies checks every 300 milliseconds that that atomic
value is greater than the previous check. If not, dump the state of the
sg driver. The stalled request was in busy state with a timeout of 1
nanosecond which indicated that blk_execute_rq_nowait() had not been
called. So the chief suspect would be blk_get_request() followed by
the bio setup calls IMO.

So it certainly looked like an IO hang, not a locking, resource nor
corruption issue IMO. That was with a branch off MKP's
5.13/scsi-staging branch taken a few weeks back. So basically
lk 5.12.0-rc1 .

Doug Gilbert


