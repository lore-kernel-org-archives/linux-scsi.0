From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Fri, 26 Sep 2003 14:43:41 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309261426440.618-100000@ida.rowland.org>
References: <Pine.LNX.4.44.0309240948550.3178-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1540 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261559AbTIZSnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 14:43:41 -0400
In-Reply-To: <Pine.LNX.4.44.0309240948550.3178-100000@home.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Ruud Linders <rkmp@xs4all.nl>, James Bottomley <James.Bottomley@SteelEye.com>, Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl

On Wed, 24 Sep 2003, Linus Torvalds wrote:

> Ok. I committed my version as "better than what is there now", but clearly
> it's not good enough.
> 
> So we should really add code to sd_read_cache_type() to default to 
> write-through for USB devices. The question is, what kind of flag do we 
> want to use?
> 
> We already have the combination "removable && !lockable", which would make
> a lot of sense. But I don't think USB even touches those flags, and
> "removable" wrt USB is actually a bit ambiguous (in the USB unplug case,
> it's actually the _controller_ that is removed, not the medium).
> 
> Suggestions? Just add a new flag like the "use_10_for_ms" flag?

Here's a suggestion.  This patch (as115) implements the concepts brought
up by Andries and Linus.  It adds a flag "randomly_unpluggable", meaning
that a host or device might be disconnected at some unknown and
uncontrollable time.  The flag is present in the host template, the host
structure (copied from the template), and the device structure (inherited
from the host), and it can be changed at will.  (Remember that a USB mass
storage device is treated as a SCSI host -- in fact, some such devices
actually _are_ hosts.)

The only place the flag gets used is in sd.c, where it prevents
sd_read_cache_type() from being called.  And the only place the flag gets 
set is in the usb-storage host template.

Although not ideal, this is one of the simplest ways of doing what we
want.  One thing that should be added is some way to SYNCHRONIZE the cache
at the appropriate times.  Unfortunately, I don't know when those times
should be -- unmount of course, but what else in addition?  (Also I don't
know how to tell at the level of sd.c when an unmount has occurred.)  And
I don't know what the effect of a SYNCHRONIZE command will be on a USB
device that doesn't like it; only experimentation with different devices
can answer that.

On the other hand, perhaps it's not necessary to worry about this.  Any
hot-unpluggable device compatible with the Windows/MacOS mass market ought
to survive an impromptu disconnect without losing any data.

This patch applies to 2.6.0-test5-bk10.

Alan Stern


===== include/scsi/scsi_device.h 1.5 vs edited =====
--- 1.5/include/scsi/scsi_device.h	Fri Sep  5 07:48:41 2003
+++ edited/include/scsi/scsi_device.h	Fri Sep 26 11:41:48 2003
@@ -85,6 +85,7 @@
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned randomly_unpluggable:1;	/* May disappear at any time */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
===== include/scsi/scsi_host.h 1.3 vs edited =====
--- 1.3/include/scsi/scsi_host.h	Thu Aug 14 18:37:32 2003
+++ edited/include/scsi/scsi_host.h	Fri Sep 26 11:40:51 2003
@@ -312,6 +312,12 @@
 	 */
 	unsigned emulated:1;
 
+	/*
+	 * True for hosts that may be unplugged at unpredictable times
+	 * (e.g. USB)
+	 */
+	unsigned randomly_unpluggable:1;
+
 	/* 
 	 * True if the driver wishes to use the generic block layer
 	 * tag queueing functions
@@ -431,6 +437,7 @@
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned highmem_io:1;
+	unsigned randomly_unpluggable:1;
 	unsigned use_blk_tcq:1;
 
 	/*
===== drivers/scsi/hosts.c 1.33 vs edited =====
--- 1.33/drivers/scsi/hosts.c	Tue Sep  2 02:15:39 2003
+++ edited/drivers/scsi/hosts.c	Fri Sep 26 11:44:41 2003
@@ -236,6 +236,7 @@
 	shost->cmd_per_lun = sht->cmd_per_lun;
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
+	shost->randomly_unpluggable = sht->randomly_unpluggable;
 	shost->use_blk_tcq = sht->use_blk_tcq;
 
 	if (sht->max_host_blocked)
===== drivers/scsi/sd.c 1.56 vs edited =====
--- 1.56/drivers/scsi/sd.c	Fri Sep  5 12:16:39 2003
+++ edited/drivers/scsi/sd.c	Fri Sep 26 11:51:38 2003
@@ -1206,7 +1206,9 @@
 		if (sdp->removable)
 			sd_read_write_protect_flag(sdkp, disk->disk_name,
 					sreq, buffer);
-		sd_read_cache_type(sdkp, disk->disk_name, sreq, buffer);
+		if (!sdp->randomly_unpluggable)
+			sd_read_cache_type(sdkp, disk->disk_name, sreq,
+					buffer);
 	}
 		
 	set_capacity(disk, sdkp->capacity);
===== drivers/scsi/scsi_scan.c 1.50 vs edited =====
--- 1.50/drivers/scsi/scsi_scan.c	Fri Sep  5 12:16:39 2003
+++ edited/drivers/scsi/scsi_scan.c	Fri Sep 26 11:49:14 2003
@@ -632,6 +632,7 @@
 
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 0;
+	sdev->randomly_unpluggable = sdev->host->randomly_unpluggable;
 
 	if(sdev->host->hostt->slave_configure)
 		sdev->host->hostt->slave_configure(sdev);
===== drivers/usb/storage/scsiglue.c 1.59 vs edited =====
--- 1.59/drivers/usb/storage/scsiglue.c	Mon Jul 28 14:29:04 2003
+++ edited/drivers/usb/storage/scsiglue.c	Fri Sep 26 12:11:10 2003
@@ -324,6 +324,9 @@
 	/* emulated HBA */
 	.emulated =			TRUE,
 
+	/* may be unplugged at any time */
+	.randomly_unpluggable = 	TRUE,
+
 	/* module management */
 	.module =			THIS_MODULE
 };

