From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3/3] usb-storage: reorganize target-specific code
Date: Tue, 10 Jan 2012 13:43:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1201101339130.1594-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55195 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756457Ab2AJSnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 13:43:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Perry Wagle <wagle@mac.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Now that usb-storage has a target_alloc() routine, this patch (as1508)
moves some existing target-specific code out of the slave_alloc()
routine to where it really belongs.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>

---

 drivers/usb/storage/scsiglue.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

Index: usb-3.2/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-3.2.orig/drivers/usb/storage/scsiglue.c
+++ usb-3.2/drivers/usb/storage/scsiglue.c
@@ -78,8 +78,6 @@ static const char* host_info(struct Scsi
 
 static int slave_alloc (struct scsi_device *sdev)
 {
-	struct us_data *us = host_to_us(sdev->host);
-
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
 	 * the extra data and many devices choke if asked for more or
@@ -104,18 +102,6 @@ static int slave_alloc (struct scsi_devi
 	 */
 	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 
-	/*
-	 * The UFI spec treates the Peripheral Qualifier bits in an
-	 * INQUIRY result as reserved and requires devices to set them
-	 * to 0.  However the SCSI spec requires these bits to be set
-	 * to 3 to indicate when a LUN is not present.
-	 *
-	 * Let the scanning code know if this target merely sets
-	 * Peripheral Device Type to 0x1f to indicate no LUN.
-	 */
-	if (us->subclass == USB_SC_UFI)
-		sdev->sdev_target->pdt_1f_for_no_lun = 1;
-
 	return 0;
 }
 
@@ -278,6 +264,8 @@ static int slave_configure(struct scsi_d
 
 static int target_alloc(struct scsi_target *starget)
 {
+	struct us_data *us = host_to_us(dev_to_shost(starget->dev.parent));
+
 	/*
 	 * Some USB drives don't support REPORT LUNS, even though they
 	 * report a SCSI revision level above 2.  Tell the SCSI layer
@@ -285,6 +273,19 @@ static int target_alloc(struct scsi_targ
 	 * scan instead.
 	 */
 	starget->no_report_luns = 1;
+
+	/*
+	 * The UFI spec treats the Peripheral Qualifier bits in an
+	 * INQUIRY result as reserved and requires devices to set them
+	 * to 0.  However the SCSI spec requires these bits to be set
+	 * to 3 to indicate when a LUN is not present.
+	 *
+	 * Let the scanning code know if this target merely sets
+	 * Peripheral Device Type to 0x1f to indicate no LUN.
+	 */
+	if (us->subclass == USB_SC_UFI)
+		starget->pdt_1f_for_no_lun = 1;
+
 	return 0;
 }
 

