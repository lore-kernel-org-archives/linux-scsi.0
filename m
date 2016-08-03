From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/22] libfc: Do not attempt to login if the port is already started
Date: Wed,  3 Aug 2016 15:13:05 +0200
Message-ID: <1470230002-37737-6-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40030 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbcHCNNb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:31 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When the port is already started we don't need to login; that
will only confuse the state machine.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index afc1f9b..8dd656e 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -418,6 +418,12 @@ static int fc_rport_login(struct fc_rport_priv *rdata)
 {
 	mutex_lock(&rdata->rp_mutex);
 
+	if (rdata->flags & FC_RP_STARTED) {
+		FC_RPORT_DBG(rdata, "port already started\n");
+		mutex_unlock(&rdata->rp_mutex);
+		return 0;
+	}
+
 	rdata->flags |= FC_RP_STARTED;
 	switch (rdata->rp_state) {
 	case RPORT_ST_READY:
-- 
1.8.5.6

