From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] USB: fix regression occurring during device removal
Date: Fri, 1 Jul 2011 16:43:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1107011640300.1624-100000@iolanthe.rowland.org>
References: <1309552148.2722.46.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1309552148.2722.46.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>, axboe@kernel.dk, "Rafael J. Wysocki" <rjw@sisk.pl>, USB list <linux-usb@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch (as1476) fixes a regression introduced by
fccf4e86200b8f5edd9a65da26f150e32ba79808 (USB: Free bandwidth when
usb_disable_device is called).  usb_disconnect() grabs the
bandwidth_mutex before calling usb_disable_device(), which calls down
indirectly to usb_set_interface(), which tries to acquire the
bandwidth_mutex.

The fix causes usb_set_interface() to return early when it is called
for an interface that has already been unregistered, which is what
happens in usb_disable_device().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: <stable@kernel.org>

---

On Fri, 1 Jul 2011, James Bottomley wrote:

> On Fri, 2011-07-01 at 14:14 -0400, Dave Jones wrote:
> > On Fri, Jul 01, 2011 at 10:05:31AM -0700, Andi Kleen wrote:
> > 
> >  > I found I can reliably crash a 3.0 system by pulling the
> >  > USB cable of a mounted USB cdrom (or rather a USB device which
> >  > has a builtin fake CD-ROM) 
> >  > 
> >  > I suspect it's a regression too.
> > 
> > We've been seeing a lot of similar bugs in Fedora since we pushed
> > a 2.6.38.8 update.  Some of the traces are different, but some
> > look to be the same as yours. (here's one for eg: https://bugzilla.redhat.com/show_bug.cgi?id=712830)
> > 
> > The common cause seems to be 'device went away'. So USB CD drives,
> > USB memory sticks, and for some reason virtualbox shutdown.
> 
> I think it's something specific in the USB path.  I can't reproduce on
> 3.0-rc5 with a SATA DVD hot unplug.  USB cc's added.
> 
> James

This should fix the problem.  Or at least, it does fix a very similar 
problem.

Alan Stern



 drivers/usb/core/message.c |    2 ++
 1 file changed, 2 insertions(+)

Index: usb-3.0/drivers/usb/core/message.c
===================================================================
--- usb-3.0.orig/drivers/usb/core/message.c
+++ usb-3.0/drivers/usb/core/message.c
@@ -1286,6 +1286,8 @@ int usb_set_interface(struct usb_device 
 			interface);
 		return -EINVAL;
 	}
+	if (iface->unregistering)
+		return -ENODEV;
 
 	alt = usb_altnum_to_altsetting(iface, alternate);
 	if (!alt) {
