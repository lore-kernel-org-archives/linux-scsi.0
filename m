From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH as540] sd: pause in sd_spinup_disk for slow USB devices
Date: Tue, 12 Jul 2005 10:45:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0507121038230.5351-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:5356 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261368AbVGLOpT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2005 10:45:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Roberts-Thomson, James" <James.Roberts-Thomson@NBNZ.CO.NZ>, SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch adds a delay tailored for USB flash devices that are slow to 
initialize their firmware.  The symptom is a repeated Unit Attention with 
ASC=0x28 (Not Ready to Ready transition).  The patch will wait for up to 5 
seconds for such devices to become ready.  Normal devices won't send the 
repeated Unit Attention sense key and hence won't trigger the patch.

This fixes a problem with James Roberts-Thomson's USB device, and I've 
seen several reports of other devices exhibiting the same symptoms -- 
presumably they will be helped as well.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -987,7 +987,7 @@ static void
 sd_spinup_disk(struct scsi_disk *sdkp, char *diskname,
 	       struct scsi_request *SRpnt, unsigned char *buffer) {
 	unsigned char cmd[10];
-	unsigned long spintime_value = 0;
+	unsigned long spintime_expire = 0;
 	int retries, spintime;
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
@@ -1074,12 +1074,27 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 				scsi_wait_req(SRpnt, (void *)cmd, 
 					      (void *) buffer, 0/*512*/, 
 					      SD_TIMEOUT, SD_MAX_RETRIES);
-				spintime_value = jiffies;
+				spintime_expire = jiffies + 100 * HZ;
+				spintime = 1;
 			}
-			spintime = 1;
 			/* Wait 1 second for next try */
 			msleep(1000);
 			printk(".");
+
+		/*
+		 * Wait for USB flash devices with slow firmware.
+		 * Yes, this sense key/ASC combination shouldn't
+		 * occur here.  It's characteristic of these devices.
+		 */
+		} else if (sense_valid &&
+				sshdr.sense_key == UNIT_ATTENTION &&
+				sshdr.asc == 0x28) {
+			if (!spintime) {
+				spintime_expire = jiffies + 5 * HZ;
+				spintime = 1;
+			}
+			/* Wait 1 second for next try */
+			msleep(1000);
 		} else {
 			/* we don't understand the sense code, so it's
 			 * probably pointless to loop */
@@ -1091,8 +1106,7 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 			break;
 		}
 				
-	} while (spintime &&
-		 time_after(spintime_value + 100 * HZ, jiffies));
+	} while (spintime && time_before_eq(jiffies, spintime_expire));
 
 	if (spintime) {
 		if (scsi_status_is_good(the_result))

