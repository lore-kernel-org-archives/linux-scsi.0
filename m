From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH as398] sd.c: adjust READ_CAPACITY for broken devices
Date: Tue, 9 Nov 2004 09:50:13 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0411090943070.951-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:516 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261549AbUKIOuR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2004 09:50:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

A number of USB mass storage devices return the wrong value in response to 
READ CAPACITY: They give the total number of blocks rather than the 
highest block number.  Currently the usb-storage driver tries to adjust 
for this by altering the contents of the reply buffer.  That's not a very 
good idea because it prevents users from seeing what the device actually 
has to say; it violates the principle that a transport should do nothing 
more than transfer data.

This patch moves the responsibility for adjusting the capacity to the sd 
driver instead, by adding a new device flag.  After this has been merged 
the corresponding change (to set the flag) will be made to the usb-storage 
driver.

Please apply.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== include/scsi/scsi_device.h 1.14 vs edited =====
--- 1.14/include/scsi/scsi_device.h	2004-10-05 11:47:13 -04:00
+++ edited/include/scsi/scsi_device.h	2004-11-08 15:42:52 -05:00
@@ -111,6 +111,7 @@
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
+	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
===== drivers/scsi/sd.c 1.73 vs edited =====
--- 1.73/drivers/scsi/sd.c	2004-10-20 12:24:44 -04:00
+++ edited/drivers/scsi/sd.c	2004-11-08 15:42:37 -05:00
@@ -1104,6 +1104,11 @@
 			(buffer[9] << 16) | (buffer[10] << 8) | buffer[11];
 	}	
 
+	/* Some devices return the total number of sectors, not the
+	 * highest sector number.  Make the necessary adjustment. */
+	if (sdp->fix_capacity)
+		--sdkp->capacity;
+
 got_data:
 	if (sector_size == 0) {
 		sector_size = 512;

