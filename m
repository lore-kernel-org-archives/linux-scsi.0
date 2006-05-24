From: Michael Reed <mdr@sgi.com>
Subject: [REPOST][PATCH 5/6] mpt fusion - abort of board reset leaves port
 dead requiring reboot
Date: Wed, 24 May 2006 15:07:57 -0500
Message-ID: <4474BD1D.6080600@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050406010801000507010102"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:41113 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S932257AbWEXUIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 May 2006 16:08:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

This is a multi-part message in MIME format.
--------------050406010801000507010102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The driver uses msleep_interruptible() in the code path responsible
for resetting the card's ports via the lsiutil command.  If a
<ctrl-c> is received during the reset it can leave a port in such
a state that the only way to regain its use is to reboot the system.
Changing from msleep_interruptible() to msleep() corrects the problem.

(Unchanged from last posting.)

Signed-off-by: Michael Reed <mdr@sgi.com>





--------------050406010801000507010102
Content-Type: text/x-patch;
 name="05-mptfc_msleep.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05-mptfc_msleep.patch"

The driver uses msleep_interruptible() in the code path responsible
for resetting the card's ports via the lsiutil command.  If a
<ctrl-c> is received during the reset it can leave a port in such
a state that the only way to regain its use is to reboot the system.
Changing from msleep_interruptible() to msleep() corrects the problem.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- rc4u/drivers/message/fusion/mptbase.c	2006-05-18 16:34:08.109594401 -0500
+++ rc4/drivers/message/fusion/mptbase.c	2006-05-18 16:36:24.094798383 -0500
@@ -2279,7 +2279,7 @@
 		}
 
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible(1);
+			msleep(1);
 		} else {
 			mdelay (1);	/* 1 msec delay */
 		}
@@ -2667,7 +2667,7 @@
 	state = mpt_GetIocState(ioc, 1);
 	while (state != MPI_IOC_STATE_OPERATIONAL && --cntdn) {
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible(1);
+			msleep(1);
 		} else {
 			mdelay(1);
 		}
@@ -2919,7 +2919,7 @@
 
 	/* wait 1 msec */
 	if (sleepFlag == CAN_SLEEP) {
-		msleep_interruptible(1);
+		msleep(1);
 	} else {
 		mdelay (1);
 	}
@@ -2936,7 +2936,7 @@
 		}
 		/* wait .1 sec */
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible (100);
+			msleep (100);
 		} else {
 			mdelay (100);
 		}
@@ -3026,7 +3026,7 @@
 
 		/* wait 1 msec */
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible (1);
+			msleep (1);
 		} else {
 			mdelay (1);
 		}
@@ -3074,7 +3074,7 @@
 			return 0;
 		}
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible (10);
+			msleep (10);
 		} else {
 			mdelay (10);
 		}
@@ -3125,7 +3125,7 @@
 		SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag);
 
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible (1000);
+			msleep (1000);
 		} else {
 			mdelay (1000);
 		}
@@ -3147,7 +3147,7 @@
 			return hard_reset_done;
 		}
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible (10);
+			msleep (10);
 		} else {
 			mdelay (10);
 		}
@@ -3218,7 +3218,7 @@
 
 			/* wait 100 msec */
 			if (sleepFlag == CAN_SLEEP) {
-				msleep_interruptible (100);
+				msleep (100);
 			} else {
 				mdelay (100);
 			}
@@ -3297,7 +3297,7 @@
 
 				/* wait 1 sec */
 				if (sleepFlag == CAN_SLEEP) {
-					msleep_interruptible (1000);
+					msleep (1000);
 				} else {
 					mdelay (1000);
 				}
@@ -3325,7 +3325,7 @@
 
 				/* wait 1 sec */
 				if (sleepFlag == CAN_SLEEP) {
-					msleep_interruptible (1000);
+					msleep (1000);
 				} else {
 					mdelay (1000);
 				}
@@ -3359,7 +3359,7 @@
 
 		/* wait 100 msec */
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible (100);
+			msleep (100);
 		} else {
 			mdelay (100);
 		}
@@ -3453,7 +3453,7 @@
 		}
 
 		if (sleepFlag == CAN_SLEEP) {
-			msleep_interruptible(1);
+			msleep(1);
 		} else {
 			mdelay (1);	/* 1 msec delay */
 		}
@@ -3893,7 +3893,7 @@
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (! (intstat & MPI_HIS_IOP_DOORBELL_STATUS))
 				break;
-			msleep_interruptible (1);
+			msleep (1);
 			count++;
 		}
 	} else {
@@ -3942,7 +3942,7 @@
 			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
 			if (intstat & MPI_HIS_DOORBELL_INTERRUPT)
 				break;
-			msleep_interruptible(1);
+			msleep(1);
 			count++;
 		}
 	} else {
--- rc4u/drivers/message/fusion/mptfc.c	2006-05-18 16:35:11.290436058 -0500
+++ rc4/drivers/message/fusion/mptfc.c	2006-05-18 16:36:24.094798383 -0500
@@ -678,7 +678,7 @@
 			 */
 			if (pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_UNKNOWN) {
 				if (count-- > 0) {
-					msleep_interruptible(100);
+					msleep(100);
 					goto try_again;
 				}
 				printk(MYIOC_s_INFO_FMT "Firmware discovery not"
--- rc4u/drivers/message/fusion/mptscsih.c	2006-05-18 16:34:08.117594001 -0500
+++ rc4/drivers/message/fusion/mptscsih.c	2006-05-18 16:36:24.098798183 -0500
@@ -1922,7 +1922,7 @@
 			break;
 		}
 		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
-		msleep_interruptible(250);
+		msleep(250);
 	} while (--loop_count);
 
 	return status;

--------------050406010801000507010102--
