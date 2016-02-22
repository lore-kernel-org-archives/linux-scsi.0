From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [v2 PATCH 2/3] scsi:stex.c Add hotplug support
Date: Mon, 22 Feb 2016 20:04:25 +0800
Message-ID: <1456142665-25327-1-git-send-email-ch1102chiou@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34177 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbcBVMEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2016 07:04:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, martin.petersen@oracle.com, jthumshirn@suse.de, hch@infradead.org, oneukum@suse.de, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Charles <charles.chiou@tw.promise.com>

1. Add hotplug support. Pegasus support surprise removal. To this end, I
   use return_abnormal_state function to return DID_NO_CONNECT for all
      commands which sent to driver.

2. Remove stex_hba_stop in stex_remove because we cannot send command to
   device after hotplug.

3. Add new device status:  MU_STATE_STOP, MU_STATE_NOCONNECT,
   MU_STATE_STOP. MU_STATE_STOP is currently not referenced.
   MU_STATE_NOCONNECT represent that device is plugged out from the host.

4. Use return_abnormal_function() to substitute part of code in stex_do_reset.

Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/stex.c | 53 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 495d632..1994603 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -84,6 +84,8 @@ enum {
 	MU_STATE_STARTED			= 2,
 	MU_STATE_RESETTING			= 3,
 	MU_STATE_FAILED				= 4,
+	MU_STATE_STOP				= 5,
+	MU_STATE_NOCONNECT			= 6,
 
 	MU_MAX_DELAY				= 120,
 	MU_HANDSHAKE_SIGNATURE			= 0x55aaaa55,
@@ -537,6 +539,27 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 	readl(hba->mmio_base + YH2I_REQ); /* flush */
 }
 
+static void return_abnormal_state(struct st_hba *hba, int status)
+{
+	struct st_ccb *ccb;
+	unsigned long flags;
+	u16 tag;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	for (tag = 0; tag < hba->host->can_queue; tag++) {
+		ccb = &hba->ccb[tag];
+		if (ccb->req == NULL)
+			continue;
+		ccb->req = NULL;
+		if (ccb->cmd) {
+			scsi_dma_unmap(ccb->cmd);
+			ccb->cmd->result = status << 16;
+			ccb->cmd->scsi_done(ccb->cmd);
+			ccb->cmd = NULL;
+		}
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+}
 static int
 stex_slave_config(struct scsi_device *sdev)
 {
@@ -560,8 +583,12 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 	hba = (struct st_hba *) &host->hostdata[0];
-
-	if (unlikely(hba->mu_status == MU_STATE_RESETTING))
+	if (hba->mu_status == MU_STATE_NOCONNECT) {
+		cmd->result = DID_NO_CONNECT;
+		done(cmd);
+		return 0;
+	}
+	if (unlikely(hba->mu_status != MU_STATE_STARTED))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	switch (cmd->cmnd[0]) {
@@ -1260,10 +1287,8 @@ static void stex_ss_reset(struct st_hba *hba)
 
 static int stex_do_reset(struct st_hba *hba)
 {
-	struct st_ccb *ccb;
 	unsigned long flags;
 	unsigned int mu_status = MU_STATE_RESETTING;
-	u16 tag;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->mu_status == MU_STATE_STARTING) {
@@ -1297,20 +1322,8 @@ static int stex_do_reset(struct st_hba *hba)
 	else if (hba->cardtype == st_yel)
 		stex_ss_reset(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	for (tag = 0; tag < hba->host->can_queue; tag++) {
-		ccb = &hba->ccb[tag];
-		if (ccb->req == NULL)
-			continue;
-		ccb->req = NULL;
-		if (ccb->cmd) {
-			scsi_dma_unmap(ccb->cmd);
-			ccb->cmd->result = DID_RESET << 16;
-			ccb->cmd->scsi_done(ccb->cmd);
-			ccb->cmd = NULL;
-		}
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	return_abnormal_state(hba, DID_RESET);
 
 	if (stex_handshake(hba) == 0)
 		return 0;
@@ -1771,9 +1784,11 @@ static void stex_remove(struct pci_dev *pdev)
 {
 	struct st_hba *hba = pci_get_drvdata(pdev);
 
+	hba->mu_status = MU_STATE_NOCONNECT;
+	return_abnormal_state(hba, DID_NO_CONNECT);
 	scsi_remove_host(hba->host);
 
-	stex_hba_stop(hba);
+	scsi_block_requests(hba->host);
 
 	stex_hba_free(hba);
 
-- 
1.9.1

