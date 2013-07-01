From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/7] dpt_i2o: return SCSI_MLQUEUE_HOST_BUSY when in reset
Date: Mon,  1 Jul 2013 08:50:50 +0200
Message-ID: <1372661455-122384-3-git-send-email-hare@suse.de>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab3GAGvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 02:51:04 -0400
In-Reply-To: <1372661455-122384-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, Hannes Reinecke <hare@suse.de>

When the HBA is in reset we should be returning 'busy' and not
rely on the obscure 'last_reset' feature.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dpt_i2o.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 106ff1a..0a2d801 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -448,11 +448,8 @@ static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 	}
 
 	rmb();
-	if((pHba->state) & DPTI_STATE_RESET) {
-		pHba->host->last_reset = jiffies;
-		pHba->host->resetting = 1;
-		return 1;
-	}
+	if((pHba->state) & DPTI_STATE_RESET)
+		return SCSI_MLQUEUE_HOST_BUSY;
 
 	// TODO if the cmd->device if offline then I may need to issue a bus rescan
 	// followed by a get_lct to see if the device is there anymore
-- 
1.7.12.4

