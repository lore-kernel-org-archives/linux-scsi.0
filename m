From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] scsi: break from queue depth adjusting loops when device found
Date: Thu, 03 Jul 2014 10:05:57 -0500
Message-ID: <20140703150557.21608.37072.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:53297 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaGCPGu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 11:06:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =james.bottomley@parallels.com
Cc: elliott@hp.com, stephenmcameron@gmail.com, hch@lst.de, linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Don't loop through all the devices even after
finding the one we're looking for

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Robert Elliott <elliott@hp.com>
---
 drivers/scsi/scsi_error.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cbe38e5..db8a488 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -635,6 +635,7 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth + 1,
 					SCSI_QDEPTH_RAMP_UP);
 		sdev->last_queue_ramp_up = jiffies;
+		break;
 	}
 }
 
@@ -657,6 +658,7 @@ static void scsi_handle_queue_full(struct scsi_device *sdev)
 		 */
 		sht->change_queue_depth(tmp_sdev, tmp_sdev->queue_depth - 1,
 					SCSI_QDEPTH_QFULL);
+		break;
 	}
 }
 

