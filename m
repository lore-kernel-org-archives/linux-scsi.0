From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] megaraid_sas: Add smp_mb__after_atomic_*() for instance->fw_outstanding
Date: Sat, 27 Nov 2010 23:17:34 -0800
Message-ID: <1290928656-31116-2-git-send-email-nab@linux-iscsi.org>
References: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm22-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.222]:33247 "HELO
	nm22-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751538Ab0K1HYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Nov 2010 02:24:45 -0500
In-Reply-To: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Bo Yang <Bo.Yang@lsi.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds four missing smp_mb__after_atomic_[inc,dec] barriers
for atomic_inc() and atomic_dec() usage with instance->fw_outstanding
within the main I/O dispatcher megasas_queue_command_lck(), completion
callback megasas_complete_cmd() and struct megasas_instance HW reset
queue drain in megasas_issue_pending_cmds_again().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/megaraid/megaraid_sas.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 7451bc0..c103554 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1398,6 +1398,7 @@ megasas_queue_command_lck(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd
 	 * Issue the command to the FW
 	 */
 	atomic_inc(&instance->fw_outstanding);
+	smp_mb__after_atomic_inc();	
 
 	instance->instancet->fire_cmd(instance, cmd->frame_phys_addr,
 				cmd->frame_count-1, instance->reg_set);
@@ -2068,6 +2069,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		if (exception) {
 
 			atomic_dec(&instance->fw_outstanding);
+			smp_mb__after_atomic_dec();
 
 			scsi_dma_unmap(cmd->scmd);
 			cmd->scmd->scsi_done(cmd->scmd);
@@ -2116,6 +2118,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 		}
 
 		atomic_dec(&instance->fw_outstanding);
+		smp_mb__after_atomic_dec();
 
 		scsi_dma_unmap(cmd->scmd);
 		cmd->scmd->scsi_done(cmd->scmd);
@@ -2219,6 +2222,7 @@ megasas_issue_pending_cmds_again(struct megasas_instance *instance)
 			cmd, cmd->scmd->cmnd[0], cmd->scmd->serial_number);
 
 			atomic_inc(&instance->fw_outstanding);
+			smp_mb__after_atomic_inc();
 			instance->instancet->fire_cmd(instance,
 					cmd->frame_phys_addr,
 					cmd->frame_count-1, instance->reg_set);
-- 
1.7.2.3

