From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 05/15] be2iscsi: Set mbox timeout to 30s
Date: Tue, 15 Dec 2015 21:24:56 +0530
Message-ID: <1450194906-12925-6-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:63987 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754028AbbLOPzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 10:55:24 -0500
In-Reply-To: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

FW recommended timeout for all mbox command is 30s.
Use msleep instead mdelay to relinquish CPU when polling for
mbox completion.

Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 6f58063..1e70053 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -587,7 +587,8 @@ int be_mcc_notify_wait(struct beiscsi_hba *phba)
  **/
 static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
 {
-#define BEISCSI_MBX_RDY_BIT_TIMEOUT	12000	/* 12sec */
+	/* wait 30s for generic non-flash MBOX operation */
+#define BEISCSI_MBX_RDY_BIT_TIMEOUT	30000
 	void __iomem *db = ctrl->db + MPU_MAILBOX_DB_OFFSET;
 	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 	unsigned long timeout;
@@ -612,7 +613,7 @@ static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
 
 		if (time_after(jiffies, timeout))
 			break;
-		mdelay(1);
+		msleep(20);
 	} while (!ready);
 
 	beiscsi_log(phba, KERN_ERR,
-- 
1.7.1

