From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: Fri, 12 Sep 2003 17:17:27 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309121711240.633-100000@ida.rowland.org>
References: <1063311558.2017.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1540 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261905AbTILVR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 17:17:28 -0400
In-Reply-To: <1063311558.2017.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On 11 Sep 2003, James Bottomley wrote:

> On Thu, 2003-09-11 at 16:05, Alan Stern wrote:
> > What do people think of just having per-device flags that the host driver
> > could set during the slave_configure() callback?  The point of these flags
> > is not to prevent bad commands from being sent to the device --
> > user-generated commands sent via sg should always be allowed.  Rather, the
> > point is to prevent sd.c from generating these commands in the first
> > place.  (Apparently the commands don't present a problem for sr.c.)
> 
> I'm not in principle opposed to this.  That's essentially what Andries
> did for the mode sense 6 vs 10 problem.
> 
> > So for example, usb-storage could set the BFLAG to block MODE-SENSE page 8
> > for any disk-type device.  This isn't a perfect solution; consider an
> > iSCSI-attached device that is actually a usb-storage disk on some server.  
> > Nevertheless, this might take care of the majority of the problems we see.  
> > (I haven't seen any MODE-SENSE page 0x3f problems, but others have.)
> 
> They can't be BLIST flags, they have to be flags in the struct
> scsi_device, but they're easy to add as long as we get a definitive list
> of what's necessary.

James and Matt:

Please tell us what you think of the two patches below.  The first patch 
introduces 2 bitflags: one causes sd.c to skip the mode-sense request for 
page 0x08 and the other causes it to skip the request for page(s) 0x3f.

The other patch makes usb-storage set the page-8 flag for disk-type
devices.  I didn't set the page-3f flag because I haven't noticed that
causing much problems.  If Matt wants to add it that will be easy to do;
if we end up not needing it then it will be easy to remove it from the
first patch.

Alan Stern


PATCH: (as95)
===== include/scsi/scsi_device.h 1.5 vs edited =====
--- 1.5/include/scsi/scsi_device.h	Fri Sep  5 07:48:41 2003
+++ edited/include/scsi/scsi_device.h	Fri Sep 12 16:17:08 2003
@@ -85,6 +85,8 @@
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned skip_ms_page_8:1;	/* do not MODE-SENSE for page 0x08 */
+	unsigned skip_ms_page_3f:1;	/* do not MODE-SENSE for page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
===== sd.c 1.56 vs edited =====
--- 1.56/drivers/scsi/sd.c	Fri Sep  5 12:16:39 2003
+++ edited/drivers/scsi/sd.c	Fri Sep 12 16:21:28 2003
@@ -1059,6 +1059,15 @@
 	struct scsi_mode_data data;
 
 	/*
+	 * Don't try to issue mode sense for page 0x3F if the device
+	 * won't like it.
+	 */
+	if (sdkp->device->skip_ms_page_3f) {
+		printk(KERN_NOTICE "%s: assuming Write Enabled\n", diskname);
+		return;
+	}
+
+	/*
 	 * First attempt: ask for all pages (0x3F), but only 4 bytes.
 	 * We have to start carefully: some devices hang if we ask
 	 * for more than is available.
@@ -1104,6 +1113,18 @@
 	const int modepage = 0x08; /* current values, cache page */
 	struct scsi_mode_data data;
 
+
+	/*
+	 * Don't try to issue mode sense for page 0x08 if the device
+	 * won't like it.
+	 */
+	if (sdkp->device->skip_ms_page_8) {
+		printk(KERN_NOTICE "%s: assuming drive cache: write through\n",
+		       diskname);
+		sdkp->WCE = 0;
+		sdkp->RCD = 0;
+		return;
+	}
 
 	/* cautiously ask */
 	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);


PATCH: (as96)
===== drivers/usb/storage/scsiglue.c 1.59 vs edited =====
--- 1.59/drivers/usb/storage/scsiglue.c	Mon Jul 28 14:29:04 2003
+++ edited/drivers/usb/storage/scsiglue.c	Fri Sep 12 16:55:26 2003
@@ -68,6 +68,12 @@
 	sdev->use_10_for_ms = 1;
 	sdev->use_10_for_rw = 1;
 
+	/* For disk-type devices, skip the mode-sense query for page 8
+	 * (the caching page).  Lots of USB Mass Storage devices crash
+	 * no matter how carefully we ask. */
+	if (sdev->type == TYPE_DISK)
+		sdev->skip_ms_page_8 = 1;
+
 	/* this is to satisify the compiler, tho I don't think the 
 	 * return code is ever checked anywhere. */
 	return 0;

