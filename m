From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 3/7] megaraid_sas : Do not process IOCTLs and SCSI
 commands during driver removal
Date: Mon, 10 Nov 2014 17:51:24 +0530
Message-ID: <201411101224.sAACOmvj018047@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0057.outbound.protection.outlook.com ([157.56.111.57]:37127
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752353AbaKJM40 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 07:56:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

Do not process any SCSI and IOCTL command further(return them with appropriate return values to callers),
while driver removal is in progress/PCI shutdown is invoked. 

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index f6a69a3..7754eeb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1572,6 +1572,12 @@ megasas_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
 
+	if (instance->unload == 1) {
+		scmd->result = DID_NO_CONNECT << 16;
+		scmd->scsi_done(scmd);
+		return 0;
+	}
+
 	if (instance->issuepend_done == 0)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
@@ -4957,10 +4963,6 @@ static int megasas_io_attach(struct megasas_instance *instance)
 		return -ENODEV;
 	}
 
-	/*
-	 * Trigger SCSI to scan our drives
-	 */
-	scsi_scan_host(host);
 	return 0;
 }
 
@@ -5288,6 +5290,10 @@ retry_irq_register:
 		goto fail_io_attach;
 
 	instance->unload = 0;
+	/*
+	 * Trigger SCSI to scan our drives
+	 */
+	scsi_scan_host(host);
 
 	/*
 	 * Initiate AEN (Asynchronous Event Notification)
@@ -6051,6 +6057,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 	megasas_issue_blocked_cmd(instance, cmd, 0);
 	cmd->sync_cmd = 0;
 
+	if (instance->unload == 1) {
+		dev_info(&instance->pdev->dev, "we are doing unload so no need"
+			"to submit data to application. This may be force exit"
+			"from driver\n");
+		goto out;
+	}
 	/*
 	 * copy out the kernel buffers to user buffers
 	 */
-- 
1.7.1

