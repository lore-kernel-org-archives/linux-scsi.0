From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Subject: Re: External USB3 disk fails with "Invalid field in cdb"
Date: Fri, 27 Jun 2014 17:34:32 +0200
Message-ID: <20140627173432.46ea93bd@marge>
References: <20140626205519.314a71ae@wiggum>
 <20140627101540.GB10042@localhost.localdomain>
 <20140627142223.48c5c18f@wiggum>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49614 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbaF0Pg7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 11:36:59 -0400
In-Reply-To: <20140627142223.48c5c18f@wiggum>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: linux-scsi@vger.kernel.org

I tried the following patch:

Index: linux/drivers/scsi/sd.c
===================================================================
--- linux.orig/drivers/scsi/sd.c	2014-06-26 18:40:39.214696552 +0200
+++ linux/drivers/scsi/sd.c	2014-06-27 15:52:30.776159456 +0200
@@ -2440,7 +2440,7 @@ sd_read_cache_type(struct scsi_disk *sdk
 			sdkp->RCD = 0;
 		}
 
-		sdkp->DPOFUA = (data.device_specific & 0x10) != 0;
+		sdkp->DPOFUA = 0;
 		if (sdkp->DPOFUA && !sdkp->device->use_10_for_rw) {
 			sd_first_printk(KERN_NOTICE, sdkp,
 				  "Uses READ/WRITE(6), disabling FUA\n");
 

This obviously is not the correct thing to do, but it makes the disk usable:

Jun 27 17:26:50 marge kernel: [  523.909815] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
Jun 27 17:26:50 marge kernel: [  523.929246] usb 2-1: New USB device found, idVendor=152d, idProduct=0567
Jun 27 17:26:50 marge kernel: [  523.929258] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Jun 27 17:26:50 marge kernel: [  523.929265] usb 2-1: Product: USB to ATA/ATAPI Bridge
Jun 27 17:26:50 marge kernel: [  523.929271] usb 2-1: Manufacturer: JMicron
Jun 27 17:26:50 marge kernel: [  523.929276] usb 2-1: SerialNumber: xxx
Jun 27 17:26:50 marge kernel: [  523.930999] usb-storage 2-1:1.0: USB Mass Storage device detected
Jun 27 17:26:50 marge kernel: [  523.931237] scsi12 : usb-storage 2-1:1.0
Jun 27 17:26:51 marge kernel: [  524.930451] scsi 12:0:0:0: Direct-Access     JMicron  Generic          0114 PQ: 0 ANSI: 6
Jun 27 17:26:51 marge kernel: [  524.931228] sd 12:0:0:0: Attached scsi generic sg3 type 0
Jun 27 17:26:51 marge kernel: [  524.932964] sd 12:0:0:0: [sdd] Spinning up disk...
Jun 27 17:26:53 marge kernel: [  525.937848] ..ready
Jun 27 17:26:53 marge kernel: [  526.942395] sd 12:0:0:0: [sdd] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Jun 27 17:26:53 marge kernel: [  526.943037] sd 12:0:0:0: [sdd] Write Protect is off
Jun 27 17:26:53 marge kernel: [  526.943048] sd 12:0:0:0: [sdd] Mode Sense: 47 00 10 08
Jun 27 17:26:53 marge kernel: [  526.943662] sd 12:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jun 27 17:26:53 marge kernel: [  526.987919]  sdd: sdd1
Jun 27 17:26:53 marge kernel: [  526.990055] sd 12:0:0:0: [sdd] Attached SCSI disk
Jun 27 17:27:29 marge kernel: [  563.227849] EXT4-fs (sdd1): warning: mounting fs with errors, running e2fsck is recommended
Jun 27 17:27:29 marge kernel: [  563.228043] EXT4-fs (sdd1): mounted filesystem with ordered data mode. Opts: (null)

(This is on another machine, but it shows the same behavior without the patch.)

Does somebody have a hint for a real fix?

Note that I also tried the following change, which did _not_ fix the issue:

Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c	2014-06-27 17:30:27.901581410 +0200
+++ linux/drivers/scsi/scsi_lib.c	2014-06-27 17:32:12.044958922 +0200
@@ -824,7 +824,7 @@ void scsi_io_completion(struct scsi_cmnd
 			 * read past the end of the disk.
 			 */
 			if ((cmd->device->use_10_for_rw &&
-			    sshdr.asc == 0x20 && sshdr.ascq == 0x00) &&
+			    (sshdr.asc == 0x20 || sshdr.asc == 0x24) && sshdr.ascq == 0x00) &&
 			    (cmd->cmnd[0] == READ_10 ||
 			     cmd->cmnd[0] == WRITE_10)) {
 				/* This will issue a new 6-byte command. */

-- 
Michael
