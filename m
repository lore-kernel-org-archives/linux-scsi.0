From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [PATCH] sd: succeed check_event if device is not removable
Date: Thu, 18 Jan 2018 17:22:39 +0100
Message-ID: <1516292559-26649-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36641 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933388AbeARQWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jan 2018 11:22:43 -0500
Received: by mail-wr0-f193.google.com with SMTP id d9so23156258wre.3
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 08:22:42 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, gi-oh.kim@profitbricks.com, Jack Wang <jinpu.wang@profitbricks.com>

From: Jack Wang <jinpu.wang@profitbricks.com>

The check_events interface was added for check if device changes,
mainly for device is removable eg. CDROM

In sd_open, it checks if device is removable then check_disk_change.

when the device is not removable, we can simple succeeds the call
without send TUR.

Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/sd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab75ebd..773ce81 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1576,6 +1576,10 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	sdp = sdkp->device;
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_check_events\n"));
 
+	if (!sdp->removable) {
+		retval = 0;
+		goto out;
+	}
 	/*
 	 * If the device is offline, don't send any commands - just pretend as
 	 * if the command failed.  If the device ever comes back online, we
-- 
2.7.4
