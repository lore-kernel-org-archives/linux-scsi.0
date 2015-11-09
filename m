From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/18] scsi_dh_alua: Disable ALUA handling for non-disk devices
Date: Mon,  9 Nov 2015 16:08:08 +0100
Message-ID: <1447081703-110552-4-git-send-email-hare@suse.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51807 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbbKIPIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 10:08:25 -0500
In-Reply-To: <1447081703-110552-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Non-disk devices might support ALUA, but the firmware
implementation is untested and frequently broken.
As we're don't actually need it disable ALUA support
for non-disk device for now.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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
1.8.5.6

