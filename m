From: Daniel Mack <zonque@gmail.com>
Subject: [PATCH RESEND] SCSI: sd: don't fail if the device doesn't recognize SYNCHRONIZE CACHE
Date: Mon,  3 Mar 2014 22:25:57 +0100
Message-ID: <1393881957-12320-1-git-send-email-zonque@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:62084 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaCCV0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 16:26:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

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
Hi,

this patch has been around for awhile, but hasn't gained much
attraction, and hasn't been merged anywhere yet. Which is sad,
as it fixes a bug on real hardware when going to suspend :)

Could anyone from the SCSI people have a quick look maybe?

Thanks,
Daniel

 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 470954a..36d1a23 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1463,8 +1463,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 			sd_print_sense_hdr(sdkp, &sshdr);
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(&sshdr) &&
-			/* 0x3a is medium not present */
-			sshdr.asc == 0x3a)
+			(sshdr.asc == 0x3a ||	/* medium not present */
+			 sshdr.asc == 0x20))	/* invalid command */
 				/* this is no error here */
 				return 0;
 
-- 
1.8.5.3

