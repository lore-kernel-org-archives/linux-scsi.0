From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Separate target visibility from reaped state information
Date: Tue, 02 Feb 2016 11:46:25 +0000
Message-ID: <1454413585.2349.11.camel@HansenPartnership.com>
References: <568FE922.9090004@sandisk.com>
	 <yq1oachqehs.fsf@sermon.lab.mkp.net>
	 <1453251809.2320.56.camel@HansenPartnership.com>
	 <56B025E4.9010009@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45286 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710AbcBBLqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2016 06:46:42 -0500
In-Reply-To: <56B025E4.9010009@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Dan Williams <dan.j.williams@intel.com>, Sebastian Herbszt <herbszt@gmx.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2016-02-01 at 19:43 -0800, Bart Van Assche wrote:
> On 01/19/16 17:03, James Bottomley wrote:
> > On Tue, 2016-01-19 at 19:30 -0500, Martin K. Petersen wrote:
> > > > > > > > "Bart" == Bart Van Assche <bart.vanassche@sandisk.com>
> > > > > > > > writes:
> > > 
> > > Bart> Instead of representing the states "visible in sysfs" and
> > > "has
> > > Bart> been removed from the target list" by a single state
> > > variable,
> > > use
> > > Bart> two variables to represent this information.
> > > 
> > > James: Are you happy with the latest iteration of this? Should I
> > > queue
> > > it?
> > 
> > Well, I'm OK with the patch: it's a simple transformation of the
> > enumerated state to a two bit state.  What I can't see is how it
> > fixes
> > any soft lockup.
> > 
> > The only change from the current workflow is that the DEL
> > transition
> > (now the reaped flag) is done before the spin lock is dropped which
> > would fix a tiny window for two threads both trying to remove the
> > same
> > target, but there's nothing that could possibly fix an iterative
> > soft
> > lockup caused by restarting the loop, which is what the changelog
> > says.
> 
> Hello James,
> 
> scsi_remove_target() doesn't lock the scan_mutex which means that 
> concurrent SCSI scanning activity is not prohibited. Such scanning 
> activity can postpone the transition of the state of a SCSI target 
> into STARGET_DEL. I think if the scheduler decides to run the thread 
> that executes scsi_remove_target() on the same CPU as the scanning 
> code after the scanning code has obtained a reap ref and before the 
> scanning code has released the reap ref again that the soft lockup 
> can be triggered that has been reported by Sebastian Herbszt.

OK, I finally understand the scenario;  I'm not sure I understand how
we're getting concurrent scanning and removal from a simple rmmod ... I
take it this is insmod rmmod in a tight loop?

So this patch now actually introduces a problem the other way: we can
do a scan with a dying target, which will lead to problems down the
road.  The original design of the code was to allow the target to be
resurrected even while being removed, because the target doesn't exist
independently of the devices ... when the last device is removed the
target is reaped.  So a test case this would need to pass is adding and
removing a single device on a target in a tight loop.  The problem
you'll see is that eventually the add will fail nastily with your code
because the target can't be resurrected even though we have a reference
and we find a device to attach because once we set your reaped flag,
the destruction is irrevocable.

All we really need to break the soft lockup is to not keep looping over
a device that we've called remove on but which hasn't gone into DEL
state.  So how about this.  It will retain a simplistic memory of the
last target and not keep looping over it.  I think it will fix the soft
lockup and preserve the resurrection of the target for the device
add/remove case.

James

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 4f18a85..00bc721 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1272,16 +1272,18 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget;
+	struct scsi_target *starget, *last_target = NULL;
 	unsigned long flags;
 
 restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
-		if (starget->state == STARGET_DEL)
+		if (starget->state == STARGET_DEL ||
+		    starget == last_target)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			kref_get(&starget->reap_ref);
+			last_target = starget;
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			__scsi_remove_target(starget);
 			scsi_target_reap(starget);

