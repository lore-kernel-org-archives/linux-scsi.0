From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Tue, 17 Jan 2017 17:38:54 +0200
Message-ID: <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------8E993426968224977B847C9F"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34809 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdAQPrw (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 10:47:52 -0500
In-Reply-To: <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Johannes Thumshirn <jthumshirn@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: linux-block@vger.kernel.org, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>

This is a multi-part message in MIME format.
--------------8E993426968224977B847C9F
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

Hey, so I made some initial analysis of whats going on with
irq-poll.

First, I sampled how much time it takes before we
get the interrupt in nvme_irq and the initial visit
to nvme_irqpoll_handler. I ran a single threaded fio
with QD=32 of 4K reads. This is two displays of a
histogram of the latency (ns):
--
[1]
queue = b'nvme0q1'
      usecs               : count     distribution
          0 -> 1          : 7310 
|****************************************|
          2 -> 3          : 11       | 
      |
          4 -> 7          : 10       | 
      |
          8 -> 15         : 20       | 
      |
         16 -> 31         : 0        | 
      |
         32 -> 63         : 0        | 
      |
         64 -> 127        : 1        | 
      |

[2]
queue = b'nvme0q1'
      usecs               : count     distribution
          0 -> 1          : 7309 
|****************************************|
          2 -> 3          : 14       | 
      |
          4 -> 7          : 7        | 
      |
          8 -> 15         : 17       | 
      |

We can see that most of the time our latency is pretty good (<1ns) but with
huge tail latencies (some 8-15 ns and even one in 32-63 ns).
**NOTE, in order to reduce the tracing impact on performance I sampled
for every 100 interrupts.

I also sampled for a multiple threads/queues with QD=32 of 4K reads.
This is a collection of histograms for 5 queues (5 fio threads):
queue = b'nvme0q1'
      usecs               : count     distribution
          0 -> 1          : 701 
|****************************************|
          2 -> 3          : 177      |********** 
      |
          4 -> 7          : 56       |*** 
      |
          8 -> 15         : 24       |* 
      |
         16 -> 31         : 6        | 
      |
         32 -> 63         : 1        | 
      |

queue = b'nvme0q2'
      usecs               : count     distribution
          0 -> 1          : 412 
|****************************************|
          2 -> 3          : 52       |***** 
      |
          4 -> 7          : 19       |* 
      |
          8 -> 15         : 13       |* 
      |
         16 -> 31         : 5        | 
      |

queue = b'nvme0q3'
      usecs               : count     distribution
          0 -> 1          : 381 
|****************************************|
          2 -> 3          : 74       |******* 
      |
          4 -> 7          : 26       |** 
      |
          8 -> 15         : 12       |* 
      |
         16 -> 31         : 3        | 
      |
         32 -> 63         : 0        | 
      |
         64 -> 127        : 0        | 
      |
        128 -> 255        : 1        | 
      |

queue = b'nvme0q4'
      usecs               : count     distribution
          0 -> 1          : 386 
|****************************************|
          2 -> 3          : 63       |****** 
      |
          4 -> 7          : 30       |*** 
      |
          8 -> 15         : 11       |* 
      |
         16 -> 31         : 7        | 
      |
         32 -> 63         : 1        | 
      |

queue = b'nvme0q5'
      usecs               : count     distribution
          0 -> 1          : 384 
|****************************************|
          2 -> 3          : 69       |******* 
      |
          4 -> 7          : 25       |** 
      |
          8 -> 15         : 15       |* 
      |
         16 -> 31         : 3        | 
      |

Overall looks pretty much the same but some more samples with tails...

Next, I sampled how many completions we are able to consume per interrupt.
Two exaples of histograms of how many completions we take per interrupt.
--
queue = b'nvme0q1'
      completed     : count     distribution
         0          : 0        |                                        |
         1          : 11690    |****************************************|
         2          : 46       |                                        |
         3          : 1        |                                        |

queue = b'nvme0q1'
      completed     : count     distribution
         0          : 0        |                                        |
         1          : 944      |****************************************|
         2          : 8        |                                        |
--

