From: Luben Tuikov <luben@splentec.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Sun, 02 Mar 2003 15:57:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E627037.9060809@splentec.com>
References: <20030228111924.A32018@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030228111924.A32018@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Hi -
> 
> Any comments or suggestions on the following patch?

Patrick,

The idea is good, but scsi core is not there yet.

Here are a few thematical comments:

1. How does the comment and name relate to each other?

struct list_head      pending_queue;   /* software enqueued commands */

Looking at how this queue is used, a proper name would
be something like ``deferred_cmd_q'', since those are
indeed _deferred_ commands because the host were busy...

I also prefer the prefix ``_cmd_q'' since it describes
that it is a _command queue_, and phonetically ``q''
*is* ``queue'', thus there's no reason to spell it out
in variable names.  But I don't have problems with
a prefix of ``_q'', as well, which is what I've used
myself.

In general, let's not use names like ``pending'' and
``siblings'' just because they sound cool or Knuth
or some paper uses them, and let us be more descriptive.

When I mentioned ``pending_q'' from my own mini-scsi-core,
I also mentioned its use, here you seem to be using the
name for a different purpose.

A subsystem, like SCSI Core, should name the variables
*from its own point of view*.  I.e. things like:
incoming_cmd_q, pending_cmd_q, done_cmd_q, for
incoming commands from ULP, pending commands for execution
status (i.e. for which queuecommand() were called), and
done commands, i.e. for which a LLDD has called scsi_done().

You see, the commands in all these hypothetical queues (but
representative of the state of a scsi command from SCSI Core's
point of view), are all *pending*.  The first queue, pending to
be submitted to a LLDD, the second queue, pending execution
status, and the third, pending to be returned to ULP.

So, please, if this patch were to go in, select a more
descriptive name.

(Descriptive names are a limited resource -- let's use
them wisely.)


2. Just think about how much *easier* your patch would be
if SCSI Core had a ``incoming_cmd_q''?   You could just
enqueue at the front, while the request fn could enqueue
at the end.

As I said, the idea is good (long overdue), but SCSI Core
is not there yet, unless its whole internal queueing mechanism
is overhauled (my beef for the last 1.5 years now).

The thing is that we've added *one more* list_head entry
to the scsi command struct and this makes tracking of
scsi commands harder.  (Active command cancelling, vs.
passive command cancelling.)

If it were up to me, the scsi command struct would have
*only one* list_head entry, which would be used from
its instantiation to its being freed, in which case
the command gets back to the free list or the slab,
and thus you get a closed logical loop.

Tiny comments of logical nature inlined, and general
comment at the bottom:
 
