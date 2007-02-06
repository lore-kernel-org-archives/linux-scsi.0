From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH 3/5] scsi: megaraid_sas - throttle io if FW is busy
Date: Tue, 06 Feb 2007 14:11:04 -0800
Message-ID: <1170799864.10482.32.camel@dumbo>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-/B20HC/b/JmRnXFgG7sp"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34401 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965329AbXBGDU6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Feb 2007 22:20:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com


--=-/B20HC/b/JmRnXFgG7sp
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Checks added in megasas_queue_command to know if FW is able to process
commands within timeout period. If number of retries is 2 or greater,
the driver stops sending cmd to FW. IO is resumed if pending cmd count
reduces to 16 or 5 seconds has elapsed from the time cmds were last sent
to FW.

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

 drivers/scsi/megaraid/megaraid_sas.c |   27 +++++++++++++++++++++++++
 drivers/scsi/megaraid/megaraid_sas.h |    3 ++
 2 files changed, 30 insertions(+)

diff -uprN 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 08:43:40.000000000 -0800
+++ 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 08:50:40.000000000 -0800
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
 
+	/* Check if we can process cmds */
+	if(instance->is_busy){
+		sec = (jiffies - instance->last_time) / HZ;
+		if(sec<5)
+			return SCSI_MLQUEUE_HOST_BUSY;
+		else{
+			instance->is_busy=0;
+			instance->last_time=0;
+		}
+	}
+
+	if(scmd->retries>1){
+		/* FW is busy */
+		instance->is_busy=1;
+		instance->last_time=jiffies;
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
+	if(instance->is_busy){
+		outstanding = atomic_read(&instance->fw_outstanding);
+		if(outstanding<17)
+			instance->is_busy=0;
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
diff -uprN 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.h 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.h
--- 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 06:56:27.000000000 -0800
+++ 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 08:51:23.000000000 -0800
@@ -1102,6 +1102,9 @@ struct megasas_instance {
 	atomic_t fw_outstanding;
 	u32 hw_crit_error;
 
+	u8 is_busy;
+	unsigned long last_time;
+
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
 };


--=-/B20HC/b/JmRnXFgG7sp
Content-Disposition: attachment; filename=p3-throttle-io.patch
Content-Type: text/x-patch; name=p3-throttle-io.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -uprN 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.c 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c
--- 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 08:43:40.000000000 -0800
+++ 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.c	2007-02-06 08:50:40.000000000 -0800
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
 
+	/* Check if we can process cmds */
+	if(instance->is_busy){
+		sec = (jiffies - instance->last_time) / HZ;
+		if(sec<5)
+			return SCSI_MLQUEUE_HOST_BUSY;
+		else{
+			instance->is_busy=0;
+			instance->last_time=0;
+		}
+	}
+
+	if(scmd->retries>1){
+		/* FW is busy */
+		instance->is_busy=1;
+		instance->last_time=jiffies;
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
+	if(instance->is_busy){
+		outstanding = atomic_read(&instance->fw_outstanding);
+		if(outstanding<17)
+			instance->is_busy=0;
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
diff -uprN 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.h 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.h
--- 2.6.new-p2/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 06:56:27.000000000 -0800
+++ 2.6.new-p3/drivers/scsi/megaraid/megaraid_sas.h	2007-02-06 08:51:23.000000000 -0800
@@ -1102,6 +1102,9 @@ struct megasas_instance {
 	atomic_t fw_outstanding;
 	u32 hw_crit_error;
 
+	u8 is_busy;
+	unsigned long last_time;
+
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
 };

--=-/B20HC/b/JmRnXFgG7sp--

