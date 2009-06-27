From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH]: create sysfs file, dh_state for SCSI devices even if they
	are not in the inteernal lists
Date: Fri, 26 Jun 2009 19:31:28 -0700
Message-ID: <1246069888.14164.53.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:34021 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbZF0C3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2009 22:29:07 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5R2PGvj006647
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 20:25:16 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5R2TAd6214108
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 20:29:10 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5R2T9wR007076
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 20:29:10 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: dm-devel <dm-devel@redhat.com>, Mario Mech <mech@meteo.uni-koeln.de>

Create the sysfs file, dh_state even if the new SCSI device is not
in the any of the device handler's internal lists.

Signed-Off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.31-rc1.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.31-rc1/drivers/scsi/device_handler/scsi_dh.c
@@ -304,18 +304,15 @@ static int scsi_dh_notifier(struct notif
 	sdev = to_scsi_device(dev);
 
 	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		err = device_create_file(dev, &scsi_dh_state_attr);
+		/* don't care about err */
 		devinfo = device_handler_match(NULL, sdev);
-		if (!devinfo)
-			goto out;
-
-		err = scsi_dh_handler_attach(sdev, devinfo);
-		if (!err)
-			err = device_create_file(dev, &scsi_dh_state_attr);
+		if (devinfo)
+			err = scsi_dh_handler_attach(sdev, devinfo);
 	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
 		device_remove_file(dev, &scsi_dh_state_attr);
 		scsi_dh_handler_detach(sdev, NULL);
 	}
-out:
 	return err;
 }
 


