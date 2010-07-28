From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 2/6] scsi_dh : increment the refcounts while calling activate
Date: Wed, 28 Jul 2010 16:59:06 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D05DC422@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42546 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755790Ab0G1W70 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 18:59:26 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Hold the refcounts for device and scsi_dh_data while calling handler's activate. This will make sure that devices and scsi_dh_data are not removed while activate is still in progress. Make sure to call put_device and kref_put in the handler after activate is complete.

Signed-off-by: Babu Moger <babu.moger@lsi.com>
---
--- linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh.c.orig	2010-07-23 05:40:11.000000000 -0500
+++ linux-2.6.35-rc5/drivers/scsi/device_handler/scsi_dh.c	2010-07-23 05:48:53.000000000 -0500
@@ -228,7 +228,8 @@ store_dh_state(struct device *dev, struc
 			 * Activate a device handler
 			 */
 			if (scsi_dh->activate)
-				err = scsi_dh->activate(sdev, NULL, NULL);
+				err = scsi_dh_activate(sdev->request_queue,
+							NULL, NULL);
 			else
 				err = 0;
 		}
@@ -431,6 +432,8 @@ EXPORT_SYMBOL_GPL(scsi_unregister_device
  *         do not hold the lock in the caller which may be needed in fn.
  * @data - data passed to the function fn upon completion.
  *
+ * NOTE  - Remember to call put_device and kref_put in the handler after
+ *         calling the callback function. Otherwise things could become messy.
  */
 int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 {
@@ -450,9 +453,12 @@ int scsi_dh_activate(struct request_queu
 	if (err)
 		return err;
 
-	if (scsi_dh->activate)
+	if (scsi_dh->activate) {
+		kref_get(&sdev->scsi_dh_data->kref);
 		err = scsi_dh->activate(sdev, fn, data);
-	put_device(&sdev->sdev_gendev);
+	} else
+		put_device(&sdev->sdev_gendev);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(scsi_dh_activate);



