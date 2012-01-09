From: Shaohua Li <shaohua.li@intel.com>
Subject: Re: [patch 1/2]scsi: scsi_run_queue() doesn't use local list to
 handle starved sdev
Date: Mon, 09 Jan 2012 15:31:07 +0800
Message-ID: <1326094267.22361.556.camel@sli10-conroe>
References: <1324523412.22361.471.camel@sli10-conroe>
	 <1324578449.9709.15.camel@dabdike.int.hansenpartnership.com>
	 <1324600851.22361.475.camel@sli10-conroe>
	 <1324603045.9282.2.camel@dabdike.cust.hotspot.t-mobile.com>
	 <1324605214.22361.490.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1324605214.22361.490.camel@sli10-conroe>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ted Ts'o <tytso@mit.edu>, "Wu, Fengguang" <fengguang.wu@intel.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2011-12-23 at 09:53 +0800, Shaohua Li wrote:
> On Thu, 2011-12-22 at 19:17 -0600, James Bottomley wrote:
> > On Fri, 2011-12-23 at 08:40 +0800, Shaohua Li wrote:
> > > On Thu, 2011-12-22 at 18:27 +0000, James Bottomley wrote:
> > > > On Thu, 2011-12-22 at 11:10 +0800, Shaohua Li wrote:
> > > > > scsi_run_queue() picks off all sdev from host starved_list to a local list,
> > > > > then handle them. If there are multiple threads running scsi_run_queue(),
> > > > > the starved_list will get messed. This is quite common, because request
> > > > > rq_affinity is on by default.
> > > > > 
> > > > > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > > > > ---
> > > > >  drivers/scsi/scsi_lib.c |   21 ++++++++++++++-------
> > > > >  1 file changed, 14 insertions(+), 7 deletions(-)
> > > > > 
> > > > > Index: linux/drivers/scsi/scsi_lib.c
> > > > > ===================================================================
> > > > > --- linux.orig/drivers/scsi/scsi_lib.c	2011-12-21 16:56:23.000000000 +0800
> > > > > +++ linux/drivers/scsi/scsi_lib.c	2011-12-22 09:33:09.000000000 +0800
> > > > > @@ -401,9 +401,8 @@ static inline int scsi_host_is_busy(stru
> > > > >   */
> > > > >  static void scsi_run_queue(struct request_queue *q)
> > > > >  {
> > > > > -	struct scsi_device *sdev = q->queuedata;
> > > > > +	struct scsi_device *sdev = q->queuedata, *head_sdev = NULL;
> > > > >  	struct Scsi_Host *shost;
> > > > > -	LIST_HEAD(starved_list);
> > > > >  	unsigned long flags;
> > > > >  
> > > > >  	/* if the device is dead, sdev will be NULL, so no queue to run */
> > > > > @@ -415,9 +414,8 @@ static void scsi_run_queue(struct reques
> > > > >  		scsi_single_lun_run(sdev);
> > > > >  
> > > > >  	spin_lock_irqsave(shost->host_lock, flags);
> > > > > -	list_splice_init(&shost->starved_list, &starved_list);
> > > > >  
> > > > > -	while (!list_empty(&starved_list)) {
> > > > > +	while (!list_empty(&shost->starved_list)) {
> > > > 
> > > > The original reason for working from a copy instead of the original list
> > > > was that the device can end up back on the starved list because of a
> > > > variety of conditions in the HBA and so this would cause the loop not to
> > > > exit, so this piece of the patch doesn't look right to me.
> > > +               /*
> > > +                * the head sdev is no longer starved and removed from the
> > > +                * starved list, select a new sdev as head.
> > > +                */
> > > +               if (head_sdev == sdev && list_empty(&sdev->starved_entry))
> > > +                       head_sdev = NULL;
> > > I had this in the loop, which is to guarantee the loop will exit if a
> > > device is removed from the starved list.
> > 
> > And the non-head sdevs? which can also get put back onto the list
> yes, it will be put back to the list tail. Note we always handle the
> head sdev first. move the cursor of list iterating to next dev and next,
> we will hit head_sdev == sdev eventually, then the loop exit. or the
> cursor isn't moving, which means we have scsi_host_is_busy(). in both
> cases, the loop will exit.
> 
> > What's the reason for not just traversing the list once using list
> > splice?
> > 
> > Basically, the changelog doesn't seem to explain what you're doing and
> > the logic looks flawed.
> The main reason is we have multiple CPU trying to get the list to its
> local list and then handle it, then putback unprocessed entries back. we
> have multiple cpu handles blk softirq, because request rq_affinity is on
> default. And the putback always happen, because scsi_run_queue is called
> after every request finish. When it's called, scsi_host has just one
> free slot. The in-coordination of multiple threads handle of the starved
> list will mess the list. I observed dev which doesn't get chance to
> dispatch request is put to starved list tail, while dev which dispatches
> request is still at head. eg, this will cause unfairness. This means
> some devices will get starved.
James,
can you take a look at it? the two patches give 12% improvement in a
simple file creation workload. I updated the patch log.

Thanks,
Shaohua

Subject: scsi: scsi_run_queue() doesn't use local list to handle starved sdev

scsi_run_queue() picks off all sdev from host starved_list to a local list,
then handle them, and putback unprocessed entries back. we have multiple cpu
handles blk softirq, because request rq_affinity is on by default. And the
putback always happen, because scsi_run_queue() is called after every request
finish. When it's called, scsi_host has just one free slot. The in-coordination
of multiple threads handle of the starved list will mess the list. I observed
dev which doesn't get chance to dispatch request is put to starved list tail,
while dev which dispatches request successfully is still at head. This will
cause unfairness, which means some devices will get starved.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/scsi/scsi_lib.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c	2011-12-23 10:21:22.000000000 +0800
+++ linux/drivers/scsi/scsi_lib.c	2012-01-09 15:14:53.000000000 +0800
@@ -401,9 +401,8 @@ static inline int scsi_host_is_busy(stru
  */
 static void scsi_run_queue(struct request_queue *q)
 {
-	struct scsi_device *sdev = q->queuedata;
+	struct scsi_device *sdev = q->queuedata, *head_sdev = NULL;
 	struct Scsi_Host *shost;
-	LIST_HEAD(starved_list);
 	unsigned long flags;
 
 	/* if the device is dead, sdev will be NULL, so no queue to run */
@@ -415,9 +414,8 @@ static void scsi_run_queue(struct reques
 		scsi_single_lun_run(sdev);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_splice_init(&shost->starved_list, &starved_list);
 
-	while (!list_empty(&starved_list)) {
+	while (!list_empty(&shost->starved_list)) {
 		/*
 		 * As long as shost is accepting commands and we have
 		 * starved queues, call blk_run_queue. scsi_request_fn
@@ -431,8 +429,13 @@ static void scsi_run_queue(struct reques
 		if (scsi_host_is_busy(shost))
 			break;
 
-		sdev = list_entry(starved_list.next,
+		sdev = list_entry(shost->starved_list.next,
 				  struct scsi_device, starved_entry);
+		if (sdev == head_sdev)
+			break;
+		if (!head_sdev)
+			head_sdev = sdev;
+
 		list_del_init(&sdev->starved_entry);
 		if (scsi_target_is_busy(scsi_target(sdev))) {
 			list_move_tail(&sdev->starved_entry,
@@ -445,9 +448,13 @@ static void scsi_run_queue(struct reques
 		__blk_run_queue(sdev->request_queue);
 		spin_unlock(sdev->request_queue->queue_lock);
 		spin_lock(shost->host_lock);
+		/*
+		 * the head sdev is no longer starved and removed from the
+		 * starved list, select a new sdev as head.
+		 */
+		if (head_sdev == sdev && list_empty(&sdev->starved_entry))
+			head_sdev = NULL;
 	}
-	/* put any unprocessed entries back */
-	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	blk_run_queue(q);
@@ -1316,9 +1323,7 @@ static inline int scsi_target_queue_read
 	}
 
 	if (scsi_target_is_busy(starget)) {
-		if (list_empty(&sdev->starved_entry))
-			list_add_tail(&sdev->starved_entry,
-				      &shost->starved_list);
+		list_move_tail(&sdev->starved_entry, &shost->starved_list);
 		return 0;
 	}
 
