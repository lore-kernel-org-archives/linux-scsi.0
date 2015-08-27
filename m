From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/10] scsi_dh: return SCSI_DH_NOTCONN in scsi_dh_activate()
Date: Thu, 27 Aug 2015 14:17:02 +0200
Message-ID: <1440677823-11695-10-git-send-email-hare@suse.de>
References: <1440677823-11695-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbbH0MRH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:17:07 -0400
In-Reply-To: <1440677823-11695-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When calling scsi_dh_activate() we should be returning
SCSI_DH_NOTCONN if the device handler couldn't be attached.

Reviewed-by: Bart van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_dh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 954ca5e..2d93bc9 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -325,6 +325,7 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 
 	if (!sdev->handler)
 		goto out_fn;
+	err = SCSI_DH_NOTCONN;
 	if (sdev->sdev_state == SDEV_CANCEL ||
 	    sdev->sdev_state == SDEV_DEL)
 		goto out_fn;
-- 
1.8.5.6

