From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/20] libfc: Replace ->lport_reset callback with function call
Date: Tue, 18 Oct 2016 10:01:36 +0200
Message-ID: <1476777714-3543-3-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47267 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751993AbcJRICZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:25 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->lport_reset callback only ever had one implementation,
which already is exported. So remove it and use the function
directly.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 drivers/scsi/libfc/fc_fcp.c   | 2 +-
 drivers/scsi/libfc/fc_lport.c | 3 ---
 include/scsi/libfc.h          | 7 -------
 4 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d9fd2f8..bfaba06 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2543,7 +2543,7 @@ int fnic_reset(struct Scsi_Host *shost)
 	 * Reset local port, this will clean up libFC exchanges,
 	 * reset remote port sessions, and if link is up, begin flogi
 	 */
-	ret = lp->tt.lport_reset(lp);
+	ret = fc_lport_reset(lp);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from fnic reset %s\n",
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c033946..831de3e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2224,7 +2224,7 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 
 	fc_block_scsi_eh(sc_cmd);
 
-	lport->tt.lport_reset(lport);
+	fc_lport_reset(lport);
 	wait_tmo = jiffies + FC_HOST_RESET_TIMEOUT;
 	while (!fc_fcp_lport_queue_ready(lport) && time_before(jiffies,
 							       wait_tmo))
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index bf79c9b..05f83a6 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -1868,9 +1868,6 @@ int fc_lport_init(struct fc_lport *lport)
 	if (!lport->tt.lport_recv)
 		lport->tt.lport_recv = fc_lport_recv_req;
 
-	if (!lport->tt.lport_reset)
-		lport->tt.lport_reset = fc_lport_reset;
-
 	fc_host_port_type(lport->host) = FC_PORTTYPE_NPORT;
 	fc_host_node_name(lport->host) = lport->wwnn;
 	fc_host_port_name(lport->host) = lport->wwpn;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 0e95803..7ee0d27 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -628,13 +628,6 @@ struct libfc_function_template {
 	void (*lport_recv)(struct fc_lport *, struct fc_frame *);
 
 	/*
-	 * Reset the local port.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	int (*lport_reset)(struct fc_lport *);
-
-	/*
 	 * Set the local port FC_ID.
 	 *
 	 * This may be provided by the LLD to allow it to be
-- 
1.8.5.6

