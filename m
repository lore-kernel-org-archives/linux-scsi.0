From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 26 Jun 2006 06:40:01 -0600
Message-ID: <20060626124001.GG1608@parisc-linux.org>
References: <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org> <447AB2F5.2000700@s5r6.in-berlin.de> <20060529130515.GE23405@parisc-linux.org> <20060531232139.GA3202@us.ibm.com> <447EE81D.2050906@ums.usu.ru> <20060601132315.GD32143@parisc-linux.org> <1151270127.3617.26.camel@mulgrave.il.steeleye.com> <20060625224631.GD1608@parisc-linux.org> <1151310285.3185.16.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:14521 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751115AbWFZMkE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 08:40:04 -0400
Content-Disposition: inline
In-Reply-To: <1151310285.3185.16.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-hotplug-devel@lists.sourceforge.net, Patrick Mansfield <patmans@us.ibm.com>, "Alexander E. Patrakov" <patrakov@ums.usu.ru>, James Bottomley <James.Bottomley@SteelEye.com>

On Mon, Jun 26, 2006 at 10:24:45AM +0200, Arjan van de Ven wrote:
> just to expand on this: The reason I am suggesting this is to allow the
> initrd to have a way to wait for device scans before (re)trying to mount
> the root filesystem. One of the interesting challenges today for the
> initrd with USB is that you don't know when the devices are visible; now
> I know this won't fix USB, but it at least introduces a proper method
> for ensuring that for scsi; I suppose we should make it a generic thing
> with a notifier chain so that all subsystems that want to can get a
> callback and finalize their initialization... I can imagine fiber
> channel cards wanting to use this to wait for LIP etc...

Fortunately, USB is SCSI, so we can actually use this code to solve that
problem too.  I wasn't thinking of USB when I wrote the code (because I
didn't know there was a problem).  But really, it's very generic stuff;
there's a list_head, a pointer to a Scsi_Host and a completion.

I'm not 100% sure what the problem is with USB.  If it's that we may not
have discovered all the USB devices currently plugged in, then I think
we need to change the way USB works to use one Scsi_Host for all USB
storage devices, and then make each device either its own target or its
own channel (probably the former; the latter is less well-tested code).

If it's simply the chunk of code beginning with:
        /* Wait for the timeout to expire or for a disconnect */
that's causing the problem, then this is easily fixable in the current
scheme:

Index: drivers/usb/storage/usb.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/usb/storage/usb.c,v
retrieving revision 1.22
diff -u -p -r1.22 usb.c
--- drivers/usb/storage/usb.c	3 Apr 2006 13:45:11 -0000	1.22
+++ drivers/usb/storage/usb.c	26 Jun 2006 12:34:45 -0000
@@ -849,10 +849,13 @@ static void release_everything(struct us
 static int usb_stor_scan_thread(void * __us)
 {
 	struct us_data *us = (struct us_data *)__us;
+	struct async_scan_data *data;
 
 	printk(KERN_DEBUG
 		"usb-storage: device found at %d\n", us->pusb_dev->devnum);
 
+	data = scsi_prep_async_scan(us_to_host(us));
+
 	/* Wait for the timeout to expire or for a disconnect */
 	if (delay_use > 0) {
 		printk(KERN_DEBUG "usb-storage: waiting for device "
@@ -875,12 +878,14 @@ retry:
 			us->max_lun = usb_stor_Bulk_max_lun(us);
 			mutex_unlock(&us->dev_mutex);
 		}
-		scsi_scan_host(us_to_host(us));
+		scsi_scan_target(&us_to_host(us)->shost_gendev, 0, 0,
+				SCAN_WILD_CARD, 0);
 		printk(KERN_DEBUG "usb-storage: device scan complete\n");
 
 		/* Should we unbind if no devices were detected? */
 	}
 
+	scsi_finish_async_scan(data);
 	scsi_host_put(us_to_host(us));
 	complete_and_exit(&threads_gone, 0);
 }

By the way, if USB intends to stick to its one-host-per-device scheme,
it would do well to set host->max_id to 1, rather than failing targets
in queuecommand.

> One question is if this should get a timeout parameter or if that should
> be left up to the devices...

No timeout.  It's up to the scanners to say they're done.

> (and I think the initrd needs to try to find the rootfs at least once
> without waiting, or there should be 2 levels of expensiveness to the
> wait, so that it'll first try the asynchronous way, but that it can do
> the more expensive wait rather than causing an outright panic() as
> happens today when the rootfs cannot be found..)

It's not just root, it's swap and all the other bits of fstab too.
No point in being able to reliably mount root if the sysadmin has to
manually intervene to mount /home on every boot.  Or worse, occasionally
intervene ...

All the waiting is done in parallel anyway, so you're really trying to
squeeze the last 0.0001% out of it; better to wait and be safe.
