From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH 3/6] scsi: megaraid_sas - throttle io if FW is busy
Date: Wed, 14 Feb 2007 12:49:54 -0800
Message-ID: <1171486194.4188.21.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48629 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964817AbXBOB76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Feb 2007 20:59:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com


Checks added in megasas_queue_command to know if FW is able to process
commands within the timeout period. If number of retries is 2 or more,
the driver stops sending cmd to FW. IO is resumed when pending cmd count 
reduces to 16 or 10 seconds has elapsed from the time cmds were last 
sent to FW.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

 drivers/scsi/megaraid/megaraid_sas.c |   27 +++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h |    3 ++
 2 files changed, 30 insertions(+)

diff -uprN linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.c linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.c
--- linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.c	2007-02-13 11:34:58.000000000 -0800
+++ linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.c	2007-02-13 11:45:38.000000000 -0800
@@ -839,6 +839,7 @@ megasas_queue_command(struct scsi_cmnd *
 	u32 frame_count;
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance;
+	unsigned long sec;
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
@@ -856,6 +857,23 @@ megasas_queue_command(struct scsi_cmnd *
 		goto out_done;
 	}
 
+	/* Check if we can accept cmds */
+	if (instance->is_busy) {
+		sec = (jiffies - instance->last_time) / HZ;
+		if (sec < 10)
+			return SCSI_MLQUEUE_HOST_BUSY;
+		else {
+			instance->is_busy = 0;
+			instance->last_time = 0;
+		}
+	}
+
+	if (scmd->retries > 1) {
+		/* FW is busy */
+		instance->is_busy = 1;
+		instance->last_time = jiffies;
+	}
+
 	cmd = megasas_get_cmd(instance);
 	if (!cmd)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1200,6 +1218,7 @@ megasas_complete_cmd(struct megasas_inst
 {
 	int exception = 0;
 	struct megasas_header *hdr = &cmd->frame->hdr;
+	int outstanding;
 
 	if (cmd->scmd) {
 		cmd->scmd->SCp.ptr = (char *)0;
@@ -1313,6 +1332,12 @@ megasas_complete_cmd(struct megasas_inst
 		       hdr->cmd);
 		break;
 	}
+
+	if (instance->is_busy) {
+		outstanding = atomic_read(&instance->fw_outstanding);
+		if (outstanding < 17)
+			instance->is_busy = 0;
+	}
 }
 
 /**
@@ -2384,6 +2409,8 @@ megasas_probe_one(struct pci_dev *pdev, 
 	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
 
 	megasas_dbg_lvl = 0;
+	instance->is_busy = 0;
+	instance->last_time = 0;
 
 	/*
 	 * Initialize MFI Firmware
diff -uprN linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.h linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.h
--- linux-feb13-new-p2/drivers/scsi/megaraid/megaraid_sas.h	2007-02-13 07:22:40.000000000 -0800
+++ linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.h	2007-02-13 11:37:09.000000000 -0800
@@ -1102,6 +1102,9 @@ struct megasas_instance {
 	atomic_t fw_outstanding;
 	u32 hw_crit_error;
 
+	u8 is_busy;
+	unsigned long last_time;
+
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
 };



