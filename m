From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_transport_fc: set scsi_target_id upon rescan
Date: Wed, 20 Sep 2017 08:58:53 +0200
Message-ID: <1505890733-48870-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51607 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751397AbdITG7D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Sep 2017 02:59:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Smart <james.smart@broadcom.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

When an rport is found in the bindings array there is no guarantee that
it had been a target port, so we need to call fc_remote_port_rolechg()
here to ensure the scsi_target_id is set correctly.
Otherwise the port will never be scanned.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_transport_fc.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3c6bc0081fcb..377961380fd7 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2876,7 +2876,6 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 			memcpy(&rport->port_name, &ids->port_name,
 				sizeof(rport->port_name));
 			rport->port_id = ids->port_id;
-			rport->roles = ids->roles;
 			rport->port_state = FC_PORTSTATE_ONLINE;
 			rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 
@@ -2885,15 +2884,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 						fci->f->dd_fcrport_size);
 			spin_unlock_irqrestore(shost->host_lock, flags);
 
-			if (ids->roles & FC_PORT_ROLE_FCP_TARGET) {
-				scsi_target_unblock(&rport->dev, SDEV_RUNNING);
-
-				/* initiate a scan of the target */
-				spin_lock_irqsave(shost->host_lock, flags);
-				rport->flags |= FC_RPORT_SCAN_PENDING;
-				scsi_queue_work(shost, &rport->scan_work);
-				spin_unlock_irqrestore(shost->host_lock, flags);
-			}
+			fc_remote_port_rolechg(rport, ids->roles);
 			return rport;
 		}
 	}
-- 
2.12.3
