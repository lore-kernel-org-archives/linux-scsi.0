Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D21C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 20:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57C23613C0
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 20:22:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhDTUX2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 16:23:28 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:32778 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbhDTUX1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 16:23:27 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 046A22EA2D6;
        Tue, 20 Apr 2021 16:22:55 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id 6AYvsOood-VO; Tue, 20 Apr 2021 16:03:12 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id F214D2EA323;
        Tue, 20 Apr 2021 16:22:53 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
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
 <ccdaee0e-3824-927c-8647-e8f44c1557dc@interlog.com>
 <f9b143ac-c5df-eedc-13da-8e0c2399abb4@acm.org>
 <993c3ae5-a7e2-aa6d-a6f3-147f06e9d015@interlog.com>
 <CAFj5m9LPe=TdJgz2iJ7U6UT4=x-5aE=YbRgOQ80RHfpp62GQQQ@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <acb407c9-c9ab-4783-e526-e5d34876e57b@interlog.com>
Date:   Tue, 20 Apr 2021 16:22:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAFj5m9LPe=TdJgz2iJ7U6UT4=x-5aE=YbRgOQ80RHfpp62GQQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-20 2:52 a.m., Ming Lei wrote:
> On Tue, Apr 20, 2021 at 12:54 PM Douglas Gilbert <dgilbert@interlog.com> wrote:
>>
>> On 2021-04-19 11:22 p.m., Bart Van Assche wrote:
>>> On 4/19/21 8:06 PM, Douglas Gilbert wrote:
>>>> I have always suspected under extreme pressure the block layer (or scsi
>>>> mid-level) does strange things, like an IO hang, attempts to prove that
>>>> usually lead back to my own code :-). But I have one example recently
>>>> where upwards of 10 commands had been submitted (blk_execute_rq_nowait())
>>>> and the following one stalled (all on the same thread). Seconds later
>>>> those 10 commands reported DID_TIME_OUT, the stalled thread awoke, and
>>>> my dd variant went to its conclusion (reporting 10 errors). Following
>>>> copies showed no ill effects.
>>>>
>>>> My weapons of choice are sg_dd, actually sgh_dd and sg_mrq_dd. Those last
>>>> two monitor for stalls during the copy. Each submitted READ and WRITE
>>>> command gets its pack_id from an incrementing atomic and a management
>>>> thread in those copies checks every 300 milliseconds that that atomic
>>>> value is greater than the previous check. If not, dump the state of the
>>>> sg driver. The stalled request was in busy state with a timeout of 1
>>>> nanosecond which indicated that blk_execute_rq_nowait() had not been
>>>> called. So the chief suspect would be blk_get_request() followed by
>>>> the bio setup calls IMO.
>>>>
>>>> So it certainly looked like an IO hang, not a locking, resource nor
>>>> corruption issue IMO. That was with a branch off MKP's
>>>> 5.13/scsi-staging branch taken a few weeks back. So basically
>>>> lk 5.12.0-rc1 .
>>>
>>> Hi Doug,
>>>
>>> If it would be possible to develop a script that reproduces this hang and
>>> if that script can be shared I will help with root-causing and fixing this
>>> hang.
>>
>> Possible, but not very practical:
>>      1) apply supplied 83 patches to sg driver
>>      2) apply pending patch to scsi_debug driver
>>      3) find a stable kernel platform (perhaps not lk 5.12.0-rc1)
>>      4) run supplied scripts for three weeks
>>      5) dig through the output and maybe find one case (there were lots
>>         of EAGAINs from blk_get_request() but they are expected when
>>         thrashing the storage layers)
> 
> Or collecting the debugfs log after IO hang is triggered in your test:
> 
> (cd /sys/kernel/debug/block/$SDEV && find . -type f -exec grep -aH . {} \;)
> 
> $SDEV is the disk on which IO hang is observed.

Thanks. I'll try adding that to my IO hang trigger code.

My patches on the sg driver add debugfs support so these produce
the same output:
     cat /proc/scsi/sg/debug
     cat /sys/kernel/debug/scsi_generic/snapshot

There is also a /sys/kernel/debug/scsi_generic/snapped file whose
contents reflect the driver's state when ioctl(<sg_fd>, SG_DEBUG, &one)
was last called.

When I test, the root file system is usually on a NVMe SSD so the
state of all SCSI disks present should be dumped as they are part
of my test. Also I find the netconsole module extremely useful and
have an old laptop on my network running:
    socat udp-recv:6665 - > socat.txt

picking up the UDP packets from netconsole on port 6665. Not quite as
good as monitoring a hardware serial console, but less fiddly. And
most modern laptops don't have access to a serial console so
netconsole is the only option.

Another observation: upper level issues seem to impact the submission
side of request handling (e.g. the IO hang I was trying to describe)
while error injection I can do (e.g. using the scsi_debug driver)
impacts the completion side (obviously). Are there any tools to inject
errors into the block layer submission code?

Doug Gilbert


