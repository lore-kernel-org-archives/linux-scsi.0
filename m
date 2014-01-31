From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/16] scsi_dh: invoke callback if ->activate is not present
Date: Fri, 31 Jan 2014 10:29:58 +0100
Message-ID: <1391160600-19652-15-git-send-email-hare@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbaAaJaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jan 2014 04:30:11 -0500
In-Reply-To: <1391160600-19652-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When ->activate isn't present we still need to invoke the
callbacks, otherwise the system might stall.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index ae7f399..a90380f 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -411,7 +411,7 @@ int scsi_dh_activate(struct request_queue *q, activate_complete fn, void *data)
 		err = SCSI_DH_DEV_OFFLINED;
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
-	if (err != SCSI_DH_OK) {
+	if (err != SCSI_DH_OK || !scsi_dh->activate) {
 		if (fn)
 			fn(data, err);
 		goto out;
-- 
1.7.12.4

