From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/28] uas: move eh_bus_reset_handler to eh_device_reset_handler
Date: Wed, 28 Jun 2017 10:24:54 +0200
Message-ID: <1498638316-44420-7-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52977 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751652AbdF1IbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:05 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus_reset handler is really a device reset, so move it
to eh_device_reset_handler().

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/usb/storage/uas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 5ef014b..cfb1e3b 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -737,7 +737,7 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 	return FAILED;
 }
 
-static int uas_eh_bus_reset_handler(struct scsi_cmnd *cmnd)
+static int uas_eh_device_reset_handler(struct scsi_cmnd *cmnd)
 {
 	struct scsi_device *sdev = cmnd->device;
 	struct uas_dev_info *devinfo = sdev->hostdata;
@@ -848,7 +848,7 @@ static int uas_slave_configure(struct scsi_device *sdev)
 	.slave_alloc = uas_slave_alloc,
 	.slave_configure = uas_slave_configure,
 	.eh_abort_handler = uas_eh_abort_handler,
-	.eh_bus_reset_handler = uas_eh_bus_reset_handler,
+	.eh_device_reset_handler = uas_eh_device_reset_handler,
 	.this_id = -1,
 	.sg_tablesize = SG_NONE,
 	.skip_settle_delay = 1,
-- 
1.8.5.6
