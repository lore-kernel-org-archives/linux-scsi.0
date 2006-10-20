From: Hannes Reinecke <hare@suse.de>
Subject: Re: Adaptec 29320 [aic79xx] fails on power cycle of LUN
Date: Fri, 20 Oct 2006 09:01:54 +0200
Message-ID: <45387462.10300@suse.de>
References: <1161210246.3204.17.camel@home-desk>	 <1161210748.3204.22.camel@home-desk>  <1161237121.15090.9.camel@max>	 <1161260730.3204.36.camel@home-desk>  <45378767.4080106@suse.de> <1161274711.3204.41.camel@home-desk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070904080100000702010400"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:6847 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S2992526AbWJTHCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 03:02:00 -0400
In-Reply-To: <1161274711.3204.41.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070904080100000702010400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Sean Bruno wrote:
> On Thu, 2006-10-19 at 16:10 +0200, Hannes Reinecke wrote:
>> Sean Bruno wrote:
>>> On Thu, 2006-10-19 at 01:52 -0400, Mike Christie wrote:
>>>> On Wed, 2006-10-18 at 15:32 -0700, Sean Bruno wrote:
>>>>> On Wed, 2006-10-18 at 15:24 -0700, Sean Bruno wrote:
>>>>>> I have had a tough time tracking this one down, however I can say for
>>>>>> certain that the 29320 is really having trouble if a LUN is power
>>>>>> cycled.
>>>>>>
>>>>>> I don't have access to a BUS analyzer right now, but here is my
>>>>>> regression.
>>>>>>
>>>>>> 1.  Hook an external SCSI array/disk to a 29320.
>>>>>> 2.  Power up SCSI array/disk
>>>>>> 3.  Power up PC with 29320.
>>>>>> 4.  When PC has booted, login and test device by creating a file
>>>>>>     system, eg. mkfs /dev/sda (or whatever disk the array is called on
>>>>>>     ur machine).
>>>>>> 5.  Power cycle array/disk
>>>>>> 6.  Retest device with another 'mkfs /dev/sda' ... panic/crash/lock-up
>>>>>> ensues.
>>>>>>
>>>>>>
>>>>>>
>>>>>> This did not happen in 2.6.15.7 but did appear in 2.6.16 and higher.
>>>>>>
>>>> Does this only occur with sg or is that the only way you got a trace? In
>>>> the original bug report you mentioned it occurring with mkfs, but the
>>>> bug oops is from a sg request. Is tdg_2 run while the mkfs is running?
>>> Snippets from 'dmesg' during step 6:
>>>
>>> scsi0: Someone reset channel A
>>> sd 0:0:4:0: Attempting to queue an ABORT message:CDB: 0x28 0x0 0x0 0x0
>>> 0x0 0x80 0x0 0x0 0x80 0x0
>>> Infinite interrupt loop, INTSTAT = 8scsi0: At time of recovery, card was
>>> paused
>> Ah. Hmm. Infinite SCSI interrupt.
>>
>> Maybe someone forgot to clear the status ...
>>
>> Can you try the attached patch?
>>
>> Cheers,
>>
>> Hannes
> 
> Better.  The patch allows me to cycle power on the array exactly once.
> So the new regression is:
> 
> 1.  Hook an external SCSI array/disk to a 29320.
> 2.  Power up SCSI array/disk
> 3.  Power up PC with 29320.
> 4.  When PC has booted, login and test device by creating a file
>     system, eg. mkfs /dev/sda (or whatever disk the array is called on
>     ur machine).
> 5.  Power cycle array/disk
> 6.  Retest device with another 'mkfs /dev/sda'  <-- works just fine!
> 7.  Power cycle array/disk
> 8.  No need to do anything, card dump in dmesg/messages appears and
> device in not useable:
> 
Ok. Not bad. So we have to switch to non-pkt commands after a reset.
Make sense. Care to try the updated patch?

Thanks for all the testing!

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------070904080100000702010400
Content-Type: text/plain;
 name="aic79xx-external-device-reset"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-external-device-reset"

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 653818d..555920a 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1053,10 +1053,12 @@ #endif
 			 * If a target takes us into the command phase
 			 * assume that it has been externally reset and
 			 * has thus lost our previous packetized negotiation
-			 * agreement.
-			 * Revert to async/narrow transfers until we
-			 * can renegotiate with the device and notify
-			 * the OSM about the reset.
+			 * agreement.  Since we have not sent an identify
+			 * message and may not have fully qualified the
+			 * connection, we change our command to TUR, assert
+			 * ATN and ABORT the task when we go to message in
+			 * phase.  The OSM will see the REQUEUE_REQUEST
+			 * status and retry the command.
 			 */
 			scbid = ahd_get_scbptr(ahd);
 			scb = ahd_lookup_scb(ahd, scbid);
