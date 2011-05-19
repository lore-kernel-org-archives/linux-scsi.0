From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [RFC] ib_srpt: initial .40-rc1 drivers/infiniband/ulp/srpt
	merge
Date: Wed, 18 May 2011 23:00:24 -0700
Message-ID: <1305784824.2856.576.camel@haakon2.linux-iscsi.org>
References: <1305682604-21383-1-git-send-email-nab@linux-iscsi.org>
	 <20110518074716.GA8927@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110518074716.GA8927-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rmda <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-05-18 at 03:47 -0400, Christoph Hellwig wrote:
> > +ccflags-y			:= -Idrivers/target
> 
> Why do you need the ccflags?  Everything needed should be under
> include/target, and if not that needs to be fixed.
> 
> > +#include <linux/kthread.h>
> > +#include <linux/string.h>
> > +#include <linux/delay.h>
> > +#include <linux/atomic.h>
> > +#include <scsi/libsas.h> /* TASK_ATTR_* */
> 
> We really need to stop spreading that include.  Care to submit a patch
> for .40 to move the TASK_ATTR_* defines to scsi/scsi.h?
> 

Agreed, this conversion is definately over-due for target-core.

Pushing this change now in lio-4.1 to use scsi_tcq.h for LIO upstream
fabric modules tcm_loop, iscsi-target, tcm_fc, ibmvscsis, qla2xxx,
ib_srpt, and tcm_vhost:

commit 53076ba5838d9653e273c3e43b76fd8220e459a4
Author: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Date:   Wed May 18 22:24:05 2011 -0700

    target: Convert TASK_ATTR to scsi_tcq.h definitions

commit ffee1a685bc083b4c0984230affac6b434b1ea4c
Author: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Date:   Wed May 18 22:41:31 2011 -0700

    ibmvscsis: Convert TASK_ATTR to scsi_tcq.h definitions


I will get this queued against scsi-misc for .40 with tcm_loop+tcm_fc
bits for tomorrow & respin a fresh iscsi-target pull as well.

> > +/**
> > + * srpt_sdev_name() - Return the name associated with the HCA.
> > + *
> > + * Examples are ib0, ib1, ...
> > + */
> > +static inline const char *srpt_sdev_name(struct srpt_device *sdev)
> > +{
> > +	return sdev->device->name;
> > +}
> 
> Does this really need a helper?
> 

Not sure..

> > +
> > +static enum rdma_ch_state srpt_get_ch_state(struct srpt_rdma_ch *ch)
> > +{
> > +	unsigned long flags;
> > +	enum rdma_ch_state state;
> > +
> > +	spin_lock_irqsave(&ch->spinlock, flags);
> > +	state = ch->state;
> > +	spin_unlock_irqrestore(&ch->spinlock, flags);
> > +	return state;
> > +}
> 
> Given that the channel is a 32-bit value taking a lock over reading
> it doesn't help anything.  If you need any kind of exclusion it needs
> to be held over the actual use of it, else it can be dropped.
> 

Mmm, looks like it's safe to drop.  Bart..?

> > +static enum rdma_ch_state
> > +srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new_state)
> > +{
> > +	unsigned long flags;
> > +	enum rdma_ch_state prev;
> > +
> > +	spin_lock_irqsave(&ch->spinlock, flags);
> > +	prev = ch->state;
> > +	ch->state = new_state;
> > +	spin_unlock_irqrestore(&ch->spinlock, flags);
> > +	return prev;
> > +}
> 
> The oly caller of this does a spin_lock_irq so I assume it's from
> process context.  So this one could do the same.  It would be good idea
> to check what kind of action is done from irq context at all and
> document what data structures / critical sections can be access from
> there.
> 

IB folks..?

> > +/**
> > + * srpt_srq_event() - SRQ event callback function.
> > + */
> > +static void srpt_srq_event(struct ib_event *event, void *ctx)
> > +{
> > +	printk(KERN_INFO "SRQ event %d\n", event->event);
> > +}
> 
> Is this overly useful?
> 

IB folks..?

> > +static enum srpt_command_state srpt_get_cmd_state(struct srpt_send_ioctx *ioctx)
> > +{
> > +	enum srpt_command_state state;
> > +	unsigned long flags;
> > +
> > +	BUG_ON(!ioctx);
> > +
> > +	spin_lock_irqsave(&ioctx->spinlock, flags);
> > +	state = ioctx->state;
> > +	spin_unlock_irqrestore(&ioctx->spinlock, flags);
> > +	return state;
> 
> Same comment about reading a variable as above.
> 

Bart..?

> > +/*
> > + * srpt_unpack_lun() - Convert from network LUN to linear LUN.
> > + *
> > + * Convert an 2-byte, 4-byte, 6-byte or 8-byte LUN structure in network byte
> > + * order (big endian) to a linear LUN. Supports three LUN addressing methods:
> > + * peripheral, flat and logical unit. See also SAM-2, section 4.9.4 (page 40).
> > + */
> > +static uint64_t srpt_unpack_lun(const uint8_t *lun, int len)
> 
> Nick, didn't you plan to take the LUN addressing to the core?  After
> all it's not a transport specific format.
> 

Yes, this should be using scsilun_to_int(), but in current mainline code
these is still required to load.  The iscsi-target PATCH-v4 series patch
containing this fix wrt to REPORT_LUNs needs to go into mainline before
this can be fixed..

[PATCH-v4 03/14] target: Convert REPORT_LUNs to use int_to_scsilun
http://marc.info/?l=linux-scsi&m=130561442821080&w=2

Will get this converted in ib_srpt for lio-4.1 for now..

> > +static int srpt_compl_thread(void *arg)
> > +{
> > +	struct srpt_rdma_ch *ch;
> > +
> > +	/* Hibernation / freezing of the SRPT kernel thread is not supported. */
> > +	current->flags |= PF_NOFREEZE;
> > +
> > +	ch = arg;
> > +	BUG_ON(!ch);
> > +	printk(KERN_INFO "Session %s: kernel thread %s (PID %d) started\n",
> > +	       ch->sess_name, ch->thread->comm, current->pid);
> 
> Can we please kill all these verbose printks?  I know the target core
> does them, but that needs to be fixed to.  If you really care for
> debugging you can trivially trace it using the function tracer.
> 

Ugh yes, this still needs to be addressed properly for target core..

> > +	while (!kthread_should_stop()) {
> > +		wait_event_interruptible(ch->wait_queue,
> > +			(srpt_process_completion(ch->cq, ch),
> > +			 kthread_should_stop()));
> > +	}
> 
> Instead of doing a wait_event_interruptible in a kthread you can just
> do a schedule() in interruptible context and use wake_up_process to wake
> it up.
> 

This conversion looks reasonable to me, and will get this resolved for
the next round.

Thanks for your review Christoph!

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
