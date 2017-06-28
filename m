From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/28] qlogicpti: move bus reset to host reset
Date: Wed, 28 Jun 2017 10:25:01 +0200
Message-ID: <1498638316-44420-14-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751678AbdF1IbL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:11 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus reset function really is a host reset, so move it to
eh_host_reset_handler().

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/qlogicpti.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 69bfc0a..274ee1cc 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1250,10 +1250,9 @@ static int qlogicpti_abort(struct scsi_cmnd *Cmnd)
 	return return_status;
 }
 
-static int qlogicpti_reset(struct scsi_cmnd *Cmnd)
+static int qlogicpti_reset(struct Scsi_Host *host)
 {
 	u_short param[6];
-	struct Scsi_Host *host = Cmnd->device->host;
 	struct qlogicpti *qpti = (struct qlogicpti *) host->hostdata;
 	int return_status = SUCCESS;
 
@@ -1283,7 +1282,7 @@ static int qlogicpti_reset(struct scsi_cmnd *Cmnd)
 	.queuecommand		= qlogicpti_queuecommand,
 	.slave_configure	= qlogicpti_slave_configure,
 	.eh_abort_handler	= qlogicpti_abort,
-	.eh_bus_reset_handler	= qlogicpti_reset,
+	.eh_host_reset_handler	= qlogicpti_reset,
 	.can_queue		= QLOGICPTI_REQ_QUEUE_LEN,
 	.this_id		= 7,
 	.sg_tablesize		= QLOGICPTI_MAX_SG(QLOGICPTI_REQ_QUEUE_LEN),
-- 
1.8.5.6
