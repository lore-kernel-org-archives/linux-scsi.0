From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/5] scsi_dh_rdac: Add 'state' callback
Date: Wed,  8 Jul 2015 13:09:48 +0200
Message-ID: <1436353788-104911-6-git-send-email-hare@suse.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933796AbbGHLJw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 07:09:52 -0400
In-Reply-To: <1436353788-104911-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Add a 'state' callback to display the current LUN access state
to sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 3613581..151b736 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -834,6 +834,22 @@ static void rdac_bus_detach( struct scsi_device *sdev )
 	kfree(h);
 }
 
+static int rdac_state(struct scsi_device *sdev)
+{
+	struct rdac_dh_data *h = sdev->handler_data;
+	int access_state = SCSI_ACCESS_STATE_OPTIMAL;
+
+	if (h->lun_state == RDAC_LUN_UNOWNED)
+		access_state = SCSI_ACCESS_STATE_ACTIVE;
+	if (h->state == RDAC_STATE_PASSIVE)
+		access_state = SCSI_ACCESS_STATE_PASSIVE;
+
+	if (h->preferred == RDAC_PREFERRED)
+		access_state |= SCSI_ACCESS_STATE_PREFERRED;
+
+	return access_state;
+}
+
 static struct scsi_device_handler rdac_dh = {
 	.name = RDAC_NAME,
 	.module = THIS_MODULE,
@@ -842,6 +858,7 @@ static struct scsi_device_handler rdac_dh = {
 	.attach = rdac_bus_attach,
 	.detach = rdac_bus_detach,
 	.activate = rdac_activate,
+	.state = rdac_state,
 };
 
 static int __init rdac_init(void)
-- 
1.8.5.2

