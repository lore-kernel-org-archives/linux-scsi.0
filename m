From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic7xxx: add back locking
Date: Tue, 17 May 2005 16:09:52 -0500
Message-ID: <1116364192.4989.54.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54239 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261985AbVEQVJx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 17:09:53 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j4HL9qA12958
	for <linux-scsi@vger.kernel.org>; Tue, 17 May 2005 17:09:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Tampering with the settings has to be done under the host lock ...
slave_alloc isn't called under any lock, so this has to be done
explicitly.

James

--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -645,7 +645,9 @@ ahc_linux_slave_alloc(struct scsi_device
 	struct ahc_linux_target *targ;
 	struct scsi_target *starget = device->sdev_target;
 	struct ahc_linux_device *dev;
-	u_int target_offset;
+	unsigned int target_offset;
+	unsigned long flags;
+	int retval = -ENOMEM;
 
 	target_offset = starget->id;
 	if (starget->channel != 0)
@@ -654,12 +656,14 @@ ahc_linux_slave_alloc(struct scsi_device
 	ahc = *((struct ahc_softc **)device->host->hostdata);
 	if (bootverbose)
 		printf("%s: Slave Alloc %d\n", ahc_name(ahc), device->id);
+	ahc_lock(ahc, &flags);
 	targ = ahc->platform_data->targets[target_offset];
 	if (targ == NULL) {
 		targ = ahc_linux_alloc_target(ahc, starget->channel, starget->id);
 		struct seeprom_config *sc = ahc->seep_config;
 		if (targ == NULL)
-			return -ENOMEM;
+			goto out;
+
 		if (sc) {
 			unsigned short scsirate;
 			struct ahc_devinfo devinfo;
@@ -701,10 +705,13 @@ ahc_linux_slave_alloc(struct scsi_device
 	if (dev == NULL) {
 		dev = ahc_linux_alloc_device(ahc, targ, device->lun);
 		if (dev == NULL)
-			return -ENOMEM;
+			goto out;
 	}
+	retval = 0;
 
-	return 0;
+ out:
+	ahc_unlock(ahc, &flags);
+	return retval;
 }
 
 static int


