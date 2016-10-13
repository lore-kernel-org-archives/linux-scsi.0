From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/24] libfc: use configured rport E_D_TOV
Date: Thu, 13 Oct 2016 15:10:40 +0200
Message-ID: <1476364260-12191-5-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932268AbcJMNMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:12:36 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If fc_rport_error_retry() is attempting to retry the remote
port state we should be waiting for the configured e_d_tov
value rather than the default.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/libfc/fc_rport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index bcd1cd3..bb7e9d9 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -662,7 +662,7 @@ static void fc_rport_error(struct fc_rport_priv *rdata, struct fc_frame *fp)
 static void fc_rport_error_retry(struct fc_rport_priv *rdata,
 				 struct fc_frame *fp)
 {
-	unsigned long delay = msecs_to_jiffies(FC_DEF_E_D_TOV);
+	unsigned long delay = msecs_to_jiffies(rdata->e_d_tov);
 	struct fc_lport *lport = rdata->local_port;
 
 	/* make sure this isn't an FC_EX_CLOSED error, never retry those */
-- 
1.8.5.6

