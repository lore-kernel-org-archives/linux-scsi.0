From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_dh_rdac: always retry MODE SELECT on command lock violation
Date: Fri, 22 Jan 2016 15:42:41 +0100
Message-ID: <1453473761-54777-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbcAVOmp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 09:42:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

If MODE SELECT returns with sense '05/91/36' (command lock violation)
it should always be retried without counting the number of retries.
During an HBA upgrade or similar circumstances one might see a flood
of MODE SELECT command from various HBAs, which will easily trigger
the sense code and exceed the retry count.

References: bsc#956949

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 3613581..93880ed 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -562,7 +562,7 @@ static int mode_select_handle_sense(struct scsi_device *sdev,
 			/*
 			 * Command Lock contention
 			 */
-			err = SCSI_DH_RETRY;
+			err = SCSI_DH_IMM_RETRY;
 		break;
 	default:
 		break;
@@ -612,6 +612,8 @@ retry:
 		err = mode_select_handle_sense(sdev, h->sense);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
+		if (err == SCSI_DH_IMM_RETRY)
+			goto retry;
 	}
 	if (err == SCSI_DH_OK) {
 		h->state = RDAC_STATE_ACTIVE;
-- 
1.8.5.6

