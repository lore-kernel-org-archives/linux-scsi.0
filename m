From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Wed, 27 Oct 2004 15:11:57 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410271507560.783-100000@ida.rowland.org>
References: <417F6412.90000@micro.ee.nthu.edu.tw>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5124 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262649AbUJ0TL6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2004 15:11:58 -0400
In-Reply-To: <417F6412.90000@micro.ee.nthu.edu.tw>
List-Id: linux-scsi@vger.kernel.org
To: Darsen <darsen@micro.ee.nthu.edu.tw>
Cc: Eero Volotinen <eero@ping-viini.org>, Adriaan Penning <a.penning@luon.net>, Andries Brouwer <aebr@win.tue.nl>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 27 Oct 2004, Darsen wrote:

> I applied this patch but failed in many places.
> neither kernel 2.6.8.1 nor 2.6.9 works.
> 
> Could you tell me what version it should be applied on?
> 
> Thanks

Sorry, that patch was meant for 2.6.10-rc1 (and a development version, not 
the standard version at that).  Below is the equivalent patch for vanilla 
2.6.9.  Thanks for testing it.

Alan Stern



diff -ur linux-2.6.9/drivers/scsi/sd.c linux-2.6.9-new/drivers/scsi/sd.c
--- linux-2.6.9/drivers/scsi/sd.c	2004-10-27 14:55:30.000000000 -0400
+++ linux-2.6.9-new/drivers/scsi/sd.c	2004-10-27 14:57:17.000000000 -0400
@@ -1129,6 +1129,16 @@
 		 */
 		sdkp->capacity = 0;
 	}
+
+	/* Handle broken devices that return the total number of sectors
+	 * rather than the highest sector number, by forcing the total
+	 * number to be even. */
+	if (sdp->even_capacity && (sdkp->capacity & 1)) {
+		printk(KERN_NOTICE "%s : odd number of sectors reported, "
+			"decreasing by one.\n", diskname);
+		--sdkp->capacity;
+	}
+
 	{
 		/*
 		 * The msdos fs needs to know the hardware sector size
diff -ur linux-2.6.9/drivers/usb/storage/protocol.c linux-2.6.9-new/drivers/usb/storage/protocol.c
--- linux-2.6.9/drivers/usb/storage/protocol.c	2004-10-27 14:50:20.000000000 -0400
+++ linux-2.6.9-new/drivers/usb/storage/protocol.c	2004-10-27 14:58:29.000000000 -0400
@@ -89,35 +89,6 @@
 			&index, &offset, TO_XFER_BUF);
 }
 
-/*
- * Fix-up the return data from a READ CAPACITY command. My Feiya reader
- * returns a value that is 1 too large.
- */
-static void fix_read_capacity(struct scsi_cmnd *srb)
-{
-	unsigned int index, offset;
-	__be32 c;
-	unsigned long capacity;
-
-	/* verify that it's a READ CAPACITY command */
-	if (srb->cmnd[0] != READ_CAPACITY)
-		return;
-
-	index = offset = 0;
-	if (usb_stor_access_xfer_buf((unsigned char *) &c, 4, srb,
-			&index, &offset, FROM_XFER_BUF) != 4)
-		return;
-
-	capacity = be32_to_cpu(c);
-	US_DEBUGP("US: Fixing capacity: from %ld to %ld\n",
-	       capacity+1, capacity);
-	c = cpu_to_be32(capacity - 1);
-
-	index = offset = 0;
-	usb_stor_access_xfer_buf((unsigned char *) &c, 4, srb,
-			&index, &offset, TO_XFER_BUF);
-}
-
 /***********************************************************************
  * Protocol routines
  ***********************************************************************/
@@ -224,10 +195,6 @@
 	if (srb->result == SAM_STAT_GOOD) {
 		/* Fix the INQUIRY data if necessary */
 		fix_inquiry_data(srb);
-
-		/* Fix the READ CAPACITY result if necessary */
-		if (us->flags & US_FL_FIX_CAPACITY)
-			fix_read_capacity(srb);
 	}
 }
 
