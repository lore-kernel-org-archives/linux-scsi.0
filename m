From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Wed, 20 Oct 2004 11:48:34 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410201130460.638-100000@ida.rowland.org>
References: <41765CD1.8060108@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:1284 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268404AbUJTPsh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Oct 2004 11:48:37 -0400
In-Reply-To: <41765CD1.8060108@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Adriaan Penning <a.penning@luon.net>, Darsen Lu <darsen@micro.ee.nthu.edu.tw>, Eero Volotinen <eero@ping-viini.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>

People:

We would like to test a method for determining automatically when the 
capacity value returned by a drive is too high.  If this works it means 
that the unusual_devs.h entries for your devices can be removed, and we'll 
never be troubled by similarly broken devices again.

Please try applying the patches below.  The first one removes the existing
unusual_devs entries and the second one includes the code we want to test.  
Test results are written to the system log, and you don't need to turn on
the usb-storage verbose debugging.  In your replies, include the dmesg 
output showing what happens when you plug in or turn on your drives.

Thanks for your help,

Alan Stern

P.S.: Luben, I took the liberty of adding a routine to try out the 
READ FORMAT CAPACITIES command just to see how well it works.  Probably a 
lot of USB disk-like devices support the command since it is used by 
Windows.


First patch:

===== drivers/usb/storage/unusual_devs.h 1.160 vs edited =====
--- 1.160/drivers/usb/storage/unusual_devs.h	2004-10-16 04:56:53 -04:00
+++ edited/drivers/usb/storage/unusual_devs.h	2004-10-20 11:34:13 -04:00
@@ -171,16 +171,6 @@
 		"CD-R/RW Drive",
 		US_SC_8070, US_PR_CB, NULL, 0),
 
-/* Reported by Adriaan Penning <a.penning@luon.net>
- * Note that these cameras report "Medium not present" after
- * ALLOW_MEDIUM_REMOVAL, so they also need to be marked
- * NOT_LOCKABLE in the SCSI blacklist (and the vendor is MATSHITA). */
-UNUSUAL_DEV(  0x04da, 0x2372, 0x0000, 0x9999,
-		"Panasonic",
-		"DMC-LCx Camera",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY ),
-
 /* Most of the following entries were developed with the help of
  * Shuttle/SCM directly.
  */
@@ -483,13 +473,6 @@
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
@@ -546,13 +529,6 @@
 		"USB-IDE",
 		US_SC_QIC, US_PR_FREECOM, freecom_init, 0),
 #endif
-
-/* Reported by Eero Volotinen <eero@ping-viini.org> */
-UNUSUAL_DEV(  0x07ab, 0xfccd, 0x0406, 0x0406,
-		"Freecom Technologies",
-		"FHD-Classic",
-		US_SC_DEVICE, US_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY),
 
 UNUSUAL_DEV(  0x07af, 0x0004, 0x0100, 0x0133, 
 		"Microtech",



Second patch:

===== drivers/scsi/sd.c 1.72 vs edited =====
--- 1.72/drivers/scsi/sd.c	2004-09-13 12:46:37 -04:00
+++ edited/drivers/scsi/sd.c	2004-10-20 11:13:26 -04:00
@@ -990,6 +990,171 @@
 	}
 }
 