@@ -1083,7 +1085,28 @@ #endif
 			ahd_set_syncrate(ahd, &devinfo, /*period*/0,
 					 /*offset*/0, /*ppr_options*/0,
 					 AHD_TRANS_ACTIVE, /*paused*/TRUE);
-			scb->flags |= SCB_EXTERNAL_RESET;
+			/* Hand-craft TUR command */
+			ahd_outb(ahd, SCB_CDB_STORE, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+1, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+2, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+3, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+4, 0);
+			ahd_outb(ahd, SCB_CDB_STORE+5, 0);
+			ahd_outb(ahd, SCB_CDB_LEN, 6);
+			scb->hscb->control &= ~(TAG_ENB|SCB_TAG_TYPE);
+			scb->hscb->control |= MK_MESSAGE;
+			ahd_outb(ahd, SCB_CONTROL, scb->hscb->control);
+			ahd_outb(ahd, MSG_OUT, HOST_MSG);
+			ahd_outb(ahd, SAVED_SCSIID, scb->hscb->scsiid);
+			/*
+			 * The lun is 0, regardless of the SCB's lun
+			 * as we have not sent an identify message.
+			 */
+			ahd_outb(ahd, SAVED_LUN, 0);
+			ahd_outb(ahd, SEQ_FLAGS, 0);
+			ahd_assert_atn(ahd);
+			scb->flags &= ~SCB_PACKETIZED;
+			scb->flags |= SCB_ABORT|SCB_EXTERNAL_RESET;
 			ahd_freeze_devq(ahd, scb);
 			ahd_set_transaction_status(scb, CAM_REQUEUE_REQ);
 			ahd_freeze_scb(scb);
@@ -1519,8 +1542,10 @@ ahd_handle_scsiint(struct ahd_softc *ahd
 	/*
 	 * Ignore external resets after a bus reset.
 	 */
-	if (((status & SCSIRSTI) != 0) && (ahd->flags & AHD_BUS_RESET_ACTIVE))
+	if (((status & SCSIRSTI) != 0) && (ahd->flags & AHD_BUS_RESET_ACTIVE)) {
+		ahd_outb(ahd, CLRSINT1, CLRSCSIRSTI);
 		return;
+	}
 
 	/*
 	 * Clear bus reset flag
@@ -2200,6 +2225,22 @@ ahd_handle_nonpkt_busfree(struct ahd_sof
 			if (sent_msg == MSG_ABORT_TAG)
 				tag = SCB_GET_TAG(scb);
 
+			if ((scb->flags & SCB_EXTERNAL_RESET) != 0) {
+				/*
+				 * This abort is in response to an
+				 * unexpected switch to command phase
+				 * for a packetized connection.  Since
+				 * the identify message was never sent,
+				 * "saved lun" is 0.  We really want to
+				 * abort only the SCB that encountered
+				 * this error, which could have a different
+				 * lun.  The SCB will be retried so the OS
+				 * will see the UA after renegotiating to
+				 * packetized.
+				 */
+				tag = SCB_GET_TAG(scb);
+				saved_lun = scb->hscb->lun;
+			}
 			found = ahd_abort_scbs(ahd, target, 'A', saved_lun,
 					       tag, ROLE_INITIATOR,
 					       CAM_REQ_ABORTED);
@@ -7920,6 +7961,11 @@ #endif
 	ahd_clear_fifo(ahd, 1);
 
 	/*
+	 * Clear SCSI interrupt status
+	 */
+	ahd_outb(ahd, CLRSINT1, CLRSCSIRSTI);
+
+	/*
 	 * Reenable selections
 	 */
 	ahd_outb(ahd, SIMODE1, ahd_inb(ahd, SIMODE1) | ENSCSIRST);
@@ -7952,10 +7998,6 @@ #ifdef AHD_TARGET_MODE
 		}
 	}
 #endif
-	/* Notify the XPT that a bus reset occurred */
-	ahd_send_async(ahd, devinfo.channel, CAM_TARGET_WILDCARD,
-		       CAM_LUN_WILDCARD, AC_BUS_RESET);
-
 	/*
 	 * Revert to async/narrow transfers until we renegotiate.
 	 */
@@ -7977,6 +8019,10 @@ #endif
 		}
 	}
 
+	/* Notify the XPT that a bus reset occurred */
+	ahd_send_async(ahd, devinfo.channel, CAM_TARGET_WILDCARD,
+		       CAM_LUN_WILDCARD, AC_BUS_RESET);
+
 	ahd_restart(ahd);
 
 	return (found);

--------------070904080100000702010400--