> Patch is against scsi-misc-2.5.
> 
> I'm trying to break split queue_lock into a per scsi_device lock, and the
> starved code is in the way, plus it is not fair and looks like it has a
> couple of bugs. I started by trying to add a queue of request queues plus
> throttling to the current "starved" algorithm, but it was not too clean,
> so instead implemented this software enqueueing when the host can_queue
> limit is reached.
> 
> This can use more resources (scsi_cmnd's) if the sum of queue_depths on a
> host is greater than can_queue, but it is fairer (when not all devices are
> hitting queue_depth limits, or if we had throttling with a throttling
> limit of 1) and simpler compared to using a queue of queues (or code
> similiar to the current starvation code).
> 
> This also includes moving self_host_blocked checks (on self host unblock
> we run all queues so there is never a "starvation" issue), and chaning
> some of the mlqueue log levels so we do not get flooded with tons of
> message for "scsi log mlqueue 4".
> 
> Tested using the feral qla driver, with 10 drives on a host, queue_depth
> set to 16, and can_queue set to 100.
> 
> 
>  hosts.c      |   70 +++++++++++++++++++++++++++++++++++++++++++-----
>  hosts.h      |   12 +-------
>  scsi.c       |   69 +++++++++++++++++++++++++++++------------------
>  scsi.h       |    9 +++---
>  scsi_error.c |   51 +++++++++++++++++++++++++++++------
>  scsi_lib.c   |   85 ++++++++++++++++++++---------------------------------------
>  6 files changed, 182 insertions(+), 114 deletions(-)
> 
> 
> ===== drivers/scsi/hosts.c 1.54 vs edited =====
> --- 1.54/drivers/scsi/hosts.c	Sun Feb 23 10:34:55 2003
> +++ edited/drivers/scsi/hosts.c	Thu Feb 27 16:21:09 2003
> @@ -383,6 +383,7 @@
>  	scsi_assign_lock(shost, &shost->default_lock);
>  	INIT_LIST_HEAD(&shost->my_devices);
>  	INIT_LIST_HEAD(&shost->eh_cmd_q);
> +	INIT_LIST_HEAD(&shost->pending_queue);
>  
>  	init_waitqueue_head(&shost->host_wait);
>  	shost->dma_channel = 0xff;
> @@ -613,19 +614,72 @@
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  }
>  
> +void scsi_host_send_pending (struct Scsi_Host *shost)
> +{
> +	struct scsi_cmnd *scmd;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	while (!shost->host_self_blocked
> +	       && !list_empty(&shost->pending_queue)) {
> +		/*
> +		 * list_for_each_safe is not safe here, since after the
> +		 * unlock someone else can remove the scmd after the one
> +		 * we are pulling off the list.
> +		 */
> +		scmd = list_entry(shost->pending_queue.next, struct scsi_cmnd,
> +				  pending_queue);
> +		list_del_init(&scmd->pending_queue);


Out of principle (99.9% of everything I write/post), I don't like
seeing an object yanked out of a queue list just to belong to
``ether-space''.

Such logical changes, as your patch warrants, dictate
that a command is to move from queue to queue, as its state/owner
changes.  Actually its state *is* its owner and vice versa.


> +		SCSI_LOG_MLQUEUE(3,
> +			printk("%s: removed from pending cmd: 0x%lx\n",
> +			       __FUNCTION__, scmd->serial_number));
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		if (scsi_dispatch_cmd(scmd, 0))
> +			/*
> +			 * Device hit host_blocked, or (race case)
> +			 * can_queue limit was reached.
> +			 */
> +			goto unlocked;
> +		spin_lock_irqsave(shost->host_lock, flags);
> +	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +unlocked:
> +}


That ``goto unlocked'' is one more reason that the host lock
should just go *and* queuecommand() should be void...


> +
>  void scsi_host_busy_dec_and_test(struct Scsi_Host *shost, Scsi_Device *sdev)


Anything named ``xxx_dec_and_test'', had better *RETURN* the result
of the dec_and_test.  So either, rename this function or change
is prototype to an integral type.


>  {
>  	unsigned long flags;
> +	struct scsi_cmnd *scmd;
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> +	/*
> +	 * If broken adapters are ever fixed or go away (at least qlogicfc
> +	 * and qlogicisp):
> +	 *
> +	 * WARN_ON(shost->host_busy > shost->can_queue);
> +	 */
>  	shost->host_busy--;
>  	sdev->device_busy--;
> -	if (shost->in_recovery && shost->host_failed &&
> -	    (shost->host_busy == shost->host_failed))
> -	{
> -		up(shost->eh_wait);
> -		SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
> -					  " thread\n"));
> -	}
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +	if (shost->in_recovery) {
> +		if (shost->host_failed && (shost->host_busy == shost->host_failed)) {
> +			up(shost->eh_wait);
> +			SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
> +						  " thread\n"));
> +		}
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +	} else if (!list_empty(&shost->pending_queue) &&
> +		   !shost->host_blocked && !shost->host_self_blocked) {
> +		/*
> +		 * Send one pending command.
> +		 */
> +		scmd = list_entry(shost->pending_queue.next, struct scsi_cmnd,
> +				  pending_queue);
> +		list_del_init(&scmd->pending_queue);
> +		SCSI_LOG_MLQUEUE(3,
> +			printk("%s: removed from pending cmd: 0x%lx\n",
> +			       __FUNCTION__, scmd->serial_number));
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		scsi_dispatch_cmd(scmd, 0);
> +	} else 
> +		spin_unlock_irqrestore(shost->host_lock, flags);
>  }
> ===== drivers/scsi/hosts.h 1.56 vs edited =====
> --- 1.56/drivers/scsi/hosts.h	Fri Feb 21 16:41:13 2003
> +++ edited/drivers/scsi/hosts.h	Fri Feb 28 09:31:46 2003
> @@ -380,6 +380,7 @@
>      struct scsi_host_cmd_pool *cmd_pool;
>      spinlock_t            free_list_lock;
>      struct list_head      free_list;   /* backup store of cmd structs */
> +    struct list_head      pending_queue;   /* software enqueued commands */