So it looks like we are super not efficient because most of the times we 
catch 1
completion per interrupt and the whole point is that we need to find 
more! This fio
is single threaded with QD=32 so I'd expect that we be somewhere in 8-31 
almost all
the time... I also tried QD=1024, histogram is still the same.
**NOTE: Here I also sampled for every 100 interrupts.


I'll try to run the counter on the current nvme driver and see what I get.



I attached the bpf scripts I wrote (nvme-trace-irq, nvme-count-comps)
with hope that someone is interested enough to try and reproduce these
numbers on his/hers setup and maybe suggest some other useful tracing
we can do.

Prerequisites:
1. iovisor is needed for python bpf support.
   $ echo "deb [trusted=yes] https://repo.iovisor.org/apt/xenial 
xenial-nightly main" | sudo tee /etc/apt/sources.list.d/iovisor.list
   $ sudo apt-get update -y
   $ sudo apt-get install bcc-tools -y
   # Nastty hack .. bcc only available in python2 but copliant with 
python3..
   $ sudo cp -r /usr/lib/python2.7/dist-packages/bcc 
/usr/lib/python3/dist-packages/

2. Because we don't have the nvme-pci symbols exported, The nvme.h file 
is needed on the
    test machine (where the bpf code is running). I used nfs mount for 
the linux source (this
    is why I include from /mnt/linux in the scripts).


--------------8E993426968224977B847C9F
Content-Type: text/plain; charset=UTF-8;
 name="nvme-count-comps"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nvme-count-comps"

#!/usr/bin/python3
# @lint-avoid-python-3-compatibility-imports

from __future__ import print_function
from bcc import BPF
from time import sleep, strftime
import argparse

# arguments
examples = """examples:
    ./nvme_comp_cout            # summarize interrupt->irqpoll latency as a histogram
    ./nvme_comp_cout 1 10       # print 1 second summaries, 10 times
    ./nvme_comp_cout -mT 1      # 1s summaries, milliseconds, and timestamps
    ./nvme_comp_cout -Q         # show each nvme queue device separately
"""
parser = argparse.ArgumentParser(
    description="Summarize block device I/O latency as a histogram",
    formatter_class=argparse.RawDescriptionHelpFormatter,
    epilog=examples)
parser.add_argument("-T", "--timestamp", action="store_true",
    help="include timestamp on output")
parser.add_argument("-m", "--milliseconds", action="store_true",
    help="millisecond histogram")
parser.add_argument("-Q", "--queues", action="store_true",
    help="print a histogram per queue")
parser.add_argument("--freq", help="Account every N-th request",
    type=int, required=False)
parser.add_argument("interval", nargs="?", default=2,
    help="output interval, in seconds")
parser.add_argument("count", nargs="?", default=99999999,
    help="number of outputs")
args = parser.parse_args()
countdown = int(args.count)
debug = 0

