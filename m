From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Mon, 3 Mar 2003 12:52:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030303125254.A30662@beaverton.ibm.com>
References: <20030228111924.A32018@beaverton.ibm.com> <3E627037.9060809@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E627037.9060809@splentec.com>; from luben@splentec.com on Sun, Mar 02, 2003 at 03:57:27PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Mar 02, 2003 at 03:57:27PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:

> Patrick,
> 
> The idea is good, but scsi core is not there yet.

The patch fixes the problem we currently have when the can_queue limit is
reached, and helps move towards a per scsi_device queue_lock.

I coded it in with the idea of moving towards further separation of
scsi_host versus scsi_device - for example, always decrementing host_busy
when a command completes, but I'm not trying to address other general
issues.

> Here are a few thematical comments:
> 
> 1. How does the comment and name relate to each other?
> 
> struct list_head      pending_queue;   /* software enqueued commands */

> So, please, if this patch were to go in, select a more
> descriptive name.

I'll rename the field to pending_cmd - it is a command that is pending
for this host adapter, and just avoid the q vs queue postfix issue.

> 2. Just think about how much *easier* your patch would be
> if SCSI Core had a ``incoming_cmd_q''?   You could just
> enqueue at the front, while the request fn could enqueue
> at the end.

If we do that, for the current code if we never hit can_queue, then we
would always add to the list and then immediately remove the same command
from the list for further processing.

It would be interesting to use a block request queue for sending commands
to the host adapter, but that is beyond the scope of this patch.

> The thing is that we've added *one more* list_head entry
> to the scsi command struct and this makes tracking of
> scsi commands harder.  (Active command cancelling, vs.
> passive command cancelling.)
> 
> If it were up to me, the scsi command struct would have
> *only one* list_head entry, which would be used from
> its instantiation to its being freed, in which case
> the command gets back to the free list or the slab,
> and thus you get a closed logical loop.

The list_head is there because of how we are implementing the lists or
queueing - we could create a list of scsi_cmnd's that does not require a
separate field within scsi_cmnd.

We can combine the scsi_cmnd list_head pending with the eh_entry, if there
is agreement that a smaller scsi_cmnd is worth the list_head overloading.

> > +		scmd = list_entry(shost->pending_queue.next, struct scsi_cmnd,
> > +				  pending_queue);
> > +		list_del_init(&scmd->pending_queue);
> 
> 
> Out of principle (99.9% of everything I write/post), I don't like
> seeing an object yanked out of a queue list just to belong to
> ``ether-space''.
> 
> Such logical changes, as your patch warrants, dictate
> that a command is to move from queue to queue, as its state/owner
> changes.  Actually its state *is* its owner and vice versa.

This is not a queue of commands for the host adapter to process, it is a
queue of commands the host adapter will be sent in the future, so we are
either on the queue, or not on the queue.

> > -int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt)
> > +int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt, int resend)
> 
> 
> Oh, boy!
> 
> More complication!  Why do you need to change the prototype
> for the dispatch fn?  (Rhetorical.)
> 
> Because the rest of the infrastructure of SCSI Core is not
> up to date to your patch-idea?

Slightly, but even so it nice to have some sort of priority for the
scsi_cmnd, and a resend can imply higher priority.

> > +static void scsi_eh_flush_pending_q(struct list_head *pending_q)
> > +{
> > +	struct list_head *lh, *lh_sf;
> > +	struct scsi_cmnd *scmd;
> > +
> > +	list_for_each_safe(lh, lh_sf, pending_q) {
> > +		scmd = list_entry(lh, struct scsi_cmnd, pending_queue);
> > +		list_del_init(lh);
> > +		if (scmd->device->online) {
> > +			SCSI_LOG_ERROR_RECOVERY(3, 
> > +				printk("%s: flush pending cmd: %p\n",
> > +				       current->comm, scmd));
> > +			scsi_queue_insert(scmd, SCSI_MLQUEUE_PENDING);
> > +		} else {
> > +			scmd->result |= (DRIVER_TIMEOUT << 24);
> > +			SCSI_LOG_ERROR_RECOVERY(3,
> > +				printk("%s: finish pending cmd: %p\n",
> > +				       current->comm, scmd));
> > +			scsi_finish_command(scmd);
> > +		}
> > +	}
> > +}
> 
> 
> No.  I don't like it (from logical point of view of course).
> This will get too tricky as the device could be in many more
> states, then you'll have the burden of deciding what to
> do with the commands...
> 
> Decisions of what should be done with a command should
> be centralized in a single function.

I generally do not like having two lists that we must flush, but I don't
have a simpler idea that works within the context of the current code.

-- Patrick Mansfield
