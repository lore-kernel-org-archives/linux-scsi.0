From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_transport_fc: Also check for NOTPRESENT in fc_remote_port_add()
Date: Mon, 25 Sep 2017 13:47:23 +0200
Message-ID: <1506340043-67444-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40542 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933681AbdIYLr1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Sep 2017 07:47:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

During failover there is a small race window between fc_remote_port_add()
and fc_timeout_deleted_rport(); the latter drops the lock after setting
the port to NOTPRESENT, so if fc_remote_port_add() is called right at
that time it will fail to detect the existing rport and happily adding
a new structure, causing rports to get registered twice.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_transport_fc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3c6bc00..9d2d559 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2739,7 +2739,8 @@ struct fc_rport *
 
 	list_for_each_entry(rport, &fc_host->rports, peers) {
 
-		if ((rport->port_state == FC_PORTSTATE_BLOCKED) &&
+		if ((rport->port_state == FC_PORTSTATE_BLOCKED ||
+		     rport->port_state == FC_PORTSTATE_NOTPRESENT) &&
 			(rport->channel == channel)) {
 
 			switch (fc_host->tgtid_bind_type) {
-- 
1.8.5.6
