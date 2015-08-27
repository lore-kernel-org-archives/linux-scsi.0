From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v2 14/15] scsi: ufs: commit descriptors before setting the doorbell
Date: Thu, 27 Aug 2015 15:41:05 +0300
Message-ID: <1440679266-13218-15-git-send-email-ygardi@codeaurora.org>
References: <1440679266-13218-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440679266-13218-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Add a write memory barrier to make sure descriptors prepared are actually
written to memory before ringing the doorbell. We have also added the
write memory barrier after ringing the doorbell register so that
controller sees the new request immediately.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 298511a..024cc86 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -833,6 +833,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	/* Make sure that doorbell is committed immediately */
+	wmb();
 }
 
 /**
@@ -1418,6 +1420,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto out;
 	}
 
+	/* Make sure descriptors are ready before ringing the doorbell */
+	wmb();
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_send_command(hba, tag);
@@ -1627,6 +1631,8 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 
 	hba->dev_cmd.complete = &wait;
 
+	/* Make sure descriptors are ready before ringing the doorbell */
+	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