# define BPF program
bpf_text = """
#include <uapi/linux/ptrace.h>
/*****************************************************************
 * Nasty hack because we don't have the nvme-pci structs exported
 *****************************************************************/
#include <linux/aer.h>
#include <linux/bitops.h>
#include <linux/blkdev.h>
#include <linux/blk-mq.h>
#include <linux/blk-mq-pci.h>
#include <linux/cpu.h>
#include <linux/delay.h>
#include <linux/errno.h>
#include <linux/fs.h>
#include <linux/genhd.h>
#include <linux/hdreg.h>
#include <linux/idr.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/io.h>
#include <linux/kdev_t.h>
#include <linux/kernel.h>
#include <linux/mm.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/mutex.h>
#include <linux/pci.h>
#include <linux/poison.h>
#include <linux/ptrace.h>
#include <linux/sched.h>
#include <linux/slab.h>
#include <linux/t10-pi.h>
#include <linux/timer.h>
#include <linux/types.h>
#include <linux/io-64-nonatomic-lo-hi.h>
#include <asm/unaligned.h>
#include <linux/irq_poll.h>
#include "/mnt/linux/drivers/nvme/host/nvme.h"

struct nvme_dev;
struct nvme_queue;
/*
 * Represents an NVM Express device.  Each nvme_dev is a PCI function.
 */
struct nvme_dev {
	struct nvme_queue **queues;
	struct blk_mq_tag_set tagset;
	struct blk_mq_tag_set admin_tagset;
	u32 __iomem *dbs;
	struct device *dev;
	struct dma_pool *prp_page_pool;
	struct dma_pool *prp_small_pool;
	unsigned queue_count;
	unsigned online_queues;
	unsigned max_qid;
	int q_depth;
	u32 db_stride;
	void __iomem *bar;
	struct work_struct reset_work;
	struct work_struct remove_work;
	struct timer_list watchdog_timer;
	struct mutex shutdown_lock;
	bool subsystem;
	void __iomem *cmb;
	dma_addr_t cmb_dma_addr;
	u64 cmb_size;
	u32 cmbsz;
	u32 cmbloc;
	struct nvme_ctrl ctrl;
	struct completion ioq_wait;
};

/*
 * An NVM Express queue.  Each device has at least two (one for admin
 * commands and one for I/O commands).
 */
struct nvme_queue {
	struct device *q_dmadev;
	struct nvme_dev *dev;
	char irqname[24];
	spinlock_t sq_lock;
	spinlock_t cq_lock;
	struct nvme_command *sq_cmds;
	struct nvme_command __iomem *sq_cmds_io;
	volatile struct nvme_completion *cqes;
	struct blk_mq_tags **tags;
	dma_addr_t sq_dma_addr;
	dma_addr_t cq_dma_addr;
	u32 __iomem *q_db;
	u16 q_depth;
	s16 cq_vector;
	u16 sq_tail;
	u16 cq_head;
	u16 qid;
	u8 cq_phase;
	struct irq_poll	iop;
};

typedef struct queue_key {
    char queue[24];
    u64 slot;
} queue_key_t;

/* Completion counter context */
struct nvmeq {
    struct nvme_queue *q;
    u64 completed;
};

BPF_TABLE("percpu_array", int, struct nvmeq, qarr, 1);
BPF_TABLE("percpu_array", int, int, call_count, 1);
STORAGE

/* trace nvme interrupt */
int trace_interrupt_start(struct pt_regs *ctx, int irq, void *data)
{
    __CALL__COUNT__FILTER__

    struct nvmeq q ={};
    int index = 0;

    q.q = data;
    q.completed = 0; /* reset completions */

    qarr.update(&index, &q);
    return 0;
}

/* count completed on each irqpoll end */
int trace_irqpoll_end(struct pt_regs *ctx)
{
    __CALL__COUNT__FILTER__

    struct nvmeq zero = {};
    int index = 0;
    struct nvmeq *q;
    int completed = ctx->ax;

    q = qarr.lookup_or_init(&index, &zero);
    if (q == NULL) {
	goto out;
    }

    q->completed += completed;
    /* No variables in kretprobe :( 64 is our budget */
    if (completed < 64) {
        /* store as histogram */
        STORE
        q->completed = 0;
    }

out:
    return 0;
}
"""

call_count_filter = """
{
    int zero = 0;
    int index =0;
    int *skip;

    skip = call_count.lookup_or_init(&index, &zero);

    if ((*skip) < %d) {
        (*skip)++;
        return 0;
    }
    (*skip) = 0;
}
"""

# code substitutions
if args.queues:
    bpf_text = bpf_text.replace('STORAGE',
        'BPF_HISTOGRAM(dist, queue_key_t);')
    bpf_text = bpf_text.replace('STORE',
        'queue_key_t key = {.slot = q->completed}; ' +
        'bpf_probe_read(&key.queue, sizeof(key.queue), ' +
        'q->q->irqname); dist.increment(key);')
else:
    bpf_text = bpf_text.replace('STORAGE', 'BPF_HISTOGRAM(dist);')
    bpf_text = bpf_text.replace('STORE',
        'dist.increment(q->completed);')

bpf_text = bpf_text.replace("__CALL__COUNT__FILTER__", call_count_filter % (args.freq - 1) if args.freq is not None else "")
if debug:
    print(bpf_text)


# load BPF program
b = BPF(text=bpf_text)
b.attach_kprobe(event="nvme_irq", fn_name="trace_interrupt_start")
b.attach_kretprobe(event="nvme_irqpoll_handler", fn_name="trace_irqpoll_end")

