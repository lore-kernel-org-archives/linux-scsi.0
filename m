From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1] scsi: ufs: fix arguments order some trace calls
Date: Tue, 10 Jan 2017 16:48:25 -0800
Message-ID: <1484095705-3962-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50922 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756874AbdAKAsh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 19:48:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, colin.king@canonical.com, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

Colin Ian King <colin.king@canonical.com> reported that with
commit 7ff5ab473633 ("scsi: ufs: add tracing support") static analysis
is reporting that we may have swapped arguments on calls to:
    trace_ufshcd_runtime_resume,
    trace_ufshcd_runtime_suspend,
    trace_ufshcd_system_suspend,
    trace_ufshcd_system_resume,
and trace_ufshcd_init

Where:
    hba->uic_link_state is passed to dev_state
    hba->curr_dev_pwr_mode is passed to link_state

This wasn't intentional so it's a bug. This change fixed this bug.

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index be6322e..6b56eb0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5805,7 +5805,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 	trace_ufshcd_init(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
-		hba->uic_link_state, hba->curr_dev_pwr_mode);
+		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	return ret;
 }
 
@@ -6819,7 +6819,7 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 out:
 	trace_ufshcd_system_suspend(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
-		hba->uic_link_state, hba->curr_dev_pwr_mode);
+		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
 		hba->is_sys_suspended = true;
 	return ret;
@@ -6852,7 +6852,7 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 out:
 	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
-		hba->uic_link_state, hba->curr_dev_pwr_mode);
+		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
@@ -6880,7 +6880,7 @@ int ufshcd_runtime_suspend(struct ufs_hba *hba)
 out:
 	trace_ufshcd_runtime_suspend(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
-		hba->uic_link_state, hba->curr_dev_pwr_mode);
+		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_suspend);
@@ -6921,7 +6921,7 @@ int ufshcd_runtime_resume(struct ufs_hba *hba)
 out:
 	trace_ufshcd_runtime_resume(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
-		hba->uic_link_state, hba->curr_dev_pwr_mode);
+		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_runtime_resume);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

