From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 07/19] aacraid: Log count info of scsi cmds before reset
Date: Sun, 7 May 2017 04:26:52 -0700
Message-ID: <20170507112704.21940-8-RaghavaAditya.Renukunta@microsemi.com>
References: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0078.outbound.protection.outlook.com ([104.47.41.78]:46016
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754438AbdEGVkX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:40:23 -0400
In-Reply-To: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

Log the location of the scsi cmds before triggering a reset. This
information is useful for debugging.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/linit.c | 90 ++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index f6a11af..0a8d303 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -624,6 +624,56 @@ static int aac_ioctl(struct scsi_device *sdev, int cmd, void __user * arg)
 	return aac_do_ioctl(dev, cmd, arg);
 }
 
+static int get_num_of_incomplete_fibs(struct aac_dev *aac)
+{
+
+	unsigned long flags;
+	struct scsi_device *sdev = NULL;
+	struct Scsi_Host *shost = aac->scsi_host_ptr;
+	struct scsi_cmnd *scmnd = NULL;
+	struct device *ctrl_dev;
+
+	int mlcnt  = 0;
+	int llcnt  = 0;
+	int ehcnt  = 0;
+	int fwcnt  = 0;
+	int krlcnt = 0;
+
+	__shost_for_each_device(sdev, shost) {
+		spin_lock_irqsave(&sdev->list_lock, flags);
+		list_for_each_entry(scmnd, &sdev->cmd_list, list) {
+			switch (scmnd->SCp.phase) {
+			case AAC_OWNER_FIRMWARE:
+				fwcnt++;
+				break;
+			case AAC_OWNER_ERROR_HANDLER:
+				ehcnt++;
+				break;
+			case AAC_OWNER_LOWLEVEL:
+				llcnt++;
+				break;
+			case AAC_OWNER_MIDLEVEL:
+				mlcnt++;
+				break;
+			default:
+				krlcnt++;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&sdev->list_lock, flags);
+	}
+
+	ctrl_dev = &aac->pdev->dev;
+
+	dev_info(ctrl_dev, "outstanding cmd: midlevel-%d\n", mlcnt);
+	dev_info(ctrl_dev, "outstanding cmd: lowlevel-%d\n", llcnt);
+	dev_info(ctrl_dev, "outstanding cmd: error handler-%d\n", ehcnt);
+	dev_info(ctrl_dev, "outstanding cmd: firmware-%d\n", fwcnt);
+	dev_info(ctrl_dev, "outstanding cmd: kernel-%d\n", krlcnt);
+
+	return mlcnt + llcnt + ehcnt + fwcnt;
+}
+
 static int aac_eh_abort(struct scsi_cmnd* cmd)
 {
 	struct scsi_device * dev = cmd->device;
@@ -853,8 +903,6 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 			pr_err("%s: Host adapter reset request timed out\n",
 			AAC_DRIVERNAME);
 	} else {
-		struct scsi_cmnd *command;
-		unsigned long flags;
 
 		/* Mark the assoc. FIB to not complete, eh handler does this */
 		for (count = 0;
@@ -873,41 +921,9 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 		pr_err("%s: Host adapter reset request. SCSI hang ?\n",
 					AAC_DRIVERNAME);
 
-		count = aac_check_health(aac);
-		if (count)
-			return count;
-		/*
-		 * Wait for all commands to complete to this specific
-		 * target (block maximum 60 seconds).
-		 */
-		for (count = 60; count; --count) {
-			int active = aac->in_reset;
-
-			if (active == 0)
-			__shost_for_each_device(dev, host) {
-				spin_lock_irqsave(&dev->list_lock, flags);
-				list_for_each_entry(command, &dev->cmd_list,
-					list) {
-					if ((command != cmd) &&
-					(command->SCp.phase ==
-					AAC_OWNER_FIRMWARE)) {
-						active++;
-						break;
-					}
-				}
-				spin_unlock_irqrestore(&dev->list_lock, flags);
-				if (active)
-					break;
-
-			}
-			/*
-			 * We can exit If all the commands are complete
-			 */
-			if (active == 0)
-				return SUCCESS;
-			ssleep(1);
-		}
-		pr_err("%s: SCSI bus appears hung\n", AAC_DRIVERNAME);
+		count = get_num_of_incomplete_fibs(aac);
+		if (count == 0)
+			return SUCCESS;
 
 		/*
 		 * This adapter needs a blind reset, only do so for
-- 
2.7.4
