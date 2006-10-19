From: Hannes Reinecke <hare@suse.de>
Subject: Re: Adaptec 29320 [aic79xx] fails on power cycle of LUN
Date: Thu, 19 Oct 2006 16:10:47 +0200
Message-ID: <45378767.4080106@suse.de>
References: <1161210246.3204.17.camel@home-desk>	 <1161210748.3204.22.camel@home-desk>  <1161237121.15090.9.camel@max> <1161260730.3204.36.camel@home-desk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010108020300010900000809"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52631 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S1423009AbWJSOKs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 10:10:48 -0400
In-Reply-To: <1161260730.3204.36.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010108020300010900000809
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Sean Bruno wrote:
> On Thu, 2006-10-19 at 01:52 -0400, Mike Christie wrote:
>> On Wed, 2006-10-18 at 15:32 -0700, Sean Bruno wrote:
>>> On Wed, 2006-10-18 at 15:24 -0700, Sean Bruno wrote:
>>>> I have had a tough time tracking this one down, however I can say for
>>>> certain that the 29320 is really having trouble if a LUN is power
>>>> cycled.
>>>>
>>>> I don't have access to a BUS analyzer right now, but here is my
>>>> regression.
>>>>
>>>> 1.  Hook an external SCSI array/disk to a 29320.
>>>> 2.  Power up SCSI array/disk
>>>> 3.  Power up PC with 29320.
>>>> 4.  When PC has booted, login and test device by creating a file
>>>>     system, eg. mkfs /dev/sda (or whatever disk the array is called on
>>>>     ur machine).
>>>> 5.  Power cycle array/disk
>>>> 6.  Retest device with another 'mkfs /dev/sda' ... panic/crash/lock-up
>>>> ensues.
>>>>
>>>>
>>>>
>>>> This did not happen in 2.6.15.7 but did appear in 2.6.16 and higher.
>>>>
> 
>> Does this only occur with sg or is that the only way you got a trace? In
>> the original bug report you mentioned it occurring with mkfs, but the
>> bug oops is from a sg request. Is tdg_2 run while the mkfs is running?
> 
> Snippets from 'dmesg' during step 6:
> 
> scsi0: Someone reset channel A
> sd 0:0:4:0: Attempting to queue an ABORT message:CDB: 0x28 0x0 0x0 0x0
> 0x0 0x80 0x0 0x0 0x80 0x0
> Infinite interrupt loop, INTSTAT = 8scsi0: At time of recovery, card was
> paused
Ah. Hmm. Infinite SCSI interrupt.

Maybe someone forgot to clear the status ...

Can you try the attached patch?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------010108020300010900000809
Content-Type: text/plain;
 name="aic79xx-reset-scsiint"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-reset-scsiint"

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 653818d..78fa71d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1519,8 +1519,10 @@ ahd_handle_scsiint(struct ahd_softc *ahd
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
@@ -7920,6 +7922,11 @@ #endif
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
@@ -7952,10 +7959,6 @@ #ifdef AHD_TARGET_MODE
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
@@ -7977,6 +7980,10 @@ #endif
 		}
 	}
 
+	/* Notify the XPT that a bus reset occurred */
+	ahd_send_async(ahd, devinfo.channel, CAM_TARGET_WILDCARD,
+		       CAM_LUN_WILDCARD, AC_BUS_RESET);
+
 	ahd_restart(ahd);
 
 	return (found);

--------------010108020300010900000809--
