From: Michael Reed <mdr@sgi.com>
Subject: [REPOST][PATCH 5/6] mpt fusion - abort of board reset leaves port
 dead requiring reboot
Date: Thu, 18 May 2006 17:14:53 -0500
Message-ID: <446CF1DD.1000605@sgi.com>
References: <446CD260.7040703@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010800000704070000080408"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:37578 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1750764AbWERWOy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 18:14:54 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k4J0Wgud023066
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 17:32:42 -0700
In-Reply-To: <446CD260.7040703@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010800000704070000080408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch has been respun to take into account James Bottomley's
version of the fix to the fusion reset handlers.  This patch
replaces the previous patch.

http://marc.theaimsgroup.com/?l=linux-scsi&m=114790729315904&w=2

Aside from line number differences, there is no content difference.

Only patches two and five in the sequence required change.

Signed-off-by: Michael Reed <mdr@sgi.com>


Michael Reed wrote:
> The driver uses msleep_interruptible() in the code path responsible
> for resetting the card's ports via the lsiutil command.  If a
> <ctrl-c> is received during the reset it can leave a port in such
> a state that the only way to regain its use is to reboot the system.
> Changing from msleep_interruptible() to msleep() corrects the problem.
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> 
> 
> 
> ------------------------------------------------------------------------
> 
> The driver uses msleep_interruptible() in the code path responsible
> for resetting the card's ports via the lsiutil command.  If a
> <ctrl-c> is received during the reset it can leave a port in such
> a state that the only way to regain its use is to reboot the system.
> Changing from msleep_interruptible() to msleep() corrects the problem.
> 
> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> 
> --- rc3c/drivers/message/fusion/mptbase.c	2006-05-08 14:55:27.276697653 -0500
> +++ rc3/drivers/message/fusion/mptbase.c	2006-05-08 14:58:55.364106345 -0500
> @@ -2264,7 +2264,7 @@
>  		}
>  
>  		if (sleepFlag == CAN_SLEEP) {
> -			msleep_interruptible(1);
> +			msleep(1);
>  		} else {
>  			mdelay (1);	/* 1 msec delay */
>  		}
> @@ -2652,7 +2652,7 @@
>  	state = mpt_GetIocState(ioc, 1);
>  	while (state != MPI_IOC_STATE_OPERATIONAL && --cntdn) {
>  		if (sleepFlag == CAN_SLEEP) {
> -			msleep_interruptible(1);
> +			msleep(1);
>  		} else {
>  			mdelay(1);
>  		}
> @@ -2904,7 +2904,7 @@
>  
>  	/* wait 1 msec */
>  	if (sleepFlag == CAN_SLEEP) {
> -		msleep_interruptible(1);
> +		msleep(1);
>  	} else {
>  		mdelay (1);
>  	}
> @@ -2921,7 +2921,7 @@
>  		}
>  		/* wait .1 sec */
>  		if (sleepFlag == CAN_SLEEP) {
> -			msleep_interruptible (100);
> +			msleep (100);
>  		} else {
>  			mdelay (100);
>  		}
> @@ -3011,7 +3011,7 @@
>  
>  		/* wait 1 msec */
>  		if (sleepFlag == CAN_SLEEP) {
> -			msleep_interruptible (1);
> +			msleep (1);
>  		} else {
>  			mdelay (1);
>  		}
> @@ -3059,7 +3059,7 @@
>  			return 0;
>  		}
>  		if (sleepFlag == CAN_SLEEP) {
> -			msleep_interruptible (10);
> +			msleep (10);
>  		} else {
>  			mdelay (10);
>  		}
> @@ -3110,7 +3110,7 @@
>  		SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, sleepFlag);
>  
>  		if (sleepFlag == CAN_SLEEP) {
> -			msleep_interruptible (1000);
> +			msleep (1000);
>  		} else {
>  			mdelay (1000);
>  		}
> @@ -3132,7 +3132,7 @@
>  			return hard_reset_done;
>  		}
>  		if (sleepFlag == CAN_SLEEP) {
> -			msleep_interruptible (10);
> +			msleep (10);
>  		} else {
>  			mdelay (10);
>  		}
> @@ -3203,7 +3203,7 @@
>  
>  			/* wait 100 msec */
>  			if (sleepFlag == CAN_SLEEP) {
> -				msleep_interruptible (100);
> +				msleep (100);
>  			} else {
>  				mdelay (100);
>  			}
> @@ -3282,7 +3282,7 @@
>  
>  				/* wait 1 sec */
>  				if (sleepFlag == CAN_SLEEP) {
> -					msleep_interruptible (1000);
> +					msleep (1000);
>  				} else {
>  					mdelay (1000);
>  				}
> @@ -3310,7 +3310,7 @@
>  
>  				/* wait 1 sec */
>  				if (sleepFlag == CAN_SLEEP) {
> -					msleep_interruptible (1000);
> +					msleep (1000);
>  				} else {
>  					mdelay (1000);
>  				}
> @@ -3344,7 +3344,7 @@
>  
>  		/* wait 100 msec */
>  		if (sleepFlag == CAN_SLEEP) {
> -			msleep_interruptible (100);
> +			msleep (100);
>  		} else {
>  			mdelay (100);
>  		}
> @@ -3438,7 +3438,7 @@
>  		}
>  
>  		if (sleepFlag == CAN_SLEEP) {
> -			msleep_interruptible(1);
> +			msleep(1);
>  		} else {
>  			mdelay (1);	/* 1 msec delay */
>  		}
> @@ -3878,7 +3878,7 @@
>  			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
>  			if (! (intstat & MPI_HIS_IOP_DOORBELL_STATUS))
>  				break;
> -			msleep_interruptible (1);
> +			msleep (1);
>  			count++;
>  		}
>  	} else {
> @@ -3927,7 +3927,7 @@
>  			intstat = CHIPREG_READ32(&ioc->chip->IntStatus);
>  			if (intstat & MPI_HIS_DOORBELL_INTERRUPT)
>  				break;
> -			msleep_interruptible(1);
> +			msleep(1);
>  			count++;
>  		}
>  	} else {
> --- rc3c/drivers/message/fusion/mptfc.c	2006-05-08 14:55:38.828222127 -0500
> +++ rc3/drivers/message/fusion/mptfc.c	2006-05-08 14:58:58.911964756 -0500
> @@ -678,7 +678,7 @@
>  			 */
>  			if (pp0dest->PortState == MPI_FCPORTPAGE0_PORTSTATE_UNKNOWN) {
>  				if (count-- > 0) {
> -					msleep_interruptible(100);
> +					msleep(100);
>  					goto try_again;
>  				}
>  				printk(MYIOC_s_INFO_FMT "Firmware discovery not"
> --- rc3c/drivers/message/fusion/mptscsih.c	2006-05-08 14:55:06.453554069 -0500
> +++ rc3/drivers/message/fusion/mptscsih.c	2006-05-08 14:59:04.163755105 -0500
> @@ -1922,7 +1922,7 @@
>  			break;
>  		}
>  		spin_unlock_irqrestore(&hd->ioc->FreeQlock, flags);
> -		msleep_interruptible(250);
> +		msleep(250);
>  	} while (--loop_count);
>  
>  	return status;

--------------010800000704070000080408
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

--------------010800000704070000080408--
