Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DBCC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 04:54:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E297613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 04:54:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhDTEzX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 00:55:23 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:51185 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhDTEzW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 00:55:22 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 5141C2EA03C;
        Tue, 20 Apr 2021 00:54:51 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id uI-VVjCe-ir8; Tue, 20 Apr 2021 00:35:11 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 15ED42EA00A;
        Tue, 20 Apr 2021 00:54:50 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>
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
 <ccdaee0e-3824-927c-8647-e8f44c1557dc@interlog.com>
 <f9b143ac-c5df-eedc-13da-8e0c2399abb4@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <993c3ae5-a7e2-aa6d-a6f3-147f06e9d015@interlog.com>
Date:   Tue, 20 Apr 2021 00:54:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f9b143ac-c5df-eedc-13da-8e0c2399abb4@acm.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-19 11:22 p.m., Bart Van Assche wrote:
> On 4/19/21 8:06 PM, Douglas Gilbert wrote:
>> I have always suspected under extreme pressure the block layer (or scsi
>> mid-level) does strange things, like an IO hang, attempts to prove that
>> usually lead back to my own code :-). But I have one example recently
>> where upwards of 10 commands had been submitted (blk_execute_rq_nowait())
>> and the following one stalled (all on the same thread). Seconds later
>> those 10 commands reported DID_TIME_OUT, the stalled thread awoke, and
>> my dd variant went to its conclusion (reporting 10 errors). Following
>> copies showed no ill effects.
>>
>> My weapons of choice are sg_dd, actually sgh_dd and sg_mrq_dd. Those last
>> two monitor for stalls during the copy. Each submitted READ and WRITE
>> command gets its pack_id from an incrementing atomic and a management
>> thread in those copies checks every 300 milliseconds that that atomic
>> value is greater than the previous check. If not, dump the state of the
>> sg driver. The stalled request was in busy state with a timeout of 1
>> nanosecond which indicated that blk_execute_rq_nowait() had not been
>> called. So the chief suspect would be blk_get_request() followed by
>> the bio setup calls IMO.
>>
>> So it certainly looked like an IO hang, not a locking, resource nor
>> corruption issue IMO. That was with a branch off MKP's
>> 5.13/scsi-staging branch taken a few weeks back. So basically
>> lk 5.12.0-rc1 .
> 
> Hi Doug,
> 
> If it would be possible to develop a script that reproduces this hang and
> if that script can be shared I will help with root-causing and fixing this
> hang.

Possible, but not very practical:
    1) apply supplied 83 patches to sg driver
    2) apply pending patch to scsi_debug driver
    3) find a stable kernel platform (perhaps not lk 5.12.0-rc1)
    4) run supplied scripts for three weeks
    5) dig through the output and maybe find one case (there were lots
       of EAGAINs from blk_get_request() but they are expected when
       thrashing the storage layers)


My basic testing strategy may be useful for others:
     sg_dd iflag=random bs=512 of=/dev/sg6
     sg_dd if=/dev/sg6 bs=512 of=/dev/sg7
     sg_dd --verify if=/dev/sg6 bs=512 of=/dev/sg7

If the copy works, so should the verify (compare). The sg_dd utility in
sg3_utils release 1.46 is needed to support iflag=random in the first
line and the --verify in the third line.

If the backing LLD is scsi_debug, then per_host_store=1 is needed. Best
not to use SSDs. The above pattern will work just as well for /dev/sd*
device nodes, but iflag= and oflag= lists must contain the sgio flag.
Then ioctl(/dev/sd*, SG_IO, ...) is used for IO. The limitations of the
third line could be bypassed with something like:
     cmp /dev/sd6 /dev/sd7

If real disks are used, all user data will be trashed.

Doug Gilbert