+/* sd_read_true_cap: Some device servers incorrectly return the
+ * capacity as opposed to the LBA of the last logical block of the
+ * block device.
+ *
+ * We try to fix this as follows: Let x = Returned LBA from the last
+ * READ CAPACITY command issued (result in "buffer").  Reissue the
+ * READ CAPACITY command as follows: set the partial medium indicator
+ * (PMI) bit to one; set the LBA to x - 1. Fire off that READ CAPACITY
+ * command.
+ *
+ * If we get success,
+ *       If Returned LBA > x - 1, then capacity is x+1, spec behavior.
+ *       Else Returned LBA <= x - 1, then capacity is x, broken device server.
+ * Else error, nothing can be assumed, capacity is x+1.
+ */
+#define GET_RLBA_READ_CAP16(_buffer) (((u64)(_buffer)[0] << 56) | \
+				     ((u64)(_buffer)[1] << 48) |  \
+				     ((u64)(_buffer)[2] << 40) |  \
+				     ((u64)(_buffer)[3] << 32) |  \
+				     ((sector_t)(_buffer)[4] << 24) | \
+				     ((sector_t)(_buffer)[5] << 16) | \
+				     ((sector_t)(_buffer)[6] << 8)  | \
+				     (sector_t)(_buffer)[7])
+#define GET_RLBA_READ_CAP10(_buffer) (((sector_t)(_buffer)[0] << 24) | \
+				      ((_buffer)[1] << 16) |           \
+				      ((_buffer)[2] << 8) |            \
+				      (_buffer)[3])
+static void sd_read_true_cap(struct scsi_disk *sd, char *diskname,
+			     struct scsi_request *SRpnt, unsigned char *buffer,
+			     int longrc)
+{
+	unsigned char cmd[16];
+	unsigned char buf[12];
+
+	/* save the old buffer contents here */
+	memcpy(buf, buffer, 12);
+
+	if (longrc) {
+		u64 *lba = (u64 *) (cmd+2);
+		u64 rlba;
+
+		memset((void *) cmd, 0, 16);
+		cmd[0] = SERVICE_ACTION_IN;
+		cmd[1] = SAI_READ_CAPACITY_16;
+		cmd[13] = 12;
+
+		rlba = GET_RLBA_READ_CAP16(buffer);
+		rlba -= 1;
+		*lba = cpu_to_be64(rlba);
+		/* turn on the PMI bit */
+		cmd[14] |= 1;
+		memset((void *) buffer, 0, 12);
+	} else {
+		u32 *lba = (u32 *) (cmd+2);
+		u32 rlba;
+
+		cmd[0] = READ_CAPACITY;
+		memset((void *) &cmd[1], 0, 9);
+		
+		rlba = GET_RLBA_READ_CAP10(buffer);
+		rlba -= 1;
+		*lba = cpu_to_be32(rlba);
+		/* turn on the PMI bit */
+		cmd[8] |= 1;
+		memset((void *) buffer, 0, 8);
+	}
+
+	SRpnt->sr_cmd_len = 0;
+	SRpnt->sr_sense_buffer[0] = 0;
+	SRpnt->sr_sense_buffer[2] = 0;
+	SRpnt->sr_data_direction = DMA_FROM_DEVICE;
+	
+	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
+		      longrc ? 12 : 8, SD_TIMEOUT, SD_MAX_RETRIES);
+
+	if (SRpnt->sr_result) {
+		/* Nothing can be assumed. */
+		printk(KERN_NOTICE "%s: %s: PMI not supported\n",
+		       __FUNCTION__, diskname);
+		memcpy(buffer, buf, 12);
+		return;
+	}
+
+	if (longrc) {
+		u64 rlba = GET_RLBA_READ_CAP16(buffer);
+		u64 x    = GET_RLBA_READ_CAP16(buf);
+		if (rlba > x - 1) {
+			goto out_spec;
+		}
+	} else {
+		u32 rlba = GET_RLBA_READ_CAP10(buffer);
+		u32 x    = GET_RLBA_READ_CAP10(buf);
+		if (rlba > x - 1) {
+			goto out_spec;
+		}
+	}
+	printk(KERN_NOTICE "%s: %s: broken device server\n", __FUNCTION__,
+	       diskname);
+	return;
+	
+ out_spec:
+	/* Capacity is x+1, spec behavior. */
+	printk(KERN_NOTICE "%s: %s: spec behavior\n", __FUNCTION__, diskname);
+	memcpy(buffer, buf, 12);
+} /* end sd_read_true_cap() */
+
+/* Try to use the READ FORMAT CAPACITIES command to check whether the
+ * READ CAPACITY result is correct.
+ */
+static void sd_read_format_cap(struct scsi_disk *sd, char *diskname,
+			     struct scsi_request *SRpnt, unsigned char *buffer)
+{
+	unsigned char cmd[12];
+	unsigned char buf[12];
+	u32 rlba;
+	u32 x;
+
+	/* save the old buffer contents here */
+	memcpy(buf, buffer, 12);
+
+	rlba = GET_RLBA_READ_CAP10(buffer);
+
+	cmd[0] = 0x23;		/* READ_FORMAT_CAPACITIES */
+	memset(&cmd[1], 0, 11);
+	cmd[8] = 12;
+	memset(buffer, 0, 12);
+
+	SRpnt->sr_cmd_len = 0;
+	SRpnt->sr_sense_buffer[0] = 0;
+	SRpnt->sr_sense_buffer[2] = 0;
+	SRpnt->sr_data_direction = DMA_FROM_DEVICE;
+
+	scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
+		      12, SD_TIMEOUT, SD_MAX_RETRIES);
+
+	if (SRpnt->sr_result) {
+		/* Nothing can be assumed. */
+		printk(KERN_NOTICE "%s: %s: READ FORMAT CAPACITIES not supported\n",
+		       __FUNCTION__, diskname);
+		goto done;
+	}
+
+	if ((buffer[8] & 3) != 2) {
+		printk(KERN_NOTICE "%s: %s: no media or unformatted media\n",
+		       __FUNCTION__, diskname);
+		goto done;
+	}
+
+	x = GET_RLBA_READ_CAP10(buffer + 4);
+	printk(KERN_NOTICE "%s: %s: %u vs. %u\n",
+		       __FUNCTION__, diskname, rlba, x);
+	if (x > 0 && x <= rlba) {
+		printk(KERN_NOTICE "%s: %s: using lower capacity\n",
+		       __FUNCTION__, diskname);
+		--x;
+		buf[0] = (unsigned char) (x >> 24);
+		buf[1] = (unsigned char) (x >> 16);
+		buf[2] = (unsigned char) (x >> 8);
+		buf[3] = (unsigned char) x;
+	}
+
+done:
+	memcpy(buffer, buf, 12);
+}
+
 /*
  * read disk capacity
  */
