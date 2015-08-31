From: sumit.saxena@avagotech.com
Subject: [PATCH v3 02/10] megaraid_sas : Increase timeout to 60 secs for
 abort frames during shutdown
Date: Mon, 31 Aug 2015 17:23:01 +0530
Message-ID: <201508311158.t7VBwUSJ031378@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bastion.smtp.avagotech.com ([202.86.248.61]:41189 "EHLO
	sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbHaLyA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 07:54:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Martin Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index eaa81e5..1bcb59a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5506,10 +5506,10 @@ static void megasas_shutdown_controller(struct megasas_instance *instance,
 
 	if (instance->aen_cmd)
 		megasas_issue_blocked_abort_cmd(instance,
-			instance->aen_cmd, 30);
+			instance->aen_cmd, MEGASAS_BLOCKED_CMD_TIMEOUT);
 	if (instance->map_update_cmd)
 		megasas_issue_blocked_abort_cmd(instance,
-			instance->map_update_cmd, 30);
+			instance->map_update_cmd, MEGASAS_BLOCKED_CMD_TIMEOUT);
 	dcmd = &cmd->frame->dcmd;
 
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
-- 
1.7.1

