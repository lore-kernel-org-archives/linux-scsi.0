From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/7] scsi_dh_alua: always update TPGS status on activate
Date: Wed, 24 Aug 2011 10:51:16 +0200
Message-ID: <1314175879-16565-5-git-send-email-hare@suse.de>
References: <1314175879-16565-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab1HXIvu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2011 04:51:50 -0400
In-Reply-To: <1314175879-16565-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When activating a patch we should always update the TPGS state
as it might have changed in between.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 80c5cf3..f44dbf6 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -631,11 +631,9 @@ static int alua_activate(struct scsi_device *sdev,
 	struct alua_dh_data *h = get_alua_data(sdev);
 	int err = SCSI_DH_OK;
 
-	if (h->group_id != -1) {
-		err = alua_rtpg(sdev, h);
-		if (err != SCSI_DH_OK)
-			goto out;
-	}
+	err = alua_rtpg(sdev, h);
+	if (err != SCSI_DH_OK)
+		goto out;
 
 	if (h->tpgs & TPGS_MODE_EXPLICIT &&
 	    h->state != TPGS_STATE_OPTIMIZED &&
-- 
1.6.0.2

