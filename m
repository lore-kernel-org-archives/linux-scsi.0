From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 2/3] cciss: use only one scan thread
Date: Thu, 16 Jul 2009 04:15:59 +0000
Message-ID: <1247717759.25954.75.camel@grinch>
References: <20090714220239.22282.44414.stgit@bob.kio>
	 <20090714220250.22282.69385.stgit@bob.kio>
	 <20090715150637.6f171759.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:8947 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZGPEQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2009 00:16:03 -0400
In-Reply-To: <20090715150637.6f171759.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com

On Wed, 2009-07-15 at 15:06 -0700, Andrew Morton wrote:
> On Tue, 14 Jul 2009 16:02:50 -0600
> Andrew Patterson <andrew.patterson@hp.com> wrote:
> 
> > cciss: use only one scan thread
> > 
> > Replace the use of one scan kthread per controller with one per driver.
> > Use a queue to hold a list of controllers that need to be rescanned with
> > routines to add and remove controllers from the queue.
> > Fix locking and completion handling to prevent a hang during rmmod.
> > 
> >
> > ...
> >
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -39,6 +39,7 @@
> >  #include <linux/hdreg.h>
> >  #include <linux/spinlock.h>
> >  #include <linux/compat.h>
> > +#include <linux/mutex.h>
> >  #include <asm/uaccess.h>
> >  #include <asm/io.h>
> >  
> > @@ -155,6 +156,10 @@ static struct board_type products[] = {
> >  
> >  static ctlr_info_t *hba[MAX_CTLR];
> >  
> > +static struct task_struct *cciss_scan_thread;
> > +static struct mutex scan_mutex;
> > +static struct list_head scan_q;
> 
> Both of the above can be initialised at compile-time.  This is a bit
> neater and prevents reviewers from having to run around checking that
> they got initialised early enough.

Fixed.

> 
> >  static void do_cciss_request(struct request_queue *q);
> >  static irqreturn_t do_cciss_intr(int irq, void *dev_id);
> >  static int cciss_open(struct block_device *bdev, fmode_t mode);
> > @@ -189,6 +194,8 @@ static int sendcmd_withirq_core(ctlr_info_t *h, CommandList_struct *c,
> >  static int process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c);
> >  
> >  static void fail_all_cmds(unsigned long ctlr);
> > +static int add_to_scan_list(struct ctlr_info *h);
> > +static void remove_from_scan_list(struct ctlr_info *h);
> 
> These forward declarations are unneeded.
> 

Fixed.

> >  static int scan_thread(void *data);
> >  static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c);
> >  
> > @@ -3232,20 +3239,121 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
> >  	return IRQ_HANDLED;
> >  }
> >  
> > -static int scan_thread(void *data)
> > +/**
> > + * add_to_scan_list() - add controller to rescan queue
> > + * @h:		      Pointer to the controller.
> > + *
> > + * Adds the controller to the rescan queue if not already on the queue.
> > + *
> > + * returns 1 if added to the queue, 0 if skipped (could be on the
> > + * queue already, or the controller could be initializing or shutting
> > + * down).
> > + **/
> > +static int add_to_scan_list(struct ctlr_info *h)
> >  {
> > -	ctlr_info_t *h = data;
> > -	int rc;
> > -	DECLARE_COMPLETION_ONSTACK(wait);
> > -	h->rescan_wait = &wait;
> > +	struct ctlr_info *test_h;
> > +	int found = 0;
> > +	int ret = 0;
> > +
> > +	if (h->busy_initializing)
> > +		return 0;
> 
> This looks pretty random and racy.

Fixed. Converted busy_initializer to a mutex and will use:

if (mutex_is_locked(&h->busy_initializing))
		return 0;

> 
> For example, what stops busy_initializing from becoming true one
> picosecond after the test?
> 
> > +	if (!mutex_trylock(&h->busy_shutting_down))
> > +		return 0;
> >  
> > -	for (;;) {
> > -		rc = wait_for_completion_interruptible(&wait);
> > -		if (kthread_should_stop())
> > +	mutex_lock(&scan_mutex);
> > +	list_for_each_entry(test_h, &scan_q, scan_list) {
> > +		if (test_h == h) {
> > +			found = 1;
> >  			break;
> > -		if (!rc)
> > +		}
> > +	}
> > +	if (!found && !h->busy_scanning) {
> > +		INIT_COMPLETION(h->scan_wait);
> > +		list_add_tail(&h->scan_list, &scan_q);
> > +		ret = 1;
> > +	}
> > +	mutex_unlock(&scan_mutex);
> > +	mutex_unlock(&h->busy_shutting_down);
> > +
> > +	return ret;
> > +}
> 
> We already did init_completion(h->scan_wait) at startup time?  Doing
> the INIT_COMPLETION() here looks unusual and is hopefully unnecessary.
> 

I am following the text in the "Linux Device Drivers 3rd Edition section
5.4:

"A completion is normally a one-shot device; it is used once then
discarded. It is possible, however, to reuse completion structures if
proper care is taken. If complete_all is not used, a completion
structure can be reused without any problems as long as there is no
ambiguity about what event is being signalled. If you use complete_all,
however, you must reinitialize the completion structure before reusing
it. The macro:

INIT_COMPLETION(struct completion c);

can be used to quickly perform this reinitialization."

It there are better way to do this? INIT_COMPLETION() currently just
sets done = 0.

> > +/**
> > + * scan_thread() - kernel thread used to rescan controllers
> > + * @data:	 Ignored.
> > + *
> > + * A kernel thread used scan for drive topology changes on
> > + * controllers. The thread processes only one controller at a time
> > + * using a queue.  Controllers are added to the queue using
> > + * add_to_scan_list() and removed from the queue either after done
> > + * processing or using remove_from_scan_list().
> > + *
> > + * returns 0.
> > + **/
> > +static int scan_thread(void *data)
> > +{
> > +	struct ctlr_info *h;
> > +
> > +	set_current_state(TASK_INTERRUPTIBLE);
> > +	while (!kthread_should_stop()) {
> > +		mutex_lock(&scan_mutex);
> > +		if (list_empty(&scan_q)) {
> > +			h = NULL;
> > +		} else {
> > +			h = list_entry(scan_q.next,
> > +				       struct ctlr_info,
> > +				       scan_list);
> > +			list_del(&h->scan_list);
> > +			h->busy_scanning = 1;
> > +		}
> > +		mutex_unlock(&scan_mutex);
> > +
> > +		if (h) {
> > +			__set_current_state(TASK_RUNNING);
> >  			rebuild_lun_table(h, 0);
> > +			complete_all(&h->scan_wait);
> > +			mutex_lock(&scan_mutex);
> > +			h->busy_scanning = 0;
> > +			mutex_unlock(&scan_mutex);
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +		} else {
> > +			schedule();
> > +			set_current_state(TASK_INTERRUPTIBLE);
> > +			continue;
> > +		}
> >  	}
> > +
> > +	__set_current_state(TASK_RUNNING);
> >  	return 0;
> >  }
> 
> This code is somewhat wrong.  Look:
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	...
> 		mutex_lock(&scan_mutex);
> 
> now, we don't know what state the task is in.  If the mutex_lock()
> slept the we're in state TASK_RUNNING.  If the mutex_lock() didn't
> sleep then we're in state <mumble>.  Where
> <mumble>==TASK_INTERRUPTIBLE, but that's an implementation fluke.
> 
> So I'd say that some rethinking/restructuring is needed here.

Will look into this.  I have had a hard time removing this possible race
(even the mutex_lock() does not remove it completely, but at most you
get multiple completions) without using some sort of nested locks.

> 
> 
-- 
Andrew Patterson
Hewlett-Packard

