From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/17] scsi_dh: return individual errors in scsi_dh_activate()
Date: Mon,  4 May 2015 14:42:07 +0200
Message-ID: <1430743343-47174-2-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbbEDMmj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:39 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When calling scsi_dh_activate() we should be returning
individual errors and not lumping all into one.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 155abeab..a4afd30 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -315,9 +315,10 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 
 	if (!sdev->handler)
 		goto out_fn;
+	err = SCSI_DH_NOTCONN;
 	if (sdev->sdev_state == SDEV_CANCEL ||
 	    sdev->sdev_state == SDEV_DEL)
-	    	goto out_fn;
+		goto out_fn;
 
 	err = SCSI_DH_DEV_OFFLINED;
 	if (sdev->sdev_state == SDEV_OFFLINE)
-- 
1.8.5.2

