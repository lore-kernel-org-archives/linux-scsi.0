From: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] media change events - do not emit change event at device
	add
Date: Wed, 19 Mar 2008 13:09:56 +0100
Message-ID: <1205928596.8810.22.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:63892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936393AbYCSVKN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 17:10:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: scsi <linux-scsi@vger.kernel.org>

Hi James,
we like to see this in 2.6.25. There is no need to send out "change"
events immediately after we added a new device. Presetting the state flag
prevents this.

Thanks,
Kay 


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: [SCSI] media change events - do not emit change event at device add

Initialize the "state changed" flag, so we do not send a change event
immediately after registering a new device.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7aee64d..5fe7aae 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1654,6 +1654,7 @@ static int sd_probe(struct device *dev)
 	sdkp->disk = gd;
 	sdkp->index = index;
 	sdkp->openers = 0;
+	sdkp->previous_state = 1;
 
 	if (!sdp->timeout) {
 		if (sdp->type != TYPE_MOD)
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 208565b..7ee86d4 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -623,6 +623,7 @@ static int sr_probe(struct device *dev)
 	cd->disk = disk;
 	cd->capacity = 0x1fffff;
 	cd->device->changed = 1;	/* force recheck CD type */
+	cd->previous_state = 1;
 	cd->use = 1;
 	cd->readcd_known = 0;
 	cd->readcd_cdda = 0;


