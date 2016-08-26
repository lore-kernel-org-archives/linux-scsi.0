From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/30] libfc: use configured e_d_tov for remote port state
Date: Fri, 26 Aug 2016 14:01:29 +0200
Message-ID: <1472212913-39810-7-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751671AbcHZMCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:06 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If fc_rport_error_retry() is attempting to retry the remote
port state we should be waiting for the configured e_d_tov
value rather than the default.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 2406276..4c13acc 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -656,7 +656,7 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 static void fc_rport_error_retry(struct fc_rport_priv *rdata,
 				 struct fc_frame *fp)
 {
-	unsigned long delay = msecs_to_jiffies(FC_DEF_E_D_TOV);
+	unsigned long delay = msecs_to_jiffies(rdata->e_d_tov);
 	struct fc_lport *lport = rdata->local_port;
 
 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
-- 
1.8.5.6

