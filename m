From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 6/7] SYNCHRONIZE_CACHE command used fixed value
Date: Wed, 26 Nov 2008 19:31:24 +0100
Message-ID: <200811261931.25621.bs@q-leap.de>
References: <200811261840.45360.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:57619 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbYKZSba (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 13:31:30 -0500
In-Reply-To: <200811261840.45360.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>

Switch to adjustable timeout value for scsi SYNCHRONIZE_CACHE commands.
We have been running into problems with fixed values on troublesome devices.

Signed-off-by: Bernd Schubert <bs@q-leap.de>


---
 drivers/scsi/sd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/scsi/sd.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sd.c
+++ linux-2.6/drivers/scsi/sd.c
@@ -884,7 +884,8 @@ static int sd_sync_cache(struct scsi_dis
 		 * flush everything.
 		 */
 		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_TIMEOUT, SD_MAX_RETRIES);
+				       sdp->request_queue->rq_timeout,
+				       SD_MAX_RETRIES);
 		if (res == 0)
 			break;
 	}
@@ -903,7 +904,7 @@ static int sd_sync_cache(struct scsi_dis
 static void sd_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
-	rq->timeout = SD_TIMEOUT;
+	rq->timeout = q->rq_timeout;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
 	rq->cmd_len = 10;
 }


-- 
Bernd Schubert
Q-Leap Networks GmbH