print("Tracing nvme I/O interrupt/irqpoll... Hit Ctrl-C to end.")

# output
exiting = 0 if args.interval else 1
dist = b.get_table("dist")
while (1):
    try:
        sleep(int(args.interval))
    except KeyboardInterrupt:
        exiting = 1

    print()
    if args.timestamp:
        print("%-8s\n" % strftime("%H:%M:%S"), end="")

    dist.print_linear_hist("completed", "queue")
    dist.clear()

    countdown -= 1
    if exiting or countdown == 0:
        exit()

--------------8E993426968224977B847C9F
Content-Type: text/plain; charset=UTF-8;
 name="nvme-trace-irq"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nvme-trace-irq"

#!/usr/bin/python3
# @lint-avoid-python-3-compatibility-imports

from __future__ import print_function
from bcc import BPF
from time import sleep, strftime
import argparse

# arguments
examples = """examples:
    ./nvmetrace            # summarize interrupt->irqpoll latency as a histogram
    ./nvmetrace 1 10       # print 1 second summaries, 10 times
    ./nvmetrace -mT 1      # 1s summaries, milliseconds, and timestamps
    ./nvmetrace -Q         # show each nvme queue device separately
"""
parser = argparse.ArgumentParser(
    description="Summarize interrupt to softirq latency as a histogram",
    formatter_class=argparse.RawDescriptionHelpFormatter,
    epilog=examples)
parser.add_argument("-T", "--timestamp", action="store_true",
    help="include timestamp on output")
parser.add_argument("-m", "--milliseconds", action="store_true",
    help="millisecond histogram")
parser.add_argument("-Q", "--queues", action="store_true",
    help="print a histogram per queue")
parser.add_argument("--freq", help="Account every N-th request", type=int, required=False)
parser.add_argument("interval", nargs="?", default=2,
    help="output interval, in seconds")
parser.add_argument("count", nargs="?", default=99999999,
    help="number of outputs")
args = parser.parse_args()
countdown = int(args.count)
debug = 0

# define BPF program
bpf_text = """
#include <uapi/linux/ptrace.h>
/*****************************************************************
 * Nasty hack because we don't have the nvme-pci structs exported
 *****************************************************************/
#include <linux/aer.h>
#include <linux/bitops.h>
#include <linux/blkdev.h>
#include <linux/blk-mq.h>
#include <linux/blk-mq-pci.h>
#include <linux/cpu.h>
#include <linux/delay.h>
#include <linux/errno.h>
#include <linux/fs.h>
#include <linux/genhd.h>
#include <linux/hdreg.h>
#include <linux/idr.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/io.h>
#include <linux/kdev_t.h>
#include <linux/kernel.h>
#include <linux/mm.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/mutex.h>
#include <linux/pci.h>
#include <linux/poison.h>
#include <linux/ptrace.h>
#include <linux/sched.h>
#include <linux/slab.h>
#include <linux/t10-pi.h>
#include <linux/timer.h>
#include <linux/types.h>
#include <linux/io-64-nonatomic-lo-hi.h>
#include <asm/unaligned.h>
#include <linux/irq_poll.h>

/* location of nvme.h */
#include "/mnt/linux/drivers/nvme/host/nvme.h"

struct nvme_dev;
struct nvme_queue;
/*
 * Represents an NVM Express device.  Each nvme_dev is a PCI function.
 */
struct nvme_dev {
	struct nvme_queue **queues;
	struct blk_mq_tag_set tagset;
	struct blk_mq_tag_set admin_tagset;
	u32 __iomem *dbs;
	struct device *dev;
	struct dma_pool *prp_page_pool;
	struct dma_pool *prp_small_pool;
	unsigned queue_count;
	unsigned online_queues;
	unsigned max_qid;
	int q_depth;
	u32 db_stride;
	void __iomem *bar;
	struct work_struct reset_work;
	struct work_struct remove_work;
	struct timer_list watchdog_timer;
	struct mutex shutdown_lock;
	bool subsystem;
	void __iomem *cmb;
	dma_addr_t cmb_dma_addr;
	u64 cmb_size;
	u32 cmbsz;
	u32 cmbloc;
	struct nvme_ctrl ctrl;
	struct completion ioq_wait;
};

/*
 * An NVM Express queue.  Each device has at least two (one for admin
 * commands and one for I/O commands).
 */
struct nvme_queue {
	struct device *q_dmadev;
	struct nvme_dev *dev;
	char irqname[24];
	spinlock_t sq_lock;
	spinlock_t cq_lock;
	struct nvme_command *sq_cmds;
	struct nvme_command __iomem *sq_cmds_io;
	volatile struct nvme_completion *cqes;
	struct blk_mq_tags **tags;
	dma_addr_t sq_dma_addr;
	dma_addr_t cq_dma_addr;
	u32 __iomem *q_db;
	u16 q_depth;
	s16 cq_vector;
	u16 sq_tail;
	u16 cq_head;
	u16 qid;
	u8 cq_phase;
	struct irq_poll	iop;
};

typedef struct queue_key {
    char queue[24];
    u64 slot;
} queue_key_t;

BPF_HASH(start, struct nvme_queue *);
BPF_TABLE("percpu_array", int, int, call_count, 1);
STORAGE

/* timestamp nvme interrupt */
int trace_interrupt_start(struct pt_regs *ctx, int irq, void *data)
{
    __CALL__COUNT__FILTER__

    struct nvme_queue *q = data;
    u64 ts = bpf_ktime_get_ns();
    start.update(&q, &ts);
    return 0;
}

/* timestamp nvme irqpoll */
int trace_irqpoll_start(struct pt_regs *ctx, struct irq_poll *iop, int budget)
{
    struct nvme_queue *q = container_of(iop, struct nvme_queue, iop);
    u64 *tsp, delta;

    /* fetch timestamp and calculate delta */
    tsp = start.lookup(&q);
    if (tsp == 0) {
        return 0;   /* missed issue */
    }
    delta = bpf_ktime_get_ns() - *tsp;
    FACTOR

    /* store as histogram */
    STORE
    start.delete(&q);

    return 0;
}
"""

