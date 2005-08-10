From: James.Smart@Emulex.Com
Subject: [PATCH 1 of 7] lpfc driver 8.0.30 : dev_loss and nodev timeouts
Date: Wed, 10 Aug 2005 15:02:30 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F439D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:59789 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030195AbVHJTCc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 15:02:32 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j7AJ2Vr7000728
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2005 12:02:32 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix handling of the dev_loss and nodev timeouts.

Symptoms: when remote port disappears for a period of time longer then
either nodev_tmo or dev_loss_tmo, the lpfc driver worker thread will
stall removing that remote port.

Cause: removing remote port involves un-blocking and sync-ing
corresponding block device queue. But corresponding node in the lpfc
driver is still in the NPR(?node port recovery?) state and mid-layer
gets SCSI_MLQUEUE_HOST_BUSY as a return value when it is trying to call
queuecommand() with command for that node (AKA remote port)

Fix: Instead of returning SCSI_MLQUEUE_HOST_BUS from queuecommand() for
nodes in NPR states complete it with retry-able error code  DID_BUS_BUSY

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -746,6 +746,10 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 			cmnd->result = ScsiResult(DID_NO_CONNECT, 0);
 			goto out_fail_command;
 		}
+		else if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
+			cmnd->result = ScsiResult(DID_BUS_BUSY, 0);
+			goto out_fail_command;
+		}
 		/*
 		 * The device is most likely recovered and the driver
 		 * needs a bit more time to finish.  Ask the midlayer
