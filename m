From: Oliver Neukum <oliver@neukum.org>
Subject: [PATCH] scsi: NULL followed if kmalloc fails and senses needed
Date: Mon,  6 Aug 2012 15:09:58 +0200
Message-ID: <1344258598-28019-1-git-send-email-oliver@neukum.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:52578 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab2HFNLQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Aug 2012 09:11:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Oliver Neukum <oliver@neukum.org>, Oliver Neukum <oneukum@suse.de>, stable@kernel.org

In scsi_test_unit_ready() a local sense may fail to allocate. In
this case the buffer must not be used even if an IO error happens.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
CC: stable@kernel.org
---
 drivers/scsi/scsi_lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..bab19f2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2043,10 +2043,10 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 	do {
 		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
 					  timeout, retries, NULL);
-		if (sdev->removable && scsi_sense_valid(sshdr) &&
+		if (sdev->removable && sshdr && scsi_sense_valid(sshdr) &&
 		    sshdr->sense_key == UNIT_ATTENTION)
 			sdev->changed = 1;
-	} while (scsi_sense_valid(sshdr) &&
+	} while (sshdr && scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
 	if (!sshdr_external)
-- 
1.7.7

