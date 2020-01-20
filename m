Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A9FC33CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 18:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DD2D22314
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 18:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="rRSVyrRa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgATSqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 13:46:54 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:31012 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726282AbgATSqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 13:46:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579546013; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=CWUUOoFW1b3LdZHGARh2ZeruDO7qr6rXZB15xntFSmA=; b=rRSVyrRaD0rNU2ig4ChC5I9udPd7U2qWcSiVplHX2JIC1CGso49YdC8RwhNLgc957u+Pskic
 ZP7sM/17Io85886OiXxcM1skbxZEfzgXU5H/DlSvV+mnSbFVfgf0HJI7FxieFXvqX7CVJk5l
 S0A06u0YjEsYHnIoIZ0ltWO5KEw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e25f599.7fc7e4b82fb8-smtp-out-n01;
 Mon, 20 Jan 2020 18:46:49 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1A1F3C447AD; Mon, 20 Jan 2020 18:46:46 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0CC83C433CB;
        Mon, 20 Jan 2020 18:46:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0CC83C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 1/1] scsi: ufs: Add command logging infrastructure
To:     Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cang@codeaurora.org
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "Winkler, Tomas" <tomas.winkler@intel.com>, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Evan Green <evgreen@chromium.org>,
        Janek Kotas <jank@cadence.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
References: <1571808560-3965-1-git-send-email-cang@codeaurora.org>
 <5B8DA87D05A7694D9FA63FD143655C1B9DCF0AFE@hasmsx108.ger.corp.intel.com>
 <MN2PR04MB6991C2AF4DDEDD84C7887258FC6B0@MN2PR04MB6991.namprd04.prod.outlook.com>
 <01eb3c55e35738f2853fbc7175a12eaa@codeaurora.org>
 <20191029054620.GG1929@tuxbook-pro>
 <b7de9358-b8ba-3100-a3f2-ebed8aaab490@codeaurora.org>
 <a07f3244-6536-0667-cf61-3ef8b8bc6c7e@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <e3761f14-9a1b-3c83-693b-7262bf004a7e@codeaurora.org>
