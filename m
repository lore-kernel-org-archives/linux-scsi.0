From: "conway, heather" <conway_heather@emc.com>
Subject: [PATCH] LUN reporting back 'Not Ready -Manual intervention requir
	ed'
Date: Wed, 31 Jul 2002 12:19:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <FA2F59D0E55B4B4892EA076FF8704F5501C1A112@srgraham.eng.emc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: "goggin, edward" <egoggin@emc.com>, "mcafee, thomas" <mcafee_thomas@emc.com>, "seto, jimmy" <seto_jimmy@emc.com>, "moumni, ismail" <moumni_ismail@emc.com>, "'gary_lerhaupt@dell.com'" <gary_lerhaupt@dell.com>, "'matt_domsch@dell.com'" <matt_domsch@dell.com>

I would like to request that the enclosed patch be considered for inclusion
into the core kernel.  Currently, there is a 100 second delay required when
a TUR returns 'Logical Unit Not Ready - Manual Intervention Required' status
on a passive SCSI device.  This is the case on EMC CLARiiON arrays.  
Are there objections with the patch below as it skips the spin-up time?
Thanks for your consideration.
Heather

--- linux-2.4/drivers/scsi/sd.c.orig	Wed Jul 24 17:33:02 2002
+++ linux-2.4/drivers/scsi/sd.c	Wed Jul 24 17:38:20 2002
@@ -842,10 +842,13 @@ static int sd_init_onedisk(int i)
 			break;
 		}
 
-		/* Look for non-removable devices that return NOT_READY.
+		/* Look for non-removable devices that return NOT_READY,
+		 * and don't require manual intervention.
 		 * Issue command to spin up drive for these cases. */
 		if (the_result && !rscsi_disks[i].device->removable &&
-		    SRpnt->sr_sense_buffer[2] == NOT_READY) {
+		    SRpnt->sr_sense_buffer[2] == NOT_READY &&
+		    ! ( SRpnt->sr_sense_buffer[12] == 0x04 &&   /* ASC */
+			SRpnt->sr_sense_buffer[13] == 0x03 )) { /* ASCQ */
 			unsigned long time1;
 			if (!spintime) {
 				printk("%s: Spinning up disk...", nbuff);
