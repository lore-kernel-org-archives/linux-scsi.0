From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/7] libfc: Do not drop down to FLOGI for fc_rport_login()
Date: Fri, 30 Sep 2016 09:04:11 +0200
Message-ID: <1475219054-31241-5-git-send-email-hare@suse.de>
References: <1475219054-31241-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55649 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753807AbcI3HE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 03:04:27 -0400
In-Reply-To: <1475219054-31241-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When fc_rport_login() is called while the rport is not
in RPORT_ST_INIT, RPORT_ST_READY, or RPORT_ST_DELETE
login is already in progress and there's no need to
drop down to FLOGI; doing so will only confuse the
other side.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index ff33ae6..4e4087a 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -427,10 +427,14 @@ static int fc_rport_login(struct fc_rport_priv *rdata)
 	case RPORT_ST_DELETE:
 		FC_RPORT_DBG(rdata, "Restart deleted port\n");
 		break;
-	default:
+	case RPORT_ST_INIT:
 		FC_RPORT_DBG(rdata, "Login to port\n");
 		fc_rport_enter_flogi(rdata);
 		break;
+	default:
+		FC_RPORT_DBG(rdata, "Login in progress, state %s\n",
+			     fc_rport_state(rdata));
+		break;
 	}
 	mutex_unlock(&rdata->rp_mutex);
 
-- 
1.8.5.6