Date:   Mon, 20 Jan 2020 10:46:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a07f3244-6536-0667-cf61-3ef8b8bc6c7e@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/2020 7:43 PM, Bart Van Assche wrote:
> On 2020-01-16 15:03, Asutosh Das (asd) wrote:
>> On 10/28/2019 10:46 PM, Bjorn Andersson wrote:
>>> On Mon 28 Oct 19:37 PDT 2019, cang@codeaurora.org wrote:
>>>
>>>> On 2019-10-23 18:33, Avri Altman wrote:
>>>>>>
>>>>>>> Add the necessary infrastructure to keep timestamp history of
>>>>>>> commands, events and other useful info for debugging complex issues.
>>>>>>> This helps in diagnosing events leading upto failure.
>>>>>>
>>>>>> Why not use tracepoints, for that?
>>>>> Ack on Tomas's comment.
>>>>> Are there any pieces of information that you need not provided by the
>>>>> upiu tracer?
>>>>>
>>>>> Thanks,
>>>>> Avri
>>>>
>>>> In extreme cases, when the UFS runs into bad state, system may crash.
>>>> There
>>>> may not be a chance to collect trace. If trace is not collected and
>>>> failure
>>>> is hard to be reproduced, some command logs prints would be very
>>>> helpful to
>>>> help understand what was going on before we run into failure.
>>>>
>>>
>>> This is a common problem shared among many/all subsystems, so it's
>>> better to rely on a generic solution for this; such as using tracepoints
>>> dumped into pstore/ramoops.
>>>
>>> Regards,
>>> Bjorn
>>>
>>
>> Reviving this discussion.
>>
>> Another issue with using ftrace is that several subsystems use it.
>> Consider a situation in which we store a history of 64 commands,
>> responses and some other required info in ftrace.
>>
>> Say there's a command that's stuck for seconds until the software times
>> out. In this case, the other ftrace events are still enabled and keep
>> writing to ftrace buffer thus overwriting some/most of the ufs's command
>> history; thus the history is more or less lost. And there's a need to
>> reproduce the issue with other tracing disabled.
>>
>> So what we need is a client specific logging mechanism, which is
>> lightweight as ftrace and can be parsed from ramdumps.
>>
>> I'm open to ideas but ftrace in its current form may not be suitable for
>> this.
> 
> Hi Asutosh,
> 
> Are you aware that it is already possible today to figure out which SCSI
> commands are pending? Are you familiar with the files under
> /sys/kernel/debug/block/? An example:
> 
> $ (cd /sys/kernel/debug/block && grep -aH . */*/busy)
> nvme0n1/hctx7/busy:0000000006f07009 {.op=READ, .cmd_flags=META|PRIO,
> .rq_flags=DONTPREP|IO_STAT, .state=in_flight, .tag=275, .internal_tag=-1}
> 
> Bart.
> 
> 

Hi Bart,

No I was not aware of this. Thanks for letting me know.

However, it doesn't look like this stores the _history_ of commands that 
were already executed.

To put it in perspective, below is the output of the current command 
logging -:

[     461.142124354s] dme: dme_send: seq_no=  738272 lun=0 cmd_id=0x018 
lba=        0 txfer_len=       0 tag= 0 doorbell=0x0000 
outstanding=0x0000 idn= 0
[     461.142384823s] dme: dme_cmpl_2: seq_no=  738273 lun=0 
cmd_id=0x018 lba=        0 txfer_len=       0 tag= 0 doorbell=0x0000 
outstanding=0x0000 idn= 0
[     461.142453052s] scsi: scsi_send: seq_no=  738274 lun=0 
cmd_id=0x028 lba=  1360888 txfer_len=   77824 tag= 0 doorbell=0x0001 
outstanding=0x0001 idn= 0
[     461.142473000s] scsi: scsi_send: seq_no=  738275 lun=0 
cmd_id=0x028 lba=  1361056 txfer_len=   12288 tag= 1 doorbell=0x0003 
outstanding=0x0003 idn= 0
[     461.142482270s] scsi: scsi_send: seq_no=  738276 lun=0 
cmd_id=0x028 lba=  1361088 txfer_len=    4096 tag= 2 doorbell=0x0007 
outstanding=0x0007 idn= 0
[     461.142491020s] scsi: scsi_send: seq_no=  738277 lun=0 
cmd_id=0x028 lba=  1361120 txfer_len=    4096 tag= 3 doorbell=0x000F 
outstanding=0x000F idn= 0
[     461.142538208s] scsi: scsi_send: seq_no=  738278 lun=0 
cmd_id=0x028 lba=  1361144 txfer_len=    4096 tag= 4 doorbell=0x001F 
outstanding=0x001F idn= 0
[     461.142780083s] scsi: scsi_send: seq_no=  738279 lun=0 
cmd_id=0x028 lba=  1361184 txfer_len=   20480 tag= 5 doorbell=0x003F 
outstanding=0x003F idn= 0
[     461.142922791s] scsi: scsi_cmpl: seq_no=  738280 lun=0 
cmd_id=0x028 lba=  1360888 txfer_len=   77824 tag= 0 doorbell=0x003E 
outstanding=0x003F idn= 0
[     461.142982323s] scsi: scsi_cmpl: seq_no=  738281 lun=0 
cmd_id=0x028 lba=  1361056 txfer_len=   12288 tag= 1 doorbell=0x003C 
outstanding=0x003E idn= 0
[     461.142996958s] scsi: scsi_cmpl: seq_no=  738282 lun=0 
cmd_id=0x028 lba=  1361088 txfer_len=    4096 tag= 2 doorbell=0x0038 
outstanding=0x003C idn= 0
[     461.143059406s] scsi: scsi_cmpl: seq_no=  738283 lun=0 
cmd_id=0x028 lba=  1361120 txfer_len=    4096 tag= 3 doorbell=0x0020 
outstanding=0x0038 idn= 0
[     461.143064666s] scsi: scsi_cmpl: seq_no=  738284 lun=0 
cmd_id=0x028 lba=  1361144 txfer_len=    4096 tag= 4 doorbell=0x0020 
outstanding=0x0038 idn= 0

[...]

This output was extracted from ramdumps after a crash.
There're custom logs that come up as well, for e.g. scaling start and 
end etc.

In a nutshell, the high-level requirements of the logging would be -:
1. Light-weight
2. Extract from ram-dumps
3. Eliminate the need to reproduce an issue as much as possible

Ftrace ticks all the boxes except 3. There's a high chance of this data 
being overwritten by other loggers. And when this happens, the issue 
needs to be reproduced with ftrace logging enabled only for ufs.

*Motivation for this logging*:

There are several (read - all) UFS device vendors who need the sequence 
of commands leading up to the specific failure. They've asked for it 
every time. They still do.

There were 2 ways of doing this - either in device or in host.

1. In-Device-:
	The device stores a ring buffer of commands that were received.
	Upon error, host sends a command to device to read this ring 	buffer 
and dumps it out or can be extracted from ramdumps. It'd not be a 
universal solution anyway and would be very vendor-specific. Difficult 
to maintain etc. May have to be added to JEDEC to standardize it.

2. In-host-:
	Ftrace was tried out and the previously highlighted issues popped up. 
Hence the need for a UFS (client)-specific implementation.

If there's a way to have a client-specific ftrace logging, it'd be the 
ideal thing to do.

How about modifying ftrace to make it client-specific?

Any suggestions to modify the current design such that it can use ftrace 
or any other better ideas or methods, please let me know.

-asd


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