diff -ur linux-2.6.9/drivers/usb/storage/scsiglue.c linux-2.6.9-new/drivers/usb/storage/scsiglue.c
--- linux-2.6.9/drivers/usb/storage/scsiglue.c	2004-10-27 14:50:20.000000000 -0400
+++ linux-2.6.9-new/drivers/usb/storage/scsiglue.c	2004-10-27 14:59:38.000000000 -0400
@@ -135,6 +135,12 @@
 		sdev->skip_ms_page_3f = 1;
 #endif
 
+		/* Some devices return the total number of blocks in
+		 * response to READ CAPACITY instead of the highest
+		 * block number.  Deal with this by forcing the number
+		 * of blocks to be even.  Fortunately no existing USB
+		 * drive has an odd number of blocks, so far as I know! */
+		sdev->even_capacity = 1;
 	} else {
 
 		/* Non-disk-type devices don't need to blacklist any pages
@@ -358,7 +364,6 @@
 		DO_FLAG(SINGLE_LUN);
 		DO_FLAG(SCM_MULT_TARG);
 		DO_FLAG(FIX_INQUIRY);
-		DO_FLAG(FIX_CAPACITY);
 
 		*(pos++) = '\n';
 	}
diff -ur linux-2.6.9/drivers/usb/storage/unusual_devs.h linux-2.6.9-new/drivers/usb/storage/unusual_devs.h
--- linux-2.6.9/drivers/usb/storage/unusual_devs.h	2004-10-27 14:50:20.000000000 -0400
+++ linux-2.6.9-new/drivers/usb/storage/unusual_devs.h	2004-10-27 15:00:29.000000000 -0400
@@ -490,13 +490,6 @@
 		US_FL_SINGLE_LUN ),
 #endif
 
-/* Reported by Darsen Lu <darsen@micro.ee.nthu.edu.tw> */
-UNUSUAL_DEV( 0x066f, 0x8000, 0x0001, 0x0001,
-		"SigmaTel",
-		"USBMSC Audio Player",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY ),
-
 /* Submitted by Benny Sjostrand <benny@hostmobility.com> */
 UNUSUAL_DEV( 0x0686, 0x4011, 0x0001, 0x0001,
 		"Minolta",
@@ -711,13 +704,6 @@
 		US_SC_RBC, US_PR_BULK, NULL,
 		US_FL_MODE_XLATE),
 
-/* aeb */
-UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
-		"Feiya",
-		"5-in-1 Card Reader",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY ),
-
 UNUSUAL_DEV(  0x097a, 0x0001, 0x0000, 0x0001,
 		"Minds@Work",
 		"Digital Wallet",
diff -ur linux-2.6.9/drivers/usb/storage/usb.h linux-2.6.9-new/drivers/usb/storage/usb.h
--- linux-2.6.9/drivers/usb/storage/usb.h	2004-10-27 14:50:20.000000000 -0400
+++ linux-2.6.9-new/drivers/usb/storage/usb.h	2004-10-27 15:01:01.000000000 -0400
@@ -72,7 +72,7 @@
 #define US_FL_IGNORE_SER      0		 /* [no longer used]		    */
 #define US_FL_SCM_MULT_TARG   0x00000020 /* supports multiple targets	    */
 #define US_FL_FIX_INQUIRY     0x00000040 /* INQUIRY response needs faking   */
-#define US_FL_FIX_CAPACITY    0x00000080 /* READ CAPACITY response too big  */
+#define US_FL_FIX_CAPACITY    0		 /* [no longer used]		    */
 
 /* Dynamic flag definitions: used in set_bit() etc. */
 #define US_FLIDX_URB_ACTIVE	18  /* 0x00040000  current_urb is in use  */
diff -ur linux-2.6.9/include/scsi/scsi_device.h linux-2.6.9-new/include/scsi/scsi_device.h
--- linux-2.6.9/include/scsi/scsi_device.h	2004-10-27 14:50:56.000000000 -0400
+++ linux-2.6.9-new/include/scsi/scsi_device.h	2004-10-27 14:56:36.000000000 -0400
@@ -106,6 +106,7 @@
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
+	unsigned even_capacity:1; /* must have an even number of sectors */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 

