From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: Oops when completing request on the wrong queue
Date: Tue, 23 Aug 2016 17:54:03 -0300
Message-ID: <87a8g39pg4.fsf@linux.vnet.ibm.com>
References: <87a8gltgks.fsf@linux.vnet.ibm.com>
        <871t1kq455.fsf@linux.vnet.ibm.com>
        <bb6f8757-4c3d-8f49-8aff-aa0fdb8bae89@kernel.dk>
        <8fc9ae38-9488-ef52-f620-08499edebffa@kernel.dk>
        <87shu0hfye.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87shu0hfye.fsf@linux.vnet.ibm.com> (Gabriel Krisman Bertazi's
        message of "Fri, 19 Aug 2016 13:38:17 -0300")
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com> writes:

>> Can you share what you ran to online/offline CPUs? I can't reproduce
>> this here.
>
> I was using the ppc64_cpu tool, which shouldn't do nothing more than
> write to sysfs.  but I just reproduced it with the script below.
>
> Note that this is ppc64le.  I don't have a x86 in hand to attempt to
> reproduce right now, but I'll look for one and see how it goes.

Hi,

Any luck on reproducing it?  We were initially reproducing with a
proprietary stress test, but I gave a try to a generated fio jobfile
associated with the SMT script I shared earlier and I could reproduce
the crash consistently in less than 10 minutes of execution.  this was
still ppc64le, though.  I couldn't get my hands on nvme on x86 yet.

The job file I used, as well as the smt.sh script, in case you want to
give it a try:

jobfile: http://krisman.be/k/nvmejob.fio
smt.sh:  http://krisman.be/k/smt.sh

Still, the trigger seems to be consistently a heavy load of IO
associated with CPU addition/removal.

Let me share my progress from the last couple days in the hope that it
rings a bell for you.

Firstly, I verified that when we hit the BUG_ON in nvme_queue_rq, the
request_queue's freeze_depth is 0, which points away from a fault in the
freeze/unfreeze mechanism.  If a request was escaping and going through
the block layer during a freeze, we'd see freeze_depth >= 1.  Before
that, I had also tried to keep the q_usage_counter in atomic mode, in
case of a bug in the percpu refcount.  No luck, the BUG_ON was still
hit.

Also, I don't see anything special about the request that reaches the
BUG_ON.  It's a REQ_TYPE_FS request and, at least in the last time I
reproduced, it was a READ that came from the stress test task through
submit_bio.  So nothing remarkable about it too, as far as I can see.

I'm still thinking about a case in which the mapping get's screwed up,
where a ctx would appear into two hctxs bitmaps after a remap, or if the
ctx got remaped to another hctx.  I'm still learning my way through the
cpumap code, so I'm not sure it's a real possibility, but I'm not
convinced it isn't.  Some preliminary tests don't suggest it's the case
at play, but I wanna spend a little more time on this theory (maybe
for my lack of better ideas :)

On a side note, probably unrelated to this crash, it also got me
thinking about the current usefulness of blk_mq_hctx_notify.  Since CPU
is dead, no more requests would be coming through its ctx.  I think we
could force a queue run in blk_mq_queue_reinit_notify, before remapping,
which would cause the hctx to fetch the remaining requests from that
dead ctx (since it's not unmapped yet).  This way, we could maintain a
single hotplug notification hook and simplify the hotplug path.  I
haven't written code for it yet, but I'll see if I can come up with
something and send to the list.

-- 
Gabriel Krisman Bertazi

