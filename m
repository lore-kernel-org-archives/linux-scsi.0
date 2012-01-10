From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch 1/2]scsi: scsi_run_queue() doesn't use local list to
 handle starved sdev
Date: Tue, 10 Jan 2012 11:27:01 +0800
Message-ID: <1326166021.22361.564.camel@sli10-conroe>
References: <1324523412.22361.471.camel@sli10-conroe>
	 <1324578449.9709.15.camel@dabdike.int.hansenpartnership.com>
	 <1324600851.22361.475.camel@sli10-conroe>
	 <1324603045.9282.2.camel@dabdike.cust.hotspot.t-mobile.com>
	 <1324605214.22361.490.camel@sli10-conroe>
	 <1326094267.22361.556.camel@sli10-conroe>
	 <1326130228.18456.11.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab2AJDL7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2012 22:11:59 -0500
In-Reply-To: <1326130228.18456.11.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ted Ts'o <tytso@mit.edu>, "Wu, Fengguang" <fengguang.wu@intel.com>, "Darrick J. Wong" <djwong@us.ibm.com>

On Mon, 2012-01-09 at 11:30 -0600, James Bottomley wrote:
> On Mon, 2012-01-09 at 15:31 +0800, Shaohua Li wrote:
> > On Fri, 2011-12-23 at 09:53 +0800, Shaohua Li wrote:
> > > On Thu, 2011-12-22 at 19:17 -0600, James Bottomley wrote:
> > > > On Fri, 2011-12-23 at 08:40 +0800, Shaohua Li wrote:
> > > > > On Thu, 2011-12-22 at 18:27 +0000, James Bottomley wrote:
> > > > > > On Thu, 2011-12-22 at 11:10 +0800, Shaohua Li wrote:
> > > > > > > scsi_run_queue() picks off all sdev from host starved_list to a local list,
> > > > > > > then handle them. If there are multiple threads running scsi_run_queue(),
> > > > > > > the starved_list will get messed. This is quite common, because request
> > > > > > > rq_affinity is on by default.
> > > > > > > 
> > > > > > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > > > > > ---
> > > > > > >  drivers/scsi/scsi_lib.c |   21 ++++++++++++++-------
> > > > > > >  1 file changed, 14 insertions(+), 7 deletions(-)
> > > > > > > 
> > > > > > > Index: linux/drivers/scsi/scsi_lib.c
> > > > > > > ===================================================================
> > > > > > > --- linux.orig/drivers/scsi/scsi_lib.c	2011-12-21 16:56:23.000000000 +0800
> > > > > > > +++ linux/drivers/scsi/scsi_lib.c	2011-12-22 09:33:09.000000000 +0800
> > > > > > > @@ -401,9 +401,8 @@ static inline int scsi_host_is_busy(stru
> > > > > > >   */
> > > > > > >  static void scsi_run_queue(struct request_queue *q)
> > > > > > >  {
> > > > > > > -	struct scsi_device *sdev = q->queuedata;
> > > > > > > +	struct scsi_device *sdev = q->queuedata, *head_sdev = NULL;
> > > > > > >  	struct Scsi_Host *shost;
> > > > > > > -	LIST_HEAD(starved_list);
> > > > > > >  	unsigned long flags;
> > > > > > >  
> > > > > > >  	/* if the device is dead, sdev will be NULL, so no queue to run */
> > > > > > > @@ -415,9 +414,8 @@ static void scsi_run_queue(struct reques
> > > > > > >  		scsi_single_lun_run(sdev);
> > > > > > >  
> > > > > > >  	spin_lock_irqsave(shost->host_lock, flags);
> > > > > > > -	list_splice_init(&shost->starved_list, &starved_list);
> > > > > > >  
> > > > > > > -	while (!list_empty(&starved_list)) {
> > > > > > > +	while (!list_empty(&shost->starved_list)) {
> > > > > > 
> > > > > > The original reason for working from a copy instead of the original list
> > > > > > was that the device can end up back on the starved list because of a
> > > > > > variety of conditions in the HBA and so this would cause the loop not to
> > > > > > exit, so this piece of the patch doesn't look right to me.
> > > > > +               /*
> > > > > +                * the head sdev is no longer starved and removed from the
> > > > > +                * starved list, select a new sdev as head.
> > > > > +                */
> > > > > +               if (head_sdev == sdev && list_empty(&sdev->starved_entry))
> > > > > +                       head_sdev = NULL;
> > > > > I had this in the loop, which is to guarantee the loop will exit if a
> > > > > device is removed from the starved list.
> > > > 
> > > > And the non-head sdevs? which can also get put back onto the list
> > > yes, it will be put back to the list tail. Note we always handle the
> > > head sdev first. move the cursor of list iterating to next dev and next,
> > > we will hit head_sdev == sdev eventually, then the loop exit. or the
> > > cursor isn't moving, which means we have scsi_host_is_busy(). in both
> > > cases, the loop will exit.
> > > 
> > > > What's the reason for not just traversing the list once using list
> > > > splice?
> > > > 
> > > > Basically, the changelog doesn't seem to explain what you're doing and
> > > > the logic looks flawed.
> > > The main reason is we have multiple CPU trying to get the list to its
> > > local list and then handle it, then putback unprocessed entries back. we
> > > have multiple cpu handles blk softirq, because request rq_affinity is on
> > > default. And the putback always happen, because scsi_run_queue is called
> > > after every request finish. When it's called, scsi_host has just one
> > > free slot. The in-coordination of multiple threads handle of the starved
> > > list will mess the list. I observed dev which doesn't get chance to
> > > dispatch request is put to starved list tail, while dev which dispatches
> > > request is still at head. eg, this will cause unfairness. This means
> > > some devices will get starved.
> > James,
> > can you take a look at it? the two patches give 12% improvement in a
> > simple file creation workload. I updated the patch log.
> 
> The exit criteria still don't look right to me.
> 
> given two devices on the starved list, s1 and s2.  First loop around
> head_sdev is s1, we run the queue and it gets put back.  Now we loop to
> s2.  as we drop the lock to run the queue, a competing thread gets in,
> runs the starved loop and s1 gets removed.  We run s2, it gets put back,
> but we don't see s1 is gone (since the sdev we're processing is s2 and
> the check head_sdev == sdev fails) and it remains our head_sdev.  The
> result is a loop until s2 gets removed, which would be highly
> undesirable.
> 
> The problem essentially is that you're using local variables to track
> what you've made a global list, so any other list manipulation external
> to your local variables is invisible to you.  You can fix this by
> checking list_empty(&head_sdev->starved_list) instead, but this will
> still lead to running the starved list up to twice as much as we would
> have previously.
putback mostly means host busy, it can also help avoid the loop. but ok
there is rare case the list can run twice. I gave up fixing this issue. 

The issue the second patch tries to fix is still valid and can be
simplified without the first patch. Interesting is I get similar
throughput just with the simplified patch (below). This means the most
starvation list mess is from unplug path. I guess this one is
acceptable?

Thanks,
Shaohua

Subject: SCSI: don't change sdev starvation list order without request dispatched

The sdev is deleted from starved list and then try to dispatch from this
device. It's quite possible the sdev can't eventually dispatch a request,
then the sdev will be in starved list tail. This isn't fair.
There are two cases here:
1. unplug path. scsi_request_fn() calls to scsi_target_queue_ready(), then
the dev is removed from starved list, but quite possible host queue isn't
ready, the dev is moved to starved list without dispatching any request.
2. scsi_run_queue path. It deletes the dev from starved list first (both
global and local starved lists), then handles the dev. Then we could have
the same process like case 1.

This patch fixes the first case. Case 2 isn't fixed, because there is a
rare case scsi_run_queue finds host isn't busy but scsi_request_fn finds
host is busy (other CPU is faster to get host queue depth). Not deleting
the dev from starved list in scsi_run_queue will keep scsi_run_queue
looping (though this is very rare case, because host will become busy).
Fortunately fixing case 1 already gives big improvement for starvation in
my test. In a 12 disk JBOD setup, running file creation under EXT4, this
gives 12% more throughput.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/scsi/scsi_lib.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c	2012-01-10 10:35:36.000000000 +0800
+++ linux/drivers/scsi/scsi_lib.c	2012-01-10 10:39:08.000000000 +0800
@@ -1316,15 +1316,10 @@ static inline int scsi_target_queue_read
 	}
 
 	if (scsi_target_is_busy(starget)) {
-		if (list_empty(&sdev->starved_entry))
-			list_add_tail(&sdev->starved_entry,
-				      &shost->starved_list);
+		list_move_tail(&sdev->starved_entry, &shost->starved_list);
 		return 0;
 	}
 
-	/* We're OK to process the command, so we can't be starved */
-	if (!list_empty(&sdev->starved_entry))
-		list_del_init(&sdev->starved_entry);
 	return 1;
 }
 


