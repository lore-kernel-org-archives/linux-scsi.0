From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] usb: storage: fix runtime pm issue in usb_stor_probe2
Date: Wed, 3 Aug 2016 21:46:47 +0200
Message-ID: <0c83d917-678d-d4fc-3225-f2e8355f6280@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33249 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbcHCTuh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2016 15:50:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

Since commit 71723f95463d "PM / runtime: print error when activating a
child to unactive parent" I see the following error message:

scsi host2: usb-storage 1-3:1.0
scsi host2: runtime PM trying to activate child device host2 but parent
	    (1-3:1.0) is not active

Digging into it it seems to be related to the problem described in the
commit message for cd998ded5c12 "i2c: designware: Prevent runtime
suspend during adapter registration" as scsi_add_host also calls
device_add and after the call to device_add the parent device is
suspended.

Fix this by using the approach from the mentioned commit and getting
the runtime pm reference before calling scsi_add_host.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/usb/storage/usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index ef2d8cd..8c5f011 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -1070,17 +1070,17 @@ int usb_stor_probe2(struct us_data *us)
 	result = usb_stor_acquire_resources(us);
 	if (result)
 		goto BadDevice;
+	usb_autopm_get_interface_no_resume(us->pusb_intf);
 	snprintf(us->scsi_name, sizeof(us->scsi_name), "usb-storage %s",
 					dev_name(&us->pusb_intf->dev));
 	result = scsi_add_host(us_to_host(us), dev);
 	if (result) {
 		dev_warn(dev,
 				"Unable to add the scsi host\n");
-		goto BadDevice;
+		goto HostAddErr;
 	}
 
 	/* Submit the delayed_work for SCSI-device scanning */
-	usb_autopm_get_interface_no_resume(us->pusb_intf);
 	set_bit(US_FLIDX_SCAN_PENDING, &us->dflags);
 
 	if (delay_use > 0)
@@ -1090,6 +1090,8 @@ int usb_stor_probe2(struct us_data *us)
 	return 0;
 
 	/* We come here if there are any problems */
+HostAddErr:
+	usb_autopm_put_interface_no_suspend(us->pusb_intf);
 BadDevice:
 	usb_stor_dbg(us, "storage_probe() failed\n");
 	release_everything(us);
-- 
2.9.2

