From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] qlogicpti: fixup qlogicpti_reset() definition
Date: Mon, 28 Aug 2017 10:14:26 +0200
Message-ID: <1503908066-106335-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33452 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754104AbdH1IOg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Aug 2017 04:14:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

A merge error crept in when formatting commit
af167bc ("scsi: qlogicpti: move bus reset to host reset")

Fixes: af167bc ("scsi: qlogicpti: move bus reset to host reset")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/qlogicpti.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 274ee1ccfea8..cec9a14982e6 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1250,9 +1250,10 @@ static int qlogicpti_abort(struct scsi_cmnd *Cmnd)
 	return return_status;
 }
 
-static int qlogicpti_reset(struct Scsi_Host *host)
+static int qlogicpti_reset(struct scsi_cmnd *Cmnd)
 {
 	u_short param[6];
+	struct Scsi_Host *host = Cmnd->device->host;
 	struct qlogicpti *qpti = (struct qlogicpti *) host->hostdata;
 	int return_status = SUCCESS;
 
-- 
2.12.3
