From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/35] uas: move eh_bus_reset_handler to eh_device_reset_handler
Date: Fri, 23 Jun 2017 15:02:27 +0200
Message-ID: <1498222975-71858-8-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32834 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751620AbdFWNDZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:25 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus_reset handler is really a device reset, so move it
to eh_device_reset_handler().

Signed-off-by: Hannes Reinecke <hare@suse.com>
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
