From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/16] scsi_dh_alua: Do not attach to management devices
Date: Fri, 20 Dec 2013 13:13:35 +0100
Message-ID: <1387541621-54967-11-git-send-email-hare@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756841Ab3LTMNp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 07:13:45 -0500
In-Reply-To: <1387541621-54967-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, Hannes Reinecke <hare@suse.de>

Management devices should be ignored when
detecting ALUA capabilites.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e297851..51f4a31 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -315,6 +315,23 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
 {
 	int err = SCSI_DH_OK;
 
+	if (scsi_is_wlun(sdev->lun)) {
+		h->tpgs = TPGS_MODE_NONE;
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: disable for WLUN\n",
+			    ALUA_DH_NAME);
+		return SCSI_DH_DEV_UNSUPP;
+	}
+	if (sdev->type == TYPE_RAID ||
+	    sdev->type == TYPE_ENCLOSURE ||
+	    sdev->type == 0x1F) {
+		h->tpgs = TPGS_MODE_NONE;
+		sdev_printk(KERN_INFO, sdev,
+			    "%s: disable for enclosure devices\n",
+			    ALUA_DH_NAME);
+		return SCSI_DH_DEV_UNSUPP;
+	}
+
 	h->tpgs = scsi_device_tpgs(sdev);
 	switch (h->tpgs) {
 	case TPGS_MODE_EXPLICIT|TPGS_MODE_IMPLICIT:
-- 
1.7.12.4

