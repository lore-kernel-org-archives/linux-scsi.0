From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Thu, 4 Mar 2010 10:18:19 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1003041005530.1657-100000@iolanthe.rowland.org>
References: <233671224A0FED4688218FFDBED26E1A517AC38CA5@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <233671224A0FED4688218FFDBED26E1A517AC38CA5@IRVEXCHCCR01.corp.ad.broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hugh Daschbach <hdasch@broadcom.com>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, james Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 3 Mar 2010, Hugh Daschbach wrote:

> Alan Stern [mailto:stern@rowland.harvard.edu] writes:
> 
> > On Wed, 3 Mar 2010, Hugh Daschbach wrote:
> >
> >> > Can't we just protect the list?  What is wanting to write to the list
> >> > while shutdown is happening?
> >> 
> >> Indeed, Alan suggested holding the kset spinlock while iterating the
> >> list.  Unfortunately, the device shutdown routines may sleep.  At least
> >> the SCSI sd_shutdown routine issues I/O to the device as part of
> >> flushing device caches.  I would guess other subsystems sleep as well.
> >
> > What I meant was that you should hold the spinlock while finding and 
> > unlinking the last device on the list.  Clearly you shouldn't hold it 
> > while calling the device shutdown routine.
> 
> I misunderstood.  But I believe insertion and deletion is properly
> serliaized.  It looks to me like the list structure is intact.  It's the
> iterator that's been driven off into the weeds.
> 
> >> I'll try klist.  That looks like a good mediator between traversal and
> >> removal.
> >
> > Yes, it removes a lot of difficulties.
> >
> > Alan Stern
> 
> Just to be clear, the list we're talking about is "list" in "struct
> kset"  And the nodes of the list are chained by "entry" in "struct
> kobject".  I just want to make sure that this is what's intended before
> I get too far down the road.
> 
> At a minimum the change looks something like the patch below.  This
> doesn't work yet.  And I'll need extensive testing in device plug and
> unplug.  So I'm not looking for a detailed review.  But if I'm obviously
> way off base, I'd like to know earlier rather than later.
> 
> Thanks for the guidance.

If you really want to do this then you should remove the lock member 
from struct kset.  However this seems like an awful lot of work 
compared to my original suggestion -- something like this (untested, 
and you'll want to add comments):

Index: usb-2.6/drivers/base/core.c
===================================================================
--- usb-2.6.orig/drivers/base/core.c
+++ usb-2.6/drivers/base/core.c
@@ -1719,10 +1719,14 @@ EXPORT_SYMBOL_GPL(device_move);
  */
 void device_shutdown(void)
 {
-	struct device *dev, *devn;
+	struct device *dev;
+
+	spin_lock(&devices_kset->lock);
+	while (!list_empty(&devices_kset->list)) {
+		dev = list_entry(devices_kset->list.prev, struct device,
+				kobj.entry);
+		spin_unlock(&devices_kset->lock);
 
-	list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
-				kobj.entry) {
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
@@ -1730,6 +1734,10 @@ void device_shutdown(void)
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
+
+		spin_lock(&devices_kset->lock);
+		list_del_init(&dev->kobj.entry);
 	}
+	spin_unlock(&devices_kset->lock);
 	async_synchronize_full();
 }

Alan Stern
