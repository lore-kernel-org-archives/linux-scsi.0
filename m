From: Arun Easi <arun.easi@cavium.com>
Subject: scsi-mq - tag# and can_queue, performance.
Date: Sun, 2 Apr 2017 23:37:50 -0700 (PDT)
Message-ID: <alpine.LRH.2.00.1704022326190.727@mvluser05.qlc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0089.outbound.protection.outlook.com ([104.47.38.89]:53808
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750992AbdDCGiB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Apr 2017 02:38:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

Hi Folks,

I would like to seek your input on a few topics on SCSI / block 
multi-queue.

1. Tag# generation.

The context is with SCSI MQ on. My question is, what should a LLD do to 
get request tag values in the range 0 through can_queue - 1 across *all* 
of the queues. In our QLogic 41XXX series of adapters, we have a per 
session submit queue, a shared task memory (shared across all queues) and 
N completion queues (separate MSI-X vectors). We report N as the 
nr_hw_queues. I would like to, if possible, use the block layer tags to 
index into the above shared task memory area.

>From looking at the scsi/block source, it appears that when a LLD reports 
a value say #C, in can_queue (via scsi_host_template), that value is used 
as the max depth when corresponding block layer queues are created. So, 
while SCSI restricts the number of commands to LLD at #C, the request tag 
generated across any of the queues can range from 0..#C-1. Please correct 
me if I got this wrong.

If the above is true, then for a LLD to get tag# within it's max-tasks 
range, it has to report max-tasks / number-of-hw-queues in can_queue, and 
in the I/O path, use the tag and hwq# to arrive at a index# to use. This, 
though, leads to a poor use of tag resources -- queue reaching it's 
capacity while LLD can still take it.

blk_mq_unique_tag() would not work here, because it just puts the hwq# in 
the upper 16 bits, which need not fall in the max-tasks range.

Perhaps the current MQ model is to cater to a queue pair 
(submit/completion) kind of hardware model; nevertheless I would like to 
know how other hardware variants can makes use of it.

2. mq vs non-mq performance gain.

This is more like a poll, I guess. I was wondering what performance gains 
folks are observing with SCSI MQ on. I saw Christoph H.'s slide deck that 
has one slide that shows a 200k IOPS gain.

>From my testing, though, I was not lucky to observe that big of a change. 
In fact, the difference was not even noticeable(*). For e.g., for 512 
bytes random read test, in both cases, gave me in the vicinity of 2M IOPs. 
When I say both cases, I meant, one with scsi_mod's use_blk_mq set to 0 
and another with 1 (LLD is reloaded when it is done). I only used one NUMA 
node for this run. The test was run on a x86_64 setup.

* See item 3 for a special handling.

3. add_random slowness.

One thing I observed with MQ on and off was this block layer tunable, 
add_random, which as I understand is to tune disk entropy contribution. 
With non-MQ, it is turned on, and with MQ, it is turned off by default.

This got noticed because, when I was running multi-port testing, there was 
a big drop in IOPs with and without MQ (~200K IOPS to 1M+ IOPs when the 
test ran on same NUMA node / across NUMA nodes).

Just wondering why we have it ON on one setting and OFF on another.

Sorry for the rather long e-mail, but your comments/thoughts are much 
appreciated.

Regards,
-Arun
