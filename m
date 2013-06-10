From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/7] dpt_i2o: return SCSI_MLQUEUE_HOST_BUSY when in reset
Date: Mon, 10 Jun 2013 13:11:48 +0200
Message-ID: <1370862713-41323-3-git-send-email-hare@suse.de>
References: <1370862713-41323-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3FJLMD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 07:12:03 -0400
In-Reply-To: <1370862713-41323-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

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

