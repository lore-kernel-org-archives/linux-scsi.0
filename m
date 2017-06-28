From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/28] fc_fcp: do not call fc_block_scsi_eh() from host reset
Date: Wed, 28 Jun 2017 10:24:52 +0200
Message-ID: <1498638316-44420-5-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52899 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751556AbdF1IbB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:01 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When calling host reset we're resetting all ports anyway, so
there is no point in waiting for the ports to become unblocked.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/libfc/fc_fcp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 234352da..772c35a 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2222,8 +2222,6 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 
 	FC_SCSI_DBG(lport, "Resetting host\n");
 
-	fc_block_scsi_eh(sc_cmd);
-
 	fc_lport_reset(lport);
 	wait_tmo = jiffies + FC_HOST_RESET_TIMEOUT;
 	while (!fc_fcp_lport_queue_ready(lport) && time_before(jiffies,
-- 
1.8.5.6
