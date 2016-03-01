From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] scsi_dh_emc: update 'access_state' field
Date: Tue,  1 Mar 2016 05:55:42 +0100
Message-ID: <1456808143-88932-6-git-send-email-hare@suse.de>
References: <1456808143-88932-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbcCAE4L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Feb 2016 23:56:11 -0500
In-Reply-To: <1456808143-88932-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Update the 'access_state' field of the SCSI device whenever
the path state changes.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_emc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index e6fb97c..375d818 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -199,7 +199,12 @@ static int parse_sp_info_reply(struct scsi_device *sdev,
 	csdev->lun_state = csdev->buffer[4];
 	csdev->current_sp = csdev->buffer[8];
 	csdev->port = csdev->buffer[7];
-
+	if (csdev->lun_state == CLARIION_LUN_OWNED)
+		sdev->access_state = SCSI_ACCESS_STATE_OPTIMAL;
+	else
+		sdev->access_state = SCSI_ACCESS_STATE_STANDBY;
+	if (csdev->default_sp == csdev->current_sp)
+		sdev->access_state |= SCSI_ACCESS_STATE_PREFERRED;
 out:
 	return err;
 }
-- 
2.6.2

