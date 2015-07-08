From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/20] scsi_dh_alua: Disable ALUA handling for non-disk devices
Date: Wed,  8 Jul 2015 11:05:59 +0200
Message-ID: <1436346378-96518-2-git-send-email-hare@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934499AbbGHJG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 05:06:28 -0400
In-Reply-To: <1436346378-96518-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.de>

Non-disk devices might support ALUA, but the firmware
implementation is untested and frequently broken.
As we're don't actually need it disable ALUA support
for non-disk device for now.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index cc2773b..7d01ef0 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -320,6 +320,18 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	int err = SCSI_DH_OK;
 
+	/*
+	 * ALUA support for non-disk devices is fraught with
+	 * difficulties, so disable it for now.
+	 */
+	if (sdev->type != TYPE_DISK) {
+		h->tpgs = TPGS_MODE_NONE;
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: disable for non-disk devices\n",
+			    ALUA_DH_NAME);
+		return SCSI_DH_DEV_UNSUPP;
+	}
+
 	h->tpgs = scsi_device_tpgs(sdev);
 	switch (h->tpgs) {
 	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
-- 
1.8.5.2

