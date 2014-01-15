From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: sd: don't fail if the device doesn't recognize
 SYNCHRONIZE CACHE
Date: Wed, 15 Jan 2014 15:37:04 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401151533360.1587-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56647 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751447AbaAOUhF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 15:37:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sven Neumann <s.neumann@raumfeld.com>, Daniel Mack <zonque@gmail.com>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>

Evidently some wacky USB-ATA bridges don't recognize the SYNCHRONIZE
CACHE command, as shown in this email thread:

	http://marc.info/?t=138978356200002&r=1&w=2

The fact that we can't tell them to drain their caches shouldn't
prevent the system from going into suspend.  Therefore sd_sync_cache()
shouldn't return an error if the device replies with an Invalid
Command ASC.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Sven Neumann <s.neumann@raumfeld.com>
Tested-by: Daniel Mack <zonque@gmail.com>
CC: Oliver Neukum <oliver@neukum.org>
CC: <stable@vger.kernel.org>

---


[as1734]


 drivers/scsi/sd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: usb-3.13/drivers/scsi/sd.c
===================================================================
--- usb-3.13.orig/drivers/scsi/sd.c
+++ usb-3.13/drivers/scsi/sd.c
@@ -1463,8 +1463,8 @@ static int sd_sync_cache(struct scsi_dis
 			sd_print_sense_hdr(sdkp, &sshdr);
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(&sshdr) &&
-			/* 0x3a is medium not present */
-			sshdr.asc == 0x3a)
+			(sshdr.asc == 0x3a ||	/* medium not present */
+			 sshdr.asc == 0x20))	/* invalid command */
 				/* this is no error here */
 				return 0;
 

