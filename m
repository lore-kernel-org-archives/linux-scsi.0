From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 9/9] scsi_dh: return individual errors in scsi_dh_activate()
Date: Mon,  6 Jul 2015 16:15:05 +0200
Message-ID: <1436192105-44064-10-git-send-email-hare@suse.de>
References: <1436192105-44064-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbbGFOPM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 10:15:12 -0400
In-Reply-To: <1436192105-44064-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>

When calling scsi_dh_activate() we should be returning
individual errors and not lumping all into one.

Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_dh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 336dc54..0984e0d 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -323,6 +323,7 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 
 	if (!sdev->handler)
 		goto out_fn;
+	err = SCSI_DH_NOTCONN;
 	if (sdev->sdev_state == SDEV_CANCEL ||
 	    sdev->sdev_state == SDEV_DEL)
 		goto out_fn;
-- 
1.8.5.2

