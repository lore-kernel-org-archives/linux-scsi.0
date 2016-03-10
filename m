From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v8 09/17] scsi: ufs: add error recovery after DL NAC error
Date: Thu, 10 Mar 2016 17:37:13 +0200
Message-ID: <1457624241-20525-10-git-send-email-ygardi@codeaurora.org>
References: <1457624241-20525-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457624241-20525-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Some vendor's UFS device sends back to back NACs for the DL data frames
causing the host controller to raise the DFES error status. Sometimes
such UFS devices send back to back NAC without waiting for new
retransmitted DL frame from the host and in such cases it might be
possible the Host UniPro goes into bad state without raising the DFES
error interrupt. If this happens then all the pending commands would
timeout only after respective SW command (which is generally too
large).

This change workarounds such device behaviour like this:
- As soon as SW sees the DL NAC error, it would schedule the error
  handler
- Error handler would sleep for 50ms to see if there any fatal errors
  raised by UFS controller.
   - If there are fatal errors then SW does normal error recovery.
   - If there are no fatal errors then SW sends the NOP command to
     device to check if link is alive.
       - If NOP command times out, SW does normal error recovery
       - If NOP command succeed, skip the error handling.

If DL NAC error is seen multiple times with some vendor's UFS devices
then enable this quirk to initiate quick error recovery and also
silence related error logs to reduce spamming of kernel logs.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshci.h |  2 +
 2 files changed, 95 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index adaae34..4eedb7f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3795,6 +3795,79 @@ static void ufshcd_complete_requests(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_quirk_dl_nac_errors - This function checks if error handling is
+ *				to recover from the DL NAC errors or not.
+ * @hba: per-adapter instance
+ *
+ * Returns true if error handling is required, false otherwise
+ */
+static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
+{
+	unsigned long flags;
+	bool err_handling = true;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	/*
+	 * UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS only workaround the
+	 * device fatal error and/or DL NAC & REPLAY timeout errors.
+	 */
+	if (hba->saved_err & (CONTROLLER_FATAL_ERROR | SYSTEM_BUS_FATAL_ERROR))
+		goto out;
+
+	if ((hba->saved_err & DEVICE_FATAL_ERROR) ||
+	    ((hba->saved_err & UIC_ERROR) &&
+	     (hba->saved_uic_err & UFSHCD_UIC_DL_TCx_REPLAY_ERROR)))
+		goto out;
+
+	if ((hba->saved_err & UIC_ERROR) &&
+	    (hba->saved_uic_err & UFSHCD_UIC_DL_NAC_RECEIVED_ERROR)) {
+		int err;
+		/*
+		 * wait for 50ms to see if we can get any other errors or not.
+		 */
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		msleep(50);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+
+		/*
+		 * now check if we have got any other severe errors other than
+		 * DL NAC error?
+		 */
+		if ((hba->saved_err & INT_FATAL_ERRORS) ||
+		    ((hba->saved_err & UIC_ERROR) &&
+		    (hba->saved_uic_err & ~UFSHCD_UIC_DL_NAC_RECEIVED_ERROR)))
+			goto out;
+
+		/*
+		 * As DL NAC is the only error received so far, send out NOP
+		 * command to confirm if link is still active or not.
+		 *   - If we don't get any response then do error recovery.
+		 *   - If we get response then clear the DL NAC error bit.
+		 */
+
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		err = ufshcd_verify_dev_init(hba);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+
+		if (err)
+			goto out;
+
+		/* Link seems to be alive hence ignore the DL NAC errors */
+		if (hba->saved_uic_err == UFSHCD_UIC_DL_NAC_RECEIVED_ERROR)
+			hba->saved_err &= ~UIC_ERROR;
+		/* clear NAC error */
+		hba->saved_uic_err &= ~UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
+		if (!hba->saved_uic_err) {
+			err_handling = false;
+			goto out;
+		}
+	}
+out:
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	return err_handling;
+}
+
+/**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
  * @work: pointer to work structure
  */
@@ -3822,6 +3895,17 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
+
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+		bool ret;
+
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		/* release the lock as ufshcd_quirk_dl_nac_errors() may sleep */
+		ret = ufshcd_quirk_dl_nac_errors(hba);
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		if (!ret)
+			goto skip_err_handling;
+	}
 	if ((hba->saved_err & INT_FATAL_ERRORS) ||
 	    ((hba->saved_err & UIC_ERROR) &&
 	    (hba->saved_uic_err & (UFSHCD_UIC_DL_PA_INIT_ERROR |
@@ -3897,6 +3981,7 @@ skip_pending_xfer_clear:
 		hba->saved_uic_err = 0;
 	}
 
+skip_err_handling:
 	if (!needs_reset) {
 		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 		if (hba->saved_err || hba->saved_uic_err)
@@ -3925,6 +4010,14 @@ static void ufshcd_update_uic_error(struct ufs_hba *hba)
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
 	if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
 		hba->uic_error |= UFSHCD_UIC_DL_PA_INIT_ERROR;
+	else if (hba->dev_quirks &
+		   UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS) {
+		if (reg & UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED)
+			hba->uic_error |=
+				UFSHCD_UIC_DL_NAC_RECEIVED_ERROR;
+		else if (reg & UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT)
+			hba->uic_error |= UFSHCD_UIC_DL_TCx_REPLAY_ERROR;
+	}
 
 	/* UIC NL/TL/DME errors needs software retry */
 	reg = ufshcd_readl(hba, REG_UIC_ERROR_CODE_NETWORK_LAYER);
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 0ae0967..2b05bfb 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -170,6 +170,8 @@ enum {
 #define UIC_DATA_LINK_LAYER_ERROR		UFS_BIT(31)
 #define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK	0x7FFF
 #define UIC_DATA_LINK_LAYER_ERROR_PA_INIT	0x2000
+#define UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED	0x0001
+#define UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT 0x0002
 
 /* UECN - Host UIC Error Code Network Layer 40h */
 #define UIC_NETWORK_LAYER_ERROR			UFS_BIT(31)
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
