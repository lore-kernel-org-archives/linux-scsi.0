From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi host / scsi device ref counting take 2 [2/3]
Date: Fri, 1 Aug 2003 13:25:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030801202541.GF3868@beaverton.ibm.com>
References: <20030801202431.GE3868@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:6550 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S272505AbTHAUVu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2003 16:21:50 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e35.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h71KLnc8108778
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 16:21:49 -0400
Received: from dyn9-47-17-195 (DYN318028BLD.beaverton.ibm.com [9.47.17.91] (may be forged))
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h71KLnAp047074
	for <linux-scsi@vger.kernel.org>; Fri, 1 Aug 2003 14:21:49 -0600
Content-Disposition: inline
In-Reply-To: <20030801202431.GE3868@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
Align usb storage shutdown with changes in the shost shutdown.
EDESC


 drivers/usb/storage/usb.c |   14 +-------------
 1 files changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/usb/storage/usb.c~usb_stor_fixups drivers/usb/storage/usb.c
--- patched-scsi-misc-2.5/drivers/usb/storage/usb.c~usb_stor_fixups	Fri Aug  1 07:07:17 2003
+++ patched-scsi-misc-2.5-andmike/drivers/usb/storage/usb.c	Fri Aug  1 07:07:17 2003
@@ -978,16 +978,9 @@ BadDevice:
 static void storage_disconnect(struct usb_interface *intf)
 {
 	struct us_data *us = usb_get_intfdata(intf);
-	struct scsi_device *sdev;
 
 	US_DEBUGP("storage_disconnect() called\n");
 
-	/* Set devices offline -- need host lock for this */
-	scsi_lock(us->host);
-	list_for_each_entry(sdev, &us->host->my_devices, siblings)
-		sdev->online = 0;
-	scsi_unlock(us->host);
-
 	/* Prevent new USB transfers and stop the current command */
 	set_bit(US_FLIDX_DISCONNECTING, &us->flags);
 	usb_stor_stop_transport(us);
@@ -995,12 +988,7 @@ static void storage_disconnect(struct us
 	/* Dissociate from the USB device */
 	dissociate_dev(us);
 
-	/* Begin the SCSI host removal sequence */
-	if (scsi_remove_host(us->host)) {
-		US_DEBUGP("-- SCSI refused to remove the host\n");
-		BUG();
-		return;
-	}
+	scsi_remove_host(us->host);
 
 	/* TODO: somehow, wait for the device to
 	 * be 'idle' (tasklet completion) */

_
