From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: [BUG] USB Storage OOPS and a D state
 process in 2.6.10
Date: Fri, 7 Jan 2005 23:03:29 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0501072252200.13748-100000@netrider.rowland.org>
References: <200501081143.12636.harisri@internode.on.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:57610 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S261781AbVAHEDa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2005 23:03:30 -0500
In-Reply-To: <200501081143.12636.harisri@internode.on.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Srihari Vijayaraghavan <harisri@internode.on.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 8 Jan 2005, Srihari Vijayaraghavan wrote:

> Alan,
> 
> I have made a couple of observations:
> 1. While it is still easy to trigger this bug without USB Storage Debug Option 
> in vanilla 2.6.10, I cannot reproduce the bug with debug option. Perhaps it 
> changes some timings.

Certainly it changes timings.

> (Without debug option, within a dozen plug/unplug events I can reliably 
> trigger the bug, but OTOH with debug options I cannot even after 50 events. 
> Maybe I should run my desktop with debug option for better stability. :-))
> 
> 2. When running without debug option, the D state "hald" process appears 
> first, and upon unplugging the drive an OOPS appears on the very next 
> plugging of the drive.

It sounds like the problem occurs in hald, and the later oops is just a 
symptom whose cause came much earlier.

> Here is the new OOPS:
> 
> usb-storage: device found at 7
> usb-storage: waiting for device to settle before scanning
> Unable to handle kernel paging request at 0000001600000019 RIP:
> <ffffffffa0108259>{:usb_storage:bus_reset+73}

I don't suppose you're familiar enough with 64-bit assembler to be able to 
decode the low-level instruction listing and tell me which line of the 
bus_reset routine corresponds to offset 73?

Failing that, maybe you can try applying this patch.  It will print some 
extra debugging information in the system log, even with 
CONFIG_USB_STORAGE_DEBUG not set.

Alan Stern



--- 2.6.10-orig/drivers/usb/storage/scsiglue.c	Mon Jan  3 09:39:36 2005
+++ 2.6.10/drivers/usb/storage/scsiglue.c	Fri Jan  7 22:59:51 2005
@@ -268,9 +268,15 @@
 /* This is always called with scsi_lock(srb->host) held */
 static int bus_reset(struct scsi_cmnd *srb)
 {
-	struct us_data *us = (struct us_data *)srb->device->host->hostdata[0];
+	struct us_data *us;
 	int result, rc;
 
+	printk(KERN_INFO "In bus_reset, srb: %p\n", srb);
+	printk("  device: %p\n", srb->device);
+	printk("  host: %p\n", srb->device->host);
+	printk("  hostdata: %p\n", (void *) srb->device->host->hostdata[0]);
+
+	us = (struct us_data *)srb->device->host->hostdata[0];
 	US_DEBUGP("%s called\n", __FUNCTION__);
 
 	scsi_unlock(srb->device->host);

