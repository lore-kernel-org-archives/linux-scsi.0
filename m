From: Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] scsi: storvsc: avoid usage of WRITE_SAME
Date: Wed, 30 Jan 2013 15:44:54 +0100
Message-ID: <1359557094-13625-1-git-send-email-olaf@aepfle.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:49846 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3A3OpU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2013 09:45:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Olaf Hering <olaf@aepfle.de>, KY Srinivasan <kys@microsoft.com>

Set scsi_device->no_write_same because the host does not support it.
Also blacklist WRITE_SAME to avoid (and log) accident usage.

If the guest uses the ext4 filesystem, storvsc hangs while it prints
these messages in an endless loop:
...
[  161.459523] hv_storvsc vmbus_0_1: cmd 0x41 scsi status 0x2 srb status 0x6
[  161.462157] sd 2:0:0:0: [sda]
[  161.463135] Sense Key : No Sense [current]
[  161.464983] sd 2:0:0:0: [sda]
[  161.465899] Add. Sense: No additional sense information
[  161.468211] hv_storvsc vmbus_0_1: cmd 0x41 scsi status 0x2 srb status 0x6
[  161.475766] sd 2:0:0:0: [sda]
[  161.476728] Sense Key : No Sense [current]
[  161.478284] sd 2:0:0:0: [sda]
[  161.479441] Add. Sense: No additional sense information
...

This happens with a guest running on Windows Server 2012, but happens to
work while running on Windows Server 2008. WRITE_SAME isnt really
supported by both versions, so disable the command usage globally.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: KY Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 0144078..314586c 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1155,6 +1155,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
 
+	sdevice->no_write_same = 1;
+
 	return 0;
 }
 
@@ -1237,6 +1239,8 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 	u8 scsi_op = scmnd->cmnd[0];
 
 	switch (scsi_op) {
+	/* the host does not handle WRITE_SAME, log accident usage */
+	case WRITE_SAME:
 	/*
 	 * smartd sends this command and the host does not handle
 	 * this. So, don't send it.
-- 
1.8.1.1

