From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 12/28] rtsx: drop bus reset function
Date: Wed, 28 Jun 2017 10:25:00 +0200
Message-ID: <1498638316-44420-13-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53001 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751646AbdF1IbF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:05 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Function is a stub, so can as well be dropped.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/staging/rts5208/rtsx.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index b8177f5..e719b1e 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -205,16 +205,6 @@ static int device_reset(struct scsi_cmnd *srb)
 	return SUCCESS;
 }
 
-/* Simulate a SCSI bus reset by resetting the device's USB port. */
-static int bus_reset(struct scsi_cmnd *srb)
-{
-	struct rtsx_dev *dev = host_to_rtsx(srb->device->host);
-
-	dev_info(&dev->pci->dev, "%s called\n", __func__);
-
-	return SUCCESS;
-}
-
 /*
  * this defines our host template, with which we'll allocate hosts
  */
@@ -231,7 +221,6 @@ static int bus_reset(struct scsi_cmnd *srb)
 	/* error and abort handlers */
 	.eh_abort_handler =		command_abort,
 	.eh_device_reset_handler =	device_reset,
-	.eh_bus_reset_handler =		bus_reset,
 
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
-- 
1.8.5.6
