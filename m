From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/30] libfc: Do not login if the port is already started
Date: Fri, 26 Aug 2016 14:01:27 +0200
Message-ID: <1472212913-39810-5-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35116 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751668AbcHZMCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:08 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When the port is already started we don't need to login; that
will only confuse the state machine.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a37b37b..2406276 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -420,6 +420,12 @@ static int fc_rport_login(struct fc_rport_priv *rdata)
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

