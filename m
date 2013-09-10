From: Oliver Neukum <oneukum@suse.de>
Subject: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Tue, 10 Sep 2013 15:56:48 +0200
Message-ID: <1378821408.13541.26.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42796 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab3IJN4u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Sep 2013 09:56:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org

Hi Hannes,

you objected to this patch saying there's a possibilty that
HS devices may also need this feature, which would require
a quirk. Does this mean that the patch is acceptable only
with an additional predefined quirk, or do you insist that all
devices be handled with quirks?

	Regards
		Oliver

+++ b/drivers/usb/storage/scsiglue.c
@@ -211,8 +211,11 @@ static int slave_configure(struct
scsi_device0*sdev)
 		/*
 		 * Many devices do not respond properly to READ_CAPACITY_16.
 		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
+		 * However some USB 3.0 drive enclosures return capacity
+		 * modulo 2TB
 		 */
-		sdev->try_rc_10_first = 1;
+		if (us->pusb_dev->speed < USB_SPEED_SUPER)
+			sdev->try_rc_10_first = 1;
 
 		/* assume SPC3 or latter devices support sense size > 18 */
 		if (sdev->scsi_level > SCSI_SPC_2)

