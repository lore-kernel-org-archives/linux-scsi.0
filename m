From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 06/15] scsi: ufs: avoid exception event handler racing with PM callbacks
Date: Tue, 27 Oct 2015 12:44:08 +0200
Message-ID: <1445942657-6293-7-git-send-email-ygardi@codeaurora.org>
References: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

If device raises the exception event in the response to the commands
sent during the runtime/system PM callbacks, exception event handler
might run in parallel with PM callbacks and may see unclocked register
accesses. This change fixes this issue by not scheduling the exception
event handler while PM callbacks are running.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 573a8cb..0e54183 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3145,7 +3145,20 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			scsi_status = result & MASK_SCSI_STATUS;
 			result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
 
-			if (ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
+			/*
+			 * Currently we are only supporting BKOPs exception
+			 * events hence we can ignore BKOPs exception event
+			 * during power management callbacks. BKOPs exception
+			 * event is not expected to be raised in runtime suspend
+			 * callback as it allows the urgent bkops.
+			 * During system suspend, we are anyway forcefully
+			 * disabling the bkops and if urgent bkops is needed
+			 * it will be enabled on system resume. Long term
+			 * solution could be to abort the system suspend if
+			 * UFS device needs urgent BKOPs.
+			 */
+			if (!hba->pm_op_in_progress &&
+			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
 				schedule_work(&hba->eeh_work);
 			break;
 		case UPIU_TRANSACTION_REJECT_UPIU:
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