See top of this message.


>  
>      spinlock_t		  default_lock;
>      spinlock_t		  *host_lock;
> @@ -471,12 +472,6 @@
>      unsigned reverse_ordering:1;
>  
>      /*
> -     * Indicates that one or more devices on this host were starved, and
> -     * when the device becomes less busy that we need to feed them.
> -     */
> -    unsigned some_device_starved:1;
> -   
> -    /*
>       * Host has rejected a command because it was busy.
>       */
>      unsigned int host_blocked;
> @@ -580,12 +575,9 @@
>  extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
>  extern void scsi_host_put(struct Scsi_Host *);
>  extern void scsi_host_init(void);
> -
> -/*
> - * host_busy inc/dec/test functions
> - */
>  extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
>  extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
> +extern void scsi_host_send_pending (struct Scsi_Host *shost);
>  
>  /**
>   * scsi_find_device - find a device given the host
> ===== drivers/scsi/scsi.c 1.97 vs edited =====
> --- 1.97/drivers/scsi/scsi.c	Wed Feb 26 00:00:06 2003
> +++ edited/drivers/scsi/scsi.c	Fri Feb 28 09:32:01 2003
> @@ -303,6 +303,7 @@
>  		cmd->owner = SCSI_OWNER_NOBODY;
>  		init_timer(&cmd->eh_timeout);
>  		INIT_LIST_HEAD(&cmd->list);
> +		INIT_LIST_HEAD(&cmd->pending_queue);
>  		spin_lock_irqsave(&dev->list_lock, flags);
>  		list_add_tail(&cmd->list, &dev->cmd_list);
>  		spin_unlock_irqrestore(&dev->list_lock, flags);
> @@ -423,15 +424,17 @@
>  }
>  
>  /*
> - * Function:    scsi_dispatch_command
> + * Function:    scsi_dispatch_cmd
>   *
>   * Purpose:     Dispatch a command to the low-level driver.
>   *
>   * Arguments:   SCpnt - command block we are dispatching.
> + *              resend - command is being resent, host_busy was not
> + *              decremented (blah), and we have a slot available for SCpnt.
>   *
>   * Notes:
>   */
> -int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt)
> +int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt, int resend)


Oh, boy!

More complication!  Why do you need to change the prototype
for the dispatch fn?  (Rhetorical.)

Because the rest of the infrastructure of SCSI Core is not
up to date to your patch-idea?

See bottom of message.


