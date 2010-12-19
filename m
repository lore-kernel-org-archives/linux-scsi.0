From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 10/12] megaraid_sas: Add smp_mb__after_atomic_*() for instance->fw_outstanding
Date: Sun, 19 Dec 2010 13:22:05 -0800
Message-ID: <1292793727-31957-11-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

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
index 7451bc0..31c5419 100644
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
1.7.3.4
