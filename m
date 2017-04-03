From: Hannes Reinecke <hare@suse.de>
Subject: Re: scsi-mq - tag# and can_queue, performance.
Date: Mon, 3 Apr 2017 09:29:50 +0200
Message-ID: <3fd1ca57-3b0a-9405-0ec8-3be15ba33caf@suse.de>
References: <alpine.LRH.2.00.1704022326190.727@mvluser05.qlc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751282AbdDCH35 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Apr 2017 03:29:57 -0400
In-Reply-To: <alpine.LRH.2.00.1704022326190.727@mvluser05.qlc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arun Easi <arun.easi@cavium.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On 04/03/2017 08:37 AM, Arun Easi wrote:
> Hi Folks,
> 
> I would like to seek your input on a few topics on SCSI / block 
> multi-queue.
> 
> 1. Tag# generation.
> 
> The context is with SCSI MQ on. My question is, what should a LLD do to 
> get request tag values in the range 0 through can_queue - 1 across *all* 
> of the queues. In our QLogic 41XXX series of adapters, we have a per 
> session submit queue, a shared task memory (shared across all queues) and 
> N completion queues (separate MSI-X vectors). We report N as the 
> nr_hw_queues. I would like to, if possible, use the block layer tags to 
> index into the above shared task memory area.
> 
> From looking at the scsi/block source, it appears that when a LLD reports 
> a value say #C, in can_queue (via scsi_host_template), that value is used 
> as the max depth when corresponding block layer queues are created. So, 
> while SCSI restricts the number of commands to LLD at #C, the request tag 
> generated across any of the queues can range from 0..#C-1. Please correct 
> me if I got this wrong.
> 
> If the above is true, then for a LLD to get tag# within it's max-tasks 
> range, it has to report max-tasks / number-of-hw-queues in can_queue, and 
> in the I/O path, use the tag and hwq# to arrive at a index# to use. This, 
> though, leads to a poor use of tag resources -- queue reaching it's 
> capacity while LLD can still take it.
> 
Yep.

> blk_mq_unique_tag() would not work here, because it just puts the hwq# in 
> the upper 16 bits, which need not fall in the max-tasks range.
> 
> Perhaps the current MQ model is to cater to a queue pair 
> (submit/completion) kind of hardware model; nevertheless I would like to 
> know how other hardware variants can makes use of it.
> 
He. Welcome to the club.

Shared tag sets continue to dog the block-mq on 'legacy' (ie non-NVMe)
HBAs. ATM the only 'real' solution to this problem is indeed have a
static split of the entire tag space by the number of hardware queues.
With the mentioned tag-starvation problem.

If we were to continue with the tag to hardware ID mapping, we would
need to implement a dynamic tag space mapping onto hardware queues.
My idea to that would be to map the entire tag space, but rather the
individual bit words onto the hardware queue. Then we could make the
mapping dynamic, where there individual words are mapped onto the queues
only as needed.
However, the _one_ big problem we're facing here is timeouts.
With the 1:1 mapping between tags and hardware IDs we can only re-use
the tag once the timeout is _definitely_ resolved. But this means
the command will be active, and we cannot return blk_mq_complete() until
the timeout itself has been resolved.
With FC this essentially means until the corresponding XIDs are safe to
re-use, ie after all ABRT/RRQ etc processing has been completed.
Hence we totally lose the ability to return the command itself with
-ETIMEDOUT and continue with I/O processing even though the original XID
is still being held by firmware.

In the light of this I wonder if it wouldn't be better to completely
decouple block-layer tags and hardware IDs, and have an efficient
algorithm mapping the block-layer tags onto hardware IDs.
That should avoid the arbitrary tag starvation problem, and would allow
us to handle timeouts efficiently.
Of course, we don't _have_ such an efficient algorithm; maybe it's time
to have a generic one within the kernel as quite some drivers would
_love_ to just use the generic implementation here.
(qla2xxx, lpfc, fcoe, mpt3sas etc all suffer from the same problem)

> 2. mq vs non-mq performance gain.
> 
> This is more like a poll, I guess. I was wondering what performance gains 
> folks are observing with SCSI MQ on. I saw Christoph H.'s slide deck that 
> has one slide that shows a 200k IOPS gain.
> 
> From my testing, though, I was not lucky to observe that big of a change. 
> In fact, the difference was not even noticeable(*). For e.g., for 512 
> bytes random read test, in both cases, gave me in the vicinity of 2M IOPs. 
> When I say both cases, I meant, one with scsi_mod's use_blk_mq set to 0 
> and another with 1 (LLD is reloaded when it is done). I only used one NUMA 
> node for this run. The test was run on a x86_64 setup.
> 
You _really_ should have listened to my talk at VAULT.
For 'legacy' HBAs there indeed is not much of a performance gain to be
had; the max gain is indeed for heavy parallel I/O.
And there even is a scheduler issue when running with a single
submission thread; there I've measured a performance _drop_ by up to
50%. Which, as Jens claims, really looks like a block-layer issue rather
than a generic problem.


> * See item 3 for a special handling.
> 
> 3. add_random slowness.
> 
> One thing I observed with MQ on and off was this block layer tunable, 
> add_random, which as I understand is to tune disk entropy contribution. 
> With non-MQ, it is turned on, and with MQ, it is turned off by default.
> 
> This got noticed because, when I was running multi-port testing, there was 
> a big drop in IOPs with and without MQ (~200K IOPS to 1M+ IOPs when the 
> test ran on same NUMA node / across NUMA nodes).
> 
> Just wondering why we have it ON on one setting and OFF on another.
> 
> Sorry for the rather long e-mail, but your comments/thoughts are much 
> appreciated.
> 
You definitely want to use the automatic IRQ-affinity patches from
Christoph; that proved to be a major gain in high-performance setups (eg
when running off an all-flash array).

Overall, I'm very much interested in these topics; let's continue with
the discussion to figure out what the best approach here might be.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
