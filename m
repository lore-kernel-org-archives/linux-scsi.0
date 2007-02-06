From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH 1/5] scsi: megaraid_sas - stop cmd processing if
	hw_crit_error is set
Date: Tue, 06 Feb 2007 13:49:24 -0800
Message-ID: <1170798564.10482.12.camel@dumbo>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-BSYsRICM/XY08vZcLaRC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34014 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965632AbXBGC7Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Feb 2007 21:59:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com


--=-BSYsRICM/XY08vZcLaRC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Checks if hw_crit_error is set before processing cmds.
Added in megasas_queue_command and command completion routines.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---
drivers/scsi/megaraid/megaraid_sas.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletion(-)

diff -uprN 2.6.orig/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p1/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2007-02-05 09:51:01.000000000 -0800
+++ 2.6.new-p1/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 06:54:07.000000000 -0800
@@ -841,6 +841,11 @@ megasas_queue_command(struct scsi_cmnd *
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
+
+	/* Don't process if we have already declared adapter dead */
+	if(instance->hw_crit_error)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	scmd->scsi_done = done;
 	scmd->result = 0;
 
@@ -1282,11 +1287,13 @@ megasas_deplete_reply_queue(struct megas
 	if(instance->instancet->clear_intr(instance->reg_set))
 		return IRQ_NONE;
 
+	if(instance->hw_crit_error)
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
+	if(instance->hw_crit_error)
+		return;
+
 	producer = *instance->producer;
 	consumer = *instance->consumer;
 



--=-BSYsRICM/XY08vZcLaRC
Content-Description: 
Content-Disposition: inline; filename=p1-crit_err.patch
Content-Type: text/x-patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -uprN 2.6.orig/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p1/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2007-02-05 09:51:01.000000000 -0800
+++ 2.6.new-p1/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 06:54:07.000000000 -0800
@@ -841,6 +841,11 @@ megasas_queue_command(struct scsi_cmnd *
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
+
+	/* Don't process if we have already declared adapter dead */
+	if(instance->hw_crit_error)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	scmd->scsi_done = done;
 	scmd->result = 0;
 
@@ -1282,11 +1287,13 @@ megasas_deplete_reply_queue(struct megas
 	if(instance->instancet->clear_intr(instance->reg_set))
 		return IRQ_NONE;
 
+	if(instance->hw_crit_error)
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
+	if(instance->hw_crit_error)
+		return;
+
 	producer = *instance->producer;
 	consumer = *instance->consumer;
 

--=-BSYsRICM/XY08vZcLaRC--

