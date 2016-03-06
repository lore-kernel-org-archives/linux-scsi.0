From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v6 03/17] scsi: ufs: implement scsi host timeout handler
Date: Sun,  6 Mar 2016 13:55:44 +0200
Message-ID: <1457265358-31635-4-git-send-email-ygardi@codeaurora.org>
References: <1457265358-31635-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33355 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbcCFL4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2016 06:56:20 -0500
In-Reply-To: <1457265358-31635-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Gilad Broner <gbroner@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

A race condition exists between request requeueing and scsi layer
error handling:
When UFS driver queuecommand returns a busy status for a request,
it will be requeued and its tag will be freed and set to -1.
At the same time it is possible that the request will timeout and
scsi layer will start error handling for it. The scsi layer reuses
the request and its tag to send error related commands to the device,
however its tag is no longer valid.
As this request was never really sent to the device, there is no
point to start error handling with the device.
Implement the scsi error handling timeout callback and bypass SCSI
error handling for request that were not actually sent to the device.
For such requests simply reset the block layer timer. Otherwise, let
SCSI layer perform the usual error handling.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index de7280c..3400ceb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4568,6 +4568,41 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	ufshcd_probe_hba(hba);
 }
 
+static enum blk_eh_timer_return ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	struct Scsi_Host *host;
+	struct ufs_hba *hba;
+	int index;
+	bool found = false;
+
+	if (!scmd || !scmd->device || !scmd->device->host)
+		return BLK_EH_NOT_HANDLED;
+
+	host = scmd->device->host;
+	hba = shost_priv(host);
+	if (!hba)
+		return BLK_EH_NOT_HANDLED;
+
+	spin_lock_irqsave(host->host_lock, flags);
+
+	for_each_set_bit(index, &hba->outstanding_reqs, hba->nutrs) {
+		if (hba->lrb[index].cmd == scmd) {
+			found = true;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	/*
+	 * Bypass SCSI error handling and reset the block layer timer if this
+	 * SCSI command was not actually dispatched to UFS driver, otherwise
+	 * let SCSI layer handle the error as usual.
+	 */
+	return found ? BLK_EH_NOT_HANDLED : BLK_EH_RESET_TIMER;
+}
+
 static struct scsi_host_template ufshcd_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= UFSHCD,
@@ -4580,6 +4615,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
+	.eh_timed_out		= ufshcd_eh_timed_out,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
