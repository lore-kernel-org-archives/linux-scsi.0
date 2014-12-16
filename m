From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [PATCH 2/4 v4] scsi:stex.c Add hotplug support
Date: Tue, 16 Dec 2014 11:35:51 +0800
Message-ID: <548FA897.8000607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>, Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>
Cc: ed.lin@promise.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


 From 901f2c1b2d1ae2991182f0f62cedc70f87ea49bc Mon Sep 17 00:00:00 2001
From: Charles Chiou <charles.chiou@tw.promise.com>
Date: Wed, 5 Nov 2014 17:18:37 +0800
Subject: [PATCH 2/4] scsi:stex.c Add hotplug support

1. Add hotplug support. Pegasus support surprise removal. To this end, I
    use return_abnormal_state function to return DID_NO_CONNECT for all
    commands which sent to driver.

2. Remove stex_hba_stop in stex_remove because we cannot send command to
    device after hotplug.

3. Add new device status:  MU_STATE_STOP, MU_STATE_NOCONNECT
    , MU_STATE_STOP. MU_STATE_STOP is currently not referenced.
    MU_STATE_NOCONNECT represent that device is plugged out
    from the host.

4. Use return_abnormal_function() to substitute part of code
    in stex_do_reset.

Signed-off-by: charles.chiou@tw.promise.com
---
  drivers/scsi/stex.c | 51 
+++++++++++++++++++++++++++++++++------------------
  1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 08e7bc8..7dc6afe 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -83,6 +83,8 @@ enum {
  	MU_STATE_STARTED			= 2,
  	MU_STATE_RESETTING			= 3,
  	MU_STATE_FAILED				= 4,
+	MU_STATE_STOP				= 5,
+	MU_STATE_NOCONNECT			= 6,

  	MU_MAX_DELAY				= 120,
  	MU_HANDSHAKE_SIGNATURE			= 0x55aaaa55,
@@ -544,6 +546,27 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg 
*req, u16 tag)
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
  stex_slave_alloc(struct scsi_device *sdev)
  {
@@ -585,7 +608,11 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void 
(*done)(struct scsi_cmnd *))
  	id = cmd->device->id;
  	lun = cmd->device->lun;
  	hba = (struct st_hba *) &host->hostdata[0];
-
+	if (hba->mu_status == MU_STATE_NOCONNECT) {
+		cmd->result = DID_NO_CONNECT;
+		done(cmd);
+		return 0;
+	}
  	if (unlikely(hba->mu_status == MU_STATE_RESETTING))
  		return SCSI_MLQUEUE_HOST_BUSY;

@@ -1287,10 +1314,8 @@ static void stex_ss_reset(struct st_hba *hba)

  static int stex_do_reset(struct st_hba *hba)
  {
-	struct st_ccb *ccb;
  	unsigned long flags;
  	unsigned int mu_status = MU_STATE_RESETTING;
-	u16 tag;

  	spin_lock_irqsave(hba->host->host_lock, flags);
  	if (hba->mu_status == MU_STATE_STARTING) {
@@ -1324,20 +1349,8 @@ static int stex_do_reset(struct st_hba *hba)
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
@@ -1808,9 +1821,11 @@ static void stex_remove(struct pci_dev *pdev)
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