>  {
>  #ifdef DEBUG_DELAY
>  	unsigned long clock;
> @@ -494,7 +497,7 @@
>  	 * We will use a queued command if possible, otherwise we will emulate the
>  	 * queuing and calling of completion function ourselves.
>  	 */
> -	SCSI_LOG_MLQUEUE(3, printk("scsi_dispatch_cmnd (host = %d, channel = %d, target = %d, "
> +	SCSI_LOG_MLQUEUE(4, printk("scsi_dispatch_cmnd (host = %d, channel = %d, target = %d, "
>  	       "command = %p, buffer = %p, \nbufflen = %d, done = %p)\n",
>  	SCpnt->device->host->host_no, SCpnt->device->channel, SCpnt->device->id, SCpnt->cmnd,
>  			    SCpnt->buffer, SCpnt->bufflen, SCpnt->done));
> @@ -502,7 +505,7 @@
>  	SCpnt->state = SCSI_STATE_QUEUED;
>  	SCpnt->owner = SCSI_OWNER_LOWLEVEL;
>  	if (host->can_queue) {
> -		SCSI_LOG_MLQUEUE(3, printk("queuecommand : routine at %p\n",
> +		SCSI_LOG_MLQUEUE(4, printk("queuecommand : routine at %p\n",
>  					   host->hostt->queuecommand));
>  		/*
>  		 * Before we queue this command, check if the command
> @@ -510,12 +513,33 @@
>  		 */
>  		if (CDB_SIZE(SCpnt) <= SCpnt->device->host->max_cmd_len) {
>  			spin_lock_irqsave(host->host_lock, flags);
> -			rtn = host->hostt->queuecommand(SCpnt, scsi_done);
> -			spin_unlock_irqrestore(host->host_lock, flags);
> -			if (rtn != 0) {
> -				scsi_queue_insert(SCpnt, rtn == SCSI_MLQUEUE_DEVICE_BUSY ? rtn : SCSI_MLQUEUE_HOST_BUSY);
> +			if (!resend && ((host->host_busy > host->can_queue) ||
> +			    host->host_blocked)) {
> +				/*
> +				 * queue a pending command
> +				 */
>  				SCSI_LOG_MLQUEUE(3,
> -				   printk("queuecommand : request rejected\n"));                                
> +					printk("%s: add to pending cmd:"
> +					       " 0x%lx\n", __FUNCTION__,
> +					       SCpnt->serial_number));
> +				scsi_delete_timer(SCpnt);
> +				list_add_tail(&SCpnt->pending_queue,
> +					      &host->pending_queue);
> +				spin_unlock_irqrestore(host->host_lock, flags);
> +				rtn = 1;


Messy, messy, messy, but I sympathize.


> +			} else {
> +				if (!resend)
> +					host->host_busy++;
> +				rtn = host->hostt->queuecommand(SCpnt,
> +								scsi_done);
> +				spin_unlock_irqrestore(host->host_lock, flags);
> +				if (rtn != 0) {
> +					scsi_queue_insert(SCpnt,
> +						rtn == SCSI_MLQUEUE_DEVICE_BUSY
> +						? rtn : SCSI_MLQUEUE_HOST_BUSY);
> +					SCSI_LOG_MLQUEUE(3,
> +					   printk("queuecommand : request rejected\n"));                                
> +				}
>  			}
>  		} else {
>  			SCSI_LOG_MLQUEUE(3,
> @@ -531,6 +555,8 @@
>  
>  		SCSI_LOG_MLQUEUE(3, printk("command() :  routine at %p\n", host->hostt->command));
>                  spin_lock_irqsave(host->host_lock, flags);
> +		if (!resend)
> +			host->host_busy++;
>  		temp = host->hostt->command(SCpnt);
>  		SCpnt->result = temp;
>  #ifdef DEBUG_DELAY
> @@ -547,7 +573,7 @@
>  		scsi_done(SCpnt);
>                  spin_unlock_irqrestore(host->host_lock, flags);
>  	}
> -	SCSI_LOG_MLQUEUE(3, printk("leaving scsi_dispatch_cmnd()\n"));
> +	SCSI_LOG_MLQUEUE(4, printk("leaving scsi_dispatch_cmnd()\n"));
>  	return rtn;
>  }
>  
> @@ -824,7 +850,7 @@
>           */
>  	memset((void *) SCpnt->sense_buffer, 0, sizeof SCpnt->sense_buffer);
>  
> -	return scsi_dispatch_cmd(SCpnt);
> +	return scsi_dispatch_cmd(SCpnt, 1);
>  }
>  
>  /*
> @@ -845,23 +871,12 @@
>  
>  	ASSERT_LOCK(host->host_lock, 0);
>  
> -        /*
> -         * We need to protect the decrement, as otherwise a race condition
> -         * would exist.  Fiddling with SCpnt isn't a problem as the
> -         * design only allows a single SCpnt to be active in only
> -         * one execution context, but the device and host structures are
> -         * shared.
> -         */
> -	scsi_host_busy_dec_and_test(host, device);
> -
> -        /*
> -         * Clear the flags which say that the device/host is no longer
> -         * capable of accepting new commands.  These are set in scsi_queue.c
> -         * for both the queue full condition on a device, and for a
> -         * host full condition on the host.
> -         */
> -        host->host_blocked = 0;
>          device->device_blocked = 0;
> +	scsi_host_busy_dec_and_test(host, device);
> +	if (host->host_blocked) {
> +		host->host_blocked = 0;
> +		scsi_host_send_pending(host);
> +	}
>  
>  	/*
>  	 * If we have valid sense information, then some kind of recovery
> ===== drivers/scsi/scsi.h 1.65 vs edited =====
> --- 1.65/drivers/scsi/scsi.h	Sun Feb 23 10:34:55 2003
> +++ edited/drivers/scsi/scsi.h	Thu Feb 27 16:21:10 2003
> @@ -444,7 +444,7 @@
>  /*
>   * Prototypes for functions in scsi.c
>   */
> -extern int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt);
> +extern int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt, int resend);
>  extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
>  extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
>  extern struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int flags);
> @@ -634,8 +634,6 @@
>  					 * because we did a bus reset. */
>  	unsigned ten:1;		/* support ten byte read / write */
>  	unsigned remap:1;	/* support remapping  */
> -	unsigned starved:1;	/* unable to process commands because
> -				   host busy */
>  //	unsigned sync:1;	/* Sync transfer state, managed by host */
>  //	unsigned wide:1;	/* WIDE transfer state, managed by host */
>  
> @@ -727,7 +725,9 @@
>  	struct scsi_cmnd *reset_chain;
>  
>  	struct list_head list;  /* scsi_cmnd participates in queue lists */
> -
> +	struct list_head pending_queue;  /* for host->pending_queue, this could
> +					  * be shared with eh_entry.
> +					  */


Oh, boy!  One more list_head...
As I mentioned above, this would make the logical structure
of what belongs where, look like a spaghetti dish.


>  	struct list_head eh_entry; /* entry for the host eh_cmd_q */
>  	int eh_state;		/* Used for state tracking in error handlr */
>  	int eh_eflags;		/* Used by error handlr */
> @@ -854,6 +854,7 @@
>  #define SCSI_MLQUEUE_HOST_BUSY   0x1055
>  #define SCSI_MLQUEUE_DEVICE_BUSY 0x1056
>  #define SCSI_MLQUEUE_EH_RETRY    0x1057
> +#define SCSI_MLQUEUE_PENDING     0x1058
>  
>  /*
>   * old style reset request from external source
> ===== drivers/scsi/scsi_error.c 1.38 vs edited =====
> --- 1.38/drivers/scsi/scsi_error.c	Sat Feb 22 08:17:01 2003
> +++ edited/drivers/scsi/scsi_error.c	Thu Feb 27 16:21:10 2003
> @@ -1467,16 +1467,8 @@
>  	 * requests are started.
>  	 */
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	list_for_each_entry(sdev, &shost->my_devices, siblings) {
> -		if ((shost->can_queue > 0 &&
> -		     (shost->host_busy >= shost->can_queue))
> -		    || (shost->host_blocked)
> -		    || (shost->host_self_blocked)) {
> -			break;
> -		}
> -
> +	list_for_each_entry(sdev, &shost->my_devices, siblings)
>  		__blk_run_queue(sdev->request_queue);
> -	}
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  }
>  
> @@ -1497,6 +1489,34 @@
>  }
>  
>  /**
> + * scsi_eh_flush_pending_q - finish pending commands or requeue them.
> + * @pending_q:	list_head of queued pending commands.
> + *
> + **/
> +static void scsi_eh_flush_pending_q(struct list_head *pending_q)
> +{
> +	struct list_head *lh, *lh_sf;
> +	struct scsi_cmnd *scmd;
> +
> +	list_for_each_safe(lh, lh_sf, pending_q) {
> +		scmd = list_entry(lh, struct scsi_cmnd, pending_queue);
> +		list_del_init(lh);
> +		if (scmd->device->online) {
> +			SCSI_LOG_ERROR_RECOVERY(3, 
> +				printk("%s: flush pending cmd: %p\n",
> +				       current->comm, scmd));
> +			scsi_queue_insert(scmd, SCSI_MLQUEUE_PENDING);
> +		} else {
> +			scmd->result |= (DRIVER_TIMEOUT << 24);
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				printk("%s: finish pending cmd: %p\n",
> +				       current->comm, scmd));
> +			scsi_finish_command(scmd);
> +		}
> +	}
> +}


