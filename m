From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch] fix drivers/scsi/sd.c warnings
Date: Thu, 19 Dec 2002 10:07:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212191607.gBJG7Je02395@localhost.localdomain>
References: <akpm@digeo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_-1531390780"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA05448
	for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2002 08:07:27 -0800
In-Reply-To: Message from Andrew Morton <akpm@digeo.com>
   of "Wed, 18 Dec 2002 22:04:08 PST." <3E016158.CC3D9909@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_-1531390780
Content-Type: text/plain; charset=us-ascii

akpm@digeo.com said:
> Somebody forgot to test with CONFIG_LBD=n: 

Well, OK, that would be me (but then you guessed that).

I enhanced your patch slightly, since we would get a wraparound on x86 without 
CONFIG_LBD for large devices, so now it will assume the maximum (2Tb) and 
print a warning.

Hopefully, it should also be obvious to the compiler at compile time that 
longrc can only be set if sizeof(block) > 4 and therefore allow it to optimise 
correctly (or am I just being optimistic).

That's also why I was reluctant to make block a u64, since then we'd always 
run the > 0xffffffff test, which we know will never be true if LBD is not set.

How does the attached work?

James


--==_Exmh_-1531390780
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== drivers/scsi/sd.c 1.98 vs edited =====
--- 1.98/drivers/scsi/sd.c	Tue Dec 17 12:21:56 2002
+++ edited/drivers/scsi/sd.c	Thu Dec 19 09:59:10 2002
@@ -301,10 +301,10 @@
 	
 	if (block > 0xffffffff) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
-		SCpnt->cmnd[2] = (unsigned char) (block >> 56) & 0xff;
-		SCpnt->cmnd[3] = (unsigned char) (block >> 48) & 0xff;
-		SCpnt->cmnd[4] = (unsigned char) (block >> 40) & 0xff;
-		SCpnt->cmnd[5] = (unsigned char) (block >> 32) & 0xff;
+		SCpnt->cmnd[2] = sizeof(block) > 4 ? (unsigned char) (block >> 56) & 0xff : 0;
+		SCpnt->cmnd[3] = sizeof(block) > 4 ? (unsigned char) (block >> 48) & 0xff : 0;
+		SCpnt->cmnd[4] = sizeof(block) > 4 ? (unsigned char) (block >> 40) & 0xff : 0;
+		SCpnt->cmnd[5] = sizeof(block) > 4 ? (unsigned char) (block >> 32) & 0xff : 0;
 		SCpnt->cmnd[6] = (unsigned char) (block >> 24) & 0xff;
 		SCpnt->cmnd[7] = (unsigned char) (block >> 16) & 0xff;
 		SCpnt->cmnd[8] = (unsigned char) (block >> 8) & 0xff;
@@ -931,7 +931,7 @@
 		if (longrc) {
 			memset((void *) cmd, 0, 16);
 			cmd[0] = SERVICE_ACTION_IN;
-			cmd[1] = 0x10; /* READ CAPACITY (16) */
+			cmd[1] = SAI_READ_CAPACITY_16;
 			cmd[13] = 12;
 			memset((void *) buffer, 0, 12);
 		} else {
@@ -1002,21 +1002,25 @@
 		sector_size = (buffer[4] << 24) |
 			(buffer[5] << 16) | (buffer[6] << 8) | buffer[7];
 		if (buffer[0] == 0xff && buffer[1] == 0xff &&
-			buffer[2] == 0xff && buffer[3] == 0xff) {
-			printk(KERN_NOTICE "%s : very big device. try to use"
-				" READ CAPACITY(16).\n", diskname);
-			longrc = 1;
-			goto repeat;
+		    buffer[2] == 0xff && buffer[3] == 0xff) {
+			if(sizeof(sdkp->capacity) > 4) {
+				printk(KERN_NOTICE "%s : very big device. try to use"
+				       " READ CAPACITY(16).\n", diskname);
+				longrc = 1;
+				goto repeat;
+			} else {
+				printk(KERN_ERR "%s: too big for kernel.  Assuming maximum 2Tb\n", diskname);
+			}
 		}
 		sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
 			(buffer[1] << 16) |
 			(buffer[2] << 8) |
 			buffer[3]);			
 	} else {
-		sdkp->capacity = 1 + (((sector_t)buffer[0] << 56) |
-			((sector_t)buffer[1] << 48) |
-			((sector_t)buffer[2] << 40) |
-			((sector_t)buffer[3] << 32) |
+		sdkp->capacity = 1 + (((u64)buffer[0] << 56) |
+			((u64)buffer[1] << 48) |
+			((u64)buffer[2] << 40) |
+			((u64)buffer[3] << 32) |
 			((sector_t)buffer[4] << 24) |
 			((sector_t)buffer[5] << 16) |
 			((sector_t)buffer[6] << 8)  |
===== include/scsi/scsi.h 1.7 vs edited =====
--- 1.7/include/scsi/scsi.h	Tue Dec 17 12:21:56 2002
+++ edited/include/scsi/scsi.h	Thu Dec 19 09:59:56 2002
@@ -99,6 +99,8 @@
 #define READ_16               0x88
 #define WRITE_16              0x8a
 #define SERVICE_ACTION_IN     0x9e
+/* values for service action in */
+#define	SAI_READ_CAPACITY_16  0x10
 
 
 /*

--==_Exmh_-1531390780--