# code substitutions
call_count_filter = """
{
    int zero = 0;
    int index =0;
    int *skip;

    skip = call_count.lookup_or_init(&index, &zero);

    if ((*skip) < %d) {
        (*skip)++;
        return 0;
    }
    (*skip) = 0;
}
"""

if args.milliseconds:
    bpf_text = bpf_text.replace('FACTOR', 'delta /= 1000000;')
    label = "msecs"
else:
    bpf_text = bpf_text.replace('FACTOR', 'delta /= 1000;')
    label = "usecs"
if args.queues:
    bpf_text = bpf_text.replace('STORAGE',
        'BPF_HISTOGRAM(dist, queue_key_t);')
    bpf_text = bpf_text.replace('STORE',
        'queue_key_t key = {.slot = bpf_log2l(delta)}; ' +
        'bpf_probe_read(&key.queue, sizeof(key.queue), ' +
        'q->irqname); dist.increment(key);')
else:
    bpf_text = bpf_text.replace('STORAGE', 'BPF_HISTOGRAM(dist);')
    bpf_text = bpf_text.replace('STORE',
        'dist.increment(bpf_log2l(delta));')

bpf_text = bpf_text.replace("__CALL__COUNT__FILTER__", call_count_filter % (args.freq - 1) if args.freq is not None else "")
if debug:
    print(bpf_text)

# load BPF program
b = BPF(text=bpf_text)
b.attach_kprobe(event="nvme_irq", fn_name="trace_interrupt_start")
b.attach_kprobe(event="nvme_irqpoll_handler", fn_name="trace_irqpoll_start")

print("Tracing nvme I/O interrupt/irqpoll... Hit Ctrl-C to end.")

# output
exiting = 0 if args.interval else 1
dist = b.get_table("dist")
while (1):
    try:
        sleep(int(args.interval))
    except KeyboardInterrupt:
        exiting = 1

    print()
    if args.timestamp:
        print("%-8s\n" % strftime("%H:%M:%S"), end="")

    dist.print_log2_hist(label, "queue")
    dist.clear()

    countdown -= 1
    if exiting or countdown == 0:
        exit()

--------------8E993426968224977B847C9F--