No.  I don't like it (from logical point of view of course).
This will get too tricky as the device could be in many more
states, then you'll have the burden of deciding what to
do with the commands...

Decisions of what should be done with a command should
be centralized in a single function.


> +
> +/**
>   * scsi_eh_flush_done_q - finish processed commands or retry them.
>   * @done_q:	list_head of processed commands.
>   *
> @@ -1557,6 +1577,7 @@
>  	unsigned long flags;
>  	LIST_HEAD(eh_work_q);
>  	LIST_HEAD(eh_done_q);
> +	LIST_HEAD(pending_q);
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
> @@ -1568,6 +1589,16 @@
>  		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
>  			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
>  
> +	/*
> +	 * Finish or requeue all outstanding commands, first the pending
> +	 * (so they are sent after any error recovered commands) and then
> +	 * any error recovered commands.
> +	 */
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_splice_init(&shost->pending_queue, &pending_q);
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +	scsi_eh_flush_pending_q(&pending_q);
> +
>  	scsi_eh_flush_done_q(&eh_done_q);


If you're marrying a function name with an object of SCSI Core
shouldn't this be called ``scsi_flush_eh_done_q()''?


>  }
>  
> @@ -1659,7 +1690,9 @@
>  		 * restart, we restart any I/O to any other devices on the bus
>  		 * which are still online.
>  		 */
> +
>  		scsi_restart_operations(shost);
> +
>  
>  	}
>  
> ===== drivers/scsi/scsi_lib.c 1.73 vs edited =====
> --- 1.73/drivers/scsi/scsi_lib.c	Sat Feb 22 12:35:33 2003
> +++ edited/drivers/scsi/scsi_lib.c	Thu Feb 27 16:21:10 2003
> @@ -92,9 +92,11 @@
>  {
>  	struct Scsi_Host *host = cmd->device->host;
>  	struct scsi_device *device = cmd->device;
> +	unsigned long flags;
>  
>  	SCSI_LOG_MLQUEUE(1,
> -		 printk("Inserting command %p into mlqueue\n", cmd));
> +		 printk("Inserting command %p into mlqueue reason 0x%x\n",
> +			cmd, reason));
>  
>  	/*
>  	 * We are inserting the command into the ml queue.  First, we
> @@ -127,11 +129,20 @@
>  	cmd->owner = SCSI_OWNER_MIDLEVEL;
>  	cmd->bh_next = NULL;
>  
> -	/*
> -	 * Decrement the counters, since these commands are no longer
> -	 * active on the host/device.
> -	 */
> -	scsi_host_busy_dec_and_test(host, device);
> +	if (reason == SCSI_MLQUEUE_PENDING) {
> +		/*
> +		 * Pending commands have not actually made it to the host,
> +		 * so do not decrement host_busy.
> +		 */
> +		spin_lock_irqsave(host->host_lock, flags);
> +		device->device_busy--;
> +		spin_unlock_irqrestore(host->host_lock, flags);
> +	} else
> +		/*
> +		 * Decrement the counters, since these commands are no longer
> +		 * active on the host/device.
> +		 */
> +		scsi_host_busy_dec_and_test(host, device);
>  
>  	/*
>  	 * Insert this command at the head of the queue for it's device.
> @@ -358,7 +369,6 @@
>  	struct scsi_device *sdev, *sdev2;
>  	struct Scsi_Host *shost;
>  	unsigned long flags;
> -	int all_clear;
>  
>  	ASSERT_LOCK(q->queue_lock, 0);
>  
> @@ -400,10 +410,7 @@
>  	 * with special case code, then spin off separate versions and
>  	 * use function pointers to pick the right one.
>  	 */
> -	if (sdev->single_lun && blk_queue_empty(q) && sdev->device_busy ==0 &&
> -			!shost->host_blocked && !shost->host_self_blocked &&
> -			!((shost->can_queue > 0) && (shost->host_busy >=
> -				       		     shost->can_queue))) {
> +	if (sdev->single_lun && blk_queue_empty(q) && sdev->device_busy == 0) {
>  		list_for_each_entry(sdev2, &sdev->same_target_siblings,
>  			       same_target_siblings) {
>  			if (!sdev2->device_blocked &&
> @@ -414,31 +421,6 @@
>  		}
>  	}
>  
> -	/*
> -	 * Now see whether there are other devices on the bus which
> -	 * might be starved.  If so, hit the request function.  If we
> -	 * don't find any, then it is safe to reset the flag.  If we
> -	 * find any device that it is starved, it isn't safe to reset the
> -	 * flag as the queue function releases the lock and thus some
> -	 * other device might have become starved along the way.
> -	 */
> -	all_clear = 1;
> -	if (shost->some_device_starved) {
> -		list_for_each_entry(sdev, &shost->my_devices, siblings) {
> -			if (shost->can_queue > 0 &&
> -			    shost->host_busy >= shost->can_queue)
> -				break;
> -			if (shost->host_blocked || shost->host_self_blocked)
> -				break;
> -			if (sdev->device_blocked || !sdev->starved)
> -				continue;
> -			__blk_run_queue(sdev->request_queue);
> -			all_clear = 0;
> -		}
> -
> -		if (sdev == NULL && all_clear)
> -			shost->some_device_starved = 0;
> -	}
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
>  
> @@ -1094,6 +1076,7 @@
>  				SCSI_LOG_MLQUEUE(3,
>  					printk("scsi%d unblocking host at zero depth\n",
>  						shost->host_no));
> +				WARN_ON(!list_empty(&shost->pending_queue));
>  			} else {
>  				blk_plug_device(q);
>  				break;
> @@ -1117,23 +1100,18 @@
>  		 */
>  		if (sdev->device_blocked)
>  			break;
> -		if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
> -		    shost->host_blocked || shost->host_self_blocked) {
> +
> +		if (shost->host_self_blocked)
> +			break;
> +
> +		if ((sdev->device_busy > 0) && shost->host_blocked)
>  			/*
> -			 * If we are unable to process any commands at all for
> -			 * this device, then we consider it to be starved.
> -			 * What this means is that there are no outstanding
> -			 * commands for this device and hence we need a
> -			 * little help getting it started again
> -			 * once the host isn't quite so busy.
> +			 * On unblock during IO completion, we send
> +			 * pending commands, make sure we always have at
> +			 * least one command pending to keep this queue
> +			 * running again.
>  			 */
> -			if (sdev->device_busy == 0) {
> -				sdev->starved = 1;
> -				shost->some_device_starved = 1;
> -			}
>  			break;
> -		} else
> -			sdev->starved = 0;
>  
>  		/*
>  		 * If we couldn't find a request that could be queued, then we
> @@ -1170,11 +1148,6 @@
>  		if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
>  			blkdev_dequeue_request(req);
>  	
> -		/*
> -		 * Now bump the usage count for both the host and the
> -		 * device.
> -		 */
> -		shost->host_busy++;
>  		sdev->device_busy++;
>  		spin_unlock_irq(q->queue_lock);
>  
> @@ -1187,7 +1160,7 @@
>  		/*
>  		 * Dispatch the command to the low-level driver.
>  		 */
> -		scsi_dispatch_cmd(cmd);
> +		scsi_dispatch_cmd(cmd, 0);
>  
>  		/*
>  		 * Now we need to grab the lock again.  We are about to mess
> 

Overall, I think for the last 2 months we saw too many additions
of list_head queues and list_head entries (abuse of struct list_head?).

I think that this makes SCSI Core more complicated than its purpose
warrants, and harder to maintain and implement other needed features
like *active* command cancelling (cf. passive command cancelling).

I appreciate your effort to incorporate some of the [queuing]
ideas of my own mini-scsi-core, which I spoke of so many times,
but as I said, for them to be of any use, a general overhaul of
SCSI Core is needed.

-- 
Luben



