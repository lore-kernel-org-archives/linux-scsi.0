From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] scsi_dh: Allow NULL hardware handler name in scsi_dh_attach()
Date: Mon,  2 Apr 2012 18:43:54 +0200
Message-ID: <1333385035-6663-2-git-send-email-hare@suse.de>
References: <1333385035-6663-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2DBQoG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Apr 2012 12:44:06 -0400
In-Reply-To: <1333385035-6663-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>

This patch allows to pass in a NULL hardware handler to
scsi_dh_attach(), causing the reference count of the existing
hardware handler to be increased.
An error will be returned if no hardware handler is attached.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 48e46f5..77fa67e 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -475,10 +475,14 @@ int scsi_dh_attach(struct request_queue *q, const char *name)
 {
 	unsigned long flags;
 	struct scsi_device *sdev;
-	struct scsi_device_handler *scsi_dh;
+	struct scsi_device_handler *scsi_dh = NULL;
 	int err = 0;
 
-	scsi_dh = get_device_handler(name);
+	if (name) {
+		scsi_dh = get_device_handler(name);
+	} else if (sdev->scsi_dh_data) {
+		scsi_dh = sdev->scsi_dh_data->scsi_dh;
+	}
 	if (!scsi_dh)
 		return -EINVAL;
 
-- 
1.7.7

