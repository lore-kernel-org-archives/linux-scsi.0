From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: fixup return code in scsi_vpd_inquiry()
Date: Fri, 21 Mar 2014 09:01:06 +0100
Message-ID: <1395388866-105774-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbaCUIBJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2014 04:01:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

scsi_execute_req() will return a SCSI error code on failure,
which needs to be converted in the standard error codes.

Reported-by: Fengguang We <fengguang.wu@intel.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e5d5f59..4acb287 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -952,7 +952,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
 				  len, NULL, 30 * HZ, 3, NULL);
 	if (result)
-		return result;
+		return -EIO;
 
 	/* Sanity check that we got the page back that we asked for */
 	if (buffer[1] != page)
-- 
1.7.12.4

