From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v3 05/17] be2iscsi: Set mbox timeout to 30s
Date: Wed, 23 Dec 2015 14:04:24 +0530
Message-ID: <1450859676-22025-6-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55529 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933710AbbLWIex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Dec 2015 03:34:53 -0500
In-Reply-To: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

FW recommended timeout for all mbox command is 30s.
Use msleep instead mdelay to relinquish CPU when polling for
mbox completion.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 502c9b6..034b868 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -590,7 +590,8 @@ int be_mcc_notify_wait(struct beiscsi_hba *phba, unsigned int tag)
  **/
 static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
 {
-#define BEISCSI_MBX_RDY_BIT_TIMEOUT	12000	/* 12sec */
+	/* wait 30s for generic non-flash MBOX operation */
+#define BEISCSI_MBX_RDY_BIT_TIMEOUT	30000
 	void __iomem *db = ctrl->db + MPU_MAILBOX_DB_OFFSET;
 	struct beiscsi_hba *phba = pci_get_drvdata(ctrl->pdev);
 	unsigned long timeout;
@@ -615,7 +616,7 @@ static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
 
 		if (time_after(jiffies, timeout))
 			break;
-		mdelay(1);
+		msleep(20);
 	} while (!ready);
 
 	beiscsi_log(phba, KERN_ERR,
-- 
1.9.1

