From: James Bottomley <James.Bottomley@steeleye.com>
Subject: sd.c spinup code can go into a wild loop on unexpected device
	returns
Date: 08 May 2003 10:23:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052403833.2097.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-THExM0ai4wLsu502mKUa"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:17156 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261562AbTEHOLW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2003 10:11:22 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id h48ENrI32618
	for <linux-scsi@vger.kernel.org>; Thu, 8 May 2003 10:23:53 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-THExM0ai4wLsu502mKUa
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This problem was reported against 2.4 by Eddie.Williams@SteelEye.com

There's a problem in the sd spinup code in that if the unit returns NOT
READY, we begin to spin it up, but thereafter if it returns anything
other than NOT READY or success, the while loop in the spinup code will
be executed *without* the 1s delay that's in the NOT READY case.

The problem was seen with a real device: Compaq multi-path storage
arrays return NOT READY to probes down inactive paths, but when the
start unit is sent to activate the path, they can then respond back with
error conditions.

The fix is to terminate the while loop for any unexpected return.

James


--=-THExM0ai4wLsu502mKUa
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D drivers/scsi/sd.c 1.111 vs edited =3D=3D=3D=3D=3D
--- 1.111/drivers/scsi/sd.c	Wed May  7 10:15:39 2003
+++ edited/drivers/scsi/sd.c	Thu May  8 10:16:20 2003
@@ -811,7 +811,8 @@
 	       struct scsi_request *SRpnt, unsigned char *buffer) {
 	unsigned char cmd[10];
 	unsigned long spintime_value =3D 0;
-	int the_result, retries, spintime;
+	int retries, spintime;
+	unsigned int the_result;
=20
 	spintime =3D 0;
=20
@@ -820,7 +821,7 @@
 	do {
 		retries =3D 0;
=20
-		while (retries < 3) {
+		do {
 			cmd[0] =3D TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
=20
@@ -834,10 +835,9 @@
=20
 			the_result =3D SRpnt->sr_result;
 			retries++;
-			if (the_result =3D=3D 0
-			    || SRpnt->sr_sense_buffer[2] !=3D UNIT_ATTENTION)
-				break;
-		}
+		} while (retries < 3 && !scsi_status_is_good(the_result)
+			 && ((driver_byte(the_result) & DRIVER_SENSE)
+			     && SRpnt->sr_sense_buffer[2] =3D=3D UNIT_ATTENTION));
=20
 		/*
 		 * If the drive has indicated to us that it doesn't have
@@ -847,8 +847,15 @@
 		if (media_not_present(sdkp, SRpnt))
 			return;
=20
-		if (the_result =3D=3D 0)
-			break;		/* all is well now */
+		if ((driver_byte(the_result) & DRIVER_SENSE) =3D=3D 0) {
+			/* no sense, TUR either succeeded or failed
+			 * with a status error */
+			if(!spintime && !scsi_status_is_good(the_result))
+				printk(KERN_NOTICE "%s: Unit Not Ready, error =3D 0x%x\n", diskname, t=
he_result);
+			break;
+		}
+				=09
+				=09
=20
 		/*
 		 * If manual intervention is required, or this is an
@@ -856,13 +863,13 @@
 		 */
 		if (SRpnt->sr_sense_buffer[2] =3D=3D NOT_READY &&
 		    SRpnt->sr_sense_buffer[12] =3D=3D 4 /* not ready */ &&
-		    SRpnt->sr_sense_buffer[13] =3D=3D 3)
+		    SRpnt->sr_sense_buffer[13] =3D=3D 3) {
 			break;		/* manual intervention required */
=20
 		/*
 		 * Issue command to spin up drive when not ready
 		 */
-		if (SRpnt->sr_sense_buffer[2] =3D=3D NOT_READY) {
+		} else if (SRpnt->sr_sense_buffer[2] =3D=3D NOT_READY) {
 			unsigned long time1;
 			if (!spintime) {
 				printk(KERN_NOTICE "%s: Spinning up disk...",
@@ -889,15 +896,24 @@
 				time1 =3D schedule_timeout(time1);
 			} while(time1);
 			printk(".");
+		} else {
+			/* we don't understand the sense code, so it's
+			 * probably pointless to loop */
+			if(!spintime) {
+				printk(KERN_NOTICE "%s: Unit Not Ready, sense:\n", diskname);
+				print_req_sense("", SRpnt);
+			}
+			break;
 		}
+			=09
 	} while (spintime &&
 		 time_after(spintime_value + 100 * HZ, jiffies));
=20
 	if (spintime) {
-		if (the_result)
-			printk("not responding...\n");
-		else
+		if (scsi_status_is_good(the_result))
 			printk("ready\n");
+		else
+			printk("not responding...\n");
 	}
 }
=20

--=-THExM0ai4wLsu502mKUa--

