From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 4/9] fnic: Remove QUEUE_FULL handling code
Date: Mon,  9 Sep 2013 13:31:48 -0700
Message-ID: <1378758713-22443-4-git-send-email-hiralpat@cisco.com>
References: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-6.cisco.com ([173.37.86.77]:24198 "EHLO
	rcdn-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3IIUgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 16:36:20 -0400
In-Reply-To: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Suma Ramars <sramars@cisco.com>, Hiral Patel <hiralpat@cisco.com>

From: Suma Ramars <sramars@cisco.com>

Remove fnic driver QUEUE_FULL handling code instead let SCSI mid layer
handle queue full and use its algorithm to ramp down/up queue

Signed-off-by: Suma Ramars <sramars@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index ef3c463..a09dd8d 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -818,38 +818,6 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic,
 		if (icmnd_cmpl->flags & FCPIO_ICMND_CMPL_RESID_UNDER)
 			xfer_len -= icmnd_cmpl->residual;
 
-		/*
-		 * If queue_full, then try to reduce queue depth for all
-		 * LUNS on the target. Todo: this should be accompanied
-		 * by a periodic queue_depth rampup based on successful
-		 * IO completion.
-		 */
-		if (icmnd_cmpl->scsi_status == QUEUE_FULL) {
-			struct scsi_device *t_sdev;
-			int qd = 0;
-
-			shost_for_each_device(t_sdev, sc->device->host) {
-				if (t_sdev->id != sc->device->id)
-					continue;
-
-				if (t_sdev->queue_depth > 1) {
-					qd = scsi_track_queue_full
-						(t_sdev,
-						 t_sdev->queue_depth - 1);
-					if (qd == -1)
-						qd = t_sdev->host->cmd_per_lun;
-					shost_printk(KERN_INFO,
-						     fnic->lport->host,
-						     "scsi[%d:%d:%d:%d"
-						     "] queue full detected,"
-						     "new depth = %d\n",
-						     t_sdev->host->host_no,
-						     t_sdev->channel,
-						     t_sdev->id, t_sdev->lun,
-						     t_sdev->queue_depth);
-				}
-			}
-		}
 		break;
 
 	case FCPIO_TIMEOUT:          /* request was timed out */
-- 
1.7.10.4

