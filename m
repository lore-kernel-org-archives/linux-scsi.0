From: Ming Lei <ming.lei@redhat.com>
Subject: [LSF/MM TOPIC] Two blk-mq related topics
Date: Mon, 29 Jan 2018 23:46:09 +0800
Message-ID: <20180129154455.GB17176@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org, Linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Hi guys,

Two blk-mq related topics

1. blk-mq vs. CPU hotplug & IRQ vectors spread on CPUs

We have done three big changes in this field before, each time some issues
are fixed, meantime new ones are introduced

1) freeze all queues during CPU hotplug handler
- issues: queue dependency such as loop-mq/dm vs underlying queues, NVMe admin
queue vs. namespace queues, and IO hang may be caused during freezing all
these queues in CPU hotplug handler.

2) IRQ vectors spread on all present CPUs
- fix issue on 1)
- new issues introduced: don't support CPU hotplug physically, and cause blk-mq
warning during dispatch

3) IRQ vectors spread on all possible CPUs
- can support CPU hotplug physically
- warning in __blk_mq_run_hw_queue() still may be triggered if CPU
  offline/online happens between blk_mq_hctx_next_cpu() and running
   __blk_mq_run_hw_queue()
- new issues introduced: queue mapping may be distorted completely,
patch sent out(https://marc.info/?t=151603230900002&r=1&w=2), but may
need further discussion about this approach; drivers(such as NVMe) may
need to pass 'num_possible_cpus()' as the max vectors for allocating
irq vectors; some drivers(NVMe) uses hard-code hw queue index directly,
then this way becomes very fragile, since the hw queue may be inactive
from the beginning.

Also starting from 2), another issue is that IO completion may not be
delivered to CPUs, for example, IO may be dispatched to hw queue just
before(or after) all CPUs mapped to the hctx become offline, then IRQ
vector of the hw queue can be shutdown. Now seems we depend on timeout
handler to deal with the situation, and is there better way to solve this
issue?

2. When to enable SCSI_MQ at default again?

SCSI_MQ is enabled on V3.17 firstly, but disabled at default. In V4.13-rc1,
it is enabled at default, but later the patch is reverted in V4.13-rc7, and
becomes disabled at default too.

Now both the original reported PM issue(actually SCSI quiesce) and the
sequential IO performance issue have been addressed. And MQ IO schedulers
are ready too for traditional disks. Are there other issues to be addressed
for enabling SCSI_MQ at default? When can we do that again?

Last time, the two issues were reported during V4.13 dev cycle just when it is
enabled at default, that seems if SCSI_MQ isn't enabled at default, it wouldn't
be exposed to run/tested completely & fully.  

So if we continue to disable it at default, maybe it can never be exposed to
full test/production environment.


Thanks,
Ming
