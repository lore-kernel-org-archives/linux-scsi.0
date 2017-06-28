From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/47] zfcp: open-code fc_block_scsi_eh() for host reset
Date: Wed, 28 Jun 2017 10:32:35 +0200
Message-ID: <1498638793-44672-10-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53783 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751536AbdF1IdT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:19 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When issuing a host reset we should be waiting for all
ports to become unblocked; just waiting for one might
be resulting in host reset to return too early.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/s390/scsi/zfcp_scsi.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 0678cf7..3d18659 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -311,13 +311,32 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
 
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
-	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
-	int ret;
+	struct Scsi_Host *host = scpnt->device->host;
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
+	int ret = 0;
+	unsigned long flags;
+	struct zfcp_port *port;
 
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
-	ret = fc_block_scsi_eh(scpnt);
+retry_rport_blocked:
+	spin_lock_irqsave(host->host_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list) {
+		struct fc_rport *rport = port->rport;
+
+		if (rport->port_state == FC_PORTSTATE_BLOCKED) {
+			if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
+				ret = FAST_IO_FAIL;
+			else
+				ret = NEEDS_RETRY;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(host->host_lock, flags);
+	if (ret == NEEDS_RETRY) {
+		msleep(1000);
+		goto retry_rport_blocked;
+	}
 	if (ret)
 		return ret;
 
-- 
1.8.5.6
