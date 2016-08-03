From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/22] libfc: use configured e_d_tov for remote port state retries
Date: Wed,  3 Aug 2016 15:13:10 +0200
Message-ID: <1470230002-37737-11-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbcHCNNe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:34 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If fc_rport_error_retry() is attempting to retry the remote
port state we should be waiting for the configured e_d_tov
value rather than the default.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 1f22c2e..8fad3e9 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -634,7 +634,7 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 static void fc_rport_error_retry(struct fc_rport_priv *rdata,
 				 struct fc_frame *fp)
 {
-	unsigned long delay = msecs_to_jiffies(FC_DEF_E_D_TOV);
+	unsigned long delay = msecs_to_jiffies(rdata->e_d_tov);
 	struct fc_lport *lport = rdata->local_port;
 
 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
-- 
1.8.5.6

