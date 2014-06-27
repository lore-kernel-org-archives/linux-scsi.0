From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/7] libfc: Do not call fc_block_scsi_eh() on host reset
Date: Fri, 27 Jun 2014 08:27:02 +0200
Message-ID: <1403850425-89297-5-git-send-email-hare@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbaF0G1K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 02:27:10 -0400
In-Reply-To: <1403850425-89297-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Vasu Dev <vasu.dev@intel.com>

When we're resetting the host any remote port states will
be reset anyway, so it's pointless to wait for dev_loss_tmo
during host reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Vasu Dev <vasu.dev@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 1d7e76e..89749d8 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2125,8 +2125,6 @@ int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
 
 	FC_SCSI_DBG(lport, "Resetting host\n");
 
-	fc_block_scsi_eh(sc_cmd);
-
 	lport->tt.lport_reset(lport);
 	wait_tmo = jiffies + FC_HOST_RESET_TIMEOUT;
 	while (!fc_fcp_lport_queue_ready(lport) && time_before(jiffies,
-- 
1.7.12.4

