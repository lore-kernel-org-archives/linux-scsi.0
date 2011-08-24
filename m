From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/7] scsi_dh: Check for sdev state in store_dh_state()
Date: Wed, 24 Aug 2011 10:51:17 +0200
Message-ID: <1314175879-16565-6-git-send-email-hare@suse.de>
References: <1314175879-16565-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab1HXIvx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 04:51:53 -0400
In-Reply-To: <1314175879-16565-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Avoid attaching a hardware handler to a device which is
already scheduled for deletion.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 458521d..520bcf0 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -190,6 +190,10 @@ store_dh_state(struct device *dev, struct device_attribute *attr,
 	struct scsi_device_handler *scsi_dh;
 	int err = -EINVAL;
 
+	if (sdev->sdev_state == SDEV_CANCEL ||
+	    sdev->sdev_state == SDEV_DEL)
+		return -ENODEV;
+
 	if (!sdev->scsi_dh_data) {
 		/*
 		 * Attach to a device handler
-- 
1.6.0.2

