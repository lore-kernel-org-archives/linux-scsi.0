From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 6/7] megaraid_sas : Corrected return of wait_event
 from abort frame path
Date: Mon, 17 Nov 2014 15:24:23 +0530
Message-ID: <201411170958.sAH9w4GU008976@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0055.outbound.protection.outlook.com ([157.56.111.55]:7760
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752353AbaKQJyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 04:54:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

Corrected wait_event() call which was waiting for wrong completion status(0xFF).

Cc: <stable@vger.kernel.org>

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8262067..f11c5f3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1007,7 +1007,7 @@ megasas_issue_blocked_abort_cmd(struct megasas_instance *instance,
 		cpu_to_le32(upper_32_bits(cmd_to_abort->frame_phys_addr));
 
 	cmd->sync_cmd = 1;
-	cmd->cmd_status = 0xFF;
+	cmd->cmd_status = ENODATA;
 
 	instance->instancet->issue_dcmd(instance, cmd);
 
-- 
1.7.1