@@ -1073,7 +1238,14 @@
 		
 		sdkp->capacity = 1 + (sector_t) 0xffffffff;		
 		goto got_data;
-	}	
+	}
+
+	/* Check if the device reported CAPACITY as opposed to
+	 * the maxumum LBA (as per the SBC spec).
+	 */
+	sd_read_true_cap(sdkp, diskname, SRpnt, buffer, longrc);
+	if (!longrc)
+		sd_read_format_cap(sdkp, diskname, SRpnt, buffer);
 	
 	if (!longrc) {
 		sector_size = (buffer[4] << 24) |
@@ -1081,12 +1253,14 @@
 		if (buffer[0] == 0xff && buffer[1] == 0xff &&
 		    buffer[2] == 0xff && buffer[3] == 0xff) {
 			if(sizeof(sdkp->capacity) > 4) {
-				printk(KERN_NOTICE "%s : very big device. try to use"
-				       " READ CAPACITY(16).\n", diskname);
+				printk(KERN_NOTICE "%s : very big device. "
+				       "try to use READ CAPACITY(16).\n",
+				       diskname);
 				longrc = 1;
 				goto repeat;
 			} else {
-				printk(KERN_ERR "%s: too big for kernel.  Assuming maximum 2Tb\n", diskname);
+				printk(KERN_ERR "%s: too big for kernel. "
+				       "Assuming maximum 2Tb\n", diskname);
 			}
 		}
 		sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
@@ -1105,7 +1279,7 @@
 			
 		sector_size = (buffer[8] << 24) |
 			(buffer[9] << 16) | (buffer[10] << 8) | buffer[11];
-	}	
+	}
 
 got_data:
 	if (sector_size == 0) {

