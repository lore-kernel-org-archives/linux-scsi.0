From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt merge
Date: Wed, 18 May 2011 03:47:16 -0400
Message-ID: <20110518074716.GA8927@infradead.org>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-rmda <linux-rdma@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Vu Pham <vu@mellanox.com>, David Dillow <dillowda@ornl.gov>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

> +ccflags-y			:= -Idrivers/target

Why do you need the ccflags?  Everything needed should be under
include/target, and if not that needs to be fixed.

> +#include <linux/kthread.h>
> +#include <linux/string.h>
> +#include <linux/delay.h>
> +#include <linux/atomic.h>
> +#include <scsi/libsas.h> /* TASK_ATTR_* */

We really need to stop spreading that include.  Care to submit a patch
for .40 to move the TASK_ATTR_* defines to scsi/scsi.h?

> +/**
> + * srpt_sdev_name() - Return the name associated with the HCA.
> + *
> + * Examples are ib0, ib1, ...
> + */
> +static inline const char *srpt_sdev_name(struct srpt_device *sdev)
> +{
> +	return sdev->device->name;
> +}

Does this really need a helper?

> +
> +static enum rdma_ch_state srpt_get_ch_state(struct srpt_rdma_ch *ch)
> +{
> +	unsigned long flags;
> +	enum rdma_ch_state state;
> +
> +	spin_lock_irqsave(&ch->spinlock, flags);
> +	state = ch->state;
> +	spin_unlock_irqrestore(&ch->spinlock, flags);
> +	return state;
> +}

Given that the channel is a 32-bit value taking a lock over reading
it doesn't help anything.  If you need any kind of exclusion it needs
to be held over the actual use of it, else it can be dropped.

> +static enum rdma_ch_state
> +srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new_state)
> +{
> +	unsigned long flags;
> +	enum rdma_ch_state prev;
> +
> +	spin_lock_irqsave(&ch->spinlock, flags);
> +	prev = ch->state;
> +	ch->state = new_state;
> +	spin_unlock_irqrestore(&ch->spinlock, flags);
> +	return prev;
> +}

The oly caller of this does a spin_lock_irq so I assume it's from
process context.  So this one could do the same.  It would be good idea
to check what kind of action is done from irq context at all and
document what data structures / critical sections can be access from
there.

> +/**
> + * srpt_srq_event() - SRQ event callback function.
> + */
> +static void srpt_srq_event(struct ib_event *event, void *ctx)
> +{
> +	printk(KERN_INFO "SRQ event %d\n", event->event);
> +}

Is this overly useful?

> +static enum srpt_command_state srpt_get_cmd_state(struct srpt_send_ioctx *ioctx)
> +{
> +	enum srpt_command_state state;
> +	unsigned long flags;
> +
> +	BUG_ON(!ioctx);
> +
> +	spin_lock_irqsave(&ioctx->spinlock, flags);
> +	state = ioctx->state;
> +	spin_unlock_irqrestore(&ioctx->spinlock, flags);
> +	return state;

Same comment about reading a variable as above.

> +/*
> + * srpt_unpack_lun() - Convert from network LUN to linear LUN.
> + *
> + * Convert an 2-byte, 4-byte, 6-byte or 8-byte LUN structure in network byte
> + * order (big endian) to a linear LUN. Supports three LUN addressing methods:
> + * peripheral, flat and logical unit. See also SAM-2, section 4.9.4 (page 40).
> + */
> +static uint64_t srpt_unpack_lun(const uint8_t *lun, int len)

Nick, didn't you plan to take the LUN addressing to the core?  After
all it's not a transport specific format.

> +static int srpt_compl_thread(void *arg)
> +{
> +	struct srpt_rdma_ch *ch;
> +
> +	/* Hibernation / freezing of the SRPT kernel thread is not supported. */
> +	current->flags |= PF_NOFREEZE;
> +
> +	ch = arg;
> +	BUG_ON(!ch);
> +	printk(KERN_INFO "Session %s: kernel thread %s (PID %d) started\n",
> +	       ch->sess_name, ch->thread->comm, current->pid);

Can we please kill all these verbose printks?  I know the target core
does them, but that needs to be fixed to.  If you really care for
debugging you can trivially trace it using the function tracer.

> +	while (!kthread_should_stop()) {
> +		wait_event_interruptible(ch->wait_queue,
> +			(srpt_process_completion(ch->cq, ch),
> +			 kthread_should_stop()));
> +	}

Instead of doing a wait_event_interruptible in a kthread you can just
do a schedule() in interruptible context and use wake_up_process to wake
it up.

> +#include <linux/version.h>

Shouldn't be needed.

> +static inline u64 encode_wr_id(u8 opcode, u32 idx)
> +{ return ((u64)opcode << 32) | idx; }
> +static inline u8 opcode_from_wr_id(u64 wr_id)
> +{ return wr_id >> 32; }
> +static inline u32 idx_from_wr_id(u64 wr_id)
> +{ return (u32)wr_id; }

Please fix the indentation.
