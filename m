From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: get disk reference in sd_check_events()
Date: Tue, 26 Apr 2016 08:06:58 +0200
Message-ID: <1461650818-107190-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbcDZGHB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Apr 2016 02:07:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

sd_check_events() is called asynchronously, and might race
with device removal. So always take a disk reference when
processing the event to avoid the device being removed while
the event is processed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f52b74c..91f609f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1398,11 +1398,15 @@ static int media_not_present(struct scsi_disk *sdkp,
  **/
 static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 {
-	struct scsi_disk *sdkp = scsi_disk(disk);
-	struct scsi_device *sdp = sdkp->device;
+	struct scsi_disk *sdkp = scsi_disk_get(disk);
+	struct scsi_device *sdp;
 	struct scsi_sense_hdr *sshdr = NULL;
 	int retval;
 
+	if (!sdkp)
+		return 0;
+
+	sdp = sdkp->device;
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_check_events\n"));
 
 	/*
@@ -1459,6 +1463,7 @@ out:
 	kfree(sshdr);
 	retval = sdp->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 	sdp->changed = 0;
+	scsi_disk_put(sdkp);
 	return retval;
 }
 
-- 
1.8.5.6

