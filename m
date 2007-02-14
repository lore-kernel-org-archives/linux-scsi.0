From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH 1/6] scsi: megaraid_sas - donot process cmds if
	hw_crit_error is set
Date: Wed, 14 Feb 2007 12:34:46 -0800
Message-ID: <1171485286.4188.6.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48305 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbXBOBoT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Feb 2007 20:44:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com


Checks if hw_crit_error is set.
If it is set, we donot process commands.
Checks added in megasas_queue_command and command completion routines.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

 drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletion(-)

diff -uprN linux-feb13-orig/drivers/scsi/megaraid/megaraid_sas.c linux-feb13-new-p1/drivers/scsi/megaraid/megaraid_sas.c
--- linux-feb13-orig/drivers/scsi/megaraid/megaraid_sas.c	2007-02-13 06:44:46.000000000 -0800
+++ linux-feb13-new-p1/drivers/scsi/megaraid/megaraid_sas.c	2007-02-13 07:18:39.000000000 -0800
@@ -841,6 +841,11 @@ megasas_queue_command(struct scsi_cmnd *
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
+
+	/* Don't process if we have already declared adapter dead */
+	if (instance->hw_crit_error)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	scmd->scsi_done = done;
 	scmd->result = 0;
 
@@ -1282,11 +1287,13 @@ megasas_deplete_reply_queue(struct megas
 	if(instance->instancet->clear_intr(instance->reg_set))
 		return IRQ_NONE;
 
+	if (instance->hw_crit_error)
+		goto out_done;
         /*
 	 * Schedule the tasklet for cmd completion
 	 */
 	tasklet_schedule(&instance->isr_tasklet);
-
+out_done:
 	return IRQ_HANDLED;
 }
 
@@ -1741,6 +1748,10 @@ static void megasas_complete_cmd_dpc(uns
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance = (struct megasas_instance *)instance_addr;
 
+	/* If we have already declared adapter dead, donot complete cmds */
+	if (instance->hw_crit_error)
+		return;
+
 	producer = *instance->producer;
 	consumer = *instance->consumer;
 


