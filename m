From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Fw: garbled usb storage scsi vendor & model
 in 2.6.19-rc1
Date: Tue, 24 Oct 2006 16:30:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610241557500.6203-100000@iolanthe.rowland.org>
References: <Pine.SOC.4.61.0610242234560.8176@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:10 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S965183AbWJXUaz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Oct 2006 16:30:55 -0400
In-Reply-To: <Pine.SOC.4.61.0610242234560.8176@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Andrew Morton <akpm@osdl.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 24 Oct 2006, Meelis Roos wrote:

> > Here's the best thing to do to find out what is really happening:  Use the
> > usbmon facility to see exactly what data bytes are being sent to the
> > computer (instructions in Documentation/usb/usbmon.txt).  This will tell
> > us for certain whether those garbage bytes are left-over junk in RAM or
> > the device is actually sending them.

Here's the line that matters, from near the start of your log.  It 
contains the device's response to an INQUIRY command.

> ffff8100795e84c0 1469131296 C Bi:006:02 0 36 = 00800001 00000000 47454e45 52494320 55534220 4449534b 20444556 49434520

The fifth byte of the response is 0, meaning that all bytes past the fifth
are invalid.  This is kind of an odd thing to do; it says the device
hasn't really sent any vendor or product information at all.  That's why
you've been seeing garbage.

The Vendor string starts at byte position 8, the Product string at 
position 16, and the Revision string at position 32 (not captured by 
usbmon).  Translating the bytes from hex to ASCII gives:

	Vendor:  GENERIC 
	Product: USB DISK DEVICE 

These certainly _seem_ valid, albeit not very specific.  Perhaps the 
device's USB firmware was never customized for any OEM and the default 
state is marked invalid.

There's a comment about this in the source code, asking what should be
done if the INQUIRY response is too short (as it is here).  Maybe the best
approach would be always to assume the first 36 bytes are valid, even when
the device says they aren't.  It ought to solve your problem, and it's
no worse than what we're doing now.

The patch is below.  This replaces the patch I sent earlier.

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -575,6 +575,19 @@ static int scsi_probe_lun(struct scsi_de
 	 * short INQUIRY), an abort here prevents any further use of the
 	 * device, including spin up.
 	 *
+	 * On the whole, the best approach seems to be to assume the first
+	 * 36 bytes are valid no matter what the device says.  That's
+	 * better than copying < 36 bytes to the inquiry-result buffer
+	 * and displaying garbage for the Vendor, Product, or Revision
+	 * strings.
+	 */
+	if (sdev->inquiry_len < 36) {
+		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
+				" using 36\n", sdev->inquiry_len);
+		sdev->inquiry_len = 36;
+	}
+
+	/*
 	 * Related to the above issue:
 	 *
 	 * XXX Devices (disk or all?) should be sent a TEST UNIT READY,

